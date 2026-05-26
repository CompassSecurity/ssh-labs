# Accessing `linux-srv-07`

## Login as `frank`

We are still logged in on `linux-srv-07` as `frank`:

```shell-session
dave@linux-srv-06:~$ hostname
linux-srv-06.nullbyte.internal

dave@linux-srv-06:~$ id
uid=1000(dave) gid=1000(dave) groups=1000(dave),27(sudo)
```

## Flag

Get the final flag:

```shell-session
dave@linux-srv-06:~$ cat /flag.txt 

    Congrats, you successfuly solved the lab!

                            .
                            A       ;
                  |   ,--,-/ \---,-/|  ,
                 _|\,'. /|      /|   `/|-.
             \`.'    /|      ,            `;.
            ,'\   A     A         A   A _ /| `.;
          ,/  _              A       _  / _   /|  ;
         /\  / \   ,  ,           A  /    /     `/|
        /_| | _ \         ,     ,             ,/  \
       // | |/ `.\  ,-      ,       ,   ,/ ,/      \/
       / @| |@  / /'   \  \      ,              >  /|    ,--.
      |\_/   \_/ /      |  |           ,  ,/        \  ./' __:..
      |  __ __  |       |  | .--.  ,         >  >   |-'   /     `
    ,/| /  '  \ |       |  |     \      ,           |    /
   /  |<--.__,->|       |  | .    `.        >  >    /   (
  /_,' \\  ^  /  \     /  /   `.    >--            /^\   |
        \\___/    \   /  /      \__'     \   \   \/   \  |
         `.   |/          ,  ,                  /`\    \  )
           \  '  |/    ,       V    \          /        `-\
            `|/  '  V      V           \    \.'            \_
             '`-.       V       V        \./'\
                 `|/-.      \ /   \ /,---`\         kat
                  /   `._____V_____V'
                             '     '


        Have a nice day!

             Mänu

ssh-labs{mfa-does-not-mean-its-secure}
```

Congratz! You did it! I hope you had fun doing these labs and that you learned something ;-).

![Firework](../images/firework.svg){width="100"}

Have a good time,

Mänu