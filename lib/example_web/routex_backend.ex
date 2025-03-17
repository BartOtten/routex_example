defmodule My.Attrs do
  @moduledoc false
  defstruct [:contact, :name, locale: "en-US", language: "en", discount: 0]
end

defmodule ExampleWeb.RoutexBackend do
  alias My.Attrs

  use Routex.Backend,
    extensions: [
      Routex.Extension.AttrGetters,
      Routex.Extension.Alternatives,
      Routex.Extension.Translations,
      Routex.Extension.Interpolation,
      #Routex.Extension.Cloak,
      Routex.Extension.AlternativeGetters,
      Routex.Extension.VerifiedRoutes,
      Routex.Extension.RouteHelpers,
      Routex.Extension.Assigns,
      Routex.Extension.LiveViewHooks,
      Routex.Extension.Plugs,
      Routex.Extension.SimpleLocale,
    ],
    alternatives_prefix: true,
    alternatives: %{
      "/" => %{
        attrs: %Attrs{name: "Worldwide", contact: "root@example.com", discount: 0.02},
        branches: %{
          "/europe" => %{
            attrs: %Attrs{
              name: "Europe",
              locale: "en_150",
              contact: "europe@example.com",
              discount: 0.16
            },
            branches: %{
              "/nl" => %{
                attrs: %Attrs{
                  name: "The Netherlands",
                  locale: "nl-NL",
                  contact: "verkoop@example.nl",
                  discount: 0.25
                }
              },
              "/be" => %{
                attrs: %Attrs{
                  name: "Belgium",
                  locale: "nl-BE",
                  contact: "handel@example.be",
                  discount: 0.5
                }
              }
            }
          },
          "/gb" => %{
            attrs: %Attrs{
              name: "Great Britain",
              locale: "en-GB",
              contact: "sales@example.com",
              discount: 0.3
            }
          }
        }
       }
      },
    translations_backend: ExampleWeb.Gettext,
    translation_backends: [Gettext: ExampleWeb.Gettext],
    locale_backends: [Cldr: Example.Cldr],
    cloak_character: ".",
    verified_sigil_routex: "~p",
    verified_sigil_phoenix: "~o",
    verified_url_routex: :url,
    verified_path_routex: :path,
    assigns: %{namespace: :namespace, attrs: [:discount, :locale, :language, :contact, :name]}
end

# defmodule ExampleWeb.RoutexCldrBackend do
#   alias My.Attrs

#   use Routex.Backend,
#     extensions: [
#       Routex.Extension.Cldr,
#       Routex.Extension.Alternatives,
#       Routex.Extension.Interpolation,
#       Routex.Extension.Translations,
#       Routex.Extension.AttrGetters,
#       Routex.Extension.AlternativeGetters,
#       Routex.Extension.VerifiedRoutes,
#       # Routex.Extension.RouteHelpers,
#       Routex.Extension.Assigns
#     ],
#     cldr_backend: Example.Cldr,
#     # Equivalent of:
#     # alternatives: %{
#     #   "/" => %{
#     #     attrs: %{language: "en", locale: "en", territory: "US"},
#     #     branches: %{
#     #       "/en" => %{language: "en", locale: "en", territory: "US"},
#     #       "/fr" => %{language: "fr", locale: "fr", territory: "FR"},
#     #       "/th" => %{language: "th", locale: "th", territory: "TH"},
#     #       "/zh" => %{language: "zh", locale: "zh", territory: "CN"}
#     #     }
#     #   }
#     # },
#     translations_backend: ExampleWeb.CldrGettext,
#     translations_domain: "cldr_routes",
#     verified_sigil_routex: "~p",
#     verified_sigil_phoenix: "~o",
#     verified_url_routex: :url,
#     verified_path_routex: :path,
#     assigns: %{namespace: :loc, attrs: [:locale, :language, :locale_name]}
# end

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
    translations_backend: ExampleWeb.AdminGettext,
    translations_domain: "admin_routes",
    verified_sigil_routex: "~p",
    verified_sigil_original: "~o",
    extensions: []
end
