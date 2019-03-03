using System;
using Xamarin.UITest.Utils;

namespace MyProject.UITests
{
    public class WaitTimes : IWaitTimes
    {
        public TimeSpan GestureCompletionTimeout => TimeSpan.FromMinutes(1);

        public TimeSpan GestureWaitTimeout => TimeSpan.FromMinutes(1);

        public TimeSpan WaitForTimeout => TimeSpan.FromMinutes(1);
    }
}
