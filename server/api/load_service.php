<?php
header("Access-Control-Allow-Origin: *"); // running as crome app
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $results_per_page = 10;
    if ( isset( $_GET[ 'curpage' ] ) ) {
        $curpage = ( int )$_GET[ 'curpage' ];
    } else {
        $curpage = 1;
    }
    $page_first_result = ( $curpage - 1 ) * $results_per_page;

    $baseQuery = "
        SELECT
            s.service_id,
            s.user_id,
            s.service_title,
            s.service_desc,
            s.service_district,
            s.service_type,
            s.service_rate,
            s.service_date,
            u.user_name,
            u.user_email,
            u.user_phone,
            u.user_regdate
        FROM services s
        JOIN users u ON s.user_id = u.user_id
    ";

    // Search logic
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sqlloadservices = $baseQuery . "
            WHERE s.service_title LIKE '%$search%'
                OR s.service_desc LIKE '%$search%'
                OR s.service_type LIKE '%$search%'
            ORDER BY s.service_id DESC";
    } else {
        $sqlloadservices = $baseQuery . " ORDER BY s.service_id DESC";
    }
    

    $result = $conn->query($sqlloadservices);

    $number_of_result = $result->num_rows;
    $number_of_page = ceil( $number_of_result / $results_per_page );

    $sqlloadservices .= " LIMIT $page_first_result, $results_per_page";
    $result = $conn->query($sqlloadservices);

    if ($result &&$result->num_rows > 0) {
        $servicedata = array();

        while ($row = $result->fetch_assoc()) {
            $servicedata[] = $row;
        }
        $response = array('status' => 'success', 'data' => 
        $servicedata,'numofpage'=>$number_of_page, 'numberofresult'=>$number_of_result);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data'=> null,'numofpage'=>$number_of_page, 'numberofresult'=>$number_of_result);
        sendJsonResponse($response);
    }

}else{
    $response = array('status' => 'failed');
    sendJsonResponse($response);
    exit();
}



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>