import sqlite3
import tweepy
import pprint
import json

consumer_key = "lVD25kDaYLhIUE504qPrPSAJe"
consumer_secret = "37k64wJ3aG7ZztDaetmkXZonve3FB8k1PjJH5GBHmRbU6sp0Ao"
access_token = "3881791456-IoU5lA9rzM0F8407k05XtGBzO1QHtCXjp6zW7O1"
access_token_secret= "NUKiGrhIBWbATmQHUBgVXtSwfVimKu4EKjfulOXYGV6FI"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

conn = sqlite3.connect('../data/st2.db')
c = conn.cursor()


def initiate_user_table():
	users = []

	for row in c.execute('SELECT DISTINCT user, parti FROM st ORDER BY parti'):
	    print row
	    ##user = api.get_user(row[0])
	    userInfo = (row[0], row[1])
	    users.append(userInfo)

	pprint.pprint(users)

	c.executemany('INSERT INTO users VALUES (?,?,NULL)', users)

def add_raw_twitter_json_to_users():
	users = []
	for row in c.execute('SELECT * FROM users WHERE profile_image_url IS NULL LIMIT 10'):
		users.append(api.get_user(row[0]))
		print(row[0])

	for user in users:
		c.execute("UPDATE users SET profile_image_url=?, name=?, url=?, description=?, friends_count=?, id=?, statuses_count=? WHERE user=?", (
			user.profile_image_url, 
			user.name, 
			user.url, 
			user.description, 
			user.friends_count, 
			user.user_id, 
			user.statuses_count, 
			user.screen_name))


#initiate_user_table()
add_raw_twitter_json_to_users()

conn.commit()
conn.close()






