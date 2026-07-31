-- Create the database "Football" if it does not exist
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Football')
  CREATE DATABASE Football
GO

USE Football
GO


---- Drop all existing Football tables, so that we can create them from scratch
IF OBJECT_ID('Leagues_Teams') IS NOT NULL
  DROP TABLE Leagues_Teams
IF OBJECT_ID('TeamMatches') IS NOT NULL
  DROP TABLE TeamMatches
IF OBJECT_ID('InternationalMatches') IS NOT NULL
  DROP TABLE InternationalMatches
IF OBJECT_ID('Teams') IS NOT NULL
  DROP TABLE Teams
IF OBJECT_ID('Leagues') IS NOT NULL
  DROP TABLE Leagues
IF OBJECT_ID('Countries') IS NOT NULL
  DROP TABLE Countries


-- Create tables
CREATE TABLE Countries(
	CountryCode char(2) NOT NULL,
	CountryName nvarchar(50) NOT NULL,
	CurrencyCode varchar(50) NULL,
	Population int NULL,
	AreaSqKm int NULL,
	Capital nvarchar(50) NULL,
 CONSTRAINT PK_Countries PRIMARY KEY (CountryCode))
GO

CREATE TABLE Leagues(
	Id int IDENTITY NOT NULL,
	LeagueName nvarchar(50) NOT NULL,
	CountryCode char(2) NULL,
 CONSTRAINT PK_Leagues PRIMARY KEY (Id))
GO

CREATE TABLE Teams(
	Id int IDENTITY NOT NULL,
	TeamName nvarchar(50) NOT NULL,
	CountryCode char(2) NULL,
 CONSTRAINT PK_Teams PRIMARY KEY (Id))
GO

CREATE TABLE Leagues_Teams(
	LeagueId int NOT NULL,
	TeamId int NOT NULL,
 CONSTRAINT PK_Leagues_Teams PRIMARY KEY (LeagueId,	TeamId))
GO

CREATE TABLE InternationalMatches(
	Id int IDENTITY NOT NULL,
	HomeCountryCode char(2) NOT NULL,
	AwayCountryCode char(2) NOT NULL,
	HomeGoals int NULL,
	AwayGoals int NULL,
	MatchDate datetime NULL,
	LeagueId int NULL,
 CONSTRAINT PK_InternationalMatches PRIMARY KEY (Id))
GO

CREATE TABLE TeamMatches(
	Id int IDENTITY NOT NULL,
	HomeTeamId int NOT NULL,
	AwayTeamId int NOT NULL,
	HomeGoals int NULL,
	AwayGoals int NULL,
	MatchDate datetime NULL,
	LeagueId int NULL,
 CONSTRAINT PK_TeamMatches PRIMARY KEY (Id))
GO


-- Add integrity constraints
ALTER TABLE Leagues WITH CHECK ADD CONSTRAINT
FK_Leagues_Countries FOREIGN KEY(CountryCode)
REFERENCES Countries (CountryCode)
GO

ALTER TABLE Leagues_Teams WITH CHECK ADD CONSTRAINT 
FK_Leagues_Teams_Leagues FOREIGN KEY(LeagueId)
REFERENCES Leagues (Id)
GO

ALTER TABLE Leagues_Teams WITH CHECK ADD CONSTRAINT
FK_Leagues_Teams_Teams FOREIGN KEY(TeamId)
REFERENCES Teams (Id)
GO

ALTER TABLE Teams WITH CHECK ADD CONSTRAINT
FK_Teams_Countries FOREIGN KEY(CountryCode)
REFERENCES Countries (CountryCode)
GO

ALTER TABLE InternationalMatches WITH CHECK ADD CONSTRAINT
FK_InternationalMatches_Countries_HomeCountryCode FOREIGN KEY(HomeCountryCode)
REFERENCES Countries (CountryCode)
GO

ALTER TABLE InternationalMatches WITH CHECK ADD CONSTRAINT
FK_InternationalMatches_Countries_AwayCountryCode FOREIGN KEY(AwayCountryCode)
REFERENCES Countries (CountryCode)
GO

ALTER TABLE TeamMatches WITH CHECK ADD CONSTRAINT
FK_TeamMatches_Teams_HomeTeam FOREIGN KEY(HomeTeamId)
REFERENCES Teams (Id)
GO

ALTER TABLE TeamMatches WITH CHECK ADD CONSTRAINT
FK_TeamMatches_Teams_AwayTeam FOREIGN KEY(AwayTeamId)
REFERENCES Teams (Id)
GO

ALTER TABLE TeamMatches WITH CHECK ADD CONSTRAINT 
FK_TeamMatches_Leagues FOREIGN KEY(LeagueId)
REFERENCES Leagues (Id)
GO

ALTER TABLE InternationalMatches WITH CHECK ADD CONSTRAINT
FK_InternationalMatches_Leagues FOREIGN KEY(LeagueId)
REFERENCES Leagues (Id)
GO


-- Add unique key constraints
CREATE UNIQUE NONCLUSTERED INDEX UK_Country_CountryName ON Countries (CountryName)
GO

CREATE UNIQUE NONCLUSTERED INDEX UK_Leagues_LeagueName ON Leagues (LeagueName)
GO

CREATE NONCLUSTERED INDEX UK_Teams_Name_Country ON Teams (TeamName, CountryCode)
GO


-- Insert the Countries
INSERT Countries (CountryCode, CountryName, CurrencyCode, Population, AreaSqKm, Capital) VALUES (N'AD', N'Andorra', N'EUR', 84000, 468, N'Andorra la Vella'),
 (N'SD', N'Sudan', N'SDG', 35000000, 1861484, N'Khartoum'),
 (N'MX', N'Mexico', N'MXN', 112468855, 1972550, N'Mexico City'),
 (N'PW', N'Palau', N'USD', 19907, 458, N'Melekeok - Palau State Capital'),
 (N'PT', N'Portugal', N'EUR', 10676000, 92391, N'Lisbon'),
 (N'JM', N'Jamaica', N'JMD', 2847232, 10991, N'Kingston'),
 (N'KI', N'Kiribati', N'AUD', 92533, 811, N'Tarawa'),
 (N'NR', N'Nauru', N'AUD', 10065, 21, N''),
 (N'RO', N'Romania', N'RON', 21959278, 237500, N'Bucharest'),
 (N'SM', N'San Marino', N'EUR', 31477, 61, N'San Marino'),
 (N'MT', N'Malta', N'EUR', 403000, 316, N'Valletta'),
 (N'KZ', N'Kazakhstan', N'KZT', 15340000, 2717300, N'Astana'),
 (N'BV', N'Bouvet Island', N'NOK', 0, 49, N''),
 (N'TL', N'East Timor', N'USD', 1154625, 15007, N'Dili'),
 (N'VG', N'British Virgin Islands', N'USD', 21730, 153, N'Road Town'),
 (N'TG', N'Togo', N'XOF', 6587239, 56785, N'Lomé'),
 (N'GM', N'Gambia', N'GMD', 1593256, 11300, N'Banjul'),
 (N'SI', N'Slovenia', N'EUR', 2007000, 20273, N'Ljubljana'),
 (N'LU', N'Luxembourg', N'EUR', 497538, 2586, N'Luxembourg'),
 (N'GH', N'Ghana', N'GHS', 24339838, 239460, N'Accra'),
 (N'IQ', N'Iraq', N'IQD', 29671605, 437072, N'Baghdad'),
 (N'PH', N'Philippines', N'PHP', 99900177, 300000, N'Manila'),
 (N'MU', N'Mauritius', N'MUR', 1294104, 2040, N'Port Louis'),
 (N'AE', N'United Arab Emirates', N'AED', 4975593, 82880, N'Abu Dhabi'),
 (N'CN', N'China', N'CNY', 1330044000, 9596960, N'Beijing'),
 (N'CI', N'Ivory Coast', N'XOF', 21058798, 322460, N'Yamoussoukro'),
 (N'TV', N'Tuvalu', N'AUD', 10472, 26, N'Funafuti'),
 (N'BW', N'Botswana', N'BWP', 2029307, 600370, N'Gaborone'),
 (N'DJ', N'Djibouti', N'DJF', 740528, 23000, N'Djibouti'),
 (N'MW', N'Malawi', N'MWK', 15447500, 118480, N'Lilongwe'),
 (N'CW', N'Curacao', N'ANG', 141766, 444, N'Willemstad'),
 (N'TR', N'Turkey', N'TRY', 77804122, 780580, N'Ankara'),
 (N'YE', N'Yemen', N'YER', 23495361, 527970, N'Sanaa'),
 (N'SS', N'South Sudan', N'SSP', 8260490, 644329, N'Juba'),
 (N'CF', N'Central African Republic', N'XAF', 4844927, 622984, N'Bangui'),
 (N'GW', N'Guinea-Bissau', N'XOF', 1565126, 36120, N'Bissau'),
 (N'IE', N'Ireland', N'EUR', 4622917, 70280, N'Dublin'),
 (N'HR', N'Croatia', N'HRK', 4491000, 56542, N'Zagreb'),
 (N'JO', N'Jordan', N'JOD', 6407085, 92300, N'Amman'),
 (N'TZ', N'Tanzania', N'TZS', 41892895, 945087, N'Dodoma'),
 (N'PK', N'Pakistan', N'PKR', 184404791, 803940, N'Islamabad'),
 (N'OM', N'Oman', N'OMR', 2967717, 212460, N'Muscat'),
 (N'DO', N'Dominican Republic', N'DOP', 9823821, 48730, N'Santo Domingo'),
 (N'HT', N'Haiti', N'HTG', 9648924, 27750, N'Port-au-Prince'),
 (N'MA', N'Morocco', N'MAD', 31627428, 446550, N'Rabat'),
 (N'KY', N'Cayman Islands', N'KYD', 44270, 262, N'George Town'),
 (N'TT', N'Trinidad and Tobago', N'TTD', 1228691, 5128, N'Port of Spain'),
 (N'TC', N'Turks and Caicos Islands', N'USD', 20556, 430, N'Cockburn Town'),
 (N'VI', N'U.S. Virgin Islands', N'USD', 108708, 352, N'Charlotte Amalie'),
 (N'PL', N'Poland', N'PLN', 38500000, 312685, N'Warsaw'),
 (N'VN', N'Vietnam', N'VND', 89571130, 329560, N'Hanoi'),
 (N'FM', N'Micronesia', N'USD', 107708, 702, N'Palikir'),
 (N'TK', N'Tokelau', N'NZD', 1466, 10, N''),
 (N'SB', N'Solomon Islands', N'SBD', 559198, 28450, N'Honiara'),
 (N'EC', N'Ecuador', N'USD', 14790608, 283560, N'Quito'),
 (N'SY', N'Syria', N'SYP', 22198110, 185180, N'Damascus'),
 (N'GT', N'Guatemala', N'GTQ', 13550440, 108890, N'Guatemala City'),
 (N'AG', N'Antigua and Barbuda', N'XCD', 86754, 443, N'St. John''s'),
 (N'GQ', N'Equatorial Guinea', N'XAF', 1014999, 28051, N'Malabo'),
 (N'MH', N'Marshall Islands', N'USD', 65859, 181, N'Majuro'),
 (N'KH', N'Cambodia', N'KHR', 14453680, 181040, N'Phnom Penh'),
 (N'MP', N'Northern Mariana Islands', N'USD', 53883, 477, N'Saipan'),
 (N'GR', N'Greece', N'EUR', 11000000, 131940, N'Athens'),
 (N'ZA', N'South Africa', N'ZAR', 49000000, 1219912, N'Pretoria'),
 (N'CM', N'Cameroon', N'XAF', 19294149, 475440, N'Yaoundé'),
 (N'IM', N'Isle of Man', N'GBP', 75049, 572, N'Douglas'),
 (N'SJ', N'Svalbard and Jan Mayen', N'NOK', 2550, 62049, N'Longyearbyen'),
 (N'KG', N'Kyrgyzstan', N'KGS', 5508626, 198500, N'Bishkek'),
 (N'MM', N'Myanmar', N'MMK', 53414374, 678500, N'Nay Pyi Taw'),
 (N'CH', N'Switzerland', N'CHF', 7581000, 41290, N'Berne'),
 (N'BG', N'Bulgaria', N'BGN', 7148785, 110910, N'Sofia'),
 (N'US', N'United States', N'USD', 310232863, 9629091, N'Washington'),
 (N'BF', N'Burkina Faso', N'XOF', 16241811, 274200, N'Ouagadougou'),
 (N'SN', N'Senegal', N'XOF', 12323252, 196190, N'Dakar'),
 (N'EE', N'Estonia', N'EUR', 1291170, 45226, N'Tallinn'),
 (N'LC', N'Saint Lucia', N'XCD', 160922, 616, N'Castries'),
 (N'SX', N'Sint Maarten', N'ANG', 37429, 21, N'Philipsburg'),
 (N'BL', N'Saint Barthélemy', N'EUR', 8450, 21, N'Gustavia'),
 (N'AL', N'Albania', N'ALL', 2986952, 28748, N'Tirana'),
 (N'AX', N'Åland', N'EUR', 26711, 1580, N'Mariehamn'),
 (N'UA', N'Ukraine', N'UAH', 45415596, 603700, N'Kyiv'),
 (N'KW', N'Kuwait', N'KWD', 2789132, 17820, N'Kuwait City'),
 (N'MG', N'Madagascar', N'MGA', 21281844, 587040, N'Antananarivo'),
 (N'SZ', N'Swaziland', N'SZL', 1354051, 17363, N'Mbabane'),
 (N'RS', N'Serbia', N'RSD', 7344847, 88361, N'Belgrade'),
 (N'BM', N'Bermuda', N'BMD', 65365, 53, N'Hamilton'),
 (N'RE', N'Réunion', N'EUR', 776948, 2517, N'Saint-Denis'),
 (N'TW', N'Taiwan', N'TWD', 22894384, 35980, N'Taipei'),
 (N'JE', N'Jersey', N'GBP', 90812, 116, N'Saint Helier'),
 (N'BB', N'Barbados', N'BBD', 285653, 431, N'Bridgetown'),
 (N'HM', N'Heard Island and McDonald Islands', N'AUD', 0, 412, N''),
 (N'UG', N'Uganda', N'UGX', 33398682, 236040, N'Kampala'),
 (N'PG', N'Papua New Guinea', N'PGK', 6064515, 462840, N'Port Moresby'),
 (N'DM', N'Dominica', N'XCD', 72813, 754, N'Roseau'),
 (N'CY', N'Cyprus', N'EUR', 1102677, 9250, N'Nicosia'),
 (N'JP', N'Japan', N'JPY', 127288000, 377835, N'Tokyo'),
 (N'AT', N'Austria', N'EUR', 8205000, 83858, N'Vienna'),
 (N'TF', N'French Southern Territories', N'EUR', 140, 7829, N'Port-aux-Français'),
 (N'TJ', N'Tajikistan', N'TJS', 7487489, 143100, N'Dushanbe'),
 (N'LB', N'Lebanon', N'LBP', 4125247, 10400, N'Beirut'),
 (N'IS', N'Iceland', N'ISK', 308910, 103000, N'Reykjavik'),
 (N'NC', N'New Caledonia', N'XPF', 216494, 19060, N'Noumea'),
 (N'IT', N'Italy', N'EUR'
