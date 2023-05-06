public class AnimalLocator{
    public static String getAnimalNameById(Integer id){//getAnimalNameById
        Http http = new Http();
        HttpRequest request= new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        //List<Object> animals = new List<Object>();
        Map<String,Object> animal = new Map<String,Object>();
        if(response.getStatusCode() == 200){
            Map<String,Object> result = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            System.debug('---result>'+result);
            //animals = (List<Object>)result.get('animals');
            animal = (Map<String,Object>)result.get('animal');
            System.debug('--->'+animal);
        }
        //return (String)animals[id];
        System.debug('<><><>'+animal.get('name'));
        return (String)animal.get('name');
    }
}