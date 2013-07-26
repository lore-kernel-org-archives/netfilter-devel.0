From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] src: remove version from XML and JSON representations
Date: Fri, 26 Jul 2013 16:13:14 +0200
Message-ID: <1374847994-13796-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41527 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab3GZONg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:13:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes the version XML node and the version JSON field
in all our existing objects. The current versioning approach
consists of adding a version field to every object representation
in XML and JSON. While listing my entire rule-set, one can notice
that this approach is too bloated.

Once the library enters stable stage, if we need to obsolete a XML
node and a JSON field, we can follow this procedure:

1) Remove the XML node and the JSON field from the output, so fresh
   outputs will not contain the old ones anymore.

2) Do not remove the parsing of the old XML node and the JSON field
   inmediately. We have to keep supporting the parsing for a while
   to avoid breaking the interpretion of old XML/JSON files. We can
   spot a warning to warn about it, so users generate a fresh
   output again.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c                          |   19 +++----------------
 src/internal.h                       |    9 ---------
 src/rule.c                           |   21 ++++-----------------
 src/set.c                            |   15 +++------------
 src/table.c                          |   33 +++------------------------------
 tests/jsonfiles/01-table.json        |    2 +-
 tests/jsonfiles/02-table.json        |    2 +-
 tests/xmlfiles/01-table.xml          |    2 +-
 tests/xmlfiles/02-table.xml          |    2 +-
 tests/xmlfiles/10-chain.xml          |    2 +-
 tests/xmlfiles/11-chain.xml          |    2 +-
 tests/xmlfiles/12-chain.xml          |    2 +-
 tests/xmlfiles/20-rule-bitwise.xml   |    2 +-
 tests/xmlfiles/21-rule-byteorder.xml |    2 +-
 tests/xmlfiles/22-rule-cmp.xml       |    2 +-
 tests/xmlfiles/23-rule-counter.xml   |    2 +-
 tests/xmlfiles/24-rule-ct.xml        |    2 +-
 tests/xmlfiles/25-rule-exthdr.xml    |    2 +-
 tests/xmlfiles/26-rule-immediate.xml |    2 +-
 tests/xmlfiles/27-rule-limit.xml     |    2 +-
 tests/xmlfiles/28-rule-log.xml       |    2 +-
 tests/xmlfiles/29-rule-lookup.xml    |    2 +-
 tests/xmlfiles/30-rule-match.xml     |    2 +-
 tests/xmlfiles/31-rule-meta.xml      |    2 +-
 tests/xmlfiles/32-rule-nat6.xml      |    2 +-
 tests/xmlfiles/33-rule-nat4.xml      |    2 +-
 tests/xmlfiles/34-rule-payload.xml   |    2 +-
 tests/xmlfiles/35-rule-target.xml    |    2 +-
 tests/xmlfiles/36-rule-real.xml      |    2 +-
 tests/xmlfiles/37-rule-real.xml      |    2 +-
 tests/xmlfiles/38-rule-real.xml      |    2 +-
 tests/xmlfiles/39-rule-real.xml      |    2 +-
 tests/xmlfiles/40-rule-real.xml      |    2 +-
 tests/xmlfiles/41-rule-real.xml      |    2 +-
 tests/xmlfiles/42-rule-real.xml      |    2 +-
 tests/xmlfiles/43-rule-real.xml      |    2 +-
 tests/xmlfiles/44-rule-real.xml      |    2 +-
 tests/xmlfiles/45-rule-real.xml      |    2 +-
 tests/xmlfiles/46-rule-real.xml      |    2 +-
 tests/xmlfiles/47-rule-real.xml      |    2 +-
 tests/xmlfiles/48-rule-real.xml      |    2 +-
 tests/xmlfiles/49-rule-real.xml      |    2 +-
 tests/xmlfiles/50-rule-real.xml      |    2 +-
 tests/xmlfiles/51-rule-real.xml      |    2 +-
 tests/xmlfiles/52-rule-real.xml      |    2 +-
 tests/xmlfiles/53-rule-real.xml      |    2 +-
 tests/xmlfiles/54-rule-real.xml      |    2 +-
 tests/xmlfiles/55-rule-real.xml      |    2 +-
 tests/xmlfiles/56-rule-real.xml      |    2 +-
 tests/xmlfiles/57-rule-real.xml      |    2 +-
 tests/xmlfiles/58-rule-real.xml      |    2 +-
 tests/xmlfiles/59-rule-real.xml      |    2 +-
 tests/xmlfiles/60-rule-real.xml      |    2 +-
 tests/xmlfiles/61-rule-real.xml      |    2 +-
 tests/xmlfiles/62-rule-real.xml      |    2 +-
 tests/xmlfiles/63-rule-real.xml      |    2 +-
 tests/xmlfiles/64-rule-real.xml      |    2 +-
 tests/xmlfiles/65-rule-real.xml      |    2 +-
 tests/xmlfiles/66-rule-real.xml      |    2 +-
 tests/xmlfiles/67-rule-real.xml      |    2 +-
 tests/xmlfiles/68-rule-real.xml      |    2 +-
 tests/xmlfiles/69-rule-real.xml      |    2 +-
 tests/xmlfiles/70-rule-real.xml      |    2 +-
 tests/xmlfiles/71-rule-real.xml      |    2 +-
 tests/xmlfiles/72-rule-real.xml      |    2 +-
 tests/xmlfiles/73-set.xml            |    1 -
 tests/xmlfiles/74-set.xml            |    1 -
 67 files changed, 73 insertions(+), 146 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 1e07044..14db5f7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -475,7 +475,6 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 	mxml_node_t *node = NULL;
 	char *endptr = NULL;
 	uint64_t utmp;
-	int64_t tmp;
 	int family;
 
 	/* NOTE: all XML nodes are mandatory */
@@ -485,17 +484,6 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 	if (tree == NULL)
 		return -1;
 
-	/* Validate version */
-	if (mxmlElementGetAttr(tree, "version") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-	tmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
-	if (tmp == LLONG_MAX || *endptr || tmp != NFT_CHAIN_XML_VERSION) {
-		mxmlDelete(tree);
-		return -1;
-	}
-
 	/* Get and set <chain name="xxx" ... >*/
 	if (mxmlElementGetAttr(tree, "name") == NULL) {
 		mxmlDelete(tree);
@@ -694,13 +682,12 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 			"\"handle\": %"PRIu64","
 			"\"bytes\": %"PRIu64","
 			"\"packets\": %"PRIu64","
-			"\"version\": %d,"
 			"\"properties\": {"
 				"\"family\": \"%s\","
 				"\"table\": \"%s\","
 				"\"use\": %d",
 			c->name, c->handle, c->bytes, c->packets,
-			NFT_CHAIN_JSON_VERSION, nft_family2str(c->family),
+			nft_family2str(c->family),
 			c->table, c->use);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -730,7 +717,7 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 
 	ret = snprintf(buf, size,
 		       "<chain name=\"%s\" handle=\"%"PRIu64"\""
-		       " bytes=\"%"PRIu64"\" packets=\"%"PRIu64"\" version=\"%d\">"
+		       " bytes=\"%"PRIu64"\" packets=\"%"PRIu64"\">"
 		       "<properties>"
 				"<type>%s</type>"
 				"<table>%s</table>"
@@ -738,7 +725,7 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 				"<use>%d</use>"
 				"<hooknum>%s</hooknum>",
 		       c->name, c->handle, c->bytes, c->packets,
-		       NFT_CHAIN_XML_VERSION, c->type, c->table,
+		       c->type, c->table,
 		       c->prio, c->use, hooknum2str_array[c->hooknum]);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/internal.h b/src/internal.h
index 1970c9c..a8ae431 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -47,15 +47,6 @@ const char *nft_jansson_value_parse_str(json_t *root, const char *tag);
 bool nft_jansson_node_exist(json_t *root, const char *tag);
 #endif
 
-#define NFT_TABLE_XML_VERSION 0
-#define NFT_CHAIN_XML_VERSION 0
-#define NFT_RULE_XML_VERSION 0
-#define NFT_SET_XML_VERSION 0
-#define NFT_TABLE_JSON_VERSION 0
-#define NFT_CHAIN_JSON_VERSION 0
-#define NFT_RULE_JSON_VERSION 0
-#define NFT_SET_JSON_VERSION 0
-
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
 int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
diff --git a/src/rule.c b/src/rule.c
index c3cc75a..11737e5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -486,17 +486,6 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	if (tree == NULL)
 		return -1;
 
-	/* validate XML version <rule ... version=X ... > */
-	if (mxmlElementGetAttr(tree, "version") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-	tmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
-	if (tmp == LLONG_MAX || *endptr || tmp != NFT_RULE_XML_VERSION) {
-		mxmlDelete(tree);
-		return -1;
-	}
-
 	/* get and set <rule ... family=X ... > */
 	if (mxmlElementGetAttr(tree, "family") == NULL) {
 		mxmlDelete(tree);
@@ -644,10 +633,9 @@ static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 
 	ret = snprintf(buf, size,
 				"{ \"rule\": { \"family\" : \"%s\", \"table\" : \"%s\", "
-				"\"chain\"  : \"%s\", \"handle\" : %llu, \"version\" : %d, ",
+				"\"chain\"  : \"%s\", \"handle\" : %llu,",
 				nft_family2str(r->family), r->table, r->chain,
-				(unsigned long long)r->handle,
-				NFT_RULE_JSON_VERSION);
+				(unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "\"rule_flags\" : %u, ",
@@ -690,10 +678,9 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 
 	ret = snprintf(buf, size,
 		"<rule family=\"%s\" table=\"%s\" "
-			"chain=\"%s\" handle=\"%llu\" version=\"%d\">",
+			"chain=\"%s\" handle=\"%llu\">",
 				nft_family2str(r->family), r->table, r->chain,
-				(unsigned long long)r->handle,
-				NFT_RULE_XML_VERSION);
+				(unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<rule_flags>%u</rule_flags>",
diff --git a/src/set.c b/src/set.c
index 4b0ec6a..23a2ab1 100644
--- a/src/set.c
+++ b/src/set.c
@@ -311,7 +311,6 @@ static int nft_set_xml_parse(struct nft_set *s, char *xml)
 	struct nft_set_elem *elem;
 	char *name;
 	char *table;
-	int version;
 	int family;
 	char *family_str;
 
@@ -324,13 +323,6 @@ static int nft_set_xml_parse(struct nft_set *s, char *xml)
 	if (strcmp(tree->value.opaque, "set") != 0)
 		goto err;
 
-	if (nft_mxml_num_parse(tree, "set_xml_version", MXML_DESCEND_FIRST,
-			       BASE_DEC, &version, NFT_TYPE_S32) != 0)
-		goto err;
-
-	if (version != NFT_SET_XML_VERSION)
-		goto err;
-
 	name = (char *)nft_mxml_str_parse(tree, "set_name",
 					  MXML_DESCEND_FIRST);
 	if (name == NULL)
@@ -448,10 +440,10 @@ static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 	struct nft_set_elem *elem;
 
 	ret = snprintf(buf, size, "{ \"set\": { \"name\": \"%s\","
-				  "\"table\": \"%s\",\"version\": %d,"
+				  "\"table\": \"%s\","
 				  "\"flags\": %u,\"family\": \"%s\","
 				  "\"key_type\": %u,\"key_len\": %u",
-			s->name, s->table, NFT_SET_JSON_VERSION, s->set_flags,
+			s->name, s->table, s->set_flags,
 			nft_family2str(s->family), s->key_type, s->key_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -529,14 +521,13 @@ static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
 	ret = snprintf(buf, size, "<set><family>%s</family>"
 				  "<set_table>%s</set_table>"
 				  "<set_name>%s</set_name>"
-				  "<set_xml_version>%d</set_xml_version>"
 				  "<set_flags>%u</set_flags>"
 				  "<key_type>%u</key_type>"
 				  "<key_len>%u</key_len>"
 				  "<data_type>%u</data_type>"
 				  "<data_len>%u</data_len>",
 			nft_family2str(s->family), s->table, s->name,
-			NFT_SET_XML_VERSION,  s->set_flags, s->key_type,
+			s->set_flags, s->key_type,
 			s->key_len, s->data_type, s->data_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/table.c b/src/table.c
index 1d17d3b..1f4fe76 100644
--- a/src/table.c
+++ b/src/table.c
@@ -223,8 +223,6 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 #ifdef XML_PARSING
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
-	char *endptr = NULL;
-	int64_t stmp;
 	int family;
 
 	/* NOTE: all XML nodes are mandatory */
@@ -234,18 +232,6 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 	if (tree == NULL)
 		return -1;
 
-	/* Check the version of the XML */
-	if (mxmlElementGetAttr(tree, "version") == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-
-	stmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
-	if (stmp == LLONG_MAX || *endptr || stmp != NFT_TABLE_XML_VERSION) {
-		mxmlDelete(tree);
-		return -1;
-	}
-
 	/* Get and set the name of the table */
 	if (mxmlElementGetAttr(tree, "name") == NULL) {
 		mxmlDelete(tree);
@@ -300,7 +286,6 @@ static int nft_table_json_parse(struct nft_table *t, char *json)
 #ifdef JSON_PARSING
 	json_t *root;
 	json_error_t error;
-	uint64_t version;
 	uint32_t table_flag;
 	const char *str;
 	int family;
@@ -317,15 +302,6 @@ static int nft_table_json_parse(struct nft_table *t, char *json)
 		goto err;
 	}
 
-	if (nft_jansson_value_parse_val(root, "version",
-					NFT_TYPE_U64, &version) == -1)
-		goto err;
-
-	if (version != NFT_TABLE_JSON_VERSION) {
-		errno = EINVAL;
-		goto err;
-	}
-
 	str = nft_jansson_value_parse_str(root, "name");
 	if (str == NULL)
 		goto err;
@@ -392,27 +368,24 @@ static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 	return snprintf(buf, size,
 			"{\"table\" : {"
 			"\"name\" : \"%s\","
-			"\"version\" : %d,"
 			"\"properties\" : {"
 				"\"family\" : \"%s\","
 				"\"table_flags\" : %d"
 				"}"
 			"}"
 			"}" ,
-			t->name, NFT_TABLE_JSON_VERSION,
-			nft_family2str(t->family), t->table_flags);
+			t->name, nft_family2str(t->family), t->table_flags);
 }
 
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 {
-	return snprintf(buf, size, "<table name=\"%s\" version=\"%d\">"
+	return snprintf(buf, size, "<table name=\"%s\">"
 				"<properties>"
 					"<family>%s</family>"
 					"<table_flags>%d</table_flags>"
 				"</properties>"
 				"</table>",
-		       t->name, NFT_TABLE_XML_VERSION,
-		       nft_family2str(t->family), t->table_flags);
+		       t->name, nft_family2str(t->family), t->table_flags);
 }
 
 static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *t)
diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.json
index ec496b9..9afc014 100644
--- a/tests/jsonfiles/01-table.json
+++ b/tests/jsonfiles/01-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter","version" : 0,"properties" : {"family" : "ip","table_flags" : 0}}}
+{"table" : {"name" : "filter","properties" : {"family" : "ip","table_flags" : 0}}}
diff --git a/tests/jsonfiles/02-table.json b/tests/jsonfiles/02-table.json
index 03f4d5a..b66ec52 100644
--- a/tests/jsonfiles/02-table.json
+++ b/tests/jsonfiles/02-table.json
@@ -1 +1 @@
-{"table" : {"name" : "filter2","version" : 0,"properties" : {"family" : "ip6","table_flags" : 0}}}
+{"table" : {"name" : "filter2","properties" : {"family" : "ip6","table_flags" : 0}}}
diff --git a/tests/xmlfiles/01-table.xml b/tests/xmlfiles/01-table.xml
index d1f4692..133041d 100644
--- a/tests/xmlfiles/01-table.xml
+++ b/tests/xmlfiles/01-table.xml
@@ -1,4 +1,4 @@
-<table name="filter" version="0">
+<table name="filter">
 	<properties>
 		<family>ip</family>
 		<table_flags>0</table_flags>
diff --git a/tests/xmlfiles/02-table.xml b/tests/xmlfiles/02-table.xml
index 55e5c2d..0aef342 100644
--- a/tests/xmlfiles/02-table.xml
+++ b/tests/xmlfiles/02-table.xml
@@ -1,4 +1,4 @@
-<table name="nat" version="0">
+<table name="nat">
 	<properties>
 		<family>ip6</family>
 		<table_flags>0</table_flags>
diff --git a/tests/xmlfiles/10-chain.xml b/tests/xmlfiles/10-chain.xml
index 04b050d..4de1020 100644
--- a/tests/xmlfiles/10-chain.xml
+++ b/tests/xmlfiles/10-chain.xml
@@ -1,4 +1,4 @@
-<chain name="test" handle="0" bytes="0" packets="0" version="0">
+<chain name="test" handle="0" bytes="0" packets="0">
 	<properties>
 		<type>filter</type>
 		<table>filter</table>
diff --git a/tests/xmlfiles/11-chain.xml b/tests/xmlfiles/11-chain.xml
index 7baa88f..310aeaa 100644
--- a/tests/xmlfiles/11-chain.xml
+++ b/tests/xmlfiles/11-chain.xml
@@ -1,4 +1,4 @@
-<chain name="test" handle="0" bytes="59" packets="1" version="0">
+<chain name="test" handle="0" bytes="59" packets="1">
 	<properties>
 		<type>filter</type>
 		<table>filter</table>
diff --git a/tests/xmlfiles/12-chain.xml b/tests/xmlfiles/12-chain.xml
index 1480659..20ee2a8 100644
--- a/tests/xmlfiles/12-chain.xml
+++ b/tests/xmlfiles/12-chain.xml
@@ -1,4 +1,4 @@
-<chain name="foo" handle="100" bytes="59264154979" packets="2548796325" version="0">
+<chain name="foo" handle="100" bytes="59264154979" packets="2548796325">
 	<properties>
 		<type>nat</type>
 		<table>nat</table>
diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index a61f4fb..616bb03 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="100">
 	<rule_flags>0</rule_flags>
 	<expr type="bitwise">
 		<sreg>1</sreg>
diff --git a/tests/xmlfiles/21-rule-byteorder.xml b/tests/xmlfiles/21-rule-byteorder.xml
index ee2fcb2..c83fe22 100644
--- a/tests/xmlfiles/21-rule-byteorder.xml
+++ b/tests/xmlfiles/21-rule-byteorder.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="test" chain="test" handle="1000" version="0">
+<rule family="ip" table="test" chain="test" handle="1000">
 	<rule_flags>0</rule_flags>
 	<expr type="byteorder">
 		<sreg>3</sreg>
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index 6730c77..1ad90cb 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="test" handle="36" version="0">
+<rule family="ip6" table="filter" chain="test" handle="36">
 	<rule_flags>0</rule_flags>
 	<expr type="cmp">
 		<sreg>1</sreg>
diff --git a/tests/xmlfiles/23-rule-counter.xml b/tests/xmlfiles/23-rule-counter.xml
index 047bd8d..15f2e51 100644
--- a/tests/xmlfiles/23-rule-counter.xml
+++ b/tests/xmlfiles/23-rule-counter.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="test" handle="39" version="0">
+<rule family="ip6" table="filter" chain="test" handle="39">
 	<rule_flags>0</rule_flags>
 	<expr type="counter">
 		<pkts>3</pkts>
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
index 01dd68a..9a534c5 100644
--- a/tests/xmlfiles/24-rule-ct.xml
+++ b/tests/xmlfiles/24-rule-ct.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="100">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/25-rule-exthdr.xml b/tests/xmlfiles/25-rule-exthdr.xml
index fbba3cc..f4c44f0 100644
--- a/tests/xmlfiles/25-rule-exthdr.xml
+++ b/tests/xmlfiles/25-rule-exthdr.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
+<rule family="ip6" table="filter" chain="INPUT" handle="100">
 	<rule_flags>0</rule_flags>
 	<expr type="exthdr">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index 665078a..322e49f 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="input" handle="32" version="0">
+<rule family="ip" table="filter" chain="input" handle="32">
 	<rule_flags>0</rule_flags>
 	<expr type="immediate">
 		<dreg>0</dreg>
diff --git a/tests/xmlfiles/27-rule-limit.xml b/tests/xmlfiles/27-rule-limit.xml
index 92a2bd9..7fa6963 100644
--- a/tests/xmlfiles/27-rule-limit.xml
+++ b/tests/xmlfiles/27-rule-limit.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="100">
   <rule_flags>0</rule_flags>
   <expr type="limit">
     <rate>123123</rate>
diff --git a/tests/xmlfiles/28-rule-log.xml b/tests/xmlfiles/28-rule-log.xml
index a8e4a42..b001610 100644
--- a/tests/xmlfiles/28-rule-log.xml
+++ b/tests/xmlfiles/28-rule-log.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="test" handle="96" version="0">
+<rule family="ip6" table="filter" chain="test" handle="96">
 	<rule_flags>0</rule_flags>
 	<expr type="log">
 		<prefix>test_chain</prefix>
diff --git a/tests/xmlfiles/29-rule-lookup.xml b/tests/xmlfiles/29-rule-lookup.xml
index 7099d35..50f9340 100644
--- a/tests/xmlfiles/29-rule-lookup.xml
+++ b/tests/xmlfiles/29-rule-lookup.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="test" handle="37" version="0">
+<rule family="ip6" table="filter" chain="test" handle="37">
 	<rule_flags>0</rule_flags>
 	<expr type="lookup">
 		<set>set0</set>
diff --git a/tests/xmlfiles/30-rule-match.xml b/tests/xmlfiles/30-rule-match.xml
index 5a88ee6..99d53f7 100644
--- a/tests/xmlfiles/30-rule-match.xml
+++ b/tests/xmlfiles/30-rule-match.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="100">
 	<rule_flags>0</rule_flags>
 	<expr type="match">
 		<name>state</name>
diff --git a/tests/xmlfiles/31-rule-meta.xml b/tests/xmlfiles/31-rule-meta.xml
index 673abc9..2ffb7c5 100644
--- a/tests/xmlfiles/31-rule-meta.xml
+++ b/tests/xmlfiles/31-rule-meta.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="test" handle="36" version="0">
+<rule family="ip6" table="filter" chain="test" handle="36">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
index 4cc6571..108722a 100644
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ b/tests/xmlfiles/32-rule-nat6.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="nat" chain="OUTPUT" handle="100" version="0">
+<rule family="ip6" table="nat" chain="OUTPUT" handle="100">
 	<rule_flags>0</rule_flags>
 	<expr type="nat">
 		<family>ip6</family>
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
index 0dc213e..1729b9f 100644
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ b/tests/xmlfiles/33-rule-nat4.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="100">
   <rule_flags>0</rule_flags>
   <expr type="nat">
     <sreg_addr_min>1</sreg_addr_min>
diff --git a/tests/xmlfiles/34-rule-payload.xml b/tests/xmlfiles/34-rule-payload.xml
index d3e466f..0920c65 100644
--- a/tests/xmlfiles/34-rule-payload.xml
+++ b/tests/xmlfiles/34-rule-payload.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="test" handle="34" version="0">
+<rule family="ip6" table="filter" chain="test" handle="34">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/35-rule-target.xml b/tests/xmlfiles/35-rule-target.xml
index 86f6d43..8fce3b5 100644
--- a/tests/xmlfiles/35-rule-target.xml
+++ b/tests/xmlfiles/35-rule-target.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="100">
 	<rule_flags>0</rule_flags>
 	<expr type="target">
 		<name>LOG</name>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
index dd70252..352027a 100644
--- a/tests/xmlfiles/36-rule-real.xml
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="22" version="0">
+<rule family="ip" table="filter" chain="output" handle="22">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index 5dfdcfd..a4ced2c 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="25" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="25">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index 423ef6d..d48547c 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="INPUT" handle="30" version="0">
+<rule family="ip" table="filter" chain="INPUT" handle="30">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index 249160e..8e8b77f 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip6" table="filter" chain="test" handle="31" version="0">
+<rule family="ip6" table="filter" chain="test" handle="31">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
index 981715d..00a333d 100644
--- a/tests/xmlfiles/40-rule-real.xml
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="2" version="0">
+<rule family="ip" table="filter" chain="output" handle="2">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
index 1a80e42..58c13d0 100644
--- a/tests/xmlfiles/41-rule-real.xml
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="3" version="0">
+<rule family="ip" table="filter" chain="output" handle="3">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
index 74eb226..298181c 100644
--- a/tests/xmlfiles/42-rule-real.xml
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="4" version="0">
+<rule family="ip" table="filter" chain="output" handle="4">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index 7c24e26..b814e55 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="5" version="0">
+<rule family="ip" table="filter" chain="output" handle="5">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
index 36cba92..7be5705 100644
--- a/tests/xmlfiles/44-rule-real.xml
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="6" version="0">
+<rule family="ip" table="filter" chain="output" handle="6">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
index ff36c26..d1cab48 100644
--- a/tests/xmlfiles/45-rule-real.xml
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="7" version="0">
+<rule family="ip" table="filter" chain="output" handle="7">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
index 9c9d796..e87194f 100644
--- a/tests/xmlfiles/46-rule-real.xml
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="8" version="0">
+<rule family="ip" table="filter" chain="output" handle="8">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
index a7fcdf4..c15edc0 100644
--- a/tests/xmlfiles/47-rule-real.xml
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="9" version="0">
+<rule family="ip" table="filter" chain="output" handle="9">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
index 8dbf189..097f602 100644
--- a/tests/xmlfiles/48-rule-real.xml
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="10" version="0">
+<rule family="ip" table="filter" chain="output" handle="10">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
index fefa727..32cc623 100644
--- a/tests/xmlfiles/49-rule-real.xml
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="11" version="0">
+<rule family="ip" table="filter" chain="output" handle="11">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index 814cde2..6800d19 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="12" version="0">
+<rule family="ip" table="filter" chain="output" handle="12">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index 0b0c737..a77d5d9 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="13" version="0">
+<rule family="ip" table="filter" chain="output" handle="13">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index 7e13a38..289a6eb 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="14" version="0">
+<rule family="ip" table="filter" chain="output" handle="14">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index 78db321..ba1ba42 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="15" version="0">
+<rule family="ip" table="filter" chain="output" handle="15">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index 73fec98..bcb81b7 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="16" version="0">
+<rule family="ip" table="filter" chain="output" handle="16">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index 728fb69..fd98495 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="17" version="0">
+<rule family="ip" table="filter" chain="output" handle="17">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index a0ab9bb..cfffce8 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="18" version="0">
+<rule family="ip" table="filter" chain="output" handle="18">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index cb6de17..6674496 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="19" version="0">
+<rule family="ip" table="filter" chain="output" handle="19">
 	<rule_flags>0</rule_flags>
 	<expr type="ct">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
index 0a09cf0..f7adb9c 100644
--- a/tests/xmlfiles/58-rule-real.xml
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="20" version="0">
+<rule family="ip" table="filter" chain="output" handle="20">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
index ce597fc..88442a1 100644
--- a/tests/xmlfiles/59-rule-real.xml
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="21" version="0">
+<rule family="ip" table="filter" chain="output" handle="21">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
index 95ef299..2cfbec7 100644
--- a/tests/xmlfiles/60-rule-real.xml
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="22" version="0">
+<rule family="ip" table="filter" chain="output" handle="22">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
index a7edb58..0b7e8a3 100644
--- a/tests/xmlfiles/61-rule-real.xml
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="23" version="0">
+<rule family="ip" table="filter" chain="output" handle="23">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
index a4744a2..6ef3055 100644
--- a/tests/xmlfiles/62-rule-real.xml
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="24" version="0">
+<rule family="ip" table="filter" chain="output" handle="24">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
index ef53bb2..69933f2 100644
--- a/tests/xmlfiles/63-rule-real.xml
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="25" version="0">
+<rule family="ip" table="filter" chain="output" handle="25">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
index e77e646..10db311 100644
--- a/tests/xmlfiles/64-rule-real.xml
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="26" version="0">
+<rule family="ip" table="filter" chain="output" handle="26">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
index 4982350..b88f81a 100644
--- a/tests/xmlfiles/65-rule-real.xml
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="27" version="0">
+<rule family="ip" table="filter" chain="output" handle="27">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
index 12ecdcf..f0bf768 100644
--- a/tests/xmlfiles/66-rule-real.xml
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="28" version="0">
+<rule family="ip" table="filter" chain="output" handle="28">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
index 71922a9..82d1310 100644
--- a/tests/xmlfiles/67-rule-real.xml
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="29" version="0">
+<rule family="ip" table="filter" chain="output" handle="29">
 	<rule_flags>0</rule_flags>
 	<expr type="meta">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
index 119c637..f538185 100644
--- a/tests/xmlfiles/68-rule-real.xml
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="32" version="0">
+<rule family="ip" table="filter" chain="output" handle="32">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/69-rule-real.xml b/tests/xmlfiles/69-rule-real.xml
index 9225bf9..bfa4efe 100644
--- a/tests/xmlfiles/69-rule-real.xml
+++ b/tests/xmlfiles/69-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="33" version="0">
+<rule family="ip" table="filter" chain="output" handle="33">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
index 48b1d30..8f15733 100644
--- a/tests/xmlfiles/70-rule-real.xml
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="34" version="0">
+<rule family="ip" table="filter" chain="output" handle="34">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
index 6bed65b..f8e199a 100644
--- a/tests/xmlfiles/71-rule-real.xml
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="35" version="0">
+<rule family="ip" table="filter" chain="output" handle="35">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/72-rule-real.xml b/tests/xmlfiles/72-rule-real.xml
index e14a888..4b9f93b 100644
--- a/tests/xmlfiles/72-rule-real.xml
+++ b/tests/xmlfiles/72-rule-real.xml
@@ -1,4 +1,4 @@
-<rule family="ip" table="filter" chain="output" handle="36" version="0">
+<rule family="ip" table="filter" chain="output" handle="36">
 	<rule_flags>0</rule_flags>
 	<expr type="payload">
 		<dreg>1</dreg>
diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
index 6807ea7..9c51548 100644
--- a/tests/xmlfiles/73-set.xml
+++ b/tests/xmlfiles/73-set.xml
@@ -1,7 +1,6 @@
 <set>
 	<set_name>set0</set_name>
 	<set_table>filter</set_table>
-	<set_xml_version>0</set_xml_version>
 	<family>ip</family>
 	<set_flags>0</set_flags>
 	<key_type>0</key_type>
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
index dd65703..9bfb9f9 100644
--- a/tests/xmlfiles/74-set.xml
+++ b/tests/xmlfiles/74-set.xml
@@ -1,7 +1,6 @@
 <set>
 	<set_name>set0</set_name>
 	<set_table>filter</set_table>
-	<set_xml_version>0</set_xml_version>
 	<family>ip6</family>
 	<set_flags>0</set_flags>
 	<key_type>0</key_type>
-- 
1.7.10.4

