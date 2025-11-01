import { ContactForm } from "../../src/forms/contactForm";
import { XrmMockGenerator } from "xrm-mock";

describe("ContactForm.onLoad",()=>{

    beforeAll(()=>{
         XrmMockGenerator.initialise();
    });

    test("should execute successfully when valid executionContext is provided",()=>{
        
        const executionContext = XrmMockGenerator.getEventContext();

        Xrm.Navigation.openAlertDialog = jest.fn().mockResolvedValue(true);

        const form = ContactForm.onLoad(executionContext);

        expect(Xrm.Navigation.openAlertDialog).toHaveBeenCalledTimes(1);
    });
});
