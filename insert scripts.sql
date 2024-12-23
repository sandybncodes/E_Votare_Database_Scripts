/*
	ID_STATUT INT PRIMARY KEY,
	STATUT VARCHAR(20) UNIQUE CHECK(STATUT IN ('Activ', 'Inactiv', 'Suspendat')) NOT NULL
*/
INSERT INTO STATUTURI
VALUES
(0, 'Inactiv'),
(1, 'Activ'),
(2, 'Suspendat');

INSERT INTO ROLURI_UTILIZATOR
VALUES
(0, 'Administrator'),
(1, 'Utilizator');

SELECT * FROM ROLURI_UTILIZATOR;

INSERT INTO TIP_SCRUTIN 
VALUES 
(1, 'Individual'),
(2, 'Partid');

SELECT * FROM TIP_SCRUTIN;

-- Inserare localitati din Municipiul Chisinau
INSERT INTO LOCALITATI (DENUMIRE, RAION)
VALUES
    ('Chisinau', 'Municipiul Chisinau'),
    ('Codru', 'Municipiul Chisinau'),
    ('Durlesti', 'Municipiul Chisinau'),
    ('Sangera', 'Municipiul Chisinau'),
    ('Vadul lui Voda', 'Municipiul Chisinau'),
    ('Vatra', 'Municipiul Chisinau');

-- Inserare localitati din Raionul Cahul
INSERT INTO LOCALITATI (DENUMIRE, RAION)
VALUES
    ('Cahul', 'Raionul Cahul'),
    ('Crihana Veche', 'Raionul Cahul'),
    ('Vulcanesti', 'Raionul Cahul'),
    ('Slobozia Mare', 'Raionul Cahul'),
    ('Rosu', 'Raionul Cahul');

-- Inserare localitati din Raionul Orhei
INSERT INTO LOCALITATI (DENUMIRE, RAION)
VALUES
    ('Orhei', 'Raionul Orhei'),
    ('Pelivan', 'Raionul Orhei'),
    ('Pohorniceni', 'Raionul Orhei'),
    ('Trebalauti', 'Raionul Orhei'),
    ('Lopatna', 'Raionul Orhei');

-- Inserare localitati din Raionul Soroca
INSERT INTO LOCALITATI (DENUMIRE, RAION)
VALUES
    ('Soroca', 'Raionul Soroca'),
    ('Zastinca', 'Raionul Soroca'),
    ('Egoreni', 'Raionul Soroca'),
    ('Cosauti', 'Raionul Soroca'),
    ('Rublenita', 'Raionul Soroca');

-- Inserare localitati din Municipiul Balti
INSERT INTO LOCALITATI (DENUMIRE, RAION)
VALUES
    ('Balti', 'Municipiul Balti'),
    ('Elizaveta', 'Municipiul Balti'),
    ('Sadovoe', 'Municipiul Balti');

SELECT * FROM LOCALITATI;

/*
	ID_UTILIZATOR INT PRIMARY KEY IDENTITY(1, 1),
	IDNP CHAR(13) UNIQUE CHECK(LEN(IDNP) = 13) NOT NULL,
	NUME VARCHAR(100) NOT NULL,
	PRENUME VARCHAR(100) NOT NULL,
	PATRONIMIC VARCHAR(100),
	DATA_NASTERII DATE NOT NULL,
	EMAIL VARCHAR(100) UNIQUE,
	TELEFON VARCHAR(15) UNIQUE,
	ID_ROL INT NOT NULL,
	ID_STATUT INT NOT NULL,
	CONSTRAINT FK_ID_ROL FOREIGN KEY (ID_ROL) REFERENCES ROLURI_UTILIZATOR(ID_ROL) ON DELETE CASCADE,
	CONSTRAINT FK_ID_STATUT FOREIGN KEY (ID_STATUT) REFERENCES STATUTURI(ID_STATUT) ON DELETE CASCADE
*/
INSERT INTO UTILIZATORI
VALUES
('1111111111111', 'Bolocan', 'Alexandru', NULL, '2002-01-01', 'bolocan.alexandru@gmail.com', '069897456', 0, 1);

SELECT * FROM UTILIZATORI;

/*
	ID_DETALII INT PRIMARY KEY IDENTITY(1, 1),
	ID_UTILIZATOR INT UNIQUE NOT NULL,
	CONSTRAINT FK_ID_UTILIZATOR FOREIGN KEY(ID_UTILIZATOR) REFERENCES UTILIZATORI (ID_UTILIZATOR) ON DELETE CASCADE,
	SERIA_BULETIN CHAR(9) UNIQUE CHECK(LEN(SERIA_BULETIN) = 9) NOT NULL,
	DATA_EMITERII_BULETIN DATE NOT NULL,
	DATA_EXPIRARII_BULETIN DATE NOT NULL,
	ID_LOCALITATE INT NOT NULL,
	CONSTRAINT FK_ID_LOCALITATE FOREIGN KEY (ID_LOCALITATE) REFERENCES LOCALITATI(ID_LOCALITATE),
	ADRESA VARCHAR(100)
*/
INSERT INTO DETALII_UTILIZATOR
VALUES
(3, 'B11111111', '2018-05-15', '2028-09-05', 1, NULL);

SELECT * FROM DETALII_UTILIZATOR;

/*
	CONT_ID INT PRIMARY KEY IDENTITY(1, 1),
	ID_UTILIZATOR INT UNIQUE NOT NULL,
	CONSTRAINT FK_CONT_ID_UTILIZATOR FOREIGN KEY (ID_UTILIZATOR) REFERENCES UTILIZATORI(ID_UTILIZATOR),
	PAROLA VARCHAR(255) NOT NULL
*/
INSERT INTO CONTURI
VALUES
(3, '123');