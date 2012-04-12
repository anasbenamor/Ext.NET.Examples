<%@ Page Language="C#" %>

<%@ Import Namespace="System.Collections.ObjectModel" %>
<%@ Import Namespace="System.Collections.Generic" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<script runat="server">
    protected void Store1_RefreshData(object sender, StoreReadDataEventArgs e)
    {
        List<object> data = FiltersTestData.Data;

        string s = e.Parameters[this.GridFilters1.ParamPrefix];
        //or with hardcoding - string s = e.Parameters["filter"];;
        
        
        //-- start filtering ------------------------------------------------------------
        if (!string.IsNullOrEmpty(s))
        {
            FilterConditions fc = new FilterConditions(s);

            foreach (FilterCondition condition in fc.Conditions)
            {
                Comparison comparison = condition.Comparison;
                string field = condition.Field;
                FilterType type = condition.Type;
                
                object value;
                switch(condition.Type)
                {
                    case FilterType.Boolean:
                        value = condition.Value<bool>();
                       break;
                    case FilterType.Date:
                        value = condition.Value<DateTime>();
                        break;
                    case FilterType.List:
                        value = condition.List;
                        break;
                    case FilterType.Numeric:
                        if (data.Count > 0 && data[0].GetType().GetProperty(field).PropertyType == typeof(int))
                        {
                            value = condition.Value<int>();
                        }
                        else
                        {
                            value = condition.Value<double>();
                        }
                        
                        break;
                    case FilterType.String:
                        value = condition.Value<string>();
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }
                
                data.RemoveAll(
                    item =>
                        {
                            object oValue = item.GetType().GetProperty(field).GetValue(item, null);
                            IComparable cItem = oValue as IComparable;
                            
                            switch (comparison)
                            {
                                case Comparison.Eq:
                                    
                                    switch(type)
                                    {
                                        case FilterType.List:
                                            return !(value as List<string>).Contains(oValue.ToString());
                                        case FilterType.String:
                                            return !oValue.ToString().StartsWith(value.ToString());
                                        default:
                                            return !cItem.Equals(value);
                                    }
                                    
                                case Comparison.Gt:
                                    return cItem.CompareTo(value) < 1;
                                case Comparison.Lt:
                                    return cItem.CompareTo(value) > -1;
                                default:
                                    throw new ArgumentOutOfRangeException();
                            }
                        }
                );
            }
        }
        //-- end filtering ------------------------------------------------------------


        //-- start sorting ------------------------------------------------------------
        if (e.Sort.Length > 0)
        {
            data.Sort(delegate(object x, object y)
            {
                object a;
                object b;

                int direction = e.Sort[0].Direction == Ext.Net.SortDirection.DESC ? -1 : 1;

                a = x.GetType().GetProperty(e.Sort[0].Property).GetValue(x, null);
                b = y.GetType().GetProperty(e.Sort[0].Property).GetValue(y, null);
                return CaseInsensitiveComparer.Default.Compare(a, b) * direction;
            });
        }
        //-- end sorting ------------------------------------------------------------


        //-- start paging ------------------------------------------------------------
        var limit = e.Limit;
        
        if ((e.Start + e.Limit) > data.Count)
        {
            limit = data.Count - e.Start;
        }

        List<object> rangeData = (e.Start < 0 || limit < 0) ? data : data.GetRange(e.Start, limit);
        //-- end paging ------------------------------------------------------------

        //The Total can be set in RefreshData event as below
        //or (Store1.Proxy.Proxy as PageProxy).Total in anywhere
        //Please pay attention that the Total make a sence only during DirectEvent because
        //the Store with PageProxy get/refresh data using ajax request

        e.Total = data.Count;
        
        this.GridPanel1.GetStore().DataSource = rangeData;
    }
</script>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>GridPanel with Remote Filtering, Sorting and Paging - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form runat="server">
        <ext:ResourceManager runat="server" />
        
        <h1>GridPanel with Remote Filtering, Sorting and Paging</h1>
        
        <p>Please see column header menu for apllying filters</p>
        
        <ext:Window 
            ID="Window1" 
            runat="server" 
            Width="700" 
            Height="400" 
            Closable="false"
            Collapsible="true" 
            Title="Example"
            Maximizable="true"
            Layout="Fit">
            <Items>
                <ext:GridPanel ID="GridPanel1" runat="server" Border="false">
                    <Store>
                        <ext:Store 
                            runat="server" 
                            RemoteSort="true" 
                            OnReadData="Store1_RefreshData" 
                            PageSize="10">
                            <Proxy>
                                <ext:PageProxy />
                            </Proxy>
                            <Model>
                                <ext:Model runat="server" IDProperty="Id">
                                    <Fields>
                                        <ext:ModelField Name="Id" Type="Int" />
                                        <ext:ModelField Name="Company" Type="String" />
                                        <ext:ModelField Name="Price" Type="Float" />
                                        <ext:ModelField Name="Date" Type="Date" DateFormat="yyyy-MM-ddTHH:mm:ss" />
                                        <ext:ModelField Name="Size" Type="String" />
                                        <ext:ModelField Name="Visible" Type="Boolean" />
                                    </Fields>
                                </ext:Model>
                            </Model>                            
                            <Sorters>
                                <ext:DataSorter Property="Company" Direction="ASC" />
                            </Sorters>
                        </ext:Store>
                    </Store>
                    <ColumnModel runat="server">
			            <Columns>
                            <ext:Column runat="server" Text="ID" DataIndex="Id" />
                            <ext:Column runat="server" Text="Company" DataIndex="Company" />
                            <ext:Column runat="server" Text="Price" DataIndex="Price">
                                <Renderer Format="UsMoney" />
                            </ext:Column>                        
                            <ext:DateColumn runat="server" Text="Date" DataIndex="Date" Align="Center" Format="yyyy-MM-dd" />
                            <ext:Column runat="server" Text="Size" DataIndex="Size" />
                            <ext:Column runat="server" Text="Visible" DataIndex="Visible" Align="Center">
                                <Renderer Handler="return (value) ? 'Yes':'No';" />
                            </ext:Column>
			            </Columns>
                    </ColumnModel>                    
                    <Features>
                        <ext:GridFilters ID="GridFilters1" runat="server">
                            <Filters>
                                <ext:NumericFilter DataIndex="Id" />
                                <ext:StringFilter DataIndex="Company" />
                                <ext:NumericFilter DataIndex="Price" />
                                <ext:DateFilter DataIndex="Date">
                                    <DatePickerOptions runat="server" TodayText="Now" />
                                </ext:DateFilter>
                                <ext:ListFilter DataIndex="Size" Options="extra small,small,medium,large,extra large" />
                                <ext:BooleanFilter DataIndex="Visible" />
                            </Filters>
                        </ext:GridFilters>
                    </Features>
                    <BottomBar>
                        <ext:PagingToolbar runat="server" />
                    </BottomBar>
                </ext:GridPanel>
            </Items>
        </ext:Window>    
    </form>
</body>
</html>