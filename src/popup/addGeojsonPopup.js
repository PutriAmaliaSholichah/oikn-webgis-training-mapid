import maplibregl from 'maplibre-gl';

export function FnbPopup(event){
    const feature = event.features[0];
    const properties = feature.properties
    const geometry = feature.geometry.coordinates
    console.log(feature)

    const content = `
        <h3>${properties.nama}</h3>
        <p><b>Telepon:</b> 
        ${properties.telepon || 'Tidak tersedia'}
        </p>

        <p><b>Alamat:</b><br>
        ${properties.alamat || 'Tidak tersedia'}
        </p>
    `
    return new maplibregl.Popup()
        .setLngLat(event.lngLat)
        .setHTML(content)
}