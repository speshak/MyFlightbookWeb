using MyFlightbook;
using System;
using System.Configuration;
using System.Globalization;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;

/******************************************************
 * 
 * Copyright (c) 2007-2021 MyFlightbook LLC
 * Contact myflightbook-at-gmail.com for more information
 *
*******************************************************/

public partial class Public_ContactMe : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            rowAttach.Visible = Page.User.Identity.IsAuthenticated;

            Master.SelectedTab = tabID.tabHome;
            Title = Resources.LocalizedText.ContactUsTitle;
            if (User.Identity.IsAuthenticated)
            {
                Profile pf = MyFlightbook.Profile.GetUser(User.Identity.Name);
                txtName.Text = pf.UserFullName;
                txtEmail.Text = pf.Email;
            }

            string szEmail = util.GetStringParam(Request, "email");
            string szSubject = util.GetStringParam(Request, "subj");

            if (szEmail.Length > 0)
            {
                txtEmail.Text = HttpUtility.HtmlEncode(szEmail);
                txtName.Text = HttpUtility.HtmlEncode(Profile.GetUser(Membership.GetUserNameByEmail(szEmail)).UserFullName);
            }
            if (szSubject.Length > 0)
                txtSubject.Text = HttpUtility.HtmlEncode(szSubject);
        }
    }
    protected void btnSend_Click(object sender, EventArgs e)
    {
        if (Page.IsValid && NoBot1.IsValid())
        {
            MailAddress ma = new MailAddress(txtEmail.Text, txtName.Text);

            string szBody = String.Format(CultureInfo.InvariantCulture, "{0}\r\n\r\nUser = {1}\r\n{2}\r\nSent: {3}", txtComments.Text, (User.Identity.IsAuthenticated ? User.Identity.Name : "anonymous"), txtEmail.Text, DateTime.Now.ToLongDateString());
            string szSubject = String.Format(CultureInfo.CurrentCulture, "{0} - {1}", Branding.CurrentBrand.AppName, txtSubject.Text);
            using (MailMessage msg = new MailMessage()
            {
                From = new MailAddress(Branding.CurrentBrand.EmailAddress, String.Format(CultureInfo.InvariantCulture, Resources.SignOff.EmailSenderAddress, Branding.CurrentBrand.AppName, txtName.Text)),
                Subject = szSubject,
                Body = szBody
            })
            {
                if (fuFile.HasFiles)
                {
                    foreach (HttpPostedFile pf in fuFile.PostedFiles)
                        msg.Attachments.Add(new Attachment(pf.InputStream, pf.FileName, pf.ContentType));
                }
                msg.ReplyToList.Add(ma);
                util.AddAdminsToMessage(msg, true, ProfileRoles.maskCanContact);
                util.SendMessage(msg);
            }

            mvContact.SetActiveView(vwThanks);

            string szOOF = ConfigurationManager.AppSettings["UseOOF"];

            if (!String.IsNullOrEmpty(szOOF) && String.Compare(szOOF, "yes", StringComparison.Ordinal) == 0)
                util.NotifyUser(szSubject, Branding.ReBrand(Resources.EmailTemplates.ContactMeResponse), ma, false, false);

            // if this was done via iPhone/iPad (i.e., popped up browser), suppress the "return" link.
            if (util.GetIntParam(Request, "noCap", 0) != 0)
                lnkReturn.Visible = false;
        }
    }
}
