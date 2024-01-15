defmodule UndiWeb.GenerateLive do
  use UndiWeb, :live_view

  # alias Undi.Tokens.Token
  alias Undi.Tokens

  def render(assigns) do
    ~H"""
    <.header>
      Generate Token for login to survey
      <:subtitle>From ID we will obtain your age and gender</:subtitle>
    </.header>

    <div>
      <.simple_form for={@form} id="generate_link_form" phx-change="validate" phx-submit="save_token">
        <.input
          field={@form[:country_issued_id]}
          value={@form.params.country_issued_id}
          type="text"
          label="MyKad"
        />

        <:actions>
          <.button phx-disable-with="Generating...">Generate Token</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       form: to_form(%{country_issued_id: ""})
     )}
  end

  def handle_event("save_token", %{"country_issued_id" => country_issued_id}, socket) do
    Tokens.create_token()

    {:noreply,
     assign(socket,
       form: to_form(%{country_issued_id: socket.assigns.form.country_issued_id})
     )}
  end
end
