<%@ page import ="java.sql.*" %>
<%@ page import ="java.time.LocalDateTime"%>
<%@ page import ="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	String username = request.getParameter("username");
	String reserveFor = request.getParameter("reserveFor");
	
	if(reserveFor.equals("null") || reserveFor.equals("self")) {
		username = (String) session.getAttribute("user");
	}
	
// 	System.out.printf("reserving for user '%s'\n", username);

	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
// 	String group1 = "";
// 	String group2 = "";
// 	if (request.getParameter("group1") != null) {
// 		group1 = request.getParameter("group1").replace("/","");
// 	}
// 	if (request.getParameter("group2") != null) {
// 		group2 = request.getParameter("group2").replace("/","");
// 	}
	String group1 = request.getParameter("group1");
	String group2 = request.getParameter("group2");

	String ticketNum = "0";
	PreparedStatement p = con.prepareStatement("SELECT MAX(ticket_num) FROM Ticket t1");
	ResultSet pTemp = p.executeQuery();
	pTemp.next();
	if (pTemp.getString(1) != null) {
		ticketNum = pTemp.getString(1);
	}
	boolean onWait = false;
	if (!group1.equals("null") && group1.length() > 2) {
		String dReserveAirline = group1.substring(0,2);
		String dReserveFlightNumber = group1.substring(2);
		
		String flightClass;
		if (request.getParameter("class").startsWith("Eco")) {
			flightClass = "economy";
		} else if (request.getParameter("class").startsWith("Bus")) {
			flightClass = "business";
		} else {
			flightClass = "first";
		}
		PreparedStatement st2 = con.prepareStatement(String.format("SELECT %s_class_total - %s_class FROM Seat WHERE flight_num = ? AND airline_id = ?", flightClass, flightClass));
		
		st2.setString(1,dReserveFlightNumber);
		st2.setString(2,dReserveAirline);
		ResultSet temp = st2.executeQuery();
		temp.next();
		String result = temp.getString(1);
		int seatsAvailable = Integer.parseInt(result);
		
		if (seatsAvailable > 0) {
			
			PreparedStatement st3 = con.prepareStatement(String.format("UPDATE Seat SET %s_class = %s_class + 1 WHERE flight_num = ? AND airline_id = ?", flightClass, flightClass));
			st3.setString(1, dReserveFlightNumber);
			st3.setString(2, dReserveAirline);
			st3.executeUpdate();
			
			PreparedStatement st = con.prepareStatement("INSERT IGNORE INTO Reserves " +
						"VALUES (?,?,?);");
			st.setString(1,username);
			st.setString(2,dReserveFlightNumber);
			st.setString(3,dReserveAirline);
			st.executeUpdate();
			
			st = con.prepareStatement(String.format("INSERT INTO Ticket " +
					"VALUES (1 + %s,(SELECT price FROM Flight WHERE " +
					"airline_id = ? AND flight_num = ?) + ?,?,?,?,?,(SELECT %s_class FROM Seat WHERE flight_num = ? AND airline_id = ?),?);", ticketNum, flightClass));
			ticketNum = String.valueOf(Integer.parseInt(ticketNum) + 1);
			st.setString(1,dReserveAirline);
			st.setString(9,dReserveAirline);
			st.setString(2,dReserveFlightNumber);
			st.setString(8,dReserveFlightNumber);
			LocalDateTime now = LocalDateTime.now();
			DateTimeFormatter dtf= DateTimeFormatter.ofPattern("yyyy-MM-dd hh-mm-ss");
			st.setString(4,dtf.format(now));
			if (request.getParameter("class").startsWith("Eco")) {
				st.setString(3,"0");
				st.setString(5,"economy");
			} else if (request.getParameter("class").startsWith("Bus")) {
				st.setString(3,"150");
				st.setString(5,"business");
			} else {
				st.setString(3,"300");
				st.setString(5,"first");
			}
			st.setString(6,"40");
			st.setString(7,username);
			st.setString(10,(String)session.getAttribute("fromDate"));
			st.executeUpdate();
			
			st = con.prepareStatement(String.format("INSERT INTO AssociatedWith VALUES (%s,?,?,?,?)", ticketNum));
			st.setString(1,dReserveFlightNumber);
			st.setString(2,dReserveAirline);
			st.setString(3,(String)session.getAttribute("fromDate"));
			st.setString(4,request.getParameter("meal").toLowerCase());
			st.executeUpdate();
		} else {
			//waiting list
			PreparedStatement st = con.prepareStatement("INSERT INTO OnWaitingList VALUES (?,?,?)");
			st.setString(1,username);
			st.setString(2,dReserveFlightNumber);
			st.setString(3,dReserveAirline);
			onWait = true;
		}
	}
	if (!group2.equals("null") && group2.length() > 2) {
		String rReserveAirline = group2.substring(0,2);
		String rReserveFlightNumber = group2.substring(2);
		
		String flightClass;
		if (request.getParameter("class").startsWith("Eco")) {
			flightClass = "economy";
		} else if (request.getParameter("class").startsWith("Bus")) {
			flightClass = "business";
		} else {
			flightClass = "first";
		}
		PreparedStatement st2 = con.prepareStatement(String.format("SELECT %s_class_total - %s_class FROM Seat WHERE flight_num = ? AND airline_id = ?", flightClass, flightClass));
		st2.setString(1,rReserveFlightNumber);
		st2.setString(2,rReserveAirline);
		ResultSet temp = st2.executeQuery();
		temp.next();
		String result = temp.getString(1);
		int seatsAvailable = Integer.parseInt(result);
		
		if (seatsAvailable > 0) {
			PreparedStatement st3 = con.prepareStatement(String.format("UPDATE Seat SET %s_class = %s_class + 1 WHERE flight_num = ? AND airline_id = ?", flightClass, flightClass));
			st3.setString(1,rReserveFlightNumber);
			st3.setString(2,rReserveAirline);
			st3.executeUpdate();
			
			PreparedStatement st = con.prepareStatement("INSERT IGNORE INTO Reserves " +
						"VALUES (?,?,?);");
			st.setString(1,username);
			st.setString(2,rReserveFlightNumber);
			st.setString(3,rReserveAirline);
			st.executeUpdate();
			
			st = con.prepareStatement(String.format("INSERT INTO Ticket " +
					"VALUES (1 + %s,(SELECT price FROM Flight WHERE " +
					"airline_id = ? AND flight_num = ?) + ?,?,?,?,?,(SELECT %s_class FROM Seat WHERE flight_num = ? AND airline_id = ?),?);", ticketNum, flightClass));
			ticketNum = String.valueOf(Integer.parseInt(ticketNum) + 1);
			st.setString(1,rReserveAirline);
			st.setString(2,rReserveFlightNumber);
			st.setString(9,rReserveAirline);
			st.setString(8,rReserveFlightNumber);
			LocalDateTime now = LocalDateTime.now();
			DateTimeFormatter dtf= DateTimeFormatter.ofPattern("yyyy-MM-dd hh-mm-ss");
			st.setString(4,dtf.format(now));
			if (request.getParameter("class").startsWith("Eco")) {
				st.setString(3,"0");
				st.setString(5,"economy");
			} else if (request.getParameter("class").startsWith("Bus")) {
				st.setString(3,"150");
				st.setString(5,"business");
			} else {
				st.setString(3,"300");
				st.setString(5,"first");
			}
			st.setString(6,"40");
			st.setString(7,username);
			st.setString(10,(String)session.getAttribute("toDate"));
			st.executeUpdate();
			
			st = con.prepareStatement(String.format("INSERT INTO AssociatedWith VALUES (%s,?,?,?,?)", ticketNum));
			st.setString(1,rReserveFlightNumber);
			st.setString(2,rReserveAirline);
			st.setString(3,(String)session.getAttribute("toDate"));
			st.setString(4,request.getParameter("meal").toLowerCase());
			st.executeUpdate();
		} else {
			//waiting list
			PreparedStatement st = con.prepareStatement("INSERT INTO OnWaitingList VALUES (?,?,?)");
			st.setString(1,username);
			st.setString(2,rReserveFlightNumber);
			st.setString(3,rReserveAirline);
			onWait = true;
		}
	}
	
	if(reserveFor.equals("other")) {
		session.setAttribute("lookingAtUser", username);	
	}
	session.setAttribute("wait", onWait);
	response.sendRedirect("reservations.jsp");
%>