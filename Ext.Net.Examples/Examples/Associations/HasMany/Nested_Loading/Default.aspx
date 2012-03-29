<%@ Page Language="C#" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title> - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />  
    <link href="Book.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var stars = function(values) {
            var res = [],
                extension = Ext.isIE6 ? 'gif' : 'png',
                i = 0;

            //print out the stars for each of the ratings
            for (; i < values.rating; i++) {
                res.push('<img src="images/star.', extension, '" />');
            }

            //print out transparent stars for the rest (up to 5)
            while (i < 5) {
                res.push('<img src="images/star_no.', extension, '" />');
                i++;
            }

            return res.join('');
        };
    </script>
</head>
<body>
    <ext:ResourceManager runat="server" />

    <ext:Model runat="server" Name="Books.Review">
        <Fields>
            <ext:ModelField Name="author" />
            <ext:ModelField Name="rating" />
            <ext:ModelField Name="date" />
            <ext:ModelField Name="title" />
            <ext:ModelField Name="comment" />
        </Fields>        
    </ext:Model>

    <ext:Model runat="server" Name="Books.Book">
        <Fields>
            <ext:ModelField Name="id" />
            <ext:ModelField Name="name" />
            <ext:ModelField Name="author" />
            <ext:ModelField Name="detail" />
            <ext:ModelField Name="price" />
            <ext:ModelField Name="image" />
        </Fields>
        <Associations>
            <%--AssociationKey="/" means read 'review' xml nodes from current root node (current book)--%>
            <ext:HasManyAssociation Model="Books.Review" Name="reviews" AssociationKey="/">                
                <Reader>
                    <ext:XmlReader Record="review" />
                </Reader>
            </ext:HasManyAssociation>
        </Associations>        
    </ext:Model>
    
    <ext:Viewport runat="server" Layout="FitLayout">
        <Items>
            <ext:Panel runat="server" Border="false">
                <LayoutConfig>
                    <ext:VBoxLayoutConfig Align="Stretch" />
                </LayoutConfig>

                <DockedItems>
                    <ext:Component runat="server" Dock="Top" BaseCls="app-header" Html="Loading Nested Data Example" />
                    
                    <ext:DataView runat="server" 
                        Dock="Left"
                        Width="180"
                        Border="false"
                        Cls="sidebar-list"
                        ItemSelector=".product">
                        <Tpl>
                            <Html>
                                <div class="sidebar-title">Books</div>
                                <tpl for=".">
                                    <div class="product">{name}</div>
                                </tpl>
                            </Html>
                        </Tpl>
                        <Store>
                            <ext:Store ID="BooksStore" runat="server" ModelName="Books.Book">   
                                <Proxy>
                                    <ext:AjaxProxy runat="server" Url="Books.xml">
                                        <Reader>
                                            <ext:XmlReader Record="Book" />
                                        </Reader>
                                    </ext:AjaxProxy>                                   
                                </Proxy>   
                                <Listeners>
                                    <Load BroadcastOnBus="App.BooksLoad" />
                                </Listeners>                          
                            </ext:Store>
                        </Store>
                        <Listeners>
                            <SelectionChange BroadcastOnBus="App.SelectionChange" />
                        </Listeners>
                        <MessageBusListeners>
                            <ext:MessageBusListener Name="App.BooksLoad" Handler="data.records.length && this.getSelectionModel().select(data.records[0]);" Delay="500" />
                        </MessageBusListeners>
                    </ext:DataView>
                </DockedItems>

                <Items>
                    <ext:Panel runat="server"
                        Cls="item-ct"
                        Flex="2"
                        Border="false"
                        AutoScroll="true">
                        <LayoutConfig>
                            <ext:HBoxLayoutConfig Align="Middle" Pack="Center" AvailableSpaceOffset="17" />
                        </LayoutConfig>
                        <Items>
                            <ext:Image runat="server" MarginSpec="0 20 0 0" Width="250" Height="308" ImageUrl="={Ext.BLANK_IMAGE_URL}">
                                <LoadMask ShowMask="true" />
                                <MessageBusListeners>
                                    <ext:MessageBusListener Name="App.SelectionChange" Handler="data.selections.length && this.setImageUrl(data.selections[0].get('image'))" />
                                </MessageBusListeners>
                            </ext:Image>
                            <ext:Component runat="server" Width="500" Border="false">
                                <Tpl>
                                    <Html>
                                        <div class="name">{name} <span>${price}</span></div>
                                        <div class="author">By {author}</div>
                                        <div class="detail">{detail}</div>
                                    </Html>
                                </Tpl>
                                <MessageBusListeners>
                                    <ext:MessageBusListener Name="App.SelectionChange" Handler="data.selections.length && this.update(data.selections[0].getData())" />
                                </MessageBusListeners>
                            </ext:Component>
                        </Items>
                    </ext:Panel>

                    <ext:Panel runat="server"
                        Border="false"
                        Flex="1"
                        Layout="CardLayout">
                        <DockedItems>
                            <ext:Component runat="server" Dock="Top" BaseCls="app-header" Html="Reviews" />
                        </DockedItems>

                        <Items>
                            <ext:DataView runat="server" 
                                Border="false"
                                Cls="review-list"
                                AutoScroll="true"                                
                                ItemSelector=".review">
                                <Tpl>
                                    <Html>
                                        <tpl for=".">
                                            <div class="review {[xindex === 1 ? "first-review" : ""]}">
                                                <div class="title">{title} {[this.stars(values)]}</div>
                                                <div class="author">By <span>{author}</span> - {date}</div>
                                                <div class="comment">{comment}</div>
                                            </div>
                                        </tpl>
                                    </Html>
                                    <Functions>
                                        <ext:JFunction Name="stars" Fn="stars" />
                                    </Functions>
                                </Tpl>
                                <Store>
                                    <ext:Store ID="ReviewsStore" runat="server" ModelName="Books.Review">                                
                                    </ext:Store>
                                </Store>
                                <MessageBusListeners>
                                    <ext:MessageBusListener Name="App.SelectionChange" Handler="data.selections.length && this.bindStore(data.selections[0].reviews())" />
                                </MessageBusListeners>
                            </ext:DataView>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
</body>
</html>