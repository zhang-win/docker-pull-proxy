#!/bin/bash
BASE_URL=registry.cn-hangzhou.aliyuncs.com/outer_fast/
CHECK_FILE=${1:-trigger.txt}
echo git diff HEAD~:${CHECK_FILE} HEAD:${CHECK_FILE}
git diff HEAD^:${CHECK_FILE} HEAD:${CHECK_FILE}
lines=$(git diff HEAD^:${CHECK_FILE} HEAD:${CHECK_FILE}|grep '^+'|grep -v '^++'|awk '{print $1}')
for line in $lines
do
        line=${line:1}
        SOURCE_REPO_NAME=$line
        BASE_REPO_NAME=`echo $SOURCE_REPO_NAME|awk -F'/' '{print $2}'`
        BASE_REPO_NAME=${BASE_REPO_NAME:=$SOURCE_REPO_NAME}
        echo "$SOURCE_REPO_NAME to $BASE_URL$BASE_REPO_NAME"
        docker pull $SOURCE_REPO_NAME
        docker tag $SOURCE_REPO_NAME $BASE_URL$BASE_REPO_NAME
        docker push $BASE_URL$BASE_REPO_NAME
done
