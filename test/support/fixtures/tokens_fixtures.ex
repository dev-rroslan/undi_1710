defmodule Undi.TokensFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Undi.Tokens` context.
  """

  @doc """
  Generate a token.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{
        expiration: ~U[2023-12-30 13:09:00Z],
        token: "some token"
      })
      |> Undi.Tokens.create_token()

    token
  end
end
