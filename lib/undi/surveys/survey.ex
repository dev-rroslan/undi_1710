defmodule Undi.Surveys.Survey do
  use Ecto.Schema
  import Ecto.Changeset

  @survey_ans [:yes, :no]

  schema "surveys" do
    field :country_issued_id, :string
    field :gender, :string
    field :area, :string
    field :age, :integer
    field :sokong_fedaral, Ecto.Enum, values: @survey_ans, default: :no
    field :sokong_negeri, Ecto.Enum, values: @survey_ans, default: :no
    field :datar_padu, Ecto.Enum, values: @survey_ans, default: :no

    timestamps(type: :utc_datetime)
  end

  @doc false

  def changeset(survey, attrs) do
    survey
    |> cast(
         attrs,
         [
           :country_issued_id,
           :gender,
           :age,
           :sokong_fedaral,
           :sokong_negeri,
           :datar_padu,
           :area
         ]
       )
    |> validate_required(
         [
           :country_issued_id,
           :gender,
           :age,
           :sokong_fedaral,
           :sokong_negeri,
           :datar_padu,
           :area
         ]
       )
    |> validate_length(:country_issued_id, is: 12)
    |> unique_constraint([:country_issued_id])
    |> validate_format(
         :country_issued_id,
         Regex.compile!(
           "^([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])(0[1-9]|[1-9][0-9])([0-9]{4})$"
         )
       )
  end
end
