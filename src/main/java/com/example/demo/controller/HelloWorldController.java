package com.example.demo.controller;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
@Path("/")
public class HelloWorldController {
    private static final Logger logger = LoggerFactory.getLogger(HelloWorldController.class);
    private final Client jerseyClient;

    @Autowired
    public HelloWorldController(Client jerseyClient) {
        this.jerseyClient = jerseyClient;
    }

    @GET
    @Path("/hello")
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, String> sayHello() {
        Map<String, String> response = new HashMap<>();
        response.put("greeting", "hello");
        logger.info(response.toString());
        return response;
    }

    @GET
    @Path("/external-data")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getExternalData() {
        WebTarget target;
        target = jerseyClient.target("http://app2:8080/hello");
        Response response = target.request().get();
        logger.info(response.toString());
        return Response.status(response.getStatus())
                .entity(response.readEntity(String.class))
                .build();
    }
}