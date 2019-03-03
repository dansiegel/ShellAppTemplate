using Prism.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using Xunit.Abstractions;

namespace MyProject.Tests.Mocks.Logging
{
    public class XunitLogger : ILogger
    {
        private ITestOutputHelper _testOutputHelper { get; }

        public XunitLogger(ITestOutputHelper testOutputHelper)
        {
            _testOutputHelper = testOutputHelper;
        }

        public void Log(string message, IDictionary<string, string> properties)
        {
            _testOutputHelper.WriteLine(message);

            if(properties?.Any() ?? false)
            {
                foreach(var prop in properties)
                {
                    _testOutputHelper.WriteLine($"    {prop.Key}: {prop.Value}");
                }
            }
        }

        public void Report(Exception ex, IDictionary<string, string> properties) =>
            Log(ex.ToString(), properties);

        public void Log(string message, Category category, Priority priority) =>
            _testOutputHelper.WriteLine($"{category} - {priority}: {message}");

        public void TrackEvent(string name, IDictionary<string, string> properties) =>
            Log(name, properties);
    }
}
