# Prometheus Scraper 
Prometheus Dockerfile to start a standalone server in seconds. Once running, this server will make API calls to the           different nodes periodically to obtain the data that will be used to compute the rewards for these nodes.

## Recommended configuration to run
To run this project it is necessary to have Lua, Luarocks and also Lapis installed. Also openresty and git are needed (Git is due to the dependencies of the project, which are cloned from a repository).

```
apt install lua5.1 luarocks libssl-dev openresty
luarocks install luasec
luarocks install lapis 
```

```
lapis server
```

The API calls are secured with a secret token to avoid unauthorized access.
