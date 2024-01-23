defmodule UndiWeb.Components.Charts do
  @moduledoc """
  Holds the charts components
  """
  use Phoenix.Component
  attr :id, :string, required: true
  attr :type, :string, default: "bar"
  attr :width, :integer, default: nil
  attr :height, :integer, default: 500
  attr :animated, :boolean, default: false
  attr :toolbar, :boolean, default: false
  attr :dataset, :list, default: []
  attr :categories, :list, default: []
  attr :question, :list, default: []

  def line_graph(assigns) do
    ~H"""
    <div
      id={@id}
      class="container mx-auto p-4 overflow-hidden sm:p-6 lg:p-8"
      phx-hook="Chart"
      data-config={Jason.encode!(trim %{
        height: @height,
        width: @width,
        type: @type,
        animations: %{
          enabled: @animated
        },
        toolbar: %{
          show: @toolbar
        }
      })}
      data-series={Jason.encode!(@dataset)}
      data-categories={Jason.encode!(@categories)}
      data-question={Jason.encode!(@question)}
    >
     <div class="w-full h-full border border-gray-200 rounded-md sm:block">
      </div>
    </div>
    """
  end

  defp trim(map) do
    Map.reject(map, fn {_key, val} -> is_nil(val) || val == "" end)
  end
  end