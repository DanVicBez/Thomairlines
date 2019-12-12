<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %> 
<%
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem?useUnicode=yes&characterEncoding=UTF-8";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	
	String flightNum = request.getParameter("flightNum");
	String airlineid = request.getParameter("airlineid2");
	String choice = request.getParameter("choice");
	String newFlightNum = request.getParameter("new-flightnum");
	String newAirlineId = request.getParameter("new-airlineid2");
	boolean mon = "on".equals(request.getParameter("new-mon"));
	boolean tue = "on".equals(request.getParameter("new-tue"));
	boolean thu = "on".equals(request.getParameter("new-thu"));
	boolean fri = "on".equals(request.getParameter("new-fri"));
	boolean wed = "on".equals(request.getParameter("new-wed"));
	boolean sun = "on".equals(request.getParameter("new-sun"));
	boolean sat = "on".equals(request.getParameter("new-sat"));
	String newDays = ((sun) ? "SUN" : "") + ((mon) ? "MON" : "") + ((tue) ? "TUE" : "") + ((wed) ? "WED" : "") + ((thu) ? "THU" : "") + ((fri) ? "FRI" : "") + ((sat) ? "SAT" : "");
	String newDTime = request.getParameter("new-dtime");
	String newATime = request.getParameter("new-atime");
	String newDAirportId = request.getParameter("new-dairportid");
	String newAAirportId = request.getParameter("new-aairportid");
	String newDesignation = request.getParameter("new-designation2");
	String newPrice = request.getParameter("new-price");
	String newStops = request.getParameter("new-stops");
	
	PreparedStatement ps;
	ResultSet rs;
	
	if(choice.equals("create")){
		ps = con.prepareStatement("SELECT * FROM Aircraft WHERE designation = ? && airline_id = ?;");
		ps.setString(1, newDesignation);
		ps.setString(2, newAirlineId);
		rs = ps.executeQuery();
		if(newDays.equals("")){
			session.setAttribute("flight-response", "Error: Please make a selection for days");
		}else if(!rs.next()){
			session.setAttribute("flight-response", "Error: This model does not exist for selected airline");
		}else if(newDAirportId.equals(newAAirportId)){
			session.setAttribute("flight-response", "Error: Departing Airport and Arriving Airport Cannot be the Same");
		}else{
			ps = con.prepareStatement("SELECT * FROM Flight WHERE flight_num = ? && airline_id = ?");
			ps.setInt(1,Integer.valueOf(newFlightNum));
			ps.setString(2, newAirlineId);
			rs = ps.executeQuery();
			if(rs.next()) {
				session.setAttribute("flight-response", "Error creating flight: already exists");
			} else {
				ps = con.prepareStatement("INSERT INTO Flight VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				ps.setInt(1,Integer.valueOf(newFlightNum));
				ps.setString(2, newAirlineId);
				ps.setString(3, newDays);
				ps.setString(4, newDTime);
				ps.setString(5, newATime);
				ps.setString(6, newDAirportId);
				ps.setString(7, newAAirportId);
				ps.setString(8, newDesignation);
				ps.setDouble(9, Double.valueOf(newPrice));
				ps.setInt(10, Integer.valueOf(newStops));
			
				System.out.printf("Updated %d rows\n", ps.executeUpdate());
			
				session.setAttribute("flight-response", "Flight successfully created");
			}
		}
	}else if(choice.equals("delete")){
		
		ps = con.prepareStatement("SELECT * FROM Flight WHERE flight_num = ? && airline_id = ?");
		ps.setInt(1,Integer.valueOf(flightNum));
		ps.setString(2, airlineid);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			ps = con.prepareStatement("SELECT ticket_num FROM Ticket WHERE ticket_num = (SELECT DISTINCT ticket_num from AssociatedWith WHERE flight_num = ? && airline_id = ?)");
			ps.setInt(1, Integer.valueOf(flightNum));
			ps.setString(2, airlineid);
			ResultSet val = ps.executeQuery();
			ps = con.prepareStatement("DELETE FROM Flight WHERE flight_num = ? && airline_id = ?");
			ps.setInt(1, Integer.valueOf(flightNum));
			ps.setString(2, airlineid);
			ps.executeUpdate();
			while(val.next()) {
				PreparedStatement ps6 = con.prepareStatement("DELETE FROM Ticket WHERE ticket_num = ?");
				ps6.setString(1, val.getString(1));
				ps6.executeUpdate();
			}
			
			session.setAttribute("flight-response", "Flight successfully deleted");
		} else {
			session.setAttribute("flight-response", "Error deleting flight: doesn't exist");
		}
	}else if(choice.equals("edit")){
		ps = con.prepareStatement("SELECT * FROM Flight WHERE flight_num = ? && airline_id = ?");
		ps.setInt(1,Integer.valueOf(flightNum));
		ps.setString(2, airlineid);
		rs = ps.executeQuery();
		
		if(rs.next()){
			if(newDAirportId == null && newAAirportId != null){
				PreparedStatement pfig = con.prepareStatement("SELECT d_airport_id FROM Flight WHERE flight_num = ? && airline_id = ?;");
				pfig.setInt(1, Integer.valueOf(flightNum));
				pfig.setString(2, airlineid);
				ResultSet rfig = pfig.executeQuery();
				rfig.next();
				if(rfig.getString("d_airport_id").equals(newAAirportId)){
					session.setAttribute("flight-response", "Error: Departing Airport and Arriving Airport Cannot be the Same");
					response.sendRedirect("representative.jsp");
					return;
				}
			}else if(newDAirportId != null && newAAirportId == null){
				PreparedStatement pfig = con.prepareStatement("SELECT a_airport_id FROM Flight WHERE flight_num = ? && airline_id = ?;");
				pfig.setInt(1, Integer.valueOf(flightNum));
				pfig.setString(2, airlineid);
				ResultSet rfig = pfig.executeQuery();
				rfig.next();
				if(newDAirportId.equals(rfig.getString("a_airport_id"))){
					session.setAttribute("flight-response", "Error: Departing Airport and Arriving Airport Cannot be the Same");
					response.sendRedirect("representative.jsp");
					return;
				}
			}else if(newDAirportId != null && newAAirportId != null){
				if(newDAirportId.equals(newAAirportId)){
					session.setAttribute("flight-response", "Error: Departing Airport and Arriving Airport Cannot be the Same");
					response.sendRedirect("representative.jsp");
					return;
				}
			}
			PreparedStatement ps2 = con.prepareStatement("UPDATE Flight SET flight_num = ?, airline_id = ?, days = ?, departure_time = ?, arrival_time = ?, d_airport_id = ?, a_airport_id = ?, designation = ?, price = ?, stops = ? WHERE flight_num = ? && airline_id = ?");
			if(newFlightNum.equals("")){
				ps2.setInt(1, rs.getInt("flight_num"));
			}else{
				ps2.setInt(1, Integer.valueOf(newFlightNum));
			}
			if(newAirlineId == null || newAirlineId.equals("")){
				ps2.setString(2, rs.getString("airline_id"));
			}else{
				ps2.setString(2, newAirlineId);
			}
			PreparedStatement check = con.prepareStatement("SELECT * FROM Flight WHERE flight_num = ? && airline_id = ?;");
			ResultSet check2;
			if(newAirlineId != null && !newFlightNum.equals("")){
				check.setInt(1, Integer.valueOf(newFlightNum));
				check.setString(2, newAirlineId);
				check2 = check.executeQuery();
				if(check2.next()){
					session.setAttribute("flight-response", "Error: Duplicate Flight");
					response.sendRedirect("representative.jsp");
					return;
				}
			}else if(newAirlineId != null && newFlightNum.equals("")){
				check.setInt(1, Integer.valueOf(flightNum));
				check.setString(2, newAirlineId);
				check2 = check.executeQuery();
				if(check2.next()){
					session.setAttribute("flight-response", "Error: Duplicate Flight");
					response.sendRedirect("representative.jsp");
					return;
				}
			}else if(newAirlineId == null && !newFlightNum.equals("")){
				check.setInt(1, Integer.valueOf(newFlightNum));
				check.setString(2, airlineid);
				check2 = check.executeQuery();
				if(check2.next()){
					session.setAttribute("flight-response", "Error: Duplicate Flight");
					response.sendRedirect("representative.jsp");
					return;
				}
			}
			if(newDays.equals("")){
				ps2.setString(3, rs.getString("days"));
			}else{
				ps2.setString(3, newDays);
			}
			if(newDTime.equals("")){
				ps2.setString(4, rs.getString("departure_time"));
			}else{
				ps2.setString(4, newDTime);
			}
			if(newATime.equals("")){
				ps2.setString(5, rs.getString("arrival_time"));
			}else{
				ps2.setString(5, newATime);
			}
			if(newDAirportId == null || newDAirportId.equals("")){
				ps2.setString(6, rs.getString("d_airport_id"));
			}else{
				ps2.setString(6, newDAirportId);
			}
			if(newAAirportId == null || newAAirportId.equals("")){
				ps2.setString(7, rs.getString("a_airport_id"));
			}else{
				ps2.setString(7, newAAirportId);
			}
			if(newDesignation == null || newDesignation.equals("")){
				ps2.setString(8, rs.getString("designation"));
			}else if(newAirlineId == null || newAirlineId.equals("")){
				PreparedStatement ps3 = con.prepareStatement("SELECT * FROM Aircraft WHERE designation = ? && airline_id = ?;");
				ps3.setString(1, newDesignation);
				ps3.setString(2, airlineid);
				ResultSet rs3 = ps3.executeQuery();
				if(!rs3.next()){
					session.setAttribute("flight-response", "Error: This model does not exist for selected airline");
				}else{
					ps2.setString(8, newDesignation);
				}
			}else{
				PreparedStatement ps3 = con.prepareStatement("SELECT * FROM Aircraft WHERE designation = ? && airline_id = ?;");
				ps3.setString(1, newDesignation);
				ps3.setString(2, newAirlineId);
				ResultSet rs3 = ps3.executeQuery();
				if(!rs3.next()){
					session.setAttribute("flight-response", "Error: This model does not exist for selected airline");
				}else{
					ps2.setString(8, newDesignation);
				}
			}
			if(newPrice.equals("")){
				ps2.setDouble(9, rs.getDouble("price"));
			}else{
				ps2.setDouble(9, Double.valueOf(newPrice));
			}
			if(newStops == null || newStops.equals("")){
				ps2.setInt(10, rs.getInt("stops"));
			}else{
				ps2.setInt(10, Integer.valueOf(newStops));
			}
			ps2.setInt(11, Integer.valueOf(flightNum));
			ps2.setString(12, airlineid);
			System.out.printf("Updated %d rows\n", ps2.executeUpdate());
			
			session.setAttribute("flight-response", "Flight successfully edited");
		}else{
			session.setAttribute("flight-response", "Error deleting flight: doesn't exist");
		}
	}
	response.sendRedirect("representative.jsp");
%>