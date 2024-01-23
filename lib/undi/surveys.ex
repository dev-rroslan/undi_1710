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


  def get_filtered_surveys_by_age() do
    one = Repo.one(
      from s in Survey,
      where: s.age >= 18 and s.age <= 30,
      select: count(s.id)
    )
    two = Repo.one(
      from s in Survey,
      where: s.age >= 31 and s.age <= 45,
      select: count(s.id)
    )
    three = Repo.one(
      from s in Survey,
      where: s.age >= 45 and s.age <= 60,
      select: count(s.id)
    )
    four = Repo.one(
      from s in Survey,
      where: s.age >= 61,
      select: count(s.id)
    )
    total = Repo.one(
      from s in Survey,
      select: count(s.id)
    )
    {
      total,
      [
        %{
          name: "Age",
          data: [
            %{
              x: "18-30",
              y: one
            },
            %{
              x: "31-45",
              y: two
            },
            %{
              x: "46-60",
              y: three
            },
            %{
              x: "61 and Above",
              y: four
            }
          ]
        }
      ]
    }

  end
  def get_filtered_surveys_by_gender() do
   male =  Repo.one(
      from s in Survey,
      where: s.gender in ["male", "Male"],
      select: count(s.id)
    )
 female =  Repo.one(
      from s in Survey,
      where: s.gender in ["female", "Female"],
      select: count(s.id)
    )

   [
     %{
       name: "Gender",
       data: [
         %{
           x: "Male",
           y: male
         },
         %{
           x: "Female",
           y: female
         }
       ]
     }
   ]

  end


end
