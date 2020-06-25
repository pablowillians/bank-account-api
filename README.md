# BankAccount API

## Como inicializar a aplicação

Primeiramente, você precisará contar com o [Docker](https://www.docker.com/) instalado.

As etapas para rodar o projeto em seu ambiente são:

1. Preparar o banco de dados da aplicação

    `docker-compose run --rm web mix ecto.create && mix ecto.migrate`

2. Inicializar a aplicação:

    `docker-compose up -d web`

    Após este comando o projeto estará funcionando no endereço `http://localhost:4000`

Após feitas estas etapas, você terá acesso às seguintes rotas via HTTP:

1. `POST /api/accounts`
2. `GET /api/accounts/indications/[referral_code]` onde `[referral_code]` deverá ser substituido pelo referral_code da conta criada, para visualizar as indicações

## Como executar os testes da aplicação

Para executar os testes execute o seguinte comando: `docker-compose run --rm test`

## Como contribuir

A aplicação foi desenvolvida utilizando o [Phoenix Framework](https://www.phoenixframework.org/) em uma estrutura [Umbrella](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html).

Por isso, temos duas apliações neste projeto, são elas:

1. `bank_account`: Nesta, concentramos os módulos e funções que agregam informações do domínio e regras de negócio
2. `bank_account_web`: Aqui, concentramos o código que consome os módulos do domínio e fornece uma interface via protocolo HTTPpara clientes interagirem com a aplicação
