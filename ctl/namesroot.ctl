--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- namesroot.ctl - SQL*Loader control file for loading name stub data
--
--------------------------------------------------------------------------------

load data
infile 'nameroots'
into table nameroots
fields terminated by ' '
(name_id SEQUENCE(MAX,1), name)
