<%@ page import ="java.sql.*" %>
<%
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	
	String url = "jdbc:mysql://trs2019.cusoi1lz87e1.us-east-2.rds.amazonaws.com/TravelReservationSystem";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "admin", "prinfo$9.99");
	PreparedStatement st = con.prepareStatement("SELECT * " +
					   							"FROM Account " +
												"WHERE username=? AND acc_password=?");

	st.setString(1, username);
	st.setString(2, password);
	ResultSet rs = st.executeQuery();

	if (rs.next()) {
		st = con.prepareStatement("SELECT * FROM CustomerRep WHERE username = ?");
		st.setString(1, username);
		rs = st.executeQuery();
		
		if(rs.next()) {
			session.setAttribute("rep", true);
		} else {
			st = con.prepareStatement("SELECT * FROM Admin WHERE username = ?");
			st.setString(1, username);
			rs = st.executeQuery();
			
			if(rs.next()) {
				session.setAttribute("admin", true);
			}
		}
		
		session.setAttribute("user", username);
        response.sendRedirect("success.jsp");
    } else {
		session.setAttribute("invalid", true);
		response.sendRedirect("login.jsp");
    }
%>