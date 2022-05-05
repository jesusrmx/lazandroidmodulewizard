unit ulamwprocs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LamwSettings;

var
  ShowMessageProc: procedure(msg:string);


  function TryUndoFakeVersion(grVer: string): string;

  // GRADLE
  procedure CreateGradleProperties(const FAndroidProjectName, FAndroidTheme, FPathToJavaJDK : string; overwrite:boolean=true);
  procedure CreateLocalProperties(const FAndroidProjectName, FPathToAndroidSDK, FPathToAndroidNDK: string; overwrite:boolean=true);
  procedure CreateBuildGradle(
      FAndroidProjectName: string;
      androidPluginNumber: Integer;
      FAndroidTheme: string;
      pluginVersion: string;
      instructionChip: string;
      compileSdkVersion: string;
      sdkBuildTools: string;
      FMinApi, FTargetApi: string;
      FVersionCode:Integer;
      FVersionName:string;
      FSupport: boolean;
      FPackagePrefaceName: string;
      FSmallProjName: string;
      gradleCompatibleAsNumber: Integer;
      gradleCompatible: string;
      overwrite: boolean = true
    );
  procedure CreateGradleReadme(FAndroidProjectName, FPathToGradle, FPathToAndroidSDK: string; overwrite:boolean=true);
  // ANT

implementation

var
  strList: TStringList;

function TryUndoFakeVersion(grVer: string): string;
begin
  Result:=  grVer;
  if grVer = '4.9.1' then Result:= '4.10'
  else if grVer = '4.9.2' then Result:= '4.10.1'
  else if grVer = '4.9.3' then Result:= '4.10.2'
  else if grVer = '4.9.4' then Result:= '4.10.3';
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
  aFile: string;
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

procedure CreateBuildGradle(FAndroidProjectName: string;
  androidPluginNumber: Integer; FAndroidTheme: string; pluginVersion: string;
  instructionChip: string; compileSdkVersion: string; sdkBuildTools: string;
  FMinApi, FTargetApi: string; FVersionCode: Integer; FVersionName: string;
  FSupport: boolean; FPackagePrefaceName: string; FSmallProjName: string;
  gradleCompatibleAsNumber: Integer; gradleCompatible: string;
  overwrite: boolean);
var
  directive, strPack, aFile: String;
  innerSupported: Boolean;
  aAppCompatLib:TAppCompatLib;
  aSupportLib: TSupportLib;
begin
  if NeedFile(FAndroidProjectName+PathDelim+'build.gradle', overwrite, aFile) then
  begin

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
             ShowMessageProc('Warning: AppCompat theme need Android SDK >= ' +
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
           ShowMessageProc('Warning: Support library need Android SDK >= ' +
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

initialization
  strList := nil;

finalization
  strList.Free;

end.

