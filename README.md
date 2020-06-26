# BankAccount API

## Como inicializar a aplicação

Primeiramente, você precisará contar com o [Docker](https://www.docker.com/) instalado.

Então para inicializar a aplicação execute:

`docker-compose up -d web`

Após este comando o projeto estará funcionando no endereço `http://localhost:4000`

## Utilizando a aplicação

Primeiro de tudo, vamos criar um usuário para gerir nossas contas:

Faça uma requisição para `POST /api/sign_up` com um payload semelhante a:

```json
{
	"user": {
		"email": "foo@bar.com",
		"password": "somePassword",
		"password_confirmation": "somePassword"
	}
}
```

Após isso, faça login através de uma nova requisição para `POST /api/sign_in` com seus dados de autenticação, como no exemplo:

```json
{
	"email": "foo@bar.com",
	"password": "somePassword"
}
```

Após feitas estas etapas, você terá acesso às seguintes rotas via HTTP usando o token JWT retornado na requisição anterior como cabeçalho de autorização nas requisições:

1. `POST /api/accounts`, exemplo de payload:
	```json
	{
		"account": {
			"cpf": "99999999999",
			"name": "Name Last Name",
			"email": "email@valid.com",
			"birth_date": "1991-01-29",
			"city": "Curitiba",
			"country": "BR",
			"gender": "male",
			"state": "PR",
			"indication_referral_code": "883632"
		}
	}
	```
2. `GET /api/accounts/indications/[referral_code]` onde `[referral_code]` deverá ser substituido pelo referral_code da conta criada, para visualizar as indicações

## Como executar os testes da aplicação

Para executar os testes execute o seguinte comando: `docker-compose run --rm test`

## Como contribuir

A aplicação foi desenvolvida utilizando o [Phoenix Framework](https://www.phoenixframework.org/) em uma estrutura [Umbrella](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html).

Por isso, temos duas apliações neste projeto, são elas:

1. `bank_account`: Nesta, concentramos os módulos e funções que agregam informações do domínio e regras de negócio
2. `bank_account_web`: Aqui, concentramos o código que consome os módulos do domínio e fornece uma interface via protocolo HTTPpara clientes interagirem com a aplicação
