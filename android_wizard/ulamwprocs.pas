unit ulamwprocs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Controls, Dialogs, LamwSettings, ProjectIntf,
  CompOptsIntf, uLamwTypes;

//tk min and max API versions for build.xml
const
  cMinAPI = 14;
  cMaxAPI = 30;
// end tk

type
  // TheThing holds all variables produced by TfrmWorkSpace
  // Does all what TAndroidXXXProjectDescriptor do but can be reused in other
  // parts of LAMW
  TheThing = class
  end;

  TUpdateManifestChecks = set of (umcUpdateAndroidX, umcMinApi, umcTargetApi, umcAndroidExported);

  function IsAllCharNumber(pcString: PChar): Boolean;
  // tk ReplaceChar made public
  function ReplaceChar(const query: string; oldchar, newchar: char): string;
  // end tk

  function GetVerAsNumber(aVers: string): integer;
  function TryUndoFakeVersion(grVer: string): string;
  function TryGradleCompatibility(plugin: string; gradleVers: string; out outGradleVer: string) : boolean;
  function TryPluginCompatibility(gradleVers: string): string;
  function GetPathToJNIFolder(fullPath: string): string;
  function GetAppName(className: string): string;
  function GetFolderFromApi(api: integer): string;
  function GetPluginVersion(buildTool: string): string;
  function GetBuildTool(FPathToAndroidSDK: string; sdkApi: integer; var FCandidateSdkBuild:string; setCandidate:boolean=false): string;
  function HasBuildTools(FPathToAndroidSDK: string; platform: integer;  out outBuildTool: string; var FCandidateSdkBuild: string; setCandidate:boolean=false): boolean;
  function GetMaxSDKPlatform(FPathToAndroidSDK: string; out outBuildTool:string): Integer;
  function GetInstructionChip(FInstructionSet, ProjTargetFilename: string): string;

  procedure UpdateLibrariesAndCustomOptions(AProject: TLazProject; FAndroidProjectName, FPathToAndroidNDK, FNdkApi, FPrebuildOSYS, FInstructionSet, FFPUSet: string; FModuleType: TModuleType; FNdkIndex:Integer);

  function GetProjectLibraries(project: TLazProject): string;
  procedure SetProjectLibraries(project: TLazProject; Libraries:string);
  function GetProjectUtilities(project: TLazProject): string;
  procedure SetProjectUtilities(project: TLazProject; Utilities:string);
  procedure SetProjectCustomOptions(project: TLazProject; customOptions:string);
  function GetProjectCustomOptions(project: TLazProject): string;

  //
  // ALL
  //
  procedure CreateKeyToolInput(const FAndroidProjectName: string; overwrite:boolean=false);
  procedure CreateHowToGetYourSignedReleaseApk(const FAndroidProjectName,FSmallProjName: string; overwrite:boolean=false);
  procedure CreateAVDUtils(FAndroidProjectName, FPathToAndroidSDK,FMinApi: string);

  procedure CreateADbUninstall(FAndroidProjectName, FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateLogCat(FAndroidProjectName, FPathToAndroidSDK: string; overwrite:boolean=true);
  procedure CreateLogCatError(FAndroidProjectName, FPathToAndroidSDK: string; overwrite:boolean=true);
  procedure CreateReleaseKeyStore(FAndroidProjectName, FPathToJavaJDK, FSmallProjName: string; overwrite:boolean=true);

  procedure CreateEclipseCorePrefs(FAndroidProjectName:string; compVer:string='1.7'; overwrite:boolean=true);
  procedure CreateEclipseClassPath(FAndroidProjectName:string; overwrite:boolean=true);
  procedure CreateEclipseProjectFile(FAndroidProjectName, FSmallProjName:string; overwrite:boolean=true);

  //
  // GRADLE
  //
  procedure CreateGradleProperties(const FAndroidProjectName, FAndroidTheme, FPathToJavaJDK : string; overwrite:boolean=true);
  procedure UpdateGradleProperties(const FAndroidProjectName, FAndroidTheme, FPathToJavaJDK : string);
  procedure CreateLocalProperties(const FAndroidProjectName, FPathToAndroidSDK, FPathToAndroidNDK: string; overwrite:boolean=true);
  function CreateBuildGradle(FAndroidProjectName: string; FPathToAndroidSDK: string; FMaxSDKPlatform: Integer;
    FGradleVersion:string; FAndroidTheme: string; instructionChip: string; FMinApi, FTargetApi: string;
    FVersionCode: Integer; FVersionName: string; FSupport: boolean; FPackagePrefaceName: string; FSmallProjName: string;
    Updating:boolean=false; buildTool:string=''; overwrite: boolean = true): boolean;
  procedure CreateGradleReadme(FAndroidProjectName, FPathToGradle, FPathToAndroidSDK: string; overwrite:boolean=true);
  procedure CreateGradleAdbInstallDebug(FAndroidProjectName, FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName, instructionChip: string; overwrite: boolean = true);
  procedure CreateGradleJarsignerVerify(FAndroidProjectName, FPathToJavaJDK, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateGradleMakingWrapper(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite:boolean=true);
  procedure CreateGradleWBuild(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite:boolean=true);
  procedure CreateGradleWRun(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite:boolean=true);
  procedure CreateGradleLocalBuild(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite:boolean=true);
  procedure CreateGradleLocalBuildBundle(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite:boolean=true);
  procedure CreateGradleLocalAPKSigner(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle, FSmallProjName, instructionChip: string; FMaxSDKPlatform:Integer; overwrite: boolean=true);
  procedure CreateGradleLocalUniversalAPKSigner(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle, FSmallProjName: string; FMaxSDKPlatform:Integer; overwrite: boolean=true);
  procedure CreateGradleLocalRun(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite:boolean=true);

  //
  // ANT
  //
  procedure CreateLogcatAppPerform(FAndroidProjectName, FPathToAndroidSDK, FSmallProjName, FAntBuildMode: string; overwrite:boolean=true);
  procedure CreateLaunchAPK(FAndroidProjectName, FPathToAndroidSDK, FAntPackageName, FMainActivity: string; ovewrite:boolean=true);
  procedure CreateAAPT(FAndroidProjectName, FPathToAndroidSDK, FAntPackageName, FMinApi, FSmallProjName, FAntBuildMode: string; ovewrite:boolean=true);

  procedure CreateBuildXML(FAndroidProjectName, FPathToAndroidSDK, FAndroidTheme, FTargetApi, FPackagePrefaceName, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateAntReadme(FAndroidProjectName, FAntBuildMode, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateAntProperties(FAndroidProjectName, FSmallProjName: string; overwrite:boolean=true);
  procedure UpdateAntProperties(FAndroidProjectName: string);
  procedure CreateProguardPoject(FAndroidProjectName: string; overwrite:boolean=true);
  procedure CreateProjectProperties(FAndroidProjectName, FAndroidTheme, FTargetApi: string; overwrite:boolean=true);
  procedure CreateAntBuildDebug(FAndroidProjectName, FPathToJavaJDK, FPathToAntBin:string; overwrite:boolean=true);
  procedure CreateAntBuildRelease(FAndroidProjectName, FPathToJavaJDK, FPathToAntBin:string; overwrite:boolean=true);
  procedure CreateAntAdbInstallDebug(FAndroidProjectName, FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateAntJarsignerVerify(FAndroidProjectName, FPathToJavaJDK, FSmallProjName: string; overwrite:boolean=true);

  //
  //  Basic project files
  //
  procedure CreateJavaSrcDir(FAndroidProjectName, FPackageName, FSmallProjName: string; out FFullJavaSrcPath:string);
  procedure CreateDrawables(FAndroidProjectName, FPathToJavaTemplates: string; overwrite:boolean=true);
  procedure CreateStringsXml(FAndroidProjectName, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateColorsXml(FAndroidProjectName, FPathToJavaTemplates, FAndroidThemeColor: string; overwrite:boolean=true);
  procedure CreateStylesXml(FAndroidProjectName, FPathToJavaTemplates, FAndroidTheme: string; overwrite: boolean=true);
  procedure CreateTargetStylesXml(FAndroidProjectName, FPathToJavaTemplates, FAndroidTheme, FMinApi, FTargetApi: string; overwrite:boolean=true);
  procedure CreateActivityAppXml(FAndroidProjectName, FPathToJavaTemplates: string; overwrite:boolean=true);
  procedure CreateJSupportedJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName: string; FSupport: boolean; overwrite:boolean=true);
  procedure CreateSupportProviderPathsXML(FAndroidProjectName, FPathToJavaTemplates: string; FSupport: boolean; overwrite:boolean=true);
  procedure CreateControlsJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateJFormJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName: string; overwrite:boolean=true);
  procedure CreateAppJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName, FAndroidTheme: string; overwrite:boolean=true);
  procedure CreateControlsNative(FAndroidProjectName, FPathToJavaTemplates: string; overwrite:boolean=true);
  procedure CreateJCommonsJava(FPathToJavaTemplates, FFullJavaSrcPath, FPackagePrefaceName, FSmallProjName, FAndroidTheme: string; overwrite:boolean=true);
  procedure CreateAndroidManifestXML(FAndroidProjectName, FPathToJavaTemplates, FPackagePrefaceName, FSmallProjName, FMainActivity, FMinApi, FTargetApi:string; FSupport:boolean; overwrite:boolean=true);
  procedure UpdateAndroidManifestXML(FAndroidProjectName, FAndroidTheme: string; FSupport:boolean; FMinApi, FTargetApi, DefApi:string; Checks: TUpdateManifestChecks);
implementation

{$ifdef unix}
uses
  BaseUnix;
{$endif}

const
  COPY_FLAGS:array[false..true] of TCopyFileFlags = ([], [cffOverwriteFile]);

var
  strList: TStringList;

// Copies src (or altsrc if src do not exists) to dst.
// It does nothing if overwrite=true and dst exists
procedure AltCopyFile(src,dst:string; overwrite:boolean; altSrc:string='');
begin
  if overwrite or not FileExists(dst) then
  begin
    if not FileExists(src) then begin
      src := '';
      if (altSrc<>'') and FileExists(altSrc) then
        src := altSrc;
    end;
    if src<>'' then begin
      ForceDirectories(ExtractFilePath(dst));
      CopyFile(src, dst);
    end;
  end;
end;

function IsAllCharNumber(pcString: PChar): Boolean;
begin
  Result := False;
  if StrLen(pcString)=0 then exit;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then Exit;
    Inc(pcString);
  end;
  Result := True;
end;

function ReplaceChar(const query: string; oldchar, newchar: char): string;
var
  i: Integer;
begin
  Result := query;
  for i := 1 to Length(Result) do
    if Result[i] = oldchar then Result[i] := newchar;
end;

function GetVerAsNumber(aVers: string): integer;
var
  numberAsString: string;
  len: integer;
begin
  numberAsString:= StringReplace(aVers,'.', '', [rfReplaceAll]);
  len:= Length(numberAsString);
  if len = 2 then numberAsString:= numberAsString + '00';
  if len = 3 then numberAsString:= numberAsString + '0';
  Result:= StrToInt(numberAsString);
end;

function TryUndoFakeVersion(grVer: string): string;
begin
  Result:=  grVer;
  if grVer = '4.9.1' then Result:= '4.10'
  else if grVer = '4.9.2' then Result:= '4.10.1'
  else if grVer = '4.9.3' then Result:= '4.10.2'
  else if grVer = '4.9.4' then Result:= '4.10.3';
end;

//https://developer.android.com/studio/releases/gradle-plugin.html#updating-plugin
function TryGradleCompatibility(plugin: string; gradleVers: string; out
  outGradleVer: string): boolean;
var
  pluginNumber: integer;
  numberAsString: string;
  tryGradleVer: string;
  tryGradleNumber, len: integer;
  gradleNumber: integer;
begin

  Result:= False;
  {200  < 220 ---  2.1
  220  < 233 ---  2.14.1
  233  < 301 ---  3.3
  301  >     ---  4.0}
  if gradleVers = '' then
  begin
   ShowMessage('Error. Gradle version is empty');
   Exit;
  end;

  if plugin = '' then
  begin
    ShowMessage('Error. Android Gradle plugin version is empty');
    Exit;
  end;

  numberAsString:= StringReplace(plugin,'.', '', [rfReplaceAll]); //3.0.1
  pluginNumber:= StrToInt(numberAsString);  //301

  if (pluginNumber >=  200) and (pluginNumber <  220) then
  begin
     tryGradleVer:= '2.10';   //210  -> 2100
  end else if (pluginNumber >= 220) and (pluginNumber <  233) then
  begin
    tryGradleVer:= '2.14.1';  //        2141
  end else if (pluginNumber >= 233) and (pluginNumber <  310) then
   begin
      tryGradleVer:= '4.1';
   end else if (pluginNumber >= 310) and  (pluginNumber <  320) then
   begin
      tryGradleVer:= '4.4';         //27.0.3
   end else if (pluginNumber >= 320) and  (pluginNumber <  330) then
   begin
      tryGradleVer:= '4.6';         //28.0.3
   end else if (pluginNumber >= 330) and  (pluginNumber <  340) then
   begin
      tryGradleVer:= '4.9.2';   //fake -> '4.10.1'  //4.10.1 --> 4920     //28.0.3
   end else //(pluginNumber >= 340)
   begin
       tryGradleVer:= '5.1.1';         //28.0.3
   end;

  numberAsString:= StringReplace(tryGradleVer,'.', '', [rfReplaceAll]); //3.3
  len:= Length(numberAsString);
  if len = 2 then numberAsString:= numberAsString + '00';
  if len = 3 then numberAsString:= numberAsString + '0';
  tryGradleNumber:= StrToInt(numberAsString);

  numberAsString:= StringReplace(gradleVers,'.', '', [rfReplaceAll]); //41
  len:= Length(numberAsString);
  if len = 2 then numberAsString:= numberAsString + '00'; //4100
  if len = 3 then numberAsString:= numberAsString + '0';

  gradleNumber:= StrToInt(numberAsString);

  if gradleNumber >= tryGradleNumber then
  begin
    outGradleVer:= gradleVers;
    Result:= True;
  end
  else
  begin
    outGradleVer:= TryUndoFakeVersion(tryGradleVer);
    Result:= False;
  end;

end;

function TryPluginCompatibility(gradleVers: string): string;
var
  gradleVersNumber: integer;
begin
  Result:= '3.0.1';
  gradleVersNumber:= GetVerAsNumber(gradleVers);
  if gradleVersNumber <  4100 then Result:= '2.3.3'
  else if (gradleVersNumber >= 4100) and (gradleVersNumber < 4400) then Result:= '3.0.1'
  else if (gradleVersNumber >= 4400) and (gradleVersNumber < 4600) then Result:= '3.1.0'
  else if (gradleVersNumber >= 4600) and (gradleVersNumber < 4920) then Result:= '3.2.1'
  else if (gradleVersNumber >= 4920) and (gradleVersNumber < 5110) then Result:= '3.3.2'
  else if (gradleVersNumber >= 7000) and (gradleVersNumber < 7999) then Result:= '7.0.0'
  else Result:= '3.4.3'; //gradleVersNumber >= 5110)
end;

function GetPathToJNIFolder(fullPath: string): string;
var
  i: integer;
begin
  //fix by Leledumbo - for linux compatility
  i:= Pos('src'+DirectorySeparator,fullPath);
  if i > 2 then
    Result:= Copy(fullPath,1,i - 2)// we don't need the trailing slash
  else raise Exception.Create('src folder not found...');
end;

function GetAppName(className: string): string;
var
  listAux: TStringList;
  lastIndex: integer;
begin
  listAux:= TStringList.Create;
  listAux.StrictDelimiter:= True;
  listAux.Delimiter:= '.';
  listAux.DelimitedText:= StringReplace(className,'/','.',[rfReplaceAll]);
  lastIndex:= listAux.Count-1;
  listAux.Delete(lastIndex);
  Result:= listAux.DelimitedText;
  listAux.Free;
end;

//just for test!  not realistic!
function GetFolderFromApi(api: integer): string;
begin
  Result:= 'android-x.y';
  case api of
     17: Result:= 'android-4.2.2';
     18: Result:= 'android-4.3';
     19: Result:= 'android-4.4';
     20: Result:= 'android-4.4W';
     21: Result:= 'Lollipop-5.0';
     22: Result:= 'Lollipop-5.1';
     23: Result:= 'Marshmallow-6.0';
     24: Result:= 'Nougat-7.0';
     25: Result:= 'Nougat-7.1';
     26: Result:= 'Oreo-8.0';
     27: Result:= 'Oreo-8.1';
     28: Result:= 'Pie';
     29: Result:= 'Android-10.0';
  end;
end;

function GetPluginVersion(buildTool: string): string;
var
  maxBuilderNumber: integer;
  numberAsString: string;
begin
  Result:= '';

  if (buildTool = '') then Exit;

  numberAsString:= StringReplace(buildTool,'.', '', [rfReplaceAll]); //26.0.2
  numberAsString:= Trim(numberAsString);

  if IsAllCharNumber(PChar(numberAsString))  then
  begin
    maxBuilderNumber:= StrToInt(numberAsString);  //2602

    if (maxBuilderNumber >= 2111) and (maxBuilderNumber < 2112) then
    begin
      Result:= '2.0.0';
    end
    else if (maxBuilderNumber >= 2112) and (maxBuilderNumber < 2302) then
    begin
      Result:= '2.0.0';
    end
    else if (maxBuilderNumber >= 2302) and (maxBuilderNumber < 2500) then
    begin
        Result:= '2.2.0';
    end
    else if (maxBuilderNumber >= 2500) and (maxBuilderNumber < 2602) then   //<<---- good performance !!!
    begin
        Result:= '2.3.3';
        //gradleVer:= '3.3';
    end
    else if (maxBuilderNumber >= 2602) and (maxBuilderNumber < 2700)  then
    begin
        Result:= '3.0.1';
        //gradleVer:= '4.1';
    end
    else if (maxBuilderNumber >= 2700) and (maxBuilderNumber < 2703)   then
    begin
        Result:= '3.1.0';
        //gradleVer:= '4.4';
    end
    else if (maxBuilderNumber >= 2703) and (maxBuilderNumber < 2803)   then
    begin
        //Result:= '3.2.0'; //need build-tools 28.0.2 and need drop minSdk/targetSdk from AndroidManifest!!
        //gradleVer:= '4.6';

         Result:= '3.1.0'; //just to support minSdk/targetSdk in AndroidManifest!!
    end
    else if maxBuilderNumber >= 2803   then
    begin
        //Result:= '3.3.0';  //need droped minSdk/targetSdk in AndroidManifest!!
        //gradleVer:= 'Gradle 4.10.1';

        //Result:= '3.4.0';
        //gradleVer:= 'Gradle Gradle 5.1.1'

         //Result:= '3.4.3';
        //gradleVer:= 'Gradle Gradle 6.6.1'

         Result:= '3.1.0'; // just to support minSdk/targetSdk from AndroidManifest!!
    end;

  end;

end;

function GetBuildTool(FPathToAndroidSDK: string; sdkApi: integer;
  var FCandidateSdkBuild: string; setCandidate: boolean): string;
var
  tempOutBuildTool: string;
begin
  Result:= '';
  if HasBuildTools(FPathToAndroidSDK, sdkApi, tempOutBuildTool, FCandidateSdkBuild, setCandidate) then
  begin
     Result:= tempOutBuildTool;  //25.0.3    //***
  end;
end;

function HasBuildTools(FPathToAndroidSDK: string; platform: integer; out
  outBuildTool: string; var FCandidateSdkBuild: string; setCandidate: boolean
  ): boolean;
var
  lisDir: TStringList;
  numberAsString, auxStr: string;
  i, builderNumber: integer;
  savedBuilder: integer;
begin
  Result:= False;
  savedBuilder:= 0;
  lisDir:= TStringList.Create;   //C:\adt32\sdk\build-tools\19.1.0
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'build-tools', False);
  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       lisDir.Strings[i]:=auxStr;
    end;
    lisDir.Sorted:=True;
    for i:= 0 to lisDir.Count-1 do
    begin
       auxStr:= lisDir.Strings[i];
       if auxStr <> '' then    //19.1.0
       begin
           numberAsString:= Copy(auxStr, 1 , 2);  //19
           if IsAllCharNumber(PChar(numberAsString)) then
           begin
             builderNumber:=  StrToInt(numberAsString);
             if savedBuilder < builderNumber then
             begin
               savedBuilder:= builderNumber;
               if builderNumber > platform then FCandidateSdkBuild:= auxStr;
             end;
             if  platform <= builderNumber then
             begin
               if setCandidate then
                FCandidateSdkBuild := auxStr;
               outBuildTool:= auxStr; //25.0.3
               Result:= True;
               break;
             end;
           end;
       end;
    end;
  end;
  lisDir.free;
end;

function GetMaxSDKPlatform(FPathToAndroidSDK: string; out outBuildTool: string
  ): Integer;
var
  lisDir: TStringList;
  strApi: string;
  i, intApi, FCandidateSdkPlatform: integer;
  tempOutBuildTool, candidateSdkBuildDummy: string;
begin
  Result:= 0;
  FCandidateSdkPlatform:= 0;
  candidateSdkBuildDummy := '';

  lisDir:= TStringList.Create;
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       strApi:= ExtractFileName(lisDir.Strings[i]);   //android-21
       if strApi <> '' then
       begin
         strApi:= Copy(strApi, LastDelimiter('-', strApi) + 1, MaxInt);
         if IsAllCharNumber(PChar(strApi))  then  //skip android-P
         begin
              intApi:= StrToInt(strApi);
              if FCandidateSdkPlatform < intApi then FCandidateSdkPlatform:= intApi;
              if Result < intApi then
              begin
                if HasBuildTools(FPathToAndroidSDK, intApi, tempOutBuildTool, candidateSdkBuildDummy) then
                begin
                   Result:= intApi;
                   outBuildTool:= tempOutBuildTool;  //26.0.2
                end;
              end;

         end;
       end;
    end;
  end;
  lisDir.free;
end;

function GetInstructionChip(FInstructionSet, ProjTargetFilename: string
  ): string;
var
  tempStr: String;
begin
  tempStr:= LowerCase(FInstructionSet);
  if Length(tempStr)>0 then
  begin
  if tempStr = 'armv6'  then result:='armeabi';
  if tempStr = 'armv7a' then result:='armeabi-v7a';
  if tempStr = 'x86'    then result:='x86';
  if tempStr = 'x86_64' then result:='x86_64';
  if tempStr = 'mipsel' then result:='mips';
  if tempStr = 'armv8'  then result:='arm64-v8a';
  end
  else
  begin
    result:= ExtractFileDir(ProjTargetFilename);
    result:= ExtractFileName(result);
  end;
end;

procedure UpdateLibrariesAndCustomOptions(AProject: TLazProject;
  FAndroidProjectName, FPathToAndroidNDK, FNdkApi, FPrebuildOSYS,
  FInstructionSet, FFPUSet: string; FModuleType: TModuleType; FNdkIndex: Integer
  );
var
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

  auxStr, auxInstr: string;
  osys: string;      {windows or linux-x86 or linux-x86_64}

  auxList: TStringList;
begin
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
  SetProjectCustomOptions(AProject, customOptions_default);

  auxList:= TStringList.Create;
  auxList.Add('<Libraries Value="'+libraries_x86+'"/>');
  auxList.Add('<TargetCPU Value="i386"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt')
  else
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_x86_64+'"/>');
  auxList.Add('<TargetCPU Value="x86_64"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86_64+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86_64.txt')
  else
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86_64.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_mips+'"/>');
  auxList.Add('<TargetCPU Value="mipsel"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_mips+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_mipsel.txt')
  else
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-modes'+DirectorySeparator+'build_mipsel.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV6"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt')
  else
    auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
     auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt')
  else
     auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a_VFPv3+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
     auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_VFPv3.txt')
  else
     auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_VFPv3.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_aarch64+'"/>');
  auxList.Add('<TargetCPU Value="aarch64"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armv8+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMv8"/>');  //commented until lazarus fix bug for missing ARMv8  //again thanks to Stephano!
  if FModuleType in [mtGDX, mtGUI, mtNoGUI] then
     auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_arm64.txt')
  else
     auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-modes'+DirectorySeparator+'build_arm64.txt');

  auxList.Free;
end;

{ TFileProducer }

procedure PrepareStrList;
begin
  if strList=nil then
    strList := TStringList.Create
  else
    strList.Clear;
end;

function NeedFile(const destFile:string; overwrite:boolean; out aFile: string): boolean;
begin
  aFile := destFile;
  result := overwrite or not FileExists(aFile);
  if result then
    PrepareStrList;
end;

procedure ScriptSave(AFilename:string);
begin
  strList.SaveToFile(AFilename);
  {$ifdef unix}
  FpChmod(AFileName, &751);
  {$endif}
end;

function ScriptExt: string;
begin
  {$IFDEF WINDOWS}
  result := '.bat'
  {$ELSE}
  result := '.sh';
  {$ENDIF}
end;

function GetProjectLibraries(project: TLazProject): string;
begin
  result := project.CustomSessionData.Values['Libraries'];
end;

procedure SetProjectLibraries(project: TLazProject; Libraries: string);
begin
  project.CustomSessionData.Values['Libraries'] := Libraries;
  project.LazCompilerOptions.Libraries := '';
end;

function GetProjectUtilities(project: TLazProject): string;
begin
  result := project.CustomSessionData.Values['Utilities'];
end;

procedure SetProjectUtilities(project: TLazProject; Utilities: string);
begin
  project.CustomSessionData.Values['Utilities'] := Utilities;
end;

procedure SetProjectCustomOptions(project: TLazProject; customOptions: string);
var
  fdPos: Integer;
begin
  fdPos := pos(' -FD', UpperCase(customOptions));
  if fdPos>0 then
  begin
    SetProjectUtilities(Project, copy(customOptions, fdPos+1, Length(customOptions)));
    customOptions:= copy(customOptions, 1, fdPos-1);
  end;
  Project.LazCompilerOptions.CustomOptions:= customOptions;
end;

function GetProjectCustomOptions(project: TLazProject): string;
begin
  result := Project.LazCompilerOptions.CustomOptions;
  if pos('-FD', result)<1 then
    result := result + ' ' + GetProjectUtilities(project);
end;

procedure CreateKeyToolInput(const FAndroidProjectName: string;
  overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'keytool_input.txt', overwrite, aFile) then
  begin
    //keytool input [dammy] data!
    strList.Add('123456');             //Enter keystore password:
    strList.Add('123456');             //Re-enter new password:
    strList.Add('MyFirstName MyLastName'); //What is your first and last name?
    strList.Add('MyDevelopmentUnitName');        //What is the name of your organizational unit?
    strList.Add('MyCompanyName');   //What is the name of your organization?
    strList.Add('MyCity');             //What is the name of your City or Locality?
    strList.Add('MT');                 //What is the name of your State or Province?
    strList.Add('BR');                 //What is the two-letter country code for this unit?
    strList.Add('y');  //Is <CN=FirstName LastName, OU=Development, O=MyExampleCompany, L=MyCity, ST=AK, C=WZ> correct?[no]:  y
    strList.Add('123456'); //Enter key password for the Apk <aliasKey> <RETURN if same as keystore password>:
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateHowToGetYourSignedReleaseApk(const FAndroidProjectName,
  FSmallProjName: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'How_To_Get_Your_Signed_Release_Apk.txt', overwrite, aFile) then
  begin
    strList.Add('       Tutorial: How to get your "signed" release Apk ['+ FSmallProjName +']');
    strList.Add(' ');
    strList.Add('    NEW! ');
    strList.Add('    "Tools"  --> "[LAMW] ..." --> "Build Release Signed Apk  ..."');
    strList.Add('    "Tools"  --> "[LAMW] ..." --> "Build Release Signed Bundle ..."');
    strList.Add(' ');
    strList.Add(' ');
    strList.Add(' OR: ');
    strList.Add(' ');
    strList.Add('1)Edit/change the project file "keytool_input.txt" to more representative informations:"');
    strList.Add('');
    strList.Add('.Your keystore password [--ks-pass pass] : 123456');
    strList.Add('.Re-enter/confirm the keystore password: 123456');
    strList.Add(' ');
    strList.Add('.Your first and last name: MyFirstName MyLastName');
    strList.Add('');
    strList.Add('.Your Organizational unit: MyDevelopmentUnit');
    strList.Add('');
    strList.Add('.Your Organization name: MyCompany');
    strList.Add('');
    strList.Add('.Your City or Locality: MyCity');
    strList.Add('');
    strList.Add('.Your State or Province: MT' );
    strList.Add('');
    strList.Add('.The two-letter country code: BR');
    strList.Add('');
    strList.Add('.All correct: y');
    strList.Add('');
    strList.Add('.Your key password for this Apk alias [--key-pass pass]: 123456 ');
    strList.Add('');
    strList.Add('');
    strList.Add('2)If you are using "Ant" then edit/change "ant.properties" according, too!');
    strList.Add('');
    strList.Add('');
    strList.Add('3) Execute the [project] command "release-keystore.bat" or "release-keystore.sh" or "release-keystore-macos.sh" to get the "'+Lowercase(FSmallProjName)+'-release.keystore"');
    strList.Add('           warning: the file "'+Lowercase(FSmallProjName)+'-release.keystore" should be created only once [per application] otherwise it will fail [and NEVER delete it!]');
    strList.Add(' ');
    strList.Add('4) [Gradle]: Edit/change the values [123456] "--ks-pass pass:" and "--key-pass pass:" in project file "gradle-local-apksigner.bat" [or .sh]  according "keytool_input.txt" file');
    strList.Add('             Edit/change the values [123456] "--ks-pass pass:" and "--key-pass pass:" in project file "gradle-local-universal-apksigner.bat" [or .sh]  according "keytool_input.txt" file');
    strList.Add('');
    strList.Add('5) [Gradle]: Execute the [project] command "gradle-local-apksigner.bat" [.sh] to get the [release] signed Apk!');
    strList.Add('             OR execute "gradle-local-universal-apksigner.bat" [.sh] if your are supporting multi-architecture (ex.: armeabi-v7a + arm64-v8a + ...) ');
    strList.Add('             hint: look for your generated "'+FSmallProjName+'-release.apk" in [project] folder "...\build\outputs\apk\release"');
    strList.Add(' ');
    strList.Add('');
    strList.Add('6) [Ant]: Execute the [project] command "ant-build-release.bat" [.sh] to get the [release] signed Apk!"');
    strList.Add('          hint: look for your generated "'+FSmallProjName+'-release.apk" in [project] folder "...\bin"');
    strList.Add('');
    strList.Add('');
    strList.Add('Success! You can now upload your nice "'+FSmallProjName+'-release.apk" to "Google Play" [or others stores...]!');
    strList.Add('');
    strList.Add('....  Thanks to All!');
    strList.Add('....  Special thanks to ADiV/TR3E!');
    strList.Add('');
    strList.Add('....  by jmpessoa_hotmail_com');
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateAVDUtils(FAndroidProjectName, FPathToAndroidSDK,FMinApi: string);
begin
  //*.bat utils...
  CreateDir(FAndroidProjectName+ DirectorySeparator + 'utils');

  {"android list targets" to see the available targets...}
  strList.Clear;
  strList.Add('cd '+FPathToAndroidSDK+'tools');
  strList.Add('android list targets');
  strList.Add('cd '+FAndroidProjectName);
  strList.Add('pause');
  strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'list-target.bat');

  //need to pause on double-click use...
  strList.Clear;
  strList.Add('cmd /K list-target.bat');
  strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused-list-target.bat');

  strList.Clear;
  strList.Add('cd '+FPathToAndroidSDK+'tools');
  strList.Add('android create avd -n avd_default -t 1 -c 32M');
  strList.Add('cd '+FAndroidProjectName);
  strList.Add('pause');
  strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'create-avd-default.bat');

  //need to pause on double-click use...
  strList.Clear;
  strList.Add('cmd /k create-avd-default.bat');
  strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused-create-avd-default.bat');

  strList.Clear;
  strList.Add('cd '+FPathToAndroidSDK+'tools');
  if StrToInt(FMinApi) >= 15 then
    strList.Add('emulator -avd avd_default +  -gpu on &')  //gpu: api >= 15,,,
  else
    strList.Add('tools emulator -avd avd_api_'+FMinApi + ' &');
  strList.Add('cd '+FAndroidProjectName);
  strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch-avd-default.bat');
end;

procedure CreateADbUninstall(FAndroidProjectName, FPathToAndroidSDK,
  FPackagePrefaceName, FSmallProjName: string; overwrite: boolean);
var
  aFile: string;
begin
  //linux uninstall  - thanks to Stephano!
  if NeedFile(FAndroidProjectName+PathDelim+'adb-uninstall'+ScriptExt, overwrite, aFile) then
  begin
    strList.Add(FPathToAndroidSDK+'platform-tools'+
               DirectorySeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
    ScriptSave(aFile);
  end;
end;

procedure CreateLogCat(FAndroidProjectName, FPathToAndroidSDK: string; overwrite: boolean);
var
  aFile: string;
begin
  //linux logcat  - thanks to Stephano!
  if NeedFile(FAndroidProjectName+PathDelim+'logcat'+ScriptExt, overwrite, aFile) then
  begin
    strList.Add(FPathToAndroidSDK+'platform-tools'+DirectorySeparator+'adb logcat &');
    {$IFDEF WINDOWS}strList.Add('pause');{$ENDIF}
    ScriptSave(aFile);
  end;
end;

procedure CreateLogCatError(FAndroidProjectName, FPathToAndroidSDK: string; overwrite: boolean);
var
  aFile: string;
begin
  //linux logcat  - thanks to Stephano!
  if NeedFile(FAndroidProjectName+PathDelim+'logcat-error'+ScriptExt, overwrite, aFile) then
  begin
    strList.Add(FPathToAndroidSDK+'platform-tools'+DirectorySeparator+'adb logcat AndroidRuntime:E *:S');
    {$IFDEF WINDOWS}strList.Add('pause');{$ENDIF}
    ScriptSave(aFile);
  end;
end;

procedure CreateLogcatAppPerform(FAndroidProjectName, FPathToAndroidSDK, FSmallProjName,
  FAntBuildMode: string; overwrite: boolean);
var
  aFile: string;
begin
  //linux logcat  - thanks to Stephano!
  if NeedFile(FAndroidProjectName+PathDelim+'logcat-app-perform'+ScriptExt, overwrite, aFile) then
  begin
    strList.Add(FPathToAndroidSDK+'platform-tools'+DirectorySeparator+'adb logcat ActivityManager:I '+FSmallProjName+'-'+FAntBuildMode+'.apk:D *:S');
    {$IFDEF WINDOWS}strList.Add('pause');{$ENDIF}
    ScriptSave(aFile);
  end;
end;

procedure CreateLaunchAPK(FAndroidProjectName, FPathToAndroidSDK, FAntPackageName, FMainActivity: string; ovewrite:boolean);
var
  aFile: string;
begin
  (*//causes instability in the simulator! why ?
  if NeedFile(FAndroidProjectName+PathDelim+'launch-apk'+ScriptExt, overwrite, aFile) then
  begin
  strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
  strList.Add(FPathToAndroidSDK+'platform-tools'+DirectorySeparator+
             'adb shell am start -a android.intent.action.MAIN -n '+
              FAntPackageName+'.'+LowerCase(projName)+'/.'+FMainActivity);
    ScriptSave(aFile);
  end;
  *)
end;

procedure CreateAAPT(FAndroidProjectName, FPathToAndroidSDK, FAntPackageName, FMinApi, FSmallProjName, FAntBuildMode: string; ovewrite:boolean);
var
  aFile: string;
begin
  {
  CreateDir(FAndroidProjectName+ DirectorySeparator + 'utils');
  if NeedFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'aapt'+ScriptExt, overwrite, aFile) then
  begin
    strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
    strList.Add(FPathToAndroidSDK+
               'build-tools'+DirectorySeparator+ GetFolderFromApi(StrToInt(FMinApi))+
               DirectorySeparator + 'aapt list '+FSmallProjName+'-'+FAntBuildMode+'.apk');
    {$IFDEF WINDOWS}
    strList.Add('cd ..');
    strList.Add('pause');
    {$ENDIF}
    ScriptSave(aFile);
  end;
  }
end;

procedure CreateReleaseKeyStore(FAndroidProjectName, FPathToJavaJDK,
  FSmallProjName: string; overwrite:boolean);
var
  aFile: string;
  apk_aliaskey: string;
  LCALL: string;
begin
  if NeedFile(FAndroidProjectName+DirectorySeparator+'release-keystore'+ScriptExt, overwrite, aFile) then
  begin
    apk_aliaskey:= LowerCase(FSmallProjName)+'.keyalias';

    {$IFDEF WINDOWS}
    strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
    strList.Add('set PATH=%JAVA_HOME%'+PathDelim+'bin;%PATH%');
    strList.Add('set JAVA_TOOL_OPTIONS=-Duser.language=en');
    //https://forum.lazarus.freepascal.org/index.php/topic,56830.0.html  [by guaracy]
    //strList.Add('if exist "'+Lowercase(FSmallProjName)+'-release.keystore" goto Error');
    //roolback
    //https://forum.lazarus.freepascal.org/index.php/topic,57735.0.html
    LCALL := '';
    {$ELSE}
    {$IFDEF DARWIN}
    strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');
    strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
    LCALL := '';
    {$ELSE}
    strList.Add('export JAVA_HOME='+FPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    LCALL :='LC_ALL=C ';
    {$ENDIF}
    {$ENDIF}

    strList.Add('cd '+FAndroidProjectName);

    ////https://forum.lazarus.freepascal.org/index.php/topic,57735.0.html
    strList.Add(LCALL+'keytool -genkey -v -keystore '+Lowercase(FSmallProjName)+'-release.keystore -alias '+apk_aliaskey+' -keyalg RSA -keysize 2048 -validity 10000 < '+
                 FAndroidProjectName+DirectorySeparator+'keytool_input.txt');

    {$IFDEF WINDOWS}
    strList.Add(':Error');
    strList.Add('echo off');
    strList.Add('cls');
    strList.Add('echo.');
    strList.Add('echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.');
    strList.Add('echo.');
    strList.Add('pause');
    // [sic]
    // this code only makes sense if the line 'if exists' is added to the script
    // but ATM it is commented out.
    {$ENDIF}
    ScriptSave(aFile);
  end;
end;

procedure CreateEclipseCorePrefs(FAndroidProjectName: string; compVer: string;
  overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs', overwrite, aFile) then
  begin
    CreateDir(FAndroidProjectName+DirectorySeparator+'.settings');
    strList.Add('eclipse.preferences.version=1');
    strList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform='+compVer);
    strList.Add('org.eclipse.jdt.core.compiler.compliance='+compVer);
    strList.Add('org.eclipse.jdt.core.compiler.source='+compVer);
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateEclipseClassPath(FAndroidProjectName: string; overwrite: boolean
  );
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+DirectorySeparator+'.classpath', overwrite, aFile) then
  begin
    strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
    strList.Add('<classpath>');
    strList.Add('<classpathentry kind="src" path="src"/>');
    strList.Add('<classpathentry kind="src" path="gen"/>');
    strList.Add('<classpathentry kind="con" path="org.eclipse.andmore.ANDROID_FRAMEWORK"/>');
    strList.Add('<classpathentry exported="true" kind="con" path="org.eclipse.andmore.LIBRARIES"/>');
    strList.Add('<classpathentry exported="true" kind="con" path="org.eclipse.andmore.DEPENDENCIES"/>');
    strList.Add('<classpathentry kind="output" path="bin/classes"/>');
    strList.Add('</classpath>');
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateEclipseProjectFile(FAndroidProjectName, FSmallProjName: string;
  overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+DirectorySeparator+'.project', overwrite, aFile) then
  begin
    strList.Add('<projectDescription>');
    strList.Add('	<name>'+FSmallProjName+'</name>');
    strList.Add('	<comment></comment>');
    strList.Add('	<projects>');
    strList.Add('	</projects>');
    strList.Add('	<buildSpec>');
    strList.Add('		<buildCommand>');
    strList.Add('			<name>org.eclipse.andmore.ResourceManagerBuilder</name>');
    strList.Add('			<arguments>');
    strList.Add('			</arguments>');
    strList.Add('		</buildCommand>');
    strList.Add('		<buildCommand>');
    strList.Add('			<name>org.eclipse.andmore.PreCompilerBuilder</name>');
    strList.Add('			<arguments>');
    strList.Add('			</arguments>');
    strList.Add('		</buildCommand>');
    strList.Add('		<buildCommand>');
    strList.Add('			<name>org.eclipse.jdt.core.javabuilder</name>');
    strList.Add('			<arguments>');
    strList.Add('			</arguments>');
    strList.Add('		</buildCommand>');
    strList.Add('		<buildCommand>');
    strList.Add('			<name>org.eclipse.andmore.ApkBuilder</name>');
    strList.Add('			<arguments>');
    strList.Add('			</arguments>');
    strList.Add(' 		</buildCommand>');
    strList.Add('	</buildSpec>');
    strList.Add('	<natures>');
    strList.Add('		<nature>org.eclipse.andmore.AndroidNature</nature>');
    strList.Add('		<nature>org.eclipse.jdt.core.javanature</nature>');
    strList.Add('	</natures>');
    strList.Add('</projectDescription>');
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateGradleProperties(const FAndroidProjectName, FAndroidTheme,
  FPathToJavaJDK: string; overwrite: boolean);
var
  tempStr, aFile: String;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle.properties', overwrite, aFile) then
  begin

    if Pos('AppCompat', FAndroidTheme) > 0 then
       strList.Add('android.useAndroidX=true');

    if DirectoryExists(FPathToJavaJDK) then
    begin
      tempStr:=FPathToJavaJDK;
      {$ifdef MSWindows}
      tempStr:=StringReplace(tempStr,'\','\\',[rfReplaceAll]);
      tempStr:=StringReplace(tempStr,':','\:',[]);
      //tempStr:=StringReplace(tempStr,' ','\ ',[rfReplaceAll]); //fix "invalid string escape"
      {$endif}
      strList.Add('org.gradle.java.home='+tempStr);
    end;
    //if need configure proxy here, too
    strList.SaveToFile(aFile);
  end;

end;

procedure UpdateGradleProperties(const FAndroidProjectName, FAndroidTheme,
  FPathToJavaJDK: string);
var
  aFile, tempStr: string;
begin

  aFile := FAndroidProjectName+pathDelim+'gradle.properties';
  if not FileExists(aFile) then
  begin
    CreateGradleProperties(FAndroidProjectName, FAndroidTheme, FPathToJavaJDK);
    exit;
  end;

  PrepareStrList;
  strList.LoadFromFile(aFile);

  if Pos('AppCompat', FAndroidTheme) > 0 then
  begin
    if Pos(Uppercase('android.useAndroidX'), Uppercase(strList.Text) ) <= 0 then
    begin
       strList.Add('android.useAndroidX=true');
    end;
  end;

  //apply change suggested by DonAlfred
  if Pos('org.gradle.java.home=', strList.Text ) <= 0 then
  begin
    if DirectoryExists(FPathToJavaJDK) then
    begin
      tempStr:=FPathToJavaJDK;
      {$ifdef MSWindows}
      tempStr:=StringReplace(tempStr,'\','\\',[rfReplaceAll]);
      tempStr:=StringReplace(tempStr,':','\:',[]);
      //tempStr:=StringReplace(tempStr,' ','\ ',[rfReplaceAll]); //fix "invalid string escape"
      {$endif}
      strList.Add('org.gradle.java.home='+tempStr);
    end;
  end;

  strList.SaveToFile(aFile);
end;

procedure CreateLocalProperties(const FAndroidProjectName, FPathToAndroidSDK,
  FPathToAndroidNDK: string; overwrite: boolean);
var
  aFile, tempStr: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'local.properties', overwrite, aFile) then
  begin
    strList.Add('sdk.dir=' + FPathToAndroidSDK);
    strList.Add('ndk.dir=' + FPathToAndroidNDK);
    {$IFDEF WINDOWS}
    tempStr:= strList.Text;
    tempStr:= StringReplace(tempStr, '\', '\\', [rfReplaceAll]);
    tempStr:= StringReplace(tempStr, ':', '\:', [rfReplaceAll]);
    strList.Text:=tempStr;
    {$ENDIF}
    strList.SaveToFile(aFile);
  end;
end;

function CreateBuildGradle(FAndroidProjectName: string;
  FPathToAndroidSDK: string; FMaxSDKPlatform: Integer; FGradleVersion: string;
  FAndroidTheme: string; instructionChip: string; FMinApi, FTargetApi: string;
  FVersionCode: Integer; FVersionName: string; FSupport: boolean;
  FPackagePrefaceName: string; FSmallProjName: string; Updating: boolean;
  buildTool: string; overwrite: boolean): boolean;
var
  compileSdkVersion: string;
  directive, strPack, aFile: String;
  innerSupported, foundSignature: Boolean;
  aAppCompatLib:TAppCompatLib;
  aSupportLib: TSupportLib;
  candidateSDKBuild: string;
  sdkBuildTools: string;
  pluginVersion: string;
  gradleCompatibleAsNumber: Integer;
  outgradleCompatible: string;
  gradleCompatible: string;
  androidPluginNumber: Integer;
  includeList: TStringList;
  chipList: string;
  universalApk: boolean;
  buildToolApi: string;
begin

  universalApk := false;
  foundSignature := false;
  if Updating then
  begin
    PrepareStrList;

    if fileExists(FAndroidProjectName + PathDelim + 'gradle.properties') then
    begin
      strList.LoadFromFile(FAndroidProjectName + PathDelim + 'gradle.properties');
      if Pos('RELEASE_STORE_FILE', strList.Text) > 0 then
        foundSignature := True;
    end;

    includeList := TStringList.Create;
    includeList.Delimiter := ',';
    includeList.StrictDelimiter := True;
    includeList.Sorted := True;
    includeList.Duplicates := dupIgnore;

    includeList.Add('''' + instructionChip + ''''); //initial  Instruction Set

    if FileExists(FAndroidProjectName + PathDelim + 'libs\armeabi\libcontrols.so') then     includeList.Add('''armeabi''');
    if FileExists(FAndroidProjectName + PathDelim + 'libs\armeabi-v7a\libcontrols.so') then includeList.Add('''armeabi-v7a''');
    if FileExists(FAndroidProjectName + PathDelim + 'libs\arm64-v8a\libcontrols.so') then   includeList.Add('''arm64-v8a''');
    if FileExists(FAndroidProjectName + PathDelim + 'libs\x86_64\libcontrols.so') then      includeList.Add('''x86_64''');
    if FileExists(FAndroidProjectName + PathDelim + 'libs\x86\libcontrols.so') then         includeList.Add('''x86''');
    if FileExists(FAndroidProjectName + PathDelim + 'libs\mips\libcontrols.so') then        includeList.Add('''mips''');

    chipList := includeList.DelimitedText; //NEW! includeList based...

    universalApk := False;
    if includeList.Count > 1 then
      universalApk := True;

    includeList.Free;
  end;

  if NeedFile(FAndroidProjectName+PathDelim+'build.gradle', overwrite, aFile) then
  begin


    {%Region /fold Gradle Setup}
    if Updating then
    begin
      // buildtool is specified, FMaxSDKPlatform ignored;
      sdkBuildTools := buildTool;
      compileSdkVersion := copy(buildTool, 1, 2);
    end
    else
    begin
      compileSdkVersion:= IntToStr(FMaxSdkPlatform);
      sdkBuildTools:= GetBuildTool(FPathToAndroidSDK, FMaxSdkPlatform, candidateSDKBuild);
    end;

    if sdkBuildTools = '' then
    begin
      sdkBuildTools:= candidateSDKBuild;
      compileSdkVersion:= Copy(sdkBuildTools,1,2);
    end;

    if sdkBuildTools = '' then
    begin
      ShowMessage('Fail! Sorry... You need install SDK "build-tools" ' +IntToStr(FMaxSdkPlatform)+'.x.y');
      result := false;
      exit;
    end;

    if Updating then
    begin
      // TODO: is this correct?
      if IsAllCharNumber(PChar(compileSdkVersion)) then
      begin
        if StrToInt(compileSdkVersion) >= 25 then
          pluginVersion := GetPluginVersion(sdkBuildTools)
        else
          pluginVersion := '2.3.3';
      end
      else
      begin
        compileSdkVersion := '29';
        pluginVersion := '3.1.0';  //gradle 4.4.1
      end;
    end
    else
    begin
      if StrToInt(compileSdkVersion) > 25 then
        pluginVersion:= GetPluginVersion(sdkBuildTools)
      else
        pluginVersion:= '2.3.3';
    end;

    if pluginVersion = '' then
    begin
      // TODO
      Result := false;
      exit;
    end;

    outgradleCompatible:= '';
    gradleCompatible:= FGradleVersion;
    if not TryGradleCompatibility(pluginVersion, FGradleVersion, outgradleCompatible) then
    begin
        if MessageDlg('Warning ','plugin "'+pluginVersion+'", "build-tools "'+sdkBuildTools+ '" require Gradle "'+outgradleCompatible+'"' +sLineBreak + '[current: "'+FGradleVersion+'"]',
           mtConfirmation, [mbOk, mbIgnore], 0) = mrOk then
           begin
              gradleCompatible:= outgradleCompatible;
              ShowMessage('Please, update to Gradle "'+outgradleCompatible+'" ' + sLineBreak + 'https://gradle.org/releases/');
           end
           else
              pluginVersion:= TryPluginCompatibility(FGradleVersion);
    end;

    androidPluginNumber:= GetVerAsNumber(pluginVersion);  //ex. 3.0.0 --> 3000
    gradleCompatibleAsNumber:= GetVerAsNumber(TryPluginCompatibility(FGradleVersion));
    if gradleCompatibleAsNumber>androidPluginNumber then
    begin
      pluginVersion:= TryPluginCompatibility(FGradleVersion);
      androidPluginNumber:= GetVerAsNumber(pluginVersion);  //ex. 3.0.0 --> 3000
    end;
    {%EndRegion Gradle Setup}

    strPack := FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

    strList.Add('buildscript {');
    strList.Add('    repositories {');
    strList.Add('        mavenCentral()');
    strList.Add('        //android plugin version >= 3.0.0 [in classpath] need gradle version >= 4.1 and google() method');
    if androidPluginNumber >= 3000 then
       strList.Add('        google()')
    else
       strList.Add('        //google()');
    strList.Add('    }');
    strList.Add('    dependencies {');
    strList.Add('        classpath ''com.android.tools.build:gradle:'+pluginVersion+'''');
    strList.Add('    }');
    strList.Add('}');

    strList.Add('allprojects {');
    strList.Add('    repositories {');

    if androidPluginNumber >= 3000 then
      strList.Add('       google()')
    else
      strList.Add('     //google()');

    if Pos('GDXGame', FAndroidTheme) > 0 then
    begin
      strList.Add('       mavenLocal()');
      strList.Add('       mavenCentral()');
      strList.Add('       maven { url "https://oss.sonatype.org/content/repositories/snapshots/" }');
      strList.Add('       maven { url "https://oss.sonatype.org/content/repositories/releases/" }');
    end
    else
    begin
      strList.Add('       mavenCentral()');
    end;

    strList.Add('       maven { url ''https://jitpack.io'' }');

    strList.Add('    }');
    strList.Add('}');

    strList.Add('apply plugin: ''com.android.application''');
    strList.Add('android {');
    strList.Add('    lintOptions {');
    strList.Add('       abortOnError false');
    strList.Add('    }');

    if (Length(instructionChip)>0) then
    begin
    strList.Add('    splits {');
    strList.Add('        abi {');
    strList.Add('            enable true');
    strList.Add('            reset()');
    if universalApk then
    begin
      strList.Add('            include '+chipList);
      strList.Add('            universalApk true');
    end
    else
    begin
      strList.Add('            include '''+instructionChip+'''');
      strList.Add('            universalApk false');
    end;
    strList.Add('        }');
    strList.Add('    }');
    end;
    strList.Add('    compileOptions {');
    strList.Add('        sourceCompatibility 1.8');
    strList.Add('        targetCompatibility 1.8');
    strList.Add('    }');
    if Pos('AppCompat', FAndroidTheme) > 0 then
    begin

      strList.Add('    compileSdkVersion '+compileSdkVersion);

      if androidPluginNumber < 3000 then
      begin
        if Updating then
          //TODO: is this correct?
          strList.Add('    buildToolsVersion "26.0.2"') //sdkBuildTools
        else
          strList.Add('    buildToolsVersion "'+sdkBuildTools+'"');
      end
      //else: each version of the Android Gradle Plugin now has a default version of the build tools

    end
    else
    begin
     strList.Add('    compileSdkVersion '+compileSdkVersion);
     if androidPluginNumber < 3000 then
        strList.Add('    buildToolsVersion "'+sdkBuildTools+'"');
     //else: each version of the Android Gradle Plugin now has a default version of the build tools
    end;

    strList.Add('    defaultConfig {');

    if Pos('AppCompat', FAndroidTheme) > 0 then
    begin

      if StrToInt(FMinApi) >= 14 then
         strList.Add('            minSdkVersion '+FMinApi)
      else
         strList.Add('            minSdkVersion 14');

      if StrToInt(FTargetApi) <= StrToInt(compileSdkVersion)  then
        strList.Add('            targetSdkVersion '+ FTargetApi)  //compileSdkVersion
      else
        strList.Add('            targetSdkVersion '+compileSdkVersion);

    end
    else
    begin
      strList.Add('            minSdkVersion '+FMinApi);

      if StrToInt(FTargetApi) <= StrToInt(compileSdkVersion)  then
        strList.Add('            targetSdkVersion '+ FTargetApi)  //compileSdkVersion
      else
        strList.Add('            targetSdkVersion '+compileSdkVersion);

    end;

    //strList.Add('            versionCode 1');
    //strList.Add('            versionName "1.0"');
    if FVersionCode =  0 then
    begin
      FVersionCode:= 1;
      FVersionName:= '1.0';
    end;

    if FVersionName = '' then  FVersionName:= '1.0';
    strList.Add('            versionCode ' + intToStr(FVersionCode));
    strList.Add('            versionName "' + FVersionName + '"');
    strList.Add('    }');

    if foundSignature then
    begin
      strList.Add('    signingConfigs {');
      strList.Add('        release {');
      strList.Add('            storeFile file(RELEASE_STORE_FILE)');
      strList.Add('            storePassword RELEASE_STORE_PASSWORD');
      strList.Add('            keyAlias RELEASE_KEY_ALIAS');
      strList.Add('            keyPassword RELEASE_KEY_PASSWORD');
      strList.Add('        }');
      strList.Add('    }');
      strList.Add('    buildTypes {');
      strList.Add('        release {');
      strList.Add('            signingConfig signingConfigs.release');
      strList.Add('        }');
      strList.Add('    }');
    end;

    strList.Add('    sourceSets {');
    strList.Add('        main {');
    strList.Add('            manifest.srcFile ''AndroidManifest.xml''');
    strList.Add('            java.srcDirs = [''src'']');
    strList.Add('            resources.srcDirs = [''src'']');
    strList.Add('            aidl.srcDirs = [''src'']');
    strList.Add('            renderscript.srcDirs = [''src'']');
    strList.Add('            res.srcDirs = [''res'']');
    strList.Add('            assets.srcDirs = [''assets'']');
    strList.Add('            jni.srcDirs = []');
    strList.Add('            jniLibs.srcDirs = [''libs'']');
    strList.Add('        }');
    strList.Add('        debug.setRoot(''build-types/debug'')');
    strList.Add('        release.setRoot(''build-types/release'')');
    strList.Add('    }');
    strList.Add('    buildTypes {');
    strList.Add('        debug {');
    strList.Add('            debuggable true');
    strList.Add('            jniDebuggable true');
    strList.Add('        }');
    strList.Add('        release {');
    strList.Add('            debuggable false');
    strList.Add('            jniDebuggable false');
    strList.Add('        }');
    strList.Add('    }');
    strList.Add('}');
    strList.Add('dependencies {');

    if androidPluginNumber < 3000 then
      directive:='compile'
    else
      directive:='implementation';

    strList.Add('    '+directive+' fileTree(include: [''*.jar''], dir: ''libs'')');

    innerSupported:= False;

    if Pos('AppCompat', FAndroidTheme) > 0 then
    begin
       innerSupported:= True;
       for aAppCompatLib in AppCompatLibs do
       begin
         strList.Add('    '+directive+' '''+aAppCompatLib.Name+'''');
         if aAppCompatLib.MinAPI > StrToInt(compileSdkVersion) then
             ShowMessage('Warning: AppCompat theme need Android SDK >= ' +
                          IntToStr(aAppCompatLib.MinAPI));
       end;
       //strList.Add('    '+directive+' ''com.google.android.gms:play-services-ads:11.0.4''');
    end else
     if FSupport and (not innerSupported) then
     begin
       for aSupportLib in SupportLibs do
       begin
         strList.Add('    '+directive+' '''+aSupportLib.Name+'''');
         if aSupportLib.MinAPI > StrToInt(compileSdkVersion) then
           ShowMessage('Warning: Support library need Android SDK >= ' +
                        IntToStr(aSupportLib.MinAPI));
       end;
       //strList.Add('    '+directive+' ''com.google.android.gms:play-services-ads:11.0.4''');
     end;

    if Pos('GDXGame', FAndroidTheme) > 0 then     //just a conceptual project....
    begin
       if androidPluginNumber >=  3000 then directive:= 'api';
       strList.Add('    '+directive+' ''com.badlogicgames.gdx:gdx:1.9.10''');
       strList.Add('    '+directive+' ''com.badlogicgames.gdx:gdx-box2d:1.9.10''');
       strList.Add('    '+directive+' ''com.badlogicgames.gdx:gdx-backend-android:1.9.10''');
       strList.Add('    '+directive+' ''com.badlogicgames.gdx:gdx-box2d:1.9.10''');
    end;

    strList.Add('}');
    strList.Add(' ');
    strList.Add('task run(type: Exec, dependsOn: '':installDebug'') {');
    strList.Add('	if (System.properties[''os.name''].toLowerCase().contains(''windows'')) {');
    strList.Add('	    commandLine ''cmd'', ''/c'', ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+strPack+'/.App"');
    strList.Add('	} else {');
    strList.Add('	    commandLine ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+strPack+'/.App"');
    strList.Add('	}');
    strList.Add('}');
    strList.Add(' ');

    if Updating then
      // TODO: is this correct?
      gradleCompatibleAsNumber := GetVerAsNumber(gradleCompatible);

    if  gradleCompatibleAsNumber < 5000 then
    begin
      strList.Add('task wrapper(type: Wrapper) {');
      strList.Add('    gradleVersion = '''+ TryUndoFakeVersion(gradleCompatible)+'''');
      strList.Add('}');
    end
    else
    begin
      strList.Add('wrapper {');
      strList.Add('    gradleVersion = '''+ TryUndoFakeVersion(gradleCompatible)+'''');
      strList.Add('}');
    end;
    strList.Add('//how to use: look for "gradle_readme.txt"');
    strList.SaveToFile(aFile);
  end;

  result := true;
end;

procedure CreateGradleReadme(FAndroidProjectName, FPathToGradle,
  FPathToAndroidSDK: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle_readme.txt', overwrite, aFile) then
  begin
    strList.Add(' ');
    strList.Add(' ');
    strList.Add('HOW TO use "gradle.build" file');
    strList.Add(' ');
    strList.Add('       ::by jmpessoa');
    strList.Add(' ');
    strList.Add('references:');
    strList.Add('   http://spring.io/guides/gs/gradle-android/');
    strList.Add('   https://paulemtz.blogspot.com.br/2013/04/automating-android-builds-with-gradle.html');
    strList.Add(' ');
    strList.Add('   WARNING: you will need INTERNET CONNECTION!!');
    strList.Add(' ');
    strList.Add('***SYSTEM INFRASTRUCTURE');
    strList.Add(' ');
    strList.Add('(1) Look for the highest "...\sdk\build-tools" version');
    strList.Add('        The table point out gradle and "sdk\build-tools" versions compatibility');
    strList.Add(' ');
    strList.Add('        plugin [in classpath]           gradle        sdk\build-tools');
    strList.Add('                   2.0.0                2.10          21.1.2');
    strList.Add('                   2.2.0                2.14.1        23.0.2');
    strList.Add('                   2.3.3                3.3           25.0.3');
    strList.Add('                   3.0.1                4.1           26.0.2');
    strList.Add(' ');
    strList.Add('        Note 1. You can interpolate to some value other than these.');
    strList.Add('        Ex. If in your system the highest "sdk\build-tools" is "22.0.1", so downloaded/Installed gradle 2.1.0, etc..');
    strList.Add(' ');
    strList.Add('        Note 2. In "build.gradle" file, the gradle version is set to be compatible with the highest "sdk\build-tools" found in your system');
    strList.Add('        as a consequence, it is this version of gradle that you must download/install.');
    strList.Add(' ');
    strList.Add('        reference:');
    strList.Add('           https://developer.android.com/studio/releases/gradle-plugin.html#2-3-0');
    strList.Add('           https://gradle.org/releases/');
    strList.Add('           Hint: downloading just "binary-only" is OK!');
    strList.Add(' ');
    strList.Add('        Note 3. You should set the gradle path in Lazarus menu "Tools --> LAMW --> Paths Settings..."');
    strList.Add(' ');
    strList.Add('        Note 4. If your connection has a proxy, edit the "gradle.properties" file content. Example: ');
    strList.Add(' ');
    strList.Add('             systemProp.http.proxyHost=10.0.16.1');
    strList.Add('             systemProp.http.proxyPort=3128');
    strList.Add('             systemProp.https.proxyHost=10.0.16.1');
    strList.Add('             systemProp.https.proxyPort=3128');
    strList.Add(' ');
    strList.Add('        Note 5. Java Jdk 1.8, Android SDK "platform" 29 [or up],  "build-tools" 29.0.3, Android SDK Extra "support library/repository" and "Gradle 6.6.1" are "must have" to support AppCompat material theme in LAMW 0.8.6.1');
    strList.Add(' ');
    strList.Add(' ');
    strList.Add('***SETTING ENVIRONMENT VARIABLES...');
    strList.Add(' ');
    strList.Add('[windows] cmd line prompt:');
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
       strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
       strList.Add('set GRADLE_HOME='+FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    strList.Add(' ');

    strList.Add('[linux] cmd line prompt:');
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
       strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+ FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    strList.Add(' ');
    strList.Add('WARNING: The following tasks assume that you have:');
    strList.Add('         .Internet connection;');
    strList.Add('         .Set the environment variables;');
    strList.Add('         .Installed gradle version compatible with your highest "sdk\build-tools"');
    strList.Add(' ');
    strList.Add('***BUILDING AND RUNNING APK ....');
    strList.Add(' ');
    strList.Add('.METHOD - I.');
    strList.Add('    Running installed local version of gradle');
    strList.Add(' ');
    strList.Add('    ::Go to your project folder....');
    strList.Add(' ');
    strList.Add('[windows] cmd line prompt:');
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools'); //
    if FPathToGradle = '' then
       strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    strList.Add(' ');
    strList.Add('[windows] cmd line prompt:');
    strList.Add('gradle clean build --info');
    strList.Add('gradle run');
    strList.Add(' ');
    strList.Add(' ');
    strList.Add('[linux] cmd line prompt:');
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
      strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+FPathToGradle);

    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    strList.Add(' ');
    strList.Add('[linux] cmd line prompt:');
    //strList.Add('.\gradle clean build --info');
    strList.Add('gradle clean build --info');
    //strList.Add('.\gradle run');
    strList.Add('gradle run');
    strList.Add(' ');
    strList.Add('Congratulation!');
    strList.Add(' ');
    strList.Add('    :: Where is my Apk? here: "'+FAndroidProjectName+'\build\outputs\apk"!');
    strList.Add('       IMPORTANT: You need to sign your [release] apk for "Google Play" store!');
    strList.Add('                  Please, read the "How_To_Get_Your_Signed_Release_Apk.txt"');
    strList.Add(' ');
    strList.Add('hint: you can try edit and run:');
    strList.Add('[windows] "gradle-local-build.bat"');
    strList.Add('[linux] "gradle-local-build.sh"');

    strList.Add('[windows] "gradle-local-run.bat"');
    strList.Add('[linux] "gradle-local-run.sh"');

    strList.Add(' ');
    strList.Add(' ');
    strList.Add('.METHOD - II.');
    strList.Add(' ');
    strList.Add('(1) Making "gradlew" (gradle wrapper) available for building your project');
    strList.Add('    ::Go to your project folder....');
    strList.Add(' ');
    strList.Add('[windows] cmd line prompt:');
    strList.Add('gradle wrapper');
    strList.Add(' ');
    strList.Add('[linux] cmd line prompt:');
    strList.Add('./gradle wrapper');
    strList.Add(' ');
    strList.Add('hint: you can try edit and run:');
    strList.Add('[windows] "gradle-making-wrapper.bat"');
    strList.Add('[linux] "gradle-making-wrapper.sh"');

    strList.Add(' ');
    strList.Add('(2) Building your project with "gradlew" [gradle wrapper]');
    strList.Add(' ');
    strList.Add('[windows] cmd line prompt:');
    strList.Add('gradlew build');
    strList.Add(' ');
    strList.Add('[linux] cmd line prompt:');
    strList.Add('./gradlew build');
    strList.Add(' ');
    strList.Add('hint: you can try edit and "build" with gradle wrapper:');
    strList.Add('      [windows] "gradlew-build.bat"');
    strList.Add('      [linux]   "gradlew-build.sh"');
    strList.Add(' ');
    strList.Add('(3) Installing and Runing Apk');
    strList.Add(' ');
    strList.Add('[windows] cmd line prompt:');
    strList.Add('gradlew install');
    strList.Add(' ');
    strList.Add('[linux] cmd line prompt:');
    strList.Add('./gradlew run');
    strList.Add(' ');
    strList.Add('Congratulation!');
    strList.Add(' ');
    strList.Add('hint: where is my Apk? here: "'+FAndroidProjectName+'\build\outputs\apk"');
    strList.Add(' ');
    strList.Add('hint: you can try edit and "run" with gradle wrapper:');
    strList.Add('      [windows] "gradlew-run.bat"');
    strList.Add('      [linux] "gradlew-run.sh"');
    strList.Add(' ');
    strList.Add(' ');
    strList.Add('hint: how can I  produce a signed release Apk? read "How_To_Get_Your_Signed_Release_Apk.txt');
    strList.Add(' ');
    strList.Add('Thanks to All!');
    strList.Add(' ');
    strList.Add('by jmpessoa_hotmail_com');

    strList.SaveToFile(aFile);
  end;

end;

procedure CreateGradleAdbInstallDebug(FAndroidProjectName,
  FPathToAndroidSDK, FPackagePrefaceName, FSmallProjName,
  instructionChip: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-adb-install-debug'+ScriptExt, overwrite, aFile) then
  begin
    strList.Add(FPathToAndroidSDK+'platform-tools'+
               DirectorySeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
    strList.Add(FPathToAndroidSDK+'platform-tools'+
               DirectorySeparator+'adb install -r '+FAndroidProjectName+DirectorySeparator+'build'+DirectorySeparator+'outputs'+DirectorySeparator+'apk'+DirectorySeparator+'debug'+DirectorySeparator+FSmallProjName+'-'+instructionChip+'-debug.apk');
    {$IFDEF WINDOWS}strList.Add('pause');{$ENDIF}
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleJarsignerVerify(FAndroidProjectName, FPathToJavaJDK,
  FSmallProjName: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-jarsigner-verify'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
    strList.Add('path %JAVA_HOME%'+PathDelim+'bin;%path%');
    strList.Add('cd '+FAndroidProjectName);
    {$ELSE}
    {$IFDEF DARWIN}
    strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
    {$ELSE}
    strList.Add('export JAVA_HOME='+FPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    {$ENDIF}
    strList.Add('cd '+FAndroidProjectName);
    {$ENDIF}
    strList.Add('jarsigner -verify -verbose -certs '+FAndroidProjectName+DirectorySeparator+'build'+DirectorySeparator+'outputs'+DirectorySeparator+'apk'+DirectorySeparator+'release'+DirectorySeparator+FSmallProjName+'-release.apk');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleMakingWrapper(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-making-wrapper'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
      strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+ FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    {$ENDIF}
    strList.Add('gradle wrapper');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleWBuild(FAndroidProjectName, FPathToAndroidSDK, FPathToGradle: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradlew-build'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+ FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
       strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
       strList.Add('export GRADLE_HOME='+FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    //strList.Add('./gradlew build');
    {$ENDIF}
    strList.Add('gradlew build');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleWRun(FAndroidProjectName, FPathToAndroidSDK,
  FPathToGradle: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradlew-run'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+ FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
       strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
       strList.Add('export GRADLE_HOME='+FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    //strList.Add('./gradlew run');
    {$ENDIF}
    strList.Add('gradlew run');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleLocalBuild(FAndroidProjectName, FPathToAndroidSDK,
  FPathToGradle: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-local-build'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+ FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
      strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+ FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    {$ENDIF}
    strList.Add('gradle clean build --info');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleLocalBuildBundle(FAndroidProjectName, FPathToAndroidSDK,
  FPathToGradle: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-local-build-bundle'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+ FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
      strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+ FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    {$ENDIF}
    strList.Add('gradle clean bundle --info');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleLocalAPKSigner(FAndroidProjectName, FPathToAndroidSDK,
  FPathToGradle, FSmallProjName, instructionChip: string; FMaxSDKPlatform:Integer; overwrite: boolean);
var
  aFile, tempStr, sdkBuildTools, apkName, SubRelease: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-local-apksigner'+ScriptExt, overwrite, aFile) then
  begin
    //fixed! thanks do @pasquale!
    //thanks to TR3E!

    apkName:= FSmallProjName+ '-' + instructionChip;
    sdkBuildTools:= GetBuildTool(FPathToAndroidSDK, FMaxSdkPlatform, tempStr);

    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools;'+FPathToAndroidSDK+'build-tools\'+sdkBuildTools);
    strList.Add('set GRADLE_HOME='+FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    strList.Add('export PATH='+FPathToAndroidSdk+'build-tools/'+sdkBuildTools+':$PATH');
    strList.Add('export GRADLE_HOME='+ FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    {$ENDIF}
    SubRelease := pathDelim+'build'+pathDelim+'outputs'+pathDelim+'apk'+pathDelim+'release'+pathDelim;
    strList.Add('zipalign -v -p 4 '+FAndroidProjectName+SubRelease+apkName+'-release-unsigned.apk '+FAndroidProjectName+SubRelease+apkName+'-release-unsigned-aligned.apk');
    strList.Add('apksigner sign --ks '+FAndroidProjectName+PathDelim+Lowercase(FSmallProjName)+'-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out '+FAndroidProjectName+SubRelease+FSmallProjName+'-release.apk '+FAndroidProjectName+SubRelease+apkName+'-release-unsigned-aligned.apk');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleLocalUniversalAPKSigner(FAndroidProjectName,
  FPathToAndroidSDK, FPathToGradle, FSmallProjName: string;
  FMaxSDKPlatform: Integer; overwrite: boolean);
var
  aFile, sdkBuildTools, tempStr, SubRelease: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-local-universal-apksigner'+ScriptExt, overwrite, aFile) then
  begin
    //multi-arch :: armeabi-v7a + arm64-v8a + ...
    sdkBuildTools:= GetBuildTool(FPathToAndroidSDK, FMaxSdkPlatform, tempStr);
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools;'+FPathToAndroidSDK+'build-tools\'+sdkBuildTools);
    strList.Add('set GRADLE_HOME='+FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    strList.Add('export PATH='+FPathToAndroidSdk+'build-tools/'+sdkBuildTools+':$PATH');
    strList.Add('export GRADLE_HOME='+ FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    {$ENDIF}
    SubRelease := pathDelim+'build'+pathDelim+'outputs'+pathDelim+'apk'+pathDelim+'release'+pathDelim;
    strList.Add('zipalign -v -p 4 '+FAndroidProjectName+SubRelease+FSmallProjName+'-universal-release-unsigned.apk '+FAndroidProjectName+SubRelease+FSmallProjName+'-universal-release-unsigned-aligned.apk');
    strList.Add('apksigner sign --ks '+FAndroidProjectName+PathDelim+Lowercase(FSmallProjName)+'-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out '+FAndroidProjectName+SubRelease+FSmallProjName+'-release.apk '+FAndroidProjectName+SubRelease+FSmallProjName+'-universal-release-unsigned-aligned.apk');
    ScriptSave(aFile);
  end;
end;

procedure CreateGradleLocalRun(FAndroidProjectName, FPathToAndroidSDK,
  FPathToGradle: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'gradle-local-run'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+ FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    {$ELSE}
    strList.Add('export PATH='+FPathToAndroidSdk+'platform-tools'+':$PATH');
    if FPathToGradle = '' then
      strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+ FPathToGradle);
    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    {$ENDIF}
    strList.Add('gradle run');
    ScriptSave(aFile);
  end;
end;

procedure CreateBuildXML(FAndroidProjectName, FPathToAndroidSDK, FAndroidTheme,
  FTargetApi, FPackagePrefaceName, FSmallProjName: string; overwrite: boolean);
var
  intTargetApi, i: Integer;
  strPack, aFile: String;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'build.xml', overwrite, aFile) then
  begin
    intTargetApi:= StrToInt(FTargetApi);

    strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
    strList.Add('<project name="'+FSmallProjName+'" default="help">');
    strList.Add('<property name="sdk.dir" location="'+FPathToAndroidSDK+'"/>');

    if (Pos('AppCompat', FAndroidTheme) > 0) and (intTargetApi < 21) then
      strList.Add('<property name="target" value="android-21"/>')
    else
      strList.Add('<property name="target" value="android-'+Trim(FTargetApi)+'"/>');

    strList.Add('<property file="ant.properties"/>');
    strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');

    // tk Generate code to allow conditional compilation in our java sources
    strPack := FPackagePrefaceName + '.' + LowerCase(FSmallProjName);
    strList.Add('');
    strList.Add('<!-- Tags required to enable conditional compilation in java sources -->');
    strList.Add('<property name="src.dir" location=".'+PathDelim+'src'+PathDelim+ IncludeTrailingPathDelimiter(ReplaceChar(strPack, '.', PathDelim))+'"/>');
    strList.Add('<property name="source.dir" value="${src.dir}/${target}" />');
    strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>');

    strList.Add('');
    strList.Add('<!-- API version properties, modify according to your API level -->');
    for i := cMinAPI to cMaxAPI do
    begin
      if i <= intTargetApi then
        strList.Add('<property name="api'+IntToStr(i)+'" value="true"/>') //does the magic!!!!
      else
        strList.Add('<property name="api'+IntToStr(i)+'" value="false"/>');
    end;

    strList.Add('');
    strList.Add('<!-- API conditions, do not modify -->');
    for i := cMinAPI to cMaxAPI do
    begin
      strList.Add('<condition property="ifdef_api'+IntToStr(i)+'up" value="/*">');
      strList.Add('  <equals arg1="${api'+IntToStr(i)+'}" arg2="false"/>');
      strList.Add('</condition>');
      strList.Add('<condition property="endif_api'+IntToStr(i)+'up" value="*/">');
      strList.Add('  <equals arg1="${api'+IntToStr(i)+'}" arg2="false"/>');
      strList.Add('</condition>');
      strList.Add('<property name="ifdef_api'+IntToStr(i)+'up" value=""/>');
      strList.Add('<property name="endif_api'+IntToStr(i)+'up" value=""/>');
    end;

    strList.Add('');
    strList.Add('<!-- Copy & filter java sources for defined Android target, do not modify -->');
    strList.Add('<copy todir="${src.dir}/${target}">');
    strList.Add('  <fileset dir="${src.dir}">');
    strList.Add('    <include name="*.java"/>');
    strList.Add('  </fileset>');
    strList.Add('  <filterset begintoken="//[" endtoken="]">');
    for i := cMinAPI to cMaxAPI do
    begin
      strList.Add('    <filter token="ifdef_api'+IntToStr(i)+'up" value="${ifdef_api'+IntToStr(i)+'up}"/>');
      strList.Add('    <filter token="endif_api'+IntToStr(i)+'up" value="${endif_api'+IntToStr(i)+'up}"/>');
    end;
    strList.Add('  </filterset>');
    strList.Add('</copy>');
    // end tk
    strList.Add('</project>');
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateAntReadme(FAndroidProjectName, FAntBuildMode,
  FSmallProjName: string; overwrite: boolean);
var
  aFile: String;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'readme.txt', overwrite, aFile) then
  begin
    strList.Add('Tutorial: How to get your Android Application [Apk] using "Ant":');
    strList.Add(' ');
    strList.Add('   NEW! Go to Lazarus IDE menu "Run--> [LAMW] Build and Run"! Thanks to Anton!!!');
    strList.Add(' ');
    strList.Add('1. Double click "ant-build-debug.bat [.sh]" to build Apk');
    strList.Add(' ');
    strList.Add('2. If Android Virtual Device[AVD]/Emulator [or real device] is running then:');
    strList.Add('   2.1 double click "install-'+FAntBuildMode+'.bat" to install the Apk on the Emulator [or real device]');
    strList.Add('   2.2 look for the App "'+FSmallProjName+'" in the Emulator [or real device] and click it!');
    strList.Add(' ');
    strList.Add('3. If AVD/Emulator is NOT running:');
    strList.Add('   3.1 If AVD/Emulator NOT exist:');
    strList.Add('        3.1.1 double click "paused_create-avd-default.bat" to create the AVD ['+DirectorySeparator+'utils folder]');
    strList.Add('   3.2 double click "launch-avd-default.bat" to launch the Emulator ['+DirectorySeparator+'utils  folder]');
    strList.Add('   3.3 look for the App "'+FSmallProjName+'" in the Emulator and click it!');
    strList.Add(' ');
    strList.Add('4. Log/Debug');
    strList.Add('   4.1 double click "logcat*.bat" to read logs and bugs! ['+DirectorySeparator+'utils folder]');
    strList.Add(' ');
    strList.Add('5. Uninstall Apk');
    strList.Add('   5.1 double click "uninstall.bat" to remove Apk from the Emulator [or real device]!');
    strList.Add(' ');
    strList.Add('6. To find your Apk look for the "'+FSmallProjName+'-'+FAntBuildMode+'.apk" in '+DirectorySeparator+'bin folder!');
    strList.Add(' ');
    strList.Add('7. Android Asset Packaging Tool: to know which files were packed in "'+FSmallProjName+'-'+FAntBuildMode+'.apk"');
    strList.Add('   7.1 double click "aapt.bat" ['+DirectorySeparator+'utils folder]' );
    strList.Add(' ');
    strList.Add('8. To see all available Android targets in your system ['+DirectorySeparator+'utils folder]');
    strList.Add('   8.1 double click "paused_list_target.bat" ');
    strList.Add(' ');
    strList.Add('9. Hint 1: you can edit "*.bat" to extend/modify some command or to fix some incorrect info/path!');
    strList.Add(' ');
    strList.Add('10.Hint 2: you can edit "build.xml" to set another Android target. ex. "android-18" or "android-19" etc.');
    strList.Add('   WARNING: Yes, if after run  "ant-build-debug.*" the folder "...\bin" is still empty then try another target!' );
    strList.Add('   WARNING: If you changed the target in "build.xml" change it in "AndroidManifest.xml" too!' );
    strList.Add(' ');
    strList.Add('11.WARNING: After a new [Lazarus IDE]-> "run->build" do not forget to run again: "ant-build-debug.bat" and "install.bat" !');
    strList.Add(' ');
    strList.Add('12. Linux users: use "ant-build-debug.sh" , "install-'+FAntBuildMode+'.sh" , "uninstall.sh" and "logcat.sh" [thanks to Stephano!]');
    strList.Add('    WARNING: All demos Apps was generate on my windows system! So, please,  edit its to correct paths...!');
    strList.Add(' ');
    strList.Add('13. WARNING, before to execute "ant-build-release.bat" [.sh]  you need execute "release-keystore.bat" [.sh] !');
    strList.Add('    Please, read "How_To_Get_Your_Signed_Release_Apk.txt"');
    strList.Add(' ');
    strList.Add('14. Please, for more info, look for "How to use the Demos" in "LAMW: Lazarus Android Module Wizard" readme.txt!!');
    strList.Add(' ');
    strList.Add('....  Thank you!');
    strList.Add(' ');
    strList.Add('....  by jmpessoa_hotmail_com');
    strList.Add(' ');
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateAntProperties(FAndroidProjectName, FSmallProjName: string; overwrite: boolean);
var
  aFile, apk_aliaskey: String;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'ant.properties', overwrite, aFile) then
  begin
    apk_aliaskey:= LowerCase(FSmallProjName)+'.keyalias';
    strList.Add('java.source=1.8');
    strList.Add('java.target=1.8');
    strList.Add('key.store='+LowerCase(FSmallProjName)+'-release.keystore');
    strList.Add('key.alias='+apk_aliaskey);
    strList.Add('key.store.password=123456');
    strList.Add('key.alias.password=123456');
    strList.SaveToFile(aFile);
  end;
end;

procedure UpdateAntProperties(FAndroidProjectName: string);
begin
  PrepareStrList;
  strList.LoadFromFile(FAndroidProjectName+PathDelim+'ant.properties');
  if Pos('java.source=1.8', strList.Text) <= 0 then
  begin
    strList.Insert(0,'java.target=1.8');
    strList.Insert(0,'java.source=1.8');
    strList.SaveToFile(FAndroidProjectName+'ant.properties');
  end;
end;

procedure CreateProguardPoject(FAndroidProjectName: string; overwrite: boolean);
var
  aFile: String;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'proguard-project.txt', overwrite, aFile) then
  begin
    strList.Add('# To enable ProGuard in your project, edit project.properties');
    strList.Add('# to define the proguard.config property as described in that file.');
    strList.Add('#');
    strList.Add('# Add project specific ProGuard rules here.');
    strList.Add('# By default, the flags in this file are appended to flags specified');
    strList.Add('# in ${sdk.dir}/tools/proguard/proguard-android.txt');
    strList.Add('# You can edit the include path and order by changing the ProGuard');
    strList.Add('# include property in project.properties.');
    strList.Add('#');
    strList.Add('# For more details, see');
    strList.Add('#   http://developer.android.com/guide/developing/tools/proguard.html');
    strList.Add(' ');
    strList.Add('# Add any project specific keep options here:');
    strList.Add(' ');
    strList.Add('# If your project uses WebView with JS, uncomment the following');
    strList.Add('# and specify the fully qualified class name to the JavaScript interface');
    strList.Add('# class:');
    strList.Add('#-keepclassmembers class fqcn.of.javascript.interface.for.webview {');
    strList.Add('#   public *;');
    strList.Add('#}');
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateProjectProperties(FAndroidProjectName, FAndroidTheme, FTargetApi: string;
  overwrite: boolean);
var
  aFile: String;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'project.properties', overwrite, aFile) then
  begin
    strList.Add('# This file is automatically generated by Android Tools.');
    strList.Add('# Do not modify this file -- YOUR CHANGES WILL BE ERASED!');
    strList.Add('#');
    strList.Add('# This file must be checked in Version Control Systems.');
    strList.Add('#');
    strList.Add('# To customize properties used by the Ant build system edit');
    strList.Add('# "ant.properties", and override values to adapt the script to your');
    strList.Add('# project structure.');
    strList.Add('#');
    strList.Add('# To enable ProGuard to shrink and obfuscate your code, uncomment this (available properties: sdk.dir, user.home):');
    strList.Add('#proguard.config=${sdk.dir}/tools/proguard/proguard-android.txt:proguard-project.txt');
    strList.Add(' ');
    strList.Add('# Project target.');
    if Pos('AppCompat', FAndroidTheme) > 0 then
    begin
       if StrToInt(FTargetApi) >= 26 then  //
         strList.Add('target=android-'+ FTargetApi)
       else
         strList.Add('target=android-26');  //
    end
    else
    begin
       strList.Add('target=android-'+FTargetApi);
    end;
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateAntBuildDebug(FAndroidProjectName, FPathToJavaJDK,
  FPathToAntBin: string; overwrite: boolean);
var
  aFile: string;
begin
  if FPathToAntBin = '' then //PATH=$PATH:/data/myscripts
    exit;

  if NeedFile(FAndroidProjectName+PathDelim+'ant-build-debug'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !  [set path=%path%;C:\and32\ant\bin]
    strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
    strList.Add('cd '+FAndroidProjectName);
    strList.Add('call ant clean -Dtouchtest.enabled=true debug');
    strList.Add('if errorlevel 1 pause');
    {$ELSE}
    {$IFDEF DARWIN}
    strList.Add('export PATH='+FPathToAntBin+':$PATH');        //export PATH=/usr/bin/ant:PATH
    strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
    {$ELSE}
    strList.Add('export PATH='+FPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH
    strList.Add('export JAVA_HOME='+FPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    {$ENDIF}
    strList.Add('cd '+FAndroidProjectName);
    strList.Add('ant -Dtouchtest.enabled=true debug');
    {$ENDIF}
    ScriptSave(aFile);  //build Apk using "Ant"
  end;
end;

procedure CreateAntBuildRelease(FAndroidProjectName, FPathToJavaJDK,
  FPathToAntBin: string; overwrite: boolean);
var
  aFile: string;
begin
  if FPathToAntBin = '' then //PATH=$PATH:/data/myscripts
    exit;

  if NeedFile(FAndroidProjectName+PathDelim+'ant-build-release'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !  [set path=%path%;C:\and32\ant\bin]
    strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
    strList.Add('cd '+FAndroidProjectName);
    strList.Add('call ant clean release');
    strList.Add('if errorlevel 1 pause');
    {$ELSE}
    {$IFDEF DARWIN}
    strList.Add('export PATH='+FPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH
    strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
    {$ELSE}
    strList.Add('export PATH='+FPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH
    strList.Add('export JAVA_HOME='+FPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    {$ENDIF}
    strList.Add('cd '+FAndroidProjectName);
    strList.Add('ant clean release');
    {$ENDIF}
    ScriptSave(aFile);  //build Apk using "Ant"
  end;
end;

procedure CreateAntAdbInstallDebug(FAndroidProjectName, FPathToAndroidSDK,
  FPackagePrefaceName, FSmallProjName: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'ant-adb-install-debug'+ScriptExt, overwrite, aFile) then
  begin
    strList.Add(FPathToAndroidSDK+'platform-tools'+
               DirectorySeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
    strList.Add(FPathToAndroidSDK+'platform-tools'+
               DirectorySeparator+'adb install -r '+FAndroidProjectName+DirectorySeparator+'bin'+DirectorySeparator+FSmallProjName+'-debug.apk');
    {$IFDEF WINDOWS}
    strList.Add('pause');
    {$ENDIF}
    ScriptSave(aFile);
  end;
end;

procedure CreateAntJarsignerVerify(FAndroidProjectName, FPathToJavaJDK,
  FSmallProjName: string; overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'ant-jarsigner-verify'+ScriptExt, overwrite, aFile) then
  begin
    {$IFDEF WINDOWS}
    strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
    strList.Add('path %JAVA_HOME%'+PathDelim+'bin;%path%');
    {$ELSE}
    {$IFDEF DARWIN}
    strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
    {$ELSE}
    strList.Add('export JAVA_HOME='+FPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    {$ENDIF}
    {$ENDIF}
    strList.Add('cd '+FAndroidProjectName);
    strList.Add('jarsigner -verify -verbose -certs '+FAndroidProjectName+DirectorySeparator+'bin'+DirectorySeparator+FSmallProjName+'-release.apk');
    ScriptSave(aFile);
  end;
end;

procedure CreateJavaSrcDir(FAndroidProjectName, FPackageName,
  FSmallProjName: string; out FFullJavaSrcPath: string);
var
  L: TStringList;
  FPathToJavaSrc: string;
  i: Integer;
begin

  FPathToJavaSrc:= FAndroidProjectName + DirectorySeparator + 'src';

  if not DirectoryExists(FPathToJavaSrc) then
  begin
    ForceDirectories(FPathToJavaSrc);

    FFullJavaSrcPath:= FPathToJavaSrc;
    L := TStringList.Create;
    L.Clear;
    L.StrictDelimiter:= True;
    L.Delimiter:= '.';
    L.DelimitedText:= FPackageName + '.' + LowerCase(FSmallProjName);
    for i:= 0 to L.Count -1 do
    begin
       FFullJavaSrcPath:= FFullJavaSrcPath + DirectorySeparator + L.Strings[i];
       CreateDir(FFullJavaSrcPath);
    end;
    L.Free;
  end;
end;

procedure CreateDrawables(FAndroidProjectName, FPathToJavaTemplates: string;
  overwrite: boolean);
begin
  CreateDir(FAndroidProjectName+ DirectorySeparator + 'res' +DirectorySeparator+'drawable');

  CreateDir(FAndroidProjectName+ DirectorySeparator + 'res' +DirectorySeparator+'drawable-hdpi');
  CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png',
           FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png');

  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
  CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png',
           FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png');

  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
  CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png',
           FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png');

  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
  CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png',
           FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png');

  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
  CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png',
           FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png');

  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');
end;

procedure CreateStringsXml(FAndroidProjectName, FSmallProjName: string;
  overwrite: boolean);
var
  aFile: string;
begin
  if NeedFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml', overwrite, aFile) then
  begin
    strList.Add('<?xml version="1.0" encoding="utf-8"?>');
    strList.Add('<resources>');
    strList.Add('   <string name="app_name">'+FSmallProjName+'</string>');
    strList.Add('   <string name="hello_world">Hello world!</string>');
    strList.Add('</resources>');
    strList.SaveToFile(aFile);
  end;
end;

procedure CreateColorsXml(FAndroidProjectName, FPathToJavaTemplates,
  FAndroidThemeColor: string; overwrite: boolean);
begin
  AltCopyFile(
    FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors'+DirectorySeparator+FAndroidThemeColor+DirectorySeparator+'colors.xml',
    FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml',
    overwrite,
    FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');
end;

procedure CreateStylesXml(FAndroidProjectName, FPathToJavaTemplates,
  FAndroidTheme: string; overwrite: boolean);
var
  dstFile: String;
begin
  dstFile := FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml';
  if overwrite or not FileExists(dstFile) then
  begin
    ForceDirectories(ExtractFilePath(dstFile));
    if Pos('AppCompat', FAndroidTheme) > 0 then
    begin
        CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+FAndroidTheme+'.xml', dstFile, COPY_FLAGS[overwrite]);
    end
    else if Pos('GDXGame', FAndroidTheme) > 0 then
    begin
        CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+FAndroidTheme+'.xml', dstFile, COPY_FLAGS[overwrite]);
    end
    else
    begin
       CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'styles.xml', dstFile, COPY_FLAGS[overwrite]);
    end;
  end;
end;

procedure CreateTargetStylesXml(FAndroidProjectName, FPathToJavaTemplates,
  FAndroidTheme, FMinApi, FTargetApi: string; overwrite: boolean);
var
  intTargetApi, intMinApi: LongInt;
  strText: String;
begin
  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11');

  intTargetApi:= StrToInt(FTargetApi);
  if intTargetApi < 14 then   intTargetApi:= 14;
  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');
  //replace "dummyTheme" ..res\values-v14

  PrepareStrList;
  strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');

  if (intTargetApi >= 14) and (intTargetApi < 21) then
     strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.'+FAndroidTheme, [rfReplaceAll])
  else
     strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.DeviceDefault', [rfReplaceAll]);

  strList.Text:= strText;
  strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');

  intMinApi:= StrToInt(FMinApi);

  CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21');

  //replace "dummyTheme" ..res\values-v21
  strList.Clear;
  if (Pos('AppCompat', FAndroidTheme) <= 0) and (Pos('GDXGame', FAndroidTheme) <= 0) then  //not AppCompat
  begin
    CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21');
    //replace "dummyTheme" ..res\values-v21
    if intMinApi >= 21 then
    begin
      strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml')
    end
    else
      strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v21'+DirectorySeparator+'styles-empty.xml');

    if (intTargetApi >= 21) then
    begin
      strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.'+FAndroidTheme, [rfReplaceAll])
    end
    else
    begin
      strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.DeviceDefault', [rfReplaceAll]);
    end;

    strList.Text:= strText;
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml');
  end;
end;

procedure CreateActivityAppXml(FAndroidProjectName,
  FPathToJavaTemplates: string; overwrite: boolean);
begin
  AltCopyFile(
    FPathToJavaTemplates+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml',
    FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml',
    overwrite
  );
end;

procedure CreateJSupportedJava(FPathToJavaTemplates, FFullJavaSrcPath,
  FPackagePrefaceName, FSmallProjName: string; FSupport: boolean;
  overwrite: boolean);
var
  strPackName, dest: String;
begin
  dest := FFullJavaSrcPath + DirectorySeparator + 'jSupported.java';
  if overwrite or not FileExists(dest) then
  begin
    ForceDirectories(ExtractFilePath(dest));
    strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);
    with TStringList.Create do
    begin
      if FSupport then  // refactored by jmpessoa: UNIQUE "Controls.java" !!!
      begin
        if FileExists(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jSupported.java') then
        begin
          LoadFromFile(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jSupported.java');
          Strings[0] := 'package ' + strPackName + ';';  //replace dummy
          SaveToFile(dest);
        end;
      end
      else
      begin
        if FileExists(FPathToJavaTemplates+DirectorySeparator+ 'jSupported.java') then
        begin
          LoadFromFile(FPathToJavaTemplates+DirectorySeparator+ 'jSupported.java');
          Strings[0] := 'package ' + strPackName + ';';  //replace dummy
          SaveToFile(dest);
        end;
      end;
      Free;
    end;
  end;
end;

procedure CreateSupportProviderPathsXML(FAndroidProjectName,
  FPathToJavaTemplates: string; FSupport: boolean; overwrite: boolean);
begin
  if FSupport then
    AltCopyFile(
      FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'support_provider_paths.xml',
      FAndroidProjectName+DirectorySeparator +'res'+DirectorySeparator+'xml'+DirectorySeparator+'support_provider_paths.xml',
      overwrite);
end;

procedure CreateControlsJava(FPathToJavaTemplates, FFullJavaSrcPath,
  FPackagePrefaceName, FSmallProjName: string; overwrite: boolean);
var
  aux, strPackName, dest: string;
begin
  dest := FFullJavaSrcPath + DirectorySeparator + 'Controls.java';
  if overwrite or not FileExists(dest) then
  begin
    strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);
    ForceDirectories(ExtractFilePath(dest));
    //UNIQUE and now Refactored "Controls.java" !!!
    with TStringList.Create do
    begin
      LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'Controls.java');
      Strings[0] := 'package ' + strPackName + ';';  //replace dummy - Controls.java
      aux:=  StringReplace(Text, '/*libsmartload*/' ,
             'try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}',
             [rfReplaceAll,rfIgnoreCase]);
      Text:= aux;
      SaveToFile(dest);
      Free;
    end;
  end;
end;

procedure CreateJFormJava(FPathToJavaTemplates, FFullJavaSrcPath,
  FPackagePrefaceName, FSmallProjName: string; overwrite: boolean);
var
  dest, strPackName: string;
begin
  dest := FFullJavaSrcPath + DirectorySeparator + 'jForm.java';
  if overwrite or not FileExists(dest) then
  begin
    strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);
    //NEW GUI jForm Refactored from "Controls.java"
    with TStringList.Create do
    begin
      if FileExists(FPathToJavaTemplates + DirectorySeparator + 'jForm.java') then
      begin
        LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'jForm.java');
        Strings[0] := 'package ' + strPackName + ';';  //replace dummy
        ForceDirectories(ExtractFilePath(dest));
        SaveToFile(dest);
      end;
      Free;
    end;
  end;
end;

procedure CreateAppJava(FPathToJavaTemplates, FFullJavaSrcPath,
  FPackagePrefaceName, FSmallProjName, FAndroidTheme: string; overwrite: boolean
  );
var
  dest, strPackName: string;
begin
  dest := FFullJavaSrcPath + DirectorySeparator + 'App.java';
  if overwrite or not FileExists(dest) then
  begin
    strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

    with TStringList.Create do
    begin
      if (Pos('AppCompat', FAndroidTheme) > 0) then
      begin
         if FileExists(FPathToJavaTemplates + DirectorySeparator + 'support'+DirectorySeparator+'App.java') then
           LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'support'+DirectorySeparator+'App.java');
      end
      else
      begin
         if FileExists(FPathToJavaTemplates + DirectorySeparator + 'App.java') then
           LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'App.java');
      end;

      Strings[0] := 'package ' + strPackName + ';'; //replace dummy App.java
      SaveToFile(dest);
      Free;
    end;
  end;
end;

procedure CreateControlsNative(FAndroidProjectName, FPathToJavaTemplates: string;
  overwrite: boolean);
begin
  AltCopyFile(
    FPathToJavaTemplates+DirectorySeparator + 'Controls.native',
    FAndroidProjectName+DirectorySeparator+'lamwdesigner'+DirectorySeparator+'Controls.native',
    overwrite);
end;

procedure CreateJCommonsJava(FPathToJavaTemplates, FFullJavaSrcPath,
  FPackagePrefaceName, FSmallProjName, FAndroidTheme: string; overwrite: boolean
  );
var
  dest, strPackName: string;
begin
  dest := FFullJavaSrcPath + DirectorySeparator + 'jCommons.java';
  if overwrite or not FileExists(dest) then
  begin
    strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

    with TStringList.Create do
    begin
      if Pos('AppCompat', FAndroidTheme) > 0 then
      begin
        if FileExists(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jCommons.java') then
        begin
          LoadFromFile(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jCommons.java');
          Strings[0] := 'package ' + strPackName + ';';  //replace dummy
          SaveToFile(dest);
        end;
      end
      else
      begin
        if FileExists(FPathToJavaTemplates+DirectorySeparator+ 'jCommons.java') then
        begin
          LoadFromFile(FPathToJavaTemplates+DirectorySeparator+ 'jCommons.java');
          Strings[0] := 'package ' + strPackName + ';';  //replace dummy
          SaveToFile(dest);
        end;
      end;
      Free;
    end;
  end;
end;

procedure CreateAndroidManifestXML(FAndroidProjectName, FPathToJavaTemplates,
  FPackagePrefaceName, FSmallProjName, FMainActivity, FMinApi,
  FTargetApi: string; FSupport: boolean; overwrite: boolean);
var
  aFile, strPackName, strMainActivity, tempStr, insertRef, supportProvider: String;
  providerList: TStringList;
  p1: SizeInt;
begin
  if NeedFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml', overwrite, aFile) then
  begin
    strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);
    strList.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'androidmanifest.txt');

    tempStr  := StringReplace(strList.Text, 'dummyPackage',strPackName, [rfReplaceAll, rfIgnoreCase]);

    strMainActivity:= strPackName+'.'+FMainActivity; {gApp}

    tempStr  := StringReplace(tempStr, 'dummyAppName',strMainActivity, [rfReplaceAll, rfIgnoreCase]);

    tempStr  := StringReplace(tempStr, 'dummySdkApi', FMinApi, [rfReplaceAll, rfIgnoreCase]);
    tempStr  := StringReplace(tempStr, 'dummyTargetApi', FTargetApi, [rfReplaceAll, rfIgnoreCase]);

    strList.Text:= tempStr;

    if FSupport then
    begin
       if FileExists(FPathToJavaTemplates +DirectorySeparator +'support'+DirectorySeparator+'manifest_support_provider.txt') then
       begin
         providerList:= TStringList.Create;
         providerList.LoadFromFile(FPathToJavaTemplates +DirectorySeparator+'support'+DirectorySeparator+'manifest_support_provider.txt');
         supportProvider:= StringReplace(providerList.Text, 'dummyPackage',strPackName, [rfReplaceAll, rfIgnoreCase]);
         tempStr:= strList.Text;  //manifest
         if Pos('androidx.core.content.FileProvider', tempStr) <= 0 then    //androidX
         begin
           insertRef:= '</activity>'; //insert reference point
           p1:= Pos(insertRef, tempStr);
           Insert(sLineBreak + supportProvider, tempStr, p1+Length(insertRef));
           strList.Clear;
           strList.Text:= tempStr;
         end;
         providerList.Free;
       end;
    end;

    strList.SaveToFile(aFile);
  end;
end;

// searchs for an xml attribute in tempstr, if it's found it returns
// the attribute a string like 'attribute="value"', returns '' if it's not found.
function GetXMLAttributeString(tempStr: string; attribute:string): string;
var
  start, last: pchar;
begin
  result := '';

  if (Attribute='') or (tempStr='') then
    exit;

  // find "attribute"
  start := StrPos(@tempStr[1], @attribute[1]);
  if start=nil then
    exit;

  // find the first '"'
  last := StrPos(start, '"');
  if last=nil then
    exit;

  // find the next '"'
  last := StrPos(last+1, '"');
  if last=nil then
    exit;

  // copy the attribute string
  SetLength(result, last-start+1);
  Move(last^, result[1], last-start+1);
end;

procedure UpdateAndroidManifestXML(FAndroidProjectName, FAndroidTheme: string;
  FSupport: boolean; FMinApi, FTargetApi, DefApi: string;
  Checks: TUpdateManifestChecks);
var
  dest, tempStr, aux, manifestApis, insertRef: String;
  changed, checkAndroidX: Boolean;
  p1, p2: Integer;
  c: char;
begin
  PrepareStrList;

  dest := FAndroidProjectName+pathDelim+'AndroidManifest.xml';
  strList.LoadFromFile(dest);
  changed := false;

  // Update to androidX
  if umcUpdateAndroidX in Checks then
  begin
    if (FSupport) or (Pos('AppCompat', FAndroidTheme) > 0) then
    begin
      tempStr := strList.Text;
      if Pos('android.support.v4.content.FileProvider', tempStr) > 0 then //update to androidX
      begin
        tempStr:= StringReplace(tempStr, 'android.support.v4.content.FileProvider','androidx.core.content.FileProvider', [rfReplaceAll, rfIgnoreCase]);
        strList.Text:= tempStr;
        changed := true;
      end
    end;
  end;

  // MinApi, TargetApi, DefApi
  if umcMinApi in Checks then
  begin
    if FMinApi<>'' then begin
      tempStr:= strList.Text;  //manifest
      aux := GetXMLAttributeString(tempStr, 'android:minSdkVersion');
      if aux<>'' then
      begin
        tempStr:= StringReplace(tempStr, aux , 'android:minSdkVersion="'+FMinApi+'"', [rfReplaceAll,rfIgnoreCase]);
      end
      else //re-introduce it!
      begin
        manifestApis:= '<uses-sdk android:minSdkVersion="'+DefApi+'" android:targetSdkVersion="'+FtargetApi+'"/>';
        insertRef:= 'android:versionName='; //insert reference point
        p1:= Pos(insertRef, tempStr);
        p2:= p1 + Length(insertRef);
        c:= tempStr[p2];
        while c <> '>' do
        begin
          Inc(p2);
          c:= tempStr[p2];
        end;
        Inc(p2);
        insertRef:= Trim(Copy(tempStr, p1, p2-p1));
        p1:= Pos(insertRef, tempStr);
        Insert(sLineBreak + manifestApis, tempStr, p1+Length(insertRef) );
      end;
      strList.Text:= tempStr;
      changed := true;
    end;
  end;

  if umcAndroidExported in checks then
  begin
    //Apply to "smartdesigner.pas" improvement by LongDirtyAnimAlf in "AndroidWizard_intf"
    tempStr:= strList.Text;
    if Pos('android:exported="true"', tempStr) <= 0 then
    begin
     tempStr:= StringReplace(tempStr, 'android:enabled="true"' , 'android:enabled="true" android:exported="true"', [rfReplaceAll,rfIgnoreCase]);
     strList.Text:= tempStr;
     changed := true;
    end;
  end;

  if umcTargetApi in checks then
  begin
    if DefApi <> '' then
    begin
      tempStr:= strList.Text;
      tempStr:= StringReplace(tempStr, 'android:targetSdkVersion="'+DefApi+'"' , 'android:targetSdkVersion="'+FTargetApi+'"', [rfReplaceAll,rfIgnoreCase]);
      strList.Text:= tempStr;
      changed := true;
    end;
  end;

  if changed then
    strList.SaveToFile(dest);
end;

initialization
  strList := nil;

finalization
  strList.Free;

end.

