#!/bin/bash

# 检查repos.json文件是否存在
if [ ! -f "repos.json" ]; then
    echo "repos.json 文件不存在."
    exit 1
fi

# 读取并解析repos.json文件中的JSON数据
jq -c '.[]' repos.json | while read i; do
    # 提取repo, branch, 和 context-path值
    repo=$(echo $i | jq -r '.repo')
    branch=$(echo $i | jq -r '.branch')
    context_path=$(echo $i | jq -r '.["context-path"]')
    repo_path=$(echo $i | jq -r '.["repo-path"]')
    cmds=$(echo $i | jq -r '.cmds')

    # 如果文件夹存在，则删除它
    if [ -d "$repo_path" ]; then
        echo "删除已存在的目录: $repo_path"
        rm -rf "$repo_path"
        if [ $? -ne 0 ]; then
            echo "无法删除目录 $repo_path"
            continue
        fi
    fi

    # 克隆仓库到指定路径，并检出指定分支
    git clone --branch $branch $repo --depth=1

    # 检查克隆命令是否成功
    if [ $? -eq 0 ]; then
        echo "成功克隆: $repo 到 $repo_path"
    else
        echo "克隆失败: $repo"
    fi
done