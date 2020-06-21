Role Name
=========

A role for setting up rsnapshot in a particular way, using systemd services and timers for execution.

Role Variables
--------------

This role requires a single complex variable (list of dicts) as configuration, a full example is included below. Here we'll explain the various elements of that configuration variable. The top level variable is a list of dicts named `backups`, which we'll refer to as `backup entries` herein.

```
backups: [
  {
    ...
  },
  {
    ...
  }
]
```

Each `backup entry` contains the following keys, `name`, `enabled`, `snapshot_root`, `retain_settings`, and `backup_directives`.

```
name: default,
enabled: true,
snapshot_root: /mnt/backup,
retain_settings: [
  {
    ...
  },
  {
    ...
  }
],
backup_directives: [
  "...",
  "..."
],

```

The `retain_settings` key is a list of dicts, which we'll refer to as `retain entries` herein. Each `retain entry` contains the following keys, `name`, `count`, `schedule`, and `execs_entries`.

```
name: "weekly",
count: 4,
schedule: "Mon *-*-8..31 1:00:00",
execs_entries: [
  "...",
  "..."
]
```

The `execs_entries` key is a list of strings, which we'll refer to as `exec entries` herein. Each `exec entry` should correspond to the name of a `retain entry`. As these will be listed in the systemd service for this retain level and get passed to rsnapshot as commands/targets, so for example the weekly backup should call the weekly backup and then afterwards run the daily backup, hence it would look like the example below.

```
[
  "weekly",
  "daily"
]
```

Example Playbook
----------------

The following is an example of a full configuration that can be passed directory to a roles block in a playbook, or via a dependencies block in another role, depending on your preference.

```
  - { role: module.local.rsnapshot,
      backups: [
        { name: default,
          enabled: true,
          snapshot_root: /mnt/backup,
          retain_settings: [
            { name: "daily",
              count: 7,
              schedule: "Tue..Sun *-*-* 1:00:00",
              execs_entries: [
                "daily"
              ],
            },
            { name: "weekly",
              count: 4,
              schedule: "Mon *-*-8..31 1:00:00",
              execs_entries: [
                "weekly",
                "daily"
              ],
            },
            { name: "monthly",
              count: 6,
              schedule: "Mon *-2..12-1..7 1:00:00",
              execs_entries: [
                "monthly",
                "weekly",
                "daily"
              ],
            },
            { name: "yearly",
              count: 1,
              schedule: "Mon *-1-1..7 1:00:00",
              execs_entries: [
                "yearly",
                "monthly",
                "weekly",
                "daily"
              ],
            }
          ],
          backup_directives: [
            "backup	/mnt/storage/code	babushka/",
            "backup	/mnt/storage/documents	babushka/",
            "backup	/mnt/storage/containers/syncthing/data/schrodinger.bridge.middlearth.lan	schrodinger/"
          ],
        }
      ],
      tags: [
        "module.local.rsnapshot"
      ]
    }
```

License
-------

MIT
