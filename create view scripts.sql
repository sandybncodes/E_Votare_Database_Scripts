-- view 1 - case when tip scrutin = 1 (individual)
-- view 2 - case when tip scrutin = 2 (partid)

CREATE VIEW VW_SCRUTINE_CANDIDATI
AS
SELECT C.ID_SCRUTIN, A.ID_CANDIDAT, A.ID_PARTID, A.DATA_ORA_INREGISTRARII, B.NUME, B.PRENUME, B.URL_POZA_CANDIDAT, C.DENUMIRE AS DENUMIRE_SCRUTIN, C.TIP_SCRUTIN, C.DATA_INCEPUT, C.DATA_SFARSIT
FROM SCRUTINE_CANDIDATI A
JOIN CANDIDATI B
ON A.ID_CANDIDAT = B.ID_CANDIDAT
RIGHT JOIN SCRUTINE C
ON A.ID_SCRUTIN = C.ID_SCRUTIN;
GO

CREATE VIEW VW_SCRUTINE_PARTIDE 
AS
SELECT C.ID_SCRUTIN, A.ID_CANDIDAT, A.ID_PARTID, A.DATA_ORA_INREGISTRARII, B.DENUMIRE, B.ABREVIERE, B.URL_LOGO_PARTID, C.DENUMIRE AS DENUMIRE_SCRUTIN, C.TIP_SCRUTIN, C.DATA_INCEPUT, C.DATA_SFARSIT
FROM SCRUTINE_CANDIDATI A
JOIN PARTIDE B
ON A.ID_PARTID = B.ID_PARTID
RIGHT JOIN SCRUTINE C
ON A.ID_SCRUTIN = C.ID_SCRUTIN;
GO

-- ID_SCRUTIN, DENUMIRE, TIP_SCRUTIN, DATA_INCEPUT, DATA_SFARSIT, TOTAL_CANDIDATI, STATUT
CREATE VIEW VW_POLLS_DETAILS
AS 
WITH CTE AS (
	SELECT * FROM VW_SCRUTINE_CANDIDATI
	UNION
	SELECT * FROM VW_SCRUTINE_PARTIDE
)
SELECT DISTINCT ID_SCRUTIN, TIP_SCRUTIN, DENUMIRE_SCRUTIN, DATA_INCEPUT, DATA_SFARSIT, 
COUNT(CASE WHEN ID_CANDIDAT IS NOT NULL THEN ID_CANDIDAT
			WHEN ID_PARTID IS NOT NULL THEN ID_PARTID END) OVER(PARTITION BY ID_SCRUTIN) AS TOTAL_CANDIDATI,
	CASE 
		WHEN GETDATE() >= DATA_SFARSIT THEN 'Finisat'
		WHEN GETDATE() < DATA_INCEPUT THEN 'Urmeaza'
		ELSE 'In proces' END AS STATUT
FROM CTE;
GO


-- view 1 - case when tip scrutin = 1 (individual)
-- view 2 - case when tip scrutin = 2 (partid)

--DROP VIEW VW_VIEW_POLL_RESULTS

CREATE VIEW VW_POLL_RESULTS_PER_INDIVIDUAL
AS
SELECT 
    ID_CONT, 
    A.ID_SCRUTIN, 
    D.DENUMIRE, 
    D.DATA_INCEPUT, 
    A.ID_CANDIDAT, 
    C.URL_POZA_CANDIDAT, 
    C.NUME, 
    C.PRENUME,
    COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN) AS TOTAL_VOTURI,
    COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN, A.ID_CANDIDAT) AS VOTURI_CANDIDAT,
    CAST(CASE 
        WHEN COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN) > 0 THEN 
            CAST(COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN, A.ID_CANDIDAT) AS DECIMAL(10, 2)) * 100.0 / 
            CAST(COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN) AS DECIMAL(10, 2))
        ELSE 0 
    END AS DECIMAL(5, 2)) AS PROCENTAJ_CANDIDAT
FROM SCRUTINE_CANDIDATI A
LEFT JOIN VOTURI B
ON A.ID_SCRUTIN = B.ID_SCRUTIN AND A.ID_CANDIDAT = B.ID_CANDIDAT
JOIN CANDIDATI C
ON A.ID_CANDIDAT = C.ID_CANDIDAT
JOIN SCRUTINE D
ON A.ID_SCRUTIN = D.ID_SCRUTIN;
GO

CREATE VIEW VW_VIEW_POLL_RESULTS_PER_PARTY
AS
SELECT 
    ID_CONT, 
    A.ID_SCRUTIN, 
    D.DENUMIRE AS DENUMIRE_SCRUTIN, 
    D.DATA_INCEPUT, 
    A.ID_PARTID, 
    C.URL_LOGO_PARTID, 
    C.DENUMIRE, 
    C.ABREVIERE,
    COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN) AS TOTAL_VOTURI,
    COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN, A.ID_PARTID) AS VOTURI_CANDIDAT,
    CAST(CASE 
        WHEN COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN) > 0 THEN 
            CAST(COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN, A.ID_PARTID) AS DECIMAL(10, 2)) * 100.0 / 
            CAST(COUNT(ID_CONT) OVER (PARTITION BY A.ID_SCRUTIN) AS DECIMAL(10, 2))
        ELSE 0 
    END AS DECIMAL(5, 2)) AS PROCENTAJ_CANDIDAT
FROM SCRUTINE_CANDIDATI A
LEFT JOIN VOTURI B
ON A.ID_SCRUTIN = B.ID_SCRUTIN AND A.ID_PARTID = B.ID_PARTID
JOIN PARTIDE C
ON A.ID_PARTID = C.ID_PARTID
JOIN SCRUTINE D
ON A.ID_SCRUTIN = D.ID_SCRUTIN;
GO

CREATE VIEW VW_PARTICIPANTS_PARTIES
AS
SELECT A.*, B.DENUMIRE AS DENUMIRE_PARTID, B.ABREVIERE, B.ID_STATUT AS STATUT_PARTID
FROM CANDIDATI A
LEFT JOIN PARTIDE B
ON A.ID_PARTID = B.ID_PARTID;
GO

CREATE VIEW VW_DETALII_PARTIDE
AS
SELECT ID_PARTID, DENUMIRE, ABREVIERE, A.ID_STATUT, B.STATUT, URL_LOGO_PARTID
FROM PARTIDE A
JOIN STATUTURI B
ON A.ID_STATUT = B.ID_STATUT;
GO

CREATE VIEW VW_LOCALITATI_DATA
AS
SELECT * FROM LOCALITATI;
GO