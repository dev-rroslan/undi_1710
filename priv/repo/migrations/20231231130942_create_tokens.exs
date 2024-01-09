defmodule Undi.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :country_issued_id, :string, null: false
      add :token, :string
      add :expiration, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tokens, [:country_issued_id])
    create index(:tokens, [:expiration])
  end

end
