// Pegar todas as mensagens originais (label Tweet)
MATCH (t:Tweet)
// Coletar todas as mensagens originais
WITH collect(t) as mensagens_originais
// Achar as hashtags que aparecem em todas as mensagens originais
MATH(h:hashtag)

WHERE ALL (m IN mensagens_originais WHERE (m)-[:POSSUI]->(h))

RETURN h.tag AS hashtag_principal
LIMIT 1


