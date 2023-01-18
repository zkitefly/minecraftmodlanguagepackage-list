# 获取的 target_commitish 前1-7个字符 & 删除文件夹
targetcommitish=$(cat "latest.txt" | jq -r ".target_commitish" | cut -c1-7)
rm -r ./CFPAOrg-Minecraft-Mod-Language-Package-${targetcommitish}
# 获取 Latest GitHub Releases 名称 & 资源地址
name=$(cat "latest.txt" | jq -r ".name")
cat "latest.txt" | jq -r ".zipball_url" > d.txt
# 获取的 target_commitish 前1-7个字符
targetcommitish=$(cat "latest.txt" | jq -r ".target_commitish" | cut -c1-7)
# 下载资源
wget --no-dns-cache --random-wait --continue -d -T 60 -t 30 -O latest.zip -i "d.txt"
# 解压
unzip -q -o latest.zip
ls
# 跳转
cd ./CFPAOrg-Minecraft-Mod-Language-Package-${targetcommitish}
cd ./projects
######################################################
######################### 1.12.2-es
cd ./1.12.2
cd ./assets
tree -L 2 -H 000 1.12.2（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.12.2-es.html
mv *.html ../
cd ../
mv *.html ../
cd ../
#################### 1.12.2
cd ./1.12.2
cd ./assets
tree -H 000 1.12.2（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.12.2.html
mv *.html ../
cd ../
mv *.html ../
cd ../
######################### 1.16-es
cd ./1.16
cd ./assets
tree -L 2 -H 000 1.16（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.16-es.html
mv *.html ../
cd ../
mv *.html ../
cd ../
#################### 1.16
cd ./1.16
cd ./assets
tree -H 000 1.16（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.16.html
mv *.html ../
cd ../
mv *.html ../
cd ../
######################### 1.16-fabric-es
cd ./1.16-fabric
cd ./assets
tree -L 2 -H 000 1.16-fabric（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.16-fabric-es.html
mv *.html ../
cd ../
mv *.html ../
cd ../
#################### 1.16-fabric
cd ./1.16-fabric
cd ./assets
tree -H 000 1.16-fabric（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.16-fabric.html
mv *.html ../
cd ../
mv *.html ../
cd ../
######################### 1.18-es
cd ./1.18
cd ./assets
tree -L 2 -H 000 1.18（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.18-es.html
mv *.html ../
cd ../
mv *.html ../
cd ../
#################### 1.18
cd ./1.18
cd ./assets
tree -H 000 1.18（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.18.html
mv *.html ../
cd ../
mv *.html ../
cd ../
######################### 1.18-fabric-es
cd ./1.18-fabric
cd ./assets
tree -L 2 -H 000 1.18-fabric（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.18-fabric-es.html
mv *.html ../
cd ../
mv *.html ../
cd ../
#################### 1.18-fabric
cd ./1.18-fabric
cd ./assets
tree -H 000 1.18-fabric（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.18-fabric.html
mv *.html ../
cd ../
mv *.html ../
cd ../
######################### 1.19-es
cd ./1.19
cd ./assets
tree -L 2 -H 000 1.19（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.19-es.html
mv *.html ../
cd ../
mv *.html ../
cd ../
#################### 1.19
cd ./1.19
cd ./assets
tree -H 000 1.19（${name}_以下显示的是文件夹，里面的文件请前往详细列表） > 1.19.html
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
rm latest.zip