defmodule Auth1.Repo do
  use Ecto.Repo,
    otp_app: :auth1,
    adapter: Ecto.Adapters.Postgres
end
