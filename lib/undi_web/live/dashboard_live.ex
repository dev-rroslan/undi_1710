defmodule UndiWeb.DashboardLive do
  use UndiWeb, :live_view

  alias Undi.Surveys
  alias Undi.Area

  @topic inspect(__MODULE__)

  @impl true
  def render(assigns) do
    ~H"""
    <div  style = "margin-top: -30px;">
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
    </div>
    <div style =
    "display: flex;
        align-items: center;
    justify-content: space-between;">
    <h5>Total surveys: <%= @total_surveys %></h5>

      <.simple_form
    for={%{}} as={:area}
    id="area-form"
    name="any"
    phx-change="filter_by_area"
     style = "margin-top: -40px;"
    >
    <.input
      class="max-w-xs"  style="width: 180px;"
      name="area"
      value={assigns[:area]}
      type="select"
      options={@areas}
      prompt={gettext("Filter by area")}
    />
    </.simple_form>
    </div>
    <.live_component
      module={UndiWeb.Components.Charts}
      id="line-chart-1"
      height={420}
      width={640}
      area= {@area}
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
       area= {@area}
        dataset={@f_chart}
      />

    <.live_component
        module={UndiWeb.Components.NegeriChart}
        id="n_chart"
        height={300}
        width={300}
       area= {@area}
        dataset={@n_chart}
      />
    </.modal>

    """
  end

  @impl true
  def mount(_params, session, socket) do
    {total, males_count, females_count, data} = Surveys.get_filtered_surveys_by_age()
    categories = ["18-30", "31-45", "46-60", "61 & Above"]
    areas =
      Enum.reduce(
        Area.areas_list(),
        [],
        fn {key, _value}, acc ->
          acc ++ [key]
        end
      )
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
      |> assign(:areas, areas)
      |> assign(:area, socket.assigns[:area])
    }
  end

  @impl true
  def handle_event("see_more_charts", %{"key" => key}, socket) do
    key = if key != socket.assigns.key, do: key
    filters = if socket.assigns.area do %{"area" => socket.assigns.area} else %{} end
    f_chart = Surveys.get_federal_values(filters)
    n_chart = Surveys.get_negeri_values(filters)


    {
      :noreply,
      socket
      |> assign(:key, key)
      |> assign(:f_chart, f_chart)
      |> assign(:n_chart, n_chart)
    }
  end

  @impl true
  def handle_event("filter_by_area", p, socket) do

    {total, males_count, females_count, data} = Surveys.get_filtered_surveys_by_age(%{"area" => p["area"]})


    send_update(UndiWeb.Components.Charts, [id: "line-chart-1", event: "update_chart"])

    dataset = [
      %{
        name: "Males",
        data: males_count
      },
      %{
        name: "Females",
        data: females_count
      }
    ]

    {
      :noreply,
      socket
      |> push_event(
           "update-dataset",
           %{dataset: dataset, question: data}
         )
      |> assign(:area, p["area"])
      |> assign(:males, males_count)
      |> assign(:females, females_count)
      |> assign(:question, data)
      |> assign(:total_surveys, total)


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
