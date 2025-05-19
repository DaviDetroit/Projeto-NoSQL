// Pegar todas as mensagens originais (label Tweet)
MATCH(t:tweet)

// Coletar todas as mensagens originais
WITH collect (t) as mensagensOriginais

// Achar as hashtags que aparecem em todas as mensagens originais
MATCH h:hashtag
WHERE ALL (m IN mensagensOriginais WHERE (m) -[:POSSUI]->(h))

RETURN h.tag AS hashtag_principal
LIMIT 1
