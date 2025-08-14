package com.mottu.patio;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@EnableCaching
@SpringBootApplication
public class PatioApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(PatioApiApplication.class, args);
	}

}
