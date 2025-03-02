#!/bin/bash

# mail
export APP_PASS=$APP_PASS
export FROM=$EMAIL_FROM
export TO=$EMAIL_TO
export SUBJECT=$SUBJECT
# openai
export OPENAI_PROJECT_ID=$OPEN_AI_PROJECT_ID
export OPENAI_KEY=$OPENAI_KEY
export MODEL=$MODEL #e.g. "gpt-4o"
# translations
export LANG_FROM=$LANG_FROM
export LANG_TO=$LANG_TO
export BASE_PROMPT="Don't add introductory words like 'certainly!' etc, just write a number of examples with the following $LANG_FROM words or phrases with translation to $LANG_TO, be succinct: "
export FILE=$CSV_FILE # CSV file with words with the header "$LANG_FROM,$LANG_TO,word_from,word_to"
export WORDS_PER_MSG=$WORDS_PER_MSG # number of words for exercise in one email message
export POINTER=-1 # initial value should be -1. Set up before the start and never change unless you start again

