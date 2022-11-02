using System;
using System.Threading;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Company.Function
{

    public class StorageQTriggerError
    {
        private int retryCount = 3;
        private readonly TimeSpan delay = TimeSpan.FromSeconds(5);
        
        [FunctionName("StorageQTriggerError")]
        public void Run([QueueTrigger("testq1", Connection = "AzureWebJobsStorage")] string myQueueItem, ILogger log)
        {
            int currentRetry = 0;
            for (;;)
            {
                try
                {
                    // Perform operation. EX: Call external service (SAP).
                    log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
                    throw new InvalidOperationException("ERRRRRRRRROOOOOOORRRRR");
                    // Return or break.
                }
                catch (Exception ex)
                {
                    currentRetry++;

                    // based on the logic in the error detection strategy.
                    // Determine whether to retry the operation, as well as how
                    // long to wait, based on the retry strategy.
                    if (currentRetry > this.retryCount)
                    {
                        // If this isn't a transient error or we shouldn't retry,
                        // rethrow the exception.
                        throw new InvalidOperationException("ERRRRRRRRROOOOOOORRRRR");
                    }
                }

                // Wait to retry the operation.
                // Consider calculating an exponential delay here and
                // using a strategy best suited for the operation and fault.
                Thread.Sleep(delay);
                log.LogInformation($"C# Delay Is: {delay}");
            }
        }
    }
}
