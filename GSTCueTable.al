table 50110 "GST Cue"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }

        field(2; "Total Records"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("GST Recon Entry");
        }

        field(3; "Total GST Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("GST Recon Entry"."GST Amount");
        }
        field(4; "Matched Records"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("GST Recon Entry" where("Match Status" = const(Matched)));
        }

        field(5; "Unmatched Records"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("GST Recon Entry" where("Match Status" = const(Unmatched)));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}