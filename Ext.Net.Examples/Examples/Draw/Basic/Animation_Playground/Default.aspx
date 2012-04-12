<%@ Page Language="C#" %>
<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Animation playground - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        

        <ext:Viewport runat="server">
            <LayoutConfig>
                <ext:VBoxLayoutConfig Align="Center" Pack="Center" />
            </LayoutConfig>
            <Items>
                <ext:Panel runat="server" Border="false" PreventHeader="true" Width="640" Height="480" Layout="FitLayout" BodyStyle="background:transparent;" ButtonAlign="Center">                   
                    <Items>                        
                        <ext:DrawComponent ID="Canvas" runat="server">
                            <Items>
                                <ext:Sprite 
                                    Type="Rect" 
                                    X="0" 
                                    Y="0" 
                                    Fill="#CECECE"
                                    Radius="10" 
                                    Width="640" 
                                    Height="480">
                                </ext:Sprite>
                                <ext:Sprite
                                    SpriteID="circle"
                                    Type="Circle"
                                    X="320"
                                    Y="240"
                                    Fill="#000"
                                    Radius="60">
                                </ext:Sprite>
                            </Items>
                        </ext:DrawComponent>    
                    </Items>
                    <FooterBar>
                        <ext:Toolbar runat="server">
                            <Items>
                                <ext:TextField ID="toConfig" runat="server" Width="400" Text="{fill: '#223fa3', stroke: '#000', 'stroke-width': 80, 'stroke-opacity': 0.5}" />
                                <ext:NumberField ID="duration" runat="server" Number="2000" Width="70" />
                                <ext:Button runat="server" Text="Run">
                                    <Listeners>
                                        <Click Handler="
                                            try {
                                                #{Canvas}.get('circle').animate({
                                                    to: Ext.decode(#{toConfig}.getValue()),
                                                    duration: #{duration}.getValue()
                                                });
                                            } catch (e) {
                                                alert(e.message || e);
                                            }" />
                                    </Listeners>
                                </ext:Button>    
                            </Items>
                        </ext:Toolbar>                    
                    </FooterBar>
                </ext:Panel>            
            </Items>
        </ext:Viewport>   
    </form>    
</body>
</html>
