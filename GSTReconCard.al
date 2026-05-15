page 50101 "GST Recon Card"
{
    PageType = Card;
    SourceTable = "GST Recon Entry";
    ApplicationArea = All;
    Caption = 'GST Reconciliation Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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

                    trigger OnValidate()
                    begin
                        Rec."GST Amount" := Rec."Invoice Amount" * 0.18;
                    end;
                }

                field("GST Amount"; Rec."GST Amount")
                {
                    ApplicationArea = All;
                }
                field("Portal GST Amount"; Rec."Portal GST Amount")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Portal GST Amount" = Rec."GST Amount" then
                            Rec."Match Status" := Rec."Match Status"::Matched
                        else
                            Rec."Match Status" := Rec."Match Status"::Unmatched;
                    end;
                }
                field("Match Status"; Rec."Match Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}