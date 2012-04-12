<%@ Page Language="C#" %>
<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Animation playground - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />
</head>
<body style="background:white;">
    <form runat="server">
        <ext:ResourceManager runat="server" />

        <ext:Viewport runat="server">
            <LayoutConfig>
                <ext:VBoxLayoutConfig Align="Center" Pack="Center" />
            </LayoutConfig>
            <Items>
                <ext:Panel runat="server" Border="false" PreventHeader="true" Width="320" Height="400" BodyStyle="background:transparent;">                   
                    <Items>                        
                        <ext:DrawComponent runat="server" Width="320" Height="400" ViewBox="false">
                            <Items>
                                <ext:Sprite Type="Image" Src="bd.jpg" X="0" Y="0" Width="320" Height="240" />
                                <ext:Sprite Type="Image" Src="bd.jpg" X="0" Y="240" Width="320" Height="240">
                                    <Scale X="1" Y="-1" />
                                </ext:Sprite>
                                <ext:Sprite Type="Rect" X="0" Y="240" Width="320" Height="200" Fill="url(#reflectGrd)">                
                                </ext:Sprite>
                            </Items>
                            <Gradients>
                                <ext:Gradient GradientID="reflectGrd" Angle="90">
                                    <Stops>
                                        <ext:GradientStop Offset="0" Opacity="0.5" Color="#FFF" />  
                                        <ext:GradientStop Offset="70" Opacity="0.99" Color="#FFF" />
                                    </Stops>
                                </ext:Gradient>
                            </Gradients>
                        </ext:DrawComponent>    
                    </Items>                   
                </ext:Panel>            
            </Items>
        </ext:Viewport>   
    </form>    
</body>
</html>
