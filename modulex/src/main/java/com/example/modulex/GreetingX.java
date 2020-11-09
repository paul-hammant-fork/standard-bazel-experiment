package com.example.modulex;

public class GreetingX {
    public static void sayHi() {
            System.out.println("Hi from module X!");
            // This line works for a Maven build but not for a Bazel one presently
            com.example.modulea.GreetingA.sayHi();
    }
}

