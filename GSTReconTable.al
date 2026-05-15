table 50100 "GST Recon Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(2; "Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(3; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(4; "GSTIN"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(5; "Invoice Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(6; "GST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(7; "Portal GST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(8; "Match Status"; Option)
        {
            OptionMembers = Matched,Unmatched,Partial;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(InvoiceNo; "Invoice No.")
        {
        }
    }
}