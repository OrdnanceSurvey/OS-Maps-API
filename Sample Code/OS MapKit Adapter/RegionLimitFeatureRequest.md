# MapKit Feature Request rdar://24146134

#### Classification:
Enhancement
#### Reproducibility:
Always

### Title:
`MKMapView` should be able to restrict region and zoom levels

### Description:
When using `MKTileOverlay` to supply map tiles to `MKMapView`, it would be nice to set a hard limit to the region and zoom levels of the map view so it's simple to supply tiles only for that region. I work for Ordnance Survey, Britain's national mapping agency, and we supply tiles that cover the UK, and build apps where we'd like to restrict any map using those tiles to only the UK. Whilst it's possible to do this using `mapView:regionDidChangeAnimated:`, because this method only fires after the region has changed, all you can do is move the view port back to your preferred region, and this looks very bad to the user. It seems a logical feature request that apps that supply their own tiles to MapKit would also want to provide restrictions to the map regions and zoom levels. Whilst it is possible to set a bounding box for the tile layer, the map view itself seems to ignore this.

### Steps to reproduce:
1. Create your own `MKTileOverlay` subclass for a specific region
2. Set bounding box for that tile overlay
3. Look to try to set that same limit on map view
4. Can't be done. Run app, see tiles are supplied for that region but Apple's tiles are added everywhere else.
5. Implement `mapView:regionDidChangeAnimated:` to restrict the region, but feel a bit sad about the end result.

### Expected results:
1. Look at `MKMapView` header
2. See API to restrict the map's region and zoom levels
3. Rejoice at the ability to use MapKit's otherwise excellent `MKMapView` with it's buttery smooth performance to show Ordnance Survey map data in iOS apps.

### Actual results:
1. Look at `MKMapView` header
2. See no API to restrict the map's region and zoom levels.
3. Resort to `mapView:regionDidChangeAnimated:`
4. Feel unfulfilled
