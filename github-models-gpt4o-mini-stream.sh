#!/bin/bash
if [ -z "$GITHUB_TOKEN" ]; then
echo "========这个sh脚本是用来调用github models api，你必须得到测试资格后将token导入环境变量\$GITHUB_TOKEN后才能运行========"
else
echo -n -e "请输入问题来询问gpt4o-mini\n>"
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
        "model": "gpt-4o-mini",
	"stream": true
    }
EOF
)
curl -s -X POST "https://models.inference.ai.azure.com/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -d "$data"|while IFS= read -r line; do
if [ -n "$line" ]; then
	echo -n $line|sed 's/{"content":/\n"content":/g'|sed 's/"},"finish_reason"/\n/g'|grep '"content"'|tr -d '\n'|sed 's/"content":"//g'|sed 's/\\n/\n/g'
fi
done
fi
