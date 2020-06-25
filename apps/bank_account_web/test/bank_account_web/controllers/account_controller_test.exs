defmodule BankAccountWeb.AccountControllerTest do
  use BankAccountWeb.ConnCase

  alias BankAccount.Accounts

  @create_attrs %{
    birth_date: "2010-04-17",
    city: "some city",
    country: "some country",
    cpf: Brcpfcnpj.cpf_generate(),
    email: "some@email",
    gender: "some gender",
    name: "some name",
    referral_code: "18273645",
    state: "some state",
    status: true
  }
  @update_attrs %{
    birth_date: "2011-05-18",
    city: "some updated city",
    country: "some updated country",
    cpf: Brcpfcnpj.cpf_generate(),
    email: "some_updated@email",
    gender: "some updated gender",
    name: "some updated name",
    referral_code: "81726354",
    state: "some updated state",
    status: false
  }
  @invalid_attrs %{birth_date: nil, city: nil, country: nil, cpf: nil, email: nil, gender: nil, name: nil, referral_code: nil, state: nil, status: nil}

  def fixture(:account) do
    {:ok, account} = Accounts.create_account(@create_attrs)
    account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create_or_update), account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      assert %{
               "id" => id,
               "birth_date" => "2010-04-17",
               "city" => "some city",
               "country" => "some country",
               "cpf" => cpf,
               "email" => "some@email",
               "gender" => "some gender",
               "name" => "some name",
               "referral_code" => referral_code,
               "state" => "some state",
               "status" => true
             } = json_response(conn, 201)["data"]
      assert cpf == @create_attrs.cpf
      assert String.match?(referral_code, ~r/[0-9]{8}/)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create_or_update), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account" do
    setup [:create_account]

    test "renders account when data is valid", %{conn: conn} do
      update_attrs = Map.delete(@update_attrs, "status")
      conn = post(conn, Routes.account_path(conn, :create_or_update), account: update_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      assert %{
               "id" => id,
               "birth_date" => "2011-05-18",
               "city" => "some updated city",
               "country" => "some updated country",
               "cpf" => cpf,
               "email" => "some_updated@email",
               "gender" => "some updated gender",
               "name" => "some updated name",
               "referral_code" => referral_code,
               "state" => "some updated state",
               "status" => true
             } = json_response(conn, 201)["data"]
      assert cpf == @update_attrs.cpf
      assert String.match?(referral_code, ~r/[0-9]{8}/)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create_or_update), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_account(_) do
    account = fixture(:account)
    %{account: account}
  end
end
