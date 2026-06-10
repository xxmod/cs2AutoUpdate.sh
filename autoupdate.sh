#!/bin/bash
github_mirror=github.com #github镜像
csgo_folder=/home/xxmod/steamcmd/gamedir/game/csgo #cs文件夹
temp_folder=./temp #临时文件(建议默认)

export http_proxy="http://192.168.1.49:2080"
export https_proxy="http://192.168.1.49:2080"
echo -e "\033[31mgithub_mirror = \033[33m${github_mirror}\033[0m"
echo -e "\033[31mcsgo_folder = \033[33m${csgo_folder}\033[0m"

download() {
    #下载cssharp
    export latest_tag=$(curl -s https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mCssharp最新的tag是\033[33m${latest_tag}\033[0m"
    curl -L -o counterstrikesharp.zip "https://${github_mirror}/roflmuffin/CounterStrikeSharp/releases/download/${latest_tag}/counterstrikesharp-with-runtime-linux-${latest_tag#v}.zip"
    echo -e "\033[31mCssharp已下载\033[0m"

    #下载metamod
    export latest_tag=$(curl -s https://api.github.com/repos/alliedmodders/metamod-source/releases \  | jq -r '.[0].tag_name')
    echo -e "\033[31mMetamod最新的tag是\033[33m${latest_tag}\033[0m"
    version="${latest_tag%.*}"
    git_part="${latest_tag##*.}"
    filename="mmsource-${version}-git${git_part}-linux.tar.gz"
    echo -e "\033[31mMetamod文件名是\033[33m${filename}\033[0m"
    curl -L -o "metamod.tar.gz" "https://${github_mirror}/alliedmodders/metamod-source/releases/download/${latest_tag}/${filename}"
    echo -e "\033[31mMetamod已下载\033[0m"

    #下载matchzy
    export latest_tag=$(curl -s https://api.github.com/repos/shobhit-pathak/MatchZy/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mMatchZy最新的tag是\033[33m${latest_tag}\033[0m"
    curl -L -o "matchzy.zip" "https://${github_mirror}/shobhit-pathak/MatchZy/releases/download/${latest_tag}/MatchZy-${latest_tag}.zip"
    echo -e "\033[31mMatchZy已下载\033[0m"

    #下载weaponpaints
    export latest_tag=$(curl -s https://api.github.com/repos/Nereziel/cs2-WeaponPaints/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mWeaponPaints最新的tag是\033[33m${latest_tag}\033[0m"
    curl -L -o "weaponpaints.zip" "https://${github_mirror}/Nereziel/cs2-WeaponPaints/releases/download/${latest_tag}/WeaponPaints.zip"
    echo -e "\033[31mWeaponPaints已下载\033[0m"
    
    #下载playersettings
    export latest_tag=$(curl -s https://api.github.com/repos/NickFox007/PlayerSettingsCS2/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mPlayerSettings最新的tag是\033[33m${latest_tag}\033[0m"
    curl -L -o "playersettings.zip" "https://${github_mirror}/NickFox007/PlayerSettingsCS2/releases/download/${latest_tag}/PlayerSettings.zip"
    echo -e "\033[31mPlayerSettings已下载\033[0m"

    #下载anybaselib
    export latest_tag=$(curl -s https://api.github.com/repos/NickFox007/AnyBaseLibCS2/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mAnyBaseLib最新的tag是\033[33m${latest_tag}\033[0m"
    curl -L -o "anybaselib.zip" "https://${github_mirror}/NickFox007/AnyBaseLibCS2/releases/download/${latest_tag}/AnyBaseLib.zip"
    echo -e "\033[31mAnyBaseLib已下载\033[0m"

    #下载menumanager
    export latest_tag=$(curl -s https://api.github.com/repos/NickFox007/MenuManagerCS2/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    echo -e "\033[31mMenuManager最新的tag是\033[33m${latest_tag}\033[0m"
    curl -L -o "menumanager.zip" "https://${github_mirror}/NickFox007/MenuManagerCS2/releases/download/${latest_tag}/MenuManager.zip"
    echo -e "\033[31mMenuManager已下载\033[0m"
}

release() {
    #解压文件rm
    mkdir -p "${temp_folder}/cssharp"
    mkdir -p "${temp_folder}/wp"
    mkdir -p "${temp_folder}/matchzy"
    mkdir -p "${temp_folder}/metamod"
    mkdir -p "${temp_folder}/playersettings"
    mkdir -p "${temp_folder}/anybaselib"
    mkdir -p "${temp_folder}/menumanager"
    unzip counterstrikesharp.zip -d "${temp_folder}/cssharp"
    unzip weaponpaints.zip -d "${temp_folder}/wp"
    unzip matchzy.zip -d "${temp_folder}/matchzy"
    tar -xzf metamod.tar.gz -C "${temp_folder}/metamod"
    unzip playersettings.zip -d "${temp_folder}/playersettings"
    unzip anybaselib.zip -d "${temp_folder}/anybaselib"
    unzip menumanager.zip -d "${temp_folder}/menumanager"
    echo -e "\033[31m已解压到${temp_folder}\033[0m"
}

copy2copy_folder() {
    mkdir -p "${temp_folder}/copy/addons"
    mkdir -p "${temp_folder}/copy/cfg"
    cp -r "${temp_folder}/metamod/addons/." "${temp_folder}/copy/addons"
    #cp -r "${temp_folder}/matchzy/cfg/." "${temp_folder}/copy/cfg" #第一次安装取消注释这一行
    cp -r "${temp_folder}/matchzy/addons/." "${temp_folder}/copy/addons"
    cp -r "${temp_folder}/cssharp/addons/." "${temp_folder}/copy/addons"
    rm -rf "${temp_folder}/wp/gamedata"
    cp -r "${temp_folder}/wp/." "${temp_folder}/copy/addons/counterstrikesharp/plugins"
    cp -r "${temp_folder}/playersettings/addons/." "${temp_folder}/copy/addons"
    cp -r "${temp_folder}/menumanager/addons/." "${temp_folder}/copy/addons"
    cp -r "${temp_folder}/anybaselib/addons/." "${temp_folder}/copy/addons"
    echo -e "\033[31m文件已复制到${temp_folder}/copy\033[0m"
}


copy2cs(){
    read -r -p "按回车确认复制到cs文件夹..." _
    cp -r "${temp_folder}/copy/." "${csgo_folder}"
    echo -e "\033[31m文件已复制到${csgo_folder}\033[0m"
}

echo "1) 全部操作"
echo "2) 删除多余文件"
echo "3) gameinfo.gi添加插件路径"
echo "4) 杀掉cs2进程"

read -r -p "请输入编号: " choice

case "$choice" in
    1)
        download
        release
        copy2copy_folder
        copy2cs
        ;;
    2)
        now_folder=$(pwd)
        fullname=$(basename "$0")
        read -r -p "按回车确认删除${now_folder}除了${fullname}文件..." _
        rm -rf $(ls | grep -v "$fullname")
        ;;
    3)
        read -r -p "按回车确认添加插件路径到gameinfo.gi" _
        if grep -q "Game.*csgo/addons/metamod" "${csgo_folder}/gameinfo.gi"; then
            echo "已存在，跳过操作"
        else
            echo "不存在，执行插入"
            sed -i ':a; /^\s*$/{N;/\n\s*Game\s*csgo\s*$/!P;D;}; s/^\(\s*\)Game\s*csgo\s*$/\1Game\tcsgo\/addons\/metamod\n\1Game\tcsgo/' "${csgo_folder}/gameinfo.gi"  
        fi
        ;;
    4)
        pkill -9 cs2
        echo "cs2进程已杀死"
        ;;
esac