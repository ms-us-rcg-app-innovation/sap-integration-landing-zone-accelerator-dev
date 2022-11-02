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
    public class StoreInSBQ
    {

        [FunctionName("StoreInSBQ")]

        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req, ILogger log,
            [ServiceBus("q1", Connection = "ServiceBusConnection")] IAsyncCollector<ServiceBusMessage> collector)
        {

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            ServiceBusMessage message = new ServiceBusMessage(requestBody);


            await collector.AddAsync(message); // This will store the message and set properties based on message.ApplicationProperties above

            return new OkObjectResult("Message Sent To Queue");

        }
    }
}

