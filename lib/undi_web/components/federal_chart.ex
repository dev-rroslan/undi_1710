defmodule UndiWeb.Components.FederalChart do
  @moduledoc """
  Holds the FederalChart components
  """
  use UndiWeb, :live_component
  alias Undi.Surveys


  attr :id, :string, required: true
  attr :dataset, :list, default: []


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Sokong Fedaral
      </.header>
      <div
        id={@id}
        phx-hook="F_Chart"
        data-series={Jason.encode!(@dataset)}
      >
      </div>
    </div>
    """
  end

  @impl true
  def update(%{event: "update_f_chart"}, socket) do
    send_update_after(__MODULE__, [id: socket.assigns.id, event: "update_f_chart"], 5_000)
    filters = if socket.assigns.area do %{"area" => socket.assigns.area} else %{} end
    f_chart = Surveys.get_federal_values(filters)



    {
      :ok,
      socket
      |> push_event(
        "update-f-dataset",
        %{dataset: f_chart}
      )

    }
  end

  @impl true
  def update(assigns, socket) do
    send_update_after(__MODULE__, [id: assigns.id, event: "update_f_chart"], 5_000)

    {
      :ok,
      socket
      |> assign(assigns)
    }
  end


end
