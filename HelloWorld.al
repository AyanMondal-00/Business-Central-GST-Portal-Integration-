pageextension 50100 CustomerListExt extends "Customer List"
{
    actions
    {
        addlast(Processing)
        {
            action(MyGSTAction)
            {
                ApplicationArea = All;
                Caption = 'GST Recon';

                trigger OnAction()
                begin
                    Message('GST Reconciliation Module Coming Soon!');
                end;
            }
        }
    }
}