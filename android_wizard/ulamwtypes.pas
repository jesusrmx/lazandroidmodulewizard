unit uLamwTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TModuleType = (mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole, mtLibrary);
  TProjectModel = (
    psNewProject,         //     'Ant': please, read as "project not exists or new project"!
    psExistingProject     // 'Eclipse': please, read as "project exists!"
  );

implementation

end.

