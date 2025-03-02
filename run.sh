#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DIR/config.sh"

# validate mail variables
if [[ -z "$APP_PASS" ]]; then
    echo "APP_PASS is not set"
    exit 1
fi
if [[ -z "$FROM" ]]; then
    echo "FROM is not set"
    exit 1
fi
if [[ -z "$TO" ]]; then
    echo "TO is not set"
    exit 1
fi
if [[ -z "$SUBJECT" ]]; then
    echo "SUBJECT is not set"
    exit 1
fi
# validate openai variables
if [[ -z "$OPENAI_PROJECT_ID" ]]; then
    echo "OPENAI_PROJECT_ID is not set"
    exit 1
fi
if [[ -z "$OPENAI_KEY" ]]; then
    echo "OPENAI_KEY is not set"
    exit 1
fi
if [[ -z "$MODEL" ]]; then
    echo "MODEL is not set"
    exit 1
fi
# validate translations variables
if [[ -z "$LANG_FROM" ]]; then
    echo "LANG_FROM is not set"
    exit 1
fi
if [[ -z "$LANG_TO" ]]; then
    echo "LANG_TO is not set"
    exit 1
fi
if [[ -z "$BASE_PROMPT" ]]; then
    echo "BASE_PROMPT is not set"
    exit 1
fi
if [[ -z "$FILE" ]]; then
    echo "FILE is not set"
    exit 1
fi
if [[ -z "$WORDS_PER_MSG" ]]; then
    echo "WORDS_PER_MSG is not set"
    exit 1
fi
if [[ -z "$POINTER" ]]; then
    echo "POINTER is not set, set it to -1 to start from the end of the file"
    exit 1
fi

file=$DIR/$FILE
config="$DIR/config.sh"

validate_csv() {
    local num_cols=$(head -n 1 $file | awk -F '[,|]' 'NR==1 {print NF}')
    if [[ $num_cols < 3 ]]; then
        echo "CSV file should have at least 3 columns"
        exit 1
    fi
    local lang_from_lower=$(head -n 1 $file | awk -F '[,|]' '{print $1}') | tr '[:upper:]' '[:lower:]'
    local lang_to_lower=$(head -n 1 $file | awk -F '[,|]' '{print $2}') | tr '[:upper:]' '[:lower:]'

    local config_lang_from_lower=$LANG_FROM | tr '[:upper:]' '[:lower:]'
    local config_lang_to_lower=$LANG_TO | tr '[:upper:]' '[:lower:]'

    if [[ $lang_from_lower != $config_lang_from_lower ]]; then
        echo "first column in the CSV should be $LANG_FROM"
        exit 1
    fi

    if [[ $lang_to_lower != $config_lang_to_lower ]]; then
        echo "second column in the CSV should be $LANG_TO"
        exit 1
    fi
}

words_extractor() {
    local count=$WORDS_PER_MSG
    while [[ $count -gt 0 && $pointer -gt 0 ]]; do
        echo $pointer
        w=$(sed -n "${pointer}p" $file | awk -F, '{print $3}')
        if [ count == $WORDS_PER_MSG ]; then
            words="$w,"
        else 
            words="$words $w,"
        fi
        ((count--))
        ((pointer--))
    done
    words=$(echo $words | sed 's/.$//') # remove last comma
    sed -i '' "/^export POINTER=/s/.*/export POINTER=$pointer/" $config
}

call_openai() {
    prompt="$BASE_PROMPT: $words"
    echo "prompt: $prompt"
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
                    \"content\": \"$prompt\"
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

validate_config
echo "config validated"

validate_csv
echo "csv validated"

if [[ $POINTER -eq -1 ]]; then
    lines=$(echo $(wc -l $file) | awk '{print $1}')
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
