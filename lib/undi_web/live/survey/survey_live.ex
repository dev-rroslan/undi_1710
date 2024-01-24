defmodule UndiWeb.SurveyLive do
  use UndiWeb, :live_view

  alias Undi.Tokens
  alias Undi.Surveys
  alias Undi.Surveys.Survey

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-center text-blue-800">Survey</h1>
    <%!-- <h2>Token: <%= @token_data.token %></h2> --%>
    <%!-- <h3>Country Issued Id: <%= @token_data.country_issued_id %></h3> --%>
    <h3>Jantina: <%= @gender %></h3>
    <h3>Umur: <%= @age %></h3>

       <.simple_form for={@form} id="generate_link_form" phx-change="validate" phx-submit="submit_survey" style ="margin-top: -25px;" >

                <fieldset  style = "height: 50px;">
    <p class="text-left text-sm">
       Sokong Kerajaan Federal
      </p>
      <div class="grid gap-4 grid-cols-3 grid-rows-3">
            <.input field={@form[:sokong_fedaral]}
              id="show_as_yes"
              type="radio"
              label="Ya"
              value="yes"
              checked={(@form[:sokong_fedaral].value == :yes) || (@form.params["sokong_fedaral"] == "yes")}
            />
        <.input field={@form[:sokong_fedaral]}
              id="show_as_no"
              type="radio"
              label="Tidak"
              value="no"
              checked={(@form[:sokong_fedaral].value == :no) || (@form.params["sokong_fedaral"] == "no")}
            />
    </div>
          </fieldset>

             <fieldset   style = "height: 50px;">
    <p class="text-left text-sm">
       Sokong Kerajaan Negeri
      </p>
      <div class="grid gap-4 grid-cols-3 grid-rows-3">
            <.input field={@form[:sokong_negeri]}
              id="show_as_yes"
              type="radio"
              label="Ya"
              value="yes"
              checked={(@form[:sokong_negeri].value == :yes) || (@form.params["sokong_negeri"] == "yes")}
            />
        <.input field={@form[:sokong_negeri]}
              id="show_as_no"
              type="radio"
              label="Tidak"
              value="no"
              checked={(@form[:sokong_negeri].value == :no) || (@form.params["sokong_negeri"] == "no")}
            />
    </div>
          </fieldset>

             <fieldset style = "height: 50px;">
    <p class="text-left text-sm">
       Daftar PADU
      </p>
      <div class="grid gap-4 grid-cols-3 grid-rows-3">
            <.input field={@form[:datar_padu]}
              id="show_as_yes"
              type="radio"
              label="Ya"
              value="yes"
              checked={(@form[:datar_padu].value == :yes) || (@form.params["datar_padu"] == "yes")}
            />
        <.input field={@form[:datar_padu]}
              id="show_as_no"
              type="radio"
              label="Tidak"
              value="no"
              checked={(@form[:datar_padu].value == :no) || (@form.params["datar_padu"] == "no")}
            />
    </div>
    </fieldset>
        <:actions>
              <.button phx-disable-with="Submitting...">Hantar</.button>
        </:actions>
      </.simple_form>

    """
  end

  @impl true
  def mount(params, session, socket) do
    changeset = change(Survey, %Survey{})
    token_data = Tokens.get_token!(session["country_issued_id"])
    if token_data.token == params["token"] do
      gender = find_gender(token_data)
      age = find_age(token_data)

      {
        :ok,
        socket
        |> assign(:token_data, token_data)
        |> assign(:gender, gender)
        |> assign(:age, age)
        |> assign_form(changeset)

      }
    else

      {
        :ok,
        socket
        |> redirect(to: ~p"/")

      }
    end
  end

  @impl true
  def handle_event("submit_survey", %{"survey" => survey} = _p, socket) do
    survey_params = Map.merge(
      survey,
      %{
        "country_issued_id" => socket.assigns.token_data.country_issued_id,
        "gender" => socket.assigns.gender,
        "age" => socket.assigns.age
      }
    )
    with {:ok, survey} <- Surveys.create_survey(survey_params),
         {:ok, _token} <- Tokens.update_token(socket.assigns.token_data, %{"token" => nil}) do
      Phoenix.PubSub.broadcast(Undi.PubSub, "UndiWeb.DashboardLive", survey)

      {
        :noreply,
        socket
        |> put_flash(:info, "Form submitted successfully")
        |> redirect(to: ~p"/")

      }
    else

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Something went wrong")
          |> assign_form(changeset)
        }
    end


  end

  @impl true
  def handle_event("validate", p, socket) do
    changeset = change(Survey, %Survey{}, p["survey"])
                |> Map.put(:action, :validate)
    {
      :noreply,
      socket
      |> assign_form(changeset)
    }
  end


  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp find_age(token_data) do
    date_of_birth_string = String.slice(token_data.country_issued_id, 0..5)
    year = String.slice(date_of_birth_string, 0, 2)
    current_date = Date.utc_today()
    current_year = current_date.year()
    current_year_last_2_digits = String.slice(Integer.to_string(current_year), 2..4)
    century =
      if year <= current_year_last_2_digits do
        "20"
      else
        "19"
      end
    formatted_date_string = century <> String.replace(date_of_birth_string, ~r/(.{2})(?=.)/, "\\1-")
    dob_date = Date.from_iso8601!(formatted_date_string)
    age_in_days = Date.diff(current_date, dob_date)
    _age_in_years = div(age_in_days, 365)

  end

  defp find_gender(token_data) do
    String.at(token_data.country_issued_id, String.length(token_data.country_issued_id) - 1)
    |> String.to_integer()
    |> is_even_or_odd()
  end

  defp is_even_or_odd(number) do
    if rem(number, 2) == 0 do
      "Female" #even
    else
      "Male" #odd
    end
  end
  defp change(model, data, attrs \\ %{}) do
    model.changeset(data, attrs)
  end

end
