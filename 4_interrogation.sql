
-- 4_interrogation.sql : Mini-projet BDD - Maison Aravelle (étape 5)
-- Utilisatrice : la responsable commerciale et marketing de Maison Aravelle,
-- qui prépare la campagne de fin d'année (coffrets, abonnements, containers
-- personnalisés, ateliers) et pilote les achats de café vert.

USE mini_projet;

-- Partie A 

-- Liste des catégories de produits distinctes du catalogue.
SELECT DISTINCT categorie
FROM Produit
ORDER BY categorie;

-- Clients ayant une adresse Gmail, triés par nom
SELECT nom_client, prenom_client, email_client
FROM Client
WHERE email_client LIKE '%@gmail.com'
ORDER BY nom_client ASC, prenom_client ASC;

-- Produits dont le prix TTC est compris entre 10 et 30 euros, du moins cher au plus cher.
SELECT reference, designation, categorie, prix_unitaire_ttc
FROM Produit
WHERE prix_unitaire_ttc BETWEEN 10 AND 30
ORDER BY prix_unitaire_ttc ASC;

-- Plantations d'Afrique de l'Est situées à au moins 1700 m d'altitude
SELECT nom_plantation, nom_pays, altitude
FROM Plantation
WHERE nom_pays IN ('Ethiopie', 'Kenya', 'Rwanda')
  AND altitude >= 1700
ORDER BY altitude DESC;

-- Commandes du site web passées sur la période du 1er septembre au 30 novembre 2025
SELECT num_commande, date_commande, num_client, nom_pays
FROM Commande
WHERE canal_vente = 'Site web'
  AND date_commande BETWEEN '2025-09-01' AND '2025-11-30'
ORDER BY date_commande;


-- Partie B 

-- Nombre de commandes par année
SELECT YEAR(date_commande) AS annee, COUNT(*) AS nb_commandes
FROM Commande
GROUP BY YEAR(date_commande)
ORDER BY annee;

-- Produits les plus vendus : quantité totale vendue supérieure à 20 
SELECT reference, SUM(quantite) AS quantite_totale
FROM Contenir
GROUP BY reference
HAVING SUM(quantite) > 20
ORDER BY quantite_totale DESC;

-- Sessions d'ateliers ayant au moins 4 inscrits
SELECT nom_atelier, num_session, COUNT(*) AS nb_inscrits
FROM S_inscrire
GROUP BY nom_atelier, num_session
HAVING COUNT(*) >= 4
ORDER BY nb_inscrits DESC;

-- Chiffre d'affaires et nombre de commandes par canal de vente
SELECT c.canal_vente,
       COUNT(DISTINCT c.num_commande) AS nb_commandes,
       SUM(co.quantite * co.prix_vente) AS chiffre_affaires
FROM Commande c
JOIN Contenir co ON co.num_commande = c.num_commande
GROUP BY c.canal_vente;

-- Prix moyen, minimum et maximum par catégorie de produit
SELECT categorie, COUNT(*) AS nb_produits,
       ROUND(AVG(prix_unitaire_ttc), 2) AS prix_moyen,
       MIN(prix_unitaire_ttc) AS prix_min,
       MAX(prix_unitaire_ttc) AS prix_max
FROM Produit
GROUP BY categorie
ORDER BY prix_moyen DESC;

-- Partie C

-- traçabilité des lots, pour les lots de profil Clair.
SELECT l.num_lot, l.date_torrefaction, l.poids_cafe_vert,
       pl.nom_plantation, pa.nom_pays, l.nom_variete, e.nom_employe AS torrefacteur
FROM Lot l
JOIN Plantation pl ON pl.nom_plantation = l.nom_plantation
JOIN Pays pa       ON pa.nom_pays = pl.nom_pays
JOIN Employe e     ON e.matricule_employe = l.matricule_employe
WHERE l.profil_torrefaction = 'Clair'
ORDER BY l.date_torrefaction;

-- clients n'ayant jamais passé de commande
SELECT cl.num_client, cl.nom_client, cl.prenom_client, cl.email_client
FROM Client cl
LEFT JOIN Commande c ON c.num_client = cl.num_client
WHERE c.num_commande IS NULL;

-- produits jamais vendus
SELECT p.reference, p.designation, p.categorie
FROM Contenir co
RIGHT JOIN Produit p ON p.reference = co.reference
WHERE co.num_commande IS NULL;

-- Composition de chaque coffret
SELECT coffret.designation   AS coffret,
       composant.designation AS composant,
       cp.quantite_composant
FROM Composer cp
JOIN Produit coffret   ON coffret.reference   = cp.reference_coffrets
JOIN Produit composant ON composant.reference = cp.reference_composants
ORDER BY coffret.designation, composant.designation;


-- inscrits aux ateliers avec le nom de l'atelier, la date et le formateur
SELECT cl.nom_client, cl.prenom_client, a.nom_atelier,
       s.date_heure_session, e.nom_employe AS animateur
FROM S_inscrire si
JOIN Client cl          ON cl.num_client = si.num_client
JOIN Session_Atelier s  ON s.nom_atelier = si.nom_atelier
                       AND s.num_session = si.num_session
JOIN Atelier a          ON a.nom_atelier = s.nom_atelier
JOIN Employe e          ON e.matricule_employe = s.matricule_employe
ORDER BY s.date_heure_session, cl.nom_client;

-- Clients inscrits à l'atelier Latte art (requête étudiée dans le README)
SELECT cl.nom_client, cl.prenom_client, s.date_heure_session
FROM Client cl
JOIN S_inscrire si     ON si.num_client = cl.num_client
JOIN Session_Atelier s ON s.nom_atelier = si.nom_atelier
                      AND s.num_session = si.num_session
WHERE s.nom_atelier = 'Latte art';

-- Partie D

-- Clients ayant souscrit au moins un abonnement
SELECT num_client, nom_client, prenom_client
FROM Client
WHERE num_client IN (SELECT num_client FROM Abonnement);

-- Produits qui n'ont jamais été commandés
SELECT reference, designation
FROM Produit
WHERE reference NOT IN (SELECT reference FROM Contenir);

-- Clients n'ayant jamais participé à un atelier (cible pour promouvoir les ateliers).
SELECT cl.num_client, cl.nom_client, cl.prenom_client
FROM Client cl
WHERE NOT EXISTS (SELECT 1
                  FROM S_inscrire si
                  WHERE si.num_client = cl.num_client);

-- Produits plus chers qu'au moins un coffret.
SELECT reference, designation, prix_unitaire_ttc
FROM Produit
WHERE categorie <> 'Coffret'
  AND prix_unitaire_ttc > ANY (SELECT prix_unitaire_ttc
                               FROM Produit
                               WHERE categorie = 'Coffret');
                   
-- Produits dont le prix est supérieur au prix moyen.                   
SELECT reference, designation, prix_unitaire_ttc
FROM Produit
WHERE prix_unitaire_ttc > (SELECT AVG(prix_unitaire_ttc) FROM Produit)
ORDER BY prix_unitaire_ttc DESC;
