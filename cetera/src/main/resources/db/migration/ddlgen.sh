TSDATA="TABLESPACE IQUANTIFY_DATA"
TSIDX="TABLESPACE IQUANTIFY_INDEX"
SCHEMA="IQUANTIFY"
#TSDATA=""
#TSIDX=""
#SCHEMA="CETERA"

cat <<EOF
DROP TABLE $SCHEMA.ANSWERS;
DROP TABLE $SCHEMA.ENCRYPTED_PAYLOAD;
DROP TABLE $SCHEMA.IQUANTIFY;
DROP TABLE $SCHEMA.PERFORMANCES;
DROP TABLE $SCHEMA.RESOURCES_QA;
DROP TABLE $SCHEMA.RESOURCES;
DROP TABLE $SCHEMA.REVENUE;
DROP TABLE $SCHEMA.SESSIONS;
DROP TABLE $SCHEMA.PERSON;
DROP TABLE $SCHEMA.BD_QA;
DROP TABLE $SCHEMA.QUESTIONNAIRE;
DROP TABLE $SCHEMA.BROKER_DEALER;

DROP SEQUENCE $SCHEMA.ANSWERS_SEQ;
DROP SEQUENCE $SCHEMA.ENCRYPTED_PAYLOAD_SEQ;
DROP SEQUENCE $SCHEMA.IQUANTIFY_SEQ;
DROP SEQUENCE $SCHEMA.RESOURCES_QA_SEQ;
DROP SEQUENCE $SCHEMA.REVENUE_SEQ;

CREATE SEQUENCE $SCHEMA.ANSWERS_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE $SCHEMA.ENCRYPTED_PAYLOAD_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE $SCHEMA.IQUANTIFY_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE $SCHEMA.RESOURCES_QA_SEQ START WITH 1 CACHE 20;

CREATE SEQUENCE $SCHEMA.REVENUE_SEQ START WITH 1 CACHE 20;

CREATE TABLE $SCHEMA.BROKER_DEALER ( 
	ID                   number(38,0)  NOT NULL,
	EXTERNAL_ID          number(38,0)  ,
	BD_NAME              varchar2(100)  ,
	DOMAIN_NAME          varchar2(200)  ,
	VERSION              varchar2(20)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT BROKER_DEALER_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT BROKER_DEALER_UK1 UNIQUE ( EXTERNAL_ID ) ,
	CONSTRAINT BROKER_DEALER_UK2 UNIQUE ( BD_NAME ) ,
	CONSTRAINT BROKER_DEALER_UK3 UNIQUE ( DOMAIN_NAME ) 
 )
$TSDATA;

CREATE TABLE $SCHEMA.ENCRYPTED_PAYLOAD ( 
	ID                   number(38,0)  NOT NULL,
	PAYLOAD              clob  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT ENCRYPTED_PAYLOAD_PK PRIMARY KEY ( ID ) 
 )
$TSDATA;

CREATE TABLE $SCHEMA.PERFORMANCES ( 
	ID                   number(38,0)  NOT NULL,
	USER_COUNT           number(38,0)  NOT NULL,
	PERFORMANCE          number  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT PERFORMANCE_PK PRIMARY KEY ( ID ) 
 )
$TSDATA;

CREATE TABLE $SCHEMA.PERSON ( 
	ID                   varchar2(100)  NOT NULL,
	FIRST_NAME           varchar2(50)  NOT NULL,
	LAST_NAME            varchar2(50)  NOT NULL,
	EMAIL                varchar2(100)  NOT NULL,
	CONSULTANT_EMAIL     varchar2(100)  ,
	BD_ID                number(38,0)  NOT NULL,
	IS_INTERNAL          varchar2(1)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT PERSON_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT PERSON_FK1 FOREIGN KEY ( BD_ID ) REFERENCES $SCHEMA.BROKER_DEALER( ID )  
 )
$TSDATA;

CREATE INDEX PERSON_IDX ON $SCHEMA.PERSON ( BD_ID ) $TSIDX;

CREATE TABLE $SCHEMA.QUESTIONNAIRE ( 
	ID                   number(38,0)  NOT NULL,
	NAME                 varchar2(50)  NOT NULL,
	QUESTIONS            clob  NOT NULL,
	VERSION              varchar2(20)  NOT NULL,
	STATUS               varchar2(20)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT QUESTIONNAIRE_PK PRIMARY KEY ( ID ) 
 )
$TSDATA;

CREATE TABLE $SCHEMA.RESOURCES ( 
	ID                   number(38,0)  NOT NULL,
	VERSION              varchar2(20)  NOT NULL,
	LINKS                clob  NOT NULL,
	DESCRIPTION          varchar2(20)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT RESOURCES_PK PRIMARY KEY ( ID ) 
 )
$TSDATA;

CREATE TABLE $SCHEMA.REVENUE ( 
	ID                   number(38,0)  NOT NULL,
	PERSON_ID            varchar2(100)  NOT NULL,
	YEARLY_REVENUE       number  NOT NULL,
	QUALIFIED_PERC       number  NOT NULL,
	NON_RECURRING_PERC   number  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT REVENUE_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT REVENUE_FK1 FOREIGN KEY ( PERSON_ID ) REFERENCES $SCHEMA.PERSON( ID )  
 )
$TSDATA;

CREATE INDEX REVENUE_IDX ON $SCHEMA.REVENUE ( PERSON_ID ) $TSIDX;

CREATE TABLE $SCHEMA.SESSIONS ( 
	ID                   varchar2(100)  NOT NULL,
	PERSON_ID            varchar2(100)  NOT NULL,
	EXPIRES_ON           timestamp(6)  NOT NULL,
	SURVEY_STATUS        varchar2(20)  NOT NULL,
	IS_INTERNAL          varchar2(1)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT SESSIONS_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT SESSIONS_FK1 FOREIGN KEY ( PERSON_ID ) REFERENCES $SCHEMA.PERSON( ID )  
 )
$TSDATA;

CREATE INDEX SESSIONS_IDX ON $SCHEMA.SESSIONS ( PERSON_ID ) $TSIDX;

CREATE TABLE $SCHEMA.BD_QA ( 
	ID                   number(38,0)  NOT NULL,
	BD_ID                number(38,0)  NOT NULL,
	QUESTIONNAIRE_ID     number(38,0)  NOT NULL,
	VERSION              varchar2(20)  NOT NULL,
	STATUS               varchar2(20)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT BD_QA_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT BD_QA_UK UNIQUE ( BD_ID, QUESTIONNAIRE_ID ) ,
	CONSTRAINT BD_QA_FK1 FOREIGN KEY ( BD_ID ) REFERENCES $SCHEMA.BROKER_DEALER( ID )  ,
	CONSTRAINT BD_QA_FK2 FOREIGN KEY ( QUESTIONNAIRE_ID ) REFERENCES $SCHEMA.QUESTIONNAIRE( ID )  
 )
$TSDATA;

CREATE INDEX BD_QA_IDX1 ON $SCHEMA.BD_QA ( BD_ID ) $TSIDX;

CREATE INDEX BD_QA_IDX2 ON $SCHEMA.BD_QA ( QUESTIONNAIRE_ID ) $TSIDX;

CREATE TABLE $SCHEMA.IQUANTIFY ( 
	ID                   number(38,0)  NOT NULL,
	QUESTIONNAIRE_ID     number(38,0)  NOT NULL,
	PERFORMANCE          number  NOT NULL,
	I_QUANTIFY           number  NOT NULL,
	PERSON_ID            varchar2(100)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT IQUANTIFY_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT IQUANTIFY_FK2 FOREIGN KEY ( PERSON_ID ) REFERENCES $SCHEMA.PERSON( ID )  ,
	CONSTRAINT IQUANTIFY_FK1 FOREIGN KEY ( QUESTIONNAIRE_ID ) REFERENCES $SCHEMA.QUESTIONNAIRE( ID )  
 )
$TSDATA;

CREATE INDEX IQUANTIFY_IDX1 ON $SCHEMA.IQUANTIFY ( QUESTIONNAIRE_ID ) $TSIDX;

CREATE INDEX IQUANTIFY_IDX2 ON $SCHEMA.IQUANTIFY ( PERSON_ID ) $TSIDX;

CREATE INDEX IQUANTIFY_IDX3 ON $SCHEMA.IQUANTIFY ( PERSON_ID, CREATED_ON ) $TSIDX;

CREATE TABLE $SCHEMA.RESOURCES_QA ( 
	ID                   number(38,0)  NOT NULL,
	BD_QA_ID             number(38,0)  NOT NULL,
	QUESTION_ID          number(38,0)  NOT NULL,
	RES_ID               number(38,0)  NOT NULL,
	RANKING              number(38,0)  NOT NULL,
	LOWER_LIMIT          number(38,0)  NOT NULL,
	UPPER_LIMIT          number(38,0)  NOT NULL,
	VERSION              varchar2(20)  NOT NULL,
	STATUS               varchar2(20)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT RESOURCES_QA_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT RESOURCES_QA_FK1 FOREIGN KEY ( BD_QA_ID ) REFERENCES $SCHEMA.BD_QA( ID )  ,
	CONSTRAINT RESOURCES_QA_FK3 FOREIGN KEY ( RES_ID ) REFERENCES $SCHEMA.RESOURCES( ID )  
 )
$TSDATA;

CREATE INDEX RESOURCES_QA_IDX1 ON $SCHEMA.RESOURCES_QA ( BD_QA_ID ) $TSIDX;

CREATE INDEX RESOURCES_QA_IDX2 ON $SCHEMA.RESOURCES_QA ( RES_ID ) $TSIDX;

CREATE TABLE $SCHEMA.ANSWERS ( 
	ID                   number(38,0)  NOT NULL,
	I_QUANTIFY_ID        number(38,0)  NOT NULL,
	QUESTION_ID          number(38,0)  NOT NULL,
	QUESTION             varchar2(1000)  NOT NULL,
	ANSWER               varchar2(1000)  NOT NULL,
	WEIGHT               number(38,0)  NOT NULL,
	CREATED_BY           varchar2(100)  NOT NULL,
	CREATED_ON           timestamp(6)  NOT NULL,
	UPDATED_BY           varchar2(100)  ,
	UPDATED_ON           timestamp(6)  ,
	CONSTRAINT ANSWERS_PK PRIMARY KEY ( ID ) ,
	CONSTRAINT ANSWERS_UK UNIQUE ( I_QUANTIFY_ID, QUESTION_ID ) ,
	CONSTRAINT ANSWERS_FK1 FOREIGN KEY ( I_QUANTIFY_ID ) REFERENCES $SCHEMA.IQUANTIFY( ID )  
 )
$TSDATA;

CREATE INDEX ANSWERS_IDX1 ON $SCHEMA.ANSWERS ( I_QUANTIFY_ID ) $TSIDX;

CREATE INDEX ANSWERS_IDX2 ON $SCHEMA.ANSWERS ( QUESTION_ID ) $TSIDX;

CREATE OR REPLACE TRIGGER $SCHEMA.ANSWERS_TRG
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

CREATE OR REPLACE TRIGGER $SCHEMA.ENCRYPTED_PAYLOAD_TRG
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

CREATE OR REPLACE TRIGGER $SCHEMA.IQUANTIFY_TRG
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

CREATE OR REPLACE TRIGGER $SCHEMA.RESOURCES_QA_TRG
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

CREATE OR REPLACE TRIGGER $SCHEMA.REVENUE_TRG
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

EOF