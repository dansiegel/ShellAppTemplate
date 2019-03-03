using MyProject.Tests.Mocks;
using MyProject.Tests.Mocks.Logging;
using Prism.Navigation;
using System.Linq;
using Xamarin.Forms.Internals;
using Xunit;
using Xunit.Abstractions;

namespace MyProject.Tests.Tests
{
    public class AppFixture
    {
        private ITestOutputHelper _testOutputHelper;

        public AppFixture(ITestOutputHelper testOutputHelper)
        {
            Xamarin.Forms.Mocks.MockForms.Init();
        }

        public void UpdateTestOutputHelper(ITestOutputHelper testOutputHelper)
        {
            _testOutputHelper = testOutputHelper;
        }

        public XunitApp CreateApp()
        {
            PageNavigationRegistry.ClearRegistrationCache();
            var initializer = new XunitPlatformInitializer(_testOutputHelper);
            return new XunitApp(initializer);
        }
    }

    [CollectionDefinition("App collection")]
    public class AppCollection : ICollectionFixture<AppFixture>
    {

    }
}
