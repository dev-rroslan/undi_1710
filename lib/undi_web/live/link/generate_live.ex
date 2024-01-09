defmodule UndiWeb.GenerateLive do
  use UndiWeb, :live_view

  # alias Undi.Tokens.Token
  alias Undi.Tokens

  def render(assigns) do
    ~H"""
    <.simple_form phx-submit="generate_link" for={@form}>
      <.input field={@form[:country_issued_id]} value="" placeholder="No Card IC" required />
      <.button type="submit">Generate Link</.button>
    </.simple_form>
    <%= @link %>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       form: to_form(%{}),
       token: "",
       link: ""
     )}
  end

  def handle_event("generate_link", %{"country_issued_id" => country_issued_id}, socket) do
    # token = Tokens.generate_token()

    case Tokens.create_token() do
      {:ok, token} ->
        base_url = Application.get_env(:undi_web, :base_url) || "http://localhost:4000"
        link = base_url <> "/survey/:token=#{token}"
        {:noreply, assign(socket, link: link, token: token, country_issued_id: country_issued_id)}

      {:error, _changeset} ->
        IO.inspect("Errors: #{Enum.at(@errors, 0)[1]}")
    end
  end


end
