ROLLBACK;

SELECT *
FROM departments;


COMMIT;

--�ٸ� ���̺�� ROW ����

CREATE TABLE sales_reps
AS
SELECT employee_id id, Last_name name, salary, commission_pct
FROM employees;

SELECT *
FROM sales_reps;

--INSERT�� -> ġȯ���� ���

INSERT INTO departments (department_id, department_name, location_id)
VALUES (&department_id, '&department_name', &location);



SELECT *
FROM departments;


--UPDATE ������ Ȱ���� Transaction

UPDATE employees
SET salary=7000;



SELECT *
FROM employees;

ROLLBACK;

UPDATE employees
SET salary = 7000
WHERE employee_id = 104;
--Transaction ����
ROLLBACK;


UPDATE employees
SET salary = salary*1.1
WHERE employee_id = 104;


ROLLBACK;


SELECT *
FROM employees;

--���������� ����� UPDATE

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



--TABLE DELETE & TRUNCATE - ���̺� ������ ����
SELECT *
FROM sales_reps;

DELETE FROM sales_reps;
ROLLBACK;
--TABLE ���� DELETE => �����͸� ����
--TABLE ���� TRUNCATE => �����Ϳ� �����ͺ����ϴ� �������� ����

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

--������ �ִ� ���̺� �̸�(��ȸ������ ���̺�����)
SELECT table_name
FROM user_tables;

--������ �ִ� ��üŸ���� ������
SELECT DISTINCT object_type
FROM user_objects;

--�ش����̺��� ������ �ִ� ��üŸ��
SELECT *
FROM user_catalog;

--TABLE ����
CREATE TABLE DEPT(
dept_no number(2),
dname varchar2(14),
loc varchar2(13),
create_date DATE DEFAULT sysdate);


DESC dept;


INSERT INTO dept(dept_no, dname, loc)
VALUES (1, '��ġ', '����');

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




--Colunm�߰�
ALTER TABLE dept30
ADD               (job VARCHAR2(20));

DESC dept30;

ALTER TABLE dept30
MODIFY      (job NUMBER);

INSERT INTO dept30
VALUES (1, '��ġ', 2000, SYSDATE, 123);

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


--RENAME �̸� �ٲٴ°�
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

--�⺻Ű(PK) �⺻�� ���� �����ϴ� ���̺� ����
DROP TABLE board;

CREATE TABLE dept(
                    deptno NUMBER(2) PRIMARY KEY, ---�⺻Ű
                    dname VARCHAR2(14),
                    loc VARCHAR2(13),
                    create_date DATE DEFAULT SYSDATE --�⺻���� ������ ��(Column)
                    );
                    
INSERT INTO dept(deptno, dname)
VALUES(10, '��ȹ��'); --�⺻���� ������ ��(Column)�� �����Ͱ� �ڵ��Է�

INSERT INTO dept
VALUES (20, '������', '����', '20/02/15');

COMMIT;

SELECT*
FROM dept;

--�������� ���������� �����ϴ� ���̺� ����
DROP TABLE emp;

CREATE TABLE emp(
empno NUMBER(6) PRIMARY KEY,
ename VARCHAR2(25) NOT NULL,
email VARCHAR2(50) CONSTRAINT emp_mail_nn NOT NULL --NOT NULL ���� ���� + ���� ���� �̸� �ο�
                   CONSTRAINT emp_mail_uk UNIQUE, --UNIQUE ���� ����+ �������� �̸� �ο�
phone_no CHAR(11) NOT NULL,
job VARCHAR2(20),
salary NUMBER(8) CHECK(salary>2000), --CHECK ���� ����, 2000���� ū �����Ͱ� ���;� �Է°���
deptno NUMBER(4) REFERENCES dept(deptno)); -- FOREIGN KEY ���� ����, dept talbe���� deptno��� Column�� �����ؼ� ������ �Է�


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


--�������� ���� ��ųʸ� ���� ����
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
--DML�� �����ϸ� �������� �׽�Ʈ�ϱ�
INSERT INTO emp
VALUES(null, '��ġ', 'ddoChikim@naver.com', '01023456789', 'ȸ���', 3500, null);

INSERT INTO emp
VALUES(1234, '�Ǳ�ġ', 'ddoChikim@naver.com', '01022256789', 'ȸ���', 3500, null);

INSERT INTO emp
VALUES(1234, '��', 'heeeedong@naver.com', '01023451111', 'null', 2900,20);
INSERT INTO emp
VALUES(1233, '��ġ', 'ddoChikim@naver.com', '01023456789', '�����', 3500, null);

SELECT *
FROM emp;


INSERT INTO emp
VALUES(1233, '��', 'ddkim@naver.com', '01023451111', 'null', 7800, 20);



--UPDATE 
UPDATE emp
SET deptno=10
WHERE empno=1234;


ALTER TABLE emp
ADD CONSTRAINT emp_job_uk UNIQUE(job);



INSERT INTO emp
VALUES(1200, '�浿', 'gildong@naver.com', '01023452341', 'ȸ���', 5000, 20);

ALTER TABLE emp
MODIFY (salary number NOT NULL);



ALTER TABLE emp
DROP CONSTRAINT emp_job_uk;

INSERT INTO emp
VALUES(1200, '�浿', 'gildong@naver.com', '01023452341', 'ȸ���', 5000, 20);


SELECT *
FROM emp;








--��� �� ����... ������ ���� ....
--��� �� ���찡 ���� ...�к��� �����
--
--1)������ ����
---> ���Թ�ȣ, ���Ը�, �ּ�, ����ó, ����
--1-1)��,���Թ�ȣ�� �ִ� 5��
--1-2)���� �� �ִ� 10����
--1-3)�ּ� �ִ� 50����
--1-5)����ó �ִ� 13����
--1-5) ���� 6�ڸ�, 1000�� �̻� �Է�
--
--2)��ǰ�� ����
--->��ǰ ��ȣ, ��ǰ ��, ����, �������, ���� ��ȣ
--��, ��ǰ��ȣ�� �ߺ��� �ȵǾ����� �Ѵ�.
--2-1) ��ǰ ��ȣ�� 4�ڸ�
--2-2) ��ǰ �� 10����
--2-3) ���� 5�ڸ�, 100�� �̻� �Է�
--2-4) ���� ��� F(�õ�), C(����) �ΰ��� �����͸� �ް�ʹ�.