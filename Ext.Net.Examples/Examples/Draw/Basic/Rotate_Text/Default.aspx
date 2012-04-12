<%@ Page Language="C#" %>
<%@ Register assembly="Ext.Net" namespace="Ext.Net" tagprefix="ext" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Rotate Text - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        <h1>Rotating Text with a Draw Component</h1>
        <p>
            In this example, you can see how easy it is to create text in a Draw Component which can be rotated easily in any browser. Use the slider to spin the text 360 degrees.
        </p>

        <p>
            See introductory blog post on the topic <a href="http://www.sencha.com/blog/ext-js-4-drawing-charting">here</a>.
        </p>
        
        <ext:Slider runat="server" 
            Single="true" 
            Width="400"
            MinValue="0"
            MaxValue="360"
            Number="315"
            HideLabel="true">
            <Listeners>
                <Change Handler="#{Snappy}.surface.items.first().setAttributes({rotation: {degrees: newValue}}, true);" />
            </Listeners>
        </ext:Slider>

        <ext:DrawText runat="server"
            Height="350"
            Padding="20"
            Degrees="45"
            Text="With Ext.NET 2.0 Drawing" 
            >
            <TextStyle Fill="#F00" Font="18px Arial" />
        </ext:DrawText>
       
        <ext:DrawComponent runat="server"
            Height="350"
            Padding="20">
            <Items>
                <ext:Sprite 
                    Type="Text" 
                    Text="Creating a rotated Text component" 
                    Fill="#0F0" 
                    Font="18px Arial">
                    <Rotate Degrees="90" />
                </ext:Sprite>
            </Items>
        </ext:DrawComponent>

        <ext:DrawText ID="Snappy" runat="server"
            AutoSize="false"
            ViewBox="false"
            Height="350"
            Width="200"
            Padding="20"
            Degrees="315" 
            Text="Is a snap!" 
            >
            <TextStyle Fill="#00F" Font="18px Arial" Y="50" />
        </ext:DrawText>
    </form>    
</body>
</html>
