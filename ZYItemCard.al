pageextension 50112 ZYItemCard extends "Item Card"
{
    actions
    {
        addafter("&Bin Contents")
        {
            action(Rotate90FlipX)
            {
                Caption = 'Rotate 90 Flip X';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Change;

                trigger OnAction()
                begin
                    RotateFlipPicture(Enum::"Rotate Flip Type"::Rotate90FlipX);
                end;
            }
            action(Rotate90FlipNone)
            {
                Caption = 'Rotate 90 Flip None';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Change;

                trigger OnAction()
                begin
                    RotateFlipPicture(Enum::"Rotate Flip Type"::Rotate90FlipNone);
                end;
            }
        }
    }

    local procedure RotateFlipPicture(RotateFlipType: Enum "Rotate Flip Type")
    var
        Image: Codeunit Image;
        InS: InStream;
        OutS: OutStream;
        TempBlob: Codeunit "Temp Blob";
        ItemTenantMedia: Record "Tenant Media";
        FileName: Text;
    begin
        if Rec.Picture.Count > 0 then begin
            ItemTenantMedia.Get(Rec.Picture.Item(1));
            ItemTenantMedia.CalcFields(Content);
            ItemTenantMedia.Content.CreateInStream(InS, TextEncoding::UTF8);
            Image.FromStream(InS);
            Image.RotateFlip(RotateFlipType);
            TempBlob.CreateOutStream(OutS);
            Image.Save(OutS);
            TempBlob.CreateInStream(InS);
            Clear(Rec.Picture);
            FileName := Rec.Description + '.png';
            Rec.Picture.ImportStream(InS, FileName);
            Rec.Modify(true);
        end;
    end;
}
