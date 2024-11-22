drop table EmergencyResponse cascade constraints;
drop table Police cascade constraints;
drop table Doctor cascade constraints;
drop table Concert cascade constraints;
drop table Audience cascade constraints;
drop table Require cascade constraints;
drop table Review cascade constraints;
drop table TPH2 cascade constraints;
drop table TPH1 cascade constraints;
drop table L3 cascade constraints;
drop table L2 cascade constraints;
drop table L1 cascade constraints;
drop table L4 cascade constraints;
drop table SponsorCompany cascade constraints;
drop table Support cascade constraints;
drop table Performer cascade constraints;
drop table Attend_Locate cascade constraints;
drop table AssistantAssist cascade constraints;


CREATE TABLE EmergencyResponse (
  erid NUMBER(4, 0),
  ertype VARCHAR2(50),
  PRIMARY KEY (erid)
);


CREATE TABLE Police (
  erid NUMBER(4, 0),
  PRIMARY KEY (erid),
  FOREIGN KEY (erid) REFERENCES EmergencyResponse(erid)
);

-- SELECT * FROM TPH1
-- WHERE seatnumber=2 AND email=3

-- seatnumber=2, email=3
-- seatnumber=2 AND email=3


CREATE TABLE Doctor (
  erid NUMBER(4, 0),
  PRIMARY KEY (erid),
  FOREIGN KEY (erid) REFERENCES EmergencyResponse(erid)
);


CREATE TABLE Concert (
  cid NUMBER(4, 0),
  starttime DATE,
  endtime DATE,
  title VARCHAR2(50),
  PRIMARY KEY (cid)
);

-- SELECT t.seatnumber
-- FROM TPH1 t, Concert c
-- WHERE t.cid = c.cid
-- AND c.title = :title


CREATE TABLE Audience (
  email VARCHAR2(50),
  audiencename VARCHAR2(50),
  PRIMARY KEY (email)
);


CREATE TABLE Require (
  erid NUMBER(4, 0),
  cid NUMBER(4, 0),
  PRIMARY KEY (erid, cid),
  FOREIGN KEY (erid) REFERENCES EmergencyResponse(erid),
  FOREIGN KEY (cid) REFERENCES Concert(cid)
);


CREATE TABLE Review (
  email VARCHAR2(50),
  cid NUMBER(4, 0),
  rating NUMBER(1, 0),
  PRIMARY KEY (email, cid),
  FOREIGN KEY (email) REFERENCES Audience(email),
  FOREIGN KEY (cid) REFERENCES Concert(cid)
);


CREATE TABLE TPH2 (
  seatlocation VARCHAR2(50),
  price NUMBER(6, 2),
  PRIMARY KEY(seatlocation)
);


CREATE TABLE TPH1 (
  seatnumber NUMBER(4, 0),
  cid NUMBER(4, 0),
  paymentmethod VARCHAR2(50),
  paymentlocation VARCHAR2(50),
  email VARCHAR2(50),
  seatlocation VARCHAR2(50),
  PRIMARY KEY(seatnumber, cid),
  FOREIGN KEY (cid) REFERENCES Concert (cid),
  FOREIGN KEY (seatlocation) REFERENCES TPH2 (seatlocation),
  FOREIGN KEY (email) REFERENCES Audience(email)
);


CREATE TABLE L3 (
  postalcode CHAR(7),
  province VARCHAR2(50),
  PRIMARY KEY(postalcode)
);


CREATE TABLE L2 (
  postalcode CHAR(7),
  city VARCHAR2(50),
  PRIMARY KEY(postalcode),
  FOREIGN KEY(postalcode) REFERENCES L3(postalcode)
);


CREATE TABLE L1 (
  postalcode CHAR(7),
  street VARCHAR2(50),
  buildingnumber NUMBER(5, 0), 
  capacity NUMBER(6, 0),       
  PRIMARY KEY(postalcode, street, buildingnumber),
  FOREIGN KEY(postalcode) REFERENCES L2(postalcode)
);


CREATE TABLE L4 (
  street VARCHAR2(50),
  city VARCHAR2(50),
  province VARCHAR2(50),
  PRIMARY KEY(street, city)
);


CREATE TABLE SponsorCompany (
  scname VARCHAR2(50),
  sctype VARCHAR2(50),
  PRIMARY KEY (scname)
);


CREATE TABLE Support (
  scname VARCHAR2(50),
  cid NUMBER(4, 0),
  budget NUMBER(10, 2),
  PRIMARY KEY (scname, cid),
  FOREIGN KEY (scname) REFERENCES SponsorCompany(scname),
  FOREIGN KEY (cid) REFERENCES Concert(cid)
);


CREATE TABLE Performer (
  pid NUMBER(4, 0),
  pname VARCHAR2(50),
  pphone CHAR(10),
  PRIMARY KEY (pid)
);


CREATE TABLE Attend_Locate (
  cid NUMBER(4, 0),
  pid NUMBER(4, 0),
  postalcode CHAR(7) NOT NULL,
  street VARCHAR2(50) NOT NULL,
  buildingnumber NUMBER(5, 0) NOT NULL,
  PRIMARY KEY (cid, pid),
  FOREIGN KEY (cid) REFERENCES Concert(cid),
  FOREIGN KEY (pid) REFERENCES Performer(pid),
  FOREIGN KEY (postalcode, street, buildingnumber) REFERENCES L1(postalcode, street, buildingnumber)
);


CREATE TABLE AssistantAssist (
  aid NUMBER(4, 0),
  assistantname VARCHAR2(50),
  assistantphone CHAR(10),
  pid NUMBER(4, 0) NOT NULL,
  FOREIGN KEY (pid) REFERENCES Performer(pid)
);




INSERT INTO EmergencyResponse (erid, ertype) VALUES (1000, 'Security');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1001, 'Patrol');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1002, 'SWAT');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1003, 'Traffic Police');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1004, 'K-9 Unit');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1005, 'Paramedic');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1006, 'First Aid');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1007, 'General Practitioner');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1008, 'Emergency Physician');
INSERT INTO EmergencyResponse (erid, ertype) VALUES (1009, 'Pediatrician');


INSERT INTO Police (erid) VALUES (1000);
INSERT INTO Police (erid) VALUES (1001);
INSERT INTO Police (erid) VALUES (1002);
INSERT INTO Police (erid) VALUES (1003);
INSERT INTO Police (erid) VALUES (1004);


INSERT INTO Doctor (erid) VALUES (1005);
INSERT INTO Doctor (erid) VALUES (1006);
INSERT INTO Doctor (erid) VALUES (1007);
INSERT INTO Doctor (erid) VALUES (1008);
INSERT INTO Doctor (erid) VALUES (1009);


INSERT INTO Concert (cid, starttime, endtime, title) VALUES
(0001, TO_DATE('2024-11-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-01 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Rock Night Festival');
INSERT INTO Concert (cid, starttime, endtime, title) VALUES
(0002, TO_DATE('2024-11-05 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-05 22:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Beethoven Late Sonatas');
INSERT INTO Concert (cid, starttime, endtime, title) VALUES
(0003, TO_DATE('2024-11-10 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-10 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Jazz in the Park');
INSERT INTO Concert (cid, starttime, endtime, title) VALUES
(0004, TO_DATE('2024-11-15 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-15 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Hip Pop Evening');
INSERT INTO Concert (cid, starttime, endtime, title) VALUES
(0005, TO_DATE('2024-11-20 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-20 21:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Country Music Night');


INSERT INTO Audience (email, audiencename) VALUES ('zcc2280411284@gmail.com', 'Chengchao Zheng');
INSERT INTO Audience (email, audiencename) VALUES ('winifred.wang2004@gmail.com', 'Ziqing Wang');
INSERT INTO Audience (email, audiencename) VALUES ('owen04@student.ubc.ca', 'Owen Zheng');
INSERT INTO Audience (email, audiencename) VALUES ('john04@gmail.com', 'John Smith');
INSERT INTO Audience (email, audiencename) VALUES ('2280411284@qq.com', 'Moumou Zheng');
INSERT INTO Audience (email, audiencename) VALUES ('5632154064@gmail.com', 'Daniel Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('1873043358@qq.com', 'John Miller');
INSERT INTO Audience (email, audiencename) VALUES ('5090871211@outlook.com', 'Emma Williams');
INSERT INTO Audience (email, audiencename) VALUES ('5044287187@yahoo.com', 'Chris Brown');
INSERT INTO Audience (email, audiencename) VALUES ('1398579933@outlook.com', 'Laura Brown');
INSERT INTO Audience (email, audiencename) VALUES ('2953049446@icloud.com', 'John Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('5248371576@outlook.com', 'David Williams');
INSERT INTO Audience (email, audiencename) VALUES ('8636546121@icloud.com', 'Emma Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('4367300523@icloud.com', 'John Smith');
INSERT INTO Audience (email, audiencename) VALUES ('2455245314@yahoo.com', 'Emma Brown');
INSERT INTO Audience (email, audiencename) VALUES ('3118470378@qq.com', 'David Smith');
INSERT INTO Audience (email, audiencename) VALUES ('1349787176@yahoo.com', 'Katie Miller');
INSERT INTO Audience (email, audiencename) VALUES ('0337175631@gmail.com', 'Emma Williams');
INSERT INTO Audience (email, audiencename) VALUES ('5797769565@qq.com', 'Michael Brown');
INSERT INTO Audience (email, audiencename) VALUES ('3417366002@outlook.com', 'Laura Williams');
INSERT INTO Audience (email, audiencename) VALUES ('1730169836@outlook.com', 'Chris Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('4797679621@gmail.com', 'Sophia Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('5849491920@yahoo.com', 'Laura Williams');
INSERT INTO Audience (email, audiencename) VALUES ('8205678976@qq.com', 'Emma Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('0408318794@outlook.com', 'Daniel Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('5994057977@qq.com', 'Jane Brown');
INSERT INTO Audience (email, audiencename) VALUES ('9231429921@yahoo.com', 'Laura Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('0643563245@icloud.com', 'Sophia Williams');
INSERT INTO Audience (email, audiencename) VALUES ('5848664979@outlook.com', 'Laura Smith');
INSERT INTO Audience (email, audiencename) VALUES ('0000814354@gmail.com', 'Daniel Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('0732610537@outlook.com', 'John Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('1280862269@qq.com', 'Michael Miller');
INSERT INTO Audience (email, audiencename) VALUES ('7374339254@gmail.com', 'Katie Smith');
INSERT INTO Audience (email, audiencename) VALUES ('3397113209@gmail.com', 'David Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('3789988121@qq.com', 'Daniel Davis');
INSERT INTO Audience (email, audiencename) VALUES ('1017576587@outlook.com', 'Daniel Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('5510841985@qq.com', 'Emma Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('3874825822@outlook.com', 'Sophia Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('7453644143@icloud.com', 'John Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('9945118828@icloud.com', 'David Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2601653427@qq.com', 'Jane Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('0449981776@outlook.com', 'John Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('9020403760@gmail.com', 'Sophia Jones');
INSERT INTO Audience (email, audiencename) VALUES ('9183161603@gmail.com', 'Michael Smith');
INSERT INTO Audience (email, audiencename) VALUES ('5662980350@qq.com', 'Sophia Smith');
INSERT INTO Audience (email, audiencename) VALUES ('9815647485@qq.com', 'Sophia Williams');
INSERT INTO Audience (email, audiencename) VALUES ('7442789689@qq.com', 'Chris Jones');
INSERT INTO Audience (email, audiencename) VALUES ('2742022654@yahoo.com', 'Emma Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('6961627669@qq.com', 'David Williams');
INSERT INTO Audience (email, audiencename) VALUES ('7529716171@qq.com', 'Emma Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('0348325250@gmail.com', 'Jane Brown');
INSERT INTO Audience (email, audiencename) VALUES ('6215749054@outlook.com', 'Laura Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('8023895639@icloud.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('9665216988@icloud.com', 'Michael Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('9909426289@qq.com', 'John Miller');
INSERT INTO Audience (email, audiencename) VALUES ('8943504104@outlook.com', 'Sophia Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('5487969474@icloud.com', 'Sophia Brown');
INSERT INTO Audience (email, audiencename) VALUES ('9366231817@gmail.com', 'Katie Jones');
INSERT INTO Audience (email, audiencename) VALUES ('3420217935@gmail.com', 'John Smith');
INSERT INTO Audience (email, audiencename) VALUES ('2362788124@qq.com', 'David Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('0127923056@qq.com', 'Emma Williams');
INSERT INTO Audience (email, audiencename) VALUES ('3527514703@icloud.com', 'Daniel Williams');
INSERT INTO Audience (email, audiencename) VALUES ('7377841798@icloud.com', 'John Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('9508383832@gmail.com', 'Emma Smith');
INSERT INTO Audience (email, audiencename) VALUES ('1777114353@outlook.com', 'Laura Brown');
INSERT INTO Audience (email, audiencename) VALUES ('1786832776@outlook.com', 'David Smith');
INSERT INTO Audience (email, audiencename) VALUES ('2131038877@yahoo.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('2213494204@qq.com', 'Laura Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('6744125585@outlook.com', 'Sophia Miller');
INSERT INTO Audience (email, audiencename) VALUES ('0706825473@icloud.com', 'Michael Miller');
INSERT INTO Audience (email, audiencename) VALUES ('4963498216@icloud.com', 'Laura Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('4191194115@yahoo.com', 'Jane Davis');
INSERT INTO Audience (email, audiencename) VALUES ('3647058539@yahoo.com', 'Emma Brown');
INSERT INTO Audience (email, audiencename) VALUES ('5762916541@gmail.com', 'Jane Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('2739376803@gmail.com', 'Katie Brown');
INSERT INTO Audience (email, audiencename) VALUES ('2764093928@gmail.com', 'Chris Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('3863726716@outlook.com', 'Michael Brown');
INSERT INTO Audience (email, audiencename) VALUES ('5395847208@outlook.com', 'Chris Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('3652969106@yahoo.com', 'Emma Smith');
INSERT INTO Audience (email, audiencename) VALUES ('0044172188@icloud.com', 'Jane Brown');
INSERT INTO Audience (email, audiencename) VALUES ('7521045395@qq.com', 'Katie Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('1417856305@outlook.com', 'Chris Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('0637770238@icloud.com', 'Daniel Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('8056279988@icloud.com', 'Emma Davis');
INSERT INTO Audience (email, audiencename) VALUES ('1637457336@yahoo.com', 'John Miller');
INSERT INTO Audience (email, audiencename) VALUES ('9497192282@gmail.com', 'Emma Brown');
INSERT INTO Audience (email, audiencename) VALUES ('0429311406@outlook.com', 'Sophia Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('2276518643@outlook.com', 'Emma Miller');
INSERT INTO Audience (email, audiencename) VALUES ('4995335295@outlook.com', 'Katie Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('3035780004@gmail.com', 'Michael Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('4847050373@icloud.com', 'Laura Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('3929035504@outlook.com', 'Katie Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('4480944505@outlook.com', 'Chris Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('8612528309@icloud.com', 'Jane Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('3073317310@outlook.com', 'Daniel Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2467038195@outlook.com', 'Chris Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2893582704@outlook.com', 'Jane Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('0093642005@qq.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('2280547502@icloud.com', 'Michael Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('8527744975@icloud.com', 'Katie Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('3861247532@icloud.com', 'John Brown');
INSERT INTO Audience (email, audiencename) VALUES ('3173018838@yahoo.com', 'Emma Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('5740166086@icloud.com', 'Katie Smith');
INSERT INTO Audience (email, audiencename) VALUES ('2901889056@qq.com', 'Sophia Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('4701168547@yahoo.com', 'John Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('9590753601@icloud.com', 'Emma Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('7344188709@yahoo.com', 'Emma Jones');
INSERT INTO Audience (email, audiencename) VALUES ('4280518020@qq.com', 'Sophia Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('4944339125@qq.com', 'Katie Jones');
INSERT INTO Audience (email, audiencename) VALUES ('1181710943@icloud.com', 'Daniel Miller');
INSERT INTO Audience (email, audiencename) VALUES ('1676032167@icloud.com', 'Katie Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('9268155939@icloud.com', 'Laura Miller');
INSERT INTO Audience (email, audiencename) VALUES ('5546955606@gmail.com', 'David Davis');
INSERT INTO Audience (email, audiencename) VALUES ('1096350222@gmail.com', 'Laura Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('1654023429@gmail.com', 'Jane Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2181262397@gmail.com', 'John Smith');
INSERT INTO Audience (email, audiencename) VALUES ('6804321474@gmail.com', 'John Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('6864929549@icloud.com', 'Daniel Smith');
INSERT INTO Audience (email, audiencename) VALUES ('8409202534@icloud.com', 'Chris Smith');
INSERT INTO Audience (email, audiencename) VALUES ('8229489396@gmail.com', 'Michael Miller');
INSERT INTO Audience (email, audiencename) VALUES ('2297590571@gmail.com', 'Michael Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('2970250304@gmail.com', 'Daniel Williams');
INSERT INTO Audience (email, audiencename) VALUES ('4163844290@yahoo.com', 'John Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('9932731900@outlook.com', 'Daniel Williams');
INSERT INTO Audience (email, audiencename) VALUES ('4631259353@icloud.com', 'Chris Miller');
INSERT INTO Audience (email, audiencename) VALUES ('5146748838@icloud.com', 'Jane Smith');
INSERT INTO Audience (email, audiencename) VALUES ('0762016593@outlook.com', 'Laura Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('7392675057@outlook.com', 'Chris Brown');
INSERT INTO Audience (email, audiencename) VALUES ('6547611278@qq.com', 'Chris Williams');
INSERT INTO Audience (email, audiencename) VALUES ('9224533903@gmail.com', 'Sophia Miller');
INSERT INTO Audience (email, audiencename) VALUES ('7093307688@icloud.com', 'John Brown');
INSERT INTO Audience (email, audiencename) VALUES ('8673881864@icloud.com', 'Jane Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('0826084380@yahoo.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('9055659978@icloud.com', 'Laura Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('8130685886@outlook.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('5431975331@yahoo.com', 'Chris Miller');
INSERT INTO Audience (email, audiencename) VALUES ('3235616274@qq.com', 'Katie Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('2963360864@icloud.com', 'Chris Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('9515095847@yahoo.com', 'Michael Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('4115894474@yahoo.com', 'Katie Davis');
INSERT INTO Audience (email, audiencename) VALUES ('3280277916@qq.com', 'Daniel Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('9859941845@gmail.com', 'Emma Brown');
INSERT INTO Audience (email, audiencename) VALUES ('7799426695@qq.com', 'Daniel Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('5264607216@icloud.com', 'Sophia Brown');
INSERT INTO Audience (email, audiencename) VALUES ('8212916743@gmail.com', 'Katie Brown');
INSERT INTO Audience (email, audiencename) VALUES ('6930015728@gmail.com', 'Daniel Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('7327900612@icloud.com', 'Chris Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2844380014@qq.com', 'David Williams');
INSERT INTO Audience (email, audiencename) VALUES ('3009018241@qq.com', 'Katie Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('0884230753@yahoo.com', 'Michael Smith');
INSERT INTO Audience (email, audiencename) VALUES ('9211062714@qq.com', 'Michael Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('7942028233@outlook.com', 'Laura Davis');
INSERT INTO Audience (email, audiencename) VALUES ('2120528858@outlook.com', 'Michael Williams');
INSERT INTO Audience (email, audiencename) VALUES ('0719574656@icloud.com', 'Daniel Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2186351143@yahoo.com', 'David Davis');
INSERT INTO Audience (email, audiencename) VALUES ('6291705458@outlook.com', 'Daniel Smith');
INSERT INTO Audience (email, audiencename) VALUES ('2703994294@yahoo.com', 'Laura Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('3136584788@outlook.com', 'Laura Smith');
INSERT INTO Audience (email, audiencename) VALUES ('4892146043@yahoo.com', 'Chris Smith');
INSERT INTO Audience (email, audiencename) VALUES ('0694000513@yahoo.com', 'Emma Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('9899185491@gmail.com', 'Chris Williams');
INSERT INTO Audience (email, audiencename) VALUES ('5398075387@qq.com', 'Katie Williams');
INSERT INTO Audience (email, audiencename) VALUES ('4641955368@outlook.com', 'Laura Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('8145794823@gmail.com', 'Emma Jones');
INSERT INTO Audience (email, audiencename) VALUES ('5614946520@yahoo.com', 'John Davis');
INSERT INTO Audience (email, audiencename) VALUES ('6052974085@yahoo.com', 'John Smith');
INSERT INTO Audience (email, audiencename) VALUES ('8104638890@yahoo.com', 'Michael Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('0357572149@gmail.com', 'Michael Williams');
INSERT INTO Audience (email, audiencename) VALUES ('3890313945@yahoo.com', 'Katie Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('7587050199@qq.com', 'Katie Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('3272518309@icloud.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('4479860472@qq.com', 'Emma Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('6897012975@outlook.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('1261584513@qq.com', 'Laura Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('7174224084@qq.com', 'Chris Smith');
INSERT INTO Audience (email, audiencename) VALUES ('4548338549@gmail.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('5837155901@outlook.com', 'Michael Brown');
INSERT INTO Audience (email, audiencename) VALUES ('5264841067@gmail.com', 'Michael Miller');
INSERT INTO Audience (email, audiencename) VALUES ('2949478992@icloud.com', 'Michael Williams');
INSERT INTO Audience (email, audiencename) VALUES ('6867529606@icloud.com', 'Laura Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('4286511919@yahoo.com', 'Sophia Davis');
INSERT INTO Audience (email, audiencename) VALUES ('1785194735@icloud.com', 'Michael Davis');
INSERT INTO Audience (email, audiencename) VALUES ('7359683737@qq.com', 'Laura Brown');
INSERT INTO Audience (email, audiencename) VALUES ('1048785421@yahoo.com', 'Daniel Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('2632880277@outlook.com', 'David Williams');
INSERT INTO Audience (email, audiencename) VALUES ('4743844311@outlook.com', 'Emma Jones');
INSERT INTO Audience (email, audiencename) VALUES ('3796165591@outlook.com', 'John Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('8309797082@outlook.com', 'Emma Miller');
INSERT INTO Audience (email, audiencename) VALUES ('9098821078@yahoo.com', 'John Brown');
INSERT INTO Audience (email, audiencename) VALUES ('3692028943@yahoo.com', 'Jane Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2956940224@gmail.com', 'David Garcia');
INSERT INTO Audience (email, audiencename) VALUES ('8299357886@yahoo.com', 'Laura Jones');
INSERT INTO Audience (email, audiencename) VALUES ('0727376045@qq.com', 'David Hernandez');
INSERT INTO Audience (email, audiencename) VALUES ('7687378851@icloud.com', 'Sophia Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('4015746014@gmail.com', 'Daniel Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('8514936677@icloud.com', 'Katie Brown');
INSERT INTO Audience (email, audiencename) VALUES ('0614761229@gmail.com', 'Michael Williams');
INSERT INTO Audience (email, audiencename) VALUES ('2251340959@qq.com', 'Laura Miller');
INSERT INTO Audience (email, audiencename) VALUES ('5901400083@icloud.com', 'Laura Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('1080690765@yahoo.com', 'Daniel Williams');
INSERT INTO Audience (email, audiencename) VALUES ('4919701923@yahoo.com', 'David Martinez');
INSERT INTO Audience (email, audiencename) VALUES ('9036469077@qq.com', 'David Davis');
INSERT INTO Audience (email, audiencename) VALUES ('7320223180@yahoo.com', 'David Johnson');
INSERT INTO Audience (email, audiencename) VALUES ('3362184019@qq.com', 'David Jones');
INSERT INTO Audience (email, audiencename) VALUES ('2231598724@qq.com', 'Chris Jones');


INSERT INTO Require (erid, cid) VALUES (1000, 0001);
INSERT INTO Require (erid, cid) VALUES (1001, 0001);
INSERT INTO Require (erid, cid) VALUES (1006, 0001);
INSERT INTO Require (erid, cid) VALUES (1006, 0002);
INSERT INTO Require (erid, cid) VALUES (1003, 0003);
INSERT INTO Require (erid, cid) VALUES (1006, 0003);
INSERT INTO Require (erid, cid) VALUES (1007, 0003);
INSERT INTO Require (erid, cid) VALUES (1006, 0005);


INSERT INTO Review (email, cid, rating) VALUES ('zcc2280411284@gmail.com', 0001, 5);
INSERT INTO Review (email, cid, rating) VALUES ('winifred.wang2004@gmail.com', 0002, 2);
INSERT INTO Review (email, cid, rating) VALUES ('owen04@student.ubc.ca', 0001, 4);
INSERT INTO Review (email, cid, rating) VALUES ('john04@gmail.com', 0004, 1);
INSERT INTO Review (email, cid, rating) VALUES ('2280411284@qq.com', 0005, 3);


INSERT INTO TPH2(seatlocation, price) VALUES ('Suite', 1000.00);
INSERT INTO TPH2(seatlocation, price) VALUES ('Courtside', 1000.00);
INSERT INTO TPH2(seatlocation, price) VALUES ('Lower Bowl', 500.00);
INSERT INTO TPH2(seatlocation, price) VALUES ('Middle Bowl', 300.00);
INSERT INTO TPH2(seatlocation, price) VALUES ('Upper Bowl', 100.00);


INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0010, 'Courtside', 'zcc2280411284@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0011, 'Courtside', 'winifred.wang2004@gmail.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0051, 'Suite', 'owen04@student.ubc.ca', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0100, 'Middle Bowl', 'john04@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0180, 'Upper Bowl', '2280411284@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0001, 'Suite', '5632154064@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0002, 'Courtside', '1873043358@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0003, 'Upper Bowl', '5090871211@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0004, 'Lower Bowl', '5044287187@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0005, 'Middle Bowl', '1398579933@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0006, 'Courtside', '2953049446@icloud.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0007, 'Middle Bowl', '5248371576@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0008, 'Lower Bowl', '8636546121@icloud.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0009, 'Courtside', '4367300523@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0010, 'Upper Bowl', '2455245314@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0011, 'Middle Bowl', '3118470378@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0012, 'Middle Bowl', '1349787176@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0013, 'Lower Bowl', '0337175631@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0014, 'Upper Bowl', '5797769565@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0015, 'Lower Bowl', '3417366002@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0016, 'Middle Bowl', '1730169836@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0017, 'Courtside', '4797679621@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0018, 'Upper Bowl', '5849491920@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0019, 'Courtside', '8205678976@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0020, 'Upper Bowl', '0408318794@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0021, 'Upper Bowl', '5994057977@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0022, 'Lower Bowl', '9231429921@yahoo.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0023, 'Middle Bowl', '0643563245@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0024, 'Lower Bowl', '5848664979@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0025, 'Middle Bowl', '0000814354@gmail.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0026, 'Middle Bowl', '0732610537@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0027, 'Upper Bowl', '1280862269@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0028, 'Lower Bowl', '7374339254@gmail.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0029, 'Middle Bowl', '3397113209@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0030, 'Lower Bowl', '3789988121@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0031, 'Middle Bowl', '1017576587@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0032, 'Middle Bowl', '5510841985@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0033, 'Lower Bowl', '3874825822@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0034, 'Courtside', '7453644143@icloud.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0035, 'Lower Bowl', '9945118828@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0036, 'Courtside', '2601653427@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0037, 'Middle Bowl', '0449981776@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0038, 'Suite', '9020403760@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0039, 'Lower Bowl', '9183161603@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0040, 'Lower Bowl', '5662980350@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0041, 'Suite', '9815647485@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0042, 'Middle Bowl', '7442789689@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0043, 'Upper Bowl', '2742022654@yahoo.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0044, 'Middle Bowl', '6961627669@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0045, 'Middle Bowl', '7529716171@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0046, 'Middle Bowl', '0348325250@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0047, 'Middle Bowl', '6215749054@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0048, 'Middle Bowl', '8023895639@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0049, 'Upper Bowl', '9665216988@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0050, 'Middle Bowl', '9909426289@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0051, 'Upper Bowl', '8943504104@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0052, 'Upper Bowl', '5487969474@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0053, 'Lower Bowl', '9366231817@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0054, 'Upper Bowl', '3420217935@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0055, 'Middle Bowl', '2362788124@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0056, 'Middle Bowl', '0127923056@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0057, 'Upper Bowl', '3527514703@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0058, 'Upper Bowl', '7377841798@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0059, 'Suite', '9508383832@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0060, 'Courtside', '1777114353@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0061, 'Courtside', '1786832776@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0062, 'Lower Bowl', '2131038877@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0063, 'Lower Bowl', '2213494204@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0064, 'Lower Bowl', '6744125585@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0065, 'Middle Bowl', '0706825473@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0066, 'Middle Bowl', '4963498216@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0067, 'Lower Bowl', '4191194115@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0068, 'Lower Bowl', '3647058539@yahoo.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0069, 'Lower Bowl', '5762916541@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0070, 'Courtside', '2739376803@gmail.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0071, 'Middle Bowl', '2764093928@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0072, 'Lower Bowl', '3863726716@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0073, 'Lower Bowl', '5395847208@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0074, 'Upper Bowl', '3652969106@yahoo.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0075, 'Suite', '0044172188@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0076, 'Courtside', '7521045395@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0077, 'Middle Bowl', '1417856305@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0078, 'Middle Bowl', '0637770238@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0079, 'Courtside', '8056279988@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0080, 'Middle Bowl', '1637457336@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0081, 'Middle Bowl', '9497192282@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0082, 'Middle Bowl', '0429311406@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0083, 'Upper Bowl', '2276518643@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0084, 'Upper Bowl', '4995335295@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0085, 'Middle Bowl', '3035780004@gmail.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0086, 'Middle Bowl', '4847050373@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0087, 'Lower Bowl', '3929035504@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0088, 'Middle Bowl', '4480944505@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0089, 'Middle Bowl', '8612528309@icloud.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0090, 'Upper Bowl', '3073317310@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0091, 'Middle Bowl', '2467038195@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0092, 'Middle Bowl', '2893582704@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0093, 'Middle Bowl', '0093642005@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0094, 'Upper Bowl', '2280547502@icloud.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0095, 'Upper Bowl', '8527744975@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0248, 'Lower Bowl', '8636546121@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0831, 'Lower Bowl', '2131038877@yahoo.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0764, 'Suite', '2601653427@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0381, 'Suite', '8612528309@icloud.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0379, 'Upper Bowl', '8612528309@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0769, 'Courtside', '7529716171@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0276, 'Middle Bowl', '3929035504@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0455, 'Upper Bowl', '7374339254@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0970, 'Lower Bowl', '1280862269@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0903, 'Upper Bowl', '7442789689@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0735, 'Middle Bowl', '9231429921@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0559, 'Suite', '5090871211@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0569, 'Middle Bowl', '0449981776@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0382, 'Lower Bowl', '7521045395@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0090, 'Suite', '2213494204@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0636, 'Suite', '8612528309@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0591, 'Middle Bowl', '5510841985@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0269, 'Lower Bowl', '8023895639@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0123, 'Middle Bowl', '4995335295@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0841, 'Middle Bowl', '1349787176@yahoo.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0983, 'Suite', '0348325250@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0508, 'Middle Bowl', '2893582704@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0025, 'Middle Bowl', '6215749054@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0996, 'Upper Bowl', '0643563245@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0124, 'Middle Bowl', '9815647485@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0018, 'Middle Bowl', '3397113209@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0526, 'Upper Bowl', '0408318794@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0141, 'Lower Bowl', '4963498216@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0973, 'Lower Bowl', '6744125585@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0909, 'Courtside', '0643563245@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0830, 'Suite', '2280547502@icloud.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0226, 'Upper Bowl', '0732610537@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0310, 'Middle Bowl', '0127923056@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0704, 'Middle Bowl', '9945118828@icloud.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0227, 'Upper Bowl', '3073317310@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0243, 'Upper Bowl', '5762916541@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0346, 'Lower Bowl', '5248371576@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0558, 'Middle Bowl', '2739376803@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0520, 'Upper Bowl', '0637770238@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0621, 'Courtside', '2455245314@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0549, 'Upper Bowl', '3863726716@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0424, 'Courtside', '7453644143@icloud.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0324, 'Lower Bowl', '2893582704@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0050, 'Lower Bowl', '2742022654@yahoo.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0068, 'Courtside', 'john04@gmail.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0949, 'Courtside', '3397113209@gmail.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0241, 'Suite', '2467038195@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0871, 'Suite', '6215749054@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0662, 'Suite', '2131038877@yahoo.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0781, 'Suite', '4480944505@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0526, 'Suite', '2893582704@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0836, 'Courtside', '8023895639@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0027, 'Upper Bowl', '2467038195@outlook.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0658, 'Middle Bowl', '2131038877@yahoo.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0034, 'Lower Bowl', '8636546121@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0638, 'Lower Bowl', '5510841985@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0947, 'Courtside', '9497192282@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0750, 'Middle Bowl', 'zcc2280411284@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0934, 'Courtside', '3035780004@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0756, 'Upper Bowl', '2280547502@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0698, 'Suite', '5994057977@qq.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0562, 'Upper Bowl', '8943504104@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0846, 'Suite', '1017576587@outlook.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0398, 'Courtside', '3118470378@qq.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0356, 'Middle Bowl', '4367300523@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0584, 'Lower Bowl', '0127923056@qq.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0318, 'Lower Bowl', '5510841985@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0531, 'Middle Bowl', '5849491920@yahoo.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0190, 'Courtside', '5762916541@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0205, 'Suite', '1017576587@outlook.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0735, 'Lower Bowl', '0337175631@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0173, 'Middle Bowl', '8943504104@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0281, 'Suite', '3420217935@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0251, 'Suite', '0348325250@gmail.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0636, 'Middle Bowl', '9665216988@icloud.com', 'Credit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0584, 'Middle Bowl', '2742022654@yahoo.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0674, 'Lower Bowl', '7377841798@icloud.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0981, 'Middle Bowl', '3073317310@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0353, 'Courtside', '8636546121@icloud.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0883, 'Suite', '5662980350@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0883, 'Suite', '5662980350@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0883, 'Suite', '5662980350@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0883, 'Suite', '5662980350@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0883, 'Suite', '5662980350@qq.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0981, 'Middle Bowl', '3073317310@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0981, 'Middle Bowl', '3073317310@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0981, 'Middle Bowl', '3073317310@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0981, 'Middle Bowl', '3073317310@outlook.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0735, 'Lower Bowl', '0337175631@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0735, 'Lower Bowl', '0337175631@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0736, 'Lower Bowl', '0337175631@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0735, 'Lower Bowl', '0337175631@gmail.com', 'Debit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0001, 0382, 'Lower Bowl', '7521045395@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0382, 'Lower Bowl', '7521045395@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0382, 'Lower Bowl', '7521045395@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0382, 'Lower Bowl', '7521045395@qq.com', 'Debit', 'Online');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0002, 0999, 'Courtside', 'zcc2280411284@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0003, 0999, 'Courtside', 'zcc2280411284@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0004, 0999, 'Courtside', 'zcc2280411284@gmail.com', 'Credit', 'Offline');
INSERT INTO TPH1 (cid, seatnumber, seatlocation, email, paymentmethod, paymentlocation) VALUES (0005, 0999, 'Courtside', 'zcc2280411284@gmail.com', 'Credit', 'Offline');


INSERT INTO L3(postalcode, province) VALUES ('V6T 1Z3', 'BC');
INSERT INTO L3(postalcode, province) VALUES ('V5K 0A3', 'BC');
INSERT INTO L3(postalcode, province) VALUES ('T5J 0H6', 'AB');
INSERT INTO L3(postalcode, province) VALUES ('H3B 5EB', 'QC');
INSERT INTO L3(postalcode, province) VALUES ('M5J 2X2', 'ON');


INSERT INTO L2(postalcode, city) VALUES ('V6T 1Z3', 'Vancouver');
INSERT INTO L2(postalcode, city) VALUES ('V5K 0A3', 'Vancouver');
INSERT INTO L2(postalcode, city) VALUES ('T5J 0H6', 'Edmonton');
INSERT INTO L2(postalcode, city) VALUES ('H3B 5EB', 'Montreal');
INSERT INTO L2(postalcode, city) VALUES ('M5J 2X2', 'Toronto');


INSERT INTO L1(postalcode, street, buildingnumber, capacity) VALUES ('V6T 1Z3', 'Thunderbird Blvd', 6066, 5054);
INSERT INTO L1(postalcode, street, buildingnumber, capacity) VALUES ('V5K 0A3', 'Griffiths Wy', 800, 19700);
INSERT INTO L1(postalcode, street, buildingnumber, capacity) VALUES ('T5J 0H6', '104 Ave NW', 10220, 20734);
INSERT INTO L1(postalcode, street, buildingnumber, capacity) VALUES ('H3B 5EB', 'Av. des Canadiens-de-Montreal', 1909, 21000);
INSERT INTO L1(postalcode, street, buildingnumber, capacity) VALUES ('M5J 2X2', 'Bay St', 40, 19800);


INSERT INTO L4(street, city, province) VALUES ('Thunderbird Blvd', 'Vancouver', 'BC');
INSERT INTO L4(street, city, province) VALUES ('Griffiths Wy', 'Vancouver', 'BC');
INSERT INTO L4(street, city, province) VALUES ('104 Ave NW', 'Edmonton', 'AB');
INSERT INTO L4(street, city, province) VALUES ('Av. des Canadiens-de-Montreal', 'Montreal', 'QC');
INSERT INTO L4(street, city, province) VALUES ('Bay st', 'Toronto', 'ON');


INSERT INTO SponsorCompany (scname, sctype) VALUES ('Bank of Montreal', 'Finance');
INSERT INTO SponsorCompany (scname, sctype) VALUES ('Canadian Imperial Bank of Commerce', 'Finance');
INSERT INTO SponsorCompany (scname, sctype) VALUES ('Royal Bank of Canada', 'Finance');
INSERT INTO SponsorCompany (scname, sctype) VALUES ('Toronto-Dominion Bank', 'Finance');
INSERT INTO SponsorCompany (scname, sctype) VALUES ('Apple Inc.', 'Technology');
INSERT INTO SponsorCompany (scname, sctype) VALUES ('Microsoft Corporation', 'Technology');
INSERT INTO SponsorCompany (scname, sctype) VALUES ('Tencent', 'Entertainment');


INSERT INTO Support (scname, cid, budget) VALUES ('Bank of Montreal', 0001, 100000.00);
INSERT INTO Support (scname, cid, budget) VALUES ('Royal Bank of Canada', 0002, 200000.00);
INSERT INTO Support (scname, cid, budget) VALUES ('Bank of Montreal', 0003, 300000.00);
INSERT INTO Support (scname, cid, budget) VALUES ('Apple Inc.', 0004, 100000.00);
INSERT INTO Support (scname, cid, budget) VALUES ('Tencent', 0005, 500000.00);


INSERT INTO Performer (pid, pname, pphone) VALUES (0001, 'Dave Grohl', '5847526272');
INSERT INTO Performer (pid, pname, pphone) VALUES (0002, 'Anna Netrebko', '2362516808');
INSERT INTO Performer (pid, pname, pphone) VALUES (0003, 'Gregory Porter', '2046383438');
INSERT INTO Performer (pid, pname, pphone) VALUES (0004, 'Drake', '7429333662');
INSERT INTO Performer (pid, pname, pphone) VALUES (0005, 'Luke Combs', '2264474812');
INSERT INTO Performer (pid, pname, pphone) VALUES (0006, 'Justin Bieber', '3068592277');
INSERT INTO Performer (pid, pname, pphone) VALUES (0007, 'Taylor Swift', '2044825811');


INSERT INTO Attend_Locate(cid, pid, postalcode, street, buildingnumber) VALUES(0001, 0001, 'V6T 1Z3', 'Thunderbird Blvd', 6066);
INSERT INTO Attend_Locate(cid, pid, postalcode, street, buildingnumber) VALUES(0002, 0002, 'V5K 0A3', 'Griffiths Wy', 800);
INSERT INTO Attend_Locate(cid, pid, postalcode, street, buildingnumber) VALUES(0003, 0003, 'T5J 0H6', '104 Ave NW', 10220);
INSERT INTO Attend_Locate(cid, pid, postalcode, street, buildingnumber) VALUES(0004, 0004, 'H3B 5EB', 'Av. des Canadiens-de-Montreal', 1909);
INSERT INTO Attend_Locate(cid, pid, postalcode, street, buildingnumber) VALUES(0005, 0005, 'M5J 2X2', 'Bay St', 40);


INSERT INTO AssistantAssist (aid, assistantname, assistantphone, pid) VALUES (0001, 'David Liny', '2044703073', 0001);
INSERT INTO AssistantAssist (aid, assistantname, assistantphone, pid) VALUES (0002, 'Dior James', '2498033823', 0004);
INSERT INTO AssistantAssist (aid, assistantname, assistantphone, pid) VALUES (0003, 'Marry Potter', '3547795531', 0005);
INSERT INTO AssistantAssist (aid, assistantname, assistantphone, pid) VALUES (0004, 'Anthony Brown', '4033886434', 0006);
INSERT INTO AssistantAssist (aid, assistantname, assistantphone, pid) VALUES (0005, 'Nick Beal', '2634931237', 0007);