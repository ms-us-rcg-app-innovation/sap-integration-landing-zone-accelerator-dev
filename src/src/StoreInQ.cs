using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
 
namespace Company.Function
{
public static class StoreInQ
{
[FunctionName("StoreInQ")]
public static async Task<IActionResult> Run(
    [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req, 
    [Queue("testq1"),StorageAccount("AzureWebJobsStorage")] ICollector<string> msg, 
    ILogger log)
{
    log.LogInformation("C# HTTP trigger function processed a request.");

    string requestBody = await new StreamReader(req.Body).ReadToEndAsync();

    msg.Add(requestBody);
    
    return new OkObjectResult("Message Sent To Queue");
        
}
}
}
