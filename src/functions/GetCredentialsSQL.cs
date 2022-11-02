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
using Microsoft.Azure.WebJobs.Extensions.Sql;
using System.Linq;

namespace Company.Function
{
    public static class GetCredentialsSQL
    {
        [FunctionName("GetCredentialsSQL")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "GetCredentialsSQL/{username}")] HttpRequest req,
            ILogger log, [Sql("select username, credentials from basicauthtable1 where username = @username",
                CommandType = System.Data.CommandType.Text,
                Parameters = "@username={username}",
                ConnectionStringSetting = "SqlConnectionString")]
            IEnumerable<Username> usernames)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            
            return new OkObjectResult(usernames.FirstOrDefault());
        }
    }
}
