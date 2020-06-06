/*
* @description This is the rollup summary calculation system for lookup, owner or task/event whatid/whoid link
* @author: Olivier Dufour
* @date May 22, 2020
*/
global class RollupSummary_UTL {

    private class RollupDefinition {
        //TODO make getters and private properties
        public string childObject;
        public string childField;
        public string childParentId;
        public integer aggregation;
        public string filter;
        public string parentAggregateField;
        public string parentObject;
        public RollupDefinition(string childObject, string childField,
        string childParentId, integer aggregation,
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
    global static final integer aggregationCount = 1;
    global static final integer aggregationAvg = 2;
    global static final integer aggregationSum = 3;
    global static final integer aggregationMax = 4;
    global static final integer aggregationMin = 5;
    global static final integer aggregationCountDistinct = 6;
    // enum not supported in future method
    // so can not used DataSource.QueryAggregation.COUNT

    private static Map<String, List<RollupDefinition>> rollupDefinitions;

    static {
        rollupDefinitions = new Map<String, List<RollupDefinition>> ();
        // Fill rollup definition here
    }

    public static void registerRollupDefinition (string childObject, string childField,
        string childParentId, integer aggregation, string filter,
        string parentAggregateField, string parentObject) {
        List<RollupDefinition> l = rollupDefinitions.get (childObject);
        if (l == null) {
            l = new List<RollupDefinition> ();
            rollupDefinitions.put (childObject, l);
        }
        RollupDefinition r = new RollupDefinition(childObject, childField, childParentId,  aggregation, filter, parentAggregateField, parentObject);
        l.add (r);
    }

    public static void refreshRollupSummary (String ObjectType, List<SObject> objs) {
        system.debug('refreshRollupSummary started on '+ ObjectType);
        List<RollupDefinition> defs = rollupDefinitions.get(ObjectType);
        if (defs != null && defs.size() > 0) {
            for (RollupDefinition def : defs) {
                Set<Id> ids = new Set<Id> ();
                for (Sobject obj : objs) {
                    ids.add((Id)obj.get(def.childParentId));
                }
                system.debug('refreshRollupSummary async call');
                asyncrefreshRollupSummary(def.childObject, def.childField, def.childParentId,
                    def.aggregation, def.filter, def.parentAggregateField, def.parentObject, ids);
            }
        }
    }
    @future
    public static void asyncrefreshRollupSummary(string childObject, string childField,
        string childParentId, integer aggregation, string filter,
        string parentAggregateField, string parentObject, Set<Id> ids) {
        // calculate aggregate of childs
        system.debug('AGGREGATE started');
        String query = 'SELECT ';
        if (string.isBlank(childParentId)) {
            system.debug('group field is mandatory');
            return;
        }
        query += childParentId + ', ';
        if (aggregation == RollupSummary_UTL.aggregationCount) {
                query += 'COUNT(';
        } else if (aggregation == RollupSummary_UTL.aggregationAvg) {
            query += 'AVG(';
        } else if (aggregation == RollupSummary_UTL.aggregationMax) {
            query += 'MAX(';
        } else if (aggregation == RollupSummary_UTL.aggregationMin) {
            query += 'MIN(';
        } else if (aggregation == RollupSummary_UTL.aggregationSum) {
            query += 'SUM(';
        } else if (aggregation == RollupSummary_UTL.aggregationCountDistinct) {
            query += 'COUNT_DISTINCT(';
        } else {
            System.debug('agregation not allower is not allowed');
            return;
        }
        query += childField + ') agg FROM ' + childObject;
        query += ' WHERE ' + childParentId + ' IN :ids ';
        if (!string.isBlank(filter)) {
            query += 'AND ' + filter;
        }
        query += 'GROUP BY ' + childParentId;
        system.debug('AGGREGATE query :' + query);
        AggregateResult[] groupedResults = Database.query(query);
        //TODO merge SOQL to have a single query if possible
        // load parent object
        System.Type t = Type.forName(parentObject);
        //query = 'SELECT Id, ' + parentAggregateField + ' FROM ' + parentObject + ' WHERE Id IN :ids';
        //system.debug('AGGREGATE query parent :' + query);
        //List<SObject> objs = Database.query(query);
        List<SObject> objs = new List<SObject>();
        for (string parentId : ids) {
            for (AggregateResult ar : groupedResults)  {
                String objId = (String)ar.get(childParentId);
                Object agg = ar.get('agg');
                if (objId == parentId) {
                    SObject sobj = (SObject)t.newInstance();
                    sobj.put('Id', parentId);
                    sobj.put(parentAggregateField, agg);
                    objs.add(sobj);
                }
            }
        }
        if (objs.size() > 0) {
            update objs;
        }
        system.debug('AGGREGATE finished');
    }
}