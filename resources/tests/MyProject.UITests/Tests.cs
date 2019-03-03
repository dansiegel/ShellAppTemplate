using System;
using System.IO;
using System.Linq;
using MyProject.UITests.Pages;
using NUnit.Framework;
using Xamarin.UITest;
using Xamarin.UITest.Queries;

namespace MyProject.UITests
{
    public class Tests : BaseTestFixture
    {
        public Tests(Platform platform)
            : base(platform)
        {
        }

        [Test]
        public void WelcomeTextIsDisplayed()
        {
            new MainPage();
        }
    }
}
