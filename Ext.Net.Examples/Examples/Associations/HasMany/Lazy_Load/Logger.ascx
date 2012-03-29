<%@ Control Language="C#" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<ext:Panel runat="server" 
    Title="Loader log"
    TplWriteMode="Append"
    BodyPadding="5"
    AutoScroll="true"
    Flex="1">
    <Tpl>
        <Html>
            <div class="{cls}">[{now:date("H:i:s")}] - {msg}</div>
        </Html>
    </Tpl>
    <MessageBusListeners>
        <ext:MessageBusListener Name="App.Log" Fn="addLogMessage" />
    </MessageBusListeners>
    <HtmlBin>
        <style type="text/css">
            .beforeload {
                color: blue;
            }

            .afterload {
                color: green;
            }
        </style>

        <script type="text/javascript">
            var addLogMessage = function(name, data){
                this.update({
                    now: new Date(),
                    cls: data.isStart ? 'beforeload' : 'afterload',
                    msg: data.msg
                });
                this.body.scroll('b', 100000, true);
            }; 
        </script>
    </HtmlBin>
</ext:Panel>