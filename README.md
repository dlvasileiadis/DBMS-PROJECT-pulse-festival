# Pulse University Festival Database

Welcome to the Pulse University Festival Database! This project models and manages all data involved in the organization of Pulse, a multi-day, annual international music festival held at different global locations every year. It covers every aspect of the event, from planning artist shows, to selling tickets, collecting visitor feedback, and organizing staff.

## Directory Features

-  **Diagrams:** Contains the visual design of the database (ER Diagramm and Relational Schema).
- **sql:** Includes all SQL scripts for setting up and querying the database.  
  1. install.sql: Creates all tables, constraints, triggers and indexes for the schema.  
  2. load.sql: Populates the database with sample data for testing and evaluation.  
  3. Q01.sql to`Q15.sql: SQL queries for each required question.  
  4. Q01_out.txt to Q15_out.txt: Result output files for each query as returned by the DBMS.
- **code**: Contains supporting code and scripts related to data generation, application functionality, and advanced database logic.
  1. pulse-festival_app: Code for the application layer.  
  2. python_dummy_data: Python scripts for generating data to populate the database with realistic festival entries.  
  3. resale_queue_implementation.sql: SQL script implementing the ticket resale mechanism using FIFO queues for buyers and sellers.
 - **docs:** Contains our final project report

## Database Features

- **Festival & Venue Info**: Stores each year’s festival, where it happened, and details about the venues including size, equipment, and images.

- **Artists & Performances**: Keeps track of solo artists and bands, their music styles, when and where they performed, and checks that they don’t appear at two places at once or too many years in a row.

- **Tickets & Resale**: Manages different types of tickets, how they’re paid for, whether they have been used, and supports ticket resale using a first-come, first-served queue.

- **Staff Planning**: Assigns technical, security, and support staff to each event. Makes sure the number and type of staff meet the needs based on how many people the venue can hold.

- **Visitor Ratings**: Lets visitors with valid tickets rate shows based on five things (Artist performance, Sound and lighting, Stage presence, Organization, Overall impression) using a simple 3-point scale.

- **Images with Descriptions**: Adds images and short descriptions to important things like venues, artists, and equipment, useful for websites or apps.

## Contributors

- Nikolaos Apostolopoulos
- Dimitrios Vasileiadis




