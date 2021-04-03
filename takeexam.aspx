<%@ Page Language="C#" MasterPageFile="~/main.master" Title="Free Online Beck's Anxiety & Depression Inventory" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack && (Session["mid"].ToString() != null))
            Label1.Text = "Patient ID: " + Session["mid"].ToString();
    }

    protected void btnStart_Click(object sender, EventArgs e)
    {
        String sid,sname;

        sid = ddlSubjects.SelectedItem.Value;
        sname = ddlSubjects.SelectedItem.Text;
        Examination exam = new Examination(Int32.Parse(Session["mid"].ToString()), Int32.Parse(sid), sname);
        exam.GetQuestions();
        Session.Add("questions", exam);
        Response.Redirect("examination.aspx");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>Take Examination&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label1" runat="server"></asp:Label>
    </h2>
    Select Specific Inventory :
    <asp:DropDownList ID="ddlSubjects" runat="server" DataSourceID="SqlDataSource1" DataTextField="sname"
        DataValueField="sid" Width="550px">
    </asp:DropDownList><br />
    <br />
    <asp:Button ID="btnStart" runat="server" Text="Start Exam" OnClick="btnStart_Click" /><br />
    <p/>
    <b>Note</b>
    <ul>
    <!-- <li>Each exam contains 5 question.</li> -->
    <li>Use Next and Previous buttons to navigate between questions</li><li>Result is displayed after the last questions is answered</li><li>CANCEL button can be used to cancel</li>
    <!-- <li>No time limitation. However the time taken is stored in database</li> -->
    </ul>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:examConnectionString %>"
        SelectCommand="SELECT [sid], [sname] FROM [oe_subjects] order by sid ASC"></asp:SqlDataSource>
</asp:Content>

