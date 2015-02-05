//
//  SubmitPhotos.m
//  SubmitPhotos
//
//  Created by Leo on 15/2/2.
//  Copyright (c) 2015年 Leo Ling. All rights reserved.
//

#import "SubmitPhotos.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface SubmitPhotos ()
@property (nonatomic) NSMutableArray *selectPhotoArray;
@property (nonatomic) NSUInteger selectPhotoNum;
@property (nonatomic) QBImagePickerController *imagePickerController;
@end

@implementation SubmitPhotos

#define TileInitialTag          10000

UIButton *addPhoto_btn;
UIButton *pic_btn;
UIButton *submit_btn;
UITextView *text_tvw;
UIImage *fullImage;
UIImageView *clickImageView;
CGSize itemSize;
UIView *clickImage_view;
UIView *MatrixImage_view;
NSInteger selected_ID;
float originX;
float originY;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectPhotoNum=9;
    //文本框内容
    text_tvw = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, self.view.bounds.size.width-40, 180)];
    text_tvw.font= [UIFont systemFontOfSize:18];
    text_tvw.text = @"请在这里输入文字";
    //text_tvw.autoresizingMask = UIViewAutoresizingFlexibleHeight; //自适应高度
    [self.view addSubview:text_tvw];
    
    //在弹出的键盘上面加一个View来放置退出键盘的Done按钮
    UIToolbar *finishKeyboard_view = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [finishKeyboard_view setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * FlexibleSpace_btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * done_btn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:FlexibleSpace_btn, done_btn, nil];
    [finishKeyboard_view setItems:buttonsArray];
    [text_tvw setInputAccessoryView:finishKeyboard_view];
    
    //提交数据按钮
    submit_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submit_btn setTitle:@"提交数据" forState:UIControlStateNormal];
    [submit_btn addTarget:self action:@selector(submitFun) forControlEvents:UIControlEventTouchUpInside];
    submit_btn.frame=CGRectMake(25, self.view.bounds.size.height-120, 76, 76);
    [self.view addSubview:submit_btn];
    
    originX=25;
    originY=240;
    [self initPhoto];
}

-(void) initPhoto{
    MatrixImage_view=[[UIView alloc]initWithFrame:CGRectMake(originX,originY,240,240)];
    //    MatrixImage_view.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:MatrixImage_view];
    
    //添加图片按钮
    addPhoto_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPhoto_btn setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    addPhoto_btn.frame=CGRectMake(0, 0, 76, 76);
    addPhoto_btn.hidden=YES;
    [addPhoto_btn addTarget:self action:@selector(AddPhotoFun) forControlEvents:UIControlEventTouchUpInside];
    [MatrixImage_view addSubview:addPhoto_btn];
    addPhoto_btn.enabled=false;
    addPhoto_btn.hidden=true;
    
    //第一张图片按钮
    pic_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pic_btn setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
    [pic_btn addTarget:self action:@selector(AddPhotoFun) forControlEvents:UIControlEventTouchUpInside];
    pic_btn.frame=CGRectMake(0, 0, 76, 76);
    pic_btn.enabled=true;
    pic_btn.hidden=false;
    [MatrixImage_view addSubview:pic_btn];
}

-(void) submitFun{
    NSLog(@"提交数据");
}

-(void)AddPhotoFun
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
            {//相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                //                    imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
                break;
            }
            case 1:
            {//相册
                [self OpenMultiImage];
                break;
            }
        }
    }
    else {//不支持相机的时候直接跳转到相册
        if (buttonIndex == 0) {
            [self OpenMultiImage];
        }
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    //取消相册或者相机的选择界面
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *cameraImage = image;
    //    NSData *imageData = UIImageJPEGRepresentation(cameraImage, COMPRESSED_RATE);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    if(_selectPhotoArray.count==0){
        _selectPhotoArray = [NSMutableArray arrayWithObjects:cameraImage, nil];
    }else{
        [_selectPhotoArray addObject:cameraImage];
    }
    _selectPhotoNum--;
    [self AddThumbnail];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    //
}

-(void)OpenMultiImage
{
    _imagePickerController = [[QBImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    //屏蔽掉我的照片流
    _imagePickerController.groupTypes = @[
                                         @(ALAssetsGroupSavedPhotos),
                                         @(ALAssetsGroupAlbum)
                                         ];
    _imagePickerController.allowsMultipleSelection = YES;
    _imagePickerController.filterType=QBImagePickerControllerFilterTypePhotos;
    _imagePickerController.maximumNumberOfSelection = (unsigned long)_selectPhotoNum;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [self dismissImagePickerController];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    for (ALAsset *set in assets) {
        CGImageRef ref = set.thumbnail;
        UIImage *image = [UIImage imageWithCGImage:ref];
        [newArray addObject:image];
    }
    if(_selectPhotoArray.count==0){
        _selectPhotoArray = newArray;
    } else{
        [_selectPhotoArray addObjectsFromArray:newArray];
    }
    [self dismissImagePickerController];
    [self AddThumbnail];
}

-(void)AddThumbnail
{
    addPhoto_btn.enabled=true;
    addPhoto_btn.hidden=false;
    pic_btn.enabled=false;
    pic_btn.hidden=true;
    
    NSUInteger count = [_selectPhotoArray count];
    NSUInteger lineNum = 0;

    //添加图片按钮
    for (NSUInteger i = 0; i < count; i++)
    {
        UIImage *thumbnail_img;
        thumbnail_img = _selectPhotoArray[i];
        UIImageView *myImageView=[[UIImageView alloc]initWithImage:thumbnail_img];
        float newX;
        float newY;
        float addPhotoBtn_newX;
        float addPhotoBtn_newY;
        NSUInteger remainder=i%3;
        NSUInteger addPhotoBtn_remainder=(i+1)%3;
        //处理矩阵中的照片位置
        if(remainder==0) {
            newY=lineNum*79;
            lineNum=lineNum+1;
        }
        newX=remainder*79;
        myImageView.frame = CGRectMake(newX, newY, 74, 74);
        //给UIImageView添加点击事件
        myImageView.tag = i;  //可以通过这样来给下边的点击事件传值
        myImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [myImageView addGestureRecognizer:singleTap];
        //处理"添加图片按钮"的位置
        if (i==8){
            addPhoto_btn.enabled=false;
            addPhoto_btn.hidden=true;
        }else{
            if(addPhotoBtn_remainder==0) {
                addPhotoBtn_newY=newY+79;
            }else{
                addPhotoBtn_newY=newY;
            }
            addPhotoBtn_newX=addPhotoBtn_remainder*79;
            addPhoto_btn.frame = CGRectMake(addPhotoBtn_newX, addPhotoBtn_newY, 74, 74);
        }
        [MatrixImage_view addSubview:myImageView];
    }
    _selectPhotoNum = (9-count);
}

-(void)imageClick:(UITapGestureRecognizer *)recognizer
{
    clickImage_view=[[UIView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height-20)];
    clickImage_view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:clickImage_view];
    //NSLog(@"点击缩略图，生成大图片和删除按钮，返回按钮");
    //NSLog(@"选择的图片值%ld",(long)recognizer.view.tag);
    selected_ID=recognizer.view.tag;
    ALAsset *alAsset = [_selectPhotoArray objectAtIndex:selected_ID];
    if ([alAsset isKindOfClass:[ALAsset class]]) {
        //NSLog(@"result是ALAsset类，表示来自相册");
        fullImage= [UIImage imageWithCGImage:[[alAsset defaultRepresentation] fullResolutionImage]];
    }else{
        //NSLog(@"result不是ALAsset类，表示来自相机");
        fullImage = [_selectPhotoArray objectAtIndex:recognizer.view.tag];
    };
    clickImageView=[[UIImageView alloc]initWithImage:fullImage];
    clickImageView.tag=TileInitialTag+1;
    [self imageFitScreenFun];
    clickImageView.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    //clickImageView.contentMode = UIViewContentModeScaleAspectFit;
    //clickImageView.autoresizesSubviews = YES;
    //clickImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [clickImage_view addSubview:clickImageView];
    UIView *topBG_view=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,40.0)];
    topBG_view.backgroundColor = [UIColor blackColor];
    [clickImage_view addSubview:topBG_view];
    UIButton *back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    back_btn.frame = CGRectMake(20, 2, 22, 38);
    [back_btn setImage:[UIImage imageNamed:@"back_white_btn.png"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backFun) forControlEvents:UIControlEventTouchUpInside];
    [topBG_view addSubview:back_btn];
    UIButton *delete_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    delete_btn.frame = CGRectMake(self.view.bounds.size.width-36-20, 2, 36, 38);
    [delete_btn setImage:[UIImage imageNamed:@"trashCan.png"] forState:UIControlStateNormal];
    [delete_btn addTarget:self action:@selector(deleteFun) forControlEvents:UIControlEventTouchUpInside];
    [topBG_view addSubview:delete_btn];
}

-(void)imageFitScreenFun
{
    float verticalRadio = fullImage.size.height*1.0/self.view.bounds.size.height;
    float horizontalRadio = fullImage.size.width*1.0/self.view.bounds.size.width;
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    itemSize = CGSizeMake(self.view.bounds.size.width*radio, self.view.bounds.size.height*radio);
}

-(void)backFun
{
    [self clearImageFun];
}

-(void)deleteFun
{
    [self clearImageFun];
    _selectPhotoNum++;
    [_selectPhotoArray removeObjectAtIndex:selected_ID];
    [self deleteMatrixPhoto];
    [self initPhoto];
    [self AddThumbnail];
    if(_selectPhotoArray.count==0){
        addPhoto_btn.enabled=NO;
        addPhoto_btn.hidden=YES;
        pic_btn.enabled=YES;
        pic_btn.hidden=NO;
    }
}

-(void)deleteMatrixPhoto
{
    for (UIView *view in [MatrixImage_view subviews])
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
    }
    [MatrixImage_view removeFromSuperview];
}

-(void)clearImageFun
{
    [clickImage_view removeFromSuperview];
}

//关闭键盘
-(void) dismissKeyBoard{
    [text_tvw resignFirstResponder];
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

@end