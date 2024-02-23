defmodule ExampleWeb.ProductLive.Index do
  use ExampleWeb, :live_view

  alias Example.Store
  alias Example.Store.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Store.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("redirect", _, socket) do
    IO.puts(["Redirecting from `", url(~p"/products"), "` to `", url(~p"/"), "`"])

    {:noreply, redirect(socket, external: url(~p"/"))}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    product = Store.get_product!(id)
    {:ok, _} = Store.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Store.list_products()
  end
end
