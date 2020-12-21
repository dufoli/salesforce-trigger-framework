public class TriggerContext {
    private Map<String, List<SObject>> data;
    private Map<String, String> states;
    public TriggerContext() {
        data = new Map<String, List<SObject>> ();
        states = new Map<String, String> ();
    }
    public Map<String, List<SObject>> getData() {
        return data;
    }

    public void setState(String key, String val) {
        states.put(key, val);
    }

    public String getData(String key) {
        return states.get(key);
    }
}