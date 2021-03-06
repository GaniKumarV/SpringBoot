DROP TABLE CETERA.ANSWERS;
DROP TABLE CETERA.ENCRYPTED_PAYLOAD;
DROP TABLE CETERA.IQUANTIFY;
DROP TABLE CETERA.PERFORMANCES;
DROP TABLE CETERA.RESOURCES_QA;
DROP TABLE CETERA.RESOURCES;
DROP TABLE CETERA.REVENUE;
DROP TABLE CETERA.SESSIONS;
DROP TABLE CETERA.PERSON;
DROP TABLE CETERA.BD_QA;
DROP TABLE CETERA.QUESTIONNAIRE;
DROP TABLE CETERA.BROKER_DEALER;

DROP SEQUENCE CETERA.ANSWERS_SEQ;
DROP SEQUENCE CETERA.ENCRYPTED_PAYLOAD_SEQ;
DROP SEQUENCE CETERA.IQUANTIFY_SEQ;
DROP SEQUENCE CETERA.PERFORMANCES_SEQ;
DROP SEQUENCE CETERA.QUESTIONNAIRE_SEQ;
DROP SEQUENCE CETERA.RESOURCES_QA_SEQ;
DROP SEQUENCE CETERA.RESOURCES_SEQ;
DROP SEQUENCE CETERA.REVENUE_SEQ;
DROP SEQUENCE CETERA.BD_QA_SEQ;
DROP SEQUENCE CETERA.BROKER_DEALER_SEQ;

CREATE SEQUENCE CETERA.BROKER_DEALER_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.ANSWERS_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.ENCRYPTED_PAYLOAD_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.IQUANTIFY_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.PERFORMANCES_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.QUESTIONNAIRE_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.RESOURCES_QA_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.RESOURCES_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.REVENUE_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.BD_QA_SEQ START WITH 1 CACHE 20;

CREATE TABLE CETERA.BROKER_DEALER (
  ID                  NUMBER NOT NULL,
  EXTERNAL_ID         NUMBER,
  BD_NAME             VARCHAR2(100),
  DOMAIN_NAME         VARCHAR2(200),
  VERSION             VARCHAR2(20) NOT NULL,
  CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
  CONSTRAINT BROKER_DEALER_PK PRIMARY KEY (ID),
  CONSTRAINT BROKER_DEALER_UK1 UNIQUE (EXTERNAL_ID),
  CONSTRAINT BROKER_DEALER_UK2 UNIQUE (BD_NAME),
  CONSTRAINT BROKER_DEALER_UK3 UNIQUE (DOMAIN_NAME)
);

CREATE TABLE CETERA.ENCRYPTED_PAYLOAD (
	ID                  NUMBER NOT NULL,
	PAYLOAD             CLOB NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT ENCRYPTED_PAYLOAD_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.PERFORMANCES (
	ID                  NUMBER NOT NULL,
	USER_COUNT          NUMBER(38,0) NOT NULL,
	PERFORMANCE         NUMBER NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT PERFORMANCE_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.QUESTIONNAIRE (
	ID                  NUMBER NOT NULL,
	NAME                VARCHAR2(50)  NOT NULL,
	QUESTIONS           CLOB NOT NULL,
	VERSION             VARCHAR2(20)  NOT NULL,
	STATUS              VARCHAR2(20)  NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT QUESTIONNAIRE_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.RESOURCES (
	ID                  NUMBER NOT NULL,
	VERSION             VARCHAR2(20)  NOT NULL,
	LINKS               CLOB NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT RESOURCES_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.PERSON (
	ID                  VARCHAR2(100) NOT NULL,
	FIRST_NAME          VARCHAR2(50) NOT NULL,
	LAST_NAME           VARCHAR2(50) NOT NULL,
	EMAIL               VARCHAR2(100) NOT NULL,
	CONSULTANT_EMAIL    VARCHAR2(100),
	BD_ID               NUMBER NOT NULL,
	IS_INTERNAL         VARCHAR2(1) NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT PERSON_PK PRIMARY KEY ( ID ),
	CONSTRAINT PERSON_FK1
	FOREIGN KEY (BD_ID)
	REFERENCES CETERA.BROKER_DEALER (ID)
 );

 CREATE TABLE CETERA.BD_QA (
  ID                  NUMBER NOT NULL,
  BD_ID               NUMBER NOT NULL,
  QUESTIONNAIRE_ID    NUMBER NOT NULL,
  VERSION             VARCHAR2(20) NOT NULL,
  STATUS              VARCHAR2(20) NOT NULL,
  CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
  CONSTRAINT BD_QA_PK PRIMARY KEY ( ID ),
  CONSTRAINT BD_QA_UK UNIQUE (BD_ID, QUESTIONNAIRE_ID),
  CONSTRAINT BD_QA_FK1
  FOREIGN KEY (BD_ID)
  REFERENCES CETERA.BROKER_DEALER (ID),
  CONSTRAINT BD_QA_FK2
  FOREIGN KEY (QUESTIONNAIRE_ID)
  REFERENCES CETERA.QUESTIONNAIRE (ID)
);

CREATE TABLE CETERA.RESOURCES_QA (
	ID                  NUMBER NOT NULL,
	BD_QA_ID            NUMBER NOT NULL,
	QUESTION_ID         NUMBER(38,0)  NOT NULL,
	RES_ID              NUMBER NOT NULL,
	RANKING             NUMBER(38,0)  NOT NULL,
	LOWER_LIMIT         NUMBER(38,0)  NOT NULL,
	UPPER_LIMIT         NUMBER(38,0)  NOT NULL,
	VERSION             VARCHAR2(20)  NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT RESOURCES_QA_PK PRIMARY KEY ( ID ),
	CONSTRAINT RESOURCES_QA_FK1
	FOREIGN KEY (BD_QA_ID)
	REFERENCES CETERA.BD_QA (ID),
	CONSTRAINT RESOURCES_QA_FK3
	FOREIGN KEY (RES_ID)
	REFERENCES CETERA.RESOURCES (ID)
 );

CREATE TABLE CETERA.REVENUE (
	ID                  NUMBER NOT NULL,
	PERSON_ID           VARCHAR2(100)  NOT NULL,
	YEARLY_REVENUE      NUMBER NOT NULL,
	QUALIFIED_PERC      NUMBER NOT NULL,
	NON_RECURRING_PERC  NUMBER NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT REVENUE_PK PRIMARY KEY ( ID ),
	CONSTRAINT REVENUE_FK1
	FOREIGN KEY (PERSON_ID)
	REFERENCES CETERA.PERSON (ID)
 );

CREATE TABLE CETERA.SESSIONS (
	ID                  VARCHAR2(100)  NOT NULL,
	PERSON_ID           VARCHAR2(100)  NOT NULL,
	EXPIRES_ON          TIMESTAMP(6)  NOT NULL,
	SURVEY_STATUS       VARCHAR2(20)  NOT NULL,
	IS_INTERNAL         VARCHAR2(1)  NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT SESSIONS_PK PRIMARY KEY ( ID ),
	CONSTRAINT SESSIONS_FK1
	FOREIGN KEY (PERSON_ID)
	REFERENCES CETERA.PERSON (ID)
 );

CREATE TABLE CETERA.IQUANTIFY (
	ID                  NUMBER NOT NULL,
	QUESTIONNAIRE_ID    NUMBER NOT NULL,
	PERFORMANCE         NUMBER NOT NULL,
	I_QUANTIFY          NUMBER NOT NULL,
	PERSON_ID           VARCHAR2(100)  NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT IQUANTIFY_PK PRIMARY KEY ( ID ),
	CONSTRAINT IQUANTIFY_FK1
	FOREIGN KEY (QUESTIONNAIRE_ID)
	REFERENCES CETERA.QUESTIONNAIRE (ID),
	CONSTRAINT IQUANTIFY_FK2
	FOREIGN KEY (PERSON_ID)
	REFERENCES CETERA.PERSON (ID)
 );

CREATE TABLE CETERA.ANSWERS (
	ID                  NUMBER NOT NULL,
	I_QUANTIFY_ID       NUMBER NOT NULL,
	QUESTION_ID         NUMBER(38,0)  NOT NULL,
	QUESTION            VARCHAR2(1000)  NOT NULL,
	ANSWER              VARCHAR2(1000)  NOT NULL,
	WEIGHT              NUMBER(38,0)  NOT NULL,
	CREATED_BY          VARCHAR2(100) NOT NULL,
  CREATED_ON          TIMESTAMP(6) NOT NULL,
  UPDATED_BY          VARCHAR2(100),
  UPDATED_ON          TIMESTAMP(6),
	CONSTRAINT ANSWERS_PK PRIMARY KEY ( ID ),
	CONSTRAINT ANSWERS_FK1
	FOREIGN KEY (I_QUANTIFY_ID)
	REFERENCES CETERA.IQUANTIFY (ID),
	CONSTRAINT ANSWERS_UK UNIQUE (I_QUANTIFY_ID, QUESTION_ID)
 );

CREATE OR REPLACE TRIGGER CETERA.BROKER_DEALER_TRG
BEFORE INSERT ON BROKER_DEALER
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT BROKER_DEALER_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

CREATE OR REPLACE TRIGGER CETERA.ANSWERS_TRG
BEFORE INSERT ON ANSWERS
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT ANSWERS_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.ENCRYPTED_PAYLOAD_TRG
BEFORE INSERT ON ENCRYPTED_PAYLOAD
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT ENCRYPTED_PAYLOAD_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.IQUANTIFY_TRG
BEFORE INSERT ON IQUANTIFY
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT IQUANTIFY_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.PERFORMANCES_TRG
BEFORE INSERT ON PERFORMANCES
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT PERFORMANCES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.QUESTIONNAIRE_TRG
BEFORE INSERT ON QUESTIONNAIRE
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT QUESTIONNAIRE_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.RESOURCES_QA_TRG
BEFORE INSERT ON RESOURCES_QA
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT RESOURCES_QA_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.RESOURCES_TRG
BEFORE INSERT ON RESOURCES
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT RESOURCES_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.REVENUE_TRG
BEFORE INSERT ON REVENUE
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT REVENUE_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER CETERA.BD_QA_TRG
BEFORE INSERT ON BD_QA
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT BD_QA_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/

CREATE INDEX CETERA.IDX1_ANSWERS ON CETERA.ANSWERS ( I_QUANTIFY_ID );
CREATE INDEX CETERA.IDX2_ANSWERS ON CETERA.ANSWERS ( QUESTION_ID );
CREATE INDEX CETERA.IDX_SESSIONS ON CETERA.SESSIONS ( PERSON_ID );
CREATE INDEX CETERA.IDX_PERSON ON CETERA.PERSON (BD_ID);
CREATE INDEX CETERA.IDX1_RESOURCES_QA ON CETERA.RESOURCES_QA (BD_QA_ID);
CREATE INDEX CETERA.IDX2_RESOURCES_QA ON CETERA.RESOURCES_QA (RES_ID);
CREATE INDEX CETERA.IDX_REVENUE ON CETERA.REVENUE (PERSON_ID);
CREATE INDEX CETERA.IDX1_IQUANTIFY ON CETERA.IQUANTIFY (QUESTIONNAIRE_ID);
CREATE INDEX CETERA.IDX2_IQUANTIFY ON CETERA.IQUANTIFY (PERSON_ID);
CREATE INDEX CETERA.IDX1_BD_QA ON CETERA.BD_QA (BD_ID);
CREATE INDEX CETERA.IDX2_BD_QA ON CETERA.BD_QA (QUESTIONNAIRE_ID);