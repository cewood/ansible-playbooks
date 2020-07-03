local.module.dma
================

A role for setting up DragonFly Mail Agent.

Role Variables
--------------

This role makes use of the following variables:

aliases, path to your alias file
`aliases: /path/to/some/file`

authpath, path to an auth configuration file
`authpath: /etc/dma/auth.conf`

certfile, path to a certificate to use
`certfile: /path/to/other/file`

defer, to defer your mails. This is useful if you are behind a dialup line
`defer: true`

fullbounce, if you want the bounce message to include the complete original message, not just the headers
`fullbounce: true`

mailname, the internet hostname dma uses to identify the host. If not set or empty, the result of gethostname(2) is used. If MAILNAME is an absolute path to a file, the first line of this file will be used as the hostname.
`mailname: /path/to/file`

masquerade, masquerade envelope from addresses with this address/hostname. Use this if mails are not accepted by destination mail servers because your sender domain is invalid.
`masquerade: jdoe@nowhere.org`

nullclient, directly forward the mail to the SMARTHOST bypassing aliases and local delivery
`nullclient: true`

opportunistic_tls, if you have specified STARTTLS above and it should be allowed to fail ("opportunistic TLS", use an encrypted connection when available but allow an unencrypted one to servers that do not support it)
`opportunistic_tls: true`

port, the SMTP port to use. Most users will be fine with the default (25)
`port: 1337`

secure, if you want to use plain text SMTP login without using encryption, set this to 'false'. Otherwise plain login will only work over a secure connection, the default. Use this option with caution.
`secure: true`

securetransfer, if yout want TLS/SSL support
`securetransfer: true`

smarthost, your smarthost (also called relayhost). Leave blank if you don't want smarthost support.
`smarthost: localhost`

spooldir, path to your spooldir.
`spooldir: /path/to/another/file`

starttls, if you want STARTTLS support (only used in combination with SECURETRANSFER)
`starttls: true`

auth_entries, a list of dict objects for configuration authentication. Each entry contains a user, smarthost, and password field.
```
auth_entries: [
  {
    user: jdoe
    smarthost: thedoe
    password: secret
  }
]
```

Example Playbook
----------------

The following is an example of a full configuration that can be passed directly to a roles block in a playbook, or via a dependencies block in another role, depending on your preference.

```
  - { role: local.module.dma,
      aliases: /path/to/some/file,
      authpath: /etc/dma/auth.conf,
      certfile: /path/to/other/file,
      defer: true,
      fullbounce: true,
      mailname: /path/to/file,
      masquerade: jdoe@nowhere.org,
      nullclient: true,
      opportunistic_tls: true,
      port: 1337,
      secure: true,
      securetransfer: true,
      smarthost: localhost,
      spooldir: /path/to/another/file,
      starttls: true,
      auth_entries: [
        {
          user: jdoe,
          smarthost: thedoe,
          password: secret
        }
      ],
      tags: [
        "local.module.dma"
      ]
    }
```

License
-------

MIT
