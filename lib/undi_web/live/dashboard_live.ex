defmodule UndiWeb.DashboardLive do
  use UndiWeb, :live_view

  alias Undi.Surveys

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Survey Dashboard
      <:subtitle>Visualize Realtime Analytics for Surveys</:subtitle>
    </.header>

    <p class="text-center text-sm">
      <b>Age and Gender</b>
    </p>
    <.live_component module={UndiWeb.Components.Charts}
    id="line-chart-1" height={420} width={640} dataset={[
    %{
      name: "Males",
      data: @males
    },
    %{
      name: "Females",
      data: @females
    }
    ]}
    categories={@categories}
    question={@question}

    />


    """
  end

  @impl true
  def mount(_params, session, socket) do
    {males_count,
      females_count,
     data
    } = Surveys.get_filtered_surveys_by_age()
    categories = ["18-30","31-45","46-60","61 & Above"]
    {
      :ok,
      socket
      |> assign(:user_token, session["user_token"])
      |> assign(:males, males_count)
      |> assign(:females, females_count)
      |> assign(:categories, categories)
      |> assign(:question, data)

    }
  end
end
