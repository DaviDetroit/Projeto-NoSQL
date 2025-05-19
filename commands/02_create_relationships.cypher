// Busca todos os arquivos JSON na pasta Import
CALL apoc.load.directory('*.json') YIELD value 
UNWIND value AS arquivo 

// Importa os dados de cada arquivo JSON
WITH arquivo 
CALL apoc.load.json(arquivo) YIELD value 

// Cria os nós de Tweet e define atributos básicos
UNWIND value.data AS tweet
MERGE (t:Tweet {tweet_id: tweet.id}) 
ON CREATE SET  
    t.text = tweet.text,  
    t.created_at = datetime(tweet.created_at), 
    t.conversation_id = tweet.conversation_id 

// Adiciona informações de referências (retweets, citações, respostas)
FOREACH (ref_tweet IN tweet.referenced_tweets | 
    SET t.tipo_ref = coalesce(t.tipo_ref, []) + [ref_tweet.type],  
        t.id_ref = coalesce(t.id_ref, []) + [ref_tweet.id] 
) 

// Cria o nó do usuário que tuitou e faz o relacionamento
MERGE (u:User {user_id: tweet.author_id}) 
MERGE (u)-[:TUITOU]->(t) 

// Cria os nós de Hashtag e faz o relacionamento
WITH t, tweet.entities.hashtags AS hashtags 
UNWIND hashtags AS hashtag 
WITH t, apoc.text.replace(apoc.text.clean(hashtag.tag), '[^a-zA-Z0-9]', '') AS cleanedHashtag 
MERGE (h:Hashtag {tag: cleanedHashtag})
MERGE (t)-[:POSSUI]->(h);
