defmodule My.Attrs do
  @moduledoc false
  defstruct [:contact, :name, locale: "en"]
end

defmodule ExampleWeb.RoutexBackend do
  alias My.Attrs

  use Routex.Backend,
    extensions: [
      Routex.Extension.Alternatives,
      Routex.Extension.Translations,
      # Routex.Extension.Interpolation,
      # Routex.Extension.Cloak,
      Routex.Extension.AttrGetters,
      Routex.Extension.AlternativeGetters,
      Routex.Extension.VerifiedRoutes,
      Routex.Extension.RouteHelpers,
      Routex.Extension.Assigns
    ],
    alternatives_prefix: true,
    alternatives: %{
      "/" => %{
        attrs: %Attrs{name: "Worldwide", contact: "root@example.com"},
        branches: %{
          "/europe" => %{
            attrs: %Attrs{name: "Europe", contact: "europe@example.com"},
            branches: %{
              "/nl" => %{
                attrs: %Attrs{
                  name: "The Netherlands",
                  locale: "nl",
                  contact: "verkoop@example.nl"
                }
              },
              "/be" => %{
                attrs: %Attrs{name: "Belgium", locale: "nl", contact: "handel@example.be"}
              }
            }
          },
          "/gb" => %{attrs: %Attrs{name: "Great Britain", contact: "sales@example.com"}}
        }
      }
    },
    translations_backend: ExampleWeb.Gettext,
    cloak_character: ".",
    verified_sigil_routex: "~p",
    verified_sigil_phoenix: "~o",
    verified_url_routex: :url,
    verified_path_routex: :path,
    assigns: %{namespace: :loc, attrs: [:branch_helper, :locale, :contact, :name]}
end

defmodule ExampleWeb.RoutexBackendAdmin do
  alias My.Attrs

  use Routex.Backend,
    branches: %{
      "/" => %{
        attrs: %Attrs{name: "Worldwide", contact: "root_admin@example.com"},
        branches: %{
          "/europe" => %{
            attrs: %Attrs{name: "Europe", contact: "europe_admin@example.com"},
            branches: %{
              "/nl" => %{
                attrs: %Attrs{
                  name: "The Netherlands",
                  locale: "nl",
                  contact: "administratie@example.nl"
                }
              }
            }
          },
          "/gb" => %{
            attrs: %Attrs{name: "Great Britain", contact: "administration@example.com"}
          }
        }
      }
    },
    translations_backend: ExampleWeb.Gettext,
    translations_domain: "admin_routes",
    verified_sigil_routex: "~p",
    verified_sigil_original: "~o",
    extensions: []
end
