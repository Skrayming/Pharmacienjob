INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_pharmacien', 'Pharmacien', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_pharmacien', 'Pharmacien', 1);

INSERT INTO `jobs` (`name`, `label`) VALUES
('pharmacien', 'Pharmacien');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('pharmacien', 0, 'novice', 'Recrue', 100, '', ''),
('pharmacien', 1, 'experimente', 'Pharmacien(e)', 100, '', ''),
('pharmacien', 2, 'boss', 'Patron', 100, '', '');