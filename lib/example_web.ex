defmodule ExampleWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use ExampleWeb, :controller
      use ExampleWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      # Router Extension Framework
      use Routex.Router

      use Phoenix.Router, helpers: true

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: ExampleWeb,
        formats: [:html, :json],
        layouts: [html: ExampleWeb.Layouts]

      import Plug.Conn
      use Gettext, backend: ExampleWeb.Gettext

      unquote(verified_routes())
      unquote(routex_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ExampleWeb.Layouts, :app}

      unquote(html_helpers())

      on_mount(unquote(__MODULE__).Router.RoutexHelpers)
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import ExampleWeb.CoreComponents
      use Gettext, backend: ExampleWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())

      # Helper functions generated by Routex extensions
      unquote(routex_helpers())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ExampleWeb.Endpoint,
        router: ExampleWeb.Router,
        statics: ExampleWeb.static_paths()
    end
  end

  def routex_helpers do
    quote do
      import Phoenix.VerifiedRoutes,
        except: [sigil_p: 2, url: 1, url: 2, url: 3, path: 2, path: 3]

      import unquote(__MODULE__).Router.RoutexHelpers, only: :macros
      alias unquote(__MODULE__).Router.RoutexHelpers, as: Routes

      # Uncomment the next line when also using the original Phoenix Route Helpers
      # alias unquote(__MODULE__).Router.Helpers, as: OriginalRoutes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
