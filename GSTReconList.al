page 50100 "GST Recon List"
{
    PageType = List;
    SourceTable = "GST Recon Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'GST Reconciliation List';
    CardPageId = "GST Recon Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }

                field("GSTIN"; Rec."GSTIN")
                {
                    ApplicationArea = All;
                }

                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ApplicationArea = All;
                }

                field("GST Amount"; Rec."GST Amount")
                {
                    ApplicationArea = All;
                }

                field("Match Status"; Rec."Match Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportJSON)
            {
                Caption = 'Import JSON';
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                var
                    JsonText: Text;
                    Line: Text;
                    InS: InStream;
                    FileName: Text;

                    JsonArray: JsonArray;
                    JsonToken: JsonToken;
                    JsonObject: JsonObject;
                    ValueToken: JsonToken;

                    InvoiceNo: Code[20];
                    PortalGST: Decimal;

                    GSTEntry: Record "GST Recon Entry";
                    Window: Dialog;
                    Counter: Integer;
                begin
                    if not UploadIntoStream('Select JSON File', '', 'JSON Files (*.json)|*.json', FileName, InS) then
                        exit;

                    Window.Open('Reading JSON file...\\Please wait.');
                    
                    while not InS.EOS() do begin
                        InS.ReadText(Line);
                        JsonText += Line;
                    end;

                    if not JsonArray.ReadFrom(JsonText) then
                        Error('Invalid JSON format in file %1', FileName);

                    Window.Open('Matching GST Amounts...\\Record #1#######');
                    Counter := 0;

                    foreach JsonToken in JsonArray do begin
                        Counter += 1;
                        Window.Update(1, Counter);
                        
                        JsonObject := JsonToken.AsObject();

                        Clear(InvoiceNo);
                        Clear(PortalGST);

                        if JsonObject.Get('invoiceNo', ValueToken) then
                            InvoiceNo := CopyStr(ValueToken.AsValue().AsText(), 1, 20);

                        if JsonObject.Get('portalGSTAmount', ValueToken) then
                            PortalGST := ValueToken.AsValue().AsDecimal();

                        if InvoiceNo <> '' then begin
                            GSTEntry.Reset();
                            GSTEntry.SetRange("Invoice No.", InvoiceNo);

                            if GSTEntry.FindFirst() then begin
                                GSTEntry."Portal GST Amount" := PortalGST;

                                if GSTEntry."GST Amount" = PortalGST then
                                    GSTEntry."Match Status" := GSTEntry."Match Status"::Matched
                                else
                                    GSTEntry."Match Status" := GSTEntry."Match Status"::Unmatched;

                                GSTEntry.Modify();
                            end;
                        end;
                    end;
                    
                    Window.Close();
                    Message('JSON Imported and Matched Successfully!\Processed %1 records.', Counter);
                end;
            }
        }
    }
}