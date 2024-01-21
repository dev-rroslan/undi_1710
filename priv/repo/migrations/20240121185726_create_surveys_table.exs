defmodule Undi.Repo.Migrations.CreateSurveysTable do
  use Ecto.Migration

  def change do
    execute("""
    CREATE TYPE survey_enum AS ENUM ('yes', 'no');
    """)
    create table(:surveys) do
      add :country_issued_id, :string, null: false
      add :gender, :string
      add :age, :integer
      add :sokong_fedaral, :survey_enum
      add :sokong_negeri, :survey_enum
      add :datar_padu, :survey_enum


      timestamps(type: :utc_datetime)
    end

    create unique_index(:surveys, [:country_issued_id])
  end

end
