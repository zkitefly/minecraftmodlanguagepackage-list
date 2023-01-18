﻿using System.Collections.Generic;
using System.IO;
using System.Linq;

using Packer.Extensions;
using Packer.Models;
using Serilog;

namespace Packer
{
    static class Lib
    {
        /// <summary>
        /// 从主库中选出所需文本。
        /// </summary>
        /// <param name="config">所使用的配置</param>
        /// <param name="unprocessed">传出非文本处理的文件</param>
        /// <returns></returns>
        public static IEnumerable<Asset> RetrieveContent(Config config, out Dictionary<string, string> unprocessed)
        {
            // 注：仓库的文件结构如下：（仅考虑主要翻译文件）
            // projects/<version>/assets/<mod-name>/<asset-domain>/<namespace>/path/to/the/file
            // 其中，<version> 与 config.Version 一致
            // <mod-name> 是唯一的，但 <asset-domain> 和 <namespace> 都不是唯一的
            // 目标文件层级：
            // assets/<asset-domain>/<namespace>/path/to/the/file
            // 
            // 在目标层级以外的文件不支持处理，需要作为基础文件加入

            // 预备工作
            Log.Information("开始生成待打包的文件");
            var bypassed = new Dictionary<string, string>(); // 文件完整路径 -> 压缩包中的完整路径
            var result = new Dictionary<string, Asset>(); // domain -> 该domain对应的Asset对象
            var existingDomains = new Dictionary<string, string>(); // domain -> 模组名

            // 下面开始检索模组：
            // 以后可能会用更好看的linq语法写，但是现在就这样了
            var mods = new DirectoryInfo($"./projects/{config.Version}/assets")
                .EnumerateDirectories() // assets/ 的下级文件夹
                .Select(modDirectory => new Mod()
                {
                    modName = modDirectory.Name,
                    assets = modDirectory
                        .EnumerateDirectories() // <mod-name>/ 的下级文件夹
                        .Select(assetDirectory => new Asset()
                        {
                            domainName = assetDirectory.Name,
                            contents = assetDirectory
                                .EnumerateFiles("*", SearchOption.AllDirectories) // <asset-domain>/ 的下级文件
                                .Select(file =>
                                {
                                    // 这里开始真正的检索。被跳过的文本用 null 代替

                                    var prefixLength = assetDirectory.FullName.Length;
                                    var relativePath = file.FullName[(prefixLength + 1)..]; // 在asset-domain下的位置

                                    // 跳过英文文件
                                    if (relativePath.IsSkippedLang(config))
                                    {
                                        return null;
                                    }

                                    // 选出不经过处理路径的文件
                                    if (relativePath.NeedBypass(config))
                                    {
                                        Log.Information("跳过了标记为直接加入的命名空间：{0}", relativePath.Split('\\')[0]);
                                        bypassed.Add(file.FullName,
                                                     Path.Combine("assets",
                                                                  assetDirectory.Name,
                                                                  relativePath));
                                        return null;
                                    }

                                    // 处理正常的语言文件
                                    var parsingCategory = file.Extension switch
                                    {
                                        ".json" => FileCategory.JsonAlike,
                                        _ => FileCategory.LangAlike
                                    };
                                    if (relativePath.StartsWith("lang\\"))
                                    {
                                        return new LangFile(file.OpenRead(),
                                                            parsingCategory | FileCategory.LanguageFile,
                                                            config)
                                        {
                                            relativePath = relativePath
                                        };
                                    }
                                    else
                                    {
                                        return new TranslatedFile(file.OpenRead(),
                                                                  parsingCategory | FileCategory.OtherFiles,
                                                                  config)
                                        {
                                            relativePath = relativePath
                                        };
                                    }
                                }).Where(_ => _ is not null) // 排除掉跳过的文件
                        })
                });

            foreach (var mod in mods)
            {
                var name = mod.modName;
                if (!mod.assets.Any()) continue; // 没有 asset 的情况
                foreach (var asset in mod.assets)
                {
                    var domain = asset.domainName;
                    if (config.ModBlackList.Contains(name))
                    {
                        Log.Information("跳过了黑名单中的 mod：{0}（asset-domain：{1}）", name, domain);
                        continue;
                    }
                    if (config.DomainBlackList.Contains(domain))
                    {
                        Log.Information("跳过了黑名单中的 asset-domain：{0}（对应 mod：{1}）", domain, name);
                        continue;
                    }
                    Log.Information("正在处理 {0}（asset-domain：{1}）", name, domain);

                    if (!existingDomains.ContainsKey(domain))
                    {
                        Log.Information("未检测到重合。直接加入");
                        result.Add(domain, asset);
                        Log.Information("向 asset-domain 映射表中加入：{0} -> {1}", domain, name);
                        existingDomains.Add(domain, name);
                    }
                    else
                    {
                        Log.Warning("检测到 asset-domain 与 {0} 重合", existingDomains[domain]);
                        result.Remove(domain, out var existing);
                        result.Add(domain, existing.Combine(asset));
                    }
                }
            }
            unprocessed = bypassed; // 传出非文本文件
            Log.Information("文件列表生成完毕");
            return result.Select(_ => _.Value);
        }
    }
}
