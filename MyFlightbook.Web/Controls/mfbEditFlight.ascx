<%@ Control Language="C#" AutoEventWireup="true" Codebehind="mfbEditFlight.ascx.cs" Inherits="MyFlightbook.Controls.FlightEditing.mfbEditFlight" %>
<%@ Register Src="mfbImageList.ascx" TagName="mfbImageList" TagPrefix="uc2" %>
<%@ Register Src="mfbTypeInDate.ascx" TagName="mfbTypeInDate" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register src="mfbFlightInfo.ascx" tagname="mfbFlightInfo" tagprefix="uc4" %>
<%@ Register src="mfbMultiFileUpload.ascx" tagname="mfbMultiFileUpload" tagprefix="uc5" %>
<%@ Register src="mfbDecimalEdit.ascx" tagname="mfbDecimalEdit" tagprefix="uc7" %>
<%@ Register src="mfbVideoEntry.ascx" tagname="mfbVideoEntry" tagprefix="uc12" %>
<%@ Register src="mfbEditPropSet.ascx" tagname="mfbEditPropSet" tagprefix="uc13" %>
<%@ Register src="mfbFlightProperties.ascx" tagname="mfbFlightProperties" tagprefix="uc10" %>
<%@ Register src="mfbTooltip.ascx" tagname="mfbTooltip" tagprefix="uc14" %>
<%@ Register Src="~/Controls/mfbTooltip.ascx" TagPrefix="uc1" TagName="mfbTooltip" %>
<%@ Register Src="~/Controls/popmenu.ascx" TagPrefix="uc1" TagName="popmenu" %>
<asp:Panel ID="pnlContainer" runat="server" DefaultButton="btnAddFlight" 
    meta:resourcekey="pnlContainerResource1">
    <div class="flightinfoblock">
        <div class="header">
            <asp:Label ID="lblSectionGeneralInfo" runat="server" Text="General Flight Info" 
                meta:resourcekey="Label6Resource1"></asp:Label>
        </div>
        <div>
            <div class="itemtime">
                <div class="itemlabel"><asp:Label ID="Label7" runat="server" Text="Date of Flight" 
                        meta:resourcekey="Label7Resource1"></asp:Label></div>
                <div class="itemdata">
                    <uc1:mfbTypeInDate ID="mfbDate" runat="server" DefaultType="Today" Width="90%" />
                    <div>
                    <asp:CustomValidator ID="valDate" runat="server" ErrorMessage="Date of flight should be today or in the past." CssClass="error"
                        onservervalidate="valDate_ServerValidate" Display="Dynamic" 
                        meta:resourcekey="valDateResource1"></asp:CustomValidator></div>
                </div>
            </div>
            <div class="itemtime">
                <div class="itemlabel"><asp:Label ID="Label8" runat="server" Text="Aircraft:" 
                        meta:resourcekey="Label8Resource1"></asp:Label>
                    <asp:LinkButton ID="lnkAddAircraft" runat="server" CausesValidation="False" 
                        onclick="lnkAddAircraft_Click" Text="(Add...)" 
                        meta:resourcekey="lnkAddAircraftResource1"></asp:LinkButton>
                </div>
                <div class="itemdata">
                    <asp:DropDownList ID="cmbAircraft" runat="server" Width="90%" AutoPostBack="true" OnSelectedIndexChanged="cmbAircraft_SelectedIndexChanged" 
                        meta:resourcekey="cmbAircraftResource1">
                    </asp:DropDownList>
                    <script>
                        function currentlySelectedAircraft() {
                            return document.getElementById('<% =cmbAircraft.ClientID %>').value;
                        }
                    </script>
                    <div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="cmbAircraft" Display="Dynamic"
                        CssClass="error" 
                        ErrorMessage='Please select an aircraft, or click "Add" to add a new one' 
                        meta:resourcekey="RequiredFieldValidator2Resource1"></asp:RequiredFieldValidator>
                    </div>
                    <div>
                        <asp:Label ID="lblShowCatClass" runat="server" CssClass="fineprint" 
                        meta:resourcekey="lblShowCatClassResource1"></asp:Label>
                        <uc14:mfbTooltip ID="mfbTooltip1" runat="server" BodyContent="<%$ Resources:LocalizedText, EditFlightAltCatclassTooltip %>" />
                    </div>
                </div>
                <asp:Panel ID="pnlAltCatClass" runat="server" CssClass="flightinfoitem" 
                    Height="0px" style="overflow:hidden; padding-bottom:4px;" 
                    meta:resourcekey="pnlAltCatClassResource1">
                        <asp:DropDownList ID="cmbCatClasses" runat="server" AppendDataBoundItems="true"  DataValueField="IDCatClassAsInt" 
                            DataTextField="CatClass" EnableViewState="false" 
                            meta:resourcekey="cmbCatClassesResource1">
                            <asp:ListItem Selected="True" Value="0" Text="<%$ Resources:LocalizedText, EditFlightDefaultCatClass %>"></asp:ListItem>
                        </asp:DropDownList>
                </asp:Panel>
                <cc1:CollapsiblePanelExtender ID="cpeAltCatClass" runat="server" 
                    CollapseControlID="lblShowCatClass" ExpandControlID="lblShowCatClass" CollapsedText="<%$ Resources:LocalizedText, ClickToShowAlternateCatClass %>"
                 ExpandedText="<%$ Resources:LocalizedText, ClickToHideAlternateCatClass %>" 
                    TargetControlID="pnlAltCatClass" TextLabelID="lblShowCatClass" Collapsed="True" 
                    Enabled="True" >
                </cc1:CollapsiblePanelExtender>
            </div>
            <div class="itemtime">
                <div class="itemlabel">
                    <asp:Label ID="Label9" runat="server" Text="Route:" 
                        meta:resourcekey="Label9Resource1"></asp:Label>
                    <uc14:mfbTooltip ID="mfbTooltip2" runat="server" BodyContent="<%$ Resources:Airports, MapNavaidTip %>" />
                </div>
                <div class="itemdata">
                    <asp:TextBox ID="txtRoute" runat="server" Font-Size="Small" 
                        Width="90%" meta:resourcekey="txtRouteResource1"></asp:TextBox>
                </div>
            </div>
            <div class="itemtime">
                <div class="itemlabel"><asp:Label ID="Label10" runat="server" Text="Comments:" 
                        meta:resourcekey="Label10Resource1"></asp:Label>
                </div>
                <div class="itemdata">
                    <div style="position:relative; display:inline-block">
                        <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" dir="auto" Font-Names="Arial"
                            Font-Size="Small" Rows="2" Width="90%" 
                            meta:resourcekey="txtCommentsResource1"></asp:TextBox>
                    </div>
                    <script type="text/javascript">
                        autoInsert(document.getElementById("<% =txtComments.ClientID %>"), '<% =ResolveUrl("~/Member/LogbookNew.aspx/SuggestTraining") %>', '[');
                    </script> 
                </div>
            </div>
        </div>
    </div>
    <div class="timesblock">
        <div class="header">
            <asp:Localize ID="locLandingsHeader" runat="server" Text="<%$ Resources:LogbookEntry, HeaderApproachesLandings %>" />
        </div>
        <div class="itemtimeleft">
            <div id="divApproaches" class="itemlabel"><asp:Label ID="Label11" runat="server" 
                    Text="Approaches" meta:resourcekey="Label11Resource1"></asp:Label>
                <uc14:mfbTooltip ID="mfbTooltip3" runat="server" BodyContent="<%$ Resources:LocalizedText, EditFlightApproachTooltip %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="intApproaches" EditingMode="Integer" Width="40px" runat="server" />&nbsp;<asp:CheckBox 
                    ID="ckHold" runat="server" Text="Hold" 
                    meta:resourcekey="ckHoldResource1" />
                    
            </div>
        </div>
        <div class="itemtimeright">
            <div id="divLandings" class="itemlabel"><asp:Label ID="Label12" runat="server" 
                    Text="Total Landings" meta:resourcekey="Label12Resource1"></asp:Label> 
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="intLandings" EditingMode="Integer" Width="40px" runat="server" />
                <asp:CustomValidator ID="valCheckFullStop" 
                    OnServerValidate="CheckFullStopCount" runat="server" ErrorMessage="Total landings must be greater than or equal to the number of full stop landings"
                    CssClass="error" Display="Dynamic" 
                    meta:resourcekey="valCheckFullStopResource1"></asp:CustomValidator>
            </div>
        </div>
        <div class="itemtimeright">
            <div>
                <div class="itemlabel">
                    <asp:Label ID="Label13" runat="server" Text="Full Stop (Day):" meta:resourcekey="Label13Resource1"></asp:Label>
                </div>
                <div class="itemdata">
                    <uc7:mfbDecimalEdit ID="intFullStopLandings" EditingMode="Integer" Width="40px" runat="server" />
                </div>
            </div>
        </div>
        <div class="itemtimeright">
            <div>
                <div class="itemlabel">
                    <asp:Label ID="Label14" runat="server" Text="Full Stop (Night):" meta:resourcekey="Label14Resource1"></asp:Label>
                </div>
                <div class="itemdata">
                    <uc7:mfbDecimalEdit ID="intNightLandings" EditingMode="Integer" Width="40px" runat="server" />
                </div>
            </div>
        </div>
    </div>
    <asp:Panel runat="server" ID="pnlTimeRoot" class="timesblock">
        <div class="header">
            <asp:Localize ID="locTimesHeader" runat="server" Text="<%$ Resources:LogbookEntry, HeaderTimes %>" />
        </div>
        <asp:Panel ID="pnlXC" runat="server" CssClass="itemtimeleft">
            <div id="divXC" class="itemlabel"><asp:Label ID="Label15" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldCrossCountry %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decXC" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlNight" runat="server" CssClass="itemtimeright">
            <div id="divNight" class="itemlabel"><asp:Label ID="Label16" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldNight %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decNight" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlSimIFR" runat="server" CssClass="itemtimeleft">
            <div id="divSimIFR" class="itemlabel"><asp:Label ID="Label17" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldSimIMCFull %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decSimulatedIFR" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlIMC" runat="server" CssClass="itemtimeright">
            <div id="divIMC" class="itemlabel"><asp:Label ID="Label18" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldIMC %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decIMC"  Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlGrndSim" runat="server" CssClass="itemtimeleft">
            <div id="divGroundSim" class="itemlabel"><asp:Label ID="Label19" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldGroundSimFull %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decGrndSim" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlDual" runat="server" CssClass="itemtimeright">
            <div id="divDual" class="itemlabel"><asp:Label ID="Label20" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldDual %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decDual" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlCFI" runat="server" CssClass="itemtimeleft">
            <div class="itemlabel"><asp:Label ID="Label21" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldCFI %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decCFI" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlSIC" runat="server" CssClass="itemtimeright">
            <div id="div1" class="itemlabel"><asp:Label ID="Label22" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldSIC %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decSIC" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlPIC" runat="server" CssClass="itemtimeleft">
            <div id="divPIC" class="itemlabel"><asp:Label ID="Label23" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldPIC %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decPIC" Width="40px" runat="server" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlTotal" runat="server" CssClass="itemtimeright">
            <div id="divTotal" class="itemlabel"><asp:Label ID="Label24" runat="server" 
                    Text="<%$ Resources:LogbookEntry, FieldTotalFull %>" />
            </div>
            <div class="itemdata">
                <uc7:mfbDecimalEdit ID="decTotal" Width="40px" runat="server" /> 
            </div>
        </asp:Panel>
    </asp:Panel>
    <div id="rowTimes7" class="fullblock">
        <asp:MultiView ID="mvPropEdit" runat="server" ActiveViewIndex="0">
            <asp:View ID="vwPropSet" runat="server">
                <uc13:mfbEditPropSet ID="mfbEditPropSet1" runat="server" />
            </asp:View>
            <asp:View ID="vwLegacyProps" runat="server">
                <uc10:mfbFlightProperties ID="mfbFlightProperties1" Enabled="false" runat="server" />
            </asp:View>
        </asp:MultiView>
    </div>
    <asp:Panel ID="pnlFlightDetailsContainer" runat="server" CssClass="fullblock" 
        meta:resourcekey="pnlFlightDetailsContainerResource1">
        <div runat="server" id="FlightDetailsHeader" class="header">
            <asp:Label ID="Label1" runat="server" 
                Text="Times and Telemetry" meta:resourcekey="Label1Resource1"></asp:Label>&nbsp;<asp:Label 
                ID="lblExpandCollapse" runat="server" 
                meta:resourcekey="lblExpandCollapseResource1"></asp:Label>
        </div>
        <asp:Panel ID="pnlFlightDetails" runat="server" Height="0px" 
            style="overflow:hidden;" meta:resourcekey="pnlFlightDetailsResource1">
            <uc4:mfbFlightInfo ID="mfbFlightInfo1" runat="server" OnAutoFill="AutoFill" />
        </asp:Panel>
        <cc1:CollapsiblePanelExtender ID="cpeFlightDetails" runat="server" 
            TargetControlID="pnlFlightDetails" CollapsedSize="0" ExpandControlID="FlightDetailsHeader"
            CollapseControlID="FlightDetailsHeader" Collapsed="True" 
            CollapsedText="<%$ Resources:LocalizedText, ClickToShow %>" ExpandedText="<%$ Resources:LocalizedText, ClickToHide %>" 
            TextLabelID="lblExpandCollapse" Enabled="True"></cc1:CollapsiblePanelExtender>
    </asp:Panel>
    <asp:Panel ID="pnlPictures" runat="server" CssClass="fullblock" 
        meta:resourcekey="pnlPicturesResource1">
        <div class="header"><asp:Label ID="lblPixForFlight" runat="server" 
                Text="" meta:resourcekey="lblPixForFlightResource1"></asp:Label>
        </div>
        <div>
            <uc5:mfbMultiFileUpload ID="mfbMFUFlightImages" Mode="Ajax" Class="Flight" IncludeDocs="true" RefreshOnUpload="true" runat="server" OnFetchingGooglePhotos="Fetch_GooglePhotos" OnUploadComplete="mfbMFUFlightImages_UploadComplete" OnImportingGooglePhoto="mfbMFUFlightImages_GeotagPhoto" />
            <br />
            <uc2:mfbImageList ID="mfbFlightImages" ImageClass="Flight" IncludeDocs="true"
                runat="server" AltText="Images from flight" CanEdit="true" Columns="4" 
                MaxImage="-1" />
        </div>
        <div>
            <uc12:mfbVideoEntry ID="mfbVideoEntry1" CanDelete="true" runat="server" />
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlPublic" runat="server" CssClass="fullblock" 
        meta:resourcekey="pnlTwitterResource1">
        <div class="header">
            <asp:Label ID="lblSharingPrompt" runat="server" Text="Sharing" 
                meta:resourcekey="lblSharingPromptResource1"></asp:Label>
        </div>
        <p>
            <span style="vertical-align:middle">
                <asp:CheckBox ID="ckPublic" CssClass="itemlabel" runat="server" style="vertical-align:middle" 
                    meta:resourcekey="ckPublicResource1" />&nbsp;
                <asp:Label ID="Label4" AssociatedControlID="ckPublic" runat="server" 
                    CssClass="itemlabel" EnableViewState="False">
                    <asp:Image
                        ID="imgMFBPublic" runat="server" AlternateText="Share Flight Details" style="vertical-align:middle"
                        ImageUrl="~/images/mfbicon.png" EnableViewState="False" 
                        meta:resourcekey="imgMFBPublicResource1" />&nbsp;
                    <asp:Label ID="Label26" style="vertical-align:middle" 
                        AssociatedControlID="ckPublic" runat="server" 
                        CssClass="itemlabel" EnableViewState="False"
                        Text="Allow others to view details of this flight"
                        meta:resourcekey="Label26Resource1">
                    </asp:Label>
                </asp:Label>
                <uc1:mfbTooltip runat="server" ID="mfbTooltip">
                    <TooltipBody>
                        <asp:Literal ID="litSharingDesc" runat="server" Text="<%$ Resources:LocalizedText, sharingdescription %>"></asp:Literal>
                    </TooltipBody>
                </uc1:mfbTooltip>
            </span>
        </p>
    </asp:Panel>
    <asp:HiddenField ID="hdnItem" runat="server" Value="-1" />
    <asp:HiddenField ID="hdnPendingID" runat="server" Value="" />
    <script>
        function hideLint() {
            document.getElementById('<% = pnlFlightLint.ClientID %>').style.display = "none";
        }
    </script>
    <asp:UpdatePanel ID="updCheckFlights" runat="server">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="imgCheckFlights" />
        </Triggers>
        <ContentTemplate>
            <asp:Panel ID="pnlFlightLint" runat="server" Visible="false" EnableViewState="false" CssClass="hintPopup" style="display:block; width:80%; margin-top: 3px; margin-left: auto; margin-right:auto;">
                <div style="float:right"><asp:HyperLink ID="lnkClose" runat="server" onclick="javascript:hideLint()" NavigateUrl="javascript:void(0);" Text="<%$ Resources:LocalizedText, Close %>"></asp:HyperLink></div>
                <asp:GridView ID="gvFlightLint" runat="server" AutoGenerateColumns="false" ShowHeader="false" EnableViewState="false" ShowFooter="false" GridLines="None">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <ul>
                                    <asp:Repeater ID="rptIssues" runat="server" DataSource='<%# Eval("Issues") %>'>
                                        <ItemTemplate>
                                            <li><%#: Eval("IssueDescription") %></li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <p><asp:Label ID="lblNoIssues" runat="server" Text="<%$ Resources:FlightLint, CheckFlightsNoIssuesFound %>"></asp:Label></p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </asp:Panel>
            <script>
                <% if (!IsPostBack && util.GetIntParam(Request, "Chk", 0) != 0) { %>
                $(document).ready(function () {
                    document.getElementById('<% = imgCheckFlights.ClientID %>').click();
                });
                <% } %>
            </script>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Panel ID="pnlSubmit" runat="server" CssClass="fullblock" meta:resourcekey="pnlSubmitResource1">
        <div style="float:right"><asp:ImageButton ID="imgCheckFlights" runat="server" OnClick="lnkCheckFlight_Click" ToolTip="<%$ Resources:FlightLint, TitleCheckThisFlight %>" ImageUrl="~/images/CheckFlights.png" /></div>
        <table style="margin-left:auto; margin-right: auto;">
            <tr style="vertical-align:top;">
                <td>
                    <asp:Button ID="btnCancel" runat="server" Text="<%$ Resources:LogbookEntry, EditFlightInlineCancel %>" OnClick="btnCancel_Click" Visible="false" />&nbsp;&nbsp;
                    <asp:Button ID="btnAddFlight" runat="server" Text="Add Flight" 
                        OnClick="btnAddFlight_Click" 
                        meta:resourcekey="btnAddFlightResource1"/>
                </td>
                <td>
                    <uc1:popmenu runat="server" ID="popmenuCommitAndNavigate" Visible="false">
                        <MenuContent>
                            <div style="text-align:left">
                                <div runat="server" id="divUpdateNext" visible="false" style="margin: 3px;"><asp:Label ID="lblSpc" runat="server" Font-Names="Arial" Font-Size="Larger" Text="<%$ ResourceS:LogbookEntry, PreviousFlight %>" style="visibility:hidden" />&nbsp;<asp:LinkButton ID="lnkUpdateNext" runat="server" Text="<%$ Resources:LocalizedText, EditFlightUpdateFlightNext %>" OnClick="lnkUpdateNext_Click" />&nbsp;<asp:Label ID="LocNext" runat="server" Font-Names="Arial" Font-Size="Larger" Text="<%$ ResourceS:LogbookEntry, NextFlight %>" /></div>
                                <div runat="server" id="divUpdatePrev" visible="false" style="margin: 3px;"><asp:Label ID="lblSpc2" runat="server" Font-Names="Arial" Font-Size="Larger" Text="<%$ ResourceS:LogbookEntry, PreviousFlight %>" />&nbsp;<asp:LinkButton ID="lnkUpdatePrev" runat="server" Text="<%$ Resources:LocalizedText, EditFlightUpdateFlightPrev %>" OnClick="lnkUpdatePrev_Click"></asp:LinkButton></div>
                                <div runat="server" id="divUpdatePending" visible="false" style="margin: 3px"><asp:Label ID="lblSpc3" runat="server" Font-Names="Arial" Font-Size="Larger" Text="<%$ ResourceS:LogbookEntry, PreviousFlight %>" style="visibility:hidden" />&nbsp;<asp:LinkButton ID="lnkUpdatePending" runat="server" Text="<%$ Resources:LocalizedText, EditFlightUpdatePendingFlight %>" OnClick="lnkUpdatePending_Click" /></div>
                            </div>
                        </MenuContent>
                    </uc1:popmenu>
                    <uc1:popmenu runat="server" ID="popmenuPending" Visible="false">
                        <MenuContent>
                            <div style="text-align:left">
                                <div runat="server" style="margin: 3px;"><asp:LinkButton ID="lnkAddPending" runat="server" Text="Add Pending" OnClick="lnkAddPending_Click" meta:resourcekey="lnkAddPendingResource1" /></div>
                            </div>
                        </MenuContent>
                    </uc1:popmenu>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hdnNextID" runat="server" />
        <asp:HiddenField ID="hdnPrevID" runat="server" />
        <div><asp:Label ID="lblError" runat="server" CssClass="error" 
            EnableViewState="False" meta:resourcekey="lblErrorResource1"></asp:Label>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlSigEdits" runat="server" Visible="false">
        <p><asp:Label ID="lblChanges" runat="server" Text="<%$ Resources:LogbookEntry, CompareHeader %>"></asp:Label></p>
        <ul>
            <asp:Repeater ID="rptDiffs" runat="server">
                <ItemTemplate>
                    <li><%#: Container.DataItem.ToString() %></li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
    </asp:Panel>
    <asp:Panel ID="pnlAdminFixSignature" runat="server" Visible="false">
        <table>
            <tr>
                <td>Saved State:</td>
                <td><asp:Label ID="lblSigSavedState" runat="server" ></asp:Label></td>
            </tr>
            <tr>
                <td>Sanity check:</td>
                <td><asp:Label ID="lblSigSanityCheck" runat="server" ></asp:Label></td>
            </tr>
            <tr style="vertical-align:top; background-color: #E8E8E8">
                <td>Saved Hash:</td>
                <td><asp:Label ID="lblSigSavedHash" runat="server" ></asp:Label></td>
            </tr>
            <tr style="vertical-align:top;">
                <td>Current Hash:</td>
                <td><asp:Label ID="lblSigCurrentHash" runat="server" ></asp:Label></td>
            </tr>
            <tr>
                <td><asp:Button ID="btnAdminFixSignature" runat="server" Text="Fix Signature" OnClick="btnAdminFixSignature_Click" /></td>
                <td>(Set the state to match reality)</td>
            </tr>
            <tr>
                <td><asp:Button ID="btnAdminForceValid" runat="server" Text="Force Valid" OnClick="btnAdminForceValid_Click" /></td>
                <td>(Recompute the flight hash based on current values to force it to be valid)</td>
            </tr>
        </table>
    </asp:Panel>
</asp:Panel>
