<%@ page import ="java.sql.*"%>
<%@ page import ="java.time.LocalDateTime"%>
<%@ page import ="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<html>
	<head>
		<title>Thomairlines</title>
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
		<%
		boolean one = false;
		boolean two = false;
		%>
		<div id="banner">
			<img alt="Thomairlines" src="https://i.imgur.com/NfZWVqI.jpg" width=55px style="display: inline"/>
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
				<div id="pageText">
					Welcome, <%=session.getAttribute("user")%>!
					<br>
					<br>
					<a href="reservations.jsp">My Reservations</a>
					<br>
					<%
						if((Boolean) session.getAttribute("rep")) { 
					%>
							<a href="representative.jsp">Representative Dashboard</a>
					<%
						} else if((Boolean) session.getAttribute("admin")) {
					%>
							<a href="administrator.jsp">Administrator Dashboard</a>
					<%
						}
					%>
					<br>
					<a href="logout.jsp">Log out</a>
					<br>
					<br>
					<br>
				</div>
				<form method="post" action="search.jsp" align="center" >
					<table align="center">
						<tr>
							<th>From?</th>
							<th>To?</th>
							<th>Departure Date</th>
							<th>Return Date</th>
						</tr>
						<tr>
							<td id="searchtd">
								<select name="fromAirport" id="airportSelect" required>
									<%
										String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
										Class.forName("com.mysql.jdbc.Driver");
										Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
										ResultSet rs = con.prepareStatement("SELECT * FROM Airport").executeQuery();
									%>
									<option value="" selected disabled>Departure Airport</option>
									<%
										while(rs.next()) {
											%>
												<option><%=rs.getString(2)%> (<%=rs.getString(1)%>)</option>
											<%
										}
									%>
								</select>
							</td>
							<td id="searchtd">
								<select name="toAirport" id="airportSelect" required>
									<%
										// TODO: prevent people from selecting same airport as departure
										rs=con.prepareStatement("SELECT * FROM Airport").executeQuery();
									%>
									<option value="" selected disabled>Arrival Airport</option>
									<%
										while(rs.next()) {
											%>
												<option><%=rs.getString(2)%> (<%=rs.getString(1)%>)</option>
											<%
										}
									%>
								</select>
							</td>
							<%
								LocalDateTime now=LocalDateTime.now();
								DateTimeFormatter dtf=DateTimeFormatter.ofPattern("yyyy-MM-dd");
								// TODO: ban people from selecting later departure than arrival dates
							%>
							<td id="searchtd">
								<input type="date" name="fromDate" id="ddateinput" value=<%=dtf.format(now)%> min=<%=dtf.format(now)%>></input>
							</td>
							<td id="searchtd">
								<input type="date" name="toDate" id="adateinput" value=<%=dtf.format(now)%> min=<%=dtf.format(now)%>></input>
							</td>
							
							<!--<img alt="Thomairlines" src="https://i.imgur.com/NfZWVqI.jpg" width=200px style="float:right; margin-right: 5%"/>-->
							<img alt="Balouek"s Eyewear" src="https://i.imgur.com/UbjLxeh.jpg" width=200px style="float:right; margin-right: 5%"/>
						</tr>
					</table>
					<select id = 'flightType' onchange = "oneway()" required name = "flightType">
						<option>Round-Trip</option>
						<option>One-Way</option>
					</select>
					<input type="checkbox" name = "flexibility"/>Flexible Dates
					<select id = 'sortBy' required name = "sortBy">
						<option selected>Not Sorted</option>
						<option>Price Sort</option>
						<option>Take-Off Time Sort</option>
						<option>Landing Time Sort</option>
					</select>
					<input type="checkbox" name = "reverse"/>Desc. Sort
					<table style="display:inline-table;">
						<tr>
							<td id = 'filtertd'>						
								<select id = 'filterByPrice' required name = "filterByPrice">
									<option selected>Price Filter</option>
									<option>Price &lt; $250</option>
									<option>Price &lt; $500</option>
									<option>Price &lt; $750</option>
									<option>Price &lt; $1000</option>
									<option>Price &lt; $1500</option>
								</select>
							</td>
							<td id = 'filtertd'>
								<select id = 'filterByStops' required name = "filterByStops">
									<option selected>Stop Filter</option>
									<option>At Most 1 Stop</option>
									<option>At Most 2 Stops</option>
								</select>
							</td>
							<td id = 'filtertd'>
								<select id = 'filterByAirline' required name = "filterByAirline">
									<option selected>Airline Filter</option>
									<%
									rs=con.prepareStatement("SELECT * FROM Airline").executeQuery();
									while(rs.next()) {
											%>
												<option><%=rs.getString(1)%> (<%=rs.getString(2)%>)</option>
											<%
										}
									%>
								</select>
							</td>
						</tr>
					</table>
					<button>Search</button>
				</form>
				<form method="post" onsubmit= "displayRadioValue()" action="makeReservation.jsp" align="center">
				<%
					rs = (ResultSet) session.getAttribute("results");
					if(rs != null) {
						%>
						<h1 class="section" style="margin-top: 120px">Departing Flights</h1>
						<%
						if (!rs.next()) {
							%>
							<div class="result">
								<p>No flights were found.</p>
							</div>
							<% 
						} else {
							int i = 0;
							one = true;
							do {
								%>
								<div class="result">
									<table>
										<tr>
											<td style="width: 40%"><%=rs.getString("airline_name")%> Flight <%=rs.getString("airline_id")%><%=rs.getInt("flight_num")%></td>
											<td style="width: 13%; text-align: right;"><%=rs.getString("d_airport_id")%></td>
											<td style="width: 5%">&rarr;</td>
											<td style="width: 13%"><%=rs.getString("a_airport_id")%></td>
											<td style="width: 10%">$<%=rs.getInt("price")%></td>
											<td style="width: 19%; text-align: center"><label for="1radio<%=i%>">Reserve Flight</label></td>
										</tr>
										<tr>
											<td>Number Of Stops: <%=rs.getString("stops")%></td>
											<td style="text-align: right"><%=rs.getString("departure_time").substring(0,5)%></td>
											<td></td>
											<td><%=rs.getString("arrival_time").substring(0,5)%></td>
											<td></td>
											<td style="text-align: center"><input type="radio" value =<%=rs.getString("airline_id") + rs.getString("flight_num")%> id="1radio<%=i%>" required name="group1"/></td>
										</tr>
									</table>
								</div>
								<%
								i++;
							} while(rs.next());
						}
						
						ResultSet rs2 = (ResultSet) session.getAttribute("results2");
						if(rs2 != null) {
							%>
							<h1 class="section">Returning Flights</h1>
							<%
							if (!rs2.next()) {
								%>
								<div class="result">
									<p>No results could be found</p>
								</div>
								<%
							} else {
								int i = 0;
								two = true;
								do {
									%>
									<div class="result">
										<table>
											<tr>
												<td style="width: 40%"><%=rs2.getString("airline_name")%> Flight <%=rs2.getString("airline_id")%><%=rs2.getInt("flight_num")%></td>
												<td style="width: 13%; text-align: right;"><%=rs2.getString("d_airport_id")%></td>
												<td style="width: 5%">&rarr;</td>
												<td style="width: 13%"><%=rs2.getString("a_airport_id")%></td>
												<td style="width: 10%">$<%=rs2.getInt("price")%></td>
												<td style="width: 19%; text-align: center"><label for="2radio<%=i%>">Reserve Flight</label></td>
											</tr>
											<tr>
												<td>Number Of Stops: <%=rs2.getString("stops")%></td>
												<td style="text-align: right"><%=rs2.getString("departure_time").substring(0,5)%></td>
												<td></td>
												<td><%=rs2.getString("arrival_time").substring(0,5)%></td>
												<td></td>
												<td style="text-align: center"><input type="radio" required value =<%=rs2.getString("airline_id") + rs2.getString("flight_num")%> id="2radio<%=i%>" name = "group2"/></td>
											</tr>
										</table>
									</div>
									<%
									i++;
								} while(rs2.next());
							}
						}
					}
					if (one || two) {
					%>
						<div id="reserve">
							<button>Reserve Flight(s)</button>
							<%
							if(session.getAttribute("rep") != null) {
							%>
							<p>Reserve flights for:</p>
							<input onclick="document.getElementById('username').disabled = true;" type="radio" name="reserveFor" id="radioSelf" value="self" required><label for="radioSelf">Myself</label><br>
							<input onclick="document.getElementById('username').disabled = false;" type="radio" name="reserveFor" id="radioOther" value="other" required><label for="radioOther">Another user:</label>
							<input type="text" id="username" name="username" placeholder="Username" disabled required/>
							<%
							}
							%>
						</div>
					<%
					}
					%>
				</form>
				<%
			}
		%>
		<script>
		function oneway() {
			if (document.getElementById('flightType').value === 'One-Way') {
				document.getElementById('adateinput').setAttribute('disabled','disabled');
			} else {
				document.getElementById('adateinput').removeAttribute('disabled');
			}
		}
		</script>
		<script> 
        function displayRadioValue() { 
            var elements1 = document.getElementsByName('group1');
            var elements2 = document.getElementsByName('group2');
            if (elements1 != null) {
            	for(i = 0; i < elements1.length; i++) { 
                    if(elements1[i].checked) {
                    	document.getElementByName('group1').setAttribute('value',elements1[i].value);
                    }
                   
                } 
            } else if (elements2 != null) {
            	for(i = 0; i < elements2.length; i++) { 
                    if(elements2[i].checked) {
                    	document.getElementByName('group2').setAttribute('value',elements2[i].value);
                    }
                    
                } 
            }
            
        } 
    	</script> 
		
	</body>
</html>