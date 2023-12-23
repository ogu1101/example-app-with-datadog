package com.example.demo.controller;

import com.example.demo.entity.GreetingEntity;
import com.example.demo.repository.GreetingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/greeting")
public class GreetingController {
    private static final Logger LOGGER = LoggerFactory.getLogger(GreetingController.class);
    private final GreetingRepository greetingRepository;

    @Autowired
    public GreetingController(GreetingRepository greetingRepository) {
        this.greetingRepository = greetingRepository;
    }

    @PostMapping
    public ResponseEntity<GreetingEntity> createGreeting(@RequestBody GreetingEntity request) {
        LOGGER.info("Method 'createGreeting' started with parameters: {}", request);
        GreetingEntity savedEntity = greetingRepository.save(request);
        LOGGER.info("Method 'createGreeting' completed. Result: {}", savedEntity);
        return ResponseEntity.ok(savedEntity);
    }
}