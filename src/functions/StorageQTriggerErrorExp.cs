using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Company.Function
{
    public class StorageQTriggerExp
    {
        [FunctionName("StorageQTriggerExp")]
        // [ExponentialBackoffRetry(6, "00:00:01", "00:00:10")]
        public void Run([QueueTrigger("testq1", Connection = "AzureWebJobsStorage")]string myQueueItem, DateTimeOffset nextVisibleTime,ILogger log)
        {
            log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
            log.LogInformation($"C# Queue trigger function processed: {nextVisibleTime}");
            throw new InvalidOperationException("ERRRRRRRRROOOOOOORRRRR");
        }
    }
}
