<%@ Page Language="C#" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>TreePanel using WebService - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function getXmlResponseData(response) {
            var xmlData = response.responseXML,
                root = xmlData.documentElement || xmlData;            
                            
            return Ext.decode(root.firstChild.nodeValue);
        }

        function getJsonResponseData(response) {
            var xmlData = response.responseXML,
                root = xmlData.documentElement || xmlData;            
                            
            return Ext.decode(Ext.decode(response.responseText).d);
        }
    </script>
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        
        <h1>TreePanel using WebService</h1> 

        <ext:Container runat="server"
            Layout="HBoxLayout">
            <Items>
                <ext:TreePanel 
                    ID="TreePanel1" 
                    runat="server" 
                    Title="XML WebService" 
                    Height="500"
                    Width="200" 
                    Margins="10"
                    Border="false">
                    <Store>
                        <ext:TreeStore runat="server">
                            <Proxy>
                                <ext:AjaxProxy Url="TreeXmlService.asmx/GetNodes">
                                    <Reader>
                                        <ext:JsonReader>
                                            <CustomConfig>
                                                <ext:ConfigItem Name="getResponseData" Value="getXmlResponseData" Mode="Raw" />
                                            </CustomConfig>
                                        </ext:JsonReader>
                                    </Reader>
                                </ext:AjaxProxy>
                            </Proxy>
                        </ext:TreeStore>
                    </Store>
                    <Root>
                        <ext:Node NodeID="0" Text="Root" />
                    </Root>
                </ext:TreePanel>           

                <ext:TreePanel 
                    ID="TreePanel2" 
                    runat="server" 
                    Title="JSON WebService" 
                    Height="500"
                    Width="200" 
                    Margins="10"
                    Border="false">
                    <Store>
                        <ext:TreeStore runat="server">
                            <Proxy>
                                <ext:AjaxProxy Url="TreeJsonService.asmx/GetNodes" Json="true">
                                    <ActionMethods Read="POST" />
                                    <Reader>
                                        <ext:JsonReader>
                                            <CustomConfig>
                                                <ext:ConfigItem Name="getResponseData" Value="getJsonResponseData" Mode="Raw" />
                                            </CustomConfig>
                                        </ext:JsonReader>
                                    </Reader>
                                </ext:AjaxProxy>
                            </Proxy>
                        </ext:TreeStore>
                    </Store>
                    <Root>
                        <ext:Node NodeID="0" Text="Root" />
                    </Root>
                </ext:TreePanel>   
            </Items>
        </ext:Container>
        
        
    </form>
</body>
</html>