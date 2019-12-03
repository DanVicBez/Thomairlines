<%@ page import ="java.sql.*"%>
<%@ page import ="java.time.LocalDateTime"%>
<%@ page import ="java.time.format.DateTimeFormatter"%>
<html>
	<head>
		<title>Login Form</title>
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
		<div id="banner">
			<img alt = "Thomairlines" src = "https://i.imgur.com/NfZWVqI.jpg" width = 55px style = "display: inline"/>
			<h1>Thomairlines</h1>
		</div>
		<%
		    if ((session.getAttribute("user") == null)) {
		%>
				You are not logged in<br/>
				<a href="login.jsp">Please Login</a>
		<%
			} else {
		%>
				<div id = 'pageText'>
					Welcome, <%=session.getAttribute("user")%>!
					<br>
					<a href='logout.jsp'>Log out</a>
				</div>
				<select id = 'airportSelect' required style = "margin-left: 10%">
					<%
					String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
					Class.forName("com.mysql.jdbc.Driver");
					Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
					ResultSet rs = con.prepareStatement("SELECT * FROM Airport").executeQuery();
					%>
					<option selected disabled>Departure Airport</option>
					<%
					while(rs.next()) {
						%>
						<option><%=rs.getString(2)%> (<%=rs.getString(1)%>)</option>
						<%
					}
					%>
				</select>
				<select id = 'airportSelect' required>
					<%
					// TODO: prevent people from selecting same airport as departure
					rs = con.prepareStatement("SELECT * FROM Airport").executeQuery();
					%>
					<option selected disabled>Arrival Airport</option>
					<%
					while(rs.next()) {
						%>
						<option><%=rs.getString(2)%> (<%=rs.getString(1)%>)</option>
						<%
					}
					%>
				</select>
				<%
				LocalDateTime now = LocalDateTime.now();
				DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				// TODO: ban people from selecting later departure than arrival dates
				%>
				<input type="date" name="departureDate" id="ddateinput" value = <%=dtf.format(now)%> min = <%=dtf.format(now)%>/>
				<input type="date" name="arrivalDate" id="adateinput" value = <%=dtf.format(now)%> min = <%=dtf.format(now)%>/>
				
				<!--<img alt = "Thomairlines" src = "https://i.imgur.com/NfZWVqI.jpg" width = 200px style="float:right; margin-right: 5%"/>-->
				<img alt = "Balouek's Eyewear" src = "https://i.imgur.com/UbjLxeh.jpg" width = 200px style="float:right; margin-right: 5%"/>
		<%
			}
		%>
	</body>
</html>