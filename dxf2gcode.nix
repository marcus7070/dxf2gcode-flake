{
  lib
  , fetchgit
  , python3Packages
  , poppler_utils
  , pstoedit
  , mkDerivationWith
  , wrapQtAppsHook
  , qt5Full
  , src
}:

mkDerivationWith python3Packages.buildPythonApplication {

  pname = "dxf2gcode";
  version = "20190103";

  inherit src;

  nativeBuildInputs = [
    wrapQtAppsHook
    qt5Full
  ];

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    pyopengl
    poppler_utils
    pstoedit
    configobj
  ];

  preBuild = ''
    export PATH=${python3Packages.pyqt5}/bin/:$PATH
    cd source
    python ./make_tr.py
    python ./make_py_uic.py
    cp ./st-setup.py ./setup.py
  '';

  # crashes when trying to use Wayland, so force xcb
  qtWrapperArgs = [ "--set QT_QPA_PLATFORM xcb" ];

  postFixup = ''
    wrapQtApp "$out/bin/dxf2gcode"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Tool for converting 2D (dxf, pdf, ps) drawings to CNC machine compatible GCode";
    homepage = "https://sourceforge.net/projects/dxf2gcode/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marcus7070 ];
  };

}
