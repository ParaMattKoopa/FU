import cpp.Int64;

typedef Bool = Bool;
typedef UInt = UInt;
typedef Int = Int;
typedef Handle = Int64;
typedef Icon = Int64;
typedef Instance = Int64;
typedef Guid = {data: Array<Int>};
typedef NotifyIconData = {
  cbSize: UInt,
  hWnd: Handle,
  uID: UInt,
  uFlags: UInt,
  uCallbackMessage: UInt,
  hIcon: Icon,
  szTip: String,
  dwState: UInt,
  dwStateMask: UInt,
  szInfo: String,
  uTimeout: UInt,
  szInfoTitle: String,
  dwInfoFlags: UInt,
  guidItem: Guid,
  hBalloonIcon: Icon
};

@:native("Shell_NotifyIconA")
extern function shellNotifyIconA(dwMessage: Int, lpData: NotifyIconData): Bool;

@:native("LoadIconA")
extern function loadIconA(hInstance: Instance, iconCode: Icon): Icon;

@:native("DestroyIcon")
extern function destroyIcon(hIcon: Icon): Bool;

@:native("GetConsoleWindow")
extern function getConsoleWindow(): Handle;

class Main {
  static function main() {
    var trayIconCode: Icon = 32512; // Information
    var balloonIconCode: Icon = 32512; // Shield

    var trayIconHandle: Icon = loadIconA(0, trayIconCode);
    var balloonIconHandle: Icon = loadIconA(0, balloonIconCode);

    var notifyIconData: NotifyIconData = {
      cbSize: sizeof(NotifyIconData),
      hWnd: getConsoleWindow(),
      uFlags: 1 + 2, // NIF_MESSAGE | NIF_ICON
      hIcon: trayIconHandle,
      uVersion: 4,
      hBalloonIcon: balloonIconHandle
    };

    shellNotifyIconA(0, notifyIconData); // NIM_ADD
    shellNotifyIconA(4, notifyIconData); // NIM_SETVERSION

    trace("Tray icon added. Press Enter to continue...");
    Sys.stdin().readLine();

    function copyString(destArrayPtr: String, str: String): Void {
      var size: Int = sizeof(destArrayPtr) - 1;
      destArrayPtr = str.substring(0, size);
    }

    function showNotification(text: String, title: String): Void {
      notifyIconData.uFlags = 1 + 2 + 16; // NIF_MESSAGE | NIF_ICON | NIF_INFO
      notifyIconData.dwInfoFlags = 4 + 32; // NIIF_USER | NIIF_LARGE_ICON
      copyString(notifyIconData.szInfoTitle, title);
      copyString(notifyIconData.szInfo, text);
      shellNotifyIconA(1, notifyIconData); // NIM_MODIFY
    }
    while () {
    showNotification("hey", "JoshBot (V1)");
    Sys.stdin().readLine();
    }
  }
}

