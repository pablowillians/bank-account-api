# https://hub.docker.com/_/elixir/
FROM elixir:1.10-alpine

# init
RUN apk update && \
    apk add ca-certificates && update-ca-certificates && \
    apk add git bash postgresql-client openssl curl && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mkdir -p /umbrella

COPY . /umbrella

# get and compile elixir deps
RUN apk add --update alpine-sdk coreutils && \
    cd /umbrella && \
    mix do deps.get, compile

WORKDIR /umbrella

EXPOSE 4000

CMD ["sh", "-c", "mix do ecto.create, ecto.migrate; mix phx.server"]
