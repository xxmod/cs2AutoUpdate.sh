# CS2AutoUpdate.sh

> 为了避免每次游戏更新导致繁琐且重复的插件更新，开发此脚本用于自动化更新CS2插件

## 更新列表

* Metamod
* CounterStrikeSharp
* MatchZy
* WeaponPaints
* PlayerSettings(WP前置)
* AnyBaseLib(WP前置)
* MenuManager(WP前置)

## 特性

* 从github中自动下载最新的插件并更新到cs中
* 添加 `Game csgo/addons/metamod`到gameinfo.gi中

## 使用指南

### 1）下载autoupdate.sh

 打开[此链接](https://downgit.github.io/#/home?url=https://github.com/xxmod/cs2AutoUpdate.sh/blob/main/autoupdate.sh)下载压缩包

解压得到autoupdate.sh

> [!CAUTION]
> 不要把这个脚本与其他文件放在一起，脚本里的删除多余文件会把当前目录下的其他文件删掉

### 2）修改变量并给予相应权限

`nano autoupdate.sh`修改

```powershell
github_mirror=github.com #github镜像
csgo_folder=/home/gamedir/csgo #cs文件夹
temp_folder=./temp #临时文件(建议默认)
export http_proxy="http://192.168.1.49:2080" #代理
export https_proxy="http://192.168.1.49:2080" #如不需要把这两行注释掉
```

给予权限

`chmod +x autoupdate.sh`

### 3）使用脚本

`./autoupdate.sh`

> [!NOTE]
> 当脚本提示需要确认时请确认游戏目录，解压文件内容无误后再进行回车，脚本不承担误删文件造成的后果
