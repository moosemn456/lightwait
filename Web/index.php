<?php

  session_cache_limiter(false);
  session_start();
  if ($_SESSION['userType'] == 0) {
    header('Location: order.php');
    die();
  }

  else if ($_SESSION['userType'] == 1){

  }

  else if ($_SESSION['userType'] == 2){

  }
	
  $pageTitle = "Home";
	$navElements = array("queue"=>"queue.php","adminstrator"=>"administrator.php");
   $javascript = 'javascript/account.js';
	include('include/header.php');
?>
	<div class="content">
      <div class="accountForm">
   		<h1>Log In</h1>
   		<form id="loginForm" method="POST" action="#">
   			<input class="textForm" type="email" name="email"  placeholder="Email" required ><br/>
   			<input class="textForm" type="password" name="password" placeholder="Password" pattern=".{8,20}" required><br/>
   			<input class="formSubmit" type="submit" value="Log In">
   		</form>
   	</div>
        <div class="accountForm">
            <h1>Create an Account</h1>
            <form id="createAccountForm" method="POST" action="#">
                <input class="textForm" type="email" name="email" placeholder="Email" required>
                <input class="textForm" type="password" name="password" pattern=".{8,20}" placeholder="Password" required>
                <input type="text" name="fName" placeholder="First Name" required>
                <input type="text" name="lName" placeholder="Last Name" required>
                <input type="tel" name="phone" placeholder="Phone Number" required>
                <input type="radio" name="accountType" id="customer" value="chef">
                <label for="customer">Customer</label>
                <input type="radio" name="accountType" id="chef" value="chef">
                <label for="chef">Chef</label>
                <input type="radio" name="accountType" id="admin" value="admin">
                <label for="admin">Administrator</label>
                <input class="formSubmit" type="submit" value="Create Account">
            </form>
        </div>
   </div>

</body>
</html>
