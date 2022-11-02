using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace Company.Function
{
    public static class GetCredentialsHardcoded
    {
        [FunctionName("GetCredentialsHardcoded")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
          
            string name = req.Query["username"];

            List<Username> _username = new List<Username>
            {
                new Username { username = "user1@1234x.com", credentials = "a2FybDpwYXNzd29yZA=="},
                new Username { username = "user2@1234x.com", credentials = "a2FybDpwYXNzd29yZA=="},
                new Username { username = "user3@1234x.com", credentials = "a2FybDpwYXNzd29yZA=="},
                new Username { username = "user4@1234x.com", credentials = "a2FybDpwYXNzd29yZA=="},
                new Username { username = "user5@1234x.com", credentials = "quicktest"}
            };
        
            return new OkObjectResult(JsonConvert.SerializeObject(_username.Find(x=>x.username==name)));
        }
    }
}
