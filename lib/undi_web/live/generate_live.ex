defmodule UndiWeb.GenerateLive do
  use UndiWeb, :live_view

  # alias Undi.Tokens.Token
  alias Undi.Tokens

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Generate Token for login to survey
      <:subtitle>We will probably obtain gender and age from MyKad</:subtitle>
    </.header>

    <div>
      <.simple_form for={@form} id="generate_link_form" phx-change="validate" phx-submit="save_token">
        <.input
          field={@form[:country_issued_id]}
          value={@form.params["country_issued_id"]}
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
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      assign(socket,
        form: to_form(%{"country_issued_id" => ""})
      )}
  end

  @impl true
  def handle_event("save_token", %{"country_issued_id" => country_issued_id} = p, socket) do
    case Tokens.create_token(p) do
      {:ok, _token} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Record created successfully")
          |> assign(:form, to_form(%{"country_issued_id" => country_issued_id}))
        }
      {:error, %Ecto.Changeset{} = changeset} ->

        {:noreply, assign_form(socket, changeset)}
    end


  end

  @impl true
  def handle_event("validate", _, socket) do

    {:noreply, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end



end
