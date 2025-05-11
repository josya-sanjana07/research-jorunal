CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- store hashed password
    role VARCHAR(20) CHECK (role IN ('author', 'editor', 'reviewer')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(512) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE submissions (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT NOT NULL,
    abstract TEXT NOT NULL,
    file_url VARCHAR(255) NOT NULL,
    status VARCHAR(30) CHECK (status IN ('under review', 'revision requested', 'published', 'rejected')) NOT NULL,
    plagiarism_score DECIMAL(5, 2),
    feedbacks JSON DEFAULT NULL,
    revisions JSON DEFAULT NULL,
    published_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE reviewers (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    expertise VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    submission_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    review TEXT,
    score DECIMAL(3, 1),
    reviewed_at TIMESTAMP,
    FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES reviewers(id) ON DELETE CASCADE
);
CREATE TABLE published_papers (
    id SERIAL PRIMARY KEY,
    submission_id INT NOT NULL UNIQUE,
    published_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    journal_issue VARCHAR(100),
    FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE
);
CREATE TABLE email_notifications (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    subject VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
select * from users;
select * from user_sessions;
select * from submissions;
select * from reviewers;
select * from assignments;
select * from published_papers;
select * from email_notifications;
