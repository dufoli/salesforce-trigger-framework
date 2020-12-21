/*
* @description Object writer
* @author: Olivier Dufour
* @date May 22, 2020
*/
public abstract class AObjectWriter {
    protected List<SObject> toInsert;
    protected List<SObject> toUpdate;
    protected Map<String, List<SObject>> dico;
    protected List<Database.SaveResult> inputs;
    AObjectWriter reject;
    AObjectWriter next;

    public AObjectWriter (Map<String, List<SObject>> dico) {
        this.dico = dico;
        this.toInsert = new List<SObject> ();
        this.toUpdate = new List<SObject> ();
    }

    public List<SObject> getAll(){
        List<SObject> l = new List<SObject> (toInsert);
        l.addAll(toUpdate);
        return l;
    }

    public addInput (Database.SaveResult r) {
        inputs.add(r);
    }

    public AObjectWriter resolve () {
        String name = String.valueOf(this).split(':')[0];
        if (toInsert.size() >0) {
            Database.SaveResult[] srList = Database.insert(toInsert, false);
            for (Database.SaveResult r : srList) {
                if (!r.isSuccess()) {
                    reject.addInput(r);
                } else {
                    next.addInput(r);
                }
            }
        }
        if (toUpdate.size() >0) {
            Database.SaveResult[] srList = Database.update(toUpdate, false);
            for (Database.SaveResult r : srList) {
                if (!r.isSuccess()) {
                    reject.addInput(r);
                } else {
                    next.addInput(r);
                }
            }
        }
        next.resolve ();
        reject.resolve ();
        return this;
    }
    public AObjectWriter onSucceed(AObjectWriter next) {
        this.next = next;
        return this;
    }
    public AObjectWriter onFailed(AObjectWriter reject) {
        this.reject = reject;
        return this;
    }
}