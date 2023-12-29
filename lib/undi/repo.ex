defmodule Undi.Repo do
  use Ecto.Repo,
    otp_app: :undi,
    adapter: Ecto.Adapters.Postgres
end
