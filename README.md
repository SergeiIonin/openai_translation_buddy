# OpenAI Translation Buddy

If you want to get use of the pile of translations you collected in google translate, then give it a try!
This project will pick up adjustable number of words from your translations CSV file and send you a regualr email with examples of usage of these words. The direction is bottom to top (from the oldest to the newest added).

### How To Use This Project
1) checkout this repo via `git clone https://github.com/SergeiIonin/openai_translation_buddy`
2) go to the directory `openai_translation_buddy`
3) Export your translations from Google Translate or provide a CSV file (`,` or `|` separated) with at least 3 columns where 1st is a original language (e.g. "spanish"), second is the target language (e.g. "english"), the third is the expression in original language (e.g. "arbol") and fourth column is an optional expression in the target language (not used anywhere further)
4) run the script `run_cron.sh` which is by default set up be invoke the main script `run.sh` every day at 3 pm (you can customize time very simple, for more info reach out docs for [cronjob](https://docs.cron-job.org/))

This script sends you emails with translations and examples of the foreign language on a regular basis.

### Set up
Open `config.sh` and put your variables for each of the exported environment variable.

#### Email
`APP_PASS`
It is the app password, which can be set up for gmail as shown [here](https://support.google.com/mail/answer/185833?hl=en#zippy=%2Cwhy-you-may-need-an-app-password).
I recommend to create gmail business account for this purpose, verify it and setup 2FA (as per requirements of Google).
It's NOT recommended to use app password of your own google account for this project.
`EMAIL_FROM`
This is preferrably a gmail business account email address. It can be any different email of any provider which supports app passwords.
`EMAIL_TO`
An email of receiver
`SUBJECT`
An email subject, e.g. "Friendly Spanish Newsletter"

#### OpenAI
Assuming you have access to [OpenAI API platform](https://platform.openai.com/docs/overview), fullfiled your balance and set a reasonable usage limit, set up the following variables:
`OPENAI_PROJECT_ID`
`OPENAI_KEY`
`MODEL`
e.g. "gpt-4o"

NB! Your OpenAI account will be billed for API requests made on your behalf to OpenAI. 

#### Translation
This project is tailored to the format of exported CSV used by Google Translate. E.g. if you have a line of translation from spanish to russian will be:
```csv
Spanish,Russian,tarro,банка
```
Next customize the following settings and you're ready to go:
`LANG_FROM`
Language to translate from
`LANG_TO`
Language to translate to
`BASE_PROMPT`
It is a prompt which will tell OpenAI language model what to do with your words set. You can use something similar to this:
"Don't add introductory words like 'certainly!' etc, just write a number of examples with the following $LANG_FROM words or phrases with translation to $LANG_TO, be succinct: "
`FILE`
A CSV file (`,` or `|` separated) with words with the header similar to "$LANG_FROM,$LANG_TO,word_from" (for Google Translate it will be "$LANG_FROM,$LANG_TO,word_from,word_to")
NB! Make sure to place the file in the same directory as all executable files of the project.
`WORDS_PER_MSG`
Number of words to be presented in the examples in a single email message
`POINTER`
If you want to start from the oldest word, set the value to -1 and forget. If you want to start from the particular line or restart the cron job, set the line number of the relevant translation.
