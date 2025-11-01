import { Utilities } from "../shared/utilities";

export class ContactForm {

    private readonly _formContext:Xrm.FormContext;
    private readonly _utilities:Utilities;

    private static _form:ContactForm

    constructor(formContext:Xrm.FormContext){
        this._formContext = formContext;

        this._utilities = new Utilities(Xrm);
    }

    private onLoad(){
        this._utilities.Navigation.openAlertDialog({title:"INFO",text:"Demo-Form Loaded"});
    }
    
    //for registration in make.powerapps.com pass ContactForm.onLoad 
    //pass execution context
    public static onLoad(executionContext:Xrm.Events.EventContext){
            this._form = new ContactForm(executionContext.getFormContext());
            this._form.onLoad();
    }
}
