-- procedure 1
CREATE PROCEDURE SP_CREATE_NOTIFICATION
	@USER_ID INT,
	@DESCRITPION_ID INT,
	@OLD_VALUE VARCHAR(255),
	@NEW_VALUE VARCHAR(255),
	@NOTIFICATION_DATE DATETIME
AS
INSERT INTO NOTIFICARI (ID_UTILIZATOR, ID_DESCRIERE, VALOAREA_VECHE, VALOAREA_NOUA, DATA_NOTIFICARE)
VALUES
(@USER_ID, @DESCRITPION_ID, @OLD_VALUE, @NEW_VALUE, @NOTIFICATION_DATE);
GO

-- procedure 2
CREATE PROCEDURE SP_GET_UNREAD_NOTIFICATIONS @USER_ID INT
AS
SELECT A.ID_NOTIFICARE, A.ID_UTILIZATOR, B.TITLU, B.DESCRIERE, A.VALOAREA_VECHE, A.VALOAREA_NOUA, A.NOTIFICARE_CITITA, A.DATA_NOTIFICARE
FROM NOTIFICARI A
JOIN DESCRIERE_NOTIFICARI B
ON A.ID_DESCRIERE = B.ID_DESCRIERE
WHERE ID_UTILIZATOR = @USER_ID
ORDER BY A.DATA_NOTIFICARE DESC;

-- prcedure 3
CREATE PROCEDURE SP_MARK_NOTIFICATION_AS_READ @NOTIFICATION_ID INT
AS
UPDATE NOTIFICARI
SET NOTIFICARE_CITITA = 'Y'
WHERE ID_NOTIFICARE = @NOTIFICATION_ID;