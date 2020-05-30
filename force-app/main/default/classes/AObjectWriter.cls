public abstract class AObjectWriter {
    protected List<SObject> toInsert;
    protected List<SObject> toUpdate;
    //TODO delete/undelete ?
    //todo Rename to ObjectWriter
    private Map<String, List<SObject>> dico;

    public AObjectWriter (Map<String, List<SObject>> dico) {
        this.dico = dico;
    }

    public void Write () {
    //populate dico so other pipeline can used it.
    String name = String.valueOf(this).split(':')[0];
        if (toInsert.size() >0) {
            insert toInsert;
            dico.put(name+'Insert', toInsert);
        }
        if (toUpdate.size() >0) {
            update toUpdate;
            dico.put(name+'Update', toUpdate);
        }
    }
}