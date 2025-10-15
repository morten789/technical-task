page 55001 MBA_Users
{
    ApplicationArea = All;
    Caption = 'Users';
    PageType = List;
    SourceTable = MBA_User;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Id field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Username; Rec.Username)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Username field.', Comment = '%';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RefreshUsers)
            {
                Caption = 'Refresh users';
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
                    ApiClient.RefreshUsers();
                    CurrPage.Update(false);
                end;
            }
            action(OpenReleatedPosts)
            {
                Caption = 'Related posts';
                Image = View;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                trigger OnAction()
                var
                    MBAPost: Record MBA_Post;
                begin
                    MBAPost.SetRange(UserId, Rec.Id);
                    PAGE.Run(PAGE::MBA_Posts, MBAPost);
                end;
            }
        }
    }
}
