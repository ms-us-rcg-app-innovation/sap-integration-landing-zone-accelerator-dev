using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
// using System.Linq;
// using Microsoft.ApplicationInsights;
// using Microsoft.ApplicationInsights.DataContracts;
// using Microsoft.ApplicationInsights.Extensibility;
// using System.Collections.Generic;
using Azure.Messaging.ServiceBus;

namespace Company.Function
{
    public class StoreInSBQ2
    {
        // private readonly TelemetryClient telemetryClient;

        /// Using dependency injection will guarantee that you use the same configuration for telemetry collected automatically and manually.
        // public StoreInSBQ(TelemetryConfiguration telemetryConfiguration)
        // {
        //     this.telemetryClient = new TelemetryClient(telemetryConfiguration);
        // }
        [FunctionName("StoreInSBQ2")]

        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req, ILogger log,
            [ServiceBus("q1", Connection = "ServiceBusConnection")] IAsyncCollector<ServiceBusMessage> collector)
        {
            // log.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            ServiceBusMessage message = new ServiceBusMessage(requestBody);

            // var headers = req.Headers;
            // var aaamytrackingid = headers.FirstOrDefault(x => x.Key == "aaamytrackingid").Value.ToString();
            // message.ApplicationProperties.Add("aaamytrackingid", aaamytrackingid);
            // message.ApplicationProperties.Add("prop1", "val1");
            // message.ApplicationProperties.Add("prop2", "val2");


            await collector.AddAsync(message); // This will store the message and set properties based on message.ApplicationProperties above

            // this.telemetryClient.TrackTrace("Message Was Processed By Function StoreInSBQ", SeverityLevel.Information, new Dictionary<string, string> { { "aaamytrackingid", aaamytrackingid } });

            return new OkObjectResult("Message Sent To Queue");

        }
    }
}

