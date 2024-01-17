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
    |> validate_length(:country_issued_id, is: 12)
    |> unique_constraint([:country_issued_id])
    |> validate_format(
      :country_issued_id,
      Regex.compile!("^([0-9]{2})(0[1-9]|1[0-2])([1-3]{2})([01-6]{2})([0-9]{4})([0-9]{3})$")
    )
  end

end
