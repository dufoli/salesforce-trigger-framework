/*
* @description This is the rollup summary calculation system for lookup, owner or task/event whatid/whoid link
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class RollupSummary_UTL {

    private class RollupDefinition {
        //TODO make getters and private properties
        public string childObject;
        public string childField;
        public string childParentId;
        public DataSource.QueryAggregation aggregation;
        public string filter;
        public string parentAggregateField;
        public string parentObject;
        public RollupDefinition(string childObject, string childField,
        string childParentId, DataSource.QueryAggregation aggregation,
        string filter,
        string parentAggregateField, string parentObject) {
            this.childObject = childObject;
            this.childField = childField;
            this.childParentId = childParentId;
            this.aggregation = aggregation;
            this.filter = filter;
            this.parentAggregateField = parentAggregateField;
            this.parentObject = parentObject;
        }
    }
    //DataSource.QueryAggregation.COUNT
    private Map<String, List<RollupDefinition>> rollupDefinitions;

    static {
        rollupDefinitions = new Map<String, List<RollupDefinition>> ();
        // Fill rollup definition here
    }

    public static void refreshRollupSummary (String ObjectType, Set<Id> ids) {
        List<RollupDefinition> defs = rollupDefinitions.get(ObjectType);
        if (defs != null && defs.size() > 0) {
            for (RollupDefinition def : defs) {
                refreshRollupSummary(def.childObject, def.childField, def.childParentId,
                    def.aggregation, def.filter, def.parentAggregateField, def.parentObject, ids);
            }
        }
    }
    @future
    public static void refreshRollupSummary(string childObject, string childField,
        string childParentId, DataSource.QueryAggregation aggregation,
        string filter,
        string parentAggregateField, string parentObject, Set<Id> ids) {
        // calculate aggregate of childs
        String query = 'SELECT ';
        if (string.isBlank(childParentId)) {
            system.debug('group field is mandatory');
            return;
        }
        query += childParentId + ', ';
        switch on aggregation {
            WHEN DataSource.QueryAggregation.COUNT {
                query += 'COUNT(';
            }
            WHEN DataSource.QueryAggregation.AVG {
                query += 'AVG(';
            }
            WHEN DataSource.QueryAggregation.MAX {
                query += 'MAX(';
            }
            WHEN DataSource.QueryAggregation.MIN {
                query += 'MIN(';
            }
            WHEN DataSource.QueryAggregation.SUM {
                query += 'SUM(';
            }
            WHEN else {
                System.debug('none is not allowed');
                return;
            }
        }
        query += childField + ') agg FROM ' + childObject;
        query += ' WHERE ' + childParentId + ' IN :ids '
        if (!string.isBlank(filter)) {
            query += 'AND ' + filter;
        }
        query += 'GROUP BY ' + childParentId;

        AggregateResult[] groupedResults = Database.query(query);
        //TODO merge SOQL to have a single query if possible
        // load parent object
        query = 'SELECT Id, ' + parentAggregateField + ' FROM ' + parentObject + ' WHERE Id IN :ids';
        List<SObject> objs = Database.query(query);
        for (SObject obj : objs) {
            string parentId = (string)obj.get('Id');
            for (AggregateResult ar : groupedResults)  {
                String objId = (String)ar.get(childParentId);
                Object agg = ar.get('agg');
                if (objId == parentId) {
                    obj.put(parentAggregateField, agg);
                }
            }
        }
        update objs;
    }
}