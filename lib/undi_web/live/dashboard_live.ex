defmodule UndiWeb.DashboardLive do
  use UndiWeb, :live_view

  alias Undi.Surveys
  import UndiWeb.Components.Charts

  @impl true
  def render(assigns) do
    ~H"""
        <.header>
        Survey Dashboard
      <:subtitle>Visualize Realtime Analytics for Surveys</:subtitle>
    </.header>
           <h5>Total surveys: <%=@total_surveys %></h5>

    <p class="text-center text-sm">
       Age
      </p>
    <.line_graph
    id="line-chart-1"
    height={300}
    width={540}
    dataset={@data_set_for_age}
    />

    <p class="text-center text-sm">
       Gender
      </p>
    <.line_graph
    id="line-chart-121"
    height={300}
    width={540}
    dataset={@data_set_for_gender}
    />

    """
  end
  @impl true
  def mount(_params, session, socket) do

    {total, data_set_for_age} = Surveys.get_filtered_surveys_by_age()
    data_set_for_gender = Surveys.get_filtered_surveys_by_gender()


    {
      :ok,
      socket
      |> assign(:user_token, session["user_token"])
      |> assign(:data_set_for_age, data_set_for_age)
      |> assign(:data_set_for_gender, data_set_for_gender)
      |> assign(:total_surveys, total)

    }
  end




end
