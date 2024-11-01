#!/bin/sh
if [ -z "$GITHUB_TOKEN" ]; then
echo "========这个sh脚本是用来调用github models api，你必须得到测试资格后将token导入环境变量\$GITHUB_TOKEN后才能运行========"
else
echo -n "请输入问题来询问gpt4o-mini\n>"
read question
data=$(cat <<EOF
{
        "messages": [
            {
                "role": "system",
                "content": ""
            },
            {
                "role": "user",
                "content": "$question"
            }
        ],
        "temperature": 1.0,
        "top_p": 1.0,
        "max_tokens": 1000,
        "model": "gpt-4o-mini"
    }
EOF
)
curl -s -X POST "https://models.inference.ai.azure.com/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -d "$data" >chatlog
#cat chatlog|sed 's/,/\n/g'|grep '"content"'|sed 's/:/\n/g'|sed '1,2d'|sed 's/\\n/\n/g'
cat chatlog|sed 's/{"content":/\n"content":/g'|sed 's/,"role"/\n/g'|grep '"content"'|sed 's/:/\n/g'|sed '1d'|sed 's/\\n/\n/g'
fi

if [ -n "$(grep "\"error\":" <chatlog)" ]; then
	echo "token认证错误，请检查"
fi
