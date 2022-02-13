### Alex Turner ELK Stack Deployment Project Feb. 2022

# ELK-Stack-Project

The files in this repository were used to configure the network depicted below.

![RED TEAM Diagram the Network](https://user-images.githubusercontent.com/91304356/153047982-3a9cad88-f94c-440f-b445-7d9b1934ddf8.PNG)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the yml and config file may be used to install only certain pieces of it, such as Filebeat.

* [My First Playbook](https://github.com/alexandertroy92/ELK-Stack-Project/blob/87b257aac785464e2fcbdfc7b6dae12620f845b6/My%20First%20Playbook "My First Playbook")
* [Hosts](https://github.com/alexandertroy92/ELK-Stack-Project/blob/ee04126ab7b6b4443b64fe6eecf4fd3fe5997e29/Hosts "Hosts")
* [Ansible Configuration](https://github.com/alexandertroy92/ELK-Stack-Project/blob/95bb272d229207fe3798f99e58ae6ac6fc5546f1/Ansible%20Configuration "Ansible Configuration")
* [Configure ELK VM with Docker](https://github.com/alexandertroy92/ELK-Stack-Project/blob/dca064cee709d0ea19a4655349dafdf946e12d8d/Configure%20ELK%20VM%20with%20Docker "Configure ELK VM with Docker")
* [Filebeat-Configuration](https://github.com/alexandertroy92/ELK-Stack-Project/blob/64faa66def1395aaf37bb1e5a339bfc0cc39775d/Filebeat-Configuration "Filebeat-Configuration")
* [Filebeat Playbook](https://github.com/alexandertroy92/ELK-Stack-Project/blob/96df76fcf470659eae49d1b3eae5721abc5ac4bd/Filebeat%20Playbook "Filebeat Playbook")
* [Metricbeat Configuration](https://github.com/alexandertroy92/ELK-Stack-Project/blob/4043a9a95b8ca30e27743b37d3c8d7407775063a/Metricbeat%20Configuration "Metricbeat Configuration")
* [Metricbeat Playbook](https://github.com/alexandertroy92/ELK-Stack-Project/blob/fef10bf4109bb425dc1912af6fefe832708b6658/Metricbeat%20Playbook "Metricbeat Playbook")

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build

-------------------------------------------------------------------------------------------------------------------------------------------

### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application
Load balancing ensures that the application will be highly functional and available, in addition to restricting any traffic to the network.

- What aspect of security do load balancers protect? Load balancers effectively distribute incoming traffic from one server to another.

- What is the advantage of a jump box? Jump Box Provisioner keeps VM from being publicly exposed and also sets rules which IP addresses can communicate with Jump Box Provisioner. 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the  network and system logs.
-  What does Filebeat watch for? Monitor log files or any other specification and send information to Elasticsearch or Logstash.

- What does Metricbeat record? Metricbeat takes the metrics that is collected and is sent over to Elasticsearch or Logstash

The configuration details of each machine may be found below

| Name       | Function | IP Address | OS    |
|------------|----------|------------|-------|
| Jump Box   | Gateway  | 10.0.0.4   | Linux |
| Web1       | Ubuntu   | 10.0.0.5   | Linux |
| Web2       | Ubuntu   | 10.0.0.6   | Linux |
| ELK server | Ubuntu   | 10.1.0.4   | Linux |

-------------------------------------------------------------------------------------------------------------------------------------------

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump-Box-Provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- Only public IP address through TCP 5601

Machines within the network can only be accessed by Workstation and Jump-Box-Provisioner via SSH port 22 Jump-Box.

- Which machine did you allow to access your ELK VM? Jump-Box-Provisioner IP

- What was its IP address? Workstation public IP address via port TCP 5601

A summary of the access policies in place can be found in the table below.


| Name       | Publicly Accessible | Allowed IP Addresses |
|------------|---------------------|----------------------|
| Jump-Box   | Yes                 | Workstation IP       |
| Web1       | No                  | 10.1.0.4             |
| Web2       | No                  | 10.1.0.4             |
| Elk Server | No                  | Workstation IP       |

-------------------------------------------------------------------------------------------------------------------------------------------

### ELK Configuration
Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...

- What is the main advantage of automating configuration with Ansible?
  - Many advantages of automating configurations, Ansible gives you the power to deploy many applications through YAML playbooks
  - Ansible lets you decide which hosts and allows you control each hosts via SSH
  - The best advanatge of all this is saving time

The playbook implements the following tasks:

- In 3-5 bullets, explain the steps of the ELK installation play. E.g., install Docker; download image; etc.
  - Specify a different group of machines:
      ```yaml
        - name: Configure ELK VM with Docker
          hosts: elk
          become: true
          tasks:
      ```
  - Install Docker.io
      ```yaml
        - name: Install docker.io
          apt:
            update_cache: yes
            force_apt_get: yes
            name: docker.io
            state: present
      ``` 
  - Install Python-pip
      ```yaml
        - name: Install python3-pip
          apt:
            force_apt_get: yes
            name: python3-pip
            state: present

          # Use pip module (It will default to pip3)
        - name: Install Docker module
          pip:
            name: docker
            state: present
            `docker`, which is the Docker Python pip module.
      ``` 
  - Increase Virtual Memory
      ```yaml
       - name: Use more memory
         sysctl:
           name: vm.max_map_count
           value: '262144'
           state: present
           reload: yes
      ```
  - Download and Launch ELK Docker Container (image sebp/elk)
      ```yaml
       - name: Download and launch a docker elk container
         docker_container:
           name: elk
           image: sebp/elk:761
           state: started
           restart_policy: always
      ```
  - Published ports 5044, 5601 and 9200 were made available
      ```yaml
           published_ports:
             -  5601:5601
             -  9200:9200
             -  5044:5044   
      ```
      
The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance

ELK Server
----------
![ELK Server](https://user-images.githubusercontent.com/91304356/153078463-6b98240d-e7ec-4f7e-b4eb-f818aa966dd1.PNG)
Jump-Box-Provisioner
--------------------
![Jump-Box-Provisioner](https://user-images.githubusercontent.com/91304356/153079295-14fa352e-72a4-4d36-b55e-18635845422b.PNG)
Web1
----
![Web1](https://user-images.githubusercontent.com/91304356/153079355-98fd9739-5aa5-4f8a-a365-c3a90c57bcdd.PNG)
Web2
----
![Web2](https://user-images.githubusercontent.com/91304356/153079395-949932fe-f96c-435f-a4db-d5b21e338bb6.PNG)

-------------------------------------------------------------------------------------------------------------------------------------------

### Target Machines & Beats
This ELK server is configured to monitor the following machines:

- List The IP addresses of the machines you are monitoring
  - Web1: 10.0.0.5
  - Web2: 10.0.0.6

We have installed the following Beats on these machines:

- Filebeat 
  - ![image](https://user-images.githubusercontent.com/91304356/153080700-b64ed037-3391-4c61-947e-d5fa65b48411.png)

- Metricbeat
  - ![Metricbeat Module Satus Screenshot](https://user-images.githubusercontent.com/91304356/153081104-123fe216-5501-4df8-980c-8e3f3e3e4bde.PNG)

These Beats allow us to collect the following information from each machine:

 - Fielbeat is used to collect and monitor log files from servers, databases, etc and forwards them to Elasticsearch or Logstash for indexing
 
 - Metricbeat will be used to monitor and analyze VM stats, system CPU, memory and load.

----------------------------------------------------------------------------------------------------------------------------------------------------

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the YML file to ansible folder
- Update the config file to include user and ports
- Run the playbook, and navigate to Kibana to check that the installation worked as expected.

--------------------------------------------------------------------------------------------------------------------------------------------------------

 - Which file is the playbook? `Filebeat Configuration` 
 
 - Where do you copy it? `/etc/ansible`
 
 - Which file do you update to make Ansible run the playbook on a specific machine? `filebeat-config.yml`
 
 - How do I specify which machine to install the ELK server on versus which to install Filebeat on? `/etc/ansible/hosts` One group will be webservers that have each VMs IP and will install filebeat. Other group will be Elk Server with its IP thatg will have ELK installed onto it.
 
 - Which URL do you navigate to in order to check that the ELK server is running? `http://[your.ELK-VM.External.IP]:5601/app/kibana`
