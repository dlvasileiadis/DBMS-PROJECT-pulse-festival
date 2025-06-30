CREATE DATABASE IF NOT EXISTS pulse_festival;

USE pulse_festival;

CREATE TABLE IF NOT EXISTS location(
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    coordinates_lang DECIMAL(9, 6) NOT NULL,
    coordinates_long DECIMAL(9, 6) NOT NULL,
    adress VARCHAR(80) NOT NULL,
    city VARCHAR(40) NOT NULL,
    country VARCHAR(40) NOT NULL,
    continent VARCHAR(30) NOT NULL,
    UNIQUE (coordinates_lang, coordinates_long)
);

CREATE TABLE IF NOT EXISTS festival (
    festival_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    location_id INT NOT NULL UNIQUE,
    CONSTRAINT fk_festival_location FOREIGN KEY (location_id) REFERENCES location(location_id),
    CHECK (start_date <= end_date)
);

CREATE TABLE IF NOT EXISTS venue (
    /*"Κάθε σκηνή μπορεί να φιλοξενεί μόνο μία παράσταση την ίδια στιγμή." trigger*/
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    festival_id INT NOT NULL,
    name VARCHAR(80) NOT NULL,
    description TEXT,
    max_capacity INT NOT NULL CHECK (max_capacity > 0),
    CONSTRAINT fk_venue_festival FOREIGN KEY (festival_id) REFERENCES festival(festival_id)
);

CREATE TABLE IF NOT EXISTS event (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    venue_id INT NOT NULL,
    festival_id INT NOT NULL,
    CONSTRAINT fk_event_venue FOREIGN KEY (venue_id) REFERENCES venue(venue_id) ON UPDATE CASCADE,
    CONSTRAINT fk_event_festival FOREIGN KEY (festival_id) REFERENCES festival(festival_id) ON UPDATE CASCADE,
    CHECK (start_time < end_time)
);

CREATE TABLE IF NOT EXISTS equipment (
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS venue_requires_equipment (
    venue_id INT NOT NULL,
    equipment_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (venue_id, equipment_id),
    CONSTRAINT fk_venequip_venue FOREIGN KEY (venue_id) REFERENCES venue(venue_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_venequip_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

/*Το προσωπικό ασφαλείας πρέπει να καλύπτει τουλάχιστον το 5% του 
 Sυνολικού αριθμού θεατών σε κάθε σκηνή και το βοηθητικό προσωπικό το 2%. */
CREATE TABLE IF NOT EXISTS staff_role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS experience_level (
    level_id INT PRIMARY KEY AUTO_INCREMENT,
    level_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL CHECK (age >= 18),
    role_id INT NOT NULL,
    level_id INT NOT NULL,
    CONSTRAINT fk_staff_role FOREIGN KEY (role_id) REFERENCES staff_role(role_id),
    CONSTRAINT fk_staff_level FOREIGN KEY (level_id) REFERENCES experience_level(level_id)
);

CREATE TABLE IF NOT EXISTS venue_staff_assignment (
    venue_id INT NOT NULL,
    staff_id INT NOT NULL,
    PRIMARY KEY (venue_id, staff_id),
    CONSTRAINT fk_esa_venue FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
    CONSTRAINT fk_esa_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE IF NOT EXISTS performance_type(
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS genre (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS subgenre (
    subgenre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    genre_id INT NOT NULL,
    CONSTRAINT fk_subgenre_genre FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);

/*Ένας καλλιτέχνης μπορεί να ανήκει σε 
 περισσότερα από ένα συγκροτήματα. Ένας καλλιτέχνης (συγκρότημα) δεν μπορεί να εμφανίζεται σε δύο σκηνές 
 ταυτόχρονα και δεν επιτρέπεται συμμετοχή του ίδιου καλλιτέχνη (συγκροτήματος) για περισσότερα από 3 συνεχή έτη.*/
CREATE TABLE IF NOT EXISTS artist (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nickname VARCHAR(100),
    birth_date DATE NOT NULL,
    subgenre_id INT NOT NULL,
    web_page VARCHAR(100),
    instagram_profile VARCHAR(100),
    CONSTRAINT fk_artist_subgenre FOREIGN KEY (subgenre_id) REFERENCES subgenre(subgenre_id)
);

CREATE TABLE IF NOT EXISTS band (
    band_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    formation_date DATE NOT NULL,
    subgenre_id INT NOT NULL,
    web_page VARCHAR(100),
    instagram_profile VARCHAR(100),
    CONSTRAINT fk_band_subgenre FOREIGN KEY (subgenre_id) REFERENCES subgenre(subgenre_id)
);

CREATE TABLE IF NOT EXISTS performer (
    performer_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_id INT,
    band_id INT,
    CHECK (
        (
            artist_id IS NOT NULL
            AND band_id IS NULL
        )
        OR (
            artist_id IS NULL
            AND band_id IS NOT NULL
        )
    ),
    CONSTRAINT fk_performer_artist FOREIGN KEY (artist_id) REFERENCES artist(artist_id),
    CONSTRAINT fk_performer_band FOREIGN KEY (band_id) REFERENCES band(band_id)
);

CREATE TABLE IF NOT EXISTS performances (
    /*Ανάμεσα σε διαδοχικές εμφανίσεις προβλέπεται υποχρεωτικά διάλειμμα, ελάχιστης διάρκειας 
     -- ελάχιστης διάρκειας 5 λεπτών και μέγιστης 30 λεπτών. */
    performance_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    type_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    venue_id INT NOT NULL,
    performer_id INT NOT NULL,
    CONSTRAINT fk_perf_type FOREIGN KEY (type_id) REFERENCES performance_type(type_id),
    CONSTRAINT fk_perf_venue FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
    CONSTRAINT fk_perf_event FOREIGN KEY (event_id) REFERENCES event(event_id),
    CONSTRAINT fk_perf_performer FOREIGN KEY (performer_id) REFERENCES performer(performer_id),
    CHECK (end_time > start_time)
    /*CHECK (
     TIMESTAMPDIFF(MINUTE, start_time, end_time) <= 180
     ) AYTO DEN MPOREI NA GINEI... TRIGGER*/
);


CREATE TABLE IF NOT EXISTS artist_belongs (
    artist_id INT NOT NULL,
    band_id INT NOT NULL,
    PRIMARY KEY (artist_id, band_id),
    CONSTRAINT fk_ab_artist FOREIGN KEY (artist_id) REFERENCES artist(artist_id),
    CONSTRAINT fk_ab_band FOREIGN KEY (band_id) REFERENCES band(band_id)
);


CREATE TABLE IF NOT EXISTS person (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT NOT NULL CHECK (age >= 0),
    contact_info VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS ticket_category (
    ticket_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS purchase_method (
    purchase_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(30) NOT NULL UNIQUE -- no cash
);

/*Η χωρητικότητα της σκηνής δεν μπορεί να ξεπεραστεί κατά την πώληση εισιτηρίων
 Δεν μπορεί να υπάρχουν περισσότερο από ένα εισιτήρια του ίδιου 
 επισκέπτη για την ίδια ημέρα και παράσταση ΑΥΤΟ ΜΕ ΤΟ UNIQUE ΚΑΤΩ.*/
CREATE TABLE IF NOT EXISTS ticket (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT NOT NULL,
    event_id INT NOT NULL,
    ticket_category_id INT NOT NULL,
    venue_id INT NOT NULL,
    /*για χωρητικοτητα σκηνης*/
    purchase_date DATE NOT NULL,
    purchase_method_id INT NOT NULL,
    price DECIMAL(8, 2) NOT NULL CHECK (price >= 0),
    EAN_13_code CHAR(13) UNIQUE NOT NULL,
    activated BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_ticket_person FOREIGN KEY (person_id) REFERENCES person(person_id),
    CONSTRAINT fk_ticket_event FOREIGN KEY (event_id) REFERENCES event(event_id),
    CONSTRAINT fk_ticket_category FOREIGN KEY (ticket_category_id) REFERENCES ticket_category(ticket_category_id),
    CONSTRAINT fk_ticket_venue FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
    CONSTRAINT fk_ticket__purchase_method FOREIGN KEY (purchase_method_id) REFERENCES purchase_method(purchase_method_id),
    UNIQUE(person_id, event_id)
    /*a person cannot have more than one ticket for the same event.*/
);

/*Τα VIP εισιτήρια περιορίζονται στο 10% της χωρητικότητας κάθε σκηνής.*/


CREATE TABLE IF NOT EXISTS resale_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL UNIQUE
    /*available reserved sold*/
);

CREATE TABLE IF NOT EXISTS resale_offer (
    resale_offer_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    offer_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_id INT NOT NULL,
    CONSTRAINT fk_resale_ticket FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id),
    CONSTRAINT fk_resale_status FOREIGN KEY (status_id) REFERENCES resale_status(status_id) ON UPDATE CASCADE,
    UNIQUE(ticket_id)
);


CREATE TABLE IF NOT EXISTS ticket_resale_request (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT NOT NULL,
    event_id INT NOT NULL,
    ticket_category_id INT NOT NULL,
    specific_ticket_id INT, /* nullable αγοραστές εκδηλώνουν είτε για ένα συγκεκριμένο εισιτήριο που είναι διαθέσιμο προς πώληση.*/
    request_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fulfilled BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_request_person FOREIGN KEY (person_id) REFERENCES person(person_id),
    CONSTRAINT fk_request_event FOREIGN KEY (event_id) REFERENCES event(event_id),
    CONSTRAINT fk_request_category FOREIGN KEY (ticket_category_id) REFERENCES ticket_category(ticket_category_id),
    CONSTRAINT fk_request_specific_ticket FOREIGN KEY (specific_ticket_id) REFERENCES ticket(ticket_id)
);

/*το fifo με queries*/
CREATE TABLE IF NOT EXISTS resale_transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    resale_offer_id INT NOT NULL,
    request_id INT NOT NULL,
    buyer_id INT NOT NULL,
    transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_offer FOREIGN KEY (resale_offer_id) REFERENCES resale_offer(resale_offer_id),
    CONSTRAINT fk_transaction_request FOREIGN KEY (request_id) REFERENCES ticket_resale_request(request_id),
    CONSTRAINT fk_transaction_buyer FOREIGN KEY (buyer_id) REFERENCES person(person_id)
);

CREATE TABLE IF NOT EXISTS review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL UNIQUE,
    person_id INT NOT NULL,
    performance_id INT NOT NULL,
    artist_rating INT NOT NULL CHECK (
        artist_rating BETWEEN 1
        AND 3
    ),
    sound_light_rating INT NOT NULL CHECK (
        sound_light_rating BETWEEN 1
        AND 3
    ),
    stage_presence INT NOT NULL CHECK (
        stage_presence BETWEEN 1
        AND 3
    ),
    organization_rating INT NOT NULL CHECK (
        organization_rating BETWEEN 1
        AND 3
    ),
    overall_impression INT NOT NULL CHECK (
        overall_impression BETWEEN 1
        AND 3
    ),
    review_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_review_ticket FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id),
    CONSTRAINT fk_review_person FOREIGN KEY (person_id) REFERENCES person(person_id),
    CONSTRAINT fk_review_performance FOREIGN KEY (performance_id) REFERENCES performances(performance_id)
);

CREATE TABLE IF NOT EXISTS festival_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    festival_id INT NOT NULL,
    image_url TEXT NOT NULL,
    description TEXT,
    FOREIGN KEY (festival_id) REFERENCES festival(festival_id),
    CHECK (image_url LIKE 'https%')
);

CREATE TABLE IF NOT EXISTS venue_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_id INT NOT NULL,
    image_url TEXT NOT NULL,
    description TEXT,
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
    CHECK (image_url LIKE 'https%')
);

CREATE TABLE IF NOT EXISTS artist_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_id INT NOT NULL,
    image_url TEXT NOT NULL,
    description TEXT,
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id),
    CHECK (image_url LIKE 'https%')
);

CREATE TABLE IF NOT EXISTS band_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    band_id INT NOT NULL,
    image_url TEXT NOT NULL,
    description TEXT,
    FOREIGN KEY (band_id) REFERENCES Band(band_id),
    CHECK (image_url LIKE 'https%')
);


/*indexes*/



--q1
CREATE INDEX idx_ticket_event_id ON ticket(event_id);

CREATE INDEX idx_event_festival_id ON event(festival_id);

CREATE INDEX idx_ticket_purchase_method_id ON ticket(purchase_method_id);

--q2
CREATE INDEX idx_subgenre_genre_id ON subgenre(genre_id);

CREATE INDEX idx_performer_artist_id ON performer(artist_id);

CREATE INDEX idx_performer_band_id ON performer(band_id);

CREATE INDEX idx_performances_performer_id ON performances(performer_id);

CREATE INDEX idx_artist_belongs_artist_id ON artist_belongs(artist_id);

--q3
CREATE INDEX idx_performance_type_name ON performance_type(type_name);

CREATE INDEX idx_performances_type_id ON performances(type_id);

CREATE INDEX idx_performances_event_id ON performances(event_id);

--q4
CREATE INDEX idx_review_performance_id ON review(performance_id);

CREATE INDEX idx_performer_artist_band ON performer(artist_id);

CREATE INDEX idx_performances_performance_id ON performances(performance_id);

--q5
CREATE INDEX idx_artist_birth_date ON artist(birth_date);

--q6
CREATE INDEX idx_vsa_venue_id ON venue_staff_assignment(venue_id);

CREATE INDEX idx_vsa_staff_id ON venue_staff_assignment(staff_id);

CREATE INDEX idx_staff_role_id ON staff(role_id);

CREATE INDEX idx_staff_level_id ON staff(level_id);

CREATE INDEX idx_staff_role_name ON staff_role(role_name);

--q7
CREATE INDEX idx_festival_start_end ON festival(start_date, end_date);

--q15
CREATE INDEX idx_ticket_activated ON ticket(activated);


--
CREATE INDEX idx_review_person_id ON review(person_id);

CREATE INDEX idx_review_ticket_id ON review(ticket_id);

/*q6*/
CREATE INDEX idx_review_performance_person ON review(performance_id, person_id);
/*q4*/
CREATE INDEX idx_performer_artist_band_null ON performer(artist_id, band_id);



/*triggers*/




USE pulse_festival;

/*Κάθε σκηνή μπορεί να φιλοξενεί όνο μία παράσταση την ίδια στιγμή*/

CREATE TRIGGER IF NOT EXISTS prevent_event_overlap_insert
BEFORE INSERT ON event
FOR EACH ROW
BEGIN
  /* check if another event at the same venue overlaps in date and time*/
  IF EXISTS (
    SELECT 1
    FROM event
    WHERE venue_id = NEW.venue_id
      AND date = NEW.date
      AND NEW.start_time < end_time
      AND NEW.end_time > start_time
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'this venue is already booked at that time.';
  END IF;
END;




CREATE TRIGGER IF NOT EXISTS prevent_event_overlap_update
BEFORE UPDATE ON event
FOR EACH ROW
BEGIN
  /*check if the updated event overlaps with any other event at the same venue and date*/
  IF EXISTS (
    SELECT 1
    FROM event
    WHERE venue_id = NEW.venue_id
      AND date = NEW.date
      AND NEW.start_time < end_time
      AND NEW.end_time > start_time
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'this venue is already booked at that time.';
  END IF;
END;



/* Το προσωπικό ασφαλείας πρέπει να καλύπτει τουλάχιστον το 5% του συνολικού 
αριθμού θεατών σε κάθε σκηνή και το βοηθητικό προσωπικό το 2%. */


CREATE TRIGGER check_security_staff_percentage
AFTER INSERT ON venue_staff_assignment
FOR EACH ROW
BEGIN
  DECLARE venue_capacity INT;
  DECLARE security_count INT;
  DECLARE security_role_id INT;
  DECLARE total_staff_count INT;

  -- Get the role_id for 'security'
  SELECT role_id INTO security_role_id
  FROM staff_role
  WHERE role_name = 'security';

  -- Get max capacity of the venue
  SELECT max_capacity INTO venue_capacity
  FROM venue
  WHERE venue_id = NEW.venue_id;

  -- Count total staff assigned (all roles)
  SELECT COUNT(*) INTO total_staff_count
  FROM venue_staff_assignment
  WHERE venue_id = NEW.venue_id;

  -- Count security staff assigned
  SELECT COUNT(*) INTO security_count
  FROM venue_staff_assignment vsa
  JOIN staff s ON vsa.staff_id = s.staff_id
  WHERE vsa.venue_id = NEW.venue_id
    AND s.role_id = security_role_id;

  -- Only check after 6 total staff inserted
  IF total_staff_count >= 6 THEN
    IF security_count < CEIL(venue_capacity * 0.05) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Security staff must be at least 5% of venue capacity.';
    END IF;
  END IF;
END;





CREATE TRIGGER check_assistant_percentage
AFTER INSERT ON venue_staff_assignment
FOR EACH ROW
BEGIN
  DECLARE venue_capacity INT;
  DECLARE assistant_count INT;
  DECLARE assistant_role_id INT;
  DECLARE total_staff_count INT;

  -- Get the role_id for 'assistant'
  SELECT role_id INTO assistant_role_id
  FROM staff_role
  WHERE role_name = 'assistant';

  -- Get max capacity of the venue
  SELECT max_capacity INTO venue_capacity
  FROM venue
  WHERE venue_id = NEW.venue_id;

  -- Count total staff assigned (all roles)
  SELECT COUNT(*) INTO total_staff_count
  FROM venue_staff_assignment
  WHERE venue_id = NEW.venue_id;

  -- Count assistant staff assigned
  SELECT COUNT(*) INTO assistant_count
  FROM venue_staff_assignment vsa
  JOIN staff s ON vsa.staff_id = s.staff_id
  WHERE vsa.venue_id = NEW.venue_id
    AND s.role_id = assistant_role_id;

  -- Only check after 6 total staff inserted
  IF total_staff_count >= 6 THEN
    IF assistant_count < CEIL(venue_capacity * 0.02) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Assistant staff must be at least 2% of venue capacity.';
    END IF;
  END IF;
END;



/*Οι εμφανίσεις έχουν μέγιστη διάρκεια 3 ώρες.*/



CREATE TRIGGER IF NOT EXISTS trg_check_max_performance_duration
BEFORE UPDATE ON performances
FOR EACH ROW
BEGIN
  IF TIMESTAMPDIFF(MINUTE, NEW.start_time, NEW.end_time) > 180 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Performance duration cannot exceed 3 hours (180 minutes).';
  END IF;
END;





/*Ανάμεσα σε διαδοχικές εμφανίσεις προβλέπεται υποχρεωτικά διάλειμμα, 
 ελάχιστης διάρκειας ελάχιστης διάρκειας 5 λεπτών και μέγιστης 30 λεπτών.*/


CREATE TRIGGER IF NOT EXISTS trg_check_performance_break
BEFORE INSERT ON performances
FOR EACH ROW
BEGIN
  DECLARE last_end DATETIME;
  DECLARE diff_minutes INT;

  /*βρες την τελευταια εμφάνιση στο ίδιο venue πριν την καινουρια*/
  SELECT MAX(end_time)
  INTO last_end
  FROM performances
  WHERE venue_id = NEW.venue_id
    AND event_id = NEW.event_id
    AND end_time <= NEW.start_time;

  /*αν υπάρχει προηγούμενη εμφάνιση έλεγξε το διάλειμμα*/
  IF last_end IS NOT NULL THEN
    SET diff_minutes = TIMESTAMPDIFF(MINUTE, last_end, NEW.start_time);

    IF diff_minutes < 5 OR diff_minutes > 30 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Break between performances must be between 5 and 30 minutes.';
    END IF;
  END IF;
END;



/* Ένας καλλιτέχνης (συγκρότημα) δεν μπορεί να εμφανίζεται σε δύο σκηνές ταυτόχρονα*/


CREATE TRIGGER IF NOT EXISTS check_performer_overlap
BEFORE INSERT ON performances
FOR EACH ROW
BEGIN
  DECLARE overlap_count INT;

  /*count existing performances with overlapping time for the same performer*/
  SELECT COUNT(*) INTO overlap_count
  FROM performances
  WHERE performer_id = NEW.performer_id
    AND (
      NEW.start_time < end_time AND
      NEW.end_time > start_time
    );

  /*f there is any overlap deny the insert*/
  IF overlap_count > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'This performer is already scheduled at the same time.';
  END IF;
END;



/*Η χωρητικότητα της σκηνής δεν μπορεί να
 ξεπεραστεί κατά την πώληση εισιτηρίων*/


CREATE TRIGGER IF NOT EXISTS check_venue_capacity_on_ticket
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
  DECLARE current_ticket_count INT;
  DECLARE venue_capacity INT;

  /*bρες τη χωρητικότητα της σκηνής για το event*/
  SELECT v.max_capacity INTO venue_capacity
  FROM event e
  JOIN venue v ON e.venue_id = v.venue_id
  WHERE e.event_id = NEW.event_id;

  /*μέτρα πόσα εισιτήρια έχουν εκδοθεί για αυτό το event*/
  SELECT COUNT(*) INTO current_ticket_count
  FROM ticket
  WHERE event_id = NEW.event_id;

  /*αν έχει ήδη πωληθεί ο μέγιστος αριθμός μπλόκαρε την αγορά*/
  IF current_ticket_count >= venue_capacity THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot sell ticket: venue capacity exceeded.';
  END IF;
END;


/*Τα VIP εισιτήρια περιορίζονται στο 10% της χωρητικότητας κάθε σκηνής.*/


CREATE TRIGGER IF NOT EXISTS check_vip_ticket_percentage
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
 
  DECLARE venue_capacity INT;
  DECLARE vip_ticket_count INT;
  DECLARE vip_category_id INT;

  /*get the ticket_category_id for vip*/
  SELECT ticket_category_id INTO vip_category_id
  FROM ticket_category
  WHERE category_name = 'VIP';

  /*if the ticket being inserted is  vip*/
  IF NEW.ticket_category_id = vip_category_id THEN
    /*find the capacity of the venue where the ticket is being issued*/
    SELECT v.max_capacity INTO venue_capacity
    FROM venue v
    WHERE v.venue_id = NEW.venue_id;

    /*count how many VIP tickets have already been sold for this event and venue*/
    SELECT COUNT(*) INTO vip_ticket_count
    FROM ticket t
    WHERE t.event_id = NEW.event_id
      AND t.venue_id = NEW.venue_id
      AND t.ticket_category_id = vip_category_id;

    /*f the number of VIP tickets exceeds 10% of capacity, block the insert*/
    IF vip_ticket_count >= CEIL(venue_capacity * 0.10) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'VIP ticket limit (10% of venue capacity) has been reached.';
    END IF;
  END IF;
END;



/*Only non-activated tickets (not activated = FALSE) can be added to resale_offer.*/


CREATE TRIGGER IF NOT EXISTS trg_prevent_activated_ticket_resale
BEFORE INSERT ON resale_offer
FOR EACH ROW
BEGIN
  DECLARE is_activated BOOLEAN;

  -- Check whether the ticket is already activated
  SELECT activated INTO is_activated
  FROM ticket
  WHERE ticket_id = NEW.ticket_id;

  -- If activated = TRUE, reject the resale offer
  IF is_activated THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot create resale offer for activated (used) ticket.';
  END IF;
END;

/*the oposite for review*/

CREATE TRIGGER IF NOT EXISTS trg_allow_only_activated_ticket_review
BEFORE INSERT ON review
FOR EACH ROW
BEGIN
  DECLARE is_activated BOOLEAN;

  -- Check whether the ticket is activated
  SELECT activated INTO is_activated
  FROM ticket
  WHERE ticket_id = NEW.ticket_id;

  -- If the ticket is NOT activated, reject the review
  IF NOT is_activated THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot create review for non-activated (unused) ticket.';
  END IF;
END;



/*views*/

/*q1*/

CREATE VIEW IF NOT EXISTS rock_artists AS
SELECT 
    a.artist_id,
    a.name
FROM 
    artist a
JOIN subgenre sg ON a.subgenre_id = sg.subgenre_id
JOIN genre g ON sg.genre_id = g.genre_id
WHERE 
    g.name = 'Rock';


/*q5*/

CREATE VIEW IF NOT EXISTS artist_festival_participations AS
SELECT 
    a.artist_id,
    f.festival_id
FROM 
    artist a
JOIN 
    performer p ON a.artist_id = p.artist_id
JOIN 
    performances pf ON p.performer_id = pf.performer_id
JOIN 
    event e ON pf.event_id = e.event_id
JOIN 
    festival f ON e.festival_id = f.festival_id

UNION ALL

SELECT 
    a.artist_id,
    f.festival_id
FROM 
    artist a
JOIN 
    artist_belongs ab ON a.artist_id = ab.artist_id
JOIN 
    performer p ON ab.band_id = p.band_id
JOIN 
    performances pf ON p.performer_id = pf.performer_id
JOIN 
    event e ON pf.event_id = e.event_id
JOIN 
    festival f ON e.festival_id = f.festival_id;


/*q13*/

CREATE VIEW IF NOT EXISTS artist_continent_participations AS
SELECT 
    a.artist_id,
    l.continent
FROM 
    artist a
JOIN 
    performer p ON a.artist_id = p.artist_id
JOIN 
    performances pf ON p.performer_id = pf.performer_id
JOIN 
    event e ON pf.event_id = e.event_id
JOIN 
    festival f ON e.festival_id = f.festival_id
JOIN 
    location l ON f.location_id = l.location_id

UNION ALL

SELECT 
    a.artist_id,
    l.continent
FROM 
    artist a
JOIN 
    artist_belongs ab ON a.artist_id = ab.artist_id
JOIN 
    performer p ON ab.band_id = p.band_id
JOIN 
    performances pf ON p.performer_id = pf.performer_id
JOIN 
    event e ON pf.event_id = e.event_id
JOIN 
    festival f ON e.festival_id = f.festival_id
JOIN 
    location l ON f.location_id = l.location_id;

/*q13*/

CREATE VIEW IF NOT EXISTS genre_year_performances AS
SELECT 
    g.name AS genre_name,
    f.year,
    COUNT(pf.performance_id) AS total_performances
FROM 
    performances pf
JOIN 
    performer pr ON pf.performer_id = pr.performer_id
LEFT JOIN 
    artist a ON pr.artist_id = a.artist_id
LEFT JOIN 
    band b ON pr.band_id = b.band_id
LEFT JOIN 
    subgenre sa ON a.subgenre_id = sa.subgenre_id
LEFT JOIN 
    subgenre sb ON b.subgenre_id = sb.subgenre_id
LEFT JOIN 
    genre g ON g.genre_id = 
    CASE 
      WHEN sa.genre_id IS NOT NULL THEN sa.genre_id
    ELSE sb.genre_id
END

JOIN 
    event e ON pf.event_id = e.event_id
JOIN 
    festival f ON e.festival_id = f.festival_id
GROUP BY 
    g.name, f.year;


/*Q9*/

CREATE VIEW IF NOT EXISTS performances_per_year AS
SELECT 
    t.person_id,
    YEAR(e.date) AS year_attended,
    COUNT(*) AS performance_count
FROM 
    ticket t
JOIN 
    event e ON t.event_id = e.event_id
WHERE 
    t.activated = TRUE
GROUP BY 
    t.person_id, YEAR(e.date)
HAVING 
    COUNT(*) > 3;








