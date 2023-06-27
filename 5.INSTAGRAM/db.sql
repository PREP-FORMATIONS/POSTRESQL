CREATE TABLE IF NOT EXISTS users (
	id SERIAL PRIMARY KEY,
	username VARCHAR(30) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	bio VARCHAR(400),
	avatar VARCHAR(200),
	phone VARCHAR(25),
	email VARCHAR(40),
	password VARCHAR(50),
	CONSTRAINT contact_info_provided CHECK(
		COALESCE(phone, email) IS NOT NULL AND
		(phone IS NULL OR phone <> '') AND
		(email IS NULL OR email <> '')
	)
);

CREATE TABLE IF NOT EXISTS posts (
	id SERIAL PRIMARY KEY,
	url VARCHAR(200) NOT NULL,
	caption VARCHAR(240),
	lat REAL CHECK(lat >= -90 AND lat <= 90), 
	lng REAL CHECK(lng >= -180 AND lng <= 180),
	CONSTRAINT lat_lng_provided CHECK((lat IS NULL AND lng IS NULL) OR (lat IS NOT NULL AND lng IS NOT NULL)),
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	contents VARCHAR(240) NOT NULL,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE
);


CREATE TABLE likes (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
	comment_id INTEGER REFERENCES comments(id) ON DELETE CASCADE,
	CHECK(
		COALESCE((post_id)::BOOLEAN::INTEGER, 0)
		+
		COALESCE((comment_id)::BOOLEAN::INTEGER, 0)
		= 1
	),
	UNIQUE(user_id, post_id, comment_id)
);


