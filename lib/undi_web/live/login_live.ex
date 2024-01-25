defmodule UndiWeb.LoginLive do
  use UndiWeb, :live_view

  alias Undi.Tokens
  alias Undi.Tokens.Token

  @impl true
  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Cara Guna Login
      <:subtitle>Agen akan buat Token menggunakan nombor MyKad, kami akan process untuk mendapatkan umur dan jantina sahaja</:subtitle>
    </.header>
    <.simple_form
      for={@form}
      id="country_issued_id_form"
      phx-change="validate"
      phx-submit="submit"
      phx-trigger-action={@trigger_submit}
      action={~p"/survey-login"}
      method="get"
    >
      <.input
        field={@form[:country_issued_id]}
        value={@form.params["country_issued_id"]}
        type="text"
        label="MyKad"
        required="true"
      />
      <:actions>
        <.button phx-disable-with="Submitting...">Login ke Survey</.button>
      </:actions>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = change(Token, %Token{})

    {
      :ok,
      socket
      |> assign_form(changeset)
      |> assign(trigger_submit: false)
    }
  end

  @impl true
  def handle_event("submit", %{"token" => token_param}, socket) do
    with %Token{token: token} when token not in [nil, ""] <-
           Tokens.get_token!(token_param["country_issued_id"]) do
      {
        :noreply,
        socket
        |> put_flash(:info, "Login successful.")
        |> assign(trigger_submit: true)
      }
    else
      _ ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           "Login failed! please make sure that MyKad is correct or the token is generated"
         )}
    end
  end

  @impl true
  def handle_event("validate", p, socket) do
    changeset =
      change(Token, %Token{}, p["token"])
      |> Map.put(:action, :validate)

    {
      :noreply,
      socket
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
