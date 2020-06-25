public class Domain {
    public static string dom(String name){
        
        name=name.substringAfter('//');
        name=name.substringBefore('.');
        System.debug('name@@@  '+name);
        return name;
    }
}