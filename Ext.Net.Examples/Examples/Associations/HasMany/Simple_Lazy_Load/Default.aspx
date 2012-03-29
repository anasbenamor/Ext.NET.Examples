<%@ Page Language="C#" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            UsersStore.DataSource = this.Users;
            UsersStore.DataBind();
        }
    }

    private static int idgen = 10;
    [DirectMethod]
    public object SaveNewProducts(string action, Dictionary<string, object> extraParams, List<Product> products)
    {
        X.Msg.Alert(action, string.Format("{0} new products were saved for user with id={1}", products.Count, products[0].UserId)).Show();
        products.ForEach(p =>
        {
            p.Id = idgen++;
        });
        return products;
    }

    [DirectMethod]
    public object GetProducts(string action, Dictionary<string, object> extraParams, object serviceParams)
    {
        var userId = -1;

        StoreRequestParameters prms = new StoreRequestParameters(extraParams);
        var filter = prms.Filter;
        if (filter.Length > 0 && filter[0].Property == "UserId")
        {
            userId = Convert.ToInt32(filter[0].Value);
        }
        
        return this.Products.Where(p => p.UserId == userId);
    }

    public List<Product> Products
    {
        get
        {
            return new List<Product> 
            { 
                new Product(1, 1, "Product1 of User1"),
                new Product(2, 1, "Product2 of User1"),
                new Product(3, 1, "Product3 of User1"),
                new Product(4, 2, "Product1 of User2"),
                new Product(5, 2, "Product2 of User2"),
                new Product(6, 2, "Product3 of User2"),
                new Product(7, 3, "Product1 of User3"),
                new Product(8, 3, "Product2 of User3"),
                new Product(9, 3, "Product3 of User3")
            };
        }
    }

    public List<User> Users
    {
        get
        {
            return new List<User> 
            { 
                new User(1, "Product1 of User1"),
                new User(2, "Product2 of User2"),
                new User(3, "Product3 of User3")
            };
        }
    }

    public class Product
    {
        public Product(int id, int userId, string name)
        {
            this.Id = id;
            this.UserId = userId;
            this.Name = name;
        }
        
        public int Id
        {
            get;
            set;
        }

        public int UserId
        {
            get;
            set;
        }

        public string Name
        {
            get;
            set;
        }
    }

    public class User
    {
        public User(int id, string name)
        {
            this.Id = id;
            this.Name = name;
        }

        public int Id
        {
            get;
            set;
        }

        public string Name
        {
            get;
            set;
        }
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Simple lazy load - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />    
</head>
<body>
    <ext:ResourceManager runat="server" />
    
     <h1>Simple lazy load</h1>
     <p>Products for each user are loaded only once (caching on the client side)</p>

     <ext:Model runat="server" Name="User" IDProperty="Id">
        <Fields>
            <ext:ModelField Name="Id" Type="Int" />
            <ext:ModelField Name="Name" Type="String" />
        </Fields>        
        <Associations>
            <ext:HasManyAssociation Model="Product" Name="products" ForeignKey="UserId" PrimaryKey="Id" AutoLoad="true" />
        </Associations>
     </ext:Model>

     <ext:Model runat="server" Name="Product" IDProperty="Id">
        <Fields>
            <ext:ModelField Name="Id" Type="Int" />
            <ext:ModelField Name="UserId" Type="Int" />
            <ext:ModelField Name="Name" Type="String" />
        </Fields>                                          
        <Proxy>
            <ext:PageProxy>
                <API Read="App.direct.GetProducts" Sync="App.direct.SaveNewProducts" />
            </ext:PageProxy>
        </Proxy>
     </ext:Model>

     <ext:Panel runat="server" Border="false" Width="500" Height="250">
        <LayoutConfig>
            <ext:HBoxLayoutConfig Align="Stretch" DefaultMargins="5" />
        </LayoutConfig>
        <Items>
            <ext:GridPanel 
                runat="server" 
                Title="Users (select a row to see products)" 
                Flex="1">
                <Store>
                    <ext:Store ID="UsersStore" runat="server" ModelName="User">                        
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column runat="server" Text="Name" DataIndex="Name" Flex="1" />
                    </Columns>            
                </ColumnModel> 
                 <Listeners>
                    <SelectionChange Handler="selected.length && #{ProductsGrid}.bindStore(selected[0].products());" />
                </Listeners>                                   
            </ext:GridPanel>

            <ext:GridPanel 
                ID="ProductsGrid"
                runat="server" 
                Title="Products" 
                Flex="1">               
                <ColumnModel>
                    <Columns>
                        <ext:Column runat="server" Text="Name" DataIndex="Name" Flex="1" />
                    </Columns>            
                </ColumnModel>  
                <Buttons>
                    <ext:Button runat="server" Text="Add Product">
                        <Listeners>
                            <Click Handler="this.up('gridpanel').store.add({Name:'New product'});" />
                        </Listeners>
                    </ext:Button>

                    <ext:Button runat="server" Text="Save new products">
                        <Listeners>
                            <Click Handler="this.up('gridpanel').store.sync();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>                                
            </ext:GridPanel>
        </Items>
    </ext:Panel>
</body>
</html>