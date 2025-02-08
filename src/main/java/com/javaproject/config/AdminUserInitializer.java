package com.javaproject.config;

import org.springframework.stereotype.Component;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.ApplicationArguments;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Arrays;
import java.util.List;

@Component
public class AdminUserInitializer implements ApplicationRunner {
    
    @Autowired
    private JdbcUserDetailsManager userDetailsManager;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Value("${ADMIN_USERNAME}")
    private String adminUsername;
    
    @Value("${ADMIN_PASSWORD}")
    private String adminPassword;
    
    @Override
    public void run(ApplicationArguments args) {
        if (!userDetailsManager.userExists(adminUsername)) {
            List<GrantedAuthority> authorities = Arrays.asList(
                new SimpleGrantedAuthority("ROLE_USER"),
                new SimpleGrantedAuthority("ROLE_MANAGER")
            );
            
            User user = new User(adminUsername, 
                               passwordEncoder.encode(adminPassword), 
                               authorities);
                               
            userDetailsManager.createUser(user);
        }
    }
}