defmodule BankAccountWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :bank_account,
  module: BankAccount.Guardian,
  error_handler: BankAccountWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
