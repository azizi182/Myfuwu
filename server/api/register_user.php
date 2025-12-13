<?php
    header('Access-Control-Allow-Origin: *'); //for web to avoid crash
    include 'dbconnect.php'; // must have to connect database

    // for security
    if($_SERVER['REQUEST_METHOD'] != 'POST'){
        echo "Only POST method is allowed";
        exit();
    }

    if (!isset($_POST['email']) || !isset($_POST['password']) || !isset($_POST['name']) || !isset($_POST['phone'])) {
		http_response_code(400);
		echo json_encode(array('error' => 'Bad Request'));
		exit();
	}

    $email = $_POST['email'];
    $password = $_POST['password'];
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $address = $_POST['address'];
	$latitude = $_POST['latitude'];
	$longitude = $_POST['longitude'];
    $hashed_password = sha1($password); // change to hashed password for security
    $otp = rand(100000,999999);

    // Check if email already exists
    $sqlCheck = "SELECT * FROM `users` WHERE user_email = '$email'";
    $result = $conn->query($sqlCheck);

    if ($result->num_rows > 0) {
        $response = array("status" => "failed", "message" => "Email already registered");
        sendJsonResponse($response);
        exit();
    }
    
    // sql to insert data
    $sqlreg = $sqlregister = "INSERT INTO `users`(`user_email`, `user_name`, `user_phone`, `user_address`, `user_latitude`, `user_longitude`, `user_password`, `user_otp`) 
    VALUES ('$email','$name','$phone','$address','$latitude','$longitude', '$hashed_password','$otp')";
    
    try{
    //to insert data to database
        if($conn->query($sqlreg) === TRUE){ // query
            $response = array("status" => "success", "message" => "User registered successfully");
            sendJsonResponse($response);
        } else {
            $response = array("status" => "failed", "message" => "User registered failed");
            sendJsonResponse($response);
        }
    } catch(Exception $e){
        $response = array("status" => "error", "message" => "Error with database");
        sendJsonResponse($response);
    }

    function sendJsonResponse($response){
        header('Content-Type: application/json');
        echo json_encode($response);
    }
    
?>