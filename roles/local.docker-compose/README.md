local.docker-compose
====================

This is a small Ansible role that I created to encapsulate a bunch of docker-compose specific configuration that I had.

If you aren't familiar with Ansible, and would just like to use borrow some inspiration from this setup then you're in luck. You should be able to just copy [files/docker-compose.yml](files/docker-compose.yml), then also copy [templates/docker-compose.j2.env](templates/docker-compose.j2.env) and rename it to `.env` in the same dir as `docker-compose.yml`. Then edit them accordingly with valid inputs for your needs, and you should be able to `docker-compose up -d ...` the respective services.

Requirements
------------

You will need to have docker-compose installed and available on your system, this role does not take care of that.

Role Variables
--------------

The best way to discover the required/settable variables is to consult [defaults/main.yml](defaults/main.yml), trying to list them here and keep them in sync would be a pain and prone to errors.

Dependencies
------------

None.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: local.docker-compose,
             domain_name:          "my.domain.name",
             email_address:        "me@example.com",
             oauth2_client_id:     "someid",
             oauth2_client_secret: "asupersecret",
             oauth2_cookie_secret: "yetanothersecret",
             openvpn_config:       "example",
             openvpn_password:     "secret",
             openvpn_provider:     "nordvpn",
             openvpn_username:     "joeuser",
             samba_user1:          "joe",
             samba_user2:          "jane",
             smtp_gmail_password:  "moresecrets",
             smtp_gmail_user:      "me@example.com",
             smtp_hostname:        "smtp.example.com",
             smtp_mailname:        "smtp.example.com",
             tags: [
               "docker-compose",
               "local.docker-compose"
             ]
           }

License
-------

BSD
