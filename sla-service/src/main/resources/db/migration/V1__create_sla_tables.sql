CREATE TABLE sla_clocks (
    id                       BIGINT AUTO_INCREMENT PRIMARY KEY,
    dispute_id               BIGINT       NOT NULL,   -- points to dispute-service, NO foreign key
    ingestion_timestamp      DATETIME(6)  NOT NULL,
    regulatory_due_date      DATETIME(6)  NOT NULL,
    extended                 TINYINT(1)   NOT NULL DEFAULT 0,
    extended_at              DATETIME(6)  NULL,
    state                    VARCHAR(20)  NOT NULL,   -- RUNNING, RESOLVED, BREACHED
    current_escalation_level TINYINT      NOT NULL DEFAULT 0,
    resolved_at              DATETIME(6)  NULL,
    created_at               DATETIME(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at               DATETIME(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                          ON UPDATE CURRENT_TIMESTAMP(6),
    version                  BIGINT       NOT NULL DEFAULT 0,
    CONSTRAINT uk_sla_dispute UNIQUE (dispute_id),
    INDEX idx_sla_state_due (state, regulatory_due_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE sla_escalations (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    clock_id         BIGINT       NOT NULL,
    level            TINYINT      NOT NULL,
    triggered_at     DATETIME(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    notify_status    VARCHAR(20)  NOT NULL DEFAULT 'PENDING',  -- PENDING, SENT, FAILED
    acknowledged_by  VARCHAR(100) NULL,
    acknowledged_at  DATETIME(6)  NULL,
    CONSTRAINT fk_escalations_clock FOREIGN KEY (clock_id) REFERENCES sla_clocks(id),
    CONSTRAINT uk_escalation_level UNIQUE (clock_id, level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE sla_policies (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    policy_key        VARCHAR(40)  NOT NULL,
    standard_days     SMALLINT     NOT NULL,
    extended_days     SMALLINT     NOT NULL,
    level1_day        SMALLINT     NOT NULL,
    level2_day        SMALLINT     NOT NULL,
    final_day         SMALLINT     NOT NULL,
    final_action      VARCHAR(30)  NOT NULL,  -- ESCALATE_ONLY, REQUIRE_APPROVAL, AUTO_ACTION
    active            TINYINT(1)   NOT NULL DEFAULT 1,
    created_at        DATETIME(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT uk_policy_key UNIQUE (policy_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;