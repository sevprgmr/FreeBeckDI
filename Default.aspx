<%@ Page Language="C#"%>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        // check whether credentials are valid
        SqlConnection con = new SqlConnection(DBUtil.ConnectionString);

        try
        {
            // See if the username and password is valid here
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from pillcount_sa.oe_members where lname = @lname and pwd = @pwd", con);
            cmd.Parameters.Add("@lname", SqlDbType.VarChar, 40).Value = txtLname.Text;
            cmd.Parameters.Add("@pwd", SqlDbType.VarChar, 10).Value = txtPwd.Text;

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
                lblMsg.Text = "Sucessful Physician Login";
            else
            {
                lblMsg.Text = "Invalid Login!  Contact System Administrator for a valid Username & Password";
                dr.Close();
                return;
            }
            // See if the Patient ID exists here, If not add it
            dr.Close();
            SqlCommand cmd2 = new SqlCommand("select * from pillcount_sa.oe_members where mid = @mid", con);
            cmd2.Parameters.Add("@mid", SqlDbType.VarChar, 10).Value = txtPatientID.Text;
            SqlDataReader dr2 = cmd2.ExecuteReader();
            if (dr2.Read())
            {
                // Here the Patient ID already exists
                Session.Add("mid", dr2["mid"]);
                //Session.Add("fullname", dr["fullname"]);
                Session.Add("dlv", dr2["dlv"]);
                // update MEMBERS table for Date Last Visited
                dr2.Close();
                cmd2.CommandText = "update pillcount_sa.oe_members set dlv = getdate() where mid = @mid";
                cmd2.ExecuteNonQuery();
                lblMsg2.Text = "Patient ID was sucessfully found in the database Please click <a href=../takeexam.aspx>HERE</a> to Continue!";
            }
            else
            {
                // Here the Patient ID does not exist, so it needs to be added to the members table
                dr2.Close();
                cmd2.Parameters.Clear();
                // insert row into pillcount_sa.oe_MEMEBERS
                cmd2.CommandText = "insert into pillcount_sa.oe_members values(@mid,null,null,null,null,null,getdate())";
                cmd2.Parameters.Add("@mid", SqlDbType.Int).Value = txtPatientID.Text;
                Session.Add("mid", txtPatientID.Text);
                Session.Add("dlv", " ");
                if (cmd2.ExecuteNonQuery() > 0)
                    lblMsg2.Text = "Patient ID is new so it was successfully added to the database Please click <a href=../takeexam.aspx>HERE</a> to Continue!";
                else
                    lblMsg2.Text = "Sorry! Could not add Patient ID";
            }

        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error --> " + ex.Message;
        }
        finally
        {
            con.Close();
        }

    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link rel="shortcut icon" href="~/favicon.ico"/>
    <title>Free Online Beck's Anxiety & Depression Inventory</title>
</head>
<body>
<center>
    <form id="form1" runat="server">
    <div>
        <h1>Free Online Beck's Anxiety & Depression Inventory</h1>
        <br />
        <h3>
            Welcome To The Free Online Beck's Anxiety & Depression Inventory Website, Sponsored by Intervalidate, LLC
            <br />
            This Website has 10 Mental Health Self-Inventory Questionaires, including ADD/ADHD for Adolecents &amp; Adults</h3>
        <h4>Login</h4>
        <br />
        <table  bgcolor= "#eeeeee">
            <tr>
                <td>Username :</td>
                <td><asp:TextBox ID="txtLname" runat="server" Width="150px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtLname" ErrorMessage="Username is missing!" Font-Bold="True">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>Password :</td>
                <td><asp:TextBox ID="txtPwd" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPwd" ErrorMessage="Password is missing!" Font-Bold="True">*</asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>Patient ID :</td>
                <td><asp:TextBox ID="txtPatientID" runat="server" Width="150px" MaxLength="9"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtPatientID" ErrorMessage="Patient ID is missing!" Font-Bold="True">*</asp:RequiredFieldValidator></td>
            </tr>


<%--           <tr>
          <td colspan="2">
              <asp:CheckBox ID="chkRemember" runat="server" Text="Remember Me" /></td> 
           </tr> --%>
        </table>
        <br />
        <asp:Button ID="btnLogin" runat="server" Text="Login" Width="116px" OnClick="btnLogin_Click" /><br />
        <br />
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
        <br />
        <asp:Label ID="lblMsg2" runat="server"></asp:Label>
        <p>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="Please correct the following errors:" Font-Bold="True" />
        </p> 
<%--        <a href="all/newuser.aspx">New User?</a> 
        &nbsp; &nbsp; 
        <a href="all/forgotpassword.aspx">Forgot Password?</a>  --%>
        <br />
        <br />
        <br />
        <br />
        <asp:SqlDataSource ID="dsLogin" runat="server" ConnectionString="<%$ ConnectionStrings:examConnectionString %>"
            SelectCommand="select * from members where  mid = @mid">
            <SelectParameters>
                <asp:Parameter Name="mid" />
            </SelectParameters>
        </asp:SqlDataSource>
   
    </div>
    </form>
</center>    
</body>
</html>
