using Microsoft.PowerPlatform.Dataverse.Client;

namespace PowerPlatform.Utils
{
    public class ConnectionPool
    {
        private readonly ServiceClient[] _connections;

        public ConnectionPool(ServiceClient[] connections) { _connections = connections; }

        public ServiceClient GetConnection(int i)
        {
            return _connections[Math.Abs(i) % _connections.Length];
        }

        public int Size { get { return _connections.Length; } }
    }
}
