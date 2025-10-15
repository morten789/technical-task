table 55001 MBA_Post
{
    Caption = 'Post';
    DataClassification = ToBeClassified;
    LookupPageId = MBA_Posts;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; UserId; Integer)
        {
            Caption = 'User Id';
            DataClassification = CustomerContent;
            TableRelation = MBA_User;
        }
        field(3; Title; Text[200])
        {
            Caption = 'Title';
            DataClassification = CustomerContent;
        }
        field(4; Body; Text[2048])
        {
            Caption = 'Body';
            DataClassification = CustomerContent;
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
