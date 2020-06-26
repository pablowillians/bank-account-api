defmodule BankAccountWeb.UserControllerTest do
  use BankAccountWeb.ConnCase

  alias BankAccount.Accounts

  @create_attrs %{
    email: "some@email",
    password: "some password",
    password_confirmation: "some password"
  }
  @invalid_attrs %{email: nil, password_hash: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :sign_up), user: @create_attrs)

      assert %{
               "jwt" => jwt_token
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :sign_up), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
