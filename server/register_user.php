<?php
    header('Access-Control-Allow-Origin: *'); //for web to avoid crash
    include 'dbconnect.php'; // must have to connect database

    // for security
    if($_SERVER['REQUEST_METHOD'] != 'POST'){
        echo "Only POST method is allowed";
        exit();
    }

    if(!isset($_POST['email']) || !isset($_POST['password'])){
        echo "Email or password is not set";
        exit();
    }

    $email = $_POST['email'];
    $password = $_POST['password'];
    $name = $_POST['name'];
    $phone = $_POST['phone'];
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
    $sqlreg = "INSERT INTO `users`(`user_email`, `user_password`,`user_name`, `user_phone`, `user_otp`) VALUES ('$email','$hashed_password','$name','$phone','$otp')";

    
    try{
    //to popup message
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