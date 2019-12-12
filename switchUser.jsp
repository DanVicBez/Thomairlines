<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import ="java.sql.*" %>
<%
	session.setAttribute("lookingAtUser", "null");
	session.setAttribute("lookingAtFlightNum", "null");
	session.setAttribute("lookingAtFlightAirline", "null");

	if((Boolean) session.getAttribute("rep") || ((Boolean) session.getAttribute("admin") && request.getParameter("user") != null)) {
		session.setAttribute("lookingAtUser", request.getParameter("user"));
	} else {
		session.setAttribute("lookingAtFlightNum", request.getParameter("flightnum"));
		session.setAttribute("lookingAtFlightAirline", request.getParameter("airline"));
	}

	response.sendRedirect("reservations.jsp");
%>