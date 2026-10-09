#import <Cocoa/Cocoa.h>
#import <OpenEmuBase/OEGameCore.h>
#import <objc/runtime.h>
#import <objc/message.h>
static NSString *folder;
static id testPath(id obj,SEL sel){return folder;}
static void run(OEGameCore *core,int n){for(int i=0;i<n;i++){@autoreleasepool{[core executeFrame];}}}
static void button(OEGameCore *core,int b){((void(*)(id,SEL,int,NSUInteger))objc_msgSend)(core,NSSelectorFromString(@"didPushGenesisButton:forPlayer:"),b,1);run(core,3);((void(*)(id,SEL,int,NSUInteger))objc_msgSend)(core,NSSelectorFromString(@"didReleaseGenesisButton:forPlayer:"),b,1);run(core,3);}
static void snap(OEGameCore *core,NSString *name){OEIntSize bs=core.bufferSize;OEIntRect r=core.screenRect;const uint8_t *p=[core getVideoBufferWithHint:NULL];NSBitmapImageRep *im=[[NSBitmapImageRep alloc]initWithBitmapDataPlanes:NULL pixelsWide:r.size.width pixelsHigh:r.size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:r.size.width*4 bitsPerPixel:32];uint8_t *dst=im.bitmapData;for(int y=0;y<r.size.height;y++)for(int x=0;x<r.size.width;x++){const uint8_t *a=p+((y+r.origin.y)*bs.width+x+r.origin.x)*4;uint8_t *b=dst+(y*r.size.width+x)*4;b[0]=a[2];b[1]=a[1];b[2]=a[0];b[3]=255;}[[im representationUsingType:NSBitmapImageFileTypePNG properties:@{}]writeToFile:[folder stringByAppendingPathComponent:name] atomically:YES];printf("FRAME %d %d ASPECT %d %d\n",r.size.width,r.size.height,core.aspectSize.width,core.aspectSize.height);}
int main(int argc,char **argv){@autoreleasepool{
 if(argc<4)return 2;
 folder=[NSString stringWithUTF8String:argv[3]];[[NSFileManager defaultManager]createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
 NSBundle *bundle=[NSBundle bundleWithPath:[NSString stringWithUTF8String:argv[1]]];NSError *err=nil;if(![bundle loadAndReturnError:&err]){NSLog(@"LOAD_ERROR %@",err);return 3;}
 NSString *cn=bundle.infoDictionary[@"OEGameCoreClass"];Class parent=NSClassFromString(cn);Class cls=objc_allocateClassPair(parent,"IsolatedCoreSmoke",0);class_addMethod(cls,@selector(biosDirectoryPath),(IMP)testPath,"@@:");class_addMethod(cls,@selector(batterySavesDirectoryPath),(IMP)testPath,"@@:");objc_registerClassPair(cls);
 OEGameCore *core=[[cls alloc]init];core.systemIdentifier=@"openemu.system.sg";
 BOOL ok=[core loadFileAtPath:[NSString stringWithUTF8String:argv[2]] error:&err];printf("ROM_LOAD %d %s\n",ok,err.localizedDescription.UTF8String?:"");if(!ok)return 4;
 run(core,600);snap(core,@"boot.png");button(core,10);run(core,240);snap(core,@"menu.png");button(core,10);run(core,180);snap(core,@"diary.png");button(core,5);run(core,600);snap(core,@"game.png");
 ((void(*)(id,SEL,int,NSUInteger))objc_msgSend)(core,NSSelectorFromString(@"didPushGenesisButton:forPlayer:"),3,1);run(core,60);((void(*)(id,SEL,int,NSUInteger))objc_msgSend)(core,NSSelectorFromString(@"didReleaseGenesisButton:forPlayer:"),3,1);button(core,5);run(core,30);snap(core,@"input.png");
 __block BOOL saved=NO,loaded=NO;NSString *state=[folder stringByAppendingPathComponent:@"test.state"];[core saveStateToFileAtPath:state completionHandler:^(BOOL ok,NSError *e){saved=ok;printf("STATE_SAVE %d %s\n",ok,e.localizedDescription.UTF8String?:"");}];run(core,120);[core loadStateFromFileAtPath:state completionHandler:^(BOOL ok,NSError *e){loaded=ok;printf("STATE_LOAD %d %s\n",ok,e.localizedDescription.UTF8String?:"");}];run(core,1);snap(core,@"restored.png");if(!saved||!loaded)return 5;
 [core stopEmulation];printf("COMPLETE\n");
 }return 0;}
