table 55000 MBA_User
{
    Caption = 'User';
    DataClassification = CustomerContent;
    LookupPageId = MBA_Users;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Username; Text[60])
        {
            Caption = 'Username';
        }
        field(4; Email; Text[80])
        {
            Caption = 'Email';
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}
