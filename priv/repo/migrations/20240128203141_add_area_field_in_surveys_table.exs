defmodule Undi.Repo.Migrations.AddAreaFieldInSurveysTable do
  use Ecto.Migration

  def change do
    alter table(:surveys) do
      add :area, :string

    end
    create index(:surveys, [:area])

  end
end
