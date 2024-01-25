defmodule UndiWeb.Components.NegeriChart do
  @moduledoc """
  Holds the FederalChart components
  """
  use UndiWeb, :live_component

  attr :id, :string, required: true
  attr :dataset, :list, default: []


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Sokong Negeri
      </.header>
      <div
        id={@id}
          phx-hook="N_Chart"
        data-series={Jason.encode!(@dataset)}
      >
      </div>
    </div>
    """
  end

  @impl true
  def update(%{event: "update_n_chart"}, socket) do
    send_update_after(__MODULE__, [id: socket.assigns.id, event: "update_n_chart"], 5_000)
    n_chart = Undi.Surveys.get_federal_values()


    {
      :ok,
      socket
      |> push_event(
        "update-n-dataset",
        %{dataset: n_chart}
      )

    }
  end

  @impl true
  def update(assigns, socket) do
    send_update_after(__MODULE__, [id: assigns.id, event: "update_n_chart"], 5_000)

    {
      :ok,
      socket
      |> assign(assigns)
    }
  end


end
