defmodule UndiWeb.SurveyLive do
  use UndiWeb, :live_view

  alias Undi.Tokens


  @impl true
  def render(assigns) do
    ~H"""
    <h1>Survey</h1>
    <h2>Token: <%= @token_data.token %></h2>

        <.button phx-disable-with="Submitting..." phx-click = "submit_survey">Submit</.button>

    """
  end

  @impl true
  def mount(params, session, socket) do

    token_data = Tokens.get_token!(session["country_issued_id"])
    if token_data.token == params["token"] do

      {
        :ok,
        socket
        |> assign(:token_data, token_data)
      }
    else

      {
        :ok,
        socket
        |> redirect(to: ~p"/")

      }
    end
  end

  @impl true
  def handle_event("submit_survey", _p, socket) do
    case Tokens.update_token(socket.assigns.token_data, %{"token" => nil}) do
      {:ok, _token} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Form submitted and token deleted successfully")
          |> redirect(to: ~p"/")

        }
      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Something went wrong")
          |> assign_form(changeset)
        }
    end


  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end


end
