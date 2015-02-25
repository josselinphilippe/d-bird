/**
 * Read values coming from the form
 */
function onFormSubmission(e) {
  Logger.log("data!");
  
  
  /**
   * Use Google services to get coordinates from a locality string
   */
  //Georeference the submission
  //var loc = geocode(e.namedValues.location);
  
  /**
   * Use our own function to post to our table
   */
  postToCartoDB(
    e.namedValues.Datefound[0],
   // e.namedValues.Time_found[0],
    e.namedValues.Species[0],
    e.namedValues.Lati[0],
    e.namedValues.Longi[0],
    e.namedValues.Deadinjured[0]
  //  e.namedValues.Sex[0],
 //   e.namedValues.Age[0],
  //  e.namedValues.Your_name[0],
 //   e.namedValues.Contact_info[0],
 //   e.namedValues.Notes[0]
    
    
    //,
    
    
    //loc.lat,
    //loc.lng
  );
}
 
/**
 * Geocode using Google's services
 */
/**function geocode(address) {
  var response = UrlFetchApp.fetch("http://maps.googleapis.com/maps/api/geocode/json?address="+escape(address)+"&sensor=false");
  var respObj=Utilities.jsonParse(response.getContentText());
 
  var loc = {lat:NaN,lng:NaN};
  try {
    loc = respObj.results[0].geometry.location
  } catch(e) {
    Logger.log("Error geocoding: "+address);
  }
  return loc;
}     */
 
/**
 * Insert color into CartoDB
 */
function postToCartoDB(Datefound,Species,Lati,Longi,Deadinjured/**,latitude,longitude*/) {
  Logger.log("posting to CartoDB");
  
  /**
   * Keep your key private!
   */
  var cartodb_host = "dklein.cartodb.com";   //Your CartoDB domain
  var cartodb_api_key = "819b0c5916868603c2cd39fbf7e32c7590224a21";  //Your CartoDB API KEY
  

  
   
  /**
   * Remove all single quotes
   */
  Datefound = Datefound.replace("'","''");
 // Time_found = Time_found.replace("'","''");
  Species = Species.replace("'","''");
  Lati = Lati.replace("'","''");
  Longi = Longi.replace("'","''");
  Deadinjured = Deadinjured.replace("'","''");
 // Sex = Sex.replace("'","''");
 // Age = Age.replace("'","''");
 // Your_name = Your_name.replace("'","''");
 // Contact_info = Contact_info.replace("'","''");
 // Notes = Notes.replace("'","''");
  
  
 
  //THE GOOD STUFF
  
  var lativar = Lati;
  var longivar = Longi;  
  var locvar = "CDB_LatLng("+lativar+","+longivar+")";
  
  //OH YEAH
  
  
  /**
   * Here is the INSERT statement
   */
  var query = "INSERT INTO color_world(datefound,species,lati,longi,deadinjured,the_geom) VALUES('"+Datefound+"','"+Species+"','"+Lati+"','"+Longi+"','"+Deadinjured+"',"+locvar+")";
 
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
