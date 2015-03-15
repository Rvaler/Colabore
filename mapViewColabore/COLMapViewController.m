//
//  ViewController.m
//  mapViewColabore
//
//  Created by Matheus Becker on 06/03/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import "COLMapViewController.h"

@interface COLMapViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) COLManager *manager;

-(void)requireLocateAutorization;
@end

@implementation COLMapViewController{
    BOOL _updatingLocation;
    BOOL _performingReverseGeocoding;
    NSString *latitudeString;
    NSString *longitudeString;
    NSError *_lastLocationError;
    CLGeocoder *_geocoder;
    NSError *_lastGeocodingError;
    CLPlacemark *_placemark;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setManager:[COLManager manager]];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [[self locationManager] setDelegate:self];
    [[self mapView] setDelegate:self];
    
    [self requireLocateAutorization];
}

-(void)requireLocateAutorization{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locationManager startUpdatingLocation];
        _isLocating = YES;
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
             [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        
        UIAlertController *alertLocationSettings = [UIAlertController alertControllerWithTitle:@"Autorizações" message:@"Autorize o Colaborê a utilizar sua localização para mostrar sua região no mapa." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Configurar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *controller){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertLocationSettings addAction:cancel];
        [alertLocationSettings addAction:settings];
        
        [self presentViewController:alertLocationSettings animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapKit

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [[self mapView] setRegion:[self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100, 100)] animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!pinView) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        if (annotation == mapView.userLocation){
            customPinView.image = [UIImage imageNamed:@"pin-stickman"];
        }
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        return customPinView;
        
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}


# pragma mark - CLLocationManagerDelegate Methods


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lastUserLocation = [[[self manager] user] userlocation];
    CLLocation *newLocation = [locations lastObject];
    
    if ([newLocation.timestamp timeIntervalSinceNow] < -5.0 || newLocation.horizontalAccuracy < 0)
    {
        return;
    }
    CLLocationDistance distanceFromLastUserLocation = MAXFLOAT;
    if (lastUserLocation != nil) {
        distanceFromLastUserLocation = [newLocation distanceFromLocation:lastUserLocation];
    }
    // Executar o código a seguir somente se a nova localização oferece uma forma mais
    // Leitura precisa do que a anterior, ou se é a primeira.
    if (lastUserLocation == nil || lastUserLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        
        _lastLocationError = nil;
        [[[self manager] user] setUserlocation:newLocation];
        
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            
            [self stopLocationManager];
            // Vamos forçar uma geocodificação reversa para esse resultado final se
            // Não tiver feito este local.
            if (distanceFromLastUserLocation > 0) {
                _performingReverseGeocoding = NO;
            }
        }
        // Não é suposto para executar mais de uma geocodificação reversa
        // Pedido ao mesmo tempo, tão somente continuar, se já não estiver ocupado.
        if (!_performingReverseGeocoding) {
            
            // Iniciar uma nova solicitação de geocodificação reversa e atualizar a tela
            // Com os resultados (um novo marcador ou mensagem de erro).
            _performingReverseGeocoding = YES;
            
            [_geocoder reverseGeocodeLocation:lastUserLocation completionHandler:^(NSArray *placemarks, NSError *error){
                
                _lastGeocodingError = error;
                if (error == nil && [placemarks count] > 0) {
                    _placemark = [placemarks lastObject];
                }else{
                    _placemark = nil;
                }
                _performingReverseGeocoding = NO;
            }];
        }
        // Se a distância não se alterou significativamente desde a última vez e tem
        // Sido um tempo desde que recebemos a leitura anterior (10 segundos), em seguida,
        // Assumir este é o melhor que vai ser e parar de buscar a localização.
        latitudeString = [NSString stringWithFormat:@"%.8f",  lastUserLocation.coordinate.latitude];
        longitudeString = [NSString stringWithFormat:@"%.8f", lastUserLocation.coordinate.longitude];
        
    }else if (distanceFromLastUserLocation < 10.0){
        NSTimeInterval timeInterval = [newLocation.timestamp timeIntervalSinceDate:lastUserLocation.timestamp];
        if (timeInterval > 10) {
            [self stopLocationManager];
        }
    }
    
    latitudeString = [NSString stringWithFormat:@"%.8f",  lastUserLocation.coordinate.latitude];
    longitudeString = [NSString stringWithFormat:@"%.8f", lastUserLocation.coordinate.longitude];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorLocationUnknown) {
        return;
    }
    [self stopLocationManager];
    _lastLocationError = error;
    
}

- (void)stopLocationManager{
    if (_isLocating) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
        
        [self.locationManager stopUpdatingLocation];
        _locationManager.delegate = nil;
        _isLocating = NO;
    }
}

- (void)didTimeOut:(id)obj{
    if([[[self manager] user] userlocation] == nil){
        [self stopLocationManager];
        _lastLocationError = [NSError errorWithDomain:@"MyLocationErrorDomain" code:1 userInfo:nil];
    }
}

- (IBAction)buttonCenterByUserLocation:(id)sender {
    [[self mapView] setRegion:MKCoordinateRegionMakeWithDistance([[[self locationManager] location] coordinate], 100, 100) animated:YES];
}

- (IBAction)showPopUp:(UIButton *)sender {
    _popup = [[COLPopUpViewController alloc] init];
    [_popup showPopUpOnView:self.view animated:YES];
}

- (IBAction)showMenu:(UIButton *)sender {
    [self performSegueWithIdentifier:@"segueMapToMenu" sender:sender];
}

-(IBAction)backFromMenuToMap:(UIStoryboardSegue*)segue
{
    
}


@end
