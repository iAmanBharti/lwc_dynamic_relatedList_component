@isTest
private class AnimalLocatorTest {
    @isTest static void testAnimalLocatorFirst(){
        Test.setMock(HttpCalloutMock.class,new AnimalLocatorMock());
        String animalName = AnimalLocator.getAnimalNameById(2);
        System.assertEquals('bear',animalName);
    }
}