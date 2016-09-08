unit ImgCache;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, AvgLvlTree, Graphics, FPimage;

type

  { TImageCacheItem }

  TImageCacheItem = class
  private
    FFileName: string;
    FImg: TFPCustomImage;
    FPng: TPortableNetworkGraphic;
    FImgFileSize: QWord;
    FImgFileTime: LongInt;
    function GetImage: TFPCustomImage;
    function CheckAttribs: Boolean;
    function GetPNG: TPortableNetworkGraphic;
    procedure LoadImage;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    property Img: TFPCustomImage read GetImage;
    property PNG: TPortableNetworkGraphic read GetPNG;
  end;

  TImageCache = class
  private
    FItems: TAvgLvlTree; // list of TImageCacheItem
  public
    constructor Create;
    destructor Destroy; override;
    function GetImage(const FileName: string): TFPCustomImage;
    function GetImageAsPNG(const FileName: string): TPortableNetworkGraphic;
  end;

implementation

uses FPWritePNG;

function CmpImgCacheItems(p1, p2: Pointer): Integer;
begin
  Result := CompareText(TImageCacheItem(p1).FFileName, TImageCacheItem(p2).FFileName)
end;

function FindImgCacheItem(p1, p2: Pointer): Integer;
begin
  Result := CompareText(PString(p1)^, TImageCacheItem(p2).FFileName)
end;

{ TImageCache }

constructor TImageCache.Create;
begin
  FItems := TAvgLvlTree.Create(@CmpImgCacheItems);
end;

destructor TImageCache.Destroy;
begin
  FItems.FreeAndClear;
  FItems.Free;
  inherited Destroy;
end;

function TImageCache.GetImage(const FileName: string): TFPCustomImage;
var
  n: TAvgLvlTreeNode;
  ci: TImageCacheItem;
begin
  n := FItems.FindKey(@FileName, @FindImgCacheItem);
  if Assigned(n) then
    ci := TImageCacheItem(n.Data)
  else
    ci := TImageCacheItem.Create(FileName);
  Result := ci.Img;
end;

function TImageCache.GetImageAsPNG(const FileName: string): TPortableNetworkGraphic;
var
  n: TAvgLvlTreeNode;
  ci: TImageCacheItem;
begin
  n := FItems.FindKey(@FileName, @FindImgCacheItem);
  if Assigned(n) then
    ci := TImageCacheItem(n.Data)
  else begin
    ci := TImageCacheItem.Create(FileName);
    FItems.Add(ci);
  end;
  Result := ci.PNG;
end;

{ TImageCacheItem }

function TImageCacheItem.GetImage: TFPCustomImage;
begin
  if not FileExists(FFileName) and Assigned(Fimg) then
  begin
    FreeAndNil(FImg);
    FreeAndNil(FPng);
  end else
  if not CheckAttribs then LoadImage;
  Result := FImg
end;

function TImageCacheItem.CheckAttribs: Boolean;
var
  sr: TRawByteSearchRec;
begin
  FindFirst(FFileName, faAnyFile, sr);
  Result := (FImgFileSize = sr.Size) and (FImgFileTime = sr.Time);
  FindClose(sr);
end;

function TImageCacheItem.GetPNG: TPortableNetworkGraphic;
var
  im: TFPCustomImage;
  pngW: TFPWriterPNG;
  ms: TMemoryStream;
begin
  im := GetImage;
  if Assigned(FPng) then Exit(FPng);
  if Assigned(im) then
  begin
    pngW := TFPWriterPNG.Create;
    ms := TMemoryStream.Create;
    im.SaveToStream(ms, pngW);
    pngW.Free;
    ms.Position := 0;
    FPng := TPortableNetworkGraphic.Create;
    FPng.LoadFromStream(ms);
    ms.Free;
  end;
  Result := FPng;
end;

procedure TImageCacheItem.LoadImage;
var
  sr: TRawByteSearchRec;
begin
  if Assigned(FImg) then
  begin
    FreeAndNil(FImg);
    FreeAndNil(FPng);
  end;
  Fimg := TFPMemoryImage.Create(0, 0);
  try
    FImg.LoadFromFile(FFileName);
    FindFirst(FFileName, faAnyFile, sr);
    FImgFileSize := sr.Size;
    FImgFileTime := sr.Time;
    FindClose(sr);
  except
    FreeAndNil(FImg)
  end;
end;

constructor TImageCacheItem.Create(const AFileName: string);
begin
  FFileName := AFileName;
  if FileExists(FFileName) then
    LoadImage;
end;

destructor TImageCacheItem.Destroy;
begin
  FImg.Free;
  FPng.Free;
  inherited Destroy;
end;

end.
