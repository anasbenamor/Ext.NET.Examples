<%@ Page Language="C#" %>
<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Pies Chart - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />

    <script runat="server">
        public System.Drawing.Color ColorFromHSL(double h, double sl, double l)
        {
            double v;
            double r, g, b;

            r = l;
            g = l;
            b = l;
            v = (l <= 0.5) ? (l * (1.0 + sl)) : (l + sl - l * sl);
            if (v > 0)
            {
                double m;
                double sv;
                int sextant;
                double fract, vsf, mid1, mid2;

                m = l + l - v;
                sv = (v - m) / v;
                h *= 6.0;
                sextant = (int)h;
                fract = h - sextant;
                vsf = v * sv * fract;
                mid1 = m + vsf;
                mid2 = v - vsf;
                switch (sextant)
                {
                    case 0:
                        r = v;
                        g = mid1;
                        b = m;
                        break;
                    case 1:
                        r = mid2;
                        g = v;
                        b = m;
                        break;
                    case 2:
                        r = m;
                        g = v;
                        b = mid1;
                        break;
                    case 3:
                        r = m;
                        g = mid2;
                        b = v;
                        break;
                    case 4:
                        r = mid1;
                        g = m;
                        b = v;
                        break;
                    case 5:
                        r = v;
                        g = m;
                        b = mid2;
                        break;
                }
            }
            return System.Drawing.Color.FromArgb(Convert.ToByte(r * 255.0f), Convert.ToByte(g * 255.0f), Convert.ToByte(b * 255.0f));
        }
    
        protected void Page_Load(object sender, EventArgs e)
        {
            var data = new List<Pair> 
            { 
                new Pair("Ruby", 40),
                new Pair("JavaScript", 26),
                new Pair("Shell", 5),
                new Pair("Python", 5),
                new Pair("PHP", 4),
                new Pair("C", 4),
                new Pair("Perl", 3),
                new Pair("C++", 2),
                new Pair("Java", 2),
                new Pair("Objective-C", 2)
            };

            this.Draw(data);
        }

        private double angle = 0;
        private double start = 0;
        
        private void Draw(List<Pair> data)
        {
            DrawComponent draw = this.Draw1;
            draw.Width = 700;
            draw.Height = 700;

            this.angle = 0;
            this.start = 0;

            var total = 0;

            for (int i = 0; i < data.Count; i++)
            {
                total += (int)data[i].Second;
            }
            for (int i = 0; i < data.Count; i++)
            {
                this.Process(draw, i, data[i], total);
            }
        }

        private void Process(DrawComponent draw, int i, Pair item, int total)
        {
            var value = (int)item.Second;                
            var angleplus = 360 * value * 1.0 / total;            
            var popangle = this.angle + (angleplus / 2);            
            var color = this.ColorFromHSL(this.start, 0.5, 0.5);                            
            var delta = 30;
            var bcolor = this.ColorFromHSL(this.start, 1, 0.5);                
            var r = 200;
            var rad = Math.PI / 180;
            
            draw.Gradients.Add(new Gradient{
                Angle = 90,
                GradientID = "Grd"+i,
                Stops = {
                    new GradientStop{Offset = 0, Color = System.Drawing.ColorTranslator.ToHtml(bcolor)},
                    new GradientStop{Offset = 100, Color = System.Drawing.ColorTranslator.ToHtml(color)}
                }
            });

            var sector = this.Sector(350, 350, r, this.angle, this.angle + angleplus);
            sector.Fill = "url(#Grd"+i+")";
            sector.Stroke = "#fff";
            sector.StrokeWidth = 3;
            
            draw.Items.Add(sector);
            
            var text = new Sprite{
                SpriteID = "text"+i,
                Type = SpriteType.Text,
                X = Convert.ToInt32(350 + (r + delta + 55) * Math.Cos(-popangle * rad)),
                Y = Convert.ToInt32(350 + (r + delta + 25) * Math.Sin(-popangle * rad)),
                Text = item.First.ToString(),
                Fill = System.Drawing.ColorTranslator.ToHtml(bcolor),
                Stroke = "none",
                Opacity = 0,
                FontSize = "20"
            };

            draw.Items.Add(text);

            sector.Listeners.MouseOver.Handler = string.Format("onMouseOver(this, {0});", i);
            sector.Listeners.MouseOut.Handler = string.Format("onMouseOut(this, {0});", i);

            this.angle += angleplus;
            this.start += 0.1;
        }
        
        private Sprite Sector(int cx, int cy, int r, double startAngle, double endAngle) {
            var rad = Math.PI / 180;
            
            var x1 =JSON.Serialize(cx + r * Math.Cos(-startAngle * rad));
            var x2 = JSON.Serialize(cx + r * Math.Cos(-endAngle * rad));
            var y1 = JSON.Serialize(cy + r * Math.Sin(-startAngle * rad));
            var y2 = JSON.Serialize(cy + r * Math.Sin(-endAngle * rad));
            
            return new Sprite{
                Type = SpriteType.Path,               
                Path = String.Join<string>(" ", new string[] { "M" + cx, cy.ToString(), "L" + x1, y1.ToString(), "A" + r, r.ToString(), "0", (endAngle - startAngle) > 180 ? "1" : "0", "0", x2, y2, "z" })
            };            
        }
    </script>

    <script type="text/javascript">
        function onMouseOver(sprite, i) {
            sprite.stopAnimation().animate({to:{scale: {x: 1.1, y: 1.1, cx: 350, cy : 350}}, duration : 500, easing: "backOut"});
            sprite.surface.items.get("text"+i).stopAnimation().animate({to:{opacity: 1}, duration : 500});
        }

        function onMouseOut(sprite, i) {
            sprite.stopAnimation().animate({to:{scale: {x: 1, y: 1, cx: 350, cy : 350}}, duration : 500, easing: "backIn"});
            sprite.surface.items.get("text"+i).stopAnimation().animate({to:{opacity: 0}, duration : 500});
        }
    </script>
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />

        <ext:Viewport runat="server">
            <LayoutConfig>
                <ext:VBoxLayoutConfig Align="Center" Pack="Center" />
            </LayoutConfig>
            <Items>
                <ext:DrawComponent ID="Draw1" runat="server" />
            </Items>
        </ext:Viewport>   
    </form>    
</body>
</html>
