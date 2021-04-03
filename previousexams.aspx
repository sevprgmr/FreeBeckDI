<%@ Page Language="C#" MasterPageFile="~/main.master" Title="Free Online Beck's Anxiety & Depression Inventory" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
         Response.Write(" Value = " + Session["mid"]);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>
        Examinations History</h2>
    <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1"
        PageSize="3" BorderColor="Black" CellPadding="3" CellSpacing="2"  Width="100%" AllowPaging="True">
        <RowStyle Font-Names="Verdana" Font-Size="10pt" />
        <HeaderStyle BackColor="#0000C0" Font-Bold="True" Font-Names="Verdana" Font-Size="10pt"
            ForeColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:examConnectionString %>"
        SelectCommand="SELECT s.sname as 'Subject Name', e.noq as '# Questions', e.score as 'Score', e.diagnosis as 'Diagnosis', e.date as 'Date' FROM  pillcount_sa.oe_exams e, pillcount_sa.oe_subjects s&#13;&#10;where  e.sid = s.sid and mid = @mid&#13;&#10;order by date desc">
        <SelectParameters>
            <asp:SessionParameter Name="mid" SessionField="mid" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

