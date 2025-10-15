page 55000 MBA_Posts
{
    ApplicationArea = All;
    Caption = 'Posts';
    PageType = List;
    SourceTable = MBA_Post;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Body; Rec.Body)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Body field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
                field(UserId; Rec.UserId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserId field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshPosts)
            {
                Caption = 'Refresh posts';
                Image = Refresh;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                trigger OnAction()
                var
                    ApiClient: Codeunit "MBA_ApiClient";
                begin
                    ApiClient.RefreshPosts();
                    CurrPage.Update(false);
                end;
            }

            action(CreatePost)
            {
                Caption = 'Send Post';
                Image = NewDocument;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApiClient: Codeunit "MBA_ApiClient";
                begin
                    ApiClient.CreatePost(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

}
