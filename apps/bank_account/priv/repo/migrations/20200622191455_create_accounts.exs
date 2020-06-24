defmodule BankAccount.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :cpf, :string
      add :birth_date, :string
      add :gender, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :indication_referral_code, :string
      add :referral_code, :string
      add :status, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:accounts, [:cpf])
    create unique_index(:accounts, [:referral_code])
  end
end
