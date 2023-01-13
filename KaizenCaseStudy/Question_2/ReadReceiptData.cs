using Newtonsoft.Json;
using SkiaSharp;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using static System.Net.Mime.MediaTypeNames;

namespace KaizenCaseStudy.Question_2
{
    public class ReadReceiptData
    {
        public void ReadReceipt()
        {
            string response = File.ReadAllText(@"./Question_2/response.json");

            var descriptions = JsonConvert.DeserializeObject<List<ReceiptDescriptionModel>>(response);

            if (!descriptions.Any())
            {
                return;
            }

            var overall = descriptions[0];

            if (overall?.BoundingPoly?.Vertices == null || overall.BoundingPoly.Vertices.Count != 4)
            {
                return;
            }

            var bitmapWidth = overall.BoundingPoly.TopRight.X;
            var bitmapHeight = overall.BoundingPoly.BottomRight.Y;

            DrawImage(descriptions, bitmapWidth, bitmapHeight);

        }

        private void DrawImage(List<ReceiptDescriptionModel> descriptionList, int width, int height)
        {
            var bitmap = new SKBitmap(width, height);
            var font = SKTypeface.FromFamilyName("Arial");

            using (SKPaint textPaint = new SKPaint
            {
                Typeface = font,
                TextSize = 18.0f,
                IsAntialias = true,
                Color = SKColors.Black
            })
            {
                using (var bitmapCanvas = new SKCanvas(bitmap))
                {
                    bitmapCanvas.Clear(SKColors.White);

                    for (int i = 1; i < descriptionList.Count; i++)
                    {
                        var desc = descriptionList[i];

                        bitmapCanvas.DrawText(desc.Description, desc.BoundingPoly.TopLeft.X, desc.BoundingPoly.TopLeft.Y, textPaint);
                    }

                    bitmapCanvas.Flush();
                }
            }

            var image = SKImage.FromBitmap(bitmap);
            var data = image.Encode(SKEncodedImageFormat.Jpeg, 90);

            using (var stream = new FileStream(@"./Question_2/Receipt.jpg", FileMode.Create, FileAccess.Write))
                data.SaveTo(stream);

            data.Dispose();
            image.Dispose();
            bitmap.Dispose();
        }
    }
}
