From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 3/5] src: xml printing: delete text format
Date: Wed, 10 Apr 2013 18:40:07 +0200
Message-ID: <20130410164007.6303.77061.stgit@nfdev.cica.es>
References: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36344 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932468Ab3DJQkL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:40:11 -0400
In-Reply-To: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Delete all \n and \t from XML output.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c          |   24 ++++++++++++------------
 src/expr/bitwise.c   |    8 ++++----
 src/expr/cmp.c       |    4 ++--
 src/expr/counter.c   |    2 +-
 src/expr/immediate.c |    4 ++--
 src/expr/lookup.c    |    2 +-
 src/expr/match.c     |    2 +-
 src/expr/meta.c      |    4 ++--
 src/expr/nat.c       |    8 ++++----
 src/expr/payload.c   |    4 ++--
 src/expr/target.c    |    2 +-
 src/rule.c           |    8 ++++----
 src/table.c          |   14 +++++++-------
 13 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 9d77179..4c111b6 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -450,18 +450,18 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 {
 	return snprintf(buf, size,
 		"<chain name=\"%s\" handle=\"%lu\""
-			" bytes=\"%lu\" packets=\"%lu\" >\n"
-			"\t<properties>\n"
-				"\t\t<flags>%d</flags>\n"
-				"\t\t<type>%s</type>\n"
-				"\t\t<table>%s</table>\n"
-				"\t\t<prio>%d</prio>\n"
-				"\t\t<use>%d</use>\n"
-				"\t\t<hooknum>%d</hooknum>\n"
-				"\t\t<policy>%d</policy>\n"
-				"\t\t<family>%d</family>\n"
-			"\t</properties>\n"
-		"</chain>\n",
+			" bytes=\"%lu\" packets=\"%lu\" >"
+			"<properties>"
+				"<flags>%d</flags>"
+				"<type>%s</type>"
+				"<table>%s</table>"
+				"<prio>%d</prio>"
+				"<use>%d</use>"
+				"<hooknum>%d</hooknum>"
+				"<policy>%d</policy>"
+				"<family>%d</family>"
+			"</properties>"
+		"</chain>",
 			c->name, c->handle, c->bytes, c->packets,
 			c->flags, c->type, c->table, c->prio,
 			c->use, c->hooknum, c->policy, c->family);
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 052144e..ddcf6a7 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -201,8 +201,8 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "\t\t<sreg>%u</sreg> "
-					"<dreg>%u</dreg> ",
+	ret = snprintf(buf, len, "<sreg>%u</sreg>"
+				"<dreg>%u</dreg>",
 		       bitwise->sreg, bitwise->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -213,14 +213,14 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 				    NFT_RULE_O_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "</mask> <xor>");
+	ret = snprintf(buf+offset, len, "</mask><xor>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
 				    NFT_RULE_O_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "</xor> ");
+	ret = snprintf(buf+offset, len, "</xor>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 6b5a3a2..3de849a 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -171,7 +171,7 @@ nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "\t\t<sreg>%u</sreg> <op>%s</op> <cmpdata>",
+	ret = snprintf(buf, len, "<sreg>%u</sreg><op>%s</op><cmpdata>",
 		       cmp->sreg, expr_cmp_str[cmp->op]);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -179,7 +179,7 @@ nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
 				    NFT_RULE_O_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "</cmpdata> ");
+	ret = snprintf(buf+offset, len, "</cmpdata>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
diff --git a/src/expr/counter.c b/src/expr/counter.c
index d2da9bf..550d56d 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -133,7 +133,7 @@ nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return snprintf(buf, len, "\t\t<pkts>%lu</pkts> <bytes>%lu</bytes> ",
+		return snprintf(buf, len, "<pkts>%lu</pkts><bytes>%lu</bytes>",
 				ctr->pkts, ctr->bytes);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "pkts=%lu bytes=%lu ",
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 082db76..10f7793 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -202,8 +202,8 @@ nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
 	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = (struct nft_expr_immediate *)e->data;
 
-	ret = snprintf(buf, len, "\t\t<dreg>%u</dreg>"
-				"\n\t\t<immediatedata>", imm->dreg);
+	ret = snprintf(buf, len, "<dreg>%u</dreg>"
+				"<immediatedata>", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 550c850..003554b 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -156,7 +156,7 @@ nft_rule_expr_lookup_snprintf_xml(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "<set>%s</set><sreg>%u</sreg><dreg>%u</dreg>\n",
+	ret = snprintf(buf, len, "<set>%s</set><sreg>%u</sreg><dreg>%u</dreg>",
 			l->set_name, l->sreg, l->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/expr/match.c b/src/expr/match.c
index d1f5963..d3bfe76 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -193,7 +193,7 @@ int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 	int offset = 0;
 	uint8_t *data = (uint8_t *)mt->data;
 
-	ret = snprintf(buf, len, "\t\t<name>%s</name> <rev>%u</rev> <info><len>%u</len>",
+	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev><info><len>%u</len>",
 				mt->name, mt->rev, mt->data_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 2095545..bfc1aa6 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -133,8 +133,8 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return snprintf(buf, len, "\t\t<dreg>%u</dreg>"
-					  " <key>%u</key> ",
+		return snprintf(buf, len, "<dreg>%u</dreg>"
+					  "<key>%u</key>",
 				meta->dreg, meta->key);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "dreg=%u key=%u ",
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 68217bd..56212a7 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -211,17 +211,17 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 	switch (nat->type) {
 	case NFT_NAT_SNAT:
 		ret = snprintf(buf, len,
-			"\t\t<type>NFT_NAT_SNAT</type> ");
+			"<type>NFT_NAT_SNAT</type>");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NAT_DNAT:
 		ret = snprintf(buf, len,
-			"\t\t<type>NFT_NAT_DNAT</type> ");
+			"<type>NFT_NAT_DNAT</type>");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	}
 
-	ret = snprintf(buf, len, "<family>%s</family> ",
+	ret = snprintf(buf, len, "<family>%s</family>",
 		       nat->family == AF_INET ? "AF_INET" : "AF_INET6");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -234,7 +234,7 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
 		ret = snprintf(buf, len, "<sreg_proto_min>%u</sreg_proto_min>"
-				" <sreg_proto_max>%u</sreg_proto_max> ",
+				"<sreg_proto_max>%u</sreg_proto_max>",
 		       nat->sreg_proto_min, nat->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 33fcef1..091078b 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -172,8 +172,8 @@ nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return snprintf(buf, len, "\t\t<dreg>%u</dreg>"
-					  "<base>%u</base> <offset>%u</offset>"
+		return snprintf(buf, len, "<dreg>%u</dreg>"
+					  "<base>%u</base><offset>%u</offset>"
 					  "<len>%u</len>",
 				payload->dreg, payload->base,
 					payload->offset, payload->len);
diff --git a/src/expr/target.c b/src/expr/target.c
index aae58ce..b6cfd04 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -193,7 +193,7 @@ int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 	int offset = 0;
 	uint8_t *data = (uint8_t *)tg->data;
 
-	ret = snprintf(buf, len, "\t\t<name>%s</name> <rev>%u</rev> <info><len>%u</len>",
+	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev><info><len>%u</len>",
 			tg->name, tg->rev, tg->data_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/rule.c b/src/rule.c
index c463c69..6178e57 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -445,7 +445,7 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 
 	ret = snprintf(buf, size,
 		"<rule family=\"%u\" table=\"%s\" "
-			"chain=\"%s\" handle=\"%llu\">\n ",
+			"chain=\"%s\" handle=\"%llu\">",
 				r->family, r->table, r->chain,
 				(unsigned long long)r->handle);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -460,17 +460,17 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 
 	list_for_each_entry(expr, &r->expr_list, head) {
 		ret = snprintf(buf+offset, len,
-				"\n\t<expr type=\"%s\">\n", expr->ops->name);
+				"<expr type=\"%s\">", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = expr->ops->snprintf(buf+offset, len, type, flags, expr);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		ret = snprintf(buf+offset, len, "\n\t</expr>");
+		ret = snprintf(buf+offset, len, "</expr>");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	}
-	ret = snprintf(buf+offset, len, "\n</rule>\n ");
+	ret = snprintf(buf+offset, len, "</rule>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return ret;
diff --git a/src/table.c b/src/table.c
index f109cdd..b47d623 100644
--- a/src/table.c
+++ b/src/table.c
@@ -185,13 +185,13 @@ EXPORT_SYMBOL(nft_table_nlmsg_parse);
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,
-			"<table name=\"%s\" >\n"
-				"\t<properties>\n"
-					"\t\t<family>%u</family>\n"
-					"\t\t<flags>%d</flags>\n"
-					"\t\t<table_flags>%d</table_flags>\n"
-				"\t</properties>\n"
-			"</table>\n" ,
+			"<table name=\"%s\" >"
+				"<properties>"
+					"<family>%u</family>"
+					"<flags>%d</flags>"
+					"<table_flags>%d</table_flags>"
+				"</properties>"
+			"</table>" ,
 			t->name, t->family, t->flags, t->table_flags);
 }
 

