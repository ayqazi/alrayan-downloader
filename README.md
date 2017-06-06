Al-Rayan Bank Statement Downloader
==

A simple project to download OFX statements from an al-Rayan bank
account.

Configure your accounts by creating/editing a file `config.yaml` - see
`config.yaml.example` for how to do that.

Run `bin/scrape <account name> > file.ofx`

e.g.

    $ cat config.yaml
    ---
    personal:
      username: DEF987654321
      password: personalpassword
      password2: ijklmnop
      account-id: 36111111

    $ bin/scrape personal > file.ofx

    $ cat file.ofx
    OFXHEADER:100
    DATA:OFXSGML
    VERSION:102
    SECURITY:NONE
    ENCODING:USASCII
    CHARSET:1252
    COMPRESSION:NONE
    OLDFILEUID:NONE
    NEWFILEUID:NONE
    <OFX>...
