package com.example.demo.config;

import com.example.demo.controller.HelloWorldController;
import org.glassfish.jersey.server.ResourceConfig;
import org.springframework.stereotype.Component;

@Component
public class MyJerseyConfig extends ResourceConfig {

    public MyJerseyConfig() {
        register(HelloWorldController.class);
    }
}
