CREATE SEQUENCE CETERA.ANSWERS_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.ENCRYPTED_PAYLOAD_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.IQUANTIFY_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.PERFORMANCES_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.PERSON_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.QUESTIONNAIRE_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.RESOURCES_QA_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.RESOURCES_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.REVENUE_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE CETERA.SESSIONS_SEQ START WITH 1 CACHE 20;

CREATE TABLE CETERA.ENCRYPTED_PAYLOAD (
	ID                   number  NOT NULL,
	PAYLOAD              clob  NOT NULL,
	CREATED_BY           varchar2(100)  ,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT ENCRYPTED_PAYLOAD_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.PERFORMANCES (
	ID                   number  NOT NULL,
	USER_COUNT           number(38,0)  NOT NULL,
	PERFORMANCE          number  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           date  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           date  ,
	CONSTRAINT PERFORMANCE_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.PERSON (
	ID                   varchar2(100)  NOT NULL,
	FIRST_NAME           varchar2(50)  NOT NULL,
	LAST_NAME            varchar2(50)  NOT NULL,
	EMAIL                varchar2(100)  NOT NULL,
	CONSULTANT_EMAIL     varchar2(100)  ,
	BROKER_DEALER        number(5,0)  ,
	UPDATED_ON           timestamp(6)  ,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	CREATED_BY           varchar2(100)  NOT NULL,
	CONSTRAINT PERSON_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.QUESTIONNAIRE (
	ID                   number  NOT NULL,
	NAME                 varchar2(50)  NOT NULL,
	VERSION              varchar2(20)  NOT NULL,
	STATUS               varchar2(20)  NOT NULL,
	QUESTIONS            clob  NOT NULL,
	BROKER_DEALER        number(38,0)  ,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT QUESTIONNAIRE_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.RESOURCES (
	ID                   number  NOT NULL,
	VERSION              varchar2(20)  NOT NULL,
	LINKS                clob  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT RESOURCES_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.RESOURCES_QA (
	ID                   number  NOT NULL,
	QUESTIONNAIRE_ID     number  NOT NULL,
	QUESTION_ID          number(38,0)  NOT NULL,
	RES_ID               number  NOT NULL,
	RANKING              number(38,0)  NOT NULL,
	LOWER_LIMIT          number(38,0)  NOT NULL,
	UPPER_LIMIT          number(38,0)  NOT NULL,
	STATUS               varchar2(20)  NOT NULL,
	VERSION              varchar2(20)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT RESOURCES_QA_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.REVENUE (
	ID                   number  NOT NULL,
	PERSON_ID            varchar2(100)  NOT NULL,
	YEARLY_REVENUE       number  NOT NULL,
	QUALIFIED_PERC       number  NOT NULL,
	NON_RECURRING_PERC   number  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT REVENUE_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.SESSIONS (
	ID                   varchar2(100)  NOT NULL,
	PERSON_ID            varchar2(100)  NOT NULL,
	EXPIRES_ON           timestamp(6)  NOT NULL,
	SURVEY_STATUS        varchar2(20)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT SESSIONS_PK PRIMARY KEY ( ID )
 );

CREATE INDEX IDX_SESSIONS ON CETERA.SESSIONS ( PERSON_ID );

CREATE TABLE CETERA.IQUANTIFY (
	ID                   number  NOT NULL,
	QUESTIONNAIRE_ID     number  NOT NULL,
	PERFORMANCE          number  NOT NULL,
	I_QUANTIFY           number  NOT NULL,
	PERSON_ID            varchar2(100)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT IQUANTIFY_PK PRIMARY KEY ( ID )
 );

CREATE TABLE CETERA.ANSWERS (
	ID                   number  NOT NULL,
	I_QUANTIFY_ID        number  NOT NULL,
	QUESTION_ID          number(38,0)  NOT NULL,
	QUESTION             varchar2(1000)  NOT NULL,
	ANSWER               varchar2(1000)  NOT NULL,
	WEIGHT               number(38,0)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT ANSWERS_PK PRIMARY KEY ( ID )
 );

CREATE INDEX IDX_ANSWERS ON CETERA.ANSWERS ( I_QUANTIFY_ID );

CREATE OR REPLACE TRIGGER ANSWERS_TRG
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
CREATE OR REPLACE TRIGGER ENCRYPTED_PAYLOAD_TRG
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
CREATE OR REPLACE TRIGGER IQUANTIFY_TRG
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
CREATE OR REPLACE TRIGGER PERFORMANCES_TRG
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
CREATE OR REPLACE TRIGGER PERSON_TRG
BEFORE INSERT ON PERSON
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT PERSON_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER QUESTIONNAIRE_TRG
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
CREATE OR REPLACE TRIGGER RESOURCES_QA_TRG
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
CREATE OR REPLACE TRIGGER RESOURCES_TRG
BEFORE INSERT ON RESOURCES
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
END;
/
CREATE OR REPLACE TRIGGER REVENUE_TRG
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
CREATE OR REPLACE TRIGGER SESSIONS_TRG
BEFORE INSERT ON SESSIONS
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ID IS NULL THEN
      SELECT SESSIONS_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TABLE CETERA.ANSWERS ADD CONSTRAINT ANSWERS_FK1 FOREIGN KEY ( I_QUANTIFY_ID ) REFERENCES CETERA.IQUANTIFY( ID );

ALTER TABLE CETERA.IQUANTIFY ADD CONSTRAINT IQUANTIFY_FK1 FOREIGN KEY ( PERSON_ID ) REFERENCES CETERA.PERSON( ID );

ALTER TABLE CETERA.IQUANTIFY ADD CONSTRAINT IQUANTIFY_FK2 FOREIGN KEY ( QUESTIONNAIRE_ID ) REFERENCES CETERA.QUESTIONNAIRE( ID );

ALTER TABLE CETERA.RESOURCES_QA ADD CONSTRAINT RESOURCES_QA_FK1 FOREIGN KEY ( QUESTIONNAIRE_ID ) REFERENCES CETERA.QUESTIONNAIRE( ID );

ALTER TABLE CETERA.RESOURCES_QA ADD CONSTRAINT RESOURCES_QA_FK2 FOREIGN KEY ( RES_ID ) REFERENCES CETERA.RESOURCES( ID );

ALTER TABLE CETERA.REVENUE ADD CONSTRAINT REVENUE_FK1 FOREIGN KEY ( PERSON_ID ) REFERENCES CETERA.PERSON( ID );

ALTER TABLE CETERA.SESSIONS ADD CONSTRAINT FK_SESSIONS FOREIGN KEY ( PERSON_ID ) REFERENCES CETERA.PERSON( ID );
