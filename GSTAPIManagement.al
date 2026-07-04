codeunit 50120 "GST API Management"
{
    procedure ImportFromAPI()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;

        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        ValueToken: JsonToken;

        ExistingGSTEntry: Record "GST Recon Entry";
        NewGSTEntry: Record "GST Recon Entry";

        InvoiceNo: Code[20];
        VendorName: Text[100];
        GSTIN: Code[20];
        InvoiceAmount: Decimal;
        MobileNo: Text[15];

        Counter: Integer;
    begin

        if not Client.Get(
            'https://raw.githubusercontent.com/AyanMondal-00/Gst-API/refs/heads/main/gstdata.json',
            Response)
        then
            Error('Failed to connect to API.');

        if not Response.IsSuccessStatusCode() then
            Error(
                'HTTP Error %1 - %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());

        Response.Content().ReadAs(ResponseText);

        if ResponseText = '' then
            Error('API returned empty response.');

        if not JsonArray.ReadFrom(ResponseText) then
            Error('Invalid JSON format.');

        Counter := 0;

        foreach JsonToken in JsonArray do begin

            JsonObject := JsonToken.AsObject();

            Clear(InvoiceNo);
            Clear(VendorName);
            Clear(GSTIN);
            Clear(InvoiceAmount);
            Clear(MobileNo);

            if JsonObject.Get('InvoiceNo', ValueToken) then
                InvoiceNo := CopyStr(ValueToken.AsValue().AsText(), 1, 20);

            if JsonObject.Get('VendorName', ValueToken) then
                VendorName := CopyStr(ValueToken.AsValue().AsText(), 1, 100);

            if JsonObject.Get('GSTIN', ValueToken) then
                GSTIN := CopyStr(ValueToken.AsValue().AsText(), 1, 20);

            if JsonObject.Get('InvoiceAmount', ValueToken) then
                InvoiceAmount := ValueToken.AsValue().AsDecimal();

            if JsonObject.Get('MobileNo', ValueToken) then
                MobileNo := CopyStr(ValueToken.AsValue().AsText(), 1, 15);

            // Check for existing record using separate variable
            Message('Checking Invoice %1', InvoiceNo);
            ExistingGSTEntry.Reset();
            ExistingGSTEntry.SetRange("Invoice No.", InvoiceNo);

            if not ExistingGSTEntry.FindFirst() then begin

                // Create new record using separate variable
                Clear(NewGSTEntry);
                NewGSTEntry.Init();

                // DO NOT manually assign Entry No. - it's AutoIncrement
                NewGSTEntry."Invoice No." := InvoiceNo;
                NewGSTEntry."Vendor Name" := VendorName;
                NewGSTEntry."GSTIN" := GSTIN;
                NewGSTEntry."Invoice Amount" := InvoiceAmount;
                NewGSTEntry."Mobile No." := MobileNo;

                NewGSTEntry."GST Amount" :=
                    Round(InvoiceAmount * 0.18, 0.01);

                NewGSTEntry."Match Status" :=
                    NewGSTEntry."Match Status"::Unmatched;

                Message('Inserting Invoice %1', InvoiceNo);
                NewGSTEntry.Insert();

                Message('Inserted Invoice %1 successfully', InvoiceNo);
                Counter += 1;
            end else begin
                Message('Invoice %1 already exists - skipping', InvoiceNo);
            end;
        end;

        Message('%1 new records imported successfully.', Counter);
    end;
}