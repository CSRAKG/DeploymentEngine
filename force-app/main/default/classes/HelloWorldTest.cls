@isTest
public class HelloWorldTest {
    
    @isTest
    public static void testmethod1() 
    {
        Test.StartTest();
        HelloWorld.showMessage();
        Test.StopTest();
    }
    
}