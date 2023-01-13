using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

namespace KaizenCaseStudy.Question_2
{
    public class ReceiptDescriptionModel
    {
        [JsonProperty("description")]
        public string Description { get; set; }
        [JsonProperty("boundingPoly")]
        public BoundingPolyModel BoundingPoly { get; set; }

        public class BoundingPolyModel
        {
            [JsonProperty("vertices")]
            public List<Vertice> Vertices { get; set; }

            public Vertice TopLeft { get { return Vertices != null && Vertices.Any() ? Vertices[0] : null; } }
            public Vertice TopRight { get { return Vertices != null && Vertices.Any() ? Vertices[1] : null; } }
            public Vertice BottomRight { get { return Vertices != null && Vertices.Any() ? Vertices[2] : null; } }
            public Vertice BottomLeft { get { return Vertices != null && Vertices.Any() ? Vertices[3] : null; } }
        }

        public class Vertice
        {
            [JsonProperty("x")]
            public int X { get; set; }
            [JsonProperty("y")]
            public int Y { get; set; }
        }
    }
}
