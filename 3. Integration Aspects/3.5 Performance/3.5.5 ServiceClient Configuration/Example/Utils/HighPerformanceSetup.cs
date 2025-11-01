namespace PowerPlatform.Utils
{
    public class HighPerformanceSetup
    {
        public static void Init(int workerThreads=50, int completionPorts=50,int defaultConnectionLimit=32000,bool expect100Continue=false,bool useNagleAlgorithm=false)
        {
            // Zwiększ minimalną liczbę wątków zarezerwowanych dla tej aplikacji, aby szybciej zestawiać połączenia domyślne wartości minWorkerThreads to 4, minIOCP to 4
            ThreadPool.SetMinThreads(workerThreads, completionPorts);


            // Zmień domyślną maksymalną liczbę połączeń .NET do zdalnej usługi: z 2 do 32000
            System.Net.ServicePointManager.DefaultConnectionLimit = defaultConnectionLimit;


            // Wyłącz komunikat "Expect 100 Continue" – wartość 'true' powoduje, że wywołujący czeka
            // aż połączenie z serwerem zostanie potwierdzone rundą żądań i odpowiedzi
            System.Net.ServicePointManager.Expect100Continue = expect100Continue;


            // Może zmniejszyć ogólny narzut transmisji, ale może powodować opóźnienia w dostarczaniu
            // pakietów danych
            System.Net.ServicePointManager.UseNagleAlgorithm = useNagleAlgorithm;
        }
    }
}
