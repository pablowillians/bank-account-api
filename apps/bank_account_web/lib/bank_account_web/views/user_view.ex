defmodule BankAccountWeb.UserView do
  use BankAccountWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
