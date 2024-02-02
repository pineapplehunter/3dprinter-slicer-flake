{
  description = "A very basic flake";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      cura = pkgs.appimageTools.wrapType2 rec {
        name = "cura";
        version = "5.6.0";
        src = pkgs.fetchurl {
          url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
          hash = "sha256-EHiWoNpLKHPzv6rZrtNgEr7y//iVcRYeV/TaCn8QpEA=";
        };
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
        version = "2.7.0";
        src = pkgs.fetchurl {
          url = "https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.7.0/PrusaSlicer-2.7.0+linux-x64-GTK3-202311231454.AppImage";
          hash = "sha256-pjAsfc4QnaFiuVzpcM8SdcOHLUWRWmWTse2+YwJRT+4=";
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
