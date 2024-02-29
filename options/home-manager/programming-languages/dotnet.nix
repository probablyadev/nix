{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dotnet;
in
{
  # meta.maintainers = [ maintainers.probablyadev ];

  options.programs.dotnet = {
    enable = mkEnableOption "Enable .NET SDK";

    package = mkOption {
      type = types.package;
      default = pkgs.dotnetCorePackages.sdk_8_0;
      description = "Package providing {command}`dotnet`.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      DOTNET_SYSTEM_NET_HTTP_SOCKETSHTTPHANDLER_HTTP3SUPPORT = "1";
      DOTNET_NOLOGO = "1";
    };
  };
}