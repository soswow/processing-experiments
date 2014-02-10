// These go in a .js tab in my sketch (the PDE), say utils.js

/**
 *    Handy sorting of ArrayLists in a Java-sane syntax.
 */
var Collections = {
    sort: function ( list, comparator ) {
        var arr = list.toArray();
        if ( comparator )
            arr.sort(comparator.compare);
        else
            arr.sort();
        list.clear();
        list.addAll(arr);
    }
};

/**
 *    Mimik Arrays.sort()
 */
var Arrays = {
    sort: function ( arr, comparator ) {
        if ( comparator )
            arr.sort( comparator.compare );
        else
            arr.sort();
    }
}
