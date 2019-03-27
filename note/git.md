---
title: git使用
date: 2017-10-26 23:09:47
tags: git
---
    git init # 初始化一个Git仓库
    git clone # 从github remote repository下载一个git repository到本地
    git add readme.txt / git add .
    git rm test.txt
    git commit -m "add 3 files." # -m后面输入的是本次提交的说明，可以输入任意内容。
    当然最好是有意义的，这样你就能从历史记录里方便地找到改动记录。

    git push -u origin master #将本地repository更新到github网站，即remote repository
    git pull origin master # 拉取github上更新

    git status
