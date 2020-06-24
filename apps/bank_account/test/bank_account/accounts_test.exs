defmodule BankAccount.AccountsTest do
  use BankAccount.DataCase

  alias BankAccount.Accounts

  describe "accounts" do
    alias BankAccount.Accounts.Account

    @valid_attrs %{birth_date: "2010-04-17", city: "some city", country: "some country", cpf: Brcpfcnpj.cpf_generate(), email: "some@email", gender: "some gender", name: "some name", indication_referral_code: "18273645", state: "some state", status: true}
    @update_attrs %{birth_date: "2011-05-18", city: "some updated city", country: "some updated country", cpf: Brcpfcnpj.cpf_generate(), email: "some_updated@email", gender: "some updated gender", name: "some updated name", indication_referral_code: "81726354", state: "some updated state", status: false}
    @invalid_attrs %{birth_date: nil, city: nil, country: nil, cpf: nil, email: nil, gender: nil, name: nil, indication_referral_code: nil, state: nil, status: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert Accounts.decrypt_value(account.birth_date) == "2010-04-17"
      assert account.city == "some city"
      assert account.country == "some country"
      assert Accounts.decrypt_value(account.cpf) == @valid_attrs.cpf
      assert Accounts.decrypt_value(account.email) == "some@email"
      assert account.gender == "some gender"
      assert Accounts.decrypt_value(account.name) == "some name"
      assert account.indication_referral_code == @valid_attrs.indication_referral_code
      assert account.state == "some state"
      assert account.status == true
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert Accounts.decrypt_value(account.birth_date) == "2011-05-18"
      assert account.city == "some updated city"
      assert account.country == "some updated country"
      assert Accounts.decrypt_value(account.cpf) == @update_attrs.cpf
      assert Accounts.decrypt_value(account.email) == "some_updated@email"
      assert account.gender == "some updated gender"
      assert Accounts.decrypt_value(account.name) == "some updated name"
      assert account.indication_referral_code == @update_attrs.indication_referral_code
      assert account.state == "some updated state"
      assert account.status == false
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account_by_cpf(Accounts.decrypt_value(account.cpf))
    end

    test "get_account_by_cpf/1 with cpf already used returns the account" do
      account = account_fixture()
      cpf_already_used = Accounts.decrypt_value(account.cpf)

      assert account == Accounts.get_account_by_cpf(cpf_already_used)
    end

    test "get_account_by_cpf/1 with cpf never used returns nil" do
      cpf_never_used = Brcpfcnpj.cpf_generate()

      assert nil == Accounts.get_account_by_cpf(cpf_never_used)
    end

    test "get_account_by_referral_code/1 with already used referral_code returns the account" do
      account = account_fixture()
      assert account == Accounts.get_account_by_referral_code(account.referral_code)
    end

    test "get_account_by_referral_code/1 with never used referral_code returns nil" do
      referral_code = Accounts.generate_unused_referral_code()
      assert nil == Accounts.get_account_by_referral_code(referral_code)
    end

    test "create_or_update_account/1 when creating with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_or_update_account(@invalid_attrs)
    end

    test "create_or_update_account/2 when updating with invalid data returns error changeset" do
      account = account_fixture()

      decrypted_cpf = Accounts.decrypt_value(account.cpf)

      invalid_update_attrs = %{"cpf" => decrypted_cpf, "email" => "invalid_email"}

      assert {:error, %Ecto.Changeset{}} = Accounts.create_or_update_account(invalid_update_attrs)
      assert account == Accounts.get_account_by_cpf(decrypted_cpf)
    end

    test "create_or_update_account/2 when updating with valid data returns the account" do
      account = account_fixture()

      decrypted_cpf = Accounts.decrypt_value(account.cpf)

      update_attrs = %{"cpf" => decrypted_cpf, "email" => "updated@email"}

      assert {:ok, updated_account} = Accounts.create_or_update_account(update_attrs)
      assert Accounts.decrypt_value(updated_account.email) == "updated@email"
    end

    test "generate_unused_referral_code/0 returns an eight digit string" do
      random_code = Accounts.generate_unused_referral_code()
      assert String.match?(random_code, ~r/[0-9]{8}/)
    end
  end
end
