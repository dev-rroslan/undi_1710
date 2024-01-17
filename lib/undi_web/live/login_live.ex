defmodule UndiWeb.LoginLive do
  use UndiWeb, :live_view

  alias Undi.Tokens

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} id="country_issued_id_form" phx-submit="submit">
      <.input
        field={@form["country_issued_id"]}
        value={@form.params["country_issued_id"]}
        type="text"
        label="MyKad"
        required="true"
      />
      <:actions>
        <.button phx-disable-with="Submitting...">Login to Survey</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       form: to_form(%{"country_issued_id" => ""})
     )}
  end

  def handle_event("submit", %{"country_issued_id" => country_issued_id}, socket) do
    case Tokens.get_token!(country_issued_id) do
      {:ok, token} ->
        IO.inspect(token, label: "token")
        socket
        |> redirect(to: ~p"/survey/#{token}")
        |> put_flash(:info, "Login successful.")

        {:noreply, socket}

      {:error, _reason} ->
        socket
        |> put_flash(:error, "Login failed.")
        |> assign(:form, to_form(%{"country_issued_id" => country_issued_id}))

        {:noreply, socket}
    end
  end

  # def to_form(data) do
  # You would define the to_form/1 function here if it's not already defined.
  # This function should create a form structure that can be used by the live view
  # from the given data.
  # end
end
