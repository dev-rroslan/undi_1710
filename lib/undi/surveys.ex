defmodule Undi.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias Undi.Repo

  alias Undi.Surveys.Survey



  @doc """
  Creates a Survey.

  ## Examples

      iex> create_survey(%{field: value})
      {:ok, %survey{}}

      iex> create_survey(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey(attrs \\ %{}) do

    %Survey{}
    |> Survey.changeset(attrs)
    |> Repo.insert()
  end


end
