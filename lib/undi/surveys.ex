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
    one_male_query =
      from s in Survey,
           where: s.age >= 18 and s.age <= 30 and s.gender in ["male", "Male"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_one_male =
      one_male_query
      |> Repo.aggregate(:count, :id)

    one_male =
      one_male_query
      |> Repo.all()
      |> count_yes_no()

    one_female_query =
      from s in Survey,
           where: s.age >= 18 and s.age <= 30 and s.gender in ["female", "Female"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_one_female =
      one_female_query
      |> Repo.aggregate(:count, :id)

    one_female =
      one_female_query
      |> Repo.all()
      |> count_yes_no()

    two_male_query =
      from s in Survey,
           where: s.age >= 31 and s.age <= 45 and s.gender in ["male", "Male"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_two_male =
      two_male_query
      |> Repo.aggregate(:count, :id)

    two_male =
      two_male_query
      |> Repo.all()
      |> count_yes_no()

    two_female_query =
      from s in Survey,
           where: s.age >= 31 and s.age <= 45 and s.gender in ["female", "Female"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_two_female =
      two_female_query
      |> Repo.aggregate(:count, :id)

    two_female =
      two_female_query
      |> Repo.all()
      |> count_yes_no()

    three_male_query =
      from s in Survey,
           where: s.age >= 45 and s.age <= 60 and s.gender in ["male", "Male"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_three_male =
      three_male_query
      |> Repo.aggregate(:count, :id)

    three_male =
      three_male_query
      |> Repo.all()
      |> count_yes_no()

    three_female_query =
      from s in Survey,
           where: s.age >= 45 and s.age <= 60 and s.gender in ["female", "Female"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_three_female =
      three_female_query
      |> Repo.aggregate(:count, :id)

    three_female =
      three_female_query
      |> Repo.all()
      |> count_yes_no()

    four_male_query =
      from s in Survey,
           where: s.age >= 61 and s.gender in ["male", "Male"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_four_male =
      four_male_query
      |> Repo.aggregate(:count, :id)

    four_male =
      four_male_query
      |> Repo.all()
      |> count_yes_no()

    four_female_query =
      from s in Survey,
           where: s.age >= 61 and s.gender in ["female", "Female"],
           select: %{
             id: s.id,
             sokong_fedaral: s.sokong_fedaral,
             sokong_negeri: s.sokong_negeri,
             daftar_padu: s.datar_padu
           }

    count_four_female =
      four_female_query
      |> Repo.aggregate(:count, :id)

    four_female =
      four_female_query
      |> Repo.all()
      |> count_yes_no()

    males_count = [count_one_male] ++ [count_two_male] ++ [count_three_male] ++ [count_four_male]

    females_count =
      [count_one_female] ++ [count_two_female] ++ [count_three_female] ++ [count_four_female]

    data = [
      one_male,
      two_male,
      three_male,
      four_male,
      one_female,
      two_female,
      three_female,
      four_female
    ]

    total =
      Repo.one(
        from s in Survey,
        select: count(s.id)
      )

    {
      total,
      males_count,
      females_count,
      data
    }
  end

  def count_yes_no(maps) do
    fields = [:daftar_padu, :sokong_fedaral, :sokong_negeri]

    maps
    |> Enum.reduce(
         %{},
         fn map, acc ->
           fields
           |> Enum.reduce(
                acc,
                fn field, acc ->
                  counts = Map.get(acc, field, %{"yes" => 0, "no" => 0})

                  updated_counts =
                    Map.put(counts, to_string(map[field]), counts[to_string(map[field])] + 1)

                  Map.put(acc, field, updated_counts)
                end
              )
         end
       )
  end

  def get_federal_values() do
    fedaral_male_no = Repo.one(
      from s in Survey,
      where: s.gender in ["male", "Male"] and s.sokong_fedaral == :no,
      select: count(s.id)
    )
    fedaral_male_yes = Repo.one(
      from s in Survey,
      where: s.gender in ["male", "Male"] and s.sokong_fedaral == :yes,
      select: count(s.id)
    )
    fedaral_female_no = Repo.one(
      from s in Survey,
      where: s.gender in ["female", "Female"] and s.sokong_fedaral == :no,
      select: count(s.id)
    )
    fedaral_female_yes = Repo.one(
      from s in Survey,
      where: s.gender in ["female", "Female"] and s.sokong_fedaral == :yes,
      select: count(s.id)
    )
    [fedaral_male_no, fedaral_male_yes, fedaral_female_no, fedaral_female_yes]

  end

  def get_negeri_values() do
    negeri_male_no = Repo.one(
      from s in Survey,
      where: s.gender in ["male", "Male"] and s.sokong_negeri == :no,
      select: count(s.id)
    )
    negeri_male_yes = Repo.one(
      from s in Survey,
      where: s.gender in ["male", "Male"] and s.sokong_negeri == :yes,
      select: count(s.id)
    )
    negeri_female_no = Repo.one(
      from s in Survey,
      where: s.gender in ["female", "Female"] and s.sokong_negeri == :no,
      select: count(s.id)
    )
    negeri_female_yes = Repo.one(
      from s in Survey,
      where: s.gender in ["female", "Female"] and s.sokong_negeri == :yes,
      select: count(s.id)
    )
    [negeri_male_no, negeri_male_yes, negeri_female_no, negeri_female_yes]

  end
end
