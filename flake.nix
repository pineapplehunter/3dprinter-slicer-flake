{
  description = "A very basic flake";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      cura =
        let
          version = "5.6.0";
          icon = pkgs.fetchurl {
            name = "cura-icon.png";
            url = "https://github.com/Ultimaker/Cura/blob/${version}/resources/images/cura-icon.png?raw=true";
            hash = "sha256-4M8a6Ppz8zJu0F9iMSN1v4MTno5DVsg3A3DggPzinyw=";
          };
          cura-wrapped = pkgs.appimageTools.wrapType2 {
            name = "cura";
            src = pkgs.fetchurl {
              url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
              hash = "sha256-EHiWoNpLKHPzv6rZrtNgEr7y//iVcRYeV/TaCn8QpEA=";
            };
          };
          cura-desktop = pkgs.writeTextDir "share/applications/cura.desktop" ''
            [Desktop Entry]
            Version=1
            Type=Application
            Name=Cura
            Terminal=false
            Exec=${cura-wrapped}/bin/cura
            Icon=${icon}
          '';
        in
        pkgs.symlinkJoin {
          inherit (cura-wrapped) pname name;
          inherit version;
          paths = [ cura-wrapped cura-desktop ];
          passAsFile = [ "desktopEntry" ];
          passthru = { inherit cura-wrapped; };
        };


      creality-print = pkgs.appimageTools.wrapType2 {
        name = "creality-print";
        version = "4.3.6";
        src = pkgs.fetchurl {
          url = "https://github.com/CrealityOfficial/CrealityPrint/releases/download/v4.3.7/Creality_Print-v4.3.7.6631-x86_64-Release.AppImage";
          hash = "sha256-zc4qmPxZZLx6iCmG0YVhXCtse9prULPGoRymE/ZiG2A=";
        };
      };

      prusaslicer = pkgs.appimageTools.wrapType2 {
        name = "prusaslicer";
        version = "2.7.1";
        src = pkgs.fetchurl {
          url = "https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.7.1/PrusaSlicer-2.7.1+linux-x64-GTK3-202312121425.AppImage";
          hash = "sha256-HacdVkqFagts0Uo2MLqn0999NvZL/aKtl9nSVlfQkG8=";
        };
      };
    in
    {
      packages.x86_64-linux = {
        inherit cura creality-print prusaslicer;
      };
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };

}
