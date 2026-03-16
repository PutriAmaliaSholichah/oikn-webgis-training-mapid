import maplibregl from 'maplibre-gl' //ini jd dependensi si navigation control
import { CustomLogoControl } from './customLogoControls'; //import custom logo control

export function addControl(map) { 
    map.addControl(new maplibregl.NavigationControl()); //navigation control
    map.addControl(
        new maplibregl.AttributionControl({
            customAttribution: '<a href="https://www.instagram.com/putrias.27/" target="_blank">© Putri Amalia Sholichah</a>'
        }),
        'bottom-left')
    map.addControl(
        new maplibregl.ScaleControl({
            unit:'metric',
            maxWidth: 200
        }),
    )
    map.addControl(new maplibregl.FullscreenControl())
    map.addControl(new maplibregl.GlobeControl())
    map.addControl(new maplibregl.LogoControl())
    map.addControl(new CustomLogoControl(),'top-left')

}