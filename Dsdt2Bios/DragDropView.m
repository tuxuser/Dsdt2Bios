
#import "DragDropView.h"
#include "global.h"

@implementation DragDropView


- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    highlight=YES;
    [self setNeedsDisplay: YES];
    return NSDragOperationGeneric;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender{
    highlight=NO;
    [self setNeedsDisplay: YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    highlight=NO;
    [self setNeedsDisplay: YES];
    return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
        return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender{
    
    NSArray *draggedFilenames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    unsigned long len;
    unsigned int ret;
    unsigned char *d =NULL;
    unsigned long Old_Dsdt_Size, Old_Dsdt_Ofs;
    const char *FileName;
    char cr[65535];
    unsigned short reloc_padding;
    

    d = malloc(DsdtMax+1);
    
    switch ( [draggedFilenames count] ) //Number of files drop
    {
        case 1: //Just extract DSDT
        {
            FileName = [draggedFilenames[0] UTF8String];
            ret = Read_AmiBoardInfo(FileName, d, &len, &Old_Dsdt_Size, &Old_Dsdt_Ofs,2,cr);
            if ( ret == 2 )sprintf(cr,"\n\n\n\n\n\n\n\nFile %s has bad header\n",FileName);
            NSString* string = [[NSString alloc] initWithUTF8String:cr];
            self.Output.string=string;
        }
        break;
            
        case 2: //Extract DSDT and patch
        {
            FileName = [draggedFilenames[0] UTF8String];
            ret = Read_AmiBoardInfo(FileName, d, &len, &Old_Dsdt_Size, &Old_Dsdt_Ofs,1,cr);
            switch (ret) //Check order of files drags
            {
                case 1:
                    FileName = [draggedFilenames[1] UTF8String];
                    reloc_padding = 0;
                    Read_Dsdt(FileName, d, len, Old_Dsdt_Size, Old_Dsdt_Ofs,cr,&reloc_padding);
                    //si reloc_padding est différent de 0, cela signifie que la zone de relocation est à cheval sur un segment d'adresse
                    //il faut donc recaler l'adresse de base -> appel une seconde fois avec le paramètre reloc_padding.
                    if ( reloc_padding != 0 )
                    {
                        FileName = [draggedFilenames[0] UTF8String];
                        ret = Read_AmiBoardInfo(FileName, d, &len, &Old_Dsdt_Size, &Old_Dsdt_Ofs,1,cr);
                        FileName = [draggedFilenames[1] UTF8String];
                        Read_Dsdt(FileName, d, len, Old_Dsdt_Size, Old_Dsdt_Ofs,cr,&reloc_padding);
                    }
                break;
                case 2:
                    FileName = [draggedFilenames[1] UTF8String];
                    if ( Read_AmiBoardInfo(FileName, d, &len, &Old_Dsdt_Size, &Old_Dsdt_Ofs,1,cr) == 2)
                        sprintf(cr,"\n\n\n\n\n\n\n\nFile %s has bad header\n",FileName);
                    else
                    {
                        FileName = [draggedFilenames[0] UTF8String];
                        reloc_padding = 0;
                        Read_Dsdt(FileName, d, len, Old_Dsdt_Size, Old_Dsdt_Ofs,cr,&reloc_padding);
                        //si reloc_padding est différent de 0, cela signifie que la zone de relocation est à cheval sur un segment d'adresse
                        //il faut donc recaler l'adresse de base -> appel une seconde fois avec le paramètre reloc_padding.
                        if ( reloc_padding != 0 )
                        {
                            FileName = [draggedFilenames[1] UTF8String];
                            Read_AmiBoardInfo(FileName, d, &len, &Old_Dsdt_Size, &Old_Dsdt_Ofs,1,cr);
                            FileName = [draggedFilenames[0] UTF8String];
                            Read_Dsdt(FileName, d, len, Old_Dsdt_Size, Old_Dsdt_Ofs,cr,&reloc_padding);
                        }
                    }
                break;
            }
            NSString* string = [[NSString alloc] initWithUTF8String:cr];
            self.Output.string=string;
        }
        break;
            
        default:
        {
            self.Output.string = @"\n\n\n\n\n\nYOU MUST DRAG AND DROP SIMULTANEOUSLY\n\nYOUR ORIGINAL AMIBOARDINFO AND YOUR NEW DSDT \n\nOR\n\nJUST DRAG AND DROP AMIBOARDINFO TO GET ORIGINAL DSDT";
        }
        break;
    }
    
    
    free(d);
}

- (void)drawRect:(NSRect)rect{
    [super drawRect:rect];
    if ( highlight ) {
        [[NSColor greenColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: [self bounds]];
    }
}

@end
