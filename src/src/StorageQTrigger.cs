using System;
using System.Net.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Company.Function
{
    public class StorageQTrigger
    {
        [FunctionName("StorageQTrigger")]
        public void Run([QueueTrigger("testq1", Connection = "AzureWebJobsStorage")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
            // throw new InvalidOperationException("ERRRRRRRRROOOOOOORRRRR");
            HttpClient newClient = new HttpClient();
            HttpRequestMessage newRequest = new HttpRequestMessage(HttpMethod.Get, string.Format("https://example.com/"));
            HttpResponseMessage response = newClient.Send(newRequest);
            log.LogInformation($"HTTP Response: {response}");
            log.LogInformation("Complete");
            
        }
    }
}
