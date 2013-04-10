From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 4/5] src: expr: print flags in XML
Date: Wed, 10 Apr 2013 18:40:13 +0200
Message-ID: <20130410164013.6303.94034.stgit@nfdev.cica.es>
References: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36351 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932468Ab3DJQkQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:40:16 -0400
In-Reply-To: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the <expr_flags> XML node to expressions printing.

Using this new node, a exact copy of the expr is exported, so is possible to know what attributes were originally set in the expr.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c   |   17 ++++++++++-------
 src/expr/cmp.c       |   15 ++++++++++-----
 src/expr/counter.c   |    6 ++++--
 src/expr/immediate.c |    4 ++++
 src/expr/lookup.c    |   17 +++++++++--------
 src/expr/match.c     |    8 ++++++--
 src/expr/meta.c      |    5 +++--
 src/expr/nat.c       |    4 ++++
 src/expr/payload.c   |    5 +++--
 src/expr/target.c    |    9 +++++++--
 10 files changed, 60 insertions(+), 30 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index ddcf6a7..4376fa0 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -197,8 +197,9 @@ nft_rule_expr_bitwise_parse(struct nft_rule_expr *e, struct nlattr *attr)
 
 static int
 nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
-				   struct nft_expr_bitwise *bitwise)
+				   struct nft_rule_expr *e)
 {
+	struct nft_expr_bitwise *bitwise = (struct nft_expr_bitwise *)e->data;
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "<sreg>%u</sreg>"
@@ -223,13 +224,18 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 	ret = snprintf(buf+offset, len, "</xor>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	ret = snprintf(buf+offset, len, "<expr_flags>%u</expr_flags>",
+		       e->flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 
 static int
 nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
-				       struct nft_expr_bitwise *bitwise)
+				       struct nft_rule_expr *e)
 {
+	struct nft_expr_bitwise *bitwise = (struct nft_expr_bitwise *)e->data;
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "sreg=%u dreg=%u ",
@@ -257,14 +263,11 @@ static int
 nft_rule_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_bitwise *bitwise = (struct nft_expr_bitwise *)e->data;
-
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return nft_rule_expr_bitwise_snprintf_xml(buf, size, bitwise);
+		return nft_rule_expr_bitwise_snprintf_xml(buf, size, e);
 	case NFT_RULE_O_DEFAULT:
-		return nft_rule_expr_bitwise_snprintf_default(buf, size,
-							      bitwise);
+		return nft_rule_expr_bitwise_snprintf_default(buf, size, e);
 	default:
 		break;
 	}
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 3de849a..e1e76a6 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -167,8 +167,9 @@ static char *expr_cmp_str[] = {
 };
 
 static int
-nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
+nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_rule_expr *e)
 {
+	struct nft_expr_cmp *cmp = (struct nft_expr_cmp *)e->data;
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "<sreg>%u</sreg><op>%s</op><cmpdata>",
@@ -182,13 +183,18 @@ nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
 	ret = snprintf(buf+offset, len, "</cmpdata>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	ret = snprintf(buf+offset, len, "<expr_flags>%u</expr_flags>",
+		       e->flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 
 static int
 nft_rule_expr_cmp_snprintf_default(char *buf, size_t size,
-				   struct nft_expr_cmp *cmp)
+				   struct nft_rule_expr *e)
 {
+	struct nft_expr_cmp *cmp = (struct nft_expr_cmp *)e->data;
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "sreg=%u op=%s data=",
@@ -206,12 +212,11 @@ static int
 nft_rule_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
 			   uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_cmp *cmp = (struct nft_expr_cmp *)e->data;
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return nft_rule_expr_cmp_snprintf_xml(buf, size, cmp);
+		return nft_rule_expr_cmp_snprintf_xml(buf, size, e);
 	case NFT_RULE_O_DEFAULT:
-		return nft_rule_expr_cmp_snprintf_default(buf, size, cmp);
+		return nft_rule_expr_cmp_snprintf_default(buf, size, e);
 	default:
 		break;
 	}
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 550d56d..ec6f637 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -133,8 +133,10 @@ nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return snprintf(buf, len, "<pkts>%lu</pkts><bytes>%lu</bytes>",
-				ctr->pkts, ctr->bytes);
+		return snprintf(buf, len, "<pkts>%lu</pkts>"
+					"<bytes>%lu</bytes>"
+					"<expr_flags>%u</expr_flags>",
+				ctr->pkts, ctr->bytes, e->flags);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "pkts=%lu bytes=%lu ",
 				ctr->pkts, ctr->bytes);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 10f7793..d59f109 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -226,6 +226,10 @@ nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 	ret = snprintf(buf+offset, len, "</immediatedata>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	ret = snprintf(buf+offset, len, "<expr_flags>%u</expr_flags>",
+		       e->flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 003554b..2abe82e 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -152,12 +152,14 @@ nft_rule_expr_lookup_parse(struct nft_rule_expr *e, struct nlattr *attr)
 
 static int
 nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
-				  struct nft_expr_lookup *l)
+				  struct nft_rule_expr *e)
 {
+	struct nft_expr_lookup *l = (struct nft_expr_lookup *)e->data;
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "<set>%s</set><sreg>%u</sreg><dreg>%u</dreg>",
-			l->set_name, l->sreg, l->dreg);
+	ret = snprintf(buf, len, "<set>%s</set><sreg>%u</sreg><dreg>%u</dreg>"
+				"<expr_flags>%u</expr_flags>",
+			l->set_name, l->sreg, l->dreg, e->flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -165,8 +167,9 @@ nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 
 static int
 nft_rule_expr_lookup_snprintf_default(char *buf, size_t size,
-				      struct nft_expr_lookup *l)
+				      struct nft_rule_expr *e)
 {
+	struct nft_expr_lookup *l = (struct nft_expr_lookup *)e->data;
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "set=%s sreg=%u dreg=%u\n",
@@ -180,13 +183,11 @@ static int
 nft_rule_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_lookup *lookup = (struct nft_expr_lookup *)e->data;
-
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return nft_rule_expr_lookup_snprintf_xml(buf, size, lookup);
+		return nft_rule_expr_lookup_snprintf_xml(buf, size, e);
 	case NFT_RULE_O_DEFAULT:
-		return nft_rule_expr_lookup_snprintf_default(buf, size, lookup);
+		return nft_rule_expr_lookup_snprintf_default(buf, size, e);
 	default:
 		break;
 	}
diff --git a/src/expr/match.c b/src/expr/match.c
index d3bfe76..9a2696e 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -186,8 +186,9 @@ static int nft_rule_expr_match_parse(struct nft_rule_expr *e, struct nlattr *att
 
 static
 int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
-				struct nft_expr_match *mt)
+				struct nft_rule_expr *e)
 {
+	struct nft_expr_match *mt = (struct nft_expr_match *)e->data;
 	int ret, size=len;
 	int i;
 	int offset = 0;
@@ -205,6 +206,9 @@ int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 	ret = snprintf(buf+offset, len, "</info>" );
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	ret = snprintf(buf+offset, len, "<expr_flags>%u</expr_flags>", e->flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 
@@ -217,7 +221,7 @@ nft_rule_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return nft_rule_expr_match_snprintf_xml(buf, len, match);
+		return nft_rule_expr_match_snprintf_xml(buf, len, e);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "name=%s rev=%u ",
 				match->name, match->rev);
diff --git a/src/expr/meta.c b/src/expr/meta.c
index bfc1aa6..e342a6d 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -134,8 +134,9 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 	switch(type) {
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<key>%u</key>",
-				meta->dreg, meta->key);
+					  "<key>%u</key>"
+					"<expr_flags>%u</expr_flags>",
+				meta->dreg, meta->key, e->flags);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "dreg=%u key=%u ",
 				meta->dreg, meta->key);
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 56212a7..382862a 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -239,6 +239,10 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	ret = snprintf(buf, len, "<expr_flags>%u</expr_flags>",
+		       e->flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 091078b..b72be96 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -174,9 +174,10 @@ nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<base>%u</base><offset>%u</offset>"
-					  "<len>%u</len>",
+					  "<len>%u</len>"
+					  "<expr_flags>%u</expr_flags>",
 				payload->dreg, payload->base,
-					payload->offset, payload->len);
+				payload->offset, payload->len, e->flags);
 
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "dreg=%u base=%u offset=%u len=%u ",
diff --git a/src/expr/target.c b/src/expr/target.c
index b6cfd04..5ceecce 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -186,8 +186,9 @@ static int nft_rule_expr_target_parse(struct nft_rule_expr *e, struct nlattr *at
 
 static
 int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
-				struct nft_expr_target *tg)
+				struct nft_rule_expr *e)
 {
+	struct nft_expr_target *tg = (struct nft_expr_target *)e->data;
 	int ret, size=len;
 	int i;
 	int offset = 0;
@@ -205,6 +206,10 @@ int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 	ret = snprintf(buf+offset, len, "</info>" );
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	ret = snprintf(buf+offset, len, "<expr_flags>%u</expr_flags>",
+		       e->flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 
@@ -216,7 +221,7 @@ nft_rule_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return nft_rule_exp_target_snprintf_xml(buf, len, target);
+		return nft_rule_exp_target_snprintf_xml(buf, len, e);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "name=%s rev=%u ",
 				target->name, target->rev);

