codeunit 50130 "Cash Voucher API Mgmt"
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

        PostingDate: Date;
        DocumentNo: Code[20];
        AccountNo: Code[20];
        Description: Text[100];
        Amount: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        Counter: Integer;

    begin

        if not Client.Get(
            'https://raw.githubusercontent.com/AyanMondal-00/Gst-API/refs/heads/main/cashVoucher.json',
            Response)
          then
            Error('Failed to connect to API.');

        if not Response.IsSuccessStatusCode() then
            Error('HTTP Error %1', Response.HttpStatusCode());

        Response.Content().ReadAs(ResponseText);

        if not JsonArray.ReadFrom(ResponseText) then
            Error('Invalid JSON.');

        Counter := 0;
        foreach JsonToken in JsonArray do begin

            JsonObject := JsonToken.AsObject();

            Clear(PostingDate);
            Clear(DocumentNo);
            Clear(AccountNo);
            Clear(Description);
            Clear(Amount);

            if JsonObject.Get('PostingDate', ValueToken) then
                Evaluate(PostingDate, ValueToken.AsValue().AsText());

            if JsonObject.Get('DocumentNo', ValueToken) then
                DocumentNo := CopyStr(ValueToken.AsValue().AsText(), 1, 20);

            if JsonObject.Get('AccountNo', ValueToken) then
                AccountNo := CopyStr(ValueToken.AsValue().AsText(), 1, 20);

            if JsonObject.Get('Description', ValueToken) then
                Description := CopyStr(ValueToken.AsValue().AsText(), 1, 100);

            if JsonObject.Get('Amount', ValueToken) then
                Amount := ValueToken.AsValue().AsDecimal();

            // Check if Document already exists
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", 'CASH PAYM');
            GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
            GenJournalLine.SetRange("Document No.", DocumentNo);

            if not GenJournalLine.FindFirst() then begin

                // Get Next Line No.
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", 'CASH PAYM');
                GenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');

                if GenJournalLine.FindLast() then
                    NextLineNo := GenJournalLine."Line No." + 10000
                else
                    NextLineNo := 10000;

                Clear(GenJournalLine);
                GenJournalLine.Init();

                GenJournalLine.Validate("Journal Template Name", 'CASH PAYM');
                GenJournalLine.Validate("Journal Batch Name", 'DEFAULT');

                GenJournalLine."Line No." := NextLineNo;

                GenJournalLine.Validate("Posting Date", PostingDate);

                GenJournalLine.Validate(
                    "Document Type",
                    GenJournalLine."Document Type"::Invoice);

                GenJournalLine.Validate("Document No.", DocumentNo);

                GenJournalLine.Validate(
                    "Account Type",
                    GenJournalLine."Account Type"::Customer);

                GenJournalLine.Validate("Account No.", AccountNo);


                GenJournalLine.Validate("Description", Description);

                GenJournalLine.Validate("Amount", Amount);

                Message(
                    'Importing %1 | Account %2 | Amount %3',
                    DocumentNo,
                    AccountNo,
                    Amount);

                GenJournalLine.Insert(true);

                Counter += 1;
            end;
        end;
        Message('%1 Voucher(s) Imported Successfully.', Counter);
    end;
}