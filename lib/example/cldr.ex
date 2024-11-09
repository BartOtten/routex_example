defmodule Example.Cldr do
  @moduledoc """
  Define a backend module that will host our
  Cldr configuration and public API.

  Most function calls in Cldr will be calls
  to functions on this module.
  """
  use Cldr,
    locales: ["en", "fr", "zh", "th"],
    default_locale: "en",
    providers: [Cldr.Territory, Cldr.LocaleDisplay, Cldr.Currency]
end
