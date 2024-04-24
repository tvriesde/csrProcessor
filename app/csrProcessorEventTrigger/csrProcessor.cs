// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}

using System;
using Azure.Messaging;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;


namespace csrProcessorEventTrigger
{
    public class csrProcessor
    {
        private readonly ILogger<csrProcessor> _logger;

        public csrProcessor(ILogger<csrProcessor> logger)
        {
            _logger = logger;
        }

        [Function(nameof(csrProcessor))]
        public void Run([EventGridTrigger] CloudEvent cloudEvent, ILogger log)
        {
            _logger.LogInformation("Event type: {type}, Event subject: {subject}", cloudEvent.Type, cloudEvent.Subject);
        }
    }
}
