From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] ruleset: factorize json/xml tagging
Date: Mon, 28 Oct 2013 11:57:47 +0100
Message-ID: <20131028105747.32691.93153.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34289 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754529Ab3J1K57 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:57:59 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 3202451ED5D
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2013 10:57:56 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HhFEJf+UZH5I for <netfilter-devel@vger.kernel.org>;
	Mon, 28 Oct 2013 11:57:50 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id A7E6C51ECC9
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2013 11:57:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This factorization of JSON/XML open & close tag allows reutilice code in future
patches (for example, the fprintf API functions).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/ruleset.c |  107 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 54 insertions(+), 53 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 8944da6..24b849b 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -579,18 +579,42 @@ int nft_ruleset_parse(struct nft_ruleset *r, enum nft_ruleset_parse_type type,
 }
 EXPORT_SYMBOL(nft_ruleset_parse);
 
-static int separator_snprintf(char *buf, size_t size, void *obj, uint32_t type)
+static const char *nft_ruleset_o_opentag(uint32_t type)
+{
+	switch (type) {
+	case NFT_RULESET_O_XML:
+		return "<nftables>";
+	case NFT_RULESET_O_JSON:
+		return "{\"nftables\":[";
+	default:
+		return "";
+	}
+}
+
+static const char *nft_ruleset_o_separator(void *obj, uint32_t type)
 {
 	if (obj == NULL)
-		return 0;
+		return "";
 
 	switch (type) {
 	case NFT_RULESET_O_JSON:
-		return snprintf(buf, size, ",");
+		return ",";
 	case NFT_RULESET_O_DEFAULT:
-		return snprintf(buf, size, "\n");
+		return "\n";
 	default:
-		return 0;
+		return "";
+	}
+}
+
+static const char *nft_ruleset_o_closetag(uint32_t type)
+{
+	switch (type) {
+	case NFT_RULESET_O_XML:
+		return "</nftables>";
+	case NFT_RULESET_O_JSON:
+		return "]}";
+	default:
+		return "";
 	}
 }
 
@@ -613,7 +637,9 @@ nft_ruleset_snprintf_table(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		t = nft_table_list_iter_next(ti);
-		ret = separator_snprintf(buf+offset, len, t, type);
+
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_ruleset_o_separator(t, type));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nft_table_list_iter_destroy(ti);
@@ -640,7 +666,9 @@ nft_ruleset_snprintf_chain(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		c = nft_chain_list_iter_next(ci);
-		ret = separator_snprintf(buf+offset, len, c, type);
+
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_ruleset_o_separator(c, type));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nft_chain_list_iter_destroy(ci);
@@ -667,7 +695,9 @@ nft_ruleset_snprintf_set(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		s = nft_set_list_iter_next(si);
-		ret = separator_snprintf(buf+offset, len, s, type);
+
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_ruleset_o_separator(s, type));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nft_set_list_iter_destroy(si);
@@ -694,7 +724,9 @@ nft_ruleset_snprintf_rule(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		r = nft_rule_list_iter_next(ri);
-		ret = separator_snprintf(buf+offset, len, r, type);
+
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_ruleset_o_separator(r, type));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 	nft_rule_list_iter_destroy(ri);
@@ -709,6 +741,9 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 	int ret, len = size, offset = 0;
 	void *prev = NULL;
 
+	ret = snprintf(buf+offset, size, "%s", nft_ruleset_o_opentag(type));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST) &&
 	    (!nft_table_list_is_empty(rs->table_list))) {
 		ret = nft_ruleset_snprintf_table(buf+offset, len, rs,
@@ -721,7 +756,8 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 
 	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST) &&
 	    (!nft_chain_list_is_empty(rs->chain_list))) {
-		ret = separator_snprintf(buf+offset, len, prev, type);
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_ruleset_o_separator(prev, type));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_ruleset_snprintf_chain(buf+offset, len, rs,
@@ -734,7 +770,8 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 
 	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST) &&
 	    (!nft_set_list_is_empty(rs->set_list))) {
-		ret = separator_snprintf(buf+offset, len, prev, type);
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_ruleset_o_separator(prev, type));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_ruleset_snprintf_set(buf+offset, len, rs,
@@ -747,7 +784,8 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 
 	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST) &&
 	    (!nft_rule_list_is_empty(rs->rule_list))) {
-		ret = separator_snprintf(buf+offset, len, prev, type);
+		ret = snprintf(buf+offset, len, "%s",
+			       nft_ruleset_o_separator(prev, type));
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_ruleset_snprintf_rule(buf+offset, len, rs,
@@ -755,42 +793,7 @@ nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	return offset;
-}
-
-static int
-nft_ruleset_snprintf_xml(char *buf, size_t size, const struct nft_ruleset *rs,
-			 uint32_t flags)
-{
-	int ret, len = size, offset = 0;
-
-	ret = snprintf(buf, size, "<nftables>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = nft_ruleset_do_snprintf(buf+offset, len, rs, NFT_RULESET_O_XML,
-				      flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = snprintf(buf+offset, len, "</nftables>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	return offset;
-}
-
-static int
-nft_ruleset_snprintf_json(char *buf, size_t size, const struct nft_ruleset *rs,
-			  uint32_t flags)
-{
-	int ret, len = size, offset = 0;
-
-	ret = snprintf(buf, size, "{\"nftables\":[");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = nft_ruleset_do_snprintf(buf+offset, len, rs, NFT_RULESET_O_JSON,
-				      flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = snprintf(buf+offset, len, "]}");
+	ret = snprintf(buf+offset, size, "%s", nft_ruleset_o_closetag(type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -801,14 +804,12 @@ int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
 {
 	switch (type) {
 	case NFT_RULESET_O_DEFAULT:
-		return nft_ruleset_do_snprintf(buf, size, r, type, flags);
 	case NFT_RULESET_O_XML:
-		return nft_ruleset_snprintf_xml(buf, size, r, flags);
 	case NFT_RULESET_O_JSON:
-		return nft_ruleset_snprintf_json(buf, size, r, flags);
+		return nft_ruleset_do_snprintf(buf, size, r, type, flags);
 	default:
-		break;
+		errno = EOPNOTSUPP;
+		return -1;
 	}
-	return -1;
 }
 EXPORT_SYMBOL(nft_ruleset_snprintf);

