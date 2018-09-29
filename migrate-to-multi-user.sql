CREATE TABLE membership (id INT AUTO_INCREMENT NOT NULL, last_registration_id INT DEFAULT NULL, main_beneficiary_id INT DEFAULT NULL, member_number INT NOT NULL, withdrawn TINYINT(1) DEFAULT '0', frozen TINYINT(1) DEFAULT '0', frozen_change TINYINT(1) DEFAULT '0', first_shift_date DATE DEFAULT NULL, UNIQUE INDEX UNIQ_86FFD2856986CF73 (last_registration_id), UNIQUE INDEX UNIQ_86FFD28562C6E4EA (main_beneficiary_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
ALTER TABLE membership ADD CONSTRAINT FK_86FFD2856986CF73 FOREIGN KEY (last_registration_id) REFERENCES registration (id);
ALTER TABLE membership ADD CONSTRAINT FK_86FFD28562C6E4EA FOREIGN KEY (main_beneficiary_id) REFERENCES beneficiary (id) ON DELETE SET NULL;

INSERT INTO membership (id, last_registration_id, main_beneficiary_id, member_number, withdrawn, frozen, frozen_change, first_shift_date)
SELECT id, last_registration_id, main_beneficiary_id, member_number, withdrawn, frozen, frozen_change, first_shift_date FROM fos_user;

-- beneficiary / Add membership_id
ALTER TABLE beneficiary ADD membership_id INT DEFAULT NULL;
ALTER TABLE beneficiary ADD CONSTRAINT FK_7ABF446A1FB354CD FOREIGN KEY (membership_id) REFERENCES membership (id) ON DELETE CASCADE;
CREATE INDEX IDX_7ABF446A1FB354CD ON beneficiary (membership_id);
UPDATE beneficiary set membership_id = user_id;

-- fos_user / Replace main_beneficiary_id by beneficiary_id
ALTER TABLE fos_user DROP FOREIGN KEY FK_957A64796986CF73;
ALTER TABLE fos_user ADD beneficiary_id INT DEFAULT NULL;
ALTER TABLE fos_user ADD CONSTRAINT FK_957A6479ECCAAFA0 FOREIGN KEY (beneficiary_id) REFERENCES beneficiary (id) ON DELETE SET NULL;
ALTER TABLE fos_user ADD CONSTRAINT FK_957A64796986CF73 FOREIGN KEY (last_registration_id) REFERENCES registration (id);
CREATE UNIQUE INDEX UNIQ_957A6479ECCAAFA0 ON fos_user (beneficiary_id);
UPDATE fos_user SET beneficiary_id = main_beneficiary_id;

ALTER TABLE fos_user DROP FOREIGN KEY FK_957A647962C6E4EA;
DROP INDEX UNIQ_957A647962C6E4EA ON fos_user;
ALTER TABLE fos_user DROP main_beneficiary_id;

-- Migrate time_logs
ALTER TABLE time_log ADD membership_id INT NOT NULL;
UPDATE time_log SET membership_id = user_id;
ALTER TABLE time_log ADD CONSTRAINT FK_55BE03AF1FB354CD FOREIGN KEY (membership_id) REFERENCES membership (id) ON DELETE CASCADE;
CREATE INDEX IDX_55BE03AF1FB354CD ON time_log (membership_id);


