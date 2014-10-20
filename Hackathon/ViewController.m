//
//  ViewController.m
//  Hackathon
//
//  Created by I-Horng Huang on 18/10/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "ViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "WMGaugeView.h"

@interface ViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGrpah;
@property NSMutableArray *tempOf10;
@property NSMutableArray *desOf10;
@property NSMutableArray *dateOf10;
@property (weak, nonatomic) IBOutlet WMGaugeView *gaugeDisplay;
@property (weak, nonatomic) IBOutlet UILabel *rainConditionLabel;

@property (weak, nonatomic) IBOutlet WMGaugeView *lightGauge;
@property (weak, nonatomic) IBOutlet WMGaugeView *moistGauge;
@property (weak, nonatomic) IBOutlet WMGaugeView *tempGauge;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lineGrpah.enableBezierCurve = YES; //enabling curvy graph
    self.title = @"WET. CO";
    self.lineGrpah.enableYAxisLabel = YES;
    self.lineGrpah.enablePopUpReport = YES;
    self.lineGrpah.enableTouchReport = YES;

    [self getWeather];
    [self HappyGaugeEnable];
    [self SensorGaugeEnable];

    //hard coded the date :/
    self.dateOf10 = [NSMutableArray new];
    for (int i = 0; i<10; i++) {
        [self.dateOf10 addObject:[NSString stringWithFormat:@"8/%d", 19+i]];
    }
    NSLog(@"dates are %@", self.dateOf10);

    // loop refreshing table, dont really need
//    [NSTimer scheduledTimerWithTimeInterval:4.0
//                                         target:self
//                                       selector:@selector(reloadGraph)
//                                       userInfo:nil
//                                        repeats:YES];

        [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(getData)
                                           userInfo:nil
                                            repeats:YES];
    //[self getData];


}
- (IBAction)waterButtonPressed:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Watering" message:@"You are watering your lovely flower" delegate:self cancelButtonTitle:@"AWESOME" otherButtonTitles:nil];
//    [alert show];

//    [self.gaugeDisplay setValue:90 animated:YES duration:8.0 completion:^(BOOL finished) {
//            NSLog(@"gaugeView animation complete");
//    }];
//    [self.moistGauge setValue:90 animated:YES duration:8.0 completion:^(BOOL finished) {
//        NSLog(@"gaugeView animation complete");
//    }];

    NSURL *url = [NSURL URLWithString:@"http://ollyhicks.me:9000/water"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"sentttttttt");
    }];
}


#pragma mark - get Data
-(void)getData
{
    // this will be call every 1 second
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ollyhicks.me:9000/app"]];
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               //get the data and adjust the sensor point
                               float lightValue = [json[@"light"] floatValue];
                               float moistValue = [json[@"moisture"] floatValue];
                               float tempValue = [json[@"temperature"] floatValue];
                               NSLog(@" light:%f,  moist:%f, temp:%f",lightValue,moistValue,tempValue);

                               [self.lightGauge setValue:lightValue*230 animated:YES duration:1.0 completion:^(BOOL finished) {
                               }];
                               [self.moistGauge setValue:moistValue*200 animated:YES duration:1.0 completion:^(BOOL finished) {
                               }];
                               [self.tempGauge setValue:tempValue*2.5 animated:YES duration:1.0 completion:^(BOOL finished) {
                               }];

                               //adjustable~
                               float happyValue = tempValue + moistValue*130 + lightValue*30;
                               NSLog(@"happy value is %f",happyValue);
                               [self.gaugeDisplay setValue:happyValue animated:YES duration:1.0 completion:^(BOOL finished) {
                                   // NSLog(@"gaugeView animation complete");
                               }];
                           }];


}

#pragma mark - Gauge
- (void)SensorGaugeEnable
{
    //Light sensor
    self.lightGauge.maxValue = 100.0;
    self.lightGauge.scaleDivisions = 10;
    self.lightGauge.scaleSubdivisions = 5;
    self.lightGauge.scaleStartAngle = 30;
    self.lightGauge.scaleEndAngle = 280;
    self.lightGauge.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.lightGauge.showScaleShadow = NO;
    self.lightGauge.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    self.lightGauge.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    self.lightGauge.scaleSubdivisionsWidth = 0.002;
    self.lightGauge.scaleSubdivisionsLength = 0.04;
    self.lightGauge.scaleDivisionsWidth = 0.007;
    self.lightGauge.scaleDivisionsLength = 0.07;
    self.lightGauge.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    self.lightGauge.needleWidth = 0.002;
    self.lightGauge.needleHeight = 0.5;
    self.lightGauge.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    self.lightGauge.needleScrewRadius = 0.05;

    //Set Value HERE !
    [self.lightGauge setValue:90 animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView animation complete");
    }];

    //Moist sensor
    self.moistGauge.maxValue = 100.0;
    self.moistGauge.scaleDivisions = 10;
    self.moistGauge.scaleSubdivisions = 5;
    self.moistGauge.scaleStartAngle = 30;
    self.moistGauge.scaleEndAngle = 280;
    self.moistGauge.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.moistGauge.showScaleShadow = NO;
    self.moistGauge.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    self.moistGauge.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    self.moistGauge.scaleSubdivisionsWidth = 0.002;
    self.moistGauge.scaleSubdivisionsLength = 0.04;
    self.moistGauge.scaleDivisionsWidth = 0.007;
    self.moistGauge.scaleDivisionsLength = 0.07;
    self.moistGauge.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    self.moistGauge.needleWidth = 0.002;
    self.moistGauge.needleHeight = 0.5;
    self.moistGauge.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    self.moistGauge.needleScrewRadius = 0.05;

    //Set moistGauge HERE !
    [self.moistGauge setValue:30 animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView animation complete");
    }];

    //Temp Sensor
    self.tempGauge.maxValue = 100.0;
    self.tempGauge.scaleDivisions = 10;
    self.tempGauge.scaleSubdivisions = 5;
    self.tempGauge.scaleStartAngle = 30;
    self.tempGauge.scaleEndAngle = 280;
    self.tempGauge.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.tempGauge.showScaleShadow = NO;
    self.tempGauge.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    self.tempGauge.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    self.tempGauge.scaleSubdivisionsWidth = 0.002;
    self.tempGauge.scaleSubdivisionsLength = 0.04;
    self.tempGauge.scaleDivisionsWidth = 0.007;
    self.tempGauge.scaleDivisionsLength = 0.07;
    self.tempGauge.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    self.tempGauge.needleWidth = 0.002;
    self.tempGauge.needleHeight = 0.5;
    self.tempGauge.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    self.tempGauge.needleScrewRadius = 0.05;

    //Set Value HERE !
    [self.tempGauge setValue:75 animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView animation complete");
    }];


}
- (void)HappyGaugeEnable
{
    self.gaugeDisplay.maxValue = 100.0;
    self.gaugeDisplay.scaleDivisions = 10;
    self.gaugeDisplay.scaleSubdivisions = 5;
    self.gaugeDisplay.scaleStartAngle = 30;
    self.gaugeDisplay.scaleEndAngle = 280;
    self.gaugeDisplay.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    self.gaugeDisplay.showScaleShadow = NO;
    self.gaugeDisplay.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    self.gaugeDisplay.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    self.gaugeDisplay.scaleSubdivisionsWidth = 0.002;
    self.gaugeDisplay.scaleSubdivisionsLength = 0.04;
    self.gaugeDisplay.scaleDivisionsWidth = 0.007;
    self.gaugeDisplay.scaleDivisionsLength = 0.07;
    self.gaugeDisplay.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    self.gaugeDisplay.needleWidth = 0.002;
    self.gaugeDisplay.needleHeight = 0.5;
    self.gaugeDisplay.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    self.gaugeDisplay.needleScrewRadius = 0.05;

    //Set Value HERE !
    [self.gaugeDisplay setValue:25 animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView animation complete");
    }];
}

#pragma mark -
#pragma mark - Weather Graph
-(void)getWeather
{
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast?lat=51.7533130&lon=-1.2574110"]];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=51.7533130&lon=-1.2574110&cnt=10&mode=json"]];
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               NSDictionary *list = json[@"list"];
                               //NSLog(@"Async JSON: %@", list);
                               self.tempOf10 = [NSMutableArray new];
                               self.desOf10 = [NSMutableArray new];
                               for (NSDictionary *dic1 in list) {

                                   //GET TEMPERATURE
                                   NSDictionary *dic2 = dic1[@"temp"];
                                   NSString *mornTempK = dic2[@"morn"];
                                   float tempFloat = [mornTempK floatValue] - 272.15;
                                   NSString *tempC = [NSString stringWithFormat:@"%.1f", tempFloat];
                                   //NSLog(@"temp is %@ in celcius", tempC);
                                   [self.tempOf10 addObject:tempC];

                                   //GET DESCRIPTION
                                   //NSLog(@"%@ ", [dic1[@"weather"] firstObject][@"description"]);
                                   [self.desOf10 addObject:[dic1[@"weather"] firstObject][@"description"]];
                               }
                               NSLog(@"temp array contains %@", self.tempOf10);
                               NSLog(@"description array contains %@", self.desOf10);
                               [self.lineGrpah reloadGraph];
                           }];
}

-(void)reloadGraph
{
    [self.lineGrpah reloadGraph];
}

#pragma mark - Graph Value
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return self.tempOf10.count; //number of points in the graph
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return [[self.tempOf10 objectAtIndex:index] floatValue];
}

#pragma mark - Graph Axis
- (NSString *)labelOnXAxisForIndex:(NSInteger)index
{
    // the time
    return [self.dateOf10 objectAtIndex:index];
}
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 10;
}

#pragma mark - graph touching 
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index
{
    self.rainConditionLabel.text = [NSString stringWithFormat:@"Rain condition: %@",[self.desOf10 objectAtIndex:index]];
}

-(void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index
{
}
@end
