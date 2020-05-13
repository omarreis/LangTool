unit omNativeLanguage;  // by oMAR may20
// Cross platdform native language OS setting (Windows, iOS and Android)  TODO: MacOS
interface

var     // NativeLanguage is set at initialization
  NativeLanguage:String='';    // like 'pt-BR' ou 'en-US'

implementation //-----------------------------------------------------

uses
  {$IFDEF Android}
  FMX.Platform,    //Om: plat services
  Androidapi.JNIBridge,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes;
  {$ENDIF Android}

  {$IFDEF IOS}
  iOSapi.Foundation,
  iOSapi.AVFoundation,
  Macapi.Helpers;
  {$ENDIF IOS}

  {$IFDEF MSWINDOWS}
  Winapi.Windows;
  {$ENDIF MSWINDOWS}


// Android ---------------------------------------------------------
{$IFDEF Android}
function getDeviceCountryCode:String;  //platform specific get country code
var Locale: JLocale;
begin
  Result:='??';
  Locale := TJLocale.JavaClass.getDefault;
  Result := JStringToString( Locale.getCountry );
  if Length(Result) > 2 then Delete(Result, 3, MaxInt);
end;

function getOSLanguage:String;
var LocServ: IFMXLocaleService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, IInterface(LocServ)) then
    Result := LocServ.GetCurrentLangID        // 2 letter code, but a different one ????   instead of 'pt' it gives 'po'
    else Result := '??';
    // if set Japanese on Android, LocaleService returns "jp", but other platform returns "ja"
    // so I think it is better to change "jp" to "ja"
    if      (Result = 'jp') then Result := 'ja'
    else if (Result = 'po') then Result := 'pt';
end;

procedure getNativeLanguage;  // Android
begin
  NativeLanguage := getOSLanguage+'-'+getDeviceCountryCode;   // 'pt-BR'
end;
{$ENDIF Android}

// iOS--------------------------------------------------------------
{$IFDEF IOS}
function getOSLanguage:String;         //default language 'es-ES' 'en-US' 'pt-BR' ..
var
  Languages: NSArray;
begin
  Languages := TNSLocale.OCClass.preferredLanguages;
  Result    := TNSString.Wrap(Languages.objectAtIndex(0)).UTF8String;
end;

procedure getNativeLanguage;
begin
  NativeLanguage := getOSLanguage; // 'pt-BR'
end;

{$ENDIF IOS}

// Windows -------------------------------------------
{$IFDEF MSWINDOWS}

// from https://stackoverflow.com/questions/19369809/delphi-get-country-codes-by-localeid/37981772#37981772
function LCIDToLocaleName(Locale: LCID; lpName: LPWSTR; cchName: Integer;
  dwFlags: DWORD): Integer; stdcall;external kernel32 name 'LCIDToLocaleName';


function LocaleIDString():string;
var
   strNameBuffer : array [0..255] of WideChar; // 84 was len from original process online
   //localID : TLocaleID;
   // localID was 0, so didn't initialize, but still returned proper code page.
   // using 0 in lieu of localID : nets the same result, var not required.
   i : integer;
begin
  Result := '';

  // LOCALE_USER_DEFAULT  vs. LOCALE_SYSTEM_DEFAULT
  // since XP LOCALE_USER_DEFAULT is considered good practice for compatibility
  if (LCIDToLocaleName(LOCALE_USER_DEFAULT, strNameBuffer, 255, 0) > 0) then
    for i := 0 to 255 do
     begin
      if strNameBuffer[i] = #0 then  break
      else Result := Result + strNameBuffer[i];
    end;

  if (Length(Result) = 0) and (LCIDToLocaleName(0, strNameBuffer, 255, 0) > 0) then
   for i := 0 to 255 do
     begin
      if strNameBuffer[i] = #0 then break
      else Result := Result + strNameBuffer[i];
    end;

  if Length(Result) = 0 then
    Result := 'NR-NR' // defaulting to [No Reply - No Reply]
end;

procedure getNativeLanguage;
begin
  NativeLanguage := LocaleIDString; // 'pt-BR'
end;

{$ENDIF MSWINDOWS}

initialization
  getNativeLanguage;     // get OS native language-country
end.

