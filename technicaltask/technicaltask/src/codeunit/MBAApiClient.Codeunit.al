codeunit 55000 MBA_ApiClient
{
    var
        ErrSendRequestLbl: Label 'Could not send request to %1.', Comment = 'HTTP call failed before getting a response. %1 = URL';
        ErrHttpFailedLbl: Label 'Failed request. HTTP %1 %2 (%3)', Comment = '%1 = status code, %2 = reason phrase, %3 = URL';
        ErrInvalidUsersJsonLbl: Label 'Invalid JSON for Users.';
        ErrInvalidPostsJsonLbl: Label 'Invalid JSON for Posts.';
        ErrInvalidPostResponseLbl: Label 'Invalid POST response from %1.', Comment = '%1 = URL';
        CreatedPostMsg: Label 'Post created Id %1.', Comment = '%1 = Id of created post';

    procedure RefreshUsers()
    var
        MBAUser: Record "MBA_User";
        Dirty: Boolean;
        Client: HttpClient;
        Response: HttpResponseMessage;
        IdVal: Integer;
        Users: JsonArray;
        Obj: JsonObject;
        Token: JsonToken;
        BodyText: Text;
        EmailVal: Text;
        NameVal: Text;
        Url: Text;
        UsernameVal: Text;
    begin
        Url := GetBaseUrl() + '/users';

        if not Client.Get(Url, Response) then
            Error(ErrSendRequestLbl, Url);

        if not Response.IsSuccessStatusCode() then
            Error(ErrHttpFailedLbl, Response.HttpStatusCode(), Response.ReasonPhrase(), Url);

        Response.Content().ReadAs(BodyText);
        if not Users.ReadFrom(BodyText) then
            Error(ErrInvalidUsersJsonLbl);

        foreach Token in Users do begin

            Obj := Token.AsObject();
            IdVal := GetInt(Obj, 'id');
            NameVal := GetText(Obj, 'name');
            UsernameVal := GetText(Obj, 'username');
            EmailVal := GetText(Obj, 'email');

            if MBAUser.Get(IdVal) then begin
                Dirty := false;
                if MBAUser.Name <> NameVal then begin
                    MBAUser.Name := NameVal;
                    Dirty := true;
                end;
                if MBAUser.Username <> UsernameVal then begin
                    MBAUser.Username := UsernameVal;
                    Dirty := true;
                end;
                if MBAUser.Email <> EmailVal then begin
                    MBAUser.Email := EmailVal;
                    Dirty := true;
                end;
                if Dirty then
                    MBAUser.Modify(true);
            end else begin
                MBAUser.Init();
                MBAUser.Id := IdVal;
                MBAUser.Name := NameVal;
                MBAUser.Username := UsernameVal;
                MBAUser.Email := EmailVal;
                MBAUser.Insert(true);
            end;
        end;
    end;

    procedure RefreshPosts()
    var
        MBAPost: Record "MBA_Post";
        Dirty: Boolean;
        Client: HttpClient;
        Response: HttpResponseMessage;
        IdVal: Integer;
        UserIdVal: Integer;
        Arr: JsonArray;
        Obj: JsonObject;
        Token: JsonToken;
        BodyText: Text;
        BodyVal: Text;
        TitleVal: Text;
        Url: Text;
    begin
        Url := GetBaseUrl() + '/posts';

        if not Client.Get(Url, Response) then
            Error(ErrSendRequestLbl, Url);

        if not Response.IsSuccessStatusCode() then
            Error(ErrHttpFailedLbl, Response.HttpStatusCode(), Response.ReasonPhrase(), Url);

        Response.Content().ReadAs(BodyText);
        if not Arr.ReadFrom(BodyText) then
            Error(ErrInvalidPostsJsonLbl);

        foreach Token in Arr do begin
            Obj := Token.AsObject();

            IdVal := GetInt(Obj, 'id');
            UserIdVal := GetInt(Obj, 'userId');
            TitleVal := GetText(Obj, 'title');
            BodyVal := GetText(Obj, 'body');

            if MBAPost.Get(IdVal) then begin
                Dirty := false;

                if MBAPost.Userid <> UserIdVal then begin
                    MBAPost.Userid := UserIdVal;
                    Dirty := true;
                end;
                if MBAPost.Title <> TitleVal then begin
                    MBAPost.Title := TitleVal;
                    Dirty := true;
                end;
                if MBAPost.Body <> BodyVal then begin
                    MBAPost.Body := BodyVal;
                    Dirty := true;
                end;
                if Dirty then
                    MBAPost.Modify(true);

            end else begin
                MBAPost.Init();
                MBAPost.Id := IdVal;
                MBAPost.Userid := UserIdVal;
                MBAPost.Title := TitleVal;
                MBAPost.Body := BodyVal;
                MBAPost.Insert(true);
            end;
        end;
    end;

    procedure CreatePost(RecPost: Record "MBA_Post")
    var
        Client: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        NewId: Integer;
        ReqObj: JsonObject;
        RespObj: JsonObject;
        BodyText: Text;
        Payload: Text;
        Url: Text;
    begin
        Url := GetBaseUrl() + '/posts';

        ReqObj.Add('userId', RecPost.UserId);
        ReqObj.Add('title', RecPost.Title);
        ReqObj.Add('body', RecPost.Body);
        ReqObj.WriteTo(Payload);

        Content.WriteFrom(Payload);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json; charset=utf-8');

        if not Client.Post(Url, Content, Response) then
            Error(ErrInvalidPostResponseLbl, Url);

        if not Response.IsSuccessStatusCode() then
            Error(ErrHttpFailedLbl, Response.HttpStatusCode(), Response.ReasonPhrase());

        Response.Content().ReadAs(BodyText);
        if not RespObj.ReadFrom(BodyText) then
            Error(ErrInvalidPostResponseLbl, Url);

        NewId := GetInt(RespObj, 'id');

        Message(CreatedPostMsg, NewId);
    end;

    local procedure GetBaseUrl(): Text
    begin
        exit('https://jsonplaceholder.typicode.com');
    end;

    local procedure GetText(JsonObject: JsonObject; Name: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(Name, JsonToken) and JsonToken.IsValue() then
            exit(JsonToken.AsValue().AsText());
        exit('');
    end;

    local procedure GetInt(JsonObject: JsonObject; Name: Text): Integer
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(Name, JsonToken) and JsonToken.IsValue() then
            exit(JsonToken.AsValue().AsInteger());
        exit(0);
    end;
}