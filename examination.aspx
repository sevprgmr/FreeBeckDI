<%@ Page Language="C#" MasterPageFile="~/main.master" Title="Free Online Beck's Anxiety & Depression Inventory" %>
<%--<%@ Page Language="C#" %>--%>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // get data from session object
        Examination exam = (Examination)Session["questions"];
        Question q = exam.questions[exam.curpos];
        // Determine the number of answers for this exam/subject
        if (q.ans3 == "")
            exam.num_question_answers = 2;
        else if (q.ans4 == "")
            exam.num_question_answers = 3;
        else if (q.ans5 == "")
            exam.num_question_answers = 4;
        else
            exam.num_question_answers = 5;
        if (!Page.IsPostBack)
            DisplayQuestion();
        
       
    }

    public void DisplayQuestion()
    {
        // get data from session object
        Examination e = (Examination)Session["questions"];
        // display data
        lblSubject.Text = e.sname;
        lblQno.Text = e.curpos + 1 + "/" + e.nquestions;
        lblCtime.Text = DateTime.Now.ToString();
        lblStime.Text = e.StartTime.ToString();

        Question q = e.questions[e.curpos];
        // display details of question
        question.InnerHtml = q.question;
        ans1.InnerHtml = q.ans1;
        ans2.InnerHtml = q.ans2;
        ans3.InnerHtml = q.ans3;
        ans4.InnerHtml = q.ans4;
        ans5.InnerHtml = q.ans5;
        
        // reset all radio buttons
        rbAns1.Checked = false;
        rbAns2.Checked = false;
        rbAns3.Checked = false;
        rbAns4.Checked = false;
        rbAns5.Checked = false;

        // disable and enable buttons
        if (e.curpos == 0)
            btnPrev.Enabled = false;
        else
            btnPrev.Enabled = true;

        if (e.curpos == e.nquestions - 1)
            btnNext.Text = "YOU ARE FINISHED - PLEASE NOTIFY STAFF";
        else
            btnNext.Text = "Next";
    }

    public void ProcessQuestion()
    {
        Examination exam = (Examination)Session["questions"];
        Question q = exam.questions[exam.curpos];
        String answer;
        // find out the answer and assign it to 
        if (rbAns1.Checked)
            answer = "1";
        else
            if (rbAns2.Checked)
                answer = "2";
            else
                if (rbAns3.Checked)
                {
                    if (exam.num_question_answers < 3)
                    {
                        Label1.Text = "Error! Invalid Selection";
                        exam.current_ans = 0;
                        answer = "0";
                        return;
                    }
                    answer = "3";
                }
                else
                    if (rbAns4.Checked)
                    {
                        if (exam.num_question_answers < 4)
                        {
                            Label1.Text = "Error! Invalid Selection";
                            exam.current_ans = 0;
                            answer = "0";
                            return;
                        }
                        answer = "4";
                    }
                    else
                        if (rbAns5.Checked)
                        {
                            if (exam.num_question_answers < 5)
                            { 
                                Label1.Text = "Error! Invalid Selection";
                                exam.current_ans = 0;
                                answer = "0";
                                return;
                            }
                            answer = "5";
                        }
                        else
                        {
                            answer = "0";  // error
                            Label1.Text = "Please select an answer to continue";
                            exam.current_ans = 0;
                            return;
                        }
        q.answer = answer;
        exam.questions[exam.curpos] = q;
        exam.current_ans = Convert.ToInt32(answer);
        Session.Add("questions", exam);
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        int i;
        
            ProcessQuestion();
            Examination exam = (Examination)Session["questions"];

            if (exam.current_ans != 0)
            {
                Label1.Text = "";
                // Is the exam finished?
                if (exam.curpos == (exam.nquestions - 1))
                {
                    // Here the exam is Finished
                    for (i = 0; i < exam.nquestions; i++)
                    {
                        Question q = exam.questions[i];
                        exam.current_ans = Convert.ToInt32(q.answer);
                        // What Subject is it?
                        switch (exam.sid)
                        {
                            case 1: case 2:
                                exam.ans_total = exam.ans_total + (exam.current_ans-1);
                                break;

                            // For ADHD Adult - Part A, keep up with the shaded area score                     
                            case 3:
                                exam.ans_total = exam.ans_total + exam.current_ans;
                                // Is the answer in the shaded area, questions 0-2?
                                if ((i < 3) && (exam.current_ans > 2))
                                    // Yes, answer is in the shaded area
                                    exam.shaded_score = exam.shaded_score + 1;
                                else
                                    // I the answer in the shaded area of questions 3-5
                                    if ((i > 2) && (exam.current_ans > 3))
                                        exam.shaded_score = exam.shaded_score + 1;
                                break;

                            // Here for ADHD Adult - Part B, tally the shaded score.  See Symtom Checklist
                            case 4:
                                exam.ans_total = exam.ans_total + exam.current_ans;
                                switch (i)
                                {
                                    case 2:
                                    case 5:
                                    case 9:
                                    case 11:
                                        // Is the answer in the shaded boxes?
                                        if (exam.current_ans > 2)
                                            exam.shaded_score = exam.shaded_score + 1;
                                        break;
                                    default:
                                        if (exam.current_ans > 3)
                                            exam.shaded_score = exam.shaded_score + 1;
                                        break;
                                }
                                break;

                            // Here for ADHD Child, Tally the shaded score.  See Symtom Checklist
                            case 6:
                                exam.ans_total = exam.ans_total + exam.current_ans;
                                // Is answer in the shaded area of questions 1-9?
                                if ((i < 9) && (exam.current_ans > 2))
                                    exam.shaded_score = exam.shaded_score + 1;
                                else if ((i > 8) && (exam.current_ans > 2)) // What about questions 10-18?  .curpos is relative to zero
                                    exam.shaded_score = exam.shaded_score + 1;
                                // Save the age string
                                switch (exam.current_ans)
                                {
                                    case 1:
                                        exam.age_string = ans1.InnerText;
                                        break;
                                    case 2:
                                        exam.age_string = ans2.InnerText;
                                        break;
                                    case 3:
                                        exam.age_string = ans3.InnerText;
                                        break;
                                    case 4:
                                        exam.age_string = ans4.InnerText;
                                        break;
                                    case 5:
                                        exam.age_string = ans5.InnerText;
                                        break;
                                }
                                // Save the problem area string for Child ADHD exam, it's the next to last question in the exam
                                if (i == (exam.nquestions - 2))
                                {
                                    switch (exam.current_ans)
                                    {
                                        case 1:
                                            exam.area_string = ans1.InnerText;
                                            break;
                                        case 2:
                                            exam.area_string = ans2.InnerText;
                                            break;
                                        case 3:
                                            exam.area_string = ans3.InnerText;
                                            break;
                                        case 4:
                                            exam.area_string = ans4.InnerText;
                                            break;
                                        case 5:
                                            exam.area_string = ans5.InnerText;
                                            break;
                                    }
                                }
                                break;

                            // Here for Initial Adult ADD/ADHD Checklist
                            case 9:
                                exam.ans_total = exam.ans_total + exam.current_ans;
                                // For the questions 1-3 do the yes/no score
                                if ((i < 3) && (exam.current_ans == 1))
                                {
                                    exam.score = exam.score + 4;
                                    exam.first3flag = true;
                                }
                                else if (exam.current_ans > 2)
                                    exam.score = exam.score + exam.current_ans;
                                break;

                            default:
                                exam.ans_total = exam.ans_total + exam.current_ans;
                                break;
                        } // End Switch
                    } // End for loop
                    
                    // Now determine the Diagnosis
                    switch (exam.sid)
                    {
                        case 1:     // Subject = Beck Depression Inventory

                            // Determine Diagnosis
                            if (exam.ans_total > 63)
                                exam.diagnosis = "Extreme Depression";
                            else if (exam.ans_total > 30)
                                exam.diagnosis = "Severe Depression";
                            else if (exam.ans_total > 19)
                                exam.diagnosis = "Moderate Depression";
                            else if (exam.ans_total > 10)
                                exam.diagnosis = "Mild Depression";
                            else
                                exam.diagnosis = "Minimal Depression";
                            exam.score = exam.ans_total;
                            break;

                        case 2:     // Subject = Beck Anxiety Inventory

                            exam.score = exam.ans_total;
                            // Determine Diagnosis
                            if (exam.ans_total > 63)
                                exam.diagnosis = "Extreme Anxiety";
                            else if (exam.ans_total > 30)
                                exam.diagnosis = "Severe Anxiety";
                            else if (exam.ans_total > 19)
                                exam.diagnosis = "Moderate Anxiety";
                            else if (exam.ans_total > 10)
                                exam.diagnosis = "Mild Anxiety";
                            else
                                exam.diagnosis = "Minimal Anxiety";
                            break;

                        // For ADHD Adult - Part A, keep up with the shaded area score                     
                        case 3:
                            if (exam.shaded_score > 3)
                                exam.diagnosis = "Highly Consistent With ADHD";
                            else
                                exam.diagnosis = "Not Consistent With ADHD";
                            exam.score = exam.ans_total;
                            break;

                        // Here for ADHD Adult - Part B, tally the shaded score.  See Symtom Checklist
                        case 4:
                            exam.diagnosis = "Not Utilized for this Exam";
                            exam.score = exam.ans_total;
                            break;

                        // Here for ADHD Child, Tally the shaded score.  See Symtom Checklist
                        case 6:
                            if (exam.shaded_score > 5)
                                exam.diagnosis = "Meets DSM-V Criteria for Adolescent & Child --- Symptoms Began at Age: " + exam.age_string + " --- Problem Area: " + exam.area_string;
                            else if (exam.shaded_score == 5)
                                exam.diagnosis = "Meets DSM-V Criteria for Adolescent Only --- Symptoms Began at Age: " + exam.age_string + " --- Problem Area: " + exam.area_string;
                            exam.score = exam.ans_total;
                            break;

                        // Here for Initial Adult ADD/ADHD Checklist
                        case 9:
                            if (exam.first3flag && ((exam.score > 19) && (exam.score < 40)))
                                exam.diagnosis = "Candidate For ADD Evaluation";
                            else if (exam.score > 40)
                                exam.diagnosis = "Probably Has ADD";
                            break;
                            
                        default: 
                            exam.score = exam.ans_total;
                            break;

                    } // End Switch
                    
                    // add row to pillcount_sa.oe_EXAMS table
                    SqlConnection con = new SqlConnection(DBUtil.ConnectionString);
                    con.Open();
                    SqlCommand cmd = new SqlCommand("select isnull( max(examid),0) + 1 from pillcount_sa.oe_exams", con);
                    int examid = (Int32)cmd.ExecuteScalar();
                    cmd.CommandText = "insert into pillcount_sa.oe_exams values(@examid,@mid,@sid,@noq,@score,@diagnosis,getdate())";
                    cmd.Parameters.Add("@examid", SqlDbType.Int).Value = examid;
                    cmd.Parameters.Add("@mid", SqlDbType.Int).Value = exam.mid;
                    cmd.Parameters.Add("@sid", SqlDbType.Int).Value = exam.sid;
                    cmd.Parameters.Add("@noq", SqlDbType.Int).Value = exam.nquestions;
                    cmd.Parameters.Add("@score", SqlDbType.Int).Value = exam.score;
                    cmd.Parameters.Add("@diagnosis", SqlDbType.VarChar).Value = exam.diagnosis;
                    cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = exam.StartTime;
                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Redirect("reviewquestions.aspx");
                }
                else
                {
                    // Exam is not Finished yet
                    exam.curpos++;
                    Session.Add("questions", exam);
                    DisplayQuestion();
                }
            }
    }

    protected void btnPrev_Click(object sender, EventArgs e)
    {
        // ProcessQuestion();
        Examination exam = (Examination)Session["questions"];
        exam.curpos--;
        Session.Add("questions", exam);
        DisplayQuestion();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        // Examination exam = (Examination)Session["questions"];
        Session.Remove("questions");
        //exam = null;
        Response.Redirect("takeexam.aspx");
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link rel="shortcut icon" href="~/favicon.ico"/>
    <title>Free Online Beck Anxiety & Depression Inventory</title>
</head>
<body style="height: 456px">
    <form id="form1" runat="server">
    <h2>Examination</h2>
    <table width="100%" bgcolor="#dddddd">
    <tr>
    <td>
        Subject :
        <asp:Label ID="lblSubject" runat="server" Width="154px" Font-Bold="True" Font-Names="Verdana" ForeColor="Red"></asp:Label></td>
    <td>
        Question :
        <asp:Label ID="lblQno" runat="server" Font-Bold="True" Font-Names="Verdana" ForeColor="Red"></asp:Label></td>
    </tr>
    <tr>
    <td>
        Started At :
        <asp:Label ID="lblStime" runat="server" Font-Bold="True" Font-Names="Verdana" ForeColor="Red"></asp:Label></td>
    <td style="height: 22px">
        Current Time :<asp:Label ID="lblCtime" runat="server" Font-Bold="True" Font-Names="Verdana" ForeColor="Red"></asp:Label></td>
    </tr>
    </table>
    
    <p />
    <b>Question</b>
    <br />
    <pre runat="server" id="question" style="background-color:#eeeeee">question</pre>
    <p></p>
    <table>
    <tr>
    <td>
    <asp:RadioButton ID="rbAns1" runat="server" GroupName="answer" />
    </td>
    <td style="width: 3px">
    <pre runat="server" id="ans1"></pre>
    </td>
    </tr>
    
    <tr>
    <td>
    <asp:RadioButton ID="rbAns2" runat="server" GroupName="answer" />
    </td>
    <td style="width: 3px">
    <pre runat="server" id="ans2"></pre>
    </td>
    </tr>
    
    <tr>
    <td>
    <asp:RadioButton ID="rbAns3" runat="server" GroupName="answer" />
    </td>
    <td style="width: 3px">
    <pre runat="server" id="ans3"></pre>
    </td>
    </tr>
    
    <tr>
    <td>
    <asp:RadioButton ID="rbAns4" runat="server" GroupName="answer" />
    </td>
    <td style="width: 3px">
    <pre runat="server" id="ans4"></pre>
    </td>
    </tr>

    <tr>
    <td>
    <asp:RadioButton ID="rbAns5" runat="server" GroupName="answer" />
    </td>
    <td style="width: 3px">
    <pre runat="server" id="ans5"></pre>
    </td>
    </tr>

    
    </table>
        <br />
        <asp:Button ID="btnPrev" runat="server" Text="Previous" OnClick="btnPrev_Click" />&nbsp;<asp:Button ID="btnNext"
            runat="server" Text="Next" Width="356px" OnClick="btnNext_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel Exam" Width="115px" OnClick="btnCancel_Click" />
        
        <br />
        <asp:Label ID="Label1" runat="server" ForeColor="#FF0066" Font-Bold="True"></asp:Label>
        
    </form>
</body>
</html>
