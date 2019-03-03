using Prism.Logging.Syslog;

namespace ShellApp.Helpers
{
    public class SyslogOptions : ISyslogOptions
    {
        public string HostNameOrIp => Secrets.Host;
        public int? Port => Secrets.Port;
        public string AppNameOrTag => Secrets.AppName;
    }
}
