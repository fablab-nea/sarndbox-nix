{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, kinect
, libGL
, libdc1394
, libjpeg
, libogg
, libpng
, libtheora
, libtiff
, libusb1
, openal
, speex
, vrui
, xlibs
, zlib
}:

stdenv.mkDerivation rec {
  pname = "SARndbox";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "KeckCAVES";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SdthILDhtIVgiDrfROIvUenxplqaENwCpC2rmF5lFEM=";
  };

  patches = [
    ./0001-Load-config-from-unprefixed-location.patch
  ];

  postPatch = ''
    substituteInPlace makefile \
        --replace '$(VRUI_MAKEDIR)/Configuration.Kinect' "${kinect}/share/make/Configuration.Kinect" \
        --replace '$(VRUI_MAKEDIR)/Packages.Kinect' "${kinect}/share/make/Packages.Kinect"
  '';

  buildInputs = [
    alsa-lib
    kinect
    libGL
    libdc1394
    libjpeg
    libogg
    libpng
    libtheora
    libtiff
    libusb1
    openal
    speex
    xlibs.libXi.dev
    xlibs.libXrandr.dev
    zlib
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "INSTALLDIR=${placeholder "out"}"
    "VRUI_MAKEDIR=${vrui}/share/make"
  ];

  meta = with lib; {
    description = "Interactive augmented reality sandbox using a Kinect 3D camera";
    homepage = "https://github.com/KeckCAVES/SARndbox";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
  };
}
