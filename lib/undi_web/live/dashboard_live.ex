defmodule UndiWeb.DashboardLive do
  use UndiWeb, :live_view

  alias Undi.Surveys

  @topic inspect(__MODULE__)

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Survey Dashboard
      <.link
        class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-1 px-2 text-sm text-white active:text-white/80 float-right font-semibold
    "
        phx-click="see_more_charts"
        phx-value-key="true"
      >
        See more
      </.link>
      <:subtitle>Visualize Realtime Analytics for Surveys</:subtitle>
    </.header>
    <h5>Total surveys: <%= @total_surveys %></h5>

    <p class="text-center text-sm">
      <b>Age and Gender</b>
    </p>
    <.live_component
      module={UndiWeb.Components.Charts}
      id="line-chart-1"
      height={420}
      width={640}
      dataset={[
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
    <.modal :if={@key == "true"} id="my-modal" show on_cancel={JS.navigate(~p"/survey-dashboard")}>
      <.live_component
        module={UndiWeb.Components.FederalChart}
        id="chart"
        height={300}
        width={300}
        dataset={@f_chart}
      />

    <.live_component
        module={UndiWeb.Components.NegeriChart}
        id="n_chart"
        height={300}
        width={300}
        dataset={@n_chart}
      />
    </.modal>

    """
  end

  @impl true
  def mount(_params, session, socket) do
    {total, males_count, females_count, data} = Surveys.get_filtered_surveys_by_age()
    categories = ["18-30", "31-45", "46-60", "61 & Above"]
    Phoenix.PubSub.subscribe(Undi.PubSub, @topic, link: true)

    {
      :ok,
      socket
      |> assign(:user_token, session["user_token"])
      |> assign(:males, males_count)
      |> assign(:females, females_count)
      |> assign(:categories, categories)
      |> assign(:question, data)
      |> assign(:total_surveys, total)
      |> assign(:key, false)
      |> assign(:f_chart, [])
      |> assign(:n_chart, [])
    }
  end

  @impl true
  def handle_event("see_more_charts", %{"key" => key}, socket) do
    key = if key != socket.assigns.key, do: key
    f_chart = Surveys.get_federal_values()
    n_chart = Surveys.get_negeri_values()

    {
      :noreply,
      socket
      |> assign(:key, key)
      |> assign(:f_chart, f_chart)
      |> assign(:n_chart, n_chart)
    }
  end

  @impl true
  def handle_info(_msg, socket) do
    {
      :noreply,
      socket
      |> assign(:total_surveys, socket.assigns.total_surveys + 1)
    }
  end
end
