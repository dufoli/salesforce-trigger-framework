public abstract class APipelineItem {
    protected List<SObject> toInsert;
    protected List<SObject> toUpdate;
    //TODO delete/undelete ?
    private Map<String, List<Object>> dico;
    
    public APipelineItem (Map<String, List<Object>> dico) {
        this.dico = dico;
    }
    
    public void Write () {
        if (toInsert.size() >0) {
            insert toInsert;
        }
        if (toUpdate.size() >0) {
            update toUpdate;
        }
    }
}