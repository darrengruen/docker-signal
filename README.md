# docker-signal

Run signal inside a docker container

# USAGE

__NOTE:__ This only works on linux

```shell
docker run \
  -d \
  -v "/etc/localtime:/etc/localtime:ro" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix" \
  -e "DISPLAY=unix${DISPLAY}" \
  gruen/signal:master
```

That should get you up and running

To persist data so you don't have to log in each time you can mount a directory:

```shell
...
  -v "/tmp/.X11-unix:/tmp/.X11-unix" \
  -v "[local/path/to/mount]:/home/signal/.config/Signal" \
  -e "DISPLAY=unix${DISPLAY}" \
  ...
```

That should persist your data.

