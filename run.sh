#!/bin/bash

source config.sh

words_extractor() {
    local count=$WORDS_PER_MSG
    while [[ $count -gt 0 && $pointer -gt 0 ]]; do
        echo $pointer
        w=$(sed -n "${pointer}p" $FILE | awk -F, '{print $3}')
        if [ count == $WORDS_PER_MSG ]; then
            words="$w,"
        else 
            words="$words $w,"
        fi
        ((count--))
        ((pointer--))
    done
    sed -i '' "/^export POINTER=/s/.*/export POINTER=$pointer/" config.sh
}

call_openai() {
    resp=$(curl "https://api.openai.com/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_KEY" \
        -H "OpenAI-Project: $PROJECT_ID" \
        --data "{
            \"model\": \"$MODEL\",
            \"messages\": [
                {
                    \"role\": \"system\",
                    \"content\": \"You are a helpful assistant.\"
                },
                {
                    \"role\": \"user\",
                    \"content\": \"$BASE_PROMPT: $words\"
                }
            ]
        }"
    )
}

send_email() {
    echo "sending email"
    subject="Regular spanish examples"

    curl --url "smtps://smtp.gmail.com:465" \
        --ssl-reqd \
        --mail-from $FROM \
        --mail-rcpt $TO \
        --user $FROM:"$APP_PASS" \
        --upload-file <(echo -e "From: $FROM\nTo: $TO\nSubject: $subject\n\n$body")
}

if [[ $POINTER -eq -1 ]]; then
    lines=$(echo $(wc -l $FILE) | awk '{print $1}')
    pointer=$lines
else
    pointer=$POINTER    
fi

echo "current words pointer: $pointer"

words=""
words_extractor

echo "current slice of words: $words"

resp=""
call_openai

content=$(jq '.choices.[-1].message.content' <<< $resp)

body=$(echo $content | sed 's/\\n/\n/g')
echo $body
send_email
