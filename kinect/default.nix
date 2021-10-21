{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
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
  pname = "Kinect";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "KeckCAVES";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JNxkfzo5PlzDc4mpnME0ijkdokznCN5E+Lagao4qJzw=";
  };

  postPatch = ''
    substitute ${vrui}/share/make/Configuration.Vrui Configuration.Vrui \
        --replace "${vrui}" "${placeholder "out"}"

    substituteInPlace makefile \
        --replace '$(VRUI_MAKEDIR)/Configuration.Vrui' "Configuration.Vrui"

    cat Configuration.Vrui
  '';

  buildInputs = [
    alsa-lib
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
    vrui
    xlibs.libXi.dev
    xlibs.libXrandr.dev
    zlib
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "VRUI_MAKEDIR=${vrui}/share/make"
  ];

  meta = with lib; {
    description = "Kinect 3D Video Capture Project";
    homepage = "https://github.com/KeckCAVES/Kinect";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
  };
}
