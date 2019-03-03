using Prism.Modularity;
using Xunit;
using Xunit.Abstractions;

namespace MyProject.Tests.Tests
{
    [Collection("App collection")]
    public class ModuleTests
    {
        private AppFixture _fixture { get; }
        public ModuleTests(ITestOutputHelper testOutputHelper, AppFixture appFixture)
        {
            appFixture.UpdateTestOutputHelper(testOutputHelper);
            _fixture = appFixture;
        }

        [Fact]
        public void ModuleIsLoaded()
        {
            var app = _fixture.CreateApp();
            Assert.Single(app.ModuleLoadEvents);
            var loadEvent = app.ModuleLoadEvents[0];
            Assert.Equal(ModuleState.Initialized, loadEvent.ModuleInfo.State);
        }

        [Fact]
        public void ModuleDidNotThrowInitializationException()
        {
            var app = _fixture.CreateApp();
            Assert.Single(app.ModuleLoadEvents);
            var loadEvent = app.ModuleLoadEvents[0];
            Assert.Null(loadEvent.Error);
        }
    }
}
