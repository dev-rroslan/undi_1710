defmodule UndiWeb.SurveyLive do
  use UndiWeb, :live_view

  def fetch_token() do
    token = :ets.lookup(:token_table, nil)
    {:ok, token}
  end



  def mount(_params, _session, socket) do
    token = fetch_token()

    {:ok, assign(socket, :token, token)}
  end


  def render(assigns) do
    ~H"""
    <h1>Survey</h1>
    <h2>Token: <%= @token %></h2>
    """
  end
end
