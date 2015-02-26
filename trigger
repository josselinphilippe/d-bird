//SCRIPT FOR GOOGLE FORM

/**
 * Read values coming from the form
 */
function onFormSubmission(e) {
  Logger.log("data!");
   
  /**
   * Use our own function to post to our table
   */
  postToCartoDB(
    e.namedValues.Datefound[0],
    e.namedValues.Species[0],
    e.namedValues.Lati[0],
    e.namedValues.Longi[0],
    e.namedValues.Deadinjured[0]
  );
}
 
/**
 * Insert into CartoDB
 */
function postToCartoDB(Datefound,Species,Lati,Longi,Deadinjured/**,latitude,longitude*/) {
  Logger.log("posting to CartoDB");
  
  /**
   * Keep your key private!
   */
  var cartodb_host = "dklein.cartodb.com";
  var cartodb_api_key = "#################";
  
  /**
   * Remove all single quotes
   */
  Datefound = Datefound.replace("'","''");
  Species = Species.replace("'","''");
  Lati = Lati.replace("'","''");
  Longi = Longi.replace("'","''");
  Deadinjured = Deadinjured.replace("'","''");
  
  /**
  *PREPARES LATI AND LONGI TO BE PLACED IN THE_GEOM
  */
  var lativar = Lati;
  var longivar = Longi;  
  var locvar = "CDB_LatLng("+lativar+","+longivar+")";
  
  /**
   * INSERT statement
   */
  var query = "INSERT INTO d_bird(datefound,species,lati,longi,deadinjured,the_geom) VALUES('"+Datefound+"','"+Species.replace(/'/g, "''")+"','"+Lati+"','"+Longi+"','"+Deadinjured+"',"+locvar+")";
 
  Logger.log("SQL: "+query);  
  
  /**
   * Assemble the POST parameters
   */
  var options = {
    "method" : "post",
    "payload" : {q:query,api_key:cartodb_api_key}
  };
 
  /**
   * Ship It
   */
  var response = UrlFetchApp.fetch("https://"+cartodb_host+"/api/v1/sql", options);
  var respObj=Utilities.jsonParse(response.getContentText());
  Logger.log("CDB call result: "+response.getContentText());
  
}
