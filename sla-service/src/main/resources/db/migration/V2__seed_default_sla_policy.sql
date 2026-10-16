INSERT INTO sla_policies
    (policy_key, standard_days, extended_days, level1_day, level2_day, final_day, final_action)
VALUES
    ('DEFAULT', 30, 45, 15, 22, 28, 'REQUIRE_APPROVAL');