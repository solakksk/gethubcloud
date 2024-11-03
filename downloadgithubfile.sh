#!/bin/bash
echo -e "此脚本用来下载github仓库中的文件，格式支持\n1. <用户名>/<仓库名>/<分支名>/<文件路径>\n2. 网页直链类似于https://github.com/microsoft/vscode/blob/main/README.md"
read -p "请输入文件的url:" -r repo
if [ -z "$(echo -n $repo|grep "blob")" ]; then
BRANCH=$(echo -n $repo|awk -F'/' '{printf $3}')
PEG="/refs/heads/$BRANCH"
FILENAME=$(echo -n $repo|awk -F'/' '{printf "/"; for (i=4; i<=NF; i++) printf "%s%s",$i,(i<NF ? "/" : "")}')
wget $(echo -n "https://raw.githubusercontent.com/$repo"|sed "s|/$BRANCH$FILENAME||g")$PEG$FILENAME
else
BRANCH=$(echo -n $repo|awk -F'/' '{printf $7}')
PEG="/refs/heads/$BRANCH"
FILENAME=$(echo -n $repo|awk -F'/' '{printf "/"; for (i=8; i<=NF; i++) printf "%s%s",$i,(i<NF ? "/" : "")}')
wget $(echo -n $repo|sed 's/github.com/raw.githubusercontent.com/g'|sed "s|/blob/$BRANCH$FILENAME||g")$PEG$FILENAME
fi
