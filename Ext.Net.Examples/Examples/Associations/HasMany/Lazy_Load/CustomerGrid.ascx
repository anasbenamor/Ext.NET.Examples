<%@ Control Language="C#" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<ext:GridPanel runat="server"
    Title="Customers">
    <Store>
        <ext:Store runat="server" ModelName="Customer">
            <Listeners>
                <Load Handler="Ext.net.Bus.publish('App.Log', {msg:'Customer store loaded', isStart: false});" />
            </Listeners>
        </ext:Store>
    </Store>
    <ColumnModel>
        <Columns>
            <ext:Column runat="server" Text="Id" DataIndex="Id" />
            <ext:Column runat="server" Text="Name" DataIndex="Name" Flex="1" />
            <ext:Column runat="server" Text="Phone" DataIndex="Phone" />
        </Columns>
    </ColumnModel>
    <DockedItems>
        <ext:Toolbar runat="server">
            <Items>
                <ext:Button ItemID="btnLoad" runat="server" Text="Load Orders" Disabled="true">
                    <Listeners>
                        <Click Fn="loadOrders" />
                    </Listeners>
                </ext:Button>
            </Items>
        </ext:Toolbar>
    </DockedItems>
    <Listeners>
        <SelectionChange Handler="this.active = selected[0]; this.down('#btnLoad').setDisabled(!this.active);" />
    </Listeners>
    <HtmlBin>
        <script type="text/javascript">
            var loadOrders = function(){
                var grid = this.up("gridpanel"),
                    rec = grid.active,
                    name = rec.get('Name'),
                    owner = grid.ownerCt,
                    orders;
         
        
                orders = rec.orders();
                if (orders.isLoading()) {
                    Ext.net.Bus.publish('App.Log', {msg:'Begin loading orders: ' + rec.getId(), isStart: true});
                }
                orders.on('load', function(){
                    Ext.net.Bus.publish('App.Log', {msg:'Order store loaded - ' + rec.getId(), isStart: false});
                });

                App.direct.RenderOrders(rec.getId(), owner.id, {
                    success : function () {
                        owner.getComponent(owner.items.getCount()-1).bindStore(orders);
                        owner.getLayout().next();
                    }
                });
            };    
        </script>
    </HtmlBin>
</ext:GridPanel>