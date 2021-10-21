{ lib
, stdenv
, fetchFromGitHub
, bluez
, alsa-lib
, dbus
, libjpeg
, libpng
, libtheora
, libGL
, libtiff
, libusb1
, libdc1394
, linuxHeaders
, openal
, speex
, udev
, xlibs
, zlib
}:

stdenv.mkDerivation rec {
  pname = "Vrui";
  version = "4.6-005";

  src = fetchFromGitHub {
    owner = "KeckCAVES";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UNORCUiPhGT6MX58zESfIG1X1JMUEzOtQ+HlltXw7E0=";
  };

  patches = [
    ./0001-Fix-build-with-recent-GCC.patch
  ];

  postPatch = ''
    patchShebangs BuildRoot/*.sh

    # comparing versions with make’s expr does not work (10.3.0 < 3.0.0)
    substituteInPlace BuildRoot/SystemDefinitions \
        --replace '$(GNUC_BASEDIR)/' "" \
        --replace "SYSTEM_PACKAGE_SEARCH_PATHS = /usr/local /usr" "SYSTEM_PACKAGE_SEARCH_PATHS = $buildInputs" \
        --replace '$(shell expr `$(BASECCOMP) -dumpversion` ">=" "3.0.0")' "1" \
        --replace '$(shell expr `$(BASECCOMP) -dumpversion` ">=" "4.1.0")' "1"
  '';

  buildInputs = [
    alsa-lib
    bluez
    dbus.lib
    libjpeg
    libpng
    libtheora
    libGL
    libtiff
    libusb1
    linuxHeaders # v4l2
    libdc1394
    openal
    speex
    udev
    xlibs.libXext.dev
    xlibs.libXi.dev
    xlibs.libXrandr.dev
    zlib
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "INSTALLDIR=${placeholder "out"}"
    "USE_RPATH=0" # adds references to /build/
  ];

  meta = with lib; {
    description = "C++ software development toolkit for highly interactive virtual reality applications";
    homepage = "https://github.com/KeckCAVES/Vrui";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
  };
}
