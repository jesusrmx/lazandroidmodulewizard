unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
  Classes, SysUtils, FileUtil, Controls, Forms, Dialogs, Graphics, laz2_XMLRead, Laz2_DOM,
  LCLProc, LCLType, LCLIntf, LazIDEIntf, ProjectIntf, uLamwTypes, uLamwProcs,
  FormEditingIntf, uFormAndroidProject, uformworkspace, FPimage, AndroidWidget, gdxform;

type

  TAndroidModule = class(jForm)            //support to Android Bridges [components]
  end;

  TGdxModule = class(jGdxForm)            //support to Android libGDX [components]
  end;

  TNoGUIAndroidModule = class(TDataModule) //raw JNI ".so"
  end;


  TAndroidConsoleDataForm = class(TDataModule) // executable console app
  end;

  { TAndroidProjectDescriptor }

  TAndroidProjectDescriptor = class(TProjectDescriptor)
   private
     FPascalJNIInterfaceCode: string;
     FJavaClassName: string;
     FPathToClassName: string;
     FPathToJNIFolder: string;
     //FPathToNdkPlatforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
     //FPathToNdkToolchains: string;
     {C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3}
     FInstructionSet: string;    {ArmV6}
     FFPUSet: string;            {Soft}

     FPathToJavaTemplates: string;
     FPathToSmartDesigner: string;
     FAndroidProjectName: string;
     FModuleType: TModuleType;
     FSyntaxMode: TSyntaxMode;   {}

     FPieChecked: boolean;
     FLibraryChecked: boolean; //raw .so

     FPathToJavaJDK: string;
     FPathToAndroidSDK: string;  //Included TrailingPathDelimiter
     FPathToAndroidNDK: string;   //Included TrailingPathDelimiter
     FNDK: string; //alias  '>11'etc..
     FNDKIndex: integer; {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
     FNDKVersion: integer; //18

     FPathToAntBin: string;
     FPathToGradle: string;

     FProjectModel: TProjectModel;
     FPackagePrefaceName: string;
     FMinApi: string;
     FTargetApi: string;

     FSupport: boolean;

     FTouchtestEnabled: string;
     FAntBuildMode: string;
     FMainActivity: string;
     FPathToJavaSrc: string;
     //FAndroidNDKPlatform: string;
     FNdkApi: string;

     FPrebuildOSys: string;

     FFullPackageName: string;
     FFullJavaSrcPath: string;
     FSmallProjName:  string; //ex. 'AppDemo1'
     FGradleVersion: string;

     FAndroidTheme: string;
     FAndroidThemeColor: string;       //new
     FAndroidTemplateTheme: string;  //new

     FBuildSystem: string;
     FMaxSdkPlatform: integer;
     FCandidateSdkBuild: string;
     FIniFileName: string;
     FIniFileSection: string;

     function SettingsFilename: string;
     function TryNewJNIAndroidInterfaceCode(projectType: TModuleType): boolean; //0: GUI  project --- 1:NoGUI project
     function GetWorkSpaceFromForm(projectType: TModuleType; out outTag: TModuleType): boolean;

     //function GetBuildTool(sdkApi: integer): string;
     //function HasBuildTools(platform: integer;  out outBuildTool: string): boolean;

     function DoNewPathToJavaTemplate(): string;
     function GetPathToSmartDesigner(): string;
     procedure WriteIniString(Key, Value: string);
     function IsTemplateProject(tryTheme: string; out outAndroidTheme: string): boolean;

   public
     constructor Create; override;
     function GetLocalizedName: string; override;
     function GetLocalizedDescription: string; override;
     function DoInitDescriptor: TModalResult; override;
     function InitProject(AProject: TLazProject): TModalResult; override;
     function CreateStartFiles(AProject: TLazProject): TModalResult; override;
  end;

  { TAndroidGUIProjectDescriptor }

  TAndroidGUIProjectDescriptor = class(TAndroidProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function DoInitDescriptor: TModalResult; override;
  end;

  {TAndroidGdxProjectDescriptor}

  TAndroidGdxProjectDescriptor = class(TAndroidProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function DoInitDescriptor: TModalResult; override;
  end;

  {TAndroidNoGUIExeProjectDescriptor}

  TAndroidNoGUIExeProjectDescriptor = class(TAndroidProjectDescriptor)   //console executable App
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function DoInitDescriptor: TModalResult; override;
  end;

  TAndroidFileDescPascalUnitWithResource = class(TFileDescPascalUnitWithResource)
  private
    //
  public
    SyntaxMode: TSyntaxMode; {mdDelphi, mdObjFpc}
    PathToJNIFolder: string;
    ModuleType: TModuleType;

    AndroidTheme: string;

    SmallProjName: string;

    constructor Create; override;

    function CreateSource(const Filename     : string;
                          const SourceName   : string;
                          const ResourceName : string): string; override;

    function GetInterfaceUsesSection: string; override;

    function GetInterfaceSource(const Filename     : string;
                                const SourceName   : string;
                                const ResourceName : string): string; override;

    function GetResourceType: TResourceType; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function GetImplementationSource(const Filename     : string;
                                     const SourceName   : string;
                                     const ResourceName : string): string; override;
  end;


  TAndroidFileDescPascalUnitWithResourceGDX = class(TFileDescPascalUnitWithResource)
  private
    //
  public
    SyntaxMode: TSyntaxMode; {mdDelphi, mdObjFpc}
    PathToJNIFolder: string;
    ModuleType: TModuleType;   //-1:gdx 0: GUI; 1: No GUI ; 2: console executable App; 3: generic library

   //FSmallProjName: string;

    constructor Create; override;

    function CreateSource(const Filename     : string;
                          const SourceName   : string;
                          const ResourceName : string): string; override;

    function GetInterfaceUsesSection: string; override;

    function GetInterfaceSource(const Filename     : string;
                                const SourceName   : string;
                                const ResourceName : string): string; override;

    function GetResourceType: TResourceType; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function GetImplementationSource(const Filename     : string;
                                     const SourceName   : string;
                                     const ResourceName : string): string; override;
  end;



var
  AndroidProjectDescriptor: TAndroidProjectDescriptor;

  AndroidFileDescriptor: TAndroidFileDescPascalUnitWithResource;  //GUI
  AndroidFileDescriptorGDX: TAndroidFileDescPascalUnitWithResourceGDX;

  AndroidGUIProjectDescriptor: TAndroidGUIProjectDescriptor;
  AndroidGdxProjectDescriptor: TAndroidGdxProjectDescriptor;

  AndroidNoGUIExeProjectDescriptor: TAndroidNoGUIExeProjectDescriptor;


procedure Register;

function SplitStr(var theString: string; delimiter: string): string;

implementation

uses
   {$ifdef unix}BaseUnix,{$endif}
   LazFileUtils, uJavaParser, LamwSettings, LamwDesigner, SmartDesigner, IniFiles, PackageIntf;

procedure Register;
begin
  FormEditingHook.RegisterDesignerMediator(TAndroidWidgetMediator);
  AndroidFileDescriptor := TAndroidFileDescPascalUnitWithResource.Create;
  AndroidFileDescriptorGDX := TAndroidFileDescPascalUnitWithResourceGDX.Create;

  RegisterProjectFileDescriptor(AndroidFileDescriptor);
  RegisterProjectFileDescriptor(AndroidFileDescriptorGDX);

  AndroidProjectDescriptor:= TAndroidProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidProjectDescriptor);

  AndroidGUIProjectDescriptor:= TAndroidGUIProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidGUIProjectDescriptor);

  AndroidGdxProjectDescriptor:= TAndroidGdxProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidGdxProjectDescriptor);

  AndroidNoGUIExeProjectDescriptor:= TAndroidNoGUIExeProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidNoGUIExeProjectDescriptor);

  FormEditingHook.RegisterDesignerBaseClass(TAndroidModule);
  FormEditingHook.RegisterDesignerBaseClass(TGdxModule);

  FormEditingHook.RegisterDesignerBaseClass(TNoGUIAndroidModule);
  FormEditingHook.RegisterDesignerBaseClass(TAndroidConsoleDataForm);

  LamwSmartDesigner.Init;
end;

{ TAndroidGdxProjectDescriptor }

constructor TAndroidGdxProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create a new LAMW [libGDX] Android Project';
end;

function TAndroidGdxProjectDescriptor.GetLocalizedName: string;
begin
  //Result:=inherited GetLocalizedName;
   Result:= 'LAMW [libGDX] Android Module';
end;

function TAndroidGdxProjectDescriptor.GetLocalizedDescription: string;
begin
  //Result:=inherited GetLocalizedDescription;
  Result:=  'WARNING!!! A Proof of Concept!!!!'+ LineEnding +
            'LAMW [libGDX] Android loadable module (.so)'+ LineEnding +
            'with Form and Android libGDX Components.'+ LineEnding +
            'The project and library file are maintained by Lazarus.';
  ActivityModeDesign:= actMain;  //main
end;

function TAndroidGdxProjectDescriptor.DoInitDescriptor: TModalResult;
var
  strAfterReplace, strPackName, aux: string;
  auxList, ControlsJava: TStringList;
  outTag: TModuleType;
  i: integer;
begin

  ShowMessage('WARNING!!! libGDX Proof of Concept!! Go to "...demos/libGDX" !!');
  Exit;

  try
    FModuleType := mtGDX; //-1: gdx 0: GUI --- 1:NoGUI --- 2: NoGUI EXE Console
    FJavaClassName := 'Controls';
    FPathToClassName := '';
    if GetWorkSpaceFromForm(mtGDX, outTag) then //Gdx
    begin
      strPackName := FPackagePrefaceName + '.' + LowerCase(FSmallProjName);
      with TStringList.Create do
        try
          LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'Controls.java');
          Strings[0] := 'package ' + strPackName + ';';  //replace dummy - Controls.java
          aux:=  StringReplace(Text, '/*libsmartload*/' ,
                 'try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}',
                 [rfReplaceAll,rfIgnoreCase]);
          Text:= aux;
          SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'Controls.java');

          Clear;

          if FileExists(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'App.java') then
          begin
              LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'App.java');
              Strings[0] := 'package ' + strPackName + ';'; //replace dummy App.java
              SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'App.java');
          end;

          if FileExists(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'MyGdxGame.java') then
          begin
            LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'MyGdxGame.java');
            Strings[0] := 'package ' + strPackName + ';'; //replace dummy
            SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'MyGdxGame.java');
          end;

          if FileExists(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'jGdxForm.java') then
          begin
            LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'jGdxForm.java');
            Strings[0] := 'package ' + strPackName + ';'; //replace dummy
            SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jGdxForm.java');

            ControlsJava:= TStringList.Create;
            ControlsJava.LoadFromFile(FFullJavaSrcPath + DirectorySeparator + 'Controls.java');

            LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'jGdxForm.create');
            auxList:= TStringList.Create;
            auxList.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'jGdxForm.native');
            for i:= 0 to auxList.Count-1 do
            begin
              Add(auxList.Strings[i]);
            end;
            ControlsJava.Insert(ControlsJava.Count-1, Text);
            ControlsJava.SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'Controls.java');
            ControlsJava.Free;
            auxList.Free;
          end;

          CreateDir(FAndroidProjectName+DirectorySeparator+'lamwdesigner');

          if FileExists(FPathToJavaTemplates+DirectorySeparator + 'Controls.native') then
          begin
            CopyFile(FPathToJavaTemplates+DirectorySeparator + 'Controls.native',
              FAndroidProjectName+DirectorySeparator+'lamwdesigner'+DirectorySeparator+'Controls.native');
          end;

          if FileExists(FPathToJavaTemplates+DirectorySeparator+ 'jCommons.java') then
          begin
            LoadFromFile(FPathToJavaTemplates+DirectorySeparator+ 'jCommons.java');
            Strings[0] := 'package ' + strPackName + ';';  //replace dummy
            SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jCommons.java');
          end;

      finally
          Free;
      end;

      FPathToJNIFolder := FAndroidProjectName;
      AndroidFileDescriptorGDX.PathToJNIFolder:= FPathToJNIFolder;
      AndroidFileDescriptorGDX.ModuleType:= mtGDX;

      with TJavaParser.Create(FFullJavaSrcPath + DirectorySeparator+  'Controls.java') do
      try         //"Controls.events" produced by FormWorkspace
        FPascalJNIInterfaceCode := GetPascalJNIInterfaceCode(FPathToJavaTemplates + DirectorySeparator + 'Controls.events');
      finally
        Free;
      end;

      CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni');
      CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'mips');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
      CreateDir(FAndroidProjectName+DirectorySeparator+'obj');

      if  FModuleType in [mtGDX, mtGUI, mtNoGUI] then
        CreateDir(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');

      if FProjectModel = psNewProject then
      begin
        auxList:= TStringList.Create;
        //eclipe compatibility [Neon!]
        CreateDir(FAndroidProjectName+DirectorySeparator+'.settings');
        auxList.Add('eclipse.preferences.version=1');
        auxList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.7');
        auxList.Add('org.eclipse.jdt.core.compiler.compliance=1.7');
        auxList.Add('org.eclipse.jdt.core.compiler.source=1.7');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs');
        auxList.Clear;
        auxList.Add('<?xml version="1.0" encoding="UTF-8"?>');
        auxList.Add('<classpath>');
        auxList.Add('<classpathentry kind="src" path="src"/>');
        auxList.Add('<classpathentry kind="src" path="gen"/>');
        auxList.Add('<classpathentry kind="con" path="org.eclipse.andmore.ANDROID_FRAMEWORK"/>');
        auxList.Add('<classpathentry exported="true" kind="con" path="org.eclipse.andmore.LIBRARIES"/>');
        auxList.Add('<classpathentry exported="true" kind="con" path="org.eclipse.andmore.DEPENDENCIES"/>');
        auxList.Add('<classpathentry kind="output" path="bin/classes"/>');
        auxList.Add('</classpath>');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.classpath');

        auxList.Clear;
        auxList.Add('<projectDescription>');
        auxList.Add('	<name>'+FSmallProjName+'</name>');
        auxList.Add('	<comment></comment>');
        auxList.Add('	<projects>');
        auxList.Add('	</projects>');
        auxList.Add('	<buildSpec>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>org.eclipse.andmore.ResourceManagerBuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add('		</buildCommand>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>org.eclipse.andmore.PreCompilerBuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add('		</buildCommand>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>org.eclipse.jdt.core.javabuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add('		</buildCommand>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>org.eclipse.andmore.ApkBuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add(' 		</buildCommand>');
        auxList.Add('	</buildSpec>');
        auxList.Add('	<natures>');
        auxList.Add('		<nature>org.eclipse.andmore.AndroidNature</nature>');
        auxList.Add('		<nature>org.eclipse.jdt.core.javanature</nature>');
        auxList.Add('	</natures>');
        auxList.Add('</projectDescription>');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.project');

        auxList.Clear;
        auxList.Add('# To enable ProGuard in your project, edit project.properties');
        auxList.Add('# to define the proguard.config property as described in that file.');
        auxList.Add('#');
        auxList.Add('# Add project specific ProGuard rules here.');
        auxList.Add('# By default, the flags in this file are appended to flags specified');
        auxList.Add('# in ${sdk.dir}/tools/proguard/proguard-android.txt');
        auxList.Add('# You can edit the include path and order by changing the ProGuard');
        auxList.Add('# include property in project.properties.');
        auxList.Add('#');
        auxList.Add('# For more details, see');
        auxList.Add('#   http://developer.android.com/guide/developing/tools/proguard.html');
        auxList.Add(' ');
        auxList.Add('# Add any project specific keep options here:');
        auxList.Add(' ');
        auxList.Add('# If your project uses WebView with JS, uncomment the following');
        auxList.Add('# and specify the fully qualified class name to the JavaScript interface');
        auxList.Add('# class:');
        auxList.Add('#-keepclassmembers class fqcn.of.javascript.interface.for.webview {');
        auxList.Add('#   public *;');
        auxList.Add('#}');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'proguard-project.txt');

        auxList.Clear;
        auxList.Add('# This file is automatically generated by Android Tools.');
        auxList.Add('# Do not modify this file -- YOUR CHANGES WILL BE ERASED!');
        auxList.Add('#');
        auxList.Add('# This file must be checked in Version Control Systems.');
        auxList.Add('#');
        auxList.Add('# To customize properties used by the Ant build system edit');
        auxList.Add('# "ant.properties", and override values to adapt the script to your');
        auxList.Add('# project structure.');
        auxList.Add('#');
        auxList.Add('# To enable ProGuard to shrink and obfuscate your code, uncomment this (available properties: sdk.dir, user.home):');
        auxList.Add('#proguard.config=${sdk.dir}/tools/proguard/proguard-android.txt:proguard-project.txt');
        auxList.Add(' ');
        auxList.Add('# Project target.');

        auxList.Add('target=android-'+FTargetApi);

        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'project.properties');
        auxList.Free;
      end;

      //AndroidManifest.xml creation:
      with TStringList.Create do
      try

        LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'gdx'+DirectorySeparator+'androidmanifest.txt');
        strAfterReplace  := StringReplace(Text, 'dummyPackage',strPackName, [rfReplaceAll, rfIgnoreCase]);
        strPackName:= strPackName+'.'+FMainActivity; {gApp}
        strAfterReplace  := StringReplace(strAfterReplace, 'dummyAppName',strPackName, [rfReplaceAll, rfIgnoreCase]);

        strAfterReplace  := StringReplace(strAfterReplace, 'dummySdkApi', FMinApi, [rfReplaceAll, rfIgnoreCase]);
        strAfterReplace  := StringReplace(strAfterReplace, 'dummyTargetApi', FTargetApi, [rfReplaceAll, rfIgnoreCase]);

        Clear;
        Text:= strAfterReplace;
        SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');

      finally
        Free;
      end;

      Result := mrOK
    end else
      Result := mrAbort;
  except
    on e: Exception do
    begin
      MessageDlg('Error', e.Message, mtError, [mbOk], 0);
      Result := mrAbort;
    end;
  end;
end;

{TAndroidNoGUIExeProjectDescriptor}

constructor TAndroidNoGUIExeProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create a new LAMW [NoGUI] Android Console/Executable App';
end;

function TAndroidNoGUIExeProjectDescriptor.GetLocalizedName: string;
begin
  Result:= 'LAMW Android Console App';
end;

function TAndroidNoGUIExeProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=  'LAMW [NoGUI] Android Console Application'+ LineEnding +
            '[Native Executable]'+ LineEnding +
            'using datamodule like form.'+ LineEnding +
            'The project is maintained by Lazarus.'
end;

function TAndroidNoGUIExeProjectDescriptor.DoInitDescriptor: TModalResult;    //NoGUI Exe
var
  list: TStringList;
  outTag: TModuleType;
begin
  try
    FModuleType := mtNoGUIConsole; //-1: gdx 0: GUI --- 1:NoGUI --- 2: NoGUI EXE Console  3: generic library
    FPathToClassName := '';
    if GetWorkSpaceFromForm(mtNoGUIConsole, outTag) then
    begin

      FPathToJNIFolder := FAndroidProjectName;
      AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
      AndroidFileDescriptor.ModuleType:= mtNoGUIConsole; //Console

      if outTag = mtLibrary then
      begin
        FModuleType:= mtLibrary;
        AndroidFileDescriptor.ModuleType:= mtLibrary; // generic/custom library
      end;

      CreateDir(FAndroidProjectName+DirectorySeparator+'build-modes');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'mips');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
      CreateDir(FAndroidProjectName+DirectorySeparator+'obj');

      if FModuleType = mtNoGUIConsole then //default
      begin
        list:= TStringList.Create;

        list.Add('How to Run your native console App in "AVD/Emulator"');
        list.Add(' ');
        list.Add('		NOTE 1: To get the executable app, go to Lazarus menu  ---> "Run" --> "Build"' );
        list.Add(' ');
        if FPieChecked then
        list.Add('		NOTE 2: Project settings: Target Api = '+FTargetApi+ ' and PIE enabled!' )
        else
        list.Add('		NOTE 2: Project settings: Targeg Api = '+FTargetApi+ ' and PIE  not enabled!' );

        list.Add(' ');
        list.Add('		NOTE 3: To run in a real device, please, "readme_How_To_Run_Real_Device.txt" [ref. http://kevinboone.net/android_native.html] ');
        list.Add(' ');
        list.Add('		NOTE 4: Android >=5.0 [Target API >= 21] need to enable PIE [Position Independent Executables]: ');
        list.Add(' ');
        list.Add('			"Project" --->> "Project Options" -->> "Compile Options" --->> "Compilation and Linking" ');
        list.Add('			--->> "Pas options to linker"  [check it !] and enter: -pie into edit below ');
        list.Add(' ');
        list.Add('		NOTE 5: Handle the form OnCreate event to start the program''s tasks!');
        list.Add(' ');
        list.Add('1. Execute the AVD/Emulator ');
        list.Add(' ');
        list.Add('2. Execute the  "cmd"  terminal [windows] ');
        list.Add(' ');
        list.Add('3. Go to folder  ".../skd/platform-tools"  and run the adb shell  [note: "-e" ---> emulator ... and "-d" ---> device] ');
        list.Add(' ');
        list.Add('adb -e shell ');
        list.Add(' ');
        list.Add('4. Create a new dir/folder "tmp" in  "/sdcard" ');
        list.Add(' ');
        list.Add('cd /sdcard ');
        list.Add(' ');
        list.Add('mkdir tmp ');
        list.Add(' ');
        list.Add('exit ');
        list.Add(' ');
        list.Add('5. Copy your program file  "'+LowerCase(FSmallProjName)+'" from project folder "...\libs\armeabi\" to Emulator "/sdcard/tmp" ');
        list.Add(' ');
        list.Add('adb push C:\adt32\workspace\'+FSmallProjName+'\libs\armeabi\'+LowerCase(FSmallProjName)+'  /sdcard/tmp/'+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('6. go to "adb shell" again ');
        list.Add(' ');
        list.Add('adb -e shell. ');
        list.Add(' ');
        list.Add('7. Go to folder "/sdcard/tmp" ');
        list.Add(' ');
        list.Add('root@android:/ # cd /sdcard/tmp ');
        list.Add(' ');
        list.Add('8. Now copy your programa file "' + LowerCase(FSmallProjName)+'" to an executable place ');
        list.Add(' ');
        list.Add('root@android:/sdcard/tmp # cp ' + LowerCase(FSmallProjName)+' /data/local/tmp/'+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('9. Go to folder /data/local/tmp and Change permission to run executable ');
        list.Add(' ');
        list.Add('root@android:/ # cd /data/local/tmp');
        list.Add('root@android:/data/local/tmp # chmod 755 ' + LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('10. Execute your program! ');
        list.Add(' ');
        list.Add('root@android:/data/local/tmp # ./' + LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('Hello LAMW''s World!');
        list.Add(' ');
        list.Add('11. Congratulations !!!! ');
        list.Add(' ');
        list.Add('    by jmpessoa_hotmail_com');
        list.Add(' ');
        list.Add('    Thanks to @gtyhn,  @engkin and Prof. Claudio Z. M. [Suggestion/Motivation] ');
        list.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme_How_To_Run_AVD_Emulator.txt');

        list.Clear;
        list.Add('How to run your native console app in "Real Device" [ref. http://kevinboone.net/android_native.html] ');
        list.Add(' ');
        list.Add('		NOTE 1: To get the executable app, go to Lazarus menu  ---> "Run" --> "Build"' );
        list.Add(' ');
        if FPieChecked then
        list.Add('		NOTE 2: Project settings: Target Api = '+FTargetApi+ ' and PIE enabled!' )
        else
        list.Add('		NOTE 2: Project settings: Targeg Api = '+FTargetApi+ ' and PIE  not enabled!' );

        list.Add(' ');
        list.Add('		NOTE 3: To run in AVD/Emulator, please, "readme_How_To_Run_AVD_Emulator.txt"');
        list.Add(' ');
        list.Add('		NOTE 4: Android >=5.0 [Target API >= 21] need to enable PIE [Position Independent Executables] enabled: ');
        list.Add(' ');
        list.Add('			"Project" --->> "Project Options" -->> "Compile Options" --->> "Compilation and Linking"');
        list.Add('			--->> "Pas options to linker"  [check it !] and enter: -pie into edit below');
        list.Add(' ');
        list.Add('		NOTE 5: Handle the form OnCreate event to start the program''s tasks!');
        list.Add(' ');
        list.Add('1. Go to Google Play Store and get "Terminal Emulador" by Jack Palevich [thanks to jack!]');
        list.Add(' ');
        list.Add('2. Connect PC <---> Device via an USB cable  and  copy your program file  "'+LowerCase(FSmallProjName)+'" from project folder "...\libs\armeabi\" to Device folder "Download"');
        list.Add(' ');
        list.Add('3. Go to your Device and run  the app "Terminal Emulador"  and go to internal "Terminal Emulador" storage folder');
        list.Add(' ');
        list.Add('$ cd /data/data/jackpal.androidterm/shared_prefs');
        list.Add(' ');
        list.Add('5. Copy [cat] your program file  "'+LowerCase(FSmallProjName)+'" from Device folder "Download" to internal "Terminal Emulador" storage folder');
        list.Add(' ');
        list.Add('$ cat /sdcard/Download/'+LowerCase(FSmallProjName)+' > '+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('6. Change your program file  "'+LowerCase(FSmallProjName)+'" permission to "executable" mode');
        list.Add(' ');
        list.Add('$ chmod 755 '+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('7. Execute your program!');
        list.Add(' ');
        list.Add('$ ./'+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('Hello LAMW''s World!');
        list.Add(' ');
        list.Add('8. Congratulations !!!!');
        list.Add(' ');
        list.Add('    by jmpessoa_hotmail_com');
        list.Add(' ');
        list.Add('    Thanks to @gtyhn,  @engkin and Prof. Claudio Z. M. [Suggestion/Motivation]');

        list.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme_How_To_Run_Real_Device.txt');
        list.Free;
      end;

      Result := mrOK
    end else
      Result := mrAbort;
  except
    on e: Exception do
    begin
      MessageDlg('Error', e.Message, mtError, [mbOk], 0);
      Result := mrAbort;
    end;
  end;
end;

{ TAndroidGUIProjectDescriptor }

constructor TAndroidGUIProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create a new LAMW [GUI] Android Module (.so)';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedName: string;
begin
  Result:= 'LAMW [GUI] Android Module';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=  'LAMW [GUI] Android loadable module (.so)'+ LineEnding +
            'based on Simonsayz''s templates'+ LineEnding +
            'with Form Designer and Android Components Bridges.'+ LineEnding +
            'The project and library file are maintained by Lazarus.';
  ActivityModeDesign:= actMain;  //main jForm
end;

function TAndroidGUIProjectDescriptor.DoInitDescriptor: TModalResult;    //GUI
var
  outTag: TModuleType;
  strPackName: String;
begin
  try
    FModuleType := mtGUI;
    FJavaClassName := 'Controls';
    FPathToClassName := '';

    if GetWorkSpaceFromForm(mtGUI, outTag) then
    begin
      strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

      // What it do:
      //  * if FSupport is true:
      //      if <JTMPL>/support/jSupported.java exists Loads it and save it in FFullJAvaSrcPath while updating "package name"
      //      if <JTMPL>/support/support_provider_paths.xml exists but dest res/xml/support_provider_paths.xml not, it copies it
      //  * if FSupport is false:
      //      if <JTMPL>/jSupported.java it s copied to FFullJavaSrcPath/jSupported.java while updating "package name"
      //  * Loads <JTMPL>/Controls.java
      //      replaces "package name"
      //      replaces template /*libsmartload* with some System.loadlibrary code
      //      Save it as FFullJavaSrcPath/Controls.java
      //  * Loads <JTMPL>/jForm.java updates "package name" save it as FFullJavaSrcPath/jForm.java
      //  * if AppCompat in FAndroidTheme  Loads <JTMPL>/support/App.java
      //    else                           Loads <JTMPL>/App.java
      //        Updates "package name"
      //        Save it as FFullJavaSrcPath/App.java
      //  * Creates FAndroidProjectName/lamwdesigner
      //       if Exists FPathToJavaTemplates/Controls.native its copied to FAndroidProjectName/lamwdesigner/Controls.native
      //  * if AppCompat in FAndroidTheme
      //        if exists <JTMPL>/support/jCommons.java, loads it, change pakage name, save it as FFullJavaSrcPath/jCommons;
      //    else
      //        if exists <JTMPL>/jCommons.java, loads it, change pakage name, save it as FFullJavaSrcPath/jCommons;
      //
      // Depends on:
      //    FSupport, FPathToJavaTemplates, strPackName, FFullJavaSrcPath, FAndroidProjectName
      //    FAndroidTheme
      //
      // Produces:
      //    jSupported.java, support_provider_paths.xml, controls.java,
      //    App.java, lamwdesigner/Controls.native, jCommons.java
      //
      {%region /fold}
      CreateJSupportedJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName, FSupport);
      CreateSupportProviderPathsXML(FAndroidProjectName, FPathToJavaTemplates, FSupport);
      CreateControlsJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName);
      CreateJFormJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName);
      CreateAppJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName, FAndroidTheme);
      CreateControlsNative(FAndroidProjectName, FPathToJavaTemplates);
      CreateJCommonsJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName, FAndroidTheme);
      {%EndRegion}

      FPathToJNIFolder := FAndroidProjectName;
      AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
      AndroidFileDescriptor.SmallProjName:=  FSmallProjName;
      AndroidFileDescriptor.ModuleType:= mtGUI;

      // what it does:
      //    Parses the recent created FFullJavaSrcPath/Controls.java and extracts
      //    the corresponding Pascal Jni Interface. This is later put in the header
      //    of the main .lpr file that produces de library.so native file.
      //
      // Depends on:
      //    FFullJavaSrcPath, FPathToJavaTemplates;
      //
      //Creates:
      //    Parses Dest/Controls.java file, produces FPascalJniInterfaceCode
      //
      {%Region /fold}
      with TJavaParser.Create(FFullJavaSrcPath + DirectorySeparator+  'Controls.java') do
      try         //produce helper file [old] "ControlsEvents.txt"
        FPascalJNIInterfaceCode := GetPascalJNIInterfaceCode(FPathToJavaTemplates + DirectorySeparator + 'Controls.events');
      finally
        Free;
      end;
      {%EndRegion}


      // What it does:
      //    Creates sevaral directories
      //
      // Depends on:
      //    FAndroidProjectName, FModuleType;
      //
      // Produces:
      //    <Proj>/jni, <Proj>/jni/build-modes, <Proj>/libs, <Proj>/libs/armeabi,
      //    <Proj>/libs/armeabi-v7a, <Proj>/libs/x86, <Proj>/libs/mips,
      //    <Proj>/libs/arm64-v8a, <Proj>/libs/x86_64, <Proj>/obj, <Proj>/obj/controls
      //
      {%Region /fold}
      CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni');
      CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'mips');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
      CreateDir(FAndroidProjectName+DirectorySeparator+'obj');

      if  FModuleType in [mtGDX, mtGUI, mtNoGUI] then
        CreateDir(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');
      {%EndRegion}

      if FProjectModel = psNewProject then
      begin
        {$IFDEF FULL}
        // What it does:  For eclipse funcionality
        //    Creates <Proj>/.settings
        //    Creates <Proj>/.settings/org.eclipse.jdt.core.prefs
        //    Creates <Proj>/.classpath
        //    Creates <Proj>/.project
        //
        // Depends On:    FAndroidProjectName
        //
        {%Region /fold}
        //eclipe compatibility [Neon!]
        CreateEclipseCorePrefs(FAndroidProjectName, '1.7');
        CreateEclipseClassPath(FAndroidProjectName);
        CreateEclipseProjectFile(FAndroidProjectName, FSmallProjName);
        {%EndRegion}
        {$ENDIF}
      end;

      // What it does:  Creates <Proj>/AndroidManifest.xml
      //
      // Depends On:
      //    FPathToJavaTemplates, strPackName, FMainActivity, FMinApi, FTargetApi
      //    FSupport,
      //
      {%Region /fold}

      //AndroidManifest.xml creation:
      CreateAndroidManifestXML(FAndroidProjectName, FPathToJavaTemplates, FPackagePrefaceName, FSmallProjName, FMainActivity, FMinApi, FTargetApi, FSupport);
      {%EndRegion}

      Result := mrOK

    end else
      Result := mrAbort;
  except
    on e: Exception do
    begin
      MessageDlg('Error', e.Message, mtError, [mbOk], 0);
      Result := mrAbort;
    end;
  end;


end;

{TAndroidProjectDescriptor}

function TAndroidProjectDescriptor.GetPathToSmartDesigner(): string;
var
  Pkg: TIDEPackage;
begin
  if FPathToSmartDesigner = '' then
  begin
    Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
    if Pkg <> nil then
    begin
        FPathToSmartDesigner:= ExtractFilePath(Pkg.Filename) + 'smartdesigner';
        //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
    end;
  end;
  Result:=FPathToSmartDesigner;
end;

function TAndroidProjectDescriptor.DoNewPathToJavaTemplate(): string;
begin
   FPathToJavaTemplates:= GetPathToSmartDesigner() + pathDelim + 'java';
   Result:=FPathToJavaTemplates;
    //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner\java
end;

procedure TAndroidProjectDescriptor.WriteIniString(Key, Value: string);
var
  FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + FIniFileName);
  if FIniFile <> nil then
  begin
    FIniFile.WriteString(FIniFileSection, Key, Value);
    FIniFile.Free;
  end;
end;


function TAndroidProjectDescriptor.SettingsFilename: string;
var
    flag: boolean;
begin

    flag:= false;
    if not FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini') then
    begin
      if FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini') then
      begin
         FIniFileName:= 'LAMW.ini';
         FIniFileSection:= 'NewProject';
         CopyFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini',
                  IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
         //DeleteFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
         FPathToJavaTemplates:= DoNewPathToJavaTemplate();
         FPathToSmartDesigner:= GetPathToSmartDesigner();
         flag:= True;
      end;
    end;

    if flag then
    begin
      WriteIniString('PathToJavaTemplates', FPathToJavaTemplates);
      WriteIniString('PathToSmartDesigner', FPathToSmartDesigner);
    end;

    Result := IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';

end;

function TAndroidProjectDescriptor.TryNewJNIAndroidInterfaceCode(projectType: TModuleType): boolean;
var
  frm: TFormAndroidProject;
begin
  Result := False;
  FModuleType:= projectType;
  frm:= TFormAndroidProject.Create(nil);  //Create Form

  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;
  frm.MainActivity:= FMainActivity;
  frm.MinApi:= FMinApi;
  frm.TargetApi:= FTargetApi;
  frm.Support:=FSupport;

  frm.ProjectModel:= FProjectModel; //'Ant'  or 'Eclipse'
  frm.FullJavaSrcPath:= FFullJavaSrcPath;
  frm.ModuleType:= projectType;
  frm.SmallProjName := FSmallProjName;

  if frm.ShowModal = mrOK then
  begin

    FSyntaxMode:= frm.SyntaxMode;

    FPathToJNIFolder:= FAndroidProjectName;

    AndroidFileDescriptor.PathToJNIFolder:= FAndroidProjectName;
    AndroidFileDescriptor.ModuleType:= FModuleType;
    AndroidFileDescriptor.SyntaxMode:= FSyntaxMode;

    ShowMessage('try new jni FAndroidTheme = ' + FAndroidTheme);

    AndroidFileDescriptor.AndroidTheme:= FAndroidTheme;

    FPascalJNIInterfaceCode:= frm.PascalJNIInterfaceCode;

    FFullPackageName:= frm.FullPackageName;
    Result := True;
  end;
  frm.Free;
end;

constructor TAndroidProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create a new LAMW [NoGUI] Android Module (.so)';
end;

function TAndroidProjectDescriptor.GetLocalizedName: string;
begin
  Result := 'LAMW [NoGUI] Android Module'; //fix thanks to Stephano!
end;

function TAndroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := 'LAMW [NoGUI] Android loadable module (.so)'+ LineEnding +
            'using datamodule like form.'+ LineEnding +
            'No[!] Form Designer/Android and no Components Bridges!'+ LineEnding +
            'The project and library are maintained by Lazarus.'
end;

function TAndroidProjectDescriptor.GetWorkSpaceFromForm(projectType: TModuleType; out outTag: TModuleType): boolean;

  function MakeUniqueName(const Orig: string; sl: TStrings): string;
  var
    i: Integer;
  begin
    if sl.Count = 0 then
      Result := Orig + '1'
    else begin
      Result := ExtractFilePath(sl[0]) + Orig;
      i := 1;
      while sl.IndexOf(Result + IntToStr(i)) >= 0 do Inc(i);
      Result := Orig + IntToStr(i);
    end;
  end;

  procedure SaveShellScript(script: TStringList; const AFileName: string);
  begin
    script.SaveToFile(AFileName);
    {$ifdef unix}
    FpChmod(AFileName, &751);
    {$endif}
  end;

var
  frm: TFormWorkspace;
  strList: TStringList;
  instructionChip: string;
  FVersionCode: integer;
  FVersionName : string;
  xmlAndroidManifest: TXMLDocument;
  outTheme: string;
begin
  Result:= False;
  FModuleType:= projectType; //-1:gdx 0:GUI  1:NoGUI 2: NoGUI EXE Console 3: generic library

  AndroidFileDescriptor.ModuleType:= projectType;
  strList:= nil;
  frm:= TFormWorkspace.Create(nil);
  try
    strList:= TStringList.Create;

    frm.ModuleType:= projectType;

    frm.LoadSettings(SettingsFilename);

    frm.ComboSelectProjectName.Text:= MakeUniqueName('AppLAMWProject', frm.ComboSelectProjectName.Items);

    frm.LabelTheme.Caption:= 'Android Theme:';
    frm.ComboBoxTheme.Visible:= True;
    frm.SpeedButtonHintTheme.Visible:= True;

    frm.CheckBoxPIE.Visible:= False;
    frm.CheckBoxLibrary.Visible:= False;

    if projectType = mtGDX then //Gdx
    begin
      frm.Color:= clWhite;
      frm.PanelButtons.Color:= clWhite;

      frm.ComboSelectProjectName.Text:= MakeUniqueName('AppLAMWGdxProject', frm.ComboSelectProjectName.Items);

      frm.LabelTheme.Caption:= 'App LAMW [libGDX] Project';

      frm.cbBuildSystem.Clear;
      frm.cbBuildSystem.Items.Add('Gradle');
      frm.cbBuildSystem.Text:= 'Gradle';

      frm.ComboBoxTheme.Clear;
      frm.ComboBoxTheme.Items.Add('GDXGame');
      frm.ComboBoxTheme.Text:= 'GDXGame';
      FAndroidTheme:= 'GDXGame';
      //frm.ComboBoxTheme.Visible:= False;
      frm.SpeedButtonHintTheme.Visible:= False;
    end;

    if projectType = mtNoGUI then //No GUI
    begin
      frm.Color:= clWhite;
      frm.PanelButtons.Color:= clWhite;

      frm.ComboSelectProjectName.Text:= MakeUniqueName('AppLAMWNoGUIProject', frm.ComboSelectProjectName.Items);

      frm.LabelTheme.Caption:= 'App LAMW [NoGUI] Project';
      frm.ComboBoxTheme.Visible:= False;
      frm.SpeedButtonHintTheme.Visible:= False;
    end;

    if projectType = mtNoGUIConsole then //No GUI console executable or generic library [.so]
    begin
      frm.GroupBox1.Visible:= False;
      frm.GroupBox5.Visible:= False;

      frm.Color:= clGradientInactiveCaption;
      frm.PanelButtons.Color:= clGradientInactiveCaption;

      frm.ComboSelectProjectName.Text:= MakeUniqueName('LamwConsoleApp', frm.ComboSelectProjectName.Items);

      frm.LabelTheme.Caption:= 'App LAMW [NoGUI] Android Console/Executable Project';
      frm.EditPackagePrefaceName.Visible:= False;

      frm.EditPackagePrefaceName.Text:= '';
      frm.EditPackagePrefaceName.Enabled:= False;

      frm.ComboBoxTheme.Visible:= False;
      frm.SpeedButtonHintTheme.Visible:= False;

      frm.CheckBoxPIE.Visible:= True;
      frm.CheckBoxLibrary.Visible:= True;  //support to generic [not jni] .so library

    end;

    if frm.ShowModal = mrOK then
    begin
      frm.SaveSettings(SettingsFilename);

      // What it does:
      //
      //    Setup variables
      //
      {%Region /fold}
      FBuildSystem:= frm.BuildSystem;

      FAndroidTheme:= frm.AndroidTheme;
      FAndroidThemeColor:= frm.AndroidThemeColor;
      FAndroidTemplateTheme:= '';

      if IsTemplateProject(FAndroidTheme, outTheme) then
      begin
        FAndroidTemplateTheme:= FAndroidTheme;
        FAndroidTheme:= outTheme;
      end;

      FJavaClassName:= frm.JavaClassName;
      FSmallProjName:= frm.SmallProjName;
      FInstructionSet:= frm.InstructionSet;{ ex. ArmV6, ArmV7a, ArmV8}
      FFPUSet:= frm.FPUSet; {ex. Soft}
      FAndroidProjectName:= frm.AndroidProjectName;    //warning: full project name = path + name !
      FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';

      FPathToJavaTemplates:= frm.PathToJavaTemplates;
      FPathToSmartDesigner:= frm.PathToSmartDesigner;
      FPathToJavaJDK:= frm.PathToJavaJDK;

      FPathToAndroidSDK:= frm.PathToAndroidSDK;
      FPathToAndroidNDK:= frm.PathToAndroidNDK;
      //prepare to LamwSettings model ...
      FPathToAndroidNDK:= IncludeTrailingPathDelimiter(FPathToAndroidNDK);
      FPathToAndroidSDK:= IncludeTrailingPathDelimiter(FPathToAndroidSDK);

      FPrebuildOSys:= frm.PrebuildOSys;

      FNDK:= frm.NDK; //alias '>11',  etc...
      FNDKIndex:= frm.NDKIndex;  {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
      FNDKVersion:=frm.NDKVersion; //ex 18

      //FAndroidPlatform:= frm.AndroidPlatform; //"android-15" model was deprecated/droped after NDK 21
      FNdkApi:= frm.NdkApi; //just 14 or 22 etc...

      FPathToAntBin:= frm.PathToAntBin;
      FPathToGradle:= frm.PathToGradle;

      FMinApi:= frm.MinApi;
      FTargetApi:= frm.TargetApi;

      //FSupport:= (LazarusIDE.ActiveProject.CustomData.Values['Support']='TRUE');
      FSupport:=frm.Support;

      FPieChecked:= frm.PieChecked;
      FLibraryChecked:= frm.LibraryChecked;

      FMaxSdkPlatform:= frm.MaxSdkPlatform;

      FGradleVersion:= frm.GradleVersion;

      if FLibraryChecked then
      begin
        outTag:= mtLibrary;
        FModuleType:= mtLibrary;
      end;

      FMainActivity:= frm.MainActivity;  //App
      FJavaClassName:= frm.JavaClassName;

      FProjectModel:= frm.ProjectModel;   //<-- output from [Eclipse or Ant Project]
      if FProjectModel = psExistingProject then
           FFullJavaSrcPath:= frm.FullJavaSrcPath;

      if  frm.TouchtestEnabled = 'True' then
         FTouchtestEnabled:= '-Dtouchtest.enabled=true'
      else
         FTouchtestEnabled:='';

      FAntBuildMode:= frm.AntBuildMode;
      FPackagePrefaceName:= frm.PackagePrefaceName; // ex.: org.lamw  or  example.com
      AndroidFileDescriptor.PathToJNIFolder:= FAndroidProjectName;

      instructionChip := GetInstructionChip(FInstructionSet, LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename);
      {%EndRegion}

      try
        if FProjectModel = psNewProject then
        begin
          if FModuleType in [mtGDX, mtGUI, mtNoGUI] then   //-1:gdx 0: GUI project   1: NoGui project   2: NoGUI Exe
          begin

            FPathToJavaSrc:= FAndroidProjectName + DirectorySeparator + 'src';
            CreateDir(FAndroidProjectName+ DirectorySeparator + 'assets');
            CreateDir(FAndroidProjectName+ DirectorySeparator + 'bin');
            CreateDir(FAndroidProjectName+ DirectorySeparator + 'gen');
            CreateDir(FAndroidProjectName+ DirectorySeparator + 'res');
            CreateDir(FAndroidProjectName+ DirectorySeparator + 'res' +DirectorySeparator+'xml');

            // BuildSys: 'All'
            //       OS: 'All'
            //
            // What it does:
            //    Creates FFullJavaSrcPath -> <ProjDir>/src/pkg/preface/name/and/proj/name
            //    Creates <ProjDir>/res/drawable-hdpi/ic_launcher.png
            //    Creates <ProjDir>/res/drawable-ldpi/ic_launcher.png
            //    Creates <ProjDir>/res/drawable-mdpi/ic_launcher.png
            //    Creates <ProjDir>/res/drawable-xdpi/ic_launcher.png
            //    Creates <ProjDir>/res/drawable-xxdpi/ic_launcher.png
            //    Creates <ProjDir>/res/values/colors.xml
            //    Creates <ProjDir>/res/values/styles.xml
            //    Creates <ProjDir>/res/values/strings.xml
            //    Creates <ProjDir>/res/values-v14/styles.xml
            //    Creates <ProjDir>/res/values-v21/styles.xml
            //    Creates <ProjDir>/res/layout/activity_app.xml
            // Depends on:
            //    FAndroidProjectName, FPackagePrefaceName, FSmallProjName, FAndroidTheme, FAndroidThemeColor
            //    FPathToJavaTemplates;
            //
            {%Region /fold}
            CreateJavaSrcDir(FAndroidProjectName, FPackagePrefaceName, FSmallProjName, FFullJavaSrcPath);
            CreateDrawables(FAndroidProjectName, FPathToJavaTemplates);
            CreateColorsXml(FAndroidProjectName, FPathToJavaTemplates, FAndroidThemeColor);
            CreateStylesXml(FAndroidProjectName, FPathToJavaTemplates, FAndroidTheme);
            CreateStringsXml(FAndroidProjectName, FSmallProjName);
            CreateTargetStylesXml(FAndroidProjectName, FPathToJavaTemplates, FAndroidTheme, FMinApi, FTARgetApi);
            CreateActivityAppXml(FAndroidProjectName, FPathToJavaTemplates);
            {%EndRegion}
          end;

          if FModuleType in [mtGDX, mtGUI] then  //Android Bridges Controls... [GUI] and Gdx
          begin
            // BuildSys: 'All'
            //       OS: 'All'
            //
            // What it does:
            //    Creates FFullJavaSrcPath/App.java
            //
            // Depends On:    FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName
            //
            {%Region /fold}
            if not FileExists(FFullJavaSrcPath+DirectorySeparator+'App.java') then
            begin
               strList.Clear; //dummy App.java - will be replaced with simonsayz's "App.java" template!
               strList.Add('package '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+';');
               strList.Add('public class App extends Activity {');
               strList.Add('     //dummy app');
               strList.Add('}');
               strList.SaveToFile(FFullJavaSrcPath+DirectorySeparator+'App.java');
            end;
            {%EndRegion}
          end;

          if FModuleType = mtNoGUI then     //[No GUI]
          begin
             // BuildSys: 'All'
             //       OS: 'All'
             //
             // What it does:
             //   Creates FFullJavaSrcPath/App.java
             //   Creates FFullJavaSrcPath/FSmallProjName.java
             //   Creates FAndroidProjectName/AndroidManifest.xml
             //   Creates FAndroidProjectName/packagename.txt
             // Depends On:
             //   FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName, FSmallProjName
             //
             // Produces: FVersionCode, FVersionName
             //
             {%Region /fold}
             if not FileExists(FFullJavaSrcPath+DirectorySeparator+'App.java') then
             begin
               strList.Clear;
               strList.Add('package '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+';');
               strList.Add('');
               strList.Add('import android.os.Bundle;');
               strList.Add('import android.app.Activity;');
               strList.Add('import android.widget.Toast;');
               strList.Add('import android.util.Log;');
               strList.Add(' ');
               strList.Add('//HINT: You can change/edit "App.java" and "'+FSmallProjName+'.java" ');
               strList.Add('//to accomplish/fill  yours requirements...');
               strList.Add(' ');
               strList.Add('public class App extends Activity {');
               strList.Add('  ');

               strList.Add('   '+FSmallProjName+' m'+FSmallProjName+';  //just for demo...');
               strList.Add('  ');
               strList.Add('   @Override');
               strList.Add('   protected void onCreate(Bundle savedInstanceState) {');
               strList.Add('       super.onCreate(savedInstanceState);');
               strList.Add('       setContentView(R.layout.activity_app);');
               strList.Add('');

               strList.Add('       m'+FSmallProjName+' = new '+FSmallProjName+'(); //just for demo...');
               strList.Add('');
               strList.Add('       int sum = m'+FSmallProjName+'.getSum(2,3); //just for demo...');
               strList.Add('       Toast.makeText(getApplicationContext(), "m'+FSmallProjName+'.getSum(2,3) = "+ sum,Toast.LENGTH_LONG).show();');
               strList.Add(' ');
               strList.Add('       String mens = m'+FSmallProjName+'.getString(1); //just for demo...');
               strList.Add('       Toast.makeText(getApplicationContext(), "m'+FSmallProjName+'.getString(1) = "+ mens,Toast.LENGTH_LONG).show();');
               strList.Add(' ');
               strList.Add('   }');
               strList.Add('}');
               strList.SaveToFile(FFullJavaSrcPath+DirectorySeparator+'App.java');
             end;

             if not FileExists(FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java') then
             begin
               strList.Clear;
               strList.Add('package '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+';');
               strList.Add('');
               strList.Add('//HINT: You can change/edit "App.java" and "'+FSmallProjName+'.java"');
               strList.Add('//to accomplish/fill  yours requirements...');
               strList.Add('');
               strList.Add('public class '+FSmallProjName+' {');
               strList.Add('');
  	           strList.Add('  public native String getString(int flag);  //just for demo...');
  	           strList.Add('  public native int getSum(int x, int y);    //just for demo...');
               strList.Add('');
               strList.Add('  static {');
         	     strList.Add('	  try {');
       	       strList.Add('	      System.loadLibrary("'+LowerCase(FSmallProjName)+'");');
  	           strList.Add('	  } catch(UnsatisfiedLinkError ule) {');
   	           strList.Add('	      ule.printStackTrace();');
   	           strList.Add('	  }');
               strList.Add('  }');
               strList.Add('');
               strList.Add('}');
               strList.SaveToFile(FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java');
             end;

             strList.Clear;

             if not FileExists(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml') then
             begin
               strList.Add('<?xml version="1.0" encoding="utf-8"?>');
               strList.Add('<manifest xmlns:android="http://schemas.android.com/apk/res/android"');
               strList.Add('    package="'+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+'"');
               strList.Add('    android:versionCode="1"');
               strList.Add('    android:versionName="1.0" >');
               strList.Add('    <uses-sdk android:minSdkVersion="14" android:targetSdkVersion="29"/>');
               strList.Add('    <application');
               strList.Add('        android:allowBackup="true"');
               strList.Add('        android:icon="@drawable/ic_launcher"');
               strList.Add('        android:label="@string/app_name"');
               strList.Add('        android:theme="@style/AppTheme" >');
               strList.Add('        <activity');
               strList.Add('            android:name="'+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+'.App"');
               strList.Add('            android:label="@string/app_name" >');
               strList.Add('            <intent-filter>');
               strList.Add('                <action android:name="android.intent.action.MAIN" />');
               strList.Add('                <category android:name="android.intent.category.LAUNCHER" />');
               strList.Add('            </intent-filter>');
               strList.Add('        </activity>');
               strList.Add('    </application>');
               strList.Add('</manifest>');
               strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');
               FVersionCode := 1;
               FVersionName := '1.0';
             end else
             begin
              ReadXMLFile(xmlAndroidManifest, FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');

              if (xmlAndroidManifest = nil) or (xmlAndroidManifest.DocumentElement = nil) then
                 Exit;
              with xmlAndroidManifest.DocumentElement do
              begin
                      FVersionCode := StrToIntDef(AttribStrings['android:versionCode'], 1);
                      FVersionName := AttribStrings['android:versionName'];
                      if FVersionName = '' then  FVersionName:= '1.0';
              end;
             end;

             strList.Clear;
             strList.Add(FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
             strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'packagename.txt');
             {%EndRegion}

          end; //just Ant NoGUI project

        end; // Ant

        if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
        begin

          //
          //  All (Ant + Gradle)
          //
          {$IFDEF FULL}
          // BuildSys: 'All'
          //       OS: 'All'
          // Produces:
          //    FAndroidProjectName/keytool_input.txt
          //    FAndroidProjectName/How_To_Get_Your_Signed_Release_Apk.txt
          //    FAndroidProjectName/adb-uninstall[.bat/.sh]
          //    FAndroidProjectName/logcat[.bat/.sh]
          //    FAndroidProjectName/utils/logcat-error[.bat/.sh]
          //    FAndroidProjectName/release-keystore[.bat/.sh]
          // Requires:
          //    FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName, FAndroidProjectName,
          //    FPathToJavaJDK, FMinApi,
          //    FAntBuildMode, FAntPackageName, FMainActivity,
          {%Region /fold}
          CreateKeyToolInput(FAndroidProjectName);
          CreateHowToGetYourSignedReleaseApk(FAndroidProjectName, FSmallProjName);
          CreateADbUninstall(FAndroidProjectName, FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName);
          CreateLogcat(FAndroidProjectName, FPathToAndroidSDK);
          CreateLogcatError(FAndroidProjectName, FPathToAndroidSDK);
          CreateReleaseKeyStore(FAndroidProjectName, FPathToJavaJDK, FSmallProjName);
          {%EndRegion}

          {$IFDEF WINDOWS}
          // BuildSys: 'All'
          //       OS: 'Windows'
          // Produces:
          //    FAndroidProjectName/utils/list-target.bat,
          //    FAndroidProjectName/utils/paused-list-target.bat,
          //    FAndroidProjectName/utils/create-avd-default.bat,
          //    FAndroidProjectName/utils/paused-create-avd-default.bat
          //    FAndroidProjectName/launch-avd-default.bat
          //
          // Requires:
          //    FAndroidProjectName, FPathToAndroidSDK, FMinApi
          //
          {%Region /fold}
          CreateAVDUtils(FAndroidProjectName, FPathToAndroidSDK, FMinApi);
          {%EndRegion}
          {$ENDIF}
          {$ENDIF FULL}

          if FBuildSystem = 'Ant' then
          begin
          //
          // ANT
          //

          // BuildSys: 'Ant'
          //       OS: 'All'
          // Produces:
          //    FAndroidProjectName/build.xml
          //    FAndroidProjectName/readme.txt
          //    FAndroidProjectName/ant.properties
          //    FAndroidProjectName/proguard-project.txt
          //    FAndroidProjectName/project.properties
          // Requires:
          //    FSmallProjName, FPathToAndroidSDK, FAndroidTheme, FTargetApi, FAntBuildMode,
          //    FPackagePrefaceName, FAndroidProjectName
          {%Region /fold}
          CreateBuildXML(FAndroidProjectName, FPathToAndroidSDK, FAndroidTheme, FTargetApi, FPackagePrefaceName, FSmallProjName);
          CreateAntReadme(FAndroidProjectName, FAntBuildMode, FSmallProjName);
          CreateAntProperties(FAndroidProjectName, FSmallProjName);
          CreateProguardPoject(FAndroidProjectName);
          CreateProjectProperties(FAndroidProjectName, FAndroidTheme, FTargetApi);
          {%EndRegion}

          {$IFDEF FULL}
          {%Region /fold Full Ant region}
          // BuildSys: 'Ant'
          //       OS: 'All'
          // Produces:
          //    FAndroidProjectName/logcat-app-perform[.bat/.sh]
          //    //FAndroidProjectName/launch-apk[.bat/.sh]
          //    //FAndroidProjectName/utils/aapt[.bat/.sh]
          //    FAndroidProjectName/ant-build-debug[.bat/.sh]
          //    FAndroidProjectName/ant-build-release[.bat/.sh]
          //    FAndroidProjectName/ant-adb-install-debug[.bat/.sh]
          //    FAndroidProjectName/ant-jarsigner-verify[.bat/.sh]
          // Requires:
          //    FPathToAntBin, FPathToJavaJDK, FAndroidProjectName, FPathToAndroidSDK,
          //    FSmallProjName, FPackagePrefaceName,
          {%Region /fold}
          CreateLogcatAppPerform(FAndroidProjectName, FPathToAndroidSDK, FSmallProjName, FAntBuildMode);
          // Missing FAntPackageName
          //CreateLaunchAPK(FAndroidProjectName, FPathToAndroidSDK, FAntPackageName, FMainActivity);
          //CreateAAPT(FAndroidProjectName, FPathToAndroidSDK, FAntPackageName, FMinApi, FSmallProjName, FAntBuildMode);
          CreateAntBuildDebug(FAndroidProjectName, FPathToJavaJDK, FPathToAntBin);
          CreateAntBuildRelease(FAndroidProjectName,FPathToJavaJDK, FPathToAntBin);
          CreateAntAdbInstallDebug(FAndroidProjectName, FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName);
          CreateAntJarsignerVerify(FAndroidProjectName, FPathToJavaJDK, FSmallProjName);
          {%EndRegion}
          {$ENDIF FULL}
          end; // if "Ant"

          if FBuildSystem = 'Gradle' then
          begin
          //
          // GRADLE
          //

          // BuildSys: 'Gradle'
          //       OS: 'All'
          // Produces:
          //    FAndroidProjectName/gradle.properties
          //    FAndroidProjectName/local.properties
          //    FAndroidProjectName/build.gradle
          //    FAndroidProjectName/gradle_readme.txt
          // Requires:
          //    FMaxSdkPlatform, FGradleVersion, instructionChip,
          //    FAndroidTheme, FMinApi, FTargetApi, FPathToAndroidSDK, FVersionCode
          //    FVersionName, FPackagePrefaceName, FSmallProjName, FAndroidProjectName
          //    FPathToGradle, FPathToJavaJDK, FPathToAndroidNDK, FSupport
          {%Region /fold}
          CreateGradleProperties(FAndroidProjectName, FAndroidTheme, FPathToJavaJDK);
          CreateLocalProperties(FAndroidProjectName, FPathToAndroidSDK, FPathToAndroidNDK);
          //Add GRADLE support ... [... initial code ...]
          //Building "build.gradle" file    -- for gradle we need "sdk/build-tools" >= 21.1.1
          if not CreateBuildGradle(FAndroidProjectName, FPathToAndroidSDK, FMaxSdkPlatform,
              FGradleVersion, FAndroidTheme, instructionChip, FMinApi, FTargetApi,
              FVersionCode, FVersionName, FSupport, FPackagePrefaceName, FSmallProjName) then
          begin
            result := true;
            exit;
          end;
          CreateGradleReadme(FAndroidProjectName, FPathToGradle, FPathToAndroidSDK);
          {%EndRegion}

          {$IFDEF FULL}
          // BuildSys: 'Gradle'
          //       OS: 'All'
          // Produces:
          //    FAndroidProjectName/gradle-adb-install-debug[.bat/sh]
          //    FAndroidProjectName/gradle-jarsigner-verify[.bat/sh]
          //    FAndroidProjectName/gradle-making-wrapper[.bat/sh]
          //    FAndroidProjectName/gradlew-build[.bat/sh]
          //    FAndroidProjectName/gradlew-run[.bat/sh]
          //    FAndroidProjectName/gradle-local-build[.bat/sh]
          //    FAndroidProjectName/gradle-local-build-bundle[.bat/sh]
          //    FAndroidProjectName/gradle-local-apksigner[.bat/sh]
          //    FAndroidProjectName/gradle-local-universal-apksigner[.bat/sh]
          //    FAndroidProjectName/gradle-local-run[.bat/sh]
          // Requires:
          //    FMaxSdkPlatform, FCandidateSdkBuild, FGradleVersion, instructionChip,
          //    FAndroidTheme, AppCompatLibs, FPathToAndroidSDK, FPathToGradle,
          //    FAndroidProjectName, FPackagePrefaceName, FSmallProjName,
          //
          {%Region /fold}
          CreateGradleAdbInstallDebug(FAndroidProjectName, FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName, instructionChip);
          CreateGradleJarsignerVerify(FAndroidProjectName, FPathToJavaJDK, FSmallProjName);

          //Drafts Making gradlew (= gradle warapper)
          CreateGradleMakingWrapper(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle);
          CreateGradleWBuild(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle);
          CreateGradleWRun(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle);

          CreateGradleLocalBuild(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle);
          CreateGradleLocalBuildBundle(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle);
          CreateGradleLocalAPKSigner(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle, FSmallProjName, instructionChip, FMaxSdkPlatform);
          CreateGradleLocalUniversalAPKSigner(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle, FSmallProjName, FMaxSdkPlatform);
          CreateGradleLocalRun(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle);
          {%EndRegion}
          {$ENDIF FULL}
          end; // if "Gradle"
        end;

        Result := True;
      except
        on e: Exception do
          MessageDlg('Error',e.Message,mtError,[mbOK],0);
      end;
    end;
  finally
    strList.Free;
    frm.Free;
  end;
end;

function TAndroidProjectDescriptor.DoInitDescriptor: TModalResult;
var
   auxList: TStringList;
   outTag: TModuleType;
begin
   FModuleType := mtNoGUI;
   if GetWorkSpaceFromForm(mtNoGUI, outTag) then //1: noGUI project
   begin
      if TryNewJNIAndroidInterfaceCode(mtNoGUI) then //1: noGUI project
      begin
        CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni');
        CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'mips');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
        CreateDir(FAndroidProjectName+DirectorySeparator+'obj');
        CreateDir(FAndroidProjectName+DirectorySeparator+'lamwdesigner');

        if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
           CreateDir(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');

        //eclispe compatibility!
        CreateDir(FAndroidProjectName+DirectorySeparator+'.settings');

        auxList:= TStringList.Create;
        auxList.Add('eclipse.preferences.version=1');
        auxList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.6');
        auxList.Add('org.eclipse.jdt.core.compiler.compliance=1.6');
        auxList.Add('org.eclipse.jdt.core.compiler.source=1.6');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs');

        auxList.Clear;
        auxList.Add('<?xml version="1.0" encoding="UTF-8"?>');
        auxList.Add('<classpath>');
	auxList.Add('<classpathentry kind="src" path="src"/>');
	auxList.Add('<classpathentry kind="src" path="gen"/>');
	auxList.Add('<classpathentry kind="con" path="com.android.ide.eclipse.adt.ANDROID_FRAMEWORK"/>');
	auxList.Add('<classpathentry exported="true" kind="con" path="com.android.ide.eclipse.adt.LIBRARIES"/>');
	auxList.Add('<classpathentry exported="true" kind="con" path="com.android.ide.eclipse.adt.DEPENDENCIES"/>');
	auxList.Add('<classpathentry kind="output" path="bin/classes"/>');
        auxList.Add('</classpath>');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.classpath');

        auxList.Clear;
        auxList.Add('<projectDescription>');
        auxList.Add('	<name>'+FSmallProjName+'</name>');
        auxList.Add('	<comment></comment>');
        auxList.Add('	<projects>');
        auxList.Add('	</projects>');
        auxList.Add('	<buildSpec>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>com.android.ide.eclipse.adt.ResourceManagerBuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add('		</buildCommand>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>com.android.ide.eclipse.adt.PreCompilerBuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add('		</buildCommand>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>org.eclipse.jdt.core.javabuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add('		</buildCommand>');
        auxList.Add('		<buildCommand>');
        auxList.Add('			<name>com.android.ide.eclipse.adt.ApkBuilder</name>');
        auxList.Add('			<arguments>');
        auxList.Add('			</arguments>');
        auxList.Add(' 		</buildCommand>');
        auxList.Add('	</buildSpec>');
        auxList.Add('	<natures>');
        auxList.Add('		<nature>com.android.ide.eclipse.adt.AndroidNature</nature>');
        auxList.Add('		<nature>org.eclipse.jdt.core.javanature</nature>');
        auxList.Add('	</natures>');
        auxList.Add('</projectDescription>');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.project');

        auxList.Clear;
        auxList.Add('# To enable ProGuard in your project, edit project.properties');
        auxList.Add('# to define the proguard.config property as described in that file.');
        auxList.Add('#');
        auxList.Add('# Add project specific ProGuard rules here.');
        auxList.Add('# By default, the flags in this file are appended to flags specified');
        auxList.Add('# in ${sdk.dir}/tools/proguard/proguard-android.txt');
        auxList.Add('# You can edit the include path and order by changing the ProGuard');
        auxList.Add('# include property in project.properties.');
        auxList.Add('#');
        auxList.Add('# For more details, see');
        auxList.Add('#   http://developer.android.com/guide/developing/tools/proguard.html');
        auxList.Add(' ');
        auxList.Add('# Add any project specific keep options here:');
        auxList.Add(' ');
        auxList.Add('# If your project uses WebView with JS, uncomment the following');
        auxList.Add('# and specify the fully qualified class name to the JavaScript interface');
        auxList.Add('# class:');
        auxList.Add('#-keepclassmembers class fqcn.of.javascript.interface.for.webview {');
        auxList.Add('#   public *;');
        auxList.Add('#}');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'proguard-project.txt');

        auxList.Clear;
        auxList.Add('# This file is automatically generated by Android Tools.');
        auxList.Add('# Do not modify this file -- YOUR CHANGES WILL BE ERASED!');
        auxList.Add('#');
        auxList.Add('# This file must be checked in Version Control Systems.');
        auxList.Add('#');
        auxList.Add('# To customize properties used by the Ant build system edit');
        auxList.Add('# "ant.properties", and override values to adapt the script to your');
        auxList.Add('# project structure.');
        auxList.Add('#');
        auxList.Add('# To enable ProGuard to shrink and obfuscate your code, uncomment this (available properties: sdk.dir, user.home):');
        auxList.Add('#proguard.config=${sdk.dir}/tools/proguard/proguard-android.txt:proguard-project.txt');
        auxList.Add(' ');
        auxList.Add('# Project target.');
        auxList.Add('target=android-'+Trim(FTargetApi));
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'project.properties');

        auxList.Clear;
        auxList.Add(FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator + 'packagename.txt');

        auxList.Free;

        Result := mrOK
      end
      else
        Result := mrAbort;
   end
   else Result := mrAbort;
end;


function TAndroidProjectDescriptor.InitProject(AProject: TLazProject): TModalResult;
var
  MainFile: TLazProjectFile;
  projName, projDir, auxStr, auxInstr: string;
  sourceList: TStringList;
  auxList: TStringList;

  libraries_x86: string;
  libraries_x86_64: string;
  libraries_arm: string;
  libraries_mips: string;
  libraries_aarch64: string;

  customOptions_default: string;
  customOptions_x86: string;
  customOptions_x86_64: string;
  customOptions_mips: string;
  customOptions_armV6: string;
  customOptions_armV7a: string;
  customOptions_armV7a_VFPv3: string;
  customOptions_armV8: string;

  androidPlatformApi: string;
  PathToNdkPlatformsArm: string;
  PathToNdkPlatformsX86: string;
  PathToNdkPlatformsX86_64: string;
  PathToNdkPlatformsMips: string;
  PathToNdkPlatformsAarch64: string;

  pathToNdkToolchainsX86: string;
  pathToNdkToolchainsX86_64: string;
  pathToNdkToolchainsArm: string;
  pathToNdkToolchainsMips: string;
  pathToNdkToolchainsAarch64: string;

  pathToNdkToolchainsBinX86: string;
  pathToNdkToolchainsBinX86_64: string;
  pathToNdkToolchainsBinArm: string;
  pathToNdkToolchainsBinMips: string;
  pathToNdkToolchainsBinAarch64: string;

  osys: string;      {windows or linux-x86 or linux-x86_64}
  headerList: TStringList;
begin

  inherited InitProject(AProject);

  if  FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    projName:= LowerCase(FJavaClassName) + '.lpr'
  else
    projName:= LowerCase(FSmallProjName) + '.lpr';

  if   FPathToClassName = '' then
      FPathToClassName:= StringReplace(FPackagePrefaceName, '.', '/', [rfReplaceAll])+'/'+LowerCase(FSmallProjName)+'/'+ FJavaClassName; //ex. 'com/example/appasynctaskdemo1/Controls'

  if  FModuleType in [mtGDX, mtGUI, mtNoGUI] then
     projDir:= FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator
  else
     projDir:= FPathToJNIFolder+DirectorySeparator;

  if FModuleType = mtGDX then    {-1: gdx 0: GUI; 1: NoGUI; 2: NoGUI EXE Console}
  begin
    AProject.CustomData.Values['LAMW'] := 'GDX';
    AProject.CustomData.Values['Theme']:= 'GDXGame';
    //TODO: AProject.CustomData.Values['ThemeColor'] := FAndroidThemeColor;
    AProject.CustomData['StartModule'] := 'GdxModule1';
  end
  else if FModuleType = mtGUI then    {0: GUI; 1: NoGUI; 2: NoGUI EXE Console}
  begin
    AProject.CustomData.Values['LAMW'] := 'GUI';

    AProject.CustomData.Values['Theme']:= FAndroidTheme;
    AProject.CustomData.Values['ThemeColor'] := FAndroidThemeColor;

    AProject.CustomData['StartModule'] := 'AndroidModule1';
    if FSupport then
      AProject.CustomData.Values['Support'] := 'TRUE'
    else
      AProject.CustomData.Values['Support'] := 'FALSE';
  end
  else if  FModuleType = mtGUI then
    AProject.CustomData.Values['LAMW'] := 'NoGUI'
  else if FModuleType = mtNoGUIConsole then
    AProject.CustomData.Values['LAMW'] := 'NoGUIConsoleApp'    // FModuleType =2
  else
    AProject.CustomData.Values['LAMW'] := 'NoGUIGenericLibrary';    // FModuleType = 3

  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then    {-1:gdx 0: GUI; 1: NoGUI; 2: NoGUI EXE Console}
    AProject.CustomData.Values['Package']:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

  AProject.CustomSessionData.Values['NdkPath']:= FPathToAndroidNDK;
  AProject.CustomSessionData.Values['SdkPath']:= FPathToAndroidSDK;

  AProject.CustomData.Values['NdkApi']:= 'android-'+FNdkApi; //legacy

  AProject.CustomData.Values['BuildSystem'] := FBuildSystem;

  AProject.ProjectInfoFile := projDir + ChangeFileExt(projName, '.lpi');

  MainFile := AProject.CreateProjectFile(projDir + projName);

  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;

  if FModuleType in [mtGDX, mtGUI] then  //GUI
    AProject.AddPackageDependency('tfpandroidbridge_pack'); //GUI or gdx  controls

  sourceList:= TStringList.Create;              //FSmallProjName
  //sourceList.Add('{hint: save all files to location: ' + projDir + ' }');
  sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+FSmallProjName+DirectorySeparator+'jni }');

  if FModuleType = mtNoGUIConsole then  //console executavel
    sourceList.Add('program '+ LowerCase(FSmallProjName) +'; '+ ' //[by LAMW: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']')
  else if  FModuleType = mtLibrary then
    sourceList.Add('library '+ LowerCase(FSmallProjName) +'; '+ ' //[by LAMW: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']')
  else
    sourceList.Add('library '+ LowerCase(FJavaClassName) +'; '+ ' //[by LAMW: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']');

  sourceList.Add(' ');
  sourceList.Add('{$mode delphi}');
  sourceList.Add(' ');

  sourceList.Add('uses');

  if FModuleType in [mtGDX, mtGUI] then  //GUI or gdx controls
  begin
    //https://forum.lazarus.freepascal.org/index.php/topic,45715.msg386317
    sourceList.Add('  {$IFDEF UNIX}{$IFDEF UseCThreads}');
    sourceList.Add('  cthreads,');
    sourceList.Add('  {$ENDIF}{$ENDIF}');
  end;

  if FModuleType in [mtGDX, mtGUI] then  //-1:gdx    0:GUI or   1:noGUI controls
  begin
    sourceList.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,');
    sourceList.Add('  Laz_And_Controls_Events;');
    sourceList.Add(' ');
  end
  else if FModuleType = mtNoGUI then //NoGUI ---  Not Android Bridges Controls
  begin
    sourceList.Add('  Classes, SysUtils, CustApp, jni;');
    sourceList.Add(' ');
    sourceList.Add('type');
    sourceList.Add(' ');
    sourceList.Add('  TNoGUIApp = class(TCustomApplication)');
    sourceList.Add('  public');
    sourceList.Add('     jClassName: string;');
    sourceList.Add('     jAppName: string;');
    sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
    sourceList.Add('     destructor Destroy; override;');
    sourceList.Add('  end;');
    sourceList.Add(' ');
    sourceList.Add('procedure TNoGUIApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('var');
    sourceList.Add('  Instance: TComponent;');
    sourceList.Add('begin');
    sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
    sourceList.Add('  TComponent(Reference):= Instance;');
    sourceList.Add('  Instance.Create(Self);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('constructor TNoGUIApp.Create(TheOwner: TComponent);');
    sourceList.Add('begin');
    sourceList.Add('  inherited Create(TheOwner);');
    sourceList.Add('  StopOnException:=True;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('destructor TNoGUIApp.Destroy;');
    sourceList.Add('begin');
    sourceList.Add('  inherited Destroy;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('var');
    sourceList.Add('  gNoGUIApp: TNoGUIApp;');
    sourceList.Add('  gNoGUIjAppName: string;');
    sourceList.Add('  gNoGUIAppjClassName: string;');

    sourceList.Add('');
  end
  else if FModuleType = mtNoGUIConsole then// 2 - NoGUI console executable
  begin
    sourceList.Add('  Classes, SysUtils, CustApp;');
    sourceList.Add(' ');
    sourceList.Add('type');
    sourceList.Add(' ');
    sourceList.Add('  TAndroidConsoleApp = class(TCustomApplication)');
    sourceList.Add('  public');
    sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
    sourceList.Add('     destructor Destroy; override;');
    sourceList.Add('  end;');
    sourceList.Add(' ');
    sourceList.Add('procedure TAndroidConsoleApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('var');
    sourceList.Add('  Instance: TComponent;');
    sourceList.Add('begin');
    sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
    sourceList.Add('  TComponent(Reference):= Instance;');
    sourceList.Add('  Instance.Create(Self);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('constructor TAndroidConsoleApp.Create(TheOwner: TComponent);');
    sourceList.Add('begin');
    sourceList.Add('  inherited Create(TheOwner);');
    sourceList.Add('  StopOnException:=True;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('destructor TAndroidConsoleApp.Destroy;');
    sourceList.Add('begin');
    sourceList.Add('  inherited Destroy;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('var');
    sourceList.Add('  AndroidConsoleApp: TAndroidConsoleApp;');
    sourceList.Add('');
  end
  else //generic .so library // FModuleType = 3
  begin
    sourceList.Add('  Unit1;');  //ok
  end;

  if FModuleType in [mtGDX, mtGUI] then //GUI
  begin
    sourceList.Add('{%region /fold ''LAMW generated code''}');
    sourceList.Add('');
    sourceList.Add(FPascalJNIInterfaceCode);
    sourceList.Add('{%endregion}');
  end;

  sourceList.Add(' ');

  if FModuleType in [mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole] then sourceList.Add('begin');

  if FModuleType = mtGDX then  //Gdx Android Bridges controls...
  begin
    sourceList.Add('  gApp:= jApp.Create(nil);');
    sourceList.Add('  gApp.Title:= ''LAMW GDX Android Bridges Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';'); //com.example.appasynctaskdemo1
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';');           //com/example/appasynctaskdemo1/Controls
    sourceList.Add('  gApp.AppName:=gjAppName;');
    sourceList.Add('  gApp.ClassName:=gjClassName;');
    sourceList.Add('  gApp.Initialize;');
    sourceList.Add('  gApp.CreateForm(TGdxModule1, GdxModule1);');
  end
  else if FModuleType = mtGUI then  //GUI Android Bridges controls...
  begin
    sourceList.Add('  gApp:= jApp.Create(nil);');
    sourceList.Add('  gApp.Title:= ''LAMW JNI Android Bridges Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';'); //com.example.appasynctaskdemo1
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';');           //com/example/appasynctaskdemo1/Controls
    sourceList.Add('  gApp.AppName:=gjAppName;');
    sourceList.Add('  gApp.ClassName:=gjClassName;');
    sourceList.Add('  gApp.Initialize;');
    sourceList.Add('  gApp.CreateForm(TAndroidModule1, AndroidModule1);');
  end
  else if FModuleType = mtNoGUI then
  begin
     sourceList.Add('  gNoGUIApp:= TNoGUIApp.Create(nil);');
     sourceList.Add('  gNoGUIApp.Title:= ''My Android Pure Library'';');
     sourceList.Add('  gNoGUIjAppName:= '''+GetAppName(FPathToClassName)+''';');
     sourceList.Add('  gNoGUIAppjClassName:= '''+FPathToClassName+''';');

     sourceList.Add('  gNoGUIApp.jAppName:=gNoGUIjAppName;');
     sourceList.Add('  gNoGUIApp.jClassName:=gNoGUIAppjClassName;');

     sourceList.Add('  gNoGUIApp.Initialize;');
     sourceList.Add('  gNoGUIApp.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);');
  end
  else if FModuleType = mtNoGUIConsole then // 2  - console executable
  begin
     sourceList.Add('  AndroidConsoleApp:= TAndroidConsoleApp.Create(nil);');
     sourceList.Add('  AndroidConsoleApp.Title:= ''Android Executable Console App'';');
     sourceList.Add('  AndroidConsoleApp.Initialize;');
     sourceList.Add('  AndroidConsoleApp.CreateForm(TAndroidConsoleDataForm1,AndroidConsoleDataForm1);');
  end
  else
  begin  //generic library     // FModuleType = 3
    sourceList.Add(' ');
    sourceList.Add('function Sum(a: longint; b: longint): longint; cdecl;');
    sourceList.Add('begin');
    sourceList.Add('  Result:= SumAB(a, b);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('exports');
    sourceList.Add('  Sum;');
    sourceList.Add(' ');

    headerList:= TStringList.Create;
    headerList.Add('unit '+LowerCase(FSmallProjName)+'_h');
    headerList.Add(' ');
    headerList.Add('interface');
    headerList.Add(' ');
    headerList.Add('  function Sum(a: longint; b: longint): longint; cdecl; external ''lib'+LowerCase(FSmallProjName)+'.so'' name ''Sum'';');
    headerList.Add(' ');
    headerList.Add('implementation');
    headerList.Add(' ');
    headerList.Add('end.');
    headerList.SaveToFile(projDir+'libs'+DirectorySeparator+LowerCase(FSmallProjName)+'_h.pas');
    headerList.Free;

  end;

  sourceList.Add('end.');
  AProject.MainFile.SetSourceText(sourceList.Text, True);

  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements,
                                      pfMainUnitHasTitleStatement,
                                      pfLRSFilesInOutputDirectory];
  AProject.UseManifest:= False;
  AProject.UseAppBundle:= False;

  if (Length(FPrebuildOSYS)=0) then
  begin
    {$ifdef Windows}
    FPrebuildOSYS:='windows-x86_64';
    {$endif}
    {$ifdef Linux}
    FPrebuildOSYS:='linux';
    {$endif}
    {$ifdef Darwin}
    FPrebuildOSYS:='darwin';
    {$endif}
  end;

  osys:= FPrebuildOSys;

  {Set compiler options for Android requirements}
  if FNDKIndex < 6 then
  begin
    androidPlatformApi:= 'android-'+FNdkApi;
    PathToNdkPlatformsArm:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                  androidPlatformApi +DirectorySeparator+'arch-arm'+DirectorySeparator+
                                                  'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsAarch64:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                  androidPlatformApi +DirectorySeparator+'arch-arm64'+DirectorySeparator+
                                                  'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsX86:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                               androidPlatformApi+DirectorySeparator+'arch-x86'+DirectorySeparator+
                                               'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsX86_64:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                               androidPlatformApi+DirectorySeparator+'arch-x86_64'+DirectorySeparator+
                                               'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsMips:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                               androidPlatformApi+DirectorySeparator+'arch-mips'+DirectorySeparator+
                                               'usr'+DirectorySeparator+'lib';
  end
  else //NDK >= 22
  begin
   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\arm-linux-androideabi\22
   PathToNdkPlatformsArm:=ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','arm-linux-androideabi', FNdkApi]);

   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\aarch64-linux-android\22
   PathToNdkPlatformsAarch64:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','aarch64-linux-android', FNdkApi]);

   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\i686-linux-android\22
   PathToNdkPlatformsX86:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','i686-linux-android', FNdkApi]);

   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\x86_64-linux-android\22
    PathToNdkPlatformsX86_64:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','x86_64-linux-android', FNdkApi]);

    PathToNdkPlatformsMips:= ''; //note supported since NDK 18 ...
  end;

  {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
  if {FNDK = '7'} FNDKIndex = 0 then
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.4.3';

      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                  'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                  'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                  'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+
                                                 'gcc'+DirectorySeparator+'i686-android-linux'+DirectorySeparator+'4.4.3';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

  end else if {(FNDK = '9') or (FNDK = '10') or (FNDK = '10c')} (FNDKIndex > 0) and (FNDKIndex < 3) then          //arm-linux-androideabi-4.9
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.6';
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.6';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
  end else if {FNDK = '10e'} {FNDK = '11c'} (FNDKIndex >=3) and (FNDKIndex < 5) then          //arm-linux-androideabi-4.9
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.9';


      pathToNdkToolchainsAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'aarch64-linux-android'+DirectorySeparator+'4.9';

      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsBinAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.9';

      pathToNdkToolchainsX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'x86_64-android-linux'+DirectorySeparator+'4.9';

      pathToNdkToolchainsMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                  'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                  osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                  'mipsel-linux-android'+DirectorySeparator+'4.9';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';


      pathToNdkToolchainsBinX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

  end else if {FNDK = '>11'} FNDKIndex >= 5 then          //arm-linux-androideabi-4.9
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'aarch64-linux-android'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsBinAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                   'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                   osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                   'i686-android-linux'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                   'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                   osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                   'x86_64-android-linux'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                    'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                    osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+                                                   'mipsel-linux-android'+DirectorySeparator+'4.9.x';
  end;

  if PathToNdkPlatformsArm <> '' then
    libraries_arm:= PathToNdkPlatformsArm+';'+pathToNdkToolchainsArm
  else  libraries_arm:= pathToNdkToolchainsArm;

  if PathToNdkPlatformsAarch64 <>'' then
      libraries_aarch64:= PathToNdkPlatformsAarch64+';'+pathToNdkToolchainsAarch64
  else libraries_aarch64:= pathToNdkToolchainsAarch64;

  if PathToNdkPlatformsX86 <>'' then
     libraries_x86:= PathToNdkPlatformsX86+';'+pathToNdkToolchainsX86
  else libraries_x86:= pathToNdkToolchainsX86;

  if PathToNdkPlatformsX86_64 <>'' then
    libraries_x86_64:= PathToNdkPlatformsX86_64+';'+pathToNdkToolchainsX86_64
  else libraries_x86_64:= pathToNdkToolchainsX86_64;

  if PathToNdkPlatformsMips <>'' then
     libraries_mips:= PathToNdkPlatformsMips+';'+pathToNdkToolchainsMips
  else libraries_mips:= pathToNdkToolchainsMips;


  //https://developer.android.com/ndk/guides/abis
  auxStr:='armeabi'; //ARMv6
  auxInstr:= LowerCase(FInstructionSet);
  if auxInstr = 'armv7a' then auxStr:='armeabi-v7a';
  if auxInstr = 'x86'    then auxStr:='x86';
  if auxInstr = 'x86_64' then auxStr:='x86_64';
  if auxInstr = 'mipsel' then auxStr:='mips';
  if auxInstr = 'armv8'  then auxStr:='arm64-v8a';

  if Self.FAndroidTheme = 'GDXGame' then
  begin
    CopyFile(FPathToJavaTemplates+DirectorySeparator+'gdx'+DirectorySeparator+auxStr+DirectorySeparator+'libgdx.so',
             FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'libgdx.so');

    CopyFile(FPathToJavaTemplates+DirectorySeparator+'gdx'+DirectorySeparator+auxStr+DirectorySeparator+'libgdx-box2d.so',
             FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'libgdx-box2d.so');
  end;

  AProject.LazCompilerOptions.TargetCPU:= 'arm';    {-P}
  SetProjectLibraries(AProject, libraries_arm);

  if Pos('mips', auxStr) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'mipsel';    {-P}
     SetProjectLibraries(AProject, libraries_mips);  { -Fl}
  end
  else if Pos('x86_64', auxStr) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'x86_64';    {-P}
     SetProjectLibraries(AProject, libraries_x86_64);  { -Fl}
  end
  else if Pos('x86', auxStr) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'i386';    {-P}
     SetProjectLibraries(AProject, libraries_x86);  { -Fl}
  end
  else if Pos('arm64', auxStr) > 0 then
  begin
    AProject.LazCompilerOptions.TargetCPU:= 'aarch64';    {-P}
    SetProjectLibraries(AProject, libraries_aarch64); { -Fl}
  end;

  {Parsing}
  AProject.LazCompilerOptions.SyntaxMode:= 'delphi';  {-M}
  AProject.LazCompilerOptions.CStyleOperators:= True;
  AProject.LazCompilerOptions.AllowLabel:= True;
  AProject.LazCompilerOptions.CPPInline:= True;
  AProject.LazCompilerOptions.CStyleMacros:= True;
  AProject.LazCompilerOptions.UseAnsiStrings:= True;
  AProject.LazCompilerOptions.UseLineInfoUnit:= True;

  {Code Generation}
  AProject.LazCompilerOptions.TargetOS:= 'android'; {-T}

  AProject.LazCompilerOptions.OptimizationLevel:= 3;
  AProject.LazCompilerOptions.Win32GraphicApp:= False;

  {Link}
  AProject.LazCompilerOptions.StripSymbols:= True; {-Xs}
  AProject.LazCompilerOptions.LinkSmart:= True {-XX};
  AProject.LazCompilerOptions.GenerateDebugInfo:= False;
  AProject.LazCompilerOptions.SmallerCode:= True;
  AProject.LazCompilerOptions.SmartLinkUnit:= True;

  if FModuleType = mtNoGUIConsole then
  begin
    if FPieChecked then  //here PIE support .. ok sorry... :(  ...bad code reuse!
    begin
      AProject.LazCompilerOptions.PassLinkerOptions:= True;
      AProject.LazCompilerOptions.LinkerOptions:='-pie'
    end;
  end;

  customOptions_default:='-Xd'; //x86   aarch64   mips
  if Pos('armeabi', auxStr) > 0 then
  begin
     customOptions_default:='-Xd'+' -Cf'+ FFPUSet;
     customOptions_default:= customOptions_default + ' -Cp'+ UpperCase(FInstructionSet);
  end;

  customOptions_armV6 := '-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV6';
  customOptions_armV7a:= '-Xd'+' -CfSoft -CpARMV7A';
  customOptions_armV7a_VFPv3:= '-Xd'+' -CfVFPv3 -CpARMV7A';
  customOptions_x86   := '-Xd';
  customOptions_x86_64:= '-Xd';
  customOptions_mips  := '-Xd';
  customOptions_armv8 := '-Xd';

  customOptions_armV6 := customOptions_armV6  +' -XParm-linux-androideabi-';
  customOptions_armV7a:= customOptions_armV7a +' -XParm-linux-androideabi-';
  customOptions_armV7a_VFPv3:= customOptions_armV7a_VFPv3 + ' -XParm-linux-androideabi-';
  customOptions_x86   := customOptions_x86    +' -XPi686-linux-android-';
  customOptions_x86_64:= customOptions_x86_64 +' -XPx86_64-linux-android-';
  customOptions_mips  := customOptions_mips   +' -XPmipsel-linux-android-';
  customOptions_armv8:= customOptions_armv8   +' -XPaarch64-linux-android-';

  if Pos('armeabi', auxStr) > 0 then
    customOptions_default:= customOptions_default+' -XParm-linux-androideabi-'+' -FD'+pathToNdkToolchainsBinArm
  else if Pos('arm64', auxStr) > 0 then
      customOptions_default:= customOptions_default+' -XPaarch64-linux-android-'+' -FD'+pathToNdkToolchainsBinAarch64
  else if Pos('x86_64', auxStr) > 0 then
      customOptions_default:= customOptions_default+' -XPx86_64-linux-android-'+' -FD'+pathToNdkToolchainsBinX86_64
  else if Pos('x86', auxStr) > 0 then
    customOptions_default:= customOptions_default+' -XPi686-linux-android-'+' -FD'+pathToNdkToolchainsBinX86
  else if Pos('mips', auxStr) > 0 then
    customOptions_default:= customOptions_default+' -XPmipsel-linux-android-'+' -FD'+pathToNdkToolchainsBinMips;

  customOptions_armV6 := customOptions_armV6 +' -FD' + pathToNdkToolchainsBinArm;
  customOptions_armV7a:= customOptions_armV7a+' -FD' + pathToNdkToolchainsBinArm;
  customOptions_armv8:= customOptions_armv8  +' -FD' + pathToNdkToolchainsBinAarch64;
  customOptions_x86   := customOptions_x86   +' -FD' + pathToNdkToolchainsBinX86;
  customOptions_x86_64:= customOptions_x86_64+' -FD' + pathToNdkToolchainsBinX86_64;
  customOptions_mips  := customOptions_mips  +' -FD' + pathToNdkToolchainsBinMips;

  {Others}
  AProject.LazCompilerOptions.CustomOptions:= customOptions_default;

  auxList:= TStringList.Create;
  auxList.Add('<Libraries Value="'+libraries_x86+'"/>');
  auxList.Add('<TargetCPU Value="i386"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_x86_64+'"/>');
  auxList.Add('<TargetCPU Value="x86_64"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86_64+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86_64.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86_64.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_mips+'"/>');
  auxList.Add('<TargetCPU Value="mipsel"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_mips+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_mipsel.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_mipsel.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV6"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt')
  else
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt');


  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a_VFPv3+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_VFPv3.txt')
  else
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_VFPv3.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_aarch64+'"/>');
  auxList.Add('<TargetCPU Value="aarch64"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armv8+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMv8"/>');  //commented until lazarus fix bug for missing ARMv8  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_arm64.txt')
  else
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_arm64.txt');

  auxList.Clear;
  auxList.Add('How to get more ".so" chipset builds:');
  auxList.Add(' ');
  auxList.Add('   :: Warning 1: Your Lazarus/Freepascal needs to be prepared [cross-compile] for the various chipset builds!');
  auxList.Add('   :: Warning 2: Laz4Android [out-of-box] support only 32 Bits chipset: "armV6", "armV7a+Soft", "x86"!');
  auxList.Add(' ');
  auxList.Add('1. From LazarusIDE menu:');
  auxList.Add(' ');
  auxList.Add('   > Project -> Project Options -> Project Options -> [LAMW] Android Project Options -> "Build" -> Chipset [select!] -> [OK]');
  auxList.Add(' ');
  auxList.Add('2. From LazarusIDE  menu:');
  auxList.Add(' ');
  auxList.Add('   > Run -> Clean up and Build...');
  auxList.Add(' ');
  auxList.Add('3. From LazarusIDE menu:');
  auxList.Add(' ');
  auxList.Add('   > [LAMW] Build Android Apk and Run');
  auxList.Add(' ');

  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt');

  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
  begin
    AProject.LazCompilerOptions.TargetFilename:=
          '..'+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'lib'+LowerCase(FJavaClassName){+'.so'};

    AProject.LazCompilerOptions.UnitOutputDirectory :=
         '..'+DirectorySeparator+'obj'+ DirectorySeparator+LowerCase(FJavaClassName); {-FU}

  end
  else  //2 -- noGUI console executable
  begin
    AProject.LazCompilerOptions.TargetFilename:=
            'libs'+DirectorySeparator+auxStr+DirectorySeparator+LowerCase(FSmallProjName);

    AProject.LazCompilerOptions.UnitOutputDirectory :='obj'; {-FU}

  end;

  {TargetProcessor}

  (* //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FInstructionSet <> 'x86' then
     AProject.LazCompilerOptions.TargetProcessor:= UpperCase(FInstructionSet); {-Cp}
  *)

  auxList.Free;
  sourceList.Free;
  Result := mrOK;

end;

//C:\laz4android2.0.0\components\androidmodulewizard\android_wizard\smartdesigner\AppTemplates
function TAndroidProjectDescriptor.IsTemplateProject(tryTheme: string; out outAndroidTheme: string): boolean;
var
  p: integer;
begin
  if DirectoryExists(GetPathToSmartDesigner() + PathDelim + 'AppTemplates' +PathDelim + tryTheme) then
  begin
    p:= LastDelimiter('.', tryTheme);
    outAndroidTheme:= Copy(tryTheme, 1, p-1);  //extract real android theme ....
    Result:= True;
  end
  else
  begin
     Result:= False;
     outAndroidTheme:= tryTheme;
  end;
end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
var
  d: TIDesigner;
  c: TComponent;
  s: TLazProjectFile;
  //xmlAndroidManifest: TXMLDocument;
  templateFiles: TStringList;
  i, count: integer;
  fileName, pathToTemplate: string;
  unitFile: TLazProjectFile;
begin

  if FAndroidTemplateTheme <> '' then //Template/Theme project
  begin

    pathToTemplate:= GetPathToSmartDesigner() + PathDelim + 'AppTemplates' +PathDelim + FAndroidTemplateTheme;

    //assets
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'assets', '*.*', False);
      count:=  templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'assets'+PathDelim+fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate + PathDelim + 'res' + PathDelim + 'drawable', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
           CopyFile(templateFiles.Strings[i], FPathToJNIFolder + PathDelim + 'res' + PathDelim + 'drawable' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-hdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-hdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-hdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-mdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-mdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-mdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-xhdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-xhdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-xhdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-xxhdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-xxhdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-xxhdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-ldpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-ldpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-ldpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/raw
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'raw', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'raw' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/xml
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'xml', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'xml' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    //jni
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'jni', '*.pas;*.lfm', False);
      count:=  templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder + PathDelim+'jni' + PathDelim + fileName);
         if Pos('.pas', fileName) > 0 then
         begin
           unitFile := LazarusIDE.ActiveProject.CreateProjectFile(FPathToJNIFolder+PathDelim+'jni' + PathDelim + fileName);
           unitFile.IsPartOfProject:= True;
           LazarusIDE.ActiveProject.AddFile(unitFile, True);
           LazarusIDE.ActiveProject.Modified:= True;
         end;

      end;
    finally
      templateFiles.Free;
    end;

    {
     ReadXMLFile(xmlAndroidManifest, FPathToJNIFolder + DirectorySeparator+'AndroidManifest.xml');
     if (xmlAndroidManifest <> nil) then
     begin
        with xmlAndroidManifest.DocumentElement do
        begin
          projectPackage := AttribStrings['package'];
        end;
     end;
     }

     {  not need ...
     ReadXMLFile(xmlAndroidManifest, pathToTemplate + DirectorySeparator+'AndroidManifest.xml');
     if (xmlAndroidManifest <> nil) then
     begin
       with xmlAndroidManifest.DocumentElement do
       begin
         templatePackage := AttribStrings['package'];
         aux:=  StringReplace(templatePackage, '.' , PathDelim, [rfReplaceAll,rfIgnoreCase]);
         pathToTemplateSrc:= pathToTemplate + PathDelim + 'src' + PathDelim + aux;
         //C:\laz4android2.0.0\components\androidmodulewizard\android_wizard\smartdesigner\templates\AppCompat.Light.NoActionBar.NavigationDrawer\src\org\lamw\appcompatnavigationdrawerdemo1
       end;
     end;
     }

     { not need ...
     //java src
     templateFiles:= TStringList.Create;
     try
       FindAllFiles(templateFiles, pathToTemplateSrc, '*.java', False);
       count:=  templateFiles.Count;
       for i:= 0 to count-1 do
       begin
          fileName:= ExtractFileName(templateFiles.Strings[i]);
          auxList.Clear;
          auxList.LoadFromFile(templateFiles.Strings[i]);
          auxList.Strings[0]:= 'package '+ projectPackage+';';
          auxList.SaveToFile(FFullJavaSrcPath + PathDelim + fileName);
       end;
     finally
       templateFiles.Free;
     end;
     }

     LazarusIDE.DoSaveProject([]); // TODO: change hardcoded "controls"

     Exit;
  end; //Template project

  case FModuleType of
   mtGDX: // Gdx Controls
    AndroidFileDescriptor.ResourceClass:= TGdxModule;
   mtGUI: // GUI Controls
    AndroidFileDescriptor.ResourceClass:= TAndroidModule;  //GUI
   mtNoGUI: // NoGUI Controls
    AndroidFileDescriptor.ResourceClass:= TNoGUIAndroidModule;
   mtNoGUIConsole: // NoGUI Exe
    AndroidFileDescriptor.ResourceClass:= TAndroidConsoleDataForm;
   mtLibrary: // NoGUI generic library
    AndroidFileDescriptor.ResourceClass:= nil;
  end;

  LazarusIDE.DoSaveProject([]); // TODO: change hardcoded "controls"

  LazarusIDE.DoNewEditorFile(AndroidFileDescriptor, '', '',
                             [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);

  if FModuleType = mtGUI then // GUI
  begin
    // refresh theme
    with LazarusIDE do
      if ActiveProject.FileCount > 1 then
      begin
        s := ActiveProject.Files[1];
        d := GetDesignerWithProjectFile(s, True);
        c := d.LookupRoot;
        (TAndroidModule(c).Designer as TAndroidWidgetMediator).UpdateTheme;
      end;
  end;

  if FModuleType = mtGDX then // Gdx
  begin
    // refresh theme
    with LazarusIDE do
      if ActiveProject.FileCount > 1 then
      begin
        s := ActiveProject.Files[1];
        d := GetDesignerWithProjectFile(s, True);
        c := d.LookupRoot;
        (TGdxModule(c).Designer as TAndroidWidgetMediator).UpdateTheme;
      end;
  end;

  LazarusIDE.DoSaveProject([]); // save prompt for unit1

  Result := mrOK;
end;

{TAndroidFileDescPascalUnitWithResource}

constructor TAndroidFileDescPascalUnitWithResource.Create;
begin
  inherited Create;

  if ModuleType in [mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole] then
  begin
    Name:= 'AndroidDataModule';

    if ModuleType = mtGDX then
    begin
      Name:= 'AndroidGDXDataModule';
      ResourceClass := TGdxModule;
    end
    else if ModuleType = mtGUI then
    begin
      Name:= 'AndroidDataModule';
      ResourceClass := TAndroidModule
    end
    else if ModuleType = mtNoGUI then
    begin
       Name:= 'NoGUIAndroidDataModule';
       ResourceClass := TNoGUIAndroidModule
    end
    else  if ModuleType = mtNoGUIConsole then
    begin
       Name:= 'AndroidConsoleDataForm';
       ResourceClass:= TAndroidConsoleDataForm;
    end;
    UseCreateFormStatements:= True;
  end;
end;

constructor TAndroidFileDescPascalUnitWithResourceGDX.Create;
begin
  inherited Create;
    //if ModuleType = mtGDX then
    //begin
      Name:= 'AndroidGDXDataModule';
      ResourceClass := TGdxModule;
    //end
    UseCreateFormStatements:= True;
end;

function TAndroidFileDescPascalUnitWithResource.GetResourceType: TResourceType;
begin
   Result:= rtRes;
end;

function TAndroidFileDescPascalUnitWithResourceGDX.GetResourceType: TResourceType;
begin
   Result:= rtRes;
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedName: string;
begin
   Result := 'LAMW [GUI] Android jForm';
end;

function TAndroidFileDescPascalUnitWithResourceGDX.GetLocalizedName: string;
begin
    Result := 'LAMW [libGDX] Android jGdxForm';
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedDescription: string;
begin
    Result := 'Create a new LAMW [GUI] Android jForm';
    ActivityModeDesign:= actRecyclable;  //secondary GUI jForm
end;

function TAndroidFileDescPascalUnitWithResourceGDX.GetLocalizedDescription: string;
begin
   Result := 'Create a new LAMW [libGDX] Android jGdxForm';
   ActivityModeDesign:= actGdxScreen; //actRecyclable;  //secondary jGdxForm
end;

function TAndroidFileDescPascalUnitWithResource.CreateSource(const Filename     : string;
                                                       const SourceName   : string;
                                                       const ResourceName : string): string;
var
   sourceList: TStringList;
   uName:  string;
begin

   uName:= FileName;
   uName:= SplitStr(uName,'.');
   sourceList:= TStringList.Create;

   if ModuleType in [mtGDX, mtGUI, mtNoGUI] then
     //sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }')
     sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+SmallProjName+DirectorySeparator+'jni }')
   else
     //sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder +'}');
     sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+SmallProjName+DirectorySeparator +'}');

   sourceList.Add('unit '+uName+';');
   sourceList.Add('');
   if SyntaxMode = smDelphi then
      sourceList.Add('{$mode delphi}');
   if SyntaxMode = smObjFpc then
     sourceList.Add('{$mode objfpc}{$H+}');
   sourceList.Add('');
   sourceList.Add('interface');
   sourceList.Add('');

   if ModuleType = mtLibrary then    sourceList.Add('{');

   sourceList.Add('uses');

   //https://forum.lazarus.freepascal.org/index.php/topic,45715.msg386317
   //TODO: need drop this IFDEF from here?
   sourceList.Add('  {$IFDEF UNIX}{$IFDEF UseCThreads}');
   sourceList.Add('  cthreads,');
   sourceList.Add('  {$ENDIF}{$ENDIF}');

   sourceList.Add('  ' + GetInterfaceUsesSection);

   if ModuleType = mtLibrary then    sourceList.Add('}');

   if ModuleType = mtNoGUI then //no GUI
   begin
    sourceList.Add('');
    sourceList.Add('const');
    sourceList.Add('  gNoGUIjClassPath: string='''';');
    sourceList.Add('  gNoGUIjClass: JClass=nil;');
    sourceList.Add('  gNoGUIPDalvikVM: PJavaVM=nil;');
   end;

   if ModuleType in [mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole] then
   begin
     sourceList.Add(GetInterfaceSource(Filename, SourceName, ResourceName));
   end
   else
   begin
      sourceList.Add(' ');
     sourceList.Add('function SumAB(A: longint; B: longint): longint;');
     sourceList.Add(' ');
   end;

   sourceList.Add('implementation');
   sourceList.Add(' ');

   if ModuleType in [mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole] then
   begin
      sourceList.Add(GetImplementationSource(Filename, SourceName, ResourceName));
   end
   else
   begin
      sourceList.Add('function SumAB(A: longint; B: longint): longint;');
      sourceList.Add('begin');
      sourceList.Add('  Result:= A + B;');
      sourceList.Add('end;');
      sourceList.Add(' ');
   end;

   sourceList.Add('end.');

   Result:= sourceList.Text;

   sourceList.Free;
end;

function TAndroidFileDescPascalUnitWithResourceGDX.CreateSource(const Filename     : string;
                                                       const SourceName   : string;
                                                       const ResourceName : string): string;
var
   sourceList: TStringList;
   uName:  string;
begin
   uName:= FileName;
   uName:= SplitStr(uName,'.');
   sourceList:= TStringList.Create;

   if ModuleType in [mtGDX, mtGUI, mtNoGUI] then
     sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }')
     //sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+FSmallProjName+DirectorySeparator+'jni }')
   else
     sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder +'}');
     //sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+FSmallProjName+DirectorySeparator+'jni }');

   sourceList.Add('unit '+uName+';');
   sourceList.Add('');
   if SyntaxMode = smDelphi then
      sourceList.Add('{$mode delphi}');
   if SyntaxMode = smObjFpc then
     sourceList.Add('{$mode objfpc}{$H+}');
   sourceList.Add('');
   sourceList.Add('interface');
   sourceList.Add('');

   if ModuleType = mtLibrary then    sourceList.Add('{');

   sourceList.Add('uses');

   sourceList.Add('  {$IFDEF UNIX}{$IFDEF UseCThreads}');
   sourceList.Add('  cthreads,');
   sourceList.Add('  {$ENDIF}{$ENDIF}');


   sourceList.Add('  ' + GetInterfaceUsesSection);

   if ModuleType = mtLibrary then    sourceList.Add('}');

   if ModuleType = mtNoGUI then //no GUI
   begin
    sourceList.Add('');
    sourceList.Add('const');
    sourceList.Add('  gNoGUIjClassPath: string='''';');
    sourceList.Add('  gNoGUIjClass: JClass=nil;');
    sourceList.Add('  gNoGUIPDalvikVM: PJavaVM=nil;');
   end;

   if ModuleType in [mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole] then
   begin
     sourceList.Add(GetInterfaceSource(Filename, SourceName, ResourceName));
   end
   else
   begin
      sourceList.Add(' ');
     sourceList.Add('function SumAB(A: longint; B: longint): longint;');
     sourceList.Add(' ');
   end;

   sourceList.Add('implementation');
   sourceList.Add(' ');

   if ModuleType in [mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole] then
   begin
      sourceList.Add(GetImplementationSource(Filename, SourceName, ResourceName));
   end
   else
   begin
      sourceList.Add('function SumAB(A: longint; B: longint): longint;');
      sourceList.Add('begin');
      sourceList.Add('  Result:= A + B;');
      sourceList.Add('end;');
      sourceList.Add(' ');
   end;

   sourceList.Add('end.');

   Result:= sourceList.Text;

   sourceList.Free;
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceUsesSection: string;
begin
  if ModuleType = mtGDX then //GDX or GUI controls module
     Result := 'Classes, SysUtils, AndroidWidget, GdxForm;'
  else if ModuleType = mtGUI then //GDX or GUI controls module
     Result := 'Classes, SysUtils, AndroidWidget;'
  else if ModuleType = mtNoGUI  then  //generic module: No GUI Controls
     Result := 'Classes, SysUtils, jni;'
  else // console app or generic library
     Result := 'Classes, SysUtils;'
end;

function TAndroidFileDescPascalUnitWithResourceGDX.GetInterfaceUsesSection: string;
begin
    //GDX or GUI controls module
     Result := 'Classes, SysUtils, AndroidWidget, GdxForm;'
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceSource(const Filename     : string;
                                                             const SourceName   : string;
                                                           const ResourceName : string): string;
var
  strList: TStringList;
begin

  strList:= TStringList.Create;

  strList.Add(' ');
  strList.Add('type');
  if ModuleType = mtGDX then //Gdx controls module
  begin
    if ResourceName <> '' then
       strList.Add('  T' + ResourceName + ' = class(jGdxForm)')
    else
       strList.Add('  TGdxModuleXX = class(jGdxForm)');
  end
  else if ModuleType = mtGUI then //GUI controls module
  begin
    if ResourceName <> '' then
       strList.Add('  T' + ResourceName + ' = class(jForm)')
    else
       strList.Add('  TAndroidModuleXX = class(jForm)'); //dummy
  end
  else if ModuleType = mtNoGUI then//generic module
  begin
    if ResourceName <> '' then
      strList.Add('  T' + ResourceName + ' = class(TDataModule)')
    else
      strList.Add('  TNoGUIAndroidModuleXX  = class(TDataModule)');
  end
  else if ModuleType = mtNoGUIConsole then //  console
  begin
    if ResourceName <> '' then
      strList.Add('  T' + ResourceName + ' = class(TDataModule)')
    else
      strList.Add('  TAndroidConsoleDataFormXX  = class(TDataModule)');
  end;

  strList.Add('  private');
  strList.Add('    {private declarations}');
  strList.Add('  public');
  strList.Add('    {public declarations}');
  strList.Add('  end;');
  strList.Add('');
  strList.Add('var');

  if ModuleType = mtGDX then //GUI controls module
  begin
    if ResourceName <> '' then
       strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
       strList.Add('  GdxModuleXX: TDataMoule');
  end
  else if ModuleType = mtGUI then //GUI controls module
  begin
    if ResourceName <> '' then
       strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
       strList.Add('  AndroidModuleXX: TDataMoule');
  end
  else if ModuleType = mtNoGUI then //generic module
  begin
    if ResourceName <> '' then
      strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
      strList.Add('  NoGUIAndroidModuleXX: TNoGUIDataMoule');
  end
  else if ModuleType = mtNoGUIConsole then//2  console
  begin
    if ResourceName <> '' then
     strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
      strList.Add('  AndroidConsoleDataFormXX: TAndroidConsoleDataForm');
  end;

  if ModuleType in [mtGDX, mtGUI, mtNoGUI, mtNoGUIConsole] then
    Result := strList.Text
  else
    Result:= '';

  strList.Free;
end;

function TAndroidFileDescPascalUnitWithResourceGDX.GetInterfaceSource(const Filename     : string;
                                                             const SourceName   : string;
                                                           const ResourceName : string): string;
var
  strList: TStringList;
begin
  strList:= TStringList.Create;

  strList.Add(' ');
  strList.Add('type');
    if ResourceName <> '' then
       strList.Add('  T' + ResourceName + ' = class(jGdxForm)')
    else
       strList.Add('  TGdxModuleXX = class(jGdxForm)');
  strList.Add('  private');
  strList.Add('    {private declarations}');
  strList.Add('  public');
  strList.Add('    {public declarations}');
  strList.Add('  end;');
  strList.Add('');
  strList.Add('var');

  if ResourceName <> '' then
    strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
  else
    strList.Add('  GdxModuleXX: TDataMoule');

  Result := strList.Text;

  strList.Free;
end;

function TAndroidFileDescPascalUnitWithResource.GetImplementationSource(
                                           const Filename     : string;
                                           const SourceName   : string;
                                           const ResourceName : string): string;
var
  sttList: TStringList;
begin

  sttList:= TStringList.Create;
  sttList.Add('{$R *.lfm}');

  sttList.Add(' ');

  Result:= sttList.Text;
  sttList.Free;
end;

function TAndroidFileDescPascalUnitWithResourceGDX.GetImplementationSource(
                                           const Filename     : string;
                                           const SourceName   : string;
                                           const ResourceName : string): string;
var
  sttList: TStringList;
begin
  sttList:= TStringList.Create;
  sttList.Add('{$R *.lfm}');
  sttList.Add(' ');
  Result:= sttList.Text;
  sttList.Free;
end;

function SplitStr(var theString: string; delimiter: string): string;
var
  i: integer;
begin
  Result:= '';
  if theString <> '' then
  begin
    i:= Pos(delimiter, theString);
    if i > 0 then
    begin
       Result:= Copy(theString, 1, i-1);
       theString:= Copy(theString, i+Length(delimiter), maxLongInt);
    end
    else
    begin
       Result:= theString;
       theString:= '';
    end;
  end;
end;

end.
