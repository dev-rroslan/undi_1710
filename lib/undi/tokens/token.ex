defmodule Undi.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :country_issued_id, :string
    field :token, :string
    field :expiration, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:country_issued_id, :token, :expiration])
    |> validate_required([:country_issued_id, :token, :expiration])
    |> validate_length(:token, min: 1)
  end

end
