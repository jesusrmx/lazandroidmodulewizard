unit ulamwprocs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Controls, Dialogs, LamwSettings;

type
  // TheThing holds all variables produced by TfrmWorkSpace
  // Does all what TAndroidXXXProjectDescriptor do but can be reused in other
  // parts of LAMW
  TheThing = class
  end;

  function IsAllCharNumber(pcString: PChar): Boolean;
  function GetVerAsNumber(aVers: string): integer;

  function TryUndoFakeVersion(grVer: string): string;
  function TryGradleCompatibility(plugin: string; gradleVers: string; out outGradleVer: string) : boolean;
  function TryPluginCompatibility(gradleVers: string): string;
  function GetPathToJNIFolder(fullPath: string): string;
  function GetAppName(className: string): string;
  function GetFolderFromApi(api: integer): string;
  function GetPluginVersion(buildTool: string): string;

  function GetBuildTool(FPathToAndroidSDK: string; sdkApi: integer; out FCandidateSdkBuild:string): string;
  function HasBuildTools(FPathToAndroidSDK: string; platform: integer;  out outBuildTool,FCandidateSdkBuild: string): boolean;


  // GRADLE
  procedure CreateGradleProperties(const FAndroidProjectName, FAndroidTheme, FPathToJavaJDK : string; overwrite:boolean=true);
  procedure CreateLocalProperties(const FAndroidProjectName, FPathToAndroidSDK, FPathToAndroidNDK: string; overwrite:boolean=true);

  function CreateBuildGradle(FAndroidProjectName: string; FPathToAndroidSDK: string; FMaxSDKPlatform: Integer;
    FGradleVersion:string; FAndroidTheme: string; instructionChip: string; FMinApi, FTargetApi: string;
    FVersionCode: Integer; FVersionName: string; FSupport: boolean; FPackagePrefaceName: string; FSmallProjName: string;
    overwrite: boolean = true): boolean;

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

  // ANT

implementation

{$ifdef unix}
uses
  BaseUnix;
{$endif}

var
  strList: TStringList;

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

  numberAsString:= StringReplace(buildTool,'.', '', [rfReplaceAll]); //25.0.3
  maxBuilderNumber:= StrToInt(Trim(numberAsString));  //2503

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
      //Result:= '3.2.0';   //need build-tools 28.0.2 and need drop minSdk/targetSdk from AndroidManifest!!
      //gradleVer:= '4.6';

       Result:= '3.1.0'; //just to support minSdk/targetSdk in AndroidManifest!!
  end
  else if maxBuilderNumber >= 2803   then
  begin
      //Result:= '3.3.0';    //need droped minSdk/targetSdk in AndroidManifest!!
      //gradleVer:= 'Gradle 4.10.1';

      //Result:= '3.4.0';
      //gradleVer:= 'Gradle Gradle 5.1.1'

      Result:= '3.1.0'; //just to support minSdk/targetSdk in AndroidManifest!!
  end;

end;

function GetBuildTool(FPathToAndroidSDK: string; sdkApi: integer; out
  FCandidateSdkBuild: string): string;
var
  tempOutBuildTool: string;
begin
  Result:= '';
  if HasBuildTools(FPathToAndroidSDK, sdkApi, tempOutBuildTool, FCandidateSdkBuild) then
  begin
     Result:= tempOutBuildTool;  //25.0.3    //***
  end;
end;

function HasBuildTools(FPathToAndroidSDK: string; platform: integer; out outBuildTool,FCandidateSdkBuild: string): boolean;
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
  FPackagePrefaceName: string; FSmallProjName: string; overwrite: boolean
  ): boolean;
var
  compileSdkVersion: string;
  directive, strPack, aFile: String;
  innerSupported: Boolean;
  aAppCompatLib:TAppCompatLib;
  aSupportLib: TSupportLib;
  candidateSDKBuild: string;
  sdkBuildTools: string;
  pluginVersion: string;
  gradleCompatibleAsNumber: Integer;
  outgradleCompatible: string;
  gradleCompatible: string;
  androidPluginNumber: Integer;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'build.gradle', overwrite, aFile) then
  begin

    {%Region /fold Gradle Setup}
    compileSdkVersion:= IntToStr(FMaxSdkPlatform);
    sdkBuildTools:= GetBuildTool(FPathToAndroidSDK, FMaxSdkPlatform, candidateSDKBuild);

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

    if StrToInt(compileSdkVersion) > 25 then
      pluginVersion:= GetPluginVersion(sdkBuildTools)
    else
      pluginVersion:= '2.3.3';

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
    strList.Add('            include '''+instructionChip+'''');
      //strList.Add('            include ''x86'', ''x86_64'', ''armeabi'', ''armeabi-v7a'', ''mips'', ''mips64'', ''arm64-v8a''');
    strList.Add('            universalApk false');
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

initialization
  strList := nil;

finalization
  strList.Free;

end.

