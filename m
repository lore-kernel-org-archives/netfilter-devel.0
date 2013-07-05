From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [libnftables PATCH] src: improving default text output
Date: Fri, 05 Jul 2013 10:06:28 +0200
Message-ID: <20130705080628.2770.63222.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43532 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab3GEIGi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:06:38 -0400
Received: by mail-wg0-f49.google.com with SMTP id a12so1704060wgh.4
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 01:06:36 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.89.105])
        by mx.google.com with ESMTPSA id fb2sm38941051wic.4.2013.07.05.01.06.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 05 Jul 2013 01:06:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch, you can improve default plain text output.
Warning fixed, and replaced %lu with %"PRIu64".

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 src/chain.c          |   17 +++++++++--------
 src/expr/bitwise.c   |    9 +++------
 src/expr/byteorder.c |    7 +++----
 src/expr/cmp.c       |    4 ++--
 src/expr/counter.c   |    7 ++++---
 src/expr/ct.c        |    4 ++--
 src/expr/data_reg.c  |    4 ++--
 src/expr/exthdr.c    |    6 +++---
 src/expr/immediate.c |    2 +-
 src/expr/limit.c     |    2 +-
 src/expr/log.c       |    4 ++--
 src/expr/lookup.c    |    4 ++--
 src/expr/match.c     |    2 +-
 src/expr/meta.c      |    4 ++--
 src/expr/nat.c       |   10 +++++-----
 src/expr/payload.c   |    5 ++---
 src/expr/target.c    |    2 +-
 src/rule.c           |    9 ++++++---
 src/set.c            |    2 +-
 src/set_elem.c       |    7 +++++--
 20 files changed, 57 insertions(+), 54 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 68744bc..597c3b1 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -18,6 +18,7 @@
 #include <string.h>
 #include <netinet/in.h>
 #include <errno.h>
+#include <inttypes.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -721,9 +722,9 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 	return snprintf(buf, size,
 		"{ \"chain\": {"
 			"\"name\": \"%s\","
-			"\"handle\": %lu,"
-			"\"bytes\": %lu,"
-			"\"packets\": %lu,"
+			"\"handle\": %"PRIu64","
+			"\"bytes\": %"PRIu64","
+			"\"packets\": %"PRIu64","
 			"\"version\": %d,"
 			"\"properties\": {"
 				"\"type\" : \"%s\","
@@ -747,8 +748,8 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 	int ret, len = size, offset = 0;
 
 	ret = snprintf(buf, size,
-		       "<chain name=\"%s\" handle=\"%lu\""
-		       " bytes=\"%lu\" packets=\"%lu\" version=\"%d\">"
+		       "<chain name=\"%s\" handle=\"%"PRIu64"\""
+		       " bytes=\"%"PRIu64"\" packets=\"%"PRIu64"\" version=\"%d\">"
 		       "<properties>"
 				"<type>%s</type>"
 				"<table>%s</table>"
@@ -782,9 +783,9 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 static int nft_chain_snprintf_default(char *buf, size_t size,
 				      struct nft_chain *c)
 {
-	return snprintf(buf, size, "family=%s table=%s chain=%s type=%s "
-				   "hook=%u prio=%d policy=%d use=%d "
-				   "packets=%lu bytes=%lu",
+	return snprintf(buf, size, "%s %s %s %s "
+				   "hook %u prio %d policy %d use %d "
+				   "packets %"PRIu64" bytes=%"PRIu64" ",
 			nft_family2str(c->family), c->table, c->name, c->type,
 			c->hooknum, c->prio, c->policy, c->use, c->packets,
 			c->bytes);
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 6843086..61b4086 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -392,18 +392,15 @@ nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "sreg=%u dreg=%u ",
-		       bitwise->sreg, bitwise->dreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-	ret = snprintf(buf+offset, len, " mask=");
+	ret = snprintf(buf, len, "reg %u = (reg=%u & ",
+		       bitwise->dreg, bitwise->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
 				    NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, " xor=");
+	ret = snprintf(buf+offset, len, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index bb47f10..606f3ec 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -341,10 +341,9 @@ nft_rule_expr_byteorder_snprintf_default(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "sreg=%u dreg=%u op=%s len=%u size=%u ",
-		       byteorder->sreg, byteorder->dreg,
-		       expr_byteorder_str[byteorder->op],
-		       byteorder->len, byteorder->size);
+	ret = snprintf(buf, len, "reg %u = %s(reg %u, %u, %u) ",
+		       byteorder->dreg, expr_byteorder_str[byteorder->op],
+		       byteorder->sreg, byteorder->size, byteorder->len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index f92b3b6..0217c47 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -308,8 +308,8 @@ nft_rule_expr_cmp_snprintf_default(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "sreg=%u op=%s data=",
-		       cmp->sreg, expr_cmp_str[cmp->op]);
+	ret = snprintf(buf, len, "%s reg %u ",
+		       expr_cmp_str[cmp->op], cmp->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nft_data_reg_snprintf(buf+offset, len, &cmp->data,
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 62bd143..c3c3c33 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -13,6 +13,7 @@
 #include <stdint.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <inttypes.h>
 
 #include <linux/netfilter/nf_tables.h>
 
@@ -195,13 +196,13 @@ nft_rule_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "pkts=%lu bytes=%lu ",
+		return snprintf(buf, len, "pkts %"PRIu64" bytes %"PRIu64" ",
 				ctr->pkts, ctr->bytes);
 	case NFT_RULE_O_XML:
-		return snprintf(buf, len, "<pkts>%lu</pkts><bytes>%lu</bytes>",
+		return snprintf(buf, len, "<pkts>%"PRIu64"</pkts><bytes>%"PRIu64"</bytes>",
 				ctr->pkts, ctr->bytes);
 	case NFT_RULE_O_JSON:
-		return snprintf(buf, len, "\"pkts\" : %lu, \"bytes\" : %lu",
+		return snprintf(buf, len, "\"pkts\" : %"PRIu64", \"bytes\" : %"PRIu64"",
 				ctr->pkts, ctr->bytes);
 	default:
 		break;
diff --git a/src/expr/ct.c b/src/expr/ct.c
index fcdabce..b9352cb 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -272,8 +272,8 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "dreg=%u key=%s dir=%u ",
-				ct->dreg, ctkey2str(ct->key), ct->dir);
+		return snprintf(buf, len, "load %s => reg %u dir %u ",
+				ctkey2str(ct->key), ct->dreg, ct->dir);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<key>%s</key>"
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index fd05499..316111d 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -363,7 +363,7 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 	case DATA_VERDICT:
 		switch(output_format) {
 		case NFT_RULE_O_DEFAULT:
-			return snprintf(buf, size, "verdict=%d", reg->verdict);
+			return snprintf(buf, size, "%d ", reg->verdict);
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
 					"<data_reg type=\"verdict\">"
@@ -380,7 +380,7 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 	case DATA_CHAIN:
 		switch(output_format) {
 		case NFT_RULE_O_DEFAULT:
-			return snprintf(buf, size, "chain=%s", reg->chain);
+			return snprintf(buf, size, "%s ", reg->chain);
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
 					"<data_reg type=\"chain\">"
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index b4b9c13..fea3780 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -326,9 +326,9 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "dreg=%u type=%u offset=%u len=%u ",
-				exthdr->dreg, exthdr->type,
-				exthdr->offset, exthdr->len);
+		return snprintf(buf, len, "load %ub @ %u + %u => reg %u ",
+				exthdr->len, exthdr->type,
+				exthdr->offset, exthdr->dreg);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<exthdr_type>%s</exthdr_type>"
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 1937d82..60193a8 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -374,7 +374,7 @@ nft_rule_expr_immediate_snprintf_default(char *buf, size_t len,
 	int size = len, offset = 0, ret;
 	struct nft_expr_immediate *imm = (struct nft_expr_immediate *)e->data;
 
-	ret = snprintf(buf, len, "dreg=%u ", imm->dreg);
+	ret = snprintf(buf, len, "reg %u ", imm->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_IMM_DATA)) {
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 1e843ce..fbd9305 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -189,7 +189,7 @@ nft_rule_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "rate=%"PRIu64" depth=%"PRIu64" ",
+		return snprintf(buf, len, "rate %"PRIu64" depth %"PRIu64" ",
 				limit->rate, limit->depth);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<rate>%"PRIu64"</rate>"
diff --git a/src/expr/log.c b/src/expr/log.c
index 8dc5201..d71fa29 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -252,8 +252,8 @@ nft_rule_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "prefix=%s group=%u "
-					  "snaplen=%u qthreshold=%u ",
+		return snprintf(buf, len, "prefix '%s' group %u "
+					  "snaplen %u qthreshold %u ",
 				log->prefix, log->group,
 				log->snaplen, log->qthreshold);
 	case NFT_RULE_O_XML:
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 8591d4e..779ad45 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -271,8 +271,8 @@ nft_rule_expr_lookup_snprintf_default(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "set=%s sreg=%u dreg=%u",
-			l->set_name, l->sreg, l->dreg);
+	ret = snprintf(buf, len, "reg %u set %s dreg %u ",
+			l->sreg, l->set_name, l->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
diff --git a/src/expr/match.c b/src/expr/match.c
index 7d0f078..b8948f2 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -259,7 +259,7 @@ nft_rule_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "name=%s rev=%u ",
+		return snprintf(buf, len, "name %s rev %u ",
 				match->name, match->rev);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_match_snprintf_xml(buf, len, match);
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 1a609cf..d0e693f 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -247,8 +247,8 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "dreg=%u key=%u ",
-				meta->dreg, meta->key);
+		return snprintf(buf, len, "load %s => reg %u ",
+				meta_key2str(meta->key), meta->dreg);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
 					  "<key>%s</key>",
diff --git a/src/expr/nat.c b/src/expr/nat.c
index b753069..000e00d 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -414,28 +414,28 @@ nft_rule_expr_nat_snprintf_default(char *buf, size_t size,
 
 	switch (nat->type) {
 	case NFT_NAT_SNAT:
-		ret = snprintf(buf, len, "type=NFT_NAT_SNAT ");
+		ret = snprintf(buf, len, "snat ");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NAT_DNAT:
-		ret = snprintf(buf, len, "type=NFT_NAT_DNAT ");
+		ret = snprintf(buf, len, "dnat ");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	}
 
-	ret = snprintf(buf+offset, len, "family=%s ", nft_family2str(nat->family));
+	ret = snprintf(buf+offset, len, "%s ", nft_family2str(nat->family));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
 		ret = snprintf(buf+offset, len,
-			       "sreg_addr_min_v4=%u sreg_addr_max_v4=%u ",
+			       "addr_min reg %u addr_max reg %u ",
 			       nat->sreg_addr_min, nat->sreg_addr_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
 		ret = snprintf(buf+offset, len,
-			       "sreg_proto_min=%u sreg_proto_max=%u ",
+			       "proto_min reg %u proto_max reg %u ",
 			       nat->sreg_proto_min, nat->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 2111c47..8aff3f1 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -335,9 +335,8 @@ nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "dreg=%u base=%u offset=%u len=%u ",
-				payload->dreg, payload->base,
-				payload->offset, payload->len);
+		return snprintf(buf, len, "load %ub @ network header + %u => reg %u ",
+				payload->dreg, payload->offset, payload->len);
 	case NFT_RULE_O_XML:
 		return nft_rule_expr_payload_snprintf_xml(buf, len, flags,
 							  payload);
diff --git a/src/expr/target.c b/src/expr/target.c
index 0ad39d5..e482f8b 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -261,7 +261,7 @@ nft_rule_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "name=%s rev=%u ",
+		return snprintf(buf, len, "name %s rev %u ",
 				target->name, target->rev);
 	case NFT_RULE_O_XML:
 		return nft_rule_exp_target_snprintf_xml(buf, len, target);
diff --git a/src/rule.c b/src/rule.c
index 5e9b16d..51fa529 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -18,6 +18,7 @@
 #include <string.h>
 #include <netinet/in.h>
 #include <errno.h>
+#include <inttypes.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -764,18 +765,20 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 	struct nft_rule_expr *expr;
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, size, "family=%s table=%s chain=%s handle=%llu "
-				  "flags=%x ",
+	ret = snprintf(buf, size, "%s %s %s %"PRIu64" %x\n",
 			nft_family2str(r->family), r->table, r->chain,
 			(unsigned long long)r->handle, r->rule_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	list_for_each_entry(expr, &r->expr_list, head) {
-		ret = snprintf(buf+offset, len, "%s ", expr->ops->name);
+		ret = snprintf(buf+offset, len, "  [ %s ", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_rule_expr_snprintf(buf+offset, size, expr, type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	
+		ret = snprintf(buf+offset, len, "]\n");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	return offset;
diff --git a/src/set.c b/src/set.c
index b8d431e..69f25ac 100644
--- a/src/set.c
+++ b/src/set.c
@@ -323,7 +323,7 @@ int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
 	int len = size, offset = 0;
 	struct nft_set_elem *elem;
 
-	ret = snprintf(buf, size, "set=%s table=%s flags=%x",
+	ret = snprintf(buf, size, "%s %s %x",
 			s->name, s->table, s->set_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 0cbb9b7..a70dc09 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -389,7 +389,7 @@ int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 {
 	int ret, len = size, offset = 0, i;
 
-	ret = snprintf(buf, size, "flags=%u key=", e->set_elem_flags);
+	ret = snprintf(buf, size, "element ");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	for (i=0; i<e->key.len/sizeof(uint32_t); i++) {
@@ -397,7 +397,7 @@ int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, "data=");
+	ret = snprintf(buf+offset, size, " : ");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	for (i=0; i<e->data.len/sizeof(uint32_t); i++) {
@@ -405,6 +405,9 @@ int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	ret = snprintf(buf+offset, len, "%u [end]", e->set_elem_flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	return offset;
 }
 EXPORT_SYMBOL(nft_set_elem_snprintf);

