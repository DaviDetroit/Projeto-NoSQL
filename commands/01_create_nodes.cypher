// Importação e criação dos nós Tweet
CALL apoc.load.json("tweets_coletados_400.json") YIELD value
UNWIND value.data AS tweet

MERGE (t:Tweet {tweet_id: tweet.id})
ON CREATE SET  
  t.text = tweet.text,  
  t.created_at = datetime(tweet.created_at), 
  t.conversation_id = tweet.conversation_id

FOREACH (ref_tweet IN tweet.referenced_tweets | 
  SET t.tipo_ref = coalesce(t.tipo_ref, []) + [ref_tweet.type],  
      t.id_ref = coalesce(t.id_ref, []) + [ref_tweet.id]
)

// Criação do nó User
MERGE (u:User {user_id: tweet.author_id})

// Criação do nó Hashtag
WITH t, tweet, tweet.entities.hashtags AS hashtags
UNWIND hashtags AS hashtag
WITH t, tweet, apoc.text.replace(apoc.text.clean(hashtag.tag), '[^a-zA-Z0-9]', '') AS cleanedHashtag 
MERGE (h:Hashtag {tag: cleanedHashtag})