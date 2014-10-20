//
//  SettingViewController.m
//  Hackathon
//
//  Created by I-Horng Huang on 19/10/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *autoWaterSwitch;
@property (weak, nonatomic) IBOutlet UISlider *moistureSlider;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.autoWaterSwitch addTarget:self action:@selector(sendSettings) forControlEvents:UIControlEventValueChanged];

}

-(void)sendSettings
{
    if (self.autoWaterSwitch.on == YES) {
        NSLog(@"yes");
        self.moistureSlider.userInteractionEnabled = YES;
        self.moistureSlider.minimumTrackTintColor = [UIColor blueColor];
        //send stufff


    } else {
        NSLog(@"no");
        self.moistureSlider.userInteractionEnabled = NO;
        self.moistureSlider.minimumTrackTintColor = [UIColor blackColor];
        //send stufff

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
