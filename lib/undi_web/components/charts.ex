defmodule UndiWeb.Components.Charts do
  @moduledoc """
  Holds the charts components
  """
  use UndiWeb, :live_component

  attr :id, :string, required: true
  attr :type, :string, default: "bar"
  attr :width, :integer, default: nil
  attr :height, :integer, default: 500
  attr :animated, :boolean, default: false
  attr :toolbar, :boolean, default: false
  attr :dataset, :list, default: []
  attr :categories, :list, default: []
  attr :question, :list, default: []

  @impl true
  def render(assigns) do
    ~H"""
    <div>
        <h3 style = "text-align: center; margin-top: 20px;">Age and Gender</h3>
    <div
      id={@id}
      class="container mx-auto p-4 overflow-hidden sm:p-6 lg:p-8"
      phx-hook="Chart"
      data-config={
        Jason.encode!(
          trim(%{
            height: @height,
            width: @width,
            type: @type,
            animations: %{
              enabled: @animated
            },
            toolbar: %{
              show: @toolbar
            }
          })
        )
      }
      data-series={Jason.encode!(@dataset)}
      data-categories={Jason.encode!(@categories)}
      data-question={Jason.encode!(@question)}
    >
    </div>
    </div>
    """
  end

  @impl true
  def update(%{event: "update_chart"}, socket) do
    send_update_after(__MODULE__, [id: socket.assigns.id, event: "update_chart"], 10_000)
    filter = if socket.assigns.area do
      %{"area" => socket.assigns.area}
    else
      %{}
    end

    {total, males_count, females_count, data} = Undi.Surveys.get_filtered_surveys_by_age(filter)

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
      :ok,
      socket
      |> push_event(
           "update-dataset",
           %{dataset: dataset, question: data}
         )
      |> assign(:males, males_count)
      |> assign(:females, females_count)
      |> assign(:question, data)
      |> assign(:total, total)
    }
  end

  @impl true
  def update(assigns, socket) do
    send_update_after(__MODULE__, [id: assigns.id, event: "update_chart"], 10_000)

    {
      :ok,
      socket
      |> assign(assigns)
    }
  end

  defp trim(map) do
    Map.reject(map, fn {_key, val} -> is_nil(val) || val == "" end)
  end
end
