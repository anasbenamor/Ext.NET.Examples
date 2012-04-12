<%@ Page Language="C#" %>
<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Rotate Image - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function onMouseOver(surface, group) {
            surface.getGroup(group).items[1].animate({to:{fill: '#fc0'}, duration:300});
        }

        function onMouseOut(surface, group) {
            surface.getGroup(group).items[1].stopAnimation().setAttributes({fill: '#000'}, true);
        }

        function onClick(surface, angel){
            var img = surface.items.get('img');
            img.curAngel = img.curAngel || 0;
            img.curAngel += angel;
            img.stopAnimation().animate({
                to: {
                    rotate: {
                        degrees: img.curAngel
                    }
                },
                duration: 1000,
                easing: 'easeInOut'
            });
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
                 <ext:DrawComponent runat="server"
                    Width="640"
                    Height="480">
                    <Items>
                        <ext:Sprite Type="Circle"
                            X="320"
                            Y="240"
                            Radius="200"
                            Fill="#000"
                            FillOpacity="0.5"
                            StrokeWidth="5">                
                        </ext:Sprite>

                        <ext:Sprite SpriteID="img" Type="Image"
                            Src="bd.jpg"
                            X="160"
                            Y="120"
                            Width="320"
                            Height="240">
                        </ext:Sprite>

                        <ext:Sprite Type="Circle" Group="button1"
                            X="25"
                            Y="27"
                            Radius="27"
                            Stroke="#ccc"
                            Fill="#fff"
                            FillOpacity="0.4"
                            StrokeWidth="2">           
                            <Translate X="10" Y="181" /> 
                        </ext:Sprite>

                        <ext:Sprite Type="Path" Group="button1"
                            Path="M12.582 9.551C3.251 16.237 0.921 29.021 7.08 38.564l-2.36 1.689l4.893 2.262l4.893 2.262l-0.568-5.36l-0.567-5.359l-2.365 1.694c-4.657-7.375-2.83-17.185 4.352-22.33c7.451-5.338 17.817-3.625 23.156 3.824c5.337 7.449 3.625 17.813-3.821 23.152l2.857 3.988c9.617-6.893 11.827-20.277 4.935-29.896C35.591 4.87 22.204 2.658 12.582 9.551z"
                            Stroke="none"
                            Fill="#000">    
                            <Translate X="10" Y="181" />
                        </ext:Sprite>

                        <ext:Sprite Type="Circle" Group="button1"
                            X="25"
                            Y="27"
                            Radius="27"
                            Stroke="#ccc"
                            Fill="#fff"
                            Opacity="0">
                            <Translate X="10" Y="181" />
                            <Listeners>
                                <MouseOver Handler="onMouseOver(this.surface, 'button1');" />
                                <MouseOut Handler="onMouseOut(this.surface, 'button1');" />
                                <Click Handler="onClick(this.surface, -90);" />
                            </Listeners>    
                        </ext:Sprite>

                        <ext:Sprite Type="Circle" Group="button2"
                            X="25"
                            Y="27"
                            Radius="27"
                            Stroke="#ccc"
                            Fill="#fff"
                            FillOpacity="0.4"
                            StrokeWidth="2">  
                            <Translate X="10" Y="245" />                      
                        </ext:Sprite>

                        <ext:Sprite Type="Path" Group="button2"
                            Path="M37.566 9.551c9.331 6.686 11.661 19.471 5.502 29.014l2.36 1.689l-4.893 2.262l-4.893 2.262l0.568-5.36l0.567-5.359l2.365 1.694c4.657-7.375 2.83-17.185-4.352-22.33c-7.451-5.338-17.817-3.625-23.156 3.824C6.3 24.695 8.012 35.06 15.458 40.398l-2.857 3.988C2.983 37.494 0.773 24.109 7.666 14.49C14.558 4.87 27.944 2.658 37.566 9.551z"
                            Stroke="none"
                            Fill="#000">                
                            <Translate X="10" Y="245" />          
                        </ext:Sprite>

                        <ext:Sprite Type="Circle" Group="button2"
                            X="25"
                            Y="27"
                            Radius="27"
                            Stroke="#ccc"
                            Fill="#fff"
                            Opacity="0">
                            <Translate X="10" Y="245" />    
                            <Listeners>
                                <MouseOver Handler="onMouseOver(this.surface, 'button2');" />
                                <MouseOut Handler="onMouseOut(this.surface, 'button2');" />
                                <Click Handler="onClick(this.surface, 90);" />
                            </Listeners>    
                        </ext:Sprite>
                    </Items>
                </ext:DrawComponent>      
            </Items>
        </ext:Viewport>   
    </form>    
</body>
</html>
