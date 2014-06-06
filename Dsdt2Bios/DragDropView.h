//
//  DragDropView.h
//  AmiInfoBoard
//
//  Created by Frédéric Geoffroy on 14/04/2014.
//  Copyright (c) 2014 FredWst. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DragDropView : NSView{
    bool highlight;
    
}
@property (strong) IBOutlet NSTextView *Output;


unsigned int Read_Dsdt(const char *FileName, unsigned char *d, unsigned long len, unsigned short Old_Dsdt_Size, unsigned short Old_Dsdt_Ofs, char *cr, unsigned short *reloc_padding);
unsigned int Read_AmiBoardInfo(const char *FileName, unsigned char *d,unsigned long *len, unsigned short *Old_Dsdt_Size, unsigned short *Old_Dsdt_Ofs, int Extract, char *cr);
@end
