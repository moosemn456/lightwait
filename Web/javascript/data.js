google.load('visualization', '1.0', {'packages':['corechart','table']});
var mNumQueryGroups=1;
var mQueryGroupId=1;
const maxNumQueryGroups=8;

$(document).ready(function(){
	drawPieChart();
	testDQuery();

	getMenuData(); //Data in mMenu

	// Chart types navigation
	$('a#pieChart').click(function(e) {
		e.preventDefault();
		drawPieChart();
	});
	$('a#barGraph').click(function(e) {
		e.preventDefault();
		drawBarGraph();
	});
	$('a#lineGraph').click(function(e){
		e.preventDefault();
		drawLineGraph();
	});
	$('a#table').click(function(e){
		e.preventDefault();
		drawTable();
	});

	// Query type navigation
	$('a#simpleQuery').click(function(e){
		e.preventDefault();
		$('div#advancedQueryContainer').hide();
		$('div#simpleQueryContainer').show();
	});
	$('a#advancedQuery').click(function(e){
		$('div#simpleQueryContainer').hide();
		$('div#advancedQueryContainer').show();
		e.preventDefault();
	});

	/*   Advanced Query Form   */
	// Add new query group
	$('input[type=button][name=add]').click(function(e) {
		console.log("add");
		if (mNumQueryGroups < maxNumQueryGroups) {
			mNumQueryGroups++;
			var htmlQueryGroupForm = advancedQueryFromTemplate.replace(/idNum/g,++mQueryGroupId);
			$(e.target).before(htmlQueryGroupForm);
			$(e.target).prev().children('[name=delete]').click(function(e) {
				console.log("remove");
				if (mNumQueryGroups > 1) {
					$(e.target).parent().remove();
					mNumQueryGroups--;
				}
			});
		} else {
			alert("You can only have "+maxNumQueryGroups+" query groups.");
		}
		console.log("groups: "+mNumQueryGroups);
	});

	// Delete query group
	// Will remove query group as long as there is more than 1 query group
	$('input[type=button][name=delete').click(function(e) {
		console.log("remove");
		if (mNumQueryGroups > 1) {
			$(e.target).parent().remove();
			mNumQueryGroups--;
		}
		console.log("groups: "+mNumQueryGroups);
	});
	// Submit advanced query
	$('div#advancedQueryContainer input[name=query]').click(function(e) {
		e.preventDefault();
		alert("Advanced query");

		// Get info from form
	});

	/*   Simple Query Form   */
	// Submit simple query 
	$('form[name=simpleQuery] input[name=query]').click(function(e) {
		e.preventDefault();
		alert("Simple query");
		//TODO: Get info from database
		//TODO: Get json ready to draw things
		//TODO: draw things
	});
}); //End .ready()

/*****************/
/*   Inflaters   */
/*****************/
// !! This is deprecated
function inflateForm(menu) {
	var hasField = $('fieldset#hasIngredientsFormArea');
	var hasNotField = $('fieldset#hasNotIngredientsFormArea');
	for(var type in menu) {
		//console.log(typeof type);
		for(var item in type) {
			//console.log(typeof menu[type][item]);
			if(typeof menu[type][item] === "object") {
				var id = menu[type][item]['name']+"Checkbox";
				hasField.append('<input type="checkbox" name="ingredients" id="'+id+'" />');
				hasField.append('<label for="'+id+'"">'+menu[type][item]['name']+'</label>');
				id += "Not";
				hasNotField.append('<input type="checkbox" name="ingredients" id="'+id+'" />');
				hasNotField.append('<label for="'+id+'"">'+menu[type][item]['name']+'</label>');
			}
		}
	}
}

function inflateSimpleQuery(menu) {
	console.log("inflate");
	var field = $('fieldset#simpleQuery-types');
	for(var type in menu) {
		field.append('<input type="radio" name="type" id="simpleQuery-types-'+type+'"value="'+type+'"/>');
		field.append('<label for="simpleQuery-types-'+type+'">'+type+'</label>');
	}
}

/************/
/*   Form   */
/************/

/***********/
/*  AJAX   */
/***********/

//Get menu data from the database and call inflate function
function getMenuData() {
    $.ajax({
        type: 'GET',
        url: rootURL+"/ingredients",
        dataType: "json", // data type of response
        success: function(data){
            //console.log(JSON.stringify(data));
            inflateSimpleQuery(data);
        }
   });
}

function testDQuery() {
	console.log("hello?");
    $.ajax({
        type: 'POST',
        url: rootURL + '/squery',
        dataType: "json", // data type of response
        data: formToJSON(),
        success: function(data){
            console.log(data);
        },
        error: function(jqXHR, textStatus, errorThrown){
            console.log("Text query failed");
            console.log(jqXHR, textStatus, errorThrown);
        }
    });
}

function formToJSON() {

     return JSON.stringify({
		"returnType":"base_id"
	});
}


/******************************/
/*   Google chart functions   */
/******************************/
function drawPieChart() {
	var json = '[["Hamburger", 50],["Black Bean", 20],["Turkey", 60],["Chicken", 52],["Veggie", 89]]';
	var jObject = JSON.parse(json);

	// Create the data table.
	var data = new google.visualization.DataTable();
	data.addColumn('string', 'Base');
	data.addColumn('number', 'Quantity');
	data.addRows(jObject);

	//Set chart options
	var options = {'title':'All bases - pie chart',
	               'width':600,
	               'height':400};

	// Instantiate and draw our chart, passing in some options.
	var chart = new google.visualization.PieChart(document.getElementById('chart'));
	chart.draw(data, options);
}

function drawBarGraph() {
	var data = google.visualization.arrayToDataTable([
		['Year', 'Sales', 'Expenses'],
		['2004',  1000,      400],
		['2005',  1170,      460],
		['2006',  660,       1120],
		['2007',  1030,      540]
	]);

	var options = {
		title: 'Company Performance',
		hAxis: {title: 'Year', titleTextStyle: {color: 'red'}}
	};

	var chart = new google.visualization.ColumnChart(document.getElementById('chart'));
	chart.draw(data, options);
}

function drawLineGraph() {
	var data = google.visualization.arrayToDataTable([
		['Year', 'Sales', 'Expenses'],
		['2004',  1000,      400],
		['2005',  1170,      460],
		['2006',  660,       1120],
		['2007',  1030,      540]
	]);

	var options = {
		title: 'Company Performance'
	};

	var chart = new google.visualization.LineChart(document.getElementById('chart'));
		chart.draw(data, options);
}

function drawTable() {
	var data = new google.visualization.DataTable();
	data.addColumn('string', 'Name');
	data.addColumn('number', 'Salary');
	data.addColumn('boolean', 'Full Time');
	data.addRows(5);
	data.setCell(0, 0, 'John');
	data.setCell(0, 1, 10000, '$10,000');
	data.setCell(0, 2, true);
	data.setCell(1, 0, 'Mary');
	data.setCell(1, 1, 25000, '$25,000');
	data.setCell(1, 2, true);
	data.setCell(2, 0, 'Steve');
	data.setCell(2, 1, 8000, '$8,000');
	data.setCell(2, 2, false);
	data.setCell(3, 0, 'Ellen');
	data.setCell(3, 1, 20000, '$20,000');
	data.setCell(3, 2, true);
	data.setCell(4, 0, 'Mike');
	data.setCell(4, 1, 12000, '$12,000');
	data.setCell(4, 2, false);

	var table = new google.visualization.Table(document.getElementById('chart'));
	table.draw(data, {showRowNumber: true});

	google.visualization.events.addListener(table, 'select', function() {
		var row = table.getSelection()[0].row;
		alert('You selected ' + data.getValue(row, 0));
	});
}

/********************/
/*   Test Queries   */
/********************/
//TODO: remove these
var query1 = {
	"count":true,
	"startTime":"2014-03-30 12:04:03", 
	"endTime":"2014-04-30 12:04:03",
	"queryForAll":false,
	"queryForAny":true,
	"queryArray":{
		"base_id": ["1"],
		"bread_id":["1"],
		"fry_id":["1"]
	}
}

var query2 = {
	"count":true,
	"startTime":null, 
	"endTime":null,
	"queryForAll":false,
	"queryForAny":true,
}

var baseQuery = {
	"count":true,
	"startTime":null,
	"endTime":null,
	"searchForAll":false,
	"searchForAny":true,
	"returnType":"base_id"
}

var advancedQueryFromTemplate = '<form action="#" method="GET" name="queryGroup-idNum"><fieldset><legend>With</legend><textarea placeholder="ingredients" name="with"></textarea><input type="radio" name="andor" value="and" id="andRadioWith-idNum" /><label for="andRadioWith-idNum">And</label><input type="radio" name="andor" value="or" id="orRadioWith-idNum" /><label for="orRadioWith-idNum">Or</label></fieldset><fieldset><legend>Without</legend><textarea placeholder="ingredients" name="without"></textarea><input type="radio" name="andor" value="and" id="andRadioWithout-idNum" /><label for="andRadioWithout-idNum">And</label><input type="radio" name="andor" value="or" id="orRadioWithout-idNum" /><label for="orRadioWithout-idNum">Or</label></fieldset><fieldset><label for="dateGT-idNum">After</label><input type="date" name="dateGT" id="dateGT-idNum" /><input type="time" name="timeGT" id="timeGT-idNum" /></fieldset>';
advancedQueryFromTemplate+= '<fieldset><label for="dateLT-idNum">Before</label><input type="date" name="dateLT" id="dateLT-idNum" /><input type="time" name="timeLT" id="timeLT-idNum" /></fieldset>';
advancedQueryFromTemplate+=	'<input type="button" name="delete" value="Remove This Query Group" /></form>';




