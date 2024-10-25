using System;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using Azure.Maps.Search.Models;
using Azure.Maps.Search;
using Azure;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Microsoft.ProximityMap.API.Models;
using Newtonsoft.Json;
using Azure.Core.GeoJson;

namespace Microsoft.ProximityMap.API
{
    public class ProximityRequest
    {
        private readonly ILogger<ProximityRequest> _logger;

        public ProximityRequest(ILogger<ProximityRequest> log)
        {
            _logger = log;
        }

        [FunctionName("ConvertAddressToCoordinates")]
        [OpenApiOperation(operationId: "ConvertAddressToCoordinates", tags: new[] { "name" })]
        [OpenApiSecurity("function_key", SecuritySchemeType.ApiKey, Name = "code", In = OpenApiSecurityLocationType.Query)]
        [OpenApiRequestBody(contentType: "application/json", bodyType: typeof(ProximityAddress), Required = true, Description = "The Address is required")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(ProximityAddress), Description = "The OK response")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.BadRequest, contentType: "application/json", bodyType: typeof(Exception), Description = "The Bad Request response")]
        public async Task<IActionResult> ConvertAddressToCoordinates([HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            var proximityAddress = JsonConvert.DeserializeObject<ProximityAddress>(requestBody);

            if (proximityAddress is null)
                return new BadRequestObjectResult(new Exception("No Address Provided"));

            var coordinates = getCoordinates(proximityAddress.Address);

            proximityAddress.Lat = coordinates.Latitude;
            proximityAddress.Long = coordinates.Longitude;

            return new OkObjectResult(proximityAddress);
        }

        private GeoPosition getCoordinates(string address)
        {
            var subscriptionKey = Environment.GetEnvironmentVariable("SUBSCRIPTION_KEY") ?? string.Empty;
            var credential = new AzureKeyCredential(subscriptionKey);
            var client = new MapsSearchClient(credential);

            Response<GeocodingResponse> searchResult = client.GetGeocoding(address);

            if (searchResult.Value.Features.Count == 0)
                throw new Exception("No Coordinates for address");

            return searchResult.Value.Features[0].Geometry.Coordinates;
                            
        }

    }
}