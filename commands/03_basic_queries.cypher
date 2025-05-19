MATCH (h:Hashtag {tag: "issoaglobonaomostra"})
MATCH (h)<-[r:POSSUI]-(t:Tweet)
RETURN ru, h, t, r
LIMIT 11



