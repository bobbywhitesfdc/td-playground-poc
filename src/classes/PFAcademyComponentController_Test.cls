@isTest
public class PFAcademyComponentController_Test {
    public static testMethod void testSetSelectedValue() {
        final String TEST_VALUE='Wahoo';
        PFAcademyComponentController controller = new PFAcademyComponentController();
        System.Assert(!controller.editMode,'Should default to False not-Edit');
        
        controller.selectedValue=null;
        System.AssertEquals(controller.selectedValue,null,'Expected null now');
        System.Assert(!controller.editMode,'Implicit set should disable Edit Mode');
        
        controller.selectedValue=TEST_VALUE;
        System.AssertEquals(controller.selectedValue,TEST_VALUE,'Set should have worked!');

        System.Assert(controller.editMode,'Implicit set should toggle editMode on');
    }

}