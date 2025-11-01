//Expose utilities functions, wraps Xrm static object
export class Utilities {

    private readonly _xrm: Xrm.XrmStatic;
    private readonly _api: Xrm.WebApi;

    constructor(xrm: Xrm.XrmStatic) {
        this._xrm = xrm;
        this._api = xrm.WebApi;
    }

    public get Api(): Xrm.WebApi {
        return this._api;
    }

    public get Navigation(): Xrm.Navigation {
        return this._xrm.Navigation;
    }
}
