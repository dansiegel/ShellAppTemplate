using DryIoc;
using MyProject.Tests.Mocks.Logging;
using Prism;
using Prism.DryIoc;
using Prism.Ioc;
using Prism.Modularity;
using System.Collections.Generic;

namespace MyProject.Tests.Mocks
{
    public class XunitApp : ShellApp.App
    {
        public XunitApp(IPlatformInitializer initializer) : base(initializer)
        {
        }

        protected override void RegisterTypes(IContainerRegistry containerRegistry)
        {
            base.RegisterTypes(containerRegistry);
            containerRegistry.GetContainer().RegisterMany<XunitLogger>(Reuse.Singleton,
                serviceTypeCondition: t => typeof(XunitLogger).ImplementsServiceType(t));
        }

        private List<LoadModuleCompletedEventArgs> _moduleLoadEvents = new List<LoadModuleCompletedEventArgs>();
        public IReadOnlyList<LoadModuleCompletedEventArgs> ModuleLoadEvents => _moduleLoadEvents;

        protected override void OnLoadModuleCompleted(object sender, LoadModuleCompletedEventArgs e)
        {
            base.OnLoadModuleCompleted(sender, e);
            _moduleLoadEvents.Add(e);
        }
    }
}
