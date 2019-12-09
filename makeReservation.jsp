<%@ page import ="java.sql.*" %>
<html>
	<head>
		<title>Reserve Form</title>
		<link rel="stylesheet" href="style.css"/>
		<meta charset="utf-8"/>
		<style>
			body {
	 			background-image: url("https://images.pexels.com/photos/440731/pexels-photo-440731.jpeg");
	 			background-repeat: no-repeat;
	 			background-attachment: fixed;
	  			background-size: 100%;
			}
		</style>
	</head>
	<body>
		<div id = "banner">
			<img alt = "Thomairlines" src = "https://i.imgur.com/NfZWVqI.jpg" width = 55px style = "display: inline"/>
			<h1>Thomairlines</h1>
		</div>
		<div>
			<img alt = "Reservation" src = "https://i.imgur.com/HdULqfn.jpg" width = 400px style = "display: inline; margin-bottom: 50px;"/>
		</div>
		<div>
			<form method="post" action="confirmReservation.jsp" align="center">
				<select  style = "height: 25px" id = 'meal' required name = "meal">
					<option disabled value="" selected>Choose Your Meal</option>
					<option>Steak</option>
					<option>Chicken</option>
					<option>Curry</option>
					<option>Lobster</option>
					<option>Salad(Contains Eggs)</option>
					<option>Kosher</option>
					<option>Veggie</option>
					<option>Halal</option>
				</select>
				<select style = "height: 25px" id = 'class' required name = "class">
					<option disabled value="" selected>Choose Your Class</option>
					<option>Economy</option>
					<option>Business (+$150)</option>
					<option>First (+$300)</option>
				</select>
				<input type = "hidden" name = "reserveFor" value ="<%=request.getParameter("reserveFor")%>"/>
				<input type = "hidden" name = "username" value ="<%=request.getParameter("username")%>"/>
				<input type = "hidden" name = "group1" value = "<%=request.getParameter("group1")%>"/>
				<input type = "hidden" name = "group2" value = "<%=request.getParameter("group2")%>"/>
				<button>Reserve</button>
			</form>
		</div>
	</body>
</html>