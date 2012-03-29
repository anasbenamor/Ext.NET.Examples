<%@ Control Language="C#" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<ext:Window runat="server"
    IDMode="Static"
    ID="ItemLoaderWindow"
    CloseAction="Destroy"
    Border="false"
    Width="400"
    Height="400"
    Modal="true"
    BodyPadding="5"
    TplWriteMode="Append">
    <Tpl>
        <Html>
            <div>{type} {id} - {value}</div>
        </Html>
    </Tpl>
    <DockedItems>
        <ext:Toolbar runat="server">
            <Items>
                <ext:Button runat="server" Text="Print order detail">
                    <Listeners>
                        <Click Fn="onOrderClick" Single="true" />
                    </Listeners>
                </ext:Button>

                <ext:Button runat="server" ItemID="company" Text="Print company detail" Disabled="true">
                    <Listeners>
                        <Click Fn="onCompanyClick" Single="true" />
                    </Listeners>
                </ext:Button>
            </Items>
        </ext:Toolbar>
    </DockedItems>

    <HtmlBin>
        <script type="text/javascript">
            var onOrderClick = function () {
                var wnd = this.up('window'),
                    id = wnd.orderItem.get('OrderId'),
                    hasOrder = !!wnd.order;
            
                if (!hasOrder) {
                    Ext.net.Bus.publish('App.Log', {msg:'Begin loading order - ' + id, isStart: true});
                }
                wnd.orderItem.getOrder({
                    scope: wnd,
                    success: function(order){
                        wnd.order = order;
                        wnd.down('#company').enable();
                        if (!hasOrder) {
                            Ext.net.Bus.publish('App.Log', {msg:'Order loaded - ' + id, isStart: false});
                        }
                        wnd.update({
                            type: 'Order',
                            id: order.getId(),
                            value: Ext.Date.format(order.get('Date'), 'Y-m-d')
                        });
                    }
                });
            };

            var onCompanyClick = function () {
                var wnd = this.up('window'),
                    id = wnd.order.get('CustomerId'),
                    hasCustomer = !!wnd.customer;
            
                if (!hasCustomer) {
                    Ext.net.Bus.publish('App.Log', {msg:'Begin loading customer - ' + id, isStart: true});
                }
                wnd.order.getCustomer({
                    scope: wnd,
                    success: function(customer){
                        wnd.customer = customer;
                        if (!hasCustomer) {
                            Ext.net.Bus.publish('App.Log', {msg:'Customer loaded - ' + id, isStart: false});
                        }
                        wnd.update({
                            type: 'Customer',
                            id: customer.getId(),
                            value: customer.get('Name')
                        });
                    }
                });
            };
        </script>
    </HtmlBin>
</ext:Window>