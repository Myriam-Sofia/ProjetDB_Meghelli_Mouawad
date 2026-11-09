USE mini_projet;

ALTER TABLE Produit MODIFY designation VARCHAR(100) NOT NULL;
ALTER TABLE Produit MODIFY prix_unitaire_ttc DECIMAL(8,2) NOT NULL;
ALTER TABLE Client MODIFY nom_client VARCHAR(50) NOT NULL;
ALTER TABLE Client MODIFY email_client VARCHAR(100) NOT NULL;
ALTER TABLE Commande MODIFY date_commande DATE NOT NULL;

ALTER TABLE Client ADD CONSTRAINT uq_client_email UNIQUE (email_client);

ALTER TABLE Plantation ADD CONSTRAINT ck_altitude CHECK (altitude >= 0);
ALTER TABLE Lot ADD CONSTRAINT ck_poids CHECK (poids_cafe_vert > 0);
ALTER TABLE Produit ADD CONSTRAINT ck_prix_produit CHECK (prix_unitaire_ttc > 0);
ALTER TABLE Contenir ADD CONSTRAINT ck_quantite CHECK (quantite > 0);
ALTER TABLE Contenir ADD CONSTRAINT ck_prix_vente CHECK (prix_vente > 0);
ALTER TABLE Composer ADD CONSTRAINT ck_quantite_composant CHECK (quantite_composant > 0);
ALTER TABLE Atelier ADD CONSTRAINT ck_prix_atelier CHECK (prix_atelier >= 0);
ALTER TABLE Session_Atelier ADD CONSTRAINT ck_nb_places CHECK (nb_places_max > 0);
ALTER TABLE Evenement ADD CONSTRAINT ck_sponsoring CHECK (montant_sponsoring >= 0);

ALTER TABLE Lot ADD CONSTRAINT ck_profil CHECK (profil_torrefaction IN ('Clair', 'Moyen', 'Fonce'));
ALTER TABLE Commande ADD CONSTRAINT ck_canal CHECK (canal_vente IN ('Boutique', 'Site web'));

ALTER TABLE Client ADD CONSTRAINT ck_email CHECK (email_client LIKE '%@%.%');

ALTER TABLE Commande ALTER COLUMN canal_vente SET DEFAULT 'Boutique';