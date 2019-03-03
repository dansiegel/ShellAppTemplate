using Prism;
using Prism.Ioc;
using Xunit.Abstractions;

namespace MyProject.Tests.Mocks
{
    public class XunitPlatformInitializer : IPlatformInitializer
    {
        private ITestOutputHelper _testOutputHelper { get; }

        public XunitPlatformInitializer(ITestOutputHelper testOutputHelper)
        {
            _testOutputHelper = testOutputHelper;
        }

        public void RegisterTypes(IContainerRegistry containerRegistry)
        {
            containerRegistry.RegisterInstance(_testOutputHelper);
        }
    }
}
