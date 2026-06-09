#!/bin/bash
github_mirror=github.com
csgo_folder=/home/xxmod/steamcmd/gamedir/game/csgo
temp_folder=./temp

export http_proxy="http://192.168.1.49:2080"
export https_proxy="http://192.168.1.49:2080"
echo -e "\033[31mgithub_mirror = \033[33m${github_mirror}\033[0m"
echo -e "\033[31mcsgo_folder = \033[33m${csgo_folder}\033[0m"

download() {
    #下载cssharp
    export latest_tag=$(curl -s https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mCssharp latest tag is \033[33m${latest_tag}\033[0m"
    curl -L -o counterstrikesharp.zip "https://${github_mirror}/roflmuffin/CounterStrikeSharp/releases/download/${latest_tag}/counterstrikesharp-with-runtime-linux-${latest_tag#v}.zip"
    echo -e "\033[31mCssharp already downloaded\033[0m"

    #下载metamod
    export latest_tag=$(curl -s https://api.github.com/repos/alliedmodders/metamod-source/releases \  | jq -r '.[0].tag_name')
    echo -e "\033[31mMetamod latest tag is \033[33m${latest_tag}\033[0m"
    version="${latest_tag%.*}"
    git_part="${latest_tag##*.}"
    filename="mmsource-${version}-git${git_part}-linux.tar.gz"
    echo -e "\033[31mMetamod filename is \033[33m${filename}\033[0m"
    curl -L -o "metamod.tar.gz" "https://${github_mirror}/alliedmodders/metamod-source/releases/download/${latest_tag}/${filename}"
    echo -e "\033[31mMetamod already downloaded\033[0m"

    #下载matchzy
    export latest_tag=$(curl -s https://api.github.com/repos/shobhit-pathak/MatchZy/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mMatchZy latest tag is \033[33m${latest_tag}\033[0m"
    curl -L -o "matchzy.zip" "https://${github_mirror}/shobhit-pathak/MatchZy/releases/download/${latest_tag}/MatchZy-${latest_tag}.zip"
    echo -e "\033[31mMatchZy already downloaded\033[0m"

    #下载weaponpaints
    export latest_tag=$(curl -s https://api.github.com/repos/Nereziel/cs2-WeaponPaints/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mWeaponPaints latest tag is \033[33m${latest_tag}\033[0m"
    curl -L -o "weaponpaints.zip" "https://${github_mirror}/Nereziel/cs2-WeaponPaints/releases/download/${latest_tag}/WeaponPaints.zip"
    echo -e "\033[31mWeaponPaints already downloaded\033[0m"
}

release() {
    #解压文件rm
    mkdir -p "${temp_folder}/cssharp"
    mkdir -p "${temp_folder}/wp"
    mkdir -p "${temp_folder}/matchzy"
    mkdir -p "${temp_folder}/metamod"
    mkdir -p "${temp_folder}/copy"
    unzip counterstrikesharp.zip -d "${temp_folder}/cssharp"
    unzip weaponpaints.zip -d "${temp_folder}/wp"
    unzip matchzy.zip -d "${temp_folder}/matchzy"
    tar -xzf metamod.tar.gz -C "${temp_folder}/metamod"
}

copy2copy_folder() {
    mkdir -p "${temp_folder}/copy/addons"
    mkdir -p "${temp_folder}/copy/cfg"
    cp -r "${temp_folder}/metamod/addons/." "${temp_folder}/copy/addons"
    #cp -r "${temp_folder}/matchzy/cfg/." "${temp_folder}/copy/cfg"
    cp -r "${temp_folder}/matchzy/addons/." "${temp_folder}/copy/addons"
    cp -r "${temp_folder}/cssharp/addons/." "${temp_folder}/copy/addons"
    rm -rf "${temp_folder}/wp/gamedata"
    cp -r "${temp_folder}/wp/." "${temp_folder}/copy/addons/counterstrikesharp/plugins"
}


copy2cs(){
    read -r -p "按回车确认复制到cs文件夹..." _
    cp -r "${temp_folder}/copy/." "${csgo_folder}"
}

echo "1) 全部操作"
echo "2) 解压并操作"
echo "3) 复制到copy并操作"
echo "4) 复制到addons"
echo "5) 删除多余文件"


read -r -p "请输入编号: " choice

case "$choice" in
    1)
        download
        release
        copy2copy_folder
        copy2cs
        ;;
    2)
        release
        copy2copy_folder
        copy2cs
        ;;
    3)
        copy2copy_folder
        copy2cs
        ;;
    4)
        copy2cs
        ;;
    5)
        now_folder=$(pwd)
        read -r -p "按回车确认删除${now_folder}的其他文件..." _
        rm -rf $(ls | grep -v autoupdate.sh)
        ;;
esac