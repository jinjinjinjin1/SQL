ROLLBACK;

SELECT *
FROM departments;


COMMIT;

--다른 테이블로 ROW 복사

CREATE TABLE sales_reps
AS
SELECT employee_id id, Last_name name, salary, commission_pct
FROM employees;

SELECT *
FROM sales_reps;

--INSERT문 -> 치환변수 사용

INSERT INTO departments (department_id, department_name, location_id)
VALUES (&department_id, '&department_name', &location);



SELECT *
FROM departments;


--UPDATE 문장을 활용한 Transaction

UPDATE employees
SET salary=7000;



SELECT *
FROM employees;

ROLLBACK;

UPDATE employees
SET salary = 7000
WHERE employee_id = 104;
--Transaction 종료
ROLLBACK;


UPDATE employees
SET salary = salary*1.1
WHERE employee_id = 104;


ROLLBACK;


SELECT *
FROM employees;

--서브쿼리를 사용한 UPDATE

UPDATE employees
SET job_id = (
              SELECT job_id
              FROM employees
              WHERE employee_id = 205),
    salary = ( 
               SELECT salary
               FROM employees
               WHERE employee_id = 205)
WHERE employee_id =124;



UPDATE employees
SET department_id =
                    (
                    SELECT department_id
                    FROM departments
                    where DEPARTMENT_NAME LIKE '%pPublic%')
WHERE employee_id = 206;

SELECT * FROM employees;
SELECT * FROM departments;


ROLLBACK;


--DELETE
DELETE FROM departments
WHERE department_name = 'Finance';

DELETE FROM employees
WHERE department_id = 
                     (
                     SELECT department_id
                     FROM departments
                     WHERE department_name LIKE '%Public%');
                     
ROLLBACK;

SELECT *
FROM employees;



--TABLE DELETE & TRUNCATE - 테이블 데이터 삭제
SELECT *
FROM sales_reps;

DELETE FROM sales_reps;
ROLLBACK;
--TABLE 에서 DELETE => 데이터만 삭제
--TABLE 에서 TRUNCATE => 데이터와 데이터보관하는 공간까지 삭제

TRUNCATE TABLE sales_reps;
ROLLBACK;

INSERT INTO sales_reps
SELECT employee_id, last_name, salary, commission_pct
FROM employees
where job_id LIKE '%REP%';

SELECT *
FROM sales_reps;

COMMIT;


DELETE FROM sales_reps
where ID =174;

SAVEPOINT sp1;

DELETE FROM sales_reps
WHERE id=202;

ROLLBACK to sp1;

ROLLBACK;


SELECT * FROM employees;

--가지고 있는 테이블 이름(조회가능한 테이블종류)
SELECT table_name
FROM user_tables;

--가지고 있는 객체타입을 보여줌
SELECT DISTINCT object_type
FROM user_objects;

--해당테이블이 가지고 있는 객체타입
SELECT *
FROM user_catalog;

--TABLE 생성
CREATE TABLE DEPT(
dept_no number(2),
dname varchar2(14),
loc varchar2(13),
create_date DATE DEFAULT sysdate);


DESC dept;


INSERT INTO dept(dept_no, dname, loc)
VALUES (1, '또치', '예담');

SELECT *
FROM dept;


CREATE TABLE dept30
AS 
    SELECT employee_id, last_name, salary*12 AS "salary", hire_date
    FROM employees
    WHERE department_id = 50;
    
SELECT * FROM dept30;

DESC employees;

DESC dept30;

DROP TABLE dept;
DROP TABLE dept30;




--Colunm추가
ALTER TABLE dept30
ADD               (job VARCHAR2(20));

DESC dept30;

ALTER TABLE dept30
MODIFY      (job NUMBER);

INSERT INTO dept30
VALUES (1, '또치', 2000, SYSDATE, 123);

ALTER TABLE dept30
MODIFY               (job VARCHAR2(40));

DELETE FROM dept30
WHERE employee_id =1;


--
ALTER TABLE dept30
DROP COLUMN job;

DESC dept30;
SELECT *
FROM dept30;

ALTER TABLE dept100
SET UNUSED (hire_Date);


SELECT *
FROM dept30;

ALTER TABLE dept30
DROP UNUSED COLUMNS ;


--RENAME 이름 바꾸는거
RENAME dept30 TO dept100;

SELECT *
FROM dept30;

SELECT *
FROM dept100;


COMMENT ON TABLE dept100
IS 'THIS IS DEPT100';

SELECT *
FROM all_tab_comments
WHERE LOWER(table_name) = 'dept100';

COMMENT ON COLUMN dept100.employee_id
IS 'THIS IS EMPLOYEE_ID';

SELECT * FROM dept100;

TRUNCATE TABLE dept100;

SELECT * FROM dept100;
ROLLBACK;

SELECT * FROM dept100;

DROP TABLE dept100;

SELECT *
FROM employees;

--기본키(PK) 기본값 열을 포함하는 테이블 생성
DROP TABLE board;

CREATE TABLE dept(
                    deptno NUMBER(2) PRIMARY KEY, ---기본키
                    dname VARCHAR2(14),
                    loc VARCHAR2(13),
                    create_date DATE DEFAULT SYSDATE --기본값을 가지는 열(Column)
                    );
                    
INSERT INTO dept(deptno, dname)
VALUES(10, '기획부'); --기본값을 가지는 열(Column)에 데이터가 자동입력

INSERT INTO dept
VALUES (20, '영업부', '서울', '20/02/15');

COMMIT;

SELECT*
FROM dept;

--여러가지 제약조건을 포함하는 테이블 생성
DROP TABLE emp;

CREATE TABLE emp(
empno NUMBER(6) PRIMARY KEY,
ename VARCHAR2(25) NOT NULL,
email VARCHAR2(50) CONSTRAINT emp_mail_nn NOT NULL --NOT NULL 제약 조건 + 제약 조건 이름 부여
                   CONSTRAINT emp_mail_uk UNIQUE, --UNIQUE 제약 조건+ 제약조건 이름 부여
phone_no CHAR(11) NOT NULL,
job VARCHAR2(20),
salary NUMBER(8) CHECK(salary>2000), --CHECK 제약 조건, 2000보다 큰 데이터가 들어와야 입력가능
deptno NUMBER(4) REFERENCES dept(deptno)); -- FOREIGN KEY 제약 조건, dept talbe에서 deptno라는 Column을 참조해서 데이터 입력


DROP TABLE emp;


CREATE TABLE emp(
--COLUMN LEVEL COMSTRAINT
empno NUMBER(6), 
ename VARCHAR2(25) CONSTRAINT emp_ename_nn NOT NULL,
email VARCHAR2(50) CONSTRAINT emp_email_nn NOT NULL,
phone_no CHAR(11) ,
job VARCHAR2(20),
salary NUMBER(8),
deptno NUMBER(4),
--TABLE LEVEL CONSTRAINT
CONSTRAINT emp_empno_pk PRIMARY KEY(empno),
CONSTRAINT emp_email_uk UNIQUE(email),
CONSTRAINT emp_salary_ck CHECK(salary>2000),
CONSTRAINT emp_deptno_fk FOREIGN KEY (deptno)
REFERENCES dept(deptno));


--제약조건 관련 딕셔너리 정보 보기
SELECT constraint_name, constraint_type, search_condition
FROM user_constraints
WHERE table_name = 'EMP';

SELECT cc.column_name, c.constraint_name
FROM user_constraints c JOIN user_cons_columns cc
ON (c.constraint_name = cc.constraint_name)
WHERE c.table_name = 'EMP';


SELECT table_name, index_name
FROM user_indexes
WHERE table_name IN ('DEPT', 'EMP');

DESC emp;
--DML을 수행하며 제약조건 테스트하기
INSERT INTO emp
VALUES(null, '또치', 'ddoChikim@naver.com', '01023456789', '회사원', 3500, null);

INSERT INTO emp
VALUES(1234, '또김치', 'ddoChikim@naver.com', '01022256789', '회사원', 3500, null);

INSERT INTO emp
VALUES(1234, '희동', 'heeeedong@naver.com', '01023451111', 'null', 2900,20);
INSERT INTO emp
VALUES(1233, '또치', 'ddoChikim@naver.com', '01023456789', '직장원', 3500, null);

SELECT *
FROM emp;


INSERT INTO emp
VALUES(1233, '희동', 'ddkim@naver.com', '01023451111', 'null', 7800, 20);



--UPDATE 
UPDATE emp
SET deptno=10
WHERE empno=1234;


ALTER TABLE emp
ADD CONSTRAINT emp_job_uk UNIQUE(job);



INSERT INTO emp
VALUES(1200, '길동', 'gildong@naver.com', '01023452341', '회사원', 5000, 20);

ALTER TABLE emp
MODIFY (salary number NOT NULL);



ALTER TABLE emp
DROP CONSTRAINT emp_job_uk;

INSERT INTO emp
VALUES(1200, '길동', 'gildong@naver.com', '01023452341', '회사원', 5000, 20);


SELECT *
FROM emp;








--어느 한 동네... 한적한 마을 ....
--어느 한 수펴가 오픈 ...털보네 사장님
--
--1)슈퍼의 정보
---> 가게번호, 가게명, 주소, 연락처, 매출
--1-1)단,가게번호는 최대 5개
--1-2)가게 명 최대 10글자
--1-3)주소 최대 50글자
--1-5)연락처 최대 13글자
--1-5) 매출 6자리, 1000원 이상 입력
--
--2)상품의 정보
--->상품 번호, 상품 명, 가격, 보관방법, 가게 번호
--단, 상품번호는 중복이 안되었으면 한다.
--2-1) 상품 번호는 4자리
--2-2) 상품 명 10글자
--2-3) 가격 5자리, 100원 이상 입력
--2-4) 보관 방법 F(냉동), C(냉장) 두개의 데이터만 받고싶다.