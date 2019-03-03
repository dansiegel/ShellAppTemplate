using System;
using Xamarin.UITest;

namespace MyProject.UITests
{
    static class AppManager
    {
        static IApp app;

        public static IApp App
        {
            get
            {
                if (app == null)
                    throw new NullReferenceException("'AppManager.App' not set. Call 'AppManager.StartApp()' before trying to access it.");
                return app;
            }
        }

        static Platform? platform;

        public static Platform Platform
        {
            get
            {
                if (platform == null)
                    throw new NullReferenceException("'AppManager.Platform' not set.");
                return platform.Value;
            }

            set
            {
                platform = value;
            }
        }

        public static void StartApp()
        {
            if (Platform == Platform.Android)
            {
                app = ConfigureApp
                    .Android
                    .WaitTimes(new WaitTimes())
                    // Used to run a .apk file:
                    .ApkFile("../../../shell/ShellApp.Android/bin/UITest/com.avantipoint.myproject.apk")
                    .StartApp();
            }

            if (Platform == Platform.iOS)
            {
                app = ConfigureApp
                    .iOS
                    .WaitTimes(new WaitTimes())
                    // Used to run a .app file on an ios simulator:
                    //.AppBundle("path/to/file.app")
                    // Used to run a .ipa file on a physical ios device:
                    .InstalledApp("com.avantipoint.myproject")
                    .StartApp();
            }
        }
    }
}
