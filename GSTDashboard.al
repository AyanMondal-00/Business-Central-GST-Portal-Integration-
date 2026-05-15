page 50110 "GST Dashboard"
{

    PageType = Card;
    SourceTable = "GST Cue";
    ApplicationArea = All;
    Caption = 'GST Dashboard';
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            cuegroup("GST Overview")
            {
                field("Total Records"; Rec."Total Records")
                {
                    ApplicationArea = All;
                }

                field("Total GST Amount"; Rec."Total GST Amount")
                {
                    ApplicationArea = All;
                }
                field("Matched Records"; Rec."Matched Records")
                {
                    ApplicationArea = All;
                }

                field("Unmatched Records"; Rec."Unmatched Records")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('PRIMARY') then begin
            Rec.Init();
            Rec."Primary Key" := 'PRIMARY';
            Rec.Insert();
        end;
    end;
}