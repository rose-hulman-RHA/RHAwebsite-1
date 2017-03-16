CREATE DATABASE RHA;

CREATE TABLE Members (
    user_id SERIAL PRIMARY KEY,
    username varchar(20),
    firstname varchar(20),
    lastname varchar(20),
    hall varchar(20),
    image varchar(100),
    memberType varchar(30), 
    active boolean, -- TODO: update table to not include this column
    trip_eligible boolean,
    meet_attend jsonb, -- {'Q1': [int], 'Q2': [int], 'Q3': [int]}
    CM int,
    phone_number int,
    room_number varchar(25)
);

-- Example query for viewing members from Mees hall who attended the first meeting in Fall quarter (0-indexed, but the first meeting is the second week in Q1):
-- Select * from Members Where meet_attend#>'{Q1, 1}' = '1' AND hall = 'Mees';
-- See https://www.postgresql.org/docs/9.3/static/functions-json.html for more details on jsonb querying 

CREATE TABLE Expenses (
    expenses_id SERIAL PRIMARY KEY ,
    proposal_id int references Proposals (proposal_id),
    CM int, 
    receiver varchar(50), 
    amountUsed double precision, 
    description varchar(50), 
    accountCode int, 
    dateReceived date, 
    dateProcessed date,
    reciepts jsonb
          -- ['Amount': Money, 
          --  'InvoiceDate': datetime]
);

CREATE TABLE Funds (
    funds_id SERIAL PRIMARY KEY,
    fund_name varchar(50),
    funds_amount double precision,
    display_on_site boolean
);

CREATE TABLE Proposals (
    proposal_id SERIAL PRIMARY KEY,
    proposer varchar(50),
    proposal_name varchar(50),
    week_proposed INT,
    quarter_proposed INT,
    money_requested double precision,
    approved boolean,
    money_allocated double precision,
    paid boolean,
    proposed_date DATE,
    event_date DATE,
    event_signup_open DATE,
    event_signup_close DATE,
    cost_to_attendee double precision,
    image_path varchar(100), 
    description varchar(400),
    attendees jsonb
);


CREATE TABLE Committee (
    committeeID SERIAL PRIMARY KEY,
    committeeName varchar(30),
    description varchar(1000),
    image varchar(100)
);

CREATE TABLE Equipment (
    equipmentID SERIAL PRIMARY KEY,
    equipmentName varchar(30),
    equipmentDescription varchar(500),
    equipmentEmbed varchar(500),
    rentalTimeInDays int DEFAULT 2
);

insert into Equipment (equipmentID, equipmentName, equipmentDescription, equipmentEmbed, rentalTimeInDays) values (DEFAULT, 'Kan Jam', 'This is equipment 1', '<iframe src="https://calendar.google.com/calendar/embed?mode=WEEK&amp;height=800&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;src=25v1djivm37d6psb5284pojmqs%40group.calendar.google.com&amp;color=%23AB8B00&amp;ctz=America%2FNew_York" style="border-width:0" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>', 3);
insert into Equipment (equipmentID, equipmentName, equipmentDescription, equipmentEmbed, rentalTimeInDays) values (DEFAULT, 'Cornhole', 'This is equipment 2', '<iframe src="https://calendar.google.com/calendar/embed?mode=WEEK&amp;height=600&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;src=s2bdbeg620ghgp9bh1e6k818uo%40group.calendar.google.com&amp;color=%238D6F47&amp;ctz=America%2FNew_York" style="border-width:0" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>', 3);

CREATE TABLE Rentals (
    rental_id SERIAL PRIMARY KEY,
    member_id INT references Members (user_id),
    equipment_id INT references Equipment (equipmentID),
    approved_by INT references Members (user_id),
    reason_for_rental varchar(100),
    rented_on DATE,
    return_on DATE,
    due_by DATE
);

CREATE TABLE FloorAttendanceNumerics (
    numerics_id SERIAL PRIMARY KEY,
    floor_name varchar(30),
    floor_minimum_attendance int
);

CREATE TABLE FloorMoney (
    floormoney_id SERIAL PRIMARY KEY,
    hall_and_floor varchar(50), -- Still working this one out.
    residents INT, -- Calculated via count_residents([floor name]);
    possible_earnings double precision, -- Calculated via calc_possible_earnings([floorname], [floor_resident_count], [money_per_person_per_year])
    current_earned double precision, -- Calculated via calc_earned_money([floorname], [floor_resident_count], [money_per_person_per_year])
    possible_balance double precision, -- Calculated via calc_possible_balance([floorname], [floor_resident_count], [money_per_person_per_year])
    current_balance double precision -- Calculated via calc_current_balance([floorname], [floor_resident_count], [money_per_person_per_year]);
);

CREATE TABLE FloorExpenses (
    floor_expense_id SERIAL PRIMARY KEY,
    floor_id INT references FloorMoney (floormoney_id),
    event_description varchar(100),
    amount INT,
    turned_in_date DATE,
    processed_date DATE  
);


CREATE TABLE InfoText (
  info_text_id SERIAL PRIMARY KEY,
  info_text_desc varchar(30),
  body varchar(5000)
);

/*Load all tables with contents from CSV files (if they exist)*/

COPY Proposals FROM '/tmp/proposals.csv' DELIMITER ',' CSV HEADER;
COPY Funds FROM '/tmp/funds.csv' DELIMITER ',' CSV HEADER;
COPY Members FROM '/tmp/members.csv' DELIMITER ',' CSV HEADER;
COPY Expenses FROM '/tmp/expenses.csv' DELIMITER ',' CSV HEADER;
COPY Committee FROM '/tmp/committee.csv' DELIMITER ',' CSV HEADER;
COPY Equipment FROM '/tmp/equipment.csv' DELIMITER ',' CSV HEADER;
COPY Rentals FROM '/tmp/rentals.csv' DELIMITER ',' CSV HEADER;
COPY FloorMoney FROM '/tmp/floormoney.csv' DELIMITER ',' CSV HEADER;
COPY FloorExpenses FROM '/tmp/floorexpenses.csv' DELIMITER ',' CSV HEADER;
COPY InfoText FROM '/tmp/infotext.csv' DELIMITER ',' CSV HEADER;
/* Inserts for FloorAttendanceNumerics */

INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Blum', 4);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Scharp', 4);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Mees', 4);

INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Apartments E 1', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Apartments E 2', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Apartments E 3', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Apartments W 1', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Apartments W 2', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Apartments W 3', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'BSB 1', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'BSB 2', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'BSB 3', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Deming 0', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Deming 1', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Deming 2', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Deming Attic', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Lakeside 1', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Lakeside 2', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Lakeside 3', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Lakeside 4', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Percopo 1', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Percopo 2', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Percopo 3', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Speed 1', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Speed 2', 2);
INSERT INTO FloorAttendanceNumerics (numerics_id, floor_name, floor_minimum_attendance) VALUES (DEFAULT, 'Speed 3', 2);

/* Pre-populates the FloorMoney table with barebones entries for update_floor_money() to be
  useable both on the initial creation of the database as well as whenever attendance is
  updated each week.

  RETURNS: void
*/
CREATE OR REPLACE FUNCTION populate_floor_money()
  RETURNS void AS $$
  BEGIN
    -- call other functions 
    CREATE TEMPORARY TABLE floor_resident_count AS 
    SELECT Members.hall, count(*) FROM Members GROUP BY Members.hall;
    INSERT INTO FloorMoney (hall_and_floor, residents) 
      SELECT hall, count FROM floor_resident_count;
    DROP TABLE floor_resident_count;

    SELECT * FROM update_floor_money();
  END;
$$ LANGUAGE plpgsql;


/* Updates floor money table using function suite below. Assuming floor money table is not empty and that
   the number of residents is accurate and does not need to be changed.


   RETURNS: void
*/
CREATE OR REPLACE FUNCTION update_floor_money()
  RETURNS void AS $$
  DECLARE
    p_earnings double precision;
    c_earned double precision;
    p_balance double precision;
    c_balance double precision;
    moneyRate int := 15; 
    t_row FloorMoney%rowtype;
  BEGIN

    FOR t_row IN SELECT * FROM FloorMoney LOOP
      p_earnings := calc_possible_earnings(t_row.hall_and_floor, t_row.residents, moneyRate);
      c_earned := calc_earned_money(t_row.hall_and_floor, t_row.residents, moneyRate);
      p_balance := calc_possible_balance(t_row.hall_and_floor, t_row.residents, moneyRate);
      c_balance := calc_current_balance(t_row.hall_and_floor, t_row.residents, moneyRate);
      UPDATE FloorMoney
        SET possible_earnings = p_earnings,
            current_earned = c_earned,
            possible_balance = p_balance,
            current_balance = c_balance
      WHERE floormoney_id = t_row.floormoney_id;
    END LOOP;
  END;
$$ LANGUAGE plpgsql;


/* Counts the attendance of the specified floor during the given week and quarter

   Returns: INT
*/
CREATE OR REPLACE FUNCTION count_attendance(week int, quarter varchar, floor varchar)
  RETURNS int AS $count$
  DECLARE 
    count int;
  BEGIN 
    SELECT INTO count count(*) FROM Members WHERE Members.hall = floor AND Members.meet_attend->quarter->week = '1';
     -- Return needs to be compared to a string because it's a JSON datatype
    RETURN count;
  END;
$count$ LANGUAGE plpgsql;


/* Calculates a given floor's earned money thus far given floor name, size of the floor, and money rate

   Returns: DOUBLE PRECISION
*/
CREATE OR REPLACE FUNCTION calc_earned_money(floor varchar, size int, moneyRate int) 
  RETURNS double precision AS $earned$
  DECLARE
    earned double precision := 0;
    meet_attended double precision := 0;
    counter int;
    min_attend int := 0;
    multiplier double precision;
    weeks int[] := ARRAY[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    quarters varchar[] := ARRAY['Q1', 'Q2', 'Q3'];
    x int;
    y varchar;
  BEGIN
    multiplier := (1.0 / 1.5) ^ (9.0) * (1.0 / 3.0) * moneyRate * size;
    FOREACH y IN ARRAY quarters
    LOOP
      meet_attended :=
      CASE 
        WHEN y = 'Q1' THEN 1
        ELSE 0
      END;
      FOREACH x IN ARRAY weeks
      LOOP
        SELECT INTO min_attend FloorAttendanceNumerics.floor_minimum_attendance FROM FloorAttendanceNumerics WHERE FloorAttendanceNumerics.floor_name = floor;
        SELECT INTO counter 
        CASE 
          WHEN (SELECT count_attendance(x, y, floor)) >= min_attend THEN 1
          ELSE 0
        END;
        meet_attended := meet_attended + counter;
      END LOOP;
      IF y = 'Q1' THEN
        meet_attended = meet_attended + 1; 
      END IF;
      earned := earned + (multiplier * ((1.5) ^ meet_attended));
    END LOOP;
  RETURN earned;
  END;
$earned$ LANGUAGE plpgsql;


/* Calculates a given floor's possible earnings given floor name, size of the floor, and money rate
   based on the number of meetings attended so far, and the number of meetings remaining in the year

   Returns: DOUBLE PRECISION
*/
CREATE OR REPLACE FUNCTION calc_possible_earnings(floor varchar, size int, moneyRate int) 
  RETURNS double precision AS $possible$
  DECLARE
    meetings json;
    attended int;
    possible double precision := 0;
    current_max_meetings int;
    min_attend int := 0;
    counter int;
    multiplier double precision := (1.0 / 1.5) ^ (9.0) * (1.0 / 3.0) * moneyRate * size;
    quarters varchar[] := ARRAY['Q1', 'Q2', 'Q3'];
    weeks int[] := ARRAY[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    x int;
    y varchar;
  BEGIN
    FOREACH y IN ARRAY quarters
    LOOP
      SELECT INTO meetings Members.meet_attend->y FROM Members WHERE Members.hall = floor LIMIT 1;
      current_max_meetings := json_array_length(meetings);
      attended := 
      CASE
        WHEN y = 'Q1' THEN 1
        ELSE 0
      END;
      FOREACH x IN ARRAY weeks
      LOOP
        SELECT INTO min_attend FloorAttendanceNumerics.floor_minimum_attendance FROM FloorAttendanceNumerics WHERE FloorAttendanceNumerics.floor_name = floor;
        attended := 
        CASE 
          WHEN (SELECT count_attendance(x, y, floor)) >= min_attend THEN attended + 1
          ELSE attended + 0
        END;
      END LOOP;
      current_max_meetings := attended + (9 - current_max_meetings);
      possible := possible + multiplier * (1.5 ^ current_max_meetings);
    END LOOP;
    return possible;
  END;
$possible$ LANGUAGE plpgsql;


/* Counts the number of residents on a given floor from the Members table 

   Returns: INT
*/
CREATE OR REPLACE FUNCTION count_residents(floor varchar)
  RETURNS int AS $residents$
  DECLARE
    residents int;
  BEGIN
    SELECT INTO residents count(*) FROM Members WHERE Members.hall = floor;
    RETURN residents;
  END;
$residents$ LANGUAGE plpgsql;


/* Sums the expenses and rewards from FloorExpenses given the floor name

   Returns: INT
*/
CREATE OR REPLACE FUNCTION sum_expenses(floor varchar)
  RETURNS double precision AS $expenses$
  DECLARE
    expenses double precision;
    count int;
  BEGIN
    SELECT INTO expenses SUM(FloorExpenses.amount) FROM FloorMoney, FloorExpenses WHERE FloorMoney.hall_and_floor = floor AND FloorMoney.floormoney_id = FloorExpenses.floor_id;
    return expenses;
  END;
$expenses$ LANGUAGE plpgsql;


/* Calculates the given floor's current balance based on earned money totaled with their expenses

   Returns: DOUBLE PRECISION
*/
CREATE OR REPLACE FUNCTION calc_current_balance(floor varchar, size int, moneyRate int) 
  RETURNS double precision AS $balance$
  DECLARE
    balance double precision;
    earned double precision;
    expenses double precision;
  BEGIN
    SELECT INTO expenses sum_expenses(floor);
    SELECT INTO earned calc_earned_money(floor, size, moneyRate);
    IF expenses IS NULL THEN RETURN earned;
    END IF;
    balance := expenses + earned;
    RETURN balance;
  END;
$balance$ LANGUAGE plpgsql;
  

/* Calculates the given floor's possible balance based on possible money totaled with their expenses

   Returns: DOUBLE PRECISION
*/
CREATE OR REPLACE FUNCTION calc_possible_balance(floor varchar, size int, moneyRate int) 
  RETURNS double precision AS $balance$
  DECLARE
    balance double precision;
    possible double precision;
    expenses double precision;
  BEGIN
    SELECT INTO expenses sum_expenses(floor);
    SELECT INTO possible calc_possible_earnings(floor, size, moneyRate);
    IF expenses IS NULL THEN RETURN possible;
    END IF;
    balance := expenses + possible;
    RETURN balance;
  END;
$balance$ LANGUAGE plpgsql;

/* Adds given value to "Additions" row in Funds table

   RETURNS: void
*/
CREATE OR REPLACE FUNCTION add_additions(amount double precision) 
  RETURNS void AS $$
  DECLARE
    previous_value double precision;
    new_amount double precision;
  BEGIN
    SELECT INTO previous_value funds_amount FROM Funds WHERE Funds.fund_name = 'Additions';
    new_amount := amount + previous_value;
    UPDATE Funds SET funds_amount = new_amount WHERE fund_name = 'Additions';
    RETURN;
  END;
$$ LANGUAGE plpgsql;

/* Counts the attendence records for a given floor during a given quarter

  RETURNS: int
*/
CREATE OR REPLACE FUNCTION count_attendance_for_floor(floor varchar, quarter varchar)
  RETURNS int AS $attendance$
  DECLARE
    attendance int;
    min_attend int := 0;
    weeks int[] := ARRAY[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    x int;
  BEGIN
    IF quarter = 'Q1' THEN attendance := 1;
      ELSE attendance := 0;
    END IF;
    FOREACH x IN ARRAY weeks LOOP
      SELECT INTO min_attend FloorAttendanceNumerics.floor_minimum_attendance FROM FloorAttendanceNumerics WHERE FloorAttendanceNumerics.floor_name = floor;
      attendance := 
        CASE 
          WHEN (SELECT count_attendance(x, quarter, floor)) >= min_attend THEN attendance + 1
          ELSE attendance + 0
        END;
    END LOOP;
    RETURN attendance;
  END;
$attendance$ LANGUAGE plpgsql;

/* Sums the expenses from FloorExpenses given the floor name

   Returns: INT
*/
CREATE OR REPLACE FUNCTION sum_only_expenses(floor varchar)
  RETURNS double precision AS $expenses$
  DECLARE
    expenses double precision;
    count int;
  BEGIN
    SELECT INTO expenses SUM(FloorExpenses.amount) FROM FloorMoney, FloorExpenses WHERE FloorMoney.hall_and_floor = floor AND FloorMoney.floormoney_id = FloorExpenses.floor_id AND FloorExpenses.amount < 0;
    IF expenses IS NULL THEN return 0;
    END IF;
    return expenses;
  END;
$expenses$ LANGUAGE plpgsql;

/* Sums the awards from FloorExpenses given the floor name

   Returns: INT
*/
CREATE OR REPLACE FUNCTION sum_only_awards(floor varchar)
  RETURNS double precision AS $expenses$
  DECLARE
    expenses double precision;
    count int;
  BEGIN
    SELECT INTO expenses SUM(FloorExpenses.amount) FROM FloorMoney, FloorExpenses WHERE FloorMoney.hall_and_floor = floor AND FloorMoney.floormoney_id = FloorExpenses.floor_id AND FloorExpenses.amount > 0;
    IF expenses IS NULL THEN return 0;
    END IF;
    return expenses;
  END;
$expenses$ LANGUAGE plpgsql;


/* Determines the amount of money used for a given proposal

  RETURNS: Double precision
*/
CREATE OR REPLACE FUNCTION get_money_used(prop_id int)
  RETURNS double precision AS $used$
  DECLARE
    used double precision;
  BEGIN
    SELECT INTO used SUM(Expenses.amountUsed) FROM Expenses WHERE Expenses.proposal_id = prop_id;
    IF used IS NULL THEN RETURN 0;
    END IF;
    RETURN used;
  END;
$used$ LANGUAGE plpgsql;