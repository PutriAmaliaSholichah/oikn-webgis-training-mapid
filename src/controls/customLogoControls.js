export class CustomLogoControl {
    onAdd(map) {
        this._container = document.createElement('div');
        this._container.className = 'maplibregl-ctrl';
        this._container.innerHTML = '<img src="src/assets/img/toga-gold-ts.png" alt="Logo TOGA" style="width: 120px">';

        return this._container
    };

    onRemove() {
        this._container.parentNode.removeChild(this._container);
    }
}