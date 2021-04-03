<%@ Page Language="C#" MasterPageFile="~/main.master" Title="Free Online Beck's Anxiety & Depression Inventory" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        Examination exam = (Examination)Session["questions"];
        DataList1.DataSource = exam.questions;
        //Label1.Text = "Patient ID: " + exam.mid.ToString;
        Label1.Text = "Subject: " + exam.sname;
        Label2.Text = "------- Patient ID: " + exam.mid;
        Label3.Text = "-------- Score: " + exam.score;
        Label4.Text = "-------- Diagnosis: " + exam.diagnosis;
        // If subject is ADHD Adult - Part A or B or Child ADD/ADHD, then display shaded_score
        if ((exam.sid == 3) || (exam.sid == 4) || (exam.sid == 6))
            Label5.Text = "-------- Shaded Score: " + exam.shaded_score;
        else if ((exam.sid == 6) && exam.first3flag)
            Label5.Text = "-------- Had 'Yes' answer on 1-3";
        Label6.Text = "-------- Date: " + DateTime.Now;

        DataList1.DataBind();
    }

    void printPage()
    {
        ClientScript.RegisterClientScriptBlock(this.GetType(), "TestScript", "window.print();",true);
    }

    protected void DataList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void PrintButton_Click(object sender, EventArgs e)
    {
        ClientScript.RegisterClientScriptBlock(this.GetType(), "TestScript", "window.print();",true);
        /*        object em =null;
        axW.ExecWB(SHDocVw.OLECMDID.OLECMDID_PRINT, 
                   SHDocVw.OLECMDEXECOPT.OLECMDEXECOPT_PROMPTUSER, 
                   ref em, ref em);
        */
    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="Label1" runat="server"></asp:Label>
    <asp:Label ID="Label2" runat="server"></asp:Label>
    <asp:Label ID="Label3" runat="server"></asp:Label>
    <asp:Label ID="Label4" runat="server"></asp:Label>
    <asp:Label ID="Label5" runat="server"></asp:Label>
    <asp:Label ID="Label6" runat="server"></asp:Label>
    <asp:DataList ID="DataList1" runat="server" Width="100%" OnSelectedIndexChanged="DataList1_SelectedIndexChanged">
    <HeaderTemplate>
     <a href="takeexam.aspx">Main Menu</a>
     <asp:LinkButton ID="PrintButton" runat="server" CausesValidation="False" OnClick="PrintButton_Click">Print This Page</asp:LinkButton> 
     <h2>Review Questions</h2>
     <hr size="5" style="color:red" />
    </HeaderTemplate>
    
    <ItemTemplate>
    <pre style="color:Red;background-color:#eeeeee"><%# DataBinder.Eval( Container.DataItem,"QuestionText")%></pre>
    
    <pre>1.<%# DataBinder.Eval( Container.DataItem,"Answer1") %></pre>
    <pre>2.<%# DataBinder.Eval( Container.DataItem,"Answer2") %></pre>
    <pre>3.<%# DataBinder.Eval( Container.DataItem,"Answer3") %></pre>
    <pre>4.<%# DataBinder.Eval( Container.DataItem,"Answer4") %></pre>
    <pre>5.<%# DataBinder.Eval( Container.DataItem,"Answer5") %></pre>
    <%--<pre>Correct Answer :<%# DataBinder.Eval( Container.DataItem,"CorrectAnswer") %></pre>--%>
    <pre>Your Answer    :<%# DataBinder.Eval( Container.DataItem,"YourAnswer") %></pre>
    </ItemTemplate>
    
     <SeparatorTemplate>
     <hr size="2" style="color:Red" />
    </SeparatorTemplate>
    
    <FooterTemplate>
      <hr size="5" style="color:red" />
      <a href="takeexam.aspx">Main Menu</a> 
    </FooterTemplate>
    </asp:DataList>
</asp:Content>

