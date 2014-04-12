<?php
	session_cache_limiter(false);
    session_start();
    if (!isset($_SESSION['userType']) || $_SESSION['userType'] != 2) {
        header('Location: index.php');
        die();
    }

	$navElements=array("availability"=>"availability.php","logout"=>"index.php",);
	$pageTitle = "Queue";
	$javascript='javascript/queue.js';
	include('include/header.php');
?>
	
	<div class="window">
		<h1>No pending orders</h1>
	</div>

	<div class="sidebar">
		<div id="quantityList">

		</div>
		<button id="recall">Recall</button>
		<div class="navigation">
			<img src="images/prev_arrow.png" alt="Previous Arrow" />
			<div id="page_number">1/1</div>
			<img src="images/next_arrow.png" alt="Next Arrow" />
		</div>
	</div>
</body>

</html>