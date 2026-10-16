CREATE TABLE consumers (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    consumer_number VARCHAR(20)  NOT NULL,
    first_name      VARCHAR(60)  NOT NULL,
    last_name       VARCHAR(60)  NOT NULL,
    date_of_birth   DATE         NOT NULL,
    ssn_last4       CHAR(4)      NOT NULL,   -- synthetic data only
    created_at      DATETIME(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      DATETIME(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                 ON UPDATE CURRENT_TIMESTAMP(6),
    version         BIGINT       NOT NULL DEFAULT 0,
    CONSTRAINT uk_consumers_number UNIQUE (consumer_number),
    INDEX idx_consumers_match (last_name, date_of_birth)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE accounts (
    id                      BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_number          VARCHAR(20)   NOT NULL,
    consumer_id             BIGINT        NOT NULL,
    account_type            VARCHAR(20)   NOT NULL,
    account_status          VARCHAR(20)   NOT NULL,
    date_opened             DATE          NOT NULL,
    date_closed             DATE          NULL,
    date_first_delinquency  DATE          NULL,
    credit_limit            DECIMAL(12,2) NOT NULL,
    current_balance         DECIMAL(12,2) NOT NULL,
    amount_past_due         DECIMAL(12,2) NOT NULL DEFAULT 0,
    created_at              DATETIME(6)   NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at              DATETIME(6)   NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                          ON UPDATE CURRENT_TIMESTAMP(6),
    version                 BIGINT        NOT NULL DEFAULT 0,
    CONSTRAINT uk_accounts_number UNIQUE (account_number),
    CONSTRAINT fk_accounts_consumer FOREIGN KEY (consumer_id) REFERENCES consumers(id),
    CONSTRAINT ck_accounts_dates CHECK (
        date_closed IS NULL OR date_first_delinquency IS NULL
        OR date_first_delinquency <= date_closed)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE payment_history (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id        BIGINT        NOT NULL,
    reporting_period  DATE          NOT NULL,
    payment_rating    VARCHAR(2)    NOT NULL,
    amount_paid       DECIMAL(12,2) NOT NULL DEFAULT 0,
    reported_balance  DECIMAL(12,2) NOT NULL,
    created_at        DATETIME(6)   NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_history_account FOREIGN KEY (account_id) REFERENCES accounts(id),
    CONSTRAINT uk_history_period UNIQUE (account_id, reporting_period)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;