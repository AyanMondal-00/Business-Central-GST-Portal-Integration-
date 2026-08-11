tableextension 50120 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50100; "Entry Date"; Date)
        {
            DataClassification = CustomerContent;
        }

        field(50101; "Purchase Date"; Date)
        {
            DataClassification = CustomerContent;
        }

        field(50102; "Voucher Number"; Code[30])
        {
            DataClassification = CustomerContent;
        }

        field(50103; Airline; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(50104; Owner; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(50105; "Airline Code"; Code[30])
        {
            DataClassification = CustomerContent;
        }

        field(50106; Country; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(50107; Type; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(50108; Sector; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(50109; PNR; Code[30])
        {
            DataClassification = CustomerContent;
        }

        field(50110; Reference; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(50111; Narration; Text[250])
        {
            DataClassification = CustomerContent;
        }

        field(50112; Pax; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(50113; "Base Fare"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(50114; Others; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(50115; Rate; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(50116; "Travel Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(50117; "Travel Date"; Date)
        {
            DataClassification = CustomerContent;
        }

        field(50118; "Departure Time"; Time)
        {
            DataClassification = CustomerContent;
        }

        field(50119; "Arrival Time"; Time)
        {
            DataClassification = CustomerContent;
        }

        field(50120; "Flight No."; Code[30])
        {
            DataClassification = CustomerContent;
        }

        field(50121; "Name List"; Text[250])
        {
            DataClassification = CustomerContent;
        }

        field(50122; "Cost Revision"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
}