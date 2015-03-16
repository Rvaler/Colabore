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
@property (strong, nonatomic) CLLocation *loc;

//teste
@end

@implementation COLMapViewController{
    NSString *latitudeString;
    NSString *longitudeString;
    NSError *_lastLocationError;
    BOOL _updatingLocation;
    BOOL _performingReverseGeocoding;
    CLGeocoder *_geocoder;
    NSError *_lastGeocodingError;
    CLPlacemark *_placemark;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [[self locationManager] setDelegate:self];
    [[self mapView] setDelegate:self];
    
    [self alertRequisicao];
    
    NSLog(@"%@", [[[COLManager manager] user] username]);
}

-(void)alertRequisicao
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
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
    else {
        [self.locationManager startUpdatingLocation];
        _isLocating = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapKit

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!pinView) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        if (annotation == mapView.userLocation){
            customPinView.image = [UIImage imageNamed:@"Logo-Red + StickMan.png"];
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


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    // Se o momento em que o novo objecto foi determinada localização é muito longo
    // Atrás (5 segundos no presente caso), então este é um resultado em cache. Vamos ignorar
    // Esses locais em cache, pois eles podem estar desatualizados.
    
    if ([newLocation.timestamp timeIntervalSinceNow] < -5.0)
    {
        return;
    }
    // Ignorar medições inválidos.
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    // Calcule a distância entre a nova leitura e do antigo. Se esta
    // É a primeira leitura, então não há local anterior para comparar
    // E vamos definir o raio de um número muito grande (MAXFLOAT).
    CLLocationDistance distance = MAXFLOAT;
    if (_loc != nil) {
        distance = [newLocation distanceFromLocation:_loc];
    }
    // Executar o código a seguir somente se a nova localização oferece uma forma mais
    // Leitura precisa do que a anterior, ou se é a primeira.
    if (_loc == nil || _loc.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // Coloque as novas coordenadas na tela.
        _lastLocationError = nil;
        _loc = newLocation;
        // Terminamos se a nova localização é precisa o suficiente.
        if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            
            [self stopLocationManager];
            // Vamos forçar uma geocodificação reversa para esse resultado final se
            // Não tiver feito este local.
            if (distance > 0) {
                _performingReverseGeocoding = NO;
            }
        }
        // Não é suposto para executar mais de uma geocodificação reversa
        // Pedido ao mesmo tempo, tão somente continuar, se já não estiver ocupado.
        if (!_performingReverseGeocoding) {
            
            // Iniciar uma nova solicitação de geocodificação reversa e atualizar a tela
            // Com os resultados (um novo marcador ou mensagem de erro).
            _performingReverseGeocoding = YES;
            
            [_geocoder reverseGeocodeLocation:_loc completionHandler:^(NSArray *placemarks, NSError *error){
                
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
        latitudeString = [NSString stringWithFormat:@"%.8f",  _loc.coordinate.latitude];
        longitudeString = [NSString stringWithFormat:@"%.8f", _loc.coordinate.longitude];
        
    }else if (distance < 10.0){
        NSTimeInterval timeInterval = [newLocation.timestamp timeIntervalSinceDate:_loc.timestamp];
        if (timeInterval > 10) {
            [self stopLocationManager];
        }
    }
    
    latitudeString = [NSString stringWithFormat:@"%.8f",  _loc.coordinate.latitude];
    longitudeString = [NSString stringWithFormat:@"%.8f", _loc.coordinate.longitude];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorLocationUnknown) {
        return;
    }
    [self stopLocationManager];
    _lastLocationError = error;
    
}

-(void)stopLocationManager{
    if (_isLocating) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
        [self.locationManager stopUpdatingLocation];
        _locationManager.delegate = nil;
        _isLocating = NO;
    }
}

-(void)didTimeOut:(id)obj{
    if(_loc == nil){
        [self stopLocationManager];
        _lastLocationError = [NSError errorWithDomain:@"MyLocationErrorDomain" code:1 userInfo:nil];
    }
}
- (IBAction)locationUser:(id)sender {
    MKCoordinateRegion viewRegionLocation = MKCoordinateRegionMakeWithDistance([self.locationManager location].coordinate, 100, 100);
    [self.mapView setRegion:viewRegionLocation animated:YES];
}



- (IBAction)showPopUp:(UIButton *)sender {

    _popup = [[COLPopUpViewController alloc] init];
    [_popup setCurrentLocation:_loc];
    [_popup showPopUpOnView:self.view animated:YES];
    
}

- (IBAction)showMenu:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"segueMapToMenu" sender:sender];
    
}
# pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


-(IBAction)backFromMenuToMap:(UIStoryboardSegue*)segue
{
    
}


@end
