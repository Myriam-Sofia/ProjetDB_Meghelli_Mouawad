CREATE DATABASE mini_projet;
USE mini_projet;

CREATE TABLE Pays (
    nom_pays            VARCHAR(50)    NOT NULL,
    CONSTRAINT pk_pays PRIMARY KEY (nom_pays)
);

CREATE TABLE Variete (
    nom_variete         VARCHAR(50)    NOT NULL,
    CONSTRAINT pk_variete PRIMARY KEY (nom_variete)
);

CREATE TABLE Fournisseur (
    raison_sociale      VARCHAR(100)   NOT NULL,
    CONSTRAINT pk_fournisseur PRIMARY KEY (raison_sociale)
);

CREATE TABLE Machine (
    num_serie_machine   VARCHAR(30)    NOT NULL,
    CONSTRAINT pk_machine PRIMARY KEY (num_serie_machine)
);

CREATE TABLE Employe (
    matricule_employe   VARCHAR(10)    NOT NULL,
    nom_employe         VARCHAR(50),
    poste               VARCHAR(40),
    CONSTRAINT pk_employe PRIMARY KEY (matricule_employe)
);

CREATE TABLE Produit (
    reference           VARCHAR(20)    NOT NULL,
    designation         VARCHAR(100),
    categorie           VARCHAR(30),
    prix_unitaire_ttc   DECIMAL(8,2),
    CONSTRAINT pk_produit PRIMARY KEY (reference)
);

CREATE TABLE Client (
    num_client          INT            NOT NULL,
    nom_client          VARCHAR(50),
    prenom_client       VARCHAR(50),
    email_client        VARCHAR(100),
    CONSTRAINT pk_client PRIMARY KEY (num_client)
);

CREATE TABLE Atelier (
    nom_atelier         VARCHAR(80)    NOT NULL,
    prix_atelier        DECIMAL(6,2),
    CONSTRAINT pk_atelier PRIMARY KEY (nom_atelier)
);

CREATE TABLE Evenement (
    num_evenement       INT            NOT NULL,
    nom_evenement       VARCHAR(100),
    date_evenement      DATE,
    ville_evenement     VARCHAR(60),
    montant_sponsoring  DECIMAL(10,2),
    CONSTRAINT pk_evenement PRIMARY KEY (num_evenement)
);

CREATE TABLE Plantation (
    nom_plantation      VARCHAR(80)    NOT NULL,
    altitude            INT,
    nom_pays            VARCHAR(50)    NOT NULL,
    CONSTRAINT pk_plantation PRIMARY KEY (nom_plantation),
    CONSTRAINT fk_plantation_pays FOREIGN KEY (nom_pays)
        REFERENCES Pays (nom_pays)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Lot (
    num_lot             INT            NOT NULL,
    date_torrefaction   DATE,
    poids_cafe_vert     DECIMAL(7,2),
    profil_torrefaction VARCHAR(20),
    nom_plantation      VARCHAR(80)    NOT NULL,
    nom_variete         VARCHAR(50)    NOT NULL,
    num_serie_machine   VARCHAR(30)    NOT NULL,
    matricule_employe   VARCHAR(10)    NOT NULL,
    CONSTRAINT pk_lot PRIMARY KEY (num_lot),
    CONSTRAINT fk_lot_plantation FOREIGN KEY (nom_plantation)
        REFERENCES Plantation (nom_plantation)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_lot_variete FOREIGN KEY (nom_variete)
        REFERENCES Variete (nom_variete)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_lot_machine FOREIGN KEY (num_serie_machine)
        REFERENCES Machine (num_serie_machine)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_lot_employe FOREIGN KEY (matricule_employe)
        REFERENCES Employe (matricule_employe)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Commande (
    num_commande        INT            NOT NULL,
    date_commande       DATE,
    canal_vente         VARCHAR(20),
    num_client          INT,
    matricule_employe   VARCHAR(10),
    nom_pays            VARCHAR(50),
    CONSTRAINT pk_commande PRIMARY KEY (num_commande),
    CONSTRAINT fk_commande_client FOREIGN KEY (num_client)
        REFERENCES Client (num_client)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_commande_employe FOREIGN KEY (matricule_employe)
        REFERENCES Employe (matricule_employe)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_commande_pays FOREIGN KEY (nom_pays)
        REFERENCES Pays (nom_pays)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Abonnement (
    num_abonnement      INT            NOT NULL,
    formule             VARCHAR(30),
    date_debut          DATE,
    num_client          INT            NOT NULL,
    CONSTRAINT pk_abonnement PRIMARY KEY (num_abonnement),
    CONSTRAINT fk_abonnement_client FOREIGN KEY (num_client)
        REFERENCES Client (num_client)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Session_Atelier (
    num_session         INT            NOT NULL,
    date_heure_session  TIMESTAMP,
    nb_places_max       INT,
    nom_atelier         VARCHAR(80)    NOT NULL,
    matricule_employe   VARCHAR(10)    NOT NULL,
    CONSTRAINT pk_session_atelier PRIMARY KEY (nom_atelier, num_session),
    CONSTRAINT fk_session_atelier FOREIGN KEY (nom_atelier)
        REFERENCES Atelier (nom_atelier)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_session_employe FOREIGN KEY (matricule_employe)
        REFERENCES Employe (matricule_employe)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Container_Personnalise (
    num_container           INT            NOT NULL,
    texte_personnalisation  VARCHAR(100),
    reference               VARCHAR(20)    NOT NULL,
    num_commande            INT            NOT NULL,
    CONSTRAINT pk_container PRIMARY KEY (num_commande, num_container),
    CONSTRAINT fk_container_produit FOREIGN KEY (reference)
        REFERENCES Produit (reference)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_container_commande FOREIGN KEY (num_commande)
        REFERENCES Commande (num_commande)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cultiver (
    nom_plantation      VARCHAR(80)    NOT NULL,
    nom_variete         VARCHAR(50)    NOT NULL,
    CONSTRAINT pk_cultiver PRIMARY KEY (nom_plantation, nom_variete),
    CONSTRAINT fk_cultiver_plantation FOREIGN KEY (nom_plantation)
        REFERENCES Plantation (nom_plantation)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cultiver_variete FOREIGN KEY (nom_variete)
        REFERENCES Variete (nom_variete)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Servir_A (
    num_lot             INT            NOT NULL,
    reference           VARCHAR(20)    NOT NULL,
    CONSTRAINT pk_servir_a PRIMARY KEY (num_lot, reference),
    CONSTRAINT fk_servir_lot FOREIGN KEY (num_lot)
        REFERENCES Lot (num_lot)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_servir_produit FOREIGN KEY (reference)
        REFERENCES Produit (reference)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Fournir (
    raison_sociale      VARCHAR(100)   NOT NULL,
    reference           VARCHAR(20)    NOT NULL,
    CONSTRAINT pk_fournir PRIMARY KEY (raison_sociale, reference),
    CONSTRAINT fk_fournir_fournisseur FOREIGN KEY (raison_sociale)
        REFERENCES Fournisseur (raison_sociale)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fournir_produit FOREIGN KEY (reference)
        REFERENCES Produit (reference)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Composer (
    reference_coffrets   VARCHAR(20)   NOT NULL,
    reference_composants VARCHAR(20)   NOT NULL,
    quantite_composant   INT,
    CONSTRAINT pk_composer PRIMARY KEY (reference_coffrets, reference_composants),
    CONSTRAINT fk_composer_coffret FOREIGN KEY (reference_coffrets)
        REFERENCES Produit (reference)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_composer_composant FOREIGN KEY (reference_composants)
        REFERENCES Produit (reference)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Contenir (
    num_commande        INT            NOT NULL,
    reference           VARCHAR(20)    NOT NULL,
    quantite            INT,
    prix_vente          DECIMAL(8,2),
    CONSTRAINT pk_contenir PRIMARY KEY (num_commande, reference),
    CONSTRAINT fk_contenir_commande FOREIGN KEY (num_commande)
        REFERENCES Commande (num_commande)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_contenir_produit FOREIGN KEY (reference)
        REFERENCES Produit (reference)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Porter_Sur (
    num_abonnement      INT            NOT NULL,
    reference           VARCHAR(20)    NOT NULL,
    CONSTRAINT pk_porter_sur PRIMARY KEY (num_abonnement, reference),
    CONSTRAINT fk_porter_abonnement FOREIGN KEY (num_abonnement)
        REFERENCES Abonnement (num_abonnement)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_porter_produit FOREIGN KEY (reference)
        REFERENCES Produit (reference)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE S_inscrire (
    num_client          INT            NOT NULL,
    nom_atelier         VARCHAR(80)    NOT NULL,
    num_session         INT            NOT NULL,
    CONSTRAINT pk_s_inscrire PRIMARY KEY (num_client, nom_atelier, num_session),
    CONSTRAINT fk_inscrire_client FOREIGN KEY (num_client)
        REFERENCES Client (num_client)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_inscrire_session FOREIGN KEY (nom_atelier, num_session)
        REFERENCES Session_Atelier (nom_atelier, num_session)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Travailler_Sur (
    matricule_employe   VARCHAR(10)    NOT NULL,
    num_evenement       INT            NOT NULL,
    CONSTRAINT pk_travailler_sur PRIMARY KEY (matricule_employe, num_evenement),
    CONSTRAINT fk_travailler_employe FOREIGN KEY (matricule_employe)
        REFERENCES Employe (matricule_employe)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_travailler_evenement FOREIGN KEY (num_evenement)
        REFERENCES Evenement (num_evenement)
        ON DELETE CASCADE ON UPDATE CASCADE
);