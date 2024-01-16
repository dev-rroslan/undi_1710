defmodule UndiWeb.GenerateLive do
  use UndiWeb, :live_view

   alias Undi.Tokens.Token
  alias Undi.Tokens

  @impl true
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
    changeset = change(Token, %Token{})
    {:ok,
    socket
    |> assign_form(changeset)
    }
  end

  @impl true
  def handle_event("save_token",%{"token" => token} = _p, socket) do
    case Tokens.create_token(token) do
      {:ok, token} ->
        changeset = change(Token, token)
        {
          :noreply,
          socket
          |> put_flash(:info, "Record created successfully")
          |> assign_form(changeset)
        }
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end


  end

  @impl true
  def handle_event("validate", p, socket) do
    changeset = change(Token, %Token{}, p["token"]) |> Map.put(:action, :validate)
    {:noreply, socket
    |> assign_form(changeset)
    }
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp change(model, data, attrs \\ %{}) do
    model.changeset(data, attrs)
  end

end