package com.example.demo.repository;

import com.example.demo.entity.GreetingEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GreetingRepository extends JpaRepository<GreetingEntity, Long> {
}