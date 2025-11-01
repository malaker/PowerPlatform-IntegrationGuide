using Microsoft.Xrm.Sdk.Messages;
using Microsoft.Xrm.Sdk;

namespace PowerPlatform.Utils
{
    public class DataGenerator
    {
        private static List<TResult> Chunkify<TResult>(IList<Entity> entities, int chunkSize, Func<Entity[], TResult> mapFn)
        {
            var chunks = entities.Chunk(chunkSize).Select((chunk, idx) => mapFn(chunk)).ToList();
            return chunks;
        }

        public static List<CreateMultipleRequest> GenerateCreateMultipleRequest(int size, int chunkSize)
        {
            List<Entity> entities = new List<Entity>(size);

            for (var i = 0; i < size; i++)
            {
                var e = new Entity("account");
                e["name"] = Guid.NewGuid().ToString();
                entities.Add(e);
            }

            return Chunkify<CreateMultipleRequest>(entities, chunkSize, (en) =>
            {
                EntityCollection entityCollection = new(en) { EntityName = en[0].LogicalName };

                CreateMultipleRequest cmr = new CreateMultipleRequest() { Targets = entityCollection };

                return cmr;
            });
        }
    }
}
