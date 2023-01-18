# 获取 Latest GitHub Releases 名称 & 资源地址
name=$(cat "latest.txt" | jq -r ".name")
cat "latest.txt" | jq -r ".zipball_url" > d.txt
# 获取的 target_commitish 前1-7个字符
targetcommitish=$(cat "latest.txt" | jq -r ".target_commitish" | cut -c1-7)
# 下载资源
wget --no-dns-cache --random-wait --continue -d -T 60 -t 30 -O latest.zip -i "d.txt"
# 解压
unzip -q latest.zip
ls
# 跳转
cd ./CFPAOrg-Minecraft-Mod-Language-Package-${targetcommitish}
cd ./projects
######################################################
###################### 1.12.2
cd ./1.12.2
cd ./assets
tree -t -h -N -D -H 1.12.2 > 1.12.2.html
mv *.html ../
cd ../
mv *.html ../
cd ../
###################### 1.16
cd ./1.16
cd ./assets
tree -t -h -N -D -H 1.16-${name} > 1.16.html
mv *.html ../
cd ../
mv *.html ../
cd ../
###################### 1.16-fabric
cd ./1.16-fabric
cd ./assets
tree -t -h -N -D -H 1.16-fabric-${name} > 1.16-fabric.html
mv *.html ../
cd ../
mv *.html ../
cd ../
###################### 1.18
cd ./1.18
cd ./assets
tree -t -h -N -D -H 1.18-${name} > 1.18.html
mv *.html ../
cd ../
mv *.html ../
cd ../
###################### 1.18-fabric
cd ./1.18-fabric
cd ./assets
tree -t -h -N -D -H 1.18-fabric-${name} > 1.18-fabric.html
mv *.html ../
cd ../
mv *.html ../
cd ../
###################### 1.19
cd ./1.19
cd ./assets
tree -t -h -N -D -H 1.19-${name} > 1.19.html
mv *.html ../
cd ../
mv *.html ../
cd ../
######################################################
# 文件传到上上一层
mv *.html ../
cd ../
mv *.html ../
cd ../
# 删除文件
rm -r ./CFPAOrg-Minecraft-Mod-Language-Package-${target_commitish}
rm latest.zip