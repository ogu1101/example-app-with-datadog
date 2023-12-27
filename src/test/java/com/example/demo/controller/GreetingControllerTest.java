package com.example.demo.controller;

import com.example.demo.Application;
import com.example.demo.entity.GreetingEntity;
import com.example.demo.util.CsvDataSetLoader;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.springtestdbunit.DbUnitTestExecutionListener;
import com.github.springtestdbunit.annotation.DbUnitConfiguration;
import com.github.springtestdbunit.annotation.ExpectedDatabase;
import com.github.springtestdbunit.assertion.DatabaseAssertionMode;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.support.DependencyInjectionTestExecutionListener;
import org.springframework.test.context.transaction.TransactionalTestExecutionListener;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@DbUnitConfiguration(dataSetLoader = CsvDataSetLoader.class)
@TestExecutionListeners({
        DependencyInjectionTestExecutionListener.class,
        TransactionalTestExecutionListener.class,
        DbUnitTestExecutionListener.class
})
@RunWith(SpringRunner.class)
@AutoConfigureMockMvc
@SpringBootTest(classes = Application.class)
@DisplayName("GreetingControllerのテスト")
public class GreetingControllerTest {
    private final ObjectMapper objectMapper = new ObjectMapper();
    @Autowired
    MockMvc mockMvc;

    @Test
    @DisplayName("正常系テスト")
    @Sql(statements = "TRUNCATE TABLE greetings")
    @ExpectedDatabase(
            value = "/controller/",
            table = "greetings",
            assertionMode = DatabaseAssertionMode.NON_STRICT)
    public void testCreateGreeting() throws Exception {
        GreetingEntity greeting = new GreetingEntity();
        greeting.setMessage("Hello");
        greeting.setTarget("Kagetaka");
        String requestBody = objectMapper.writeValueAsString(greeting);
        greeting.setId(1L);
        String expected = objectMapper.writeValueAsString(greeting);

        this.mockMvc.perform(post("/greeting")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(header().string(
                        "Content-Type",
                        is(MediaType.APPLICATION_JSON_VALUE)))
                .andExpect(content().json(expected));
    }
}
