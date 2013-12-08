<?php
	header('Content-type:application/json');

	$appID = $_POST['appID'];
	$restAPI = $_POST['restAPI'];
	$alert = $_POST['alert'];
	$channels = str_replace(' ', '', $_POST['channels']);
	$channels = explode(",",$channels);
	
	$url = 'https://api.parse.com/1/push';
	
	$data = json_encode(
		array(
			'channels' => $channels, 
			'type' => 'ios',
			'data' => array(
						'alert' => $alert,
						'sound' => 'push.caf',
						'badge' => 'Increment'
						)
				),true
	);
	
	$curl = curl_init();
	
	$curlArray = array(
		CURLOPT_POST => true,
		CURLOPT_POSTFIELDS => $data,
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_HEADER => false, 
		CURLOPT_ENCODING => "gzip",
		CURLOPT_HTTPHEADER => array(
			'X-Parse-Application-Id: ' . $appID,
			'X-Parse-REST-API-Key: ' . $restAPI,
			'Content-Type: application/json',
			'Content-Length: ' . strlen($data),
		),
		CURLOPT_URL => $url
	);
	
	curl_setopt_array($curl, $curlArray);
	
	$response = curl_exec($curl);
	$code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
		
	curl_close($curl);
	
	echo $response;
?>