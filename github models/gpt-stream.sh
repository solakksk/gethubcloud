curl -s -X POST "https://models.inference.ai.azure.com/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -d '{
        "messages": [
            {
                "role": "system",
                "content": "You are a helpful assistant."
            },
            {
                "role": "user",
                "content": "Give me 5 good reasons why I should exercise every day."
            }
        ],
        "stream": true,
        "model": "gpt-4o-mini"
    }'|while IFS= read -r line; do
    if [ -n "$line" ]; then
	            echo -n $line|sed 's/{"content":/\n"content":/g'|sed 's/"},"finish_reason"/\n/g'|grep '"content"'|tr -d '\n'|sed 's/"content":"//g'|sed 's/\\n/\n/g'
    fi
done
