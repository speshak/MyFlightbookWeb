﻿<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" Codebehind="ACSchedule.aspx.cs" Inherits="Member_ACSchedule" culture="auto" meta:resourcekey="PageResource1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Register src="../Controls/mfbEditAppt.ascx" tagname="mfbEditAppt" tagprefix="uc1" %>
<%@ Register src="../Controls/mfbResourceSchedule.ascx" tagname="mfbResourceSchedule" tagprefix="uc2" %>
<%@ Register src="../Controls/ClubControls/SchedSummary.ascx" tagname="SchedSummary" tagprefix="uc3" %>
<%@ Register src="../Controls/ClubControls/TimeZone.ascx" tagname="TimeZone" tagprefix="uc4" %>
<%@ Register src="../Controls/popmenu.ascx" tagname="popmenu" tagprefix="uc5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cpTopForm" Runat="Server">
    <script src='<%= ResolveUrl("~/public/Scripts/daypilot-all.min.js?v=20210821") %>'></script>
    <script src='<%= ResolveUrl("~/public/Scripts/mfbcalendar.js?v=3") %>'></script>
    <uc1:mfbEditAppt ID="mfbEditAppt1" runat="server" />
    <asp:MultiView ID="mvStatus" runat="server">
        <asp:View ID="vwNoClub" runat="server">
            <p><asp:Label ID="lblTailNumber3" runat="server" Font-Bold="True" meta:resourcekey="lblTailNumber3Resource1"></asp:Label> - <asp:Localize ID="locNoClub" runat="server" Text="This aircraft is not in a club." meta:resourcekey="locNoClubResource1"></asp:Localize></p>
            <p><asp:HyperLink ID="lnkCreateClub" runat="server" Text="Create a club" NavigateUrl="~/Public/Clubs.aspx?noredir=1" meta:resourcekey="lnkCreateClubResource1"></asp:HyperLink></p>
        </asp:View>
        <asp:View ID="vwNotMember" runat="server">
            <p><asp:Label ID="lblTailNumber2" runat="server" Font-Bold="True" meta:resourcekey="lblTailNumber2Resource1"></asp:Label> - <asp:Localize ID="locNotMember" runat="server" Text="This aircraft belongs to the club(s) listed below, but you are not a member.  View details for the club to request membership." meta:resourcekey="locNotMemberResource1"></asp:Localize></p>
            <asp:Repeater ID="rptClubsForAircraft" runat="server">
                <ItemTemplate>
                    <h3><asp:HyperLink ID="lnkClub" NavigateUrl='<%# String.Format("~/Member/ClubDetails.aspx/{0}", Eval("ID")) %>' runat="server"><%#: Eval("Name") %></asp:HyperLink></h3>
                </ItemTemplate>
            </asp:Repeater>
        </asp:View>
        <asp:View ID="vwMember" runat="server">
            <script>
                var clubCalendars = [];
                var clubNavControl;

                function updateDate(d)
                {
                    // create a new date that is local but looks like this one.
                    var d2 = new Date(d.getTime() + new Date().getTimezoneOffset() * 60000);
                    document.getElementById('<% = lblDate.ClientID %>').innerHTML = d2.toDateString();
                }

                function refreshAllCalendars(args) {
                    for (i = 0; i < clubCalendars.length; i++) {
                        var cc = clubCalendars[i];
                        cc.dpCalendar.startDate = args.day;
                        cc.dpCalendar.update();
                        updateDate(args.day);
                        $find('cpeDate').set_collapsed(true);
                        cc.refreshEvents(); 
                    }
                }

                function InitClubNav(cal) {
                    clubCalendars[clubCalendars.length] = cal;
                    if (typeof clubNavControl == 'undefined') {
                        clubNavControl = cal.initNav('<% =pnlDateSelector.ClientID %>');
                        clubNavControl.cellHeight = clubNavControl.cellWidth = 40;
                        clubNavControl.onTimeRangeSelected = refreshAllCalendars;   // override the default function
                        clubNavControl.select(new DayPilot.Date());
                        updateDate(new DayPilot.Date());
                    }
                }

                function incrementDay(i) {
                    clubNavControl.select(clubNavControl.selectionDay.addDays(i));
                }

                function nextDay() {
                    incrementDay(1);
                }

                function prevDay() {
                    incrementDay(-1);
                }
            </script>
            <asp:Panel ID="pnlChangeDatePop" runat="server" meta:resourcekey="pnlChangeDatePopResource1" style="padding:2px; width:100%; background-color:lightgray; line-height: 30px; z-index:100; height:30px; position:fixed; top: 0px; left: 0px; text-align:center;">
                <span style="font-family:Arial;font-size:16pt; margin-left: 1em; margin-right: 1em; vertical-align:middle; float:left;" onclick="prevDay();">◄</span>
                <asp:Label ID="lblTailNumber" Font-Bold="True" Font-Size="Larger" style="vertical-align:middle" runat="server" meta:resourcekey="lblTailNumberResource1"></asp:Label> - 
                <asp:Label ID="lblDatePicker" runat="server">
                    <asp:Image ID="imgCalendar" runat="server" ImageUrl="~/images/CalendarPopup.png" style="display:inline-block; margin-right: 5px; vertical-align:middle;" meta:resourcekey="imgCalendarResource1" />
                    <asp:Label ID="lblDate" runat="server" Font-Bold="True" style="display:inline-block; line-height:normal; vertical-align:middle" meta:resourcekey="lblDateResource1"></asp:Label>
                </asp:Label>
                <span style="font-family:Arial;font-size:16pt; margin-left: 1em; margin-right: 1em; float:right; vertical-align:middle" onclick="nextDay();">►</span>
            </asp:Panel>
            <asp:Panel ID="pnlChangeDate" runat="server" HorizontalAlign="Center" CssClass="modalpopup" style="display:none; text-size-adjust: 125%" BackColor="White" meta:resourcekey="pnlChangeDateResource1">
                <asp:Panel ID="pnlDateSelector" runat="server" style="margin-left: auto; margin-right: auto;" meta:resourcekey="pnlDateSelectorResource1"></asp:Panel>
            </asp:Panel>
            <cc1:CollapsiblePanelExtender ID="cpeDate" runat="server"
                ExpandedText="<%$ Resources:LocalizedText, ClickToHide %>" CollapsedText ="<%$ Resources:LocalizedText, ClickToShow %>"
                ExpandControlID="lblDatePicker" CollapseControlID="lblDatePicker" BehaviorID="cpeDate"
                Collapsed="true" TargetControlID="pnlChangeDate" TextLabelID="lblShowHide">
            </cc1:CollapsiblePanelExtender>
            <div style="margin-top: 50px;">
                <asp:Repeater ID="rptSchedules" runat="server" OnItemDataBound="rptSchedules_ItemDataBound">
                    <ItemTemplate>
                        <div style="clear:both;" class="hostedSchedule">
                            <h3><asp:HyperLink ID="lnkClub" NavigateUrl='<%# String.Format("~/Member/ClubDetails.aspx/{0}", Eval("ID")) %>' runat="server"><%# Eval("Name") %></asp:HyperLink></h3>
                            <style type="text/css">
                                p, div, h2, h3, topTab, a.topTab, a.topTab:visited, #menu-bar .topTab, #menu-bar .current a, #menu-bar a.topTab:hover, #menu-bar li:hover > a {
                                    color: unset;
                                }
                            </style>
                            <uc2:mfbResourceSchedule ID="schedAircraft" NavInitClientFunction="InitClubNav" HideNavContainer="true" ShowResourceDetails="false" ClubID='<%# Eval("ID") %>' ResourceID="<%# AircraftID.ToString() %>" runat="server">
                            </uc2:mfbResourceSchedule>
                            <asp:Label ID="lblUpcoming" runat="server" Text="Upcoming scheduled items:" meta:resourcekey="lblUpcomingResource1"></asp:Label>
                            <uc3:SchedSummary ID="schedSummary" runat="server" UserName="<%# Page.User.Identity.Name %>" ResourceName="<%# AircraftID.ToString() %>" ClubID='<%# Eval("ID") %>' />
                            <br />
                            <br />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
