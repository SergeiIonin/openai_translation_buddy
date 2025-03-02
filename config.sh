#!/bin/bash

# mail
export APP_PASS=$APP_PASS
export FROM=$EMAIL_FROM
export TO=$EMAIL_TO
# openai
export OPENAI_PROJECT_ID=$OPEN_AI_PROJECT_ID
export OPENAI_KEY=$OPENAI_KEY
export MODEL=$MODEL #e.g. "gpt-4o"
# translations
export BASE_PROMPT="Don't add introductory words like 'certainly!' etc, just write a number of examples with the following spanish words or phrases with translation to russian, be succinct: "
export FILE=$CSV_FILE
export WORDS_PER_MSG=$WORDS_PER_MSG # number of words for exercise in one email message
export POINTER=-1 # initial value should be -1. Set up before the start and never change unless you start again

