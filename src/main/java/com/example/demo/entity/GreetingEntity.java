package com.example.demo.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

@Entity
@Table(name = "greetings")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GreetingEntity {

    private static final int MESSAGE_MAX_LENGTH = 255;
    private static final int TARGET_MAX_LENGTH = 255;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "message", nullable = false)
    @NotBlank
    @Length(max = MESSAGE_MAX_LENGTH)
    private String message;

    @Column(name = "target")
    @Length(max = TARGET_MAX_LENGTH)
    private String target;
}
