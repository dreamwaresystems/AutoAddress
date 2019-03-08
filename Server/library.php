<?php
//
//  Shared Library Classes
//

global $CONFIG;

//
// Google Places API Key
//
include_once('./secret/apikey.php');

//
// fetch remote webpage or API endpoint
//
function fetchRemoteWebpage($url) {
		
	$options = array(
		CURLOPT_RETURNTRANSFER => true,     // return web page
		CURLOPT_HEADER         => false,    // don't return headers
		CURLOPT_FOLLOWLOCATION => true,     // follow redirects
		CURLOPT_ENCODING       => "",       // handle all encodings
		CURLOPT_USERAGENT      => "spider", // who am i
		CURLOPT_AUTOREFERER    => true,     // set referer on redirect
		CURLOPT_CONNECTTIMEOUT => 120,      // timeout on connect
		CURLOPT_TIMEOUT        => 120,      // timeout on response
		CURLOPT_MAXREDIRS      => 5,        // stop after 10 redirects
		CURLOPT_SSL_VERIFYPEER => false     // disable SSL cert checks
	);
	
	$ch = curl_init($url );
	curl_setopt_array($ch, $options);
	$content = curl_exec($ch);
	$errno = curl_errno($ch);
	$errmsg = curl_error($ch);
	//$header = curl_getinfo($ch);
	curl_close($c);
	
	// response array
	$result = array();
	$result["content"] = $content;
	$result["error_desc"] = $errmsg;
	$result["error_code"] = $errno;
	
	return $result;
}


//
// XSS/SQL Injection Protection
// TODO: Encapsulate these into a class structure using the Strategy pattern
//

// XXS protection
function sanitize_web($string) {
	return htmlspecialchars($str); 
}
function unsanitize_web($string) {
	return $string;
}
// MYSQL injection protection
function sanitize_db($string){
	return mysql_real_escape_string(trim($string));
}
function unsanitize_db($string) {
	return stripslashes($string);
}

// NOTE: This is NOT secure enough for production environments.  In the interest of time, I made this a very basic, static key.  
// 	     Ideally, this should be at the very least, a client-response hash handshake to authenticate the client along with proper 
//		 SSL protocols and certificate pinning.  Again, this is cheap and in the interest of time for THIS demo.  
//		 Don't think I don't take security seriously....
function DWSStaticAPICode() {
	return "J23RVFJR";
}
function validateAPICode($client_code) {
	if($client_code===DWSStaticAPICode())
		return true;
	return false;
}


?>