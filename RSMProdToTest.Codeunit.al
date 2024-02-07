/// <summary>
/// Codeunit RSM Prod to Test (ID 50084).
/// </summary>
codeunit 50084 "RSM Prod to Test"
{
    Permissions = tabledata "Sales Shipment Header" = m,
                  tabledata "Sales Invoice Header" = m,
                  tabledata "Sales Cr.Memo Header" = m,
                  tabledata "Purch. Rcpt. Header" = m,
                  tabledata "Purch. Inv. Header" = m,
                  tabledata "Purch. Cr. Memo Hdr." = m;

    var
        ThisCodeunitID: Integer;
        WindowDlg: Dialog;

        DisableJobQueEntriesLbl: Label 'Job Queue Entries';

        ModifyVDRSMRestSetupURLsLbl: Label 'Rest Interface Setup';
        ModifyVDRSMAEBCustomsSetupURLsLbl: Label 'AEB Customs Setup';

        OpenWindowLbl: Label 'Processing Prod to Test:\Modifies #1########', comment = '%1="Which table will be modified"';

    trigger OnRun()
    begin
        ThisCodeunitID := Codeunit::"RSM Prod to Test";

        OpenWindow(WindowDlg);
        ModifyCompanyInformation();

        UpdateWindow(WindowDlg, ModifyVDRSMRestSetupURLsLbl);
        ModifyVDRSMRestSetupURLs();

        UpdateWindow(WindowDlg, DisableJobQueEntriesLbl);
        DisableJobQueEntries();

        UpdateWindow(WindowDlg, ModifyVDRSMAEBCustomsSetupURLsLbl);
        ModifyVDRSMAEBCustomsSetupURLs();

        CloseWindow(WindowDlg);
    end;

    /// <summary>
    /// Modify Company Information
    /// </summary>
    local procedure ModifyCompanyInformation()
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get();
        CompanyInformation.Validate("Custom System Indicator Text", 'TEST');
        CompanyInformation.Validate("System Indicator", 1);
        CompanyInformation.Validate("System Indicator Style", 6);
        clear(CompanyInformation.Picture);
        CompanyInformation.Modify(true);
    end;

    /// <summary>
    /// Disables all Job Que Entries. The Status will be set to "On Hold".
    /// </summary>
    local procedure DisableJobQueEntries()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Reset();
        if JobQueueEntry.FindSet() then
            repeat
                if not CheckIfTheJobQueueEntryIsTheCurrentCodeunit(JobQueueEntry) then
                    JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");   //JobQueueEntry will be Modified in the procedure.
            until JobQueueEntry.Next() = 0;
    end;

    local procedure CheckIfTheJobQueueEntryIsTheCurrentCodeunit(JobQueueEntry: Record "Job Queue Entry"): Boolean
    begin
        exit((JobQueueEntry."Object Type to Run" = JobQueueEntry."Object Type to Run"::Codeunit) and (JobQueueEntry."Object ID to Run" = ThisCodeunitID));
    end;

    /// <summary>
    /// Modifies VDRSM Rest Setup to Change all Prod URLs to Test URLs.
    /// </summary>
    local procedure ModifyVDRSMRestSetupURLs()
    var
        VDRSMRestSetup: Record "VDRSM Rest Setup";
    begin
        VDRSMRestSetup.Get();
        VDRSMRestSetup.Validate("Item Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaatst');
        VDRSMRestSetup.Validate("Customer Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guakdst');
        VDRSMRestSetup.Validate("Inventory Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guabest');
        VDRSMRestSetup.Validate("Order Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaauan');
        VDRSMRestSetup.Validate("Order Response Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guapack');
        VDRSMRestSetup.Validate("Cust. Ord. Invt. Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guakola');
        VDRSMRestSetup.Validate("Inventory Request Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guainbe');
        VDRSMRestSetup.Validate("New Customer Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guakdan');
        VDRSMRestSetup.Validate("Inventory Req. Response Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaberu');
        VDRSMRestSetup.Validate("Loading Time Frame Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guazeit');
        VDRSMRestSetup.Validate("Reserve Loading Time Frame Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guavela');
        VDRSMRestSetup.Validate("New Customer Order Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaauan');
        VDRSMRestSetup.Validate("Item Cross-Reference Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guasort');
        VDRSMRestSetup.Validate("Customer Update Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guakdak');

        VDRSMRestSetup.Validate("Sales Quote Uri", 'https://wws-test.intern.rossmann.....'); //genauen Wert anfragen

        VDRSMRestSetup.Validate("Shipment Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guasend');
        VDRSMRestSetup.Validate("Deleted Items Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaarlo');
        VDRSMRestSetup.Validate("Price Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaatpr');
        VDRSMRestSetup.Validate("Shipment Status Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guasest');
        VDRSMRestSetup.Validate("Item Preferences Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaapra');
        VDRSMRestSetup.Validate("Item Dangerous Goods Uri", 'https://wws-test.intern.rossmann.de/profoundui/universal/guaagef');
        VDRSMRestSetup.Validate("Assortment Check Uri", 'https://wws-api-test.intern.rossmann.de/run/gh/wsapi/gh/sortimentspflege_aenderungen');
        VDRSMRestSetup.Validate("RSM Zeroed Orders Uri", 'https://wws-api-test.intern.rossmann.de/run/gh/wsapi/gh/abgenullte_bestellungen');
        VDRSMRestSetup.Validate("RSM Conso. No. Shipping Uri", 'https://wws-api-test.intern.rossmann.de/run/gh/wsapi/gh/konsonr_und_verladung');
        VDRSMRestSetup.Validate("RSM Automated Shipments DE Uri", 'https://wws-api-test.intern.rossmann.de/run/gh/wsapi/GUAANBC');
        VDRSMRestSetup.Validate("RSM Automated Shipments ES Uri", 'http://tazvw-msdyn01.azr-test.rossmann.de:7063/BC-TEST/api/rossmann/bcgh/v1.0/companies(6346db92-ab2e-ed11-8c61-000d3aaa844e)/shipments');
        VDRSMRestSetup.Validate("RSM Vendor Uri", 'https://wws-api-test.intern.rossmann.de/run/gh/wsapi/gh/kreditorenstamm');
        VDRSMRestSetup.Validate("RSM Item Reference Uri", 'https://wws-api-test.intern.rossmann.de/run/gh/wsapi/gua/verpackungseans');

        VDRSMRestSetup.Modify(true);
    end;

    /// <summary>
    /// Modifies VDRSM AEB Customs Setup to Change all Prod URLs to Test URLs.
    /// </summary>
    local procedure ModifyVDRSMAEBCustomsSetupURLs()
    var
        VDRSMAEBCustomsSetup: Record "VDRSM AEB Customs Setup";
    begin
        VDRSMAEBCustomsSetup.Get();
        VDRSMAEBCustomsSetup.Validate("Acknowledge Get Changed Uri", 'https://rz3.aeb.de/test2ici/rest/InternationalCustomsBFBean/acknowledgeGetChangedDeclarations');
        VDRSMAEBCustomsSetup.Validate("Create Consignment Uri", 'https://rz3.aeb.de/test2ici/rest/InternationalCustomsBFBean/createConsignment');
        VDRSMAEBCustomsSetup.Validate("Get Changed Declarations Uri", 'https://rz3.aeb.de/test2ici/rest/InternationalCustomsBFBean/getChangedDeclarations');
        VDRSMAEBCustomsSetup.Validate("AEB login page", 'https://rz3.aeb.de/test2ici/rest/InternationalCustomsAFBean/openConsignmentFolder');
        VDRSMAEBCustomsSetup.Validate("Logon Uri", 'https://rz3.aeb.de/test2ici/rest/logon/user');
        VDRSMAEBCustomsSetup.Modify(true);
    end;

    /// <summary>
    /// OpenWindow.
    /// Opens a Dialog Window.
    /// </summary>
    /// <param name="Window">VAR Dialog.</param>
    local procedure OpenWindow(var Window: Dialog)
    begin
        if GuiAllowed then
            Window.Open(OpenWindowLbl);
    end;

    /// <summary>
    /// UpdateWindow.
    /// Updates a Dialog Window.
    /// </summary>
    /// <param name="Window">VAR Dialog.</param>
    /// <param name="ModificationText">Text to Update in the Window.</param>
    local procedure UpdateWindow(var Window: Dialog; ModificationText: Text)
    begin
        if GuiAllowed then
            Window.Update(1, ModificationText);
    end;

    /// <summary>
    /// CloseWindow.
    /// Closes a Dialog Window.
    /// </summary>
    /// <param name="Window">VAR Dialog.</param>
    local procedure CloseWindow(var Window: Dialog)
    begin
        if GuiAllowed then
            Window.Close();
    end;
}