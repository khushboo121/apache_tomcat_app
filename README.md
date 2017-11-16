apache_tomcat_app Cookbook
==========================
This Cookbook Configure Apache web server for load balancing two Tomcat server.

recipe::load_balancer_setup
- install apache2 on ubuntu
- install tomcat7, libapache2-mod-jk, openjdk-7-jdk, mysql-server-5.6
- configure load balancing
- restart service apache2, tomcat 

recipe::start_service
- start apache2, tomcat7, mysql service

Usage
-----
Just include `apache_tomcat_app` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[apache_tomcat_app::load_balancer_setup] recipe[apache_tomcat_app::start_service]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Khushboo Kumari
