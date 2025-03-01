# Openai Translation Buddy

If you want to get use of the pile of translations you collected in google translate, then give it a try!

This script sends you emails with translations and examples of the foreign language on a regular basis, e.g. everyday at 12 pm:
```bash
crontab -e
0 12 * * * /path/to/run.sh
```

### Set up

#### Email
Go to `config.sh` and add all environment variables.
APP_PASS is app password, which can be set up for gmail as shown here: https://support.google.com/mail/answer/185833?hl=en#zippy=%2Cwhy-you-may-need-an-app-password.
I recommend to create gmail business account for this purpose, verify it and setup 2FA (as per requirements of Google).

#### OpenAI
The rest of the settings are straightforward: create account at OpenAI API platform if you haven't and fullfil your balance, make sure to set a limit as well. Then provide project id, API key and model (like `gpt-4o`).
NB! Your OpenAI account will be billed for API requests made on your behalf to OpenAI. 

#### Translation
This project is tailored to the exported CSV for Google translate. E.g. if you have a line of translation from spanish to russian will be:
```csv
Spanish,Russian,tarro,банка
```
Customize a base prompt and you're ready to go.
