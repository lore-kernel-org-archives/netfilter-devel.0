From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH libnftnl] src: Change parameters of SNPRINTF_BUFFER_SIZE macro.
Date: Wed, 20 Sep 2017 21:53:08 +0530
Message-ID: <20170920162309.5852-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36558 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdITQXt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 12:23:49 -0400
Received: by mail-pg0-f65.google.com with SMTP id d8so1903457pgt.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2017 09:23:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SNPRINTF_BUFFER_SIZE() macro declaration and definition is changed so
that it accepts three arguments ret, remain and offset. Parameters size
and len are not required instead parameter remain keeps track of
available space in the buffer.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/utils.h      |   9 ++--
 src/chain.c          |  39 ++++++++--------
 src/expr.c           |   6 +--
 src/expr/bitwise.c   |  18 ++++----
 src/expr/byteorder.c |   6 +--
 src/expr/cmp.c       |  10 ++--
 src/expr/ct.c        |  12 ++---
 src/expr/data_reg.c  |  52 ++++++++++-----------
 src/expr/dup.c       |   6 +--
 src/expr/dynset.c    |  27 +++++------
 src/expr/fib.c       |  20 ++++----
 src/expr/fwd.c       |   7 +--
 src/expr/hash.c      |  16 ++++---
 src/expr/immediate.c |  18 ++++----
 src/expr/log.c       |  35 +++++++-------
 src/expr/lookup.c    |  14 +++---
 src/expr/nat.c       |  23 +++++-----
 src/expr/numgen.c    |  14 +++---
 src/expr/queue.c     |  14 +++---
 src/expr/range.c     |  14 +++---
 src/expr/redir.c     |  10 ++--
 src/gen.c            |  14 +++---
 src/object.c         |  27 +++++------
 src/rule.c           |  70 ++++++++++++++--------------
 src/ruleset.c        |  88 +++++++++++++++++------------------
 src/set.c            | 126 ++++++++++++++++++++++++++-------------------------
 src/set_elem.c       |  81 +++++++++++++++++----------------
 src/table.c          |  16 +++----
 28 files changed, 403 insertions(+), 389 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 2f5cf34..e1c2efe 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -50,14 +50,13 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
 		__nftnl_assert_attr_exists(_attr, _attr_max, __FILE__, __LINE__);	\
 })
 
-#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
+#define SNPRINTF_BUFFER_SIZE(ret, remain, offset)	\
 	if (ret < 0)					\
 		ret = 0;				\
 	offset += ret;					\
-	if (ret > len)					\
-		ret = len;				\
-	size += ret;					\
-	len -= ret;
+	if (ret > remain)				\
+		ret = remain;				\
+	remain -= ret;					\
 
 const char *nftnl_family2str(uint32_t family);
 int nftnl_str2family(const char *family);
diff --git a/src/chain.c b/src/chain.c
index e5b9fe3..44c2613 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -788,32 +788,33 @@ static int nftnl_chain_export(char *buf, size_t size,
 static int nftnl_chain_snprintf_default(char *buf, size_t size,
 					const struct nftnl_chain *c)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
-	ret = snprintf(buf, len, "%s %s %s use %u",
+	ret = snprintf(buf, remain, "%s %s %s use %u",
 		       nftnl_family2str(c->family), c->table, c->name, c->use);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (c->flags & (1 << NFTNL_CHAIN_HOOKNUM)) {
-		ret = snprintf(buf + offset, len, " type %s hook %s prio %d",
+		ret = snprintf(buf + offset, remain, " type %s hook %s prio %d",
 			       c->type, nftnl_hooknum2str(c->family, c->hooknum),
 			       c->prio);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (c->flags & (1 << NFTNL_CHAIN_POLICY)) {
-			ret = snprintf(buf + offset, len, " policy %s",
+			ret = snprintf(buf + offset, remain, " policy %s",
 				       nftnl_verdict2str(c->policy));
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf + offset, len,
+		ret = snprintf(buf + offset, remain,
 			       " packets %"PRIu64" bytes %"PRIu64"",
 			       c->packets, c->bytes);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (c->flags & (1 << NFTNL_CHAIN_DEV)) {
-			ret = snprintf(buf + offset, len, " dev %s ", c->dev);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			ret = snprintf(buf + offset, remain, " dev %s ",
+				       c->dev);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 	}
 
@@ -824,27 +825,27 @@ static int nftnl_chain_cmd_snprintf(char *buf, size_t size,
 				    const struct nftnl_chain *c, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_chain_snprintf_default(buf+offset, len, c);
+		ret = nftnl_chain_snprintf_default(buf+offset, remain, c);
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		ret = nftnl_chain_export(buf+offset, len, c, type);
+		ret = nftnl_chain_export(buf+offset, remain, c, type);
 		break;
 	default:
 		return -1;
 	}
 
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr.c b/src/expr.c
index 10ba2c4..475ef6b 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -279,13 +279,13 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 			uint32_t type, uint32_t flags)
 {
 	int ret;
-	unsigned int offset = 0, len = size;
+	unsigned int offset = 0, remain = size;
 
 	if (!expr->ops->snprintf)
 		return 0;
 
-	ret = expr->ops->snprintf(buf+offset, len, type, flags, expr);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = expr->ops->snprintf(buf+offset, remain, type, flags, expr);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 0febc9d..865aaf0 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -233,22 +233,22 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 					       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "reg %u = (reg=%u & ",
+	ret = snprintf(buf, remain, "reg %u = (reg=%u & ",
 		       bitwise->dreg, bitwise->sreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf+offset, len, &bitwise->mask,
+	ret = nftnl_data_reg_snprintf(buf+offset, remain, &bitwise->mask,
 				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf+offset, len, ") ^ ");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, ") ^ ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf+offset, len, &bitwise->xor,
+	ret = nftnl_data_reg_snprintf(buf+offset, remain, &bitwise->xor,
 				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 3805307..47c04cf 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -258,12 +258,12 @@ static int nftnl_expr_byteorder_snprintf_default(char *buf, size_t size,
 						 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "reg %u = %s(reg %u, %u, %u) ",
+	ret = snprintf(buf, remain, "reg %u = %s(reg %u, %u, %u) ",
 		       byteorder->dreg, bo2str(byteorder->op),
 		       byteorder->sreg, byteorder->size, byteorder->len);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 353e907..8156d69 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -229,15 +229,15 @@ static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
 					   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "%s reg %u ",
+	ret = snprintf(buf, remain, "%s reg %u ",
 		       cmp2str(cmp->op), cmp->sreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf+offset, len, &cmp->data,
+	ret = nftnl_data_reg_snprintf(buf+offset, remain, &cmp->data,
 				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 676dfb6..82aad58 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -289,25 +289,25 @@ static int
 nftnl_expr_ct_snprintf_default(char *buf, size_t size,
 			       const struct nftnl_expr *e)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_CT_SREG)) {
 		ret = snprintf(buf, size, "set %s with reg %u ",
 				ctkey2str(ct->key), ct->sreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_CT_DREG)) {
-		ret = snprintf(buf, len, "load %s => reg %u ",
+		ret = snprintf(buf, remain, "load %s => reg %u ",
 			       ctkey2str(ct->key), ct->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_CT_DIR)) {
-		ret = snprintf(buf+offset, len, ", dir %s ",
+		ret = snprintf(buf+offset, remain, ", dir %s ",
 			       ctdir2str(ct->dir));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 0249258..3abe0df 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -101,34 +101,34 @@ nftnl_data_reg_value_snprintf_json(char *buf, size_t size,
 				   const union nftnl_data_reg *reg,
 				   uint32_t flags)
 {
-	int len = size, offset = 0, ret, i, j;
+	int remain = size, offset = 0, ret, i, j;
 	uint32_t utemp;
 	uint8_t *tmp;
 
-	ret = snprintf(buf, len, "\"reg\":{\"type\":\"value\",");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf, remain, "\"reg\":{\"type\":\"value\",");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf+offset, len, "\"len\":%u,", reg->len);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, "\"len\":%u,", reg->len);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf+offset, len, "\"data%d\":\"0x", i);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "\"data%d\":\"0x", i);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		utemp = htonl(reg->val[i]);
 		tmp = (uint8_t *)&utemp;
 
 		for (j = 0; j<sizeof(uint32_t); j++) {
-			ret = snprintf(buf+offset, len, "%.02x", tmp[j]);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			ret = snprintf(buf+offset, remain, "%.02x", tmp[j]);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf+offset, len, "\",");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "\",");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	offset--;
-	ret = snprintf(buf+offset, len, "}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, "}");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
@@ -138,11 +138,11 @@ nftnl_data_reg_value_snprintf_default(char *buf, size_t size,
 				      const union nftnl_data_reg *reg,
 				      uint32_t flags)
 {
-	int len = size, offset = 0, ret, i;
+	int remain = size, offset = 0, ret, i;
 
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf+offset, len, "0x%.8x ", reg->val[i]);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "0x%.8x ", reg->val[i]);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
@@ -153,14 +153,14 @@ nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
 				    const union nftnl_data_reg *reg,
 				    uint32_t flags)
 {
-	int len = size, offset = 0, ret = 0;
+	int remain = size, offset = 0, ret = 0;
 
 	ret = snprintf(buf, size, "%s ", nftnl_verdict2str(reg->verdict));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (reg->chain != NULL) {
-		ret = snprintf(buf+offset, len, "-> %s ", reg->chain);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "-> %s ", reg->chain);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
@@ -171,20 +171,20 @@ nftnl_data_reg_verdict_snprintf_json(char *buf, size_t size,
 				     const union nftnl_data_reg *reg,
 				     uint32_t flags)
 {
-	int len = size, offset = 0, ret = 0;
+	int remain = size, offset = 0, ret = 0;
 
 	ret = snprintf(buf, size, "\"reg\":{\"type\":\"verdict\","
 		       "\"verdict\":\"%s\"", nftnl_verdict2str(reg->verdict));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (reg->chain != NULL) {
-		ret = snprintf(buf+offset, len, ",\"chain\":\"%s\"",
+		ret = snprintf(buf+offset, remain, ",\"chain\":\"%s\"",
 			       reg->chain);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, "}");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 9aa332b..ed8e620 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -151,17 +151,17 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 					   const struct nftnl_expr *e,
 					   uint32_t flags)
 {
-	int size = len, offset = 0, ret;
+	int remain = len, offset = 0, ret;
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_ADDR)) {
 		ret = snprintf(buf + offset, len, "sreg_addr %u ", dup->sreg_addr);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_DEV)) {
 		ret = snprintf(buf + offset, len, "sreg_dev %u ", dup->sreg_dev);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index f7b99ea..68fa14e 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -276,34 +276,35 @@ nftnl_expr_dynset_snprintf_default(char *buf, size_t size,
 {
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 	struct nftnl_expr *expr;
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "%s reg_key %u set %s ",
+	ret = snprintf(buf, remain, "%s reg_key %u set %s ",
 		       op2str(dynset->op), dynset->sreg_key, dynset->set_name);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->flags & (1 << NFTNL_EXPR_DYNSET_SREG_DATA)) {
-		ret = snprintf(buf+offset, len, "sreg_data %u ", dynset->sreg_data);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "sreg_data %u ",
+			       dynset->sreg_data);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (e->flags & (1 << NFTNL_EXPR_DYNSET_TIMEOUT)) {
-		ret = snprintf(buf+offset, len, "timeout %"PRIu64"ms ",
+		ret = snprintf(buf+offset, remain, "timeout %"PRIu64"ms ",
 			       dynset->timeout);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (e->flags & (1 << NFTNL_EXPR_DYNSET_EXPR)) {
 		expr = dynset->expr;
-		ret = snprintf(buf+offset, len, "expr [ %s ",
+		ret = snprintf(buf+offset, remain, "expr [ %s ",
 			       expr->ops->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_expr_snprintf(buf+offset, len, expr,
+		ret = nftnl_expr_snprintf(buf+offset, remain, expr,
 					     NFTNL_OUTPUT_DEFAULT,
 					     NFTNL_OF_EVENT_ANY);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = snprintf(buf+offset, len, "] ");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "] ");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/fib.c b/src/expr/fib.c
index f3be081..b922b26 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -172,7 +172,7 @@ nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 				const struct nftnl_expr *e)
 {
 	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
-	int len = size, offset = 0, ret, i;
+	int remain = size, offset = 0, ret, i;
 	uint32_t flags = fib->flags & ~NFTA_FIB_F_PRESENT;
 	uint32_t present_flag = fib->flags & NFTA_FIB_F_PRESENT;
 	static const struct {
@@ -188,27 +188,29 @@ nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 
 	for (i = 0; i < (sizeof(tab) / sizeof(tab[0])); i++) {
 		if (flags & tab[i].bit) {
-			ret = snprintf(buf + offset, len, "%s ", tab[i].name);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			ret = snprintf(buf + offset, remain, "%s ",
+				       tab[i].name);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 			flags &= ~tab[i].bit;
 			if (flags) {
-				ret = snprintf(buf + offset, len, ". ");
-				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+				ret = snprintf(buf + offset, remain, ". ");
+				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 		}
 	}
 
 	if (flags) {
-		ret = snprintf(buf + offset, len, "unknown 0x%" PRIx32, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "unknown 0x%" PRIx32,
+			       flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = snprintf(buf + offset, len, "%s%s => reg %d ",
+	ret = snprintf(buf + offset, remain, "%s%s => reg %d ",
 		       fib_type_str(fib->result),
 		       present_flag ? " present" : "",
 		       fib->dreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index c30d494..1312ea1 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -132,12 +132,13 @@ static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
 					   const struct nftnl_expr *e,
 					   uint32_t flags)
 {
-	int size = len, offset = 0, ret;
+	int remain = len, offset = 0, ret;
 	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_FWD_SREG_DEV)) {
-		ret = snprintf(buf + offset, len, "sreg_dev %u ", fwd->sreg_dev);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "sreg_dev %u ",
+			       fwd->sreg_dev);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/hash.c b/src/expr/hash.c
index d870510..fcc4fa5 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -229,29 +229,31 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 				 const struct nftnl_expr *e)
 {
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 
 	switch (hash->type) {
 	case NFT_HASH_SYM:
 		ret =
-		snprintf(buf, len, "reg %u = symhash() %% mod %u ", hash->dreg,
+		snprintf(buf, remain, "reg %u = symhash() %% mod %u ",
+			 hash->dreg,
 			 hash->modulus);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		break;
 	case NFT_HASH_JENKINS:
 	default:
 		ret =
-		snprintf(buf, len,
+		snprintf(buf, remain,
 			 "reg %u = jhash(reg %u, %u, 0x%x) %% mod %u ",
 			 hash->dreg, hash->sreg, hash->len, hash->seed,
 			 hash->modulus);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		break;
 	}
 
 	if (hash->offset) {
-		ret = snprintf(buf + offset, len, "offset %u ", hash->offset);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "offset %u ",
+			       hash->offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 0b188cc..8a858da 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -233,26 +233,26 @@ nftnl_expr_immediate_snprintf_default(char *buf, size_t len,
 				      const struct nftnl_expr *e,
 				      uint32_t flags)
 {
-	int size = len, offset = 0, ret;
+	int remain = len, offset = 0, ret;
 	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
 
-	ret = snprintf(buf, len, "reg %u ", imm->dreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf, remain, "reg %u ", imm->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->flags & (1 << NFTNL_EXPR_IMM_DATA)) {
-		ret = nftnl_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nftnl_data_reg_snprintf(buf+offset, remain, &imm->data,
 					NFTNL_OUTPUT_DEFAULT, flags, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
-		ret = nftnl_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nftnl_data_reg_snprintf(buf+offset, remain, &imm->data,
 				NFTNL_OUTPUT_DEFAULT, flags, DATA_VERDICT);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	} else if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN)) {
-		ret = nftnl_data_reg_snprintf(buf+offset, len, &imm->data,
+		ret = nftnl_data_reg_snprintf(buf+offset, remain, &imm->data,
 					NFTNL_OUTPUT_DEFAULT, flags, DATA_CHAIN);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/log.c b/src/expr/log.c
index b642255..86d9651 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -229,44 +229,45 @@ static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
 					   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_log *log = nftnl_expr_data(e);
-	int ret, offset = 0, len = size;
+	int ret, offset = 0, remain = size;
 
 	if (e->flags & (1 << NFTNL_EXPR_LOG_PREFIX)) {
-		ret = snprintf(buf, len, "prefix %s ", log->prefix);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf, remain, "prefix %s ", log->prefix);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_LOG_GROUP)) {
-		ret = snprintf(buf + offset, len,
+		ret = snprintf(buf + offset, remain,
 			       "group %u snaplen %u qthreshold %u ",
 			       log->group, log->snaplen, log->qthreshold);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	} else {
 		if (e->flags & (1 << NFTNL_EXPR_LOG_LEVEL)) {
-			ret = snprintf(buf + offset, len, "level %u ",
+			ret = snprintf(buf + offset, remain, "level %u ",
 				       log->level);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 		if (e->flags & (1 << NFTNL_EXPR_LOG_FLAGS)) {
 			if (log->flags & NF_LOG_TCPSEQ) {
-				ret = snprintf(buf + offset, len, "tcpseq ");
-				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+				ret = snprintf(buf + offset, remain, "tcpseq ");
+				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 			if (log->flags & NF_LOG_TCPOPT) {
-				ret = snprintf(buf + offset, len, "tcpopt ");
-				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+				ret = snprintf(buf + offset, remain, "tcpopt ");
+				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 			if (log->flags & NF_LOG_IPOPT) {
-				ret = snprintf(buf + offset, len, "ipopt ");
-				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+				ret = snprintf(buf + offset, remain, "ipopt ");
+				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 			if (log->flags & NF_LOG_UID) {
-				ret = snprintf(buf + offset, len, "uid ");
-				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+				ret = snprintf(buf + offset, remain, "uid ");
+				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 			if (log->flags & NF_LOG_MACDECODE) {
-				ret = snprintf(buf + offset, len, "macdecode ");
-				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+				ret = snprintf(buf + offset, remain,
+					       "macdecode ");
+				SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			}
 		}
 	}
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 861815f..e5adfd4 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -219,20 +219,20 @@ static int
 nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
 				   const struct nftnl_expr *e)
 {
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 	struct nftnl_expr_lookup *l = nftnl_expr_data(e);
 
-	ret = snprintf(buf, len, "reg %u set %s ", l->sreg, l->set_name);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf, remain, "reg %u set %s ", l->sreg, l->set_name);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_DREG)) {
-		ret = snprintf(buf+offset, len, "dreg %u ", l->dreg);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "dreg %u ", l->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_FLAGS)) {
-		ret = snprintf(buf + offset, len, "0x%x ", l->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "0x%x ", l->flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 29bc3a2..ac189e6 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -304,31 +304,32 @@ nftnl_expr_nat_snprintf_default(char *buf, size_t size,
 				const struct nftnl_expr *e)
 {
 	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
-	int len = size, offset = 0, ret = 0;
+	int remain = size, offset = 0, ret = 0;
 
-	ret = snprintf(buf, len, "%s ", nat2str(nat->type));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf, remain, "%s ", nat2str(nat->type));
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf+offset, len, "%s ", nftnl_family2str(nat->family));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, "%s ",
+		       nftnl_family2str(nat->family));
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_ADDR_MIN)) {
-		ret = snprintf(buf+offset, len,
+		ret = snprintf(buf+offset, remain,
 			       "addr_min reg %u addr_max reg %u ",
 			       nat->sreg_addr_min, nat->sreg_addr_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_MIN)) {
-		ret = snprintf(buf+offset, len,
+		ret = snprintf(buf+offset, remain,
 			       "proto_min reg %u proto_max reg %u ",
 			       nat->sreg_proto_min, nat->sreg_proto_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_NAT_FLAGS)) {
-		ret = snprintf(buf+offset, len, "flags %u", nat->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "flags %u", nat->flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index a15f03a..1369b01 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -176,26 +176,26 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 			       const struct nftnl_expr *e)
 {
 	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
-		ret = snprintf(buf, len, "reg %u = inc mod %u ",
+		ret = snprintf(buf, remain, "reg %u = inc mod %u ",
 			       ng->dreg, ng->modulus);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		break;
 	case NFT_NG_RANDOM:
-		ret = snprintf(buf, len, "reg %u = random mod %u ",
+		ret = snprintf(buf, remain, "reg %u = random mod %u ",
 			       ng->dreg, ng->modulus);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		break;
 	default:
 		return 0;
 	}
 
 	if (ng->offset) {
-		ret = snprintf(buf + offset, len, "offset %u ", ng->offset);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "offset %u ", ng->offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 8a9deda..f62db9f 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -176,38 +176,38 @@ static int nftnl_expr_queue_snprintf_default(char *buf, size_t len,
 					     const struct nftnl_expr *e)
 {
 	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
-	int ret, size = len, offset = 0;
+	int ret, remain = len, offset = 0;
 	uint16_t total_queues;
 
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_NUM)) {
 		total_queues = queue->queuenum + queue->queues_total - 1;
 
 		ret = snprintf(buf + offset, len, "num %u", queue->queuenum);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (queue->queues_total && total_queues != queue->queuenum) {
 			ret = snprintf(buf + offset, len, "-%u", total_queues);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
 		ret = snprintf(buf + offset, len, " ");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_QNUM)) {
 		ret = snprintf(buf + offset, len, "sreg_qnum %u ",
 			       queue->sreg_qnum);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS)) {
 		if (queue->flags & (NFT_QUEUE_FLAG_BYPASS)) {
 			ret = snprintf(buf + offset, len, "bypass ");
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 		if (queue->flags & (NFT_QUEUE_FLAG_CPU_FANOUT)) {
 			ret = snprintf(buf + offset, len, "fanout ");
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 	}
 	return offset;
diff --git a/src/expr/range.c b/src/expr/range.c
index 8c8ce12..b2789ff 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -243,19 +243,19 @@ static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
 					   const struct nftnl_expr *e)
 {
 	struct nftnl_expr_range *range = nftnl_expr_data(e);
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "%s reg %u ",
+	ret = snprintf(buf, remain, "%s reg %u ",
 		       expr_range_str[range->op], range->sreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, len, &range->data_from,
+	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_from,
 				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, len, &range->data_to,
+	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_to,
 				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 43538d5..b2aa345 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -176,25 +176,25 @@ static int nftnl_expr_redir_export(char *buf, size_t size,
 static int nftnl_expr_redir_snprintf_default(char *buf, size_t len,
 					     const struct nftnl_expr *e)
 {
-	int ret, size = len, offset = 0;
+	int ret, remain = len, offset = 0;
 	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_REG_PROTO_MIN)) {
 		ret = snprintf(buf + offset, len, "proto_min reg %u ",
 			       redir->sreg_proto_min);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_REG_PROTO_MAX)) {
 		ret = snprintf(buf + offset, len, "proto_max reg %u ",
 			       redir->sreg_proto_max);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_REDIR_FLAGS)) {
-		ret = snprintf(buf + offset , len, "flags 0x%x ",
+		ret = snprintf(buf + offset, len, "flags 0x%x ",
 			       redir->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
diff --git a/src/gen.c b/src/gen.c
index 213562e..e1d5280 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -166,22 +166,22 @@ static int nftnl_gen_cmd_snprintf(char *buf, size_t size,
 				  const struct nftnl_gen *gen, uint32_t cmd,
 				  uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_gen_snprintf_default(buf + offset, len, gen);
+		ret = nftnl_gen_snprintf_default(buf + offset, remain, gen);
 		break;
 	default:
 		return -1;
 	}
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/object.c b/src/object.c
index 9dc5b41..d15ec10 100644
--- a/src/object.c
+++ b/src/object.c
@@ -425,18 +425,19 @@ static int nftnl_obj_snprintf_dflt(char *buf, size_t size,
 				   uint32_t type, uint32_t flags)
 {
 	const char *name = obj->ops ? obj->ops->name : "(unknown)";
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
 	ret = snprintf(buf, size, "table %s name %s use %u [ %s ",
 		       obj->table, obj->name, obj->use, name);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (obj->ops) {
-		ret = obj->ops->snprintf(buf + offset, offset, type, flags, obj);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = obj->ops->snprintf(buf + offset, offset, type, flags,
+					 obj);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	ret = snprintf(buf + offset, offset, "]");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
@@ -445,27 +446,27 @@ static int nftnl_obj_cmd_snprintf(char *buf, size_t size,
 				    const struct nftnl_obj *obj, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_obj_snprintf_dflt(buf + offset, len, obj, type,
+		ret = nftnl_obj_snprintf_dflt(buf + offset, remain, obj, type,
 					      flags);
 		break;
 	case NFTNL_OUTPUT_JSON:
-		ret = nftnl_obj_export(buf + offset, len, obj, type, flags);
+		ret = nftnl_obj_export(buf + offset, remain, obj, type, flags);
 		break;
 	case NFTNL_OUTPUT_XML:
 	default:
 		return -1;
 	}
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/rule.c b/src/rule.c
index 6c22141..5df8216 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -714,71 +714,71 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 				       uint32_t type, uint32_t flags)
 {
 	struct nftnl_expr *expr;
-	int ret, len = size, offset = 0, i;
+	int ret, remain = size, offset = 0, i;
 
 	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
-		ret = snprintf(buf+offset, len, "%s ",
+		ret = snprintf(buf+offset, remain, "%s ",
 			       nftnl_family2str(r->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_TABLE)) {
-		ret = snprintf(buf+offset, len, "%s ",
+		ret = snprintf(buf+offset, remain, "%s ",
 			       r->table);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_CHAIN)) {
-		ret = snprintf(buf+offset, len, "%s ",
+		ret = snprintf(buf+offset, remain, "%s ",
 			       r->chain);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (r->flags & (1 << NFTNL_RULE_HANDLE)) {
-		ret = snprintf(buf+offset, len, "%llu ",
+		ret = snprintf(buf+offset, remain, "%llu ",
 			       (unsigned long long)r->handle);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_POSITION)) {
-		ret = snprintf(buf+offset, len, "%llu ",
+		ret = snprintf(buf+offset, remain, "%llu ",
 			       (unsigned long long)r->position);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_ID)) {
-		ret = snprintf(buf + offset, len, "%u ", r->id);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "%u ", r->id);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "\n");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, "\n");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	list_for_each_entry(expr, &r->expr_list, head) {
-		ret = snprintf(buf+offset, len, "  [ %s ", expr->ops->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "  [ %s ", expr->ops->name);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_expr_snprintf(buf+offset, len, expr,
+		ret = nftnl_expr_snprintf(buf+offset, remain, expr,
 					     type, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = snprintf(buf+offset, len, "]\n");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "]\n");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (r->user.len) {
-		ret = snprintf(buf+offset, len, "  userdata = { ");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "  userdata = { ");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		for (i = 0; i < r->user.len; i++) {
 			char *c = r->user.data;
 
-			ret = snprintf(buf+offset, len, "%c",
+			ret = snprintf(buf+offset, remain, "%c",
 				       isalnum(c[i]) ? c[i] : 0);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf+offset, len, " }\n");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, " }\n");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	}
 
@@ -789,21 +789,21 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 				   const struct nftnl_rule *r, uint32_t cmd,
 				   uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 	uint32_t inner_flags = flags;
 
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_rule_snprintf_default(buf+offset, len, r, type,
+		ret = nftnl_rule_snprintf_default(buf+offset, remain, r, type,
 						inner_flags);
 		break;
 	case NFTNL_OUTPUT_JSON:
-		ret = nftnl_rule_export(buf+offset, len, r, type,
+		ret = nftnl_rule_export(buf+offset, remain, r, type,
 					     inner_flags);
 		break;
 	case NFTNL_OUTPUT_XML:
@@ -811,10 +811,10 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 		return -1;
 	}
 
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/ruleset.c b/src/ruleset.c
index 6ef2956..aa23395 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -729,7 +729,7 @@ nftnl_ruleset_snprintf_table(char *buf, size_t size,
 {
 	struct nftnl_table *t;
 	struct nftnl_table_list_iter *ti;
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
 	ti = nftnl_table_list_iter_create(rs->table_list);
 	if (ti == NULL)
@@ -737,14 +737,14 @@ nftnl_ruleset_snprintf_table(char *buf, size_t size,
 
 	t = nftnl_table_list_iter_next(ti);
 	while (t != NULL) {
-		ret = nftnl_table_snprintf(buf+offset, len, t, type, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nftnl_table_snprintf(buf+offset, remain, t, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		t = nftnl_table_list_iter_next(ti);
 
-		ret = snprintf(buf+offset, len, "%s",
+		ret = snprintf(buf+offset, remain, "%s",
 			       nftnl_ruleset_o_separator(t, type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	nftnl_table_list_iter_destroy(ti);
 
@@ -758,7 +758,7 @@ nftnl_ruleset_snprintf_chain(char *buf, size_t size,
 {
 	struct nftnl_chain *c;
 	struct nftnl_chain_list_iter *ci;
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
 	ci = nftnl_chain_list_iter_create(rs->chain_list);
 	if (ci == NULL)
@@ -766,14 +766,14 @@ nftnl_ruleset_snprintf_chain(char *buf, size_t size,
 
 	c = nftnl_chain_list_iter_next(ci);
 	while (c != NULL) {
-		ret = nftnl_chain_snprintf(buf+offset, len, c, type, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nftnl_chain_snprintf(buf+offset, remain, c, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		c = nftnl_chain_list_iter_next(ci);
 
-		ret = snprintf(buf+offset, len, "%s",
+		ret = snprintf(buf+offset, remain, "%s",
 			       nftnl_ruleset_o_separator(c, type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	nftnl_chain_list_iter_destroy(ci);
 
@@ -787,7 +787,7 @@ nftnl_ruleset_snprintf_set(char *buf, size_t size,
 {
 	struct nftnl_set *s;
 	struct nftnl_set_list_iter *si;
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
 	si = nftnl_set_list_iter_create(rs->set_list);
 	if (si == NULL)
@@ -795,14 +795,14 @@ nftnl_ruleset_snprintf_set(char *buf, size_t size,
 
 	s = nftnl_set_list_iter_next(si);
 	while (s != NULL) {
-		ret = nftnl_set_snprintf(buf+offset, len, s, type, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nftnl_set_snprintf(buf+offset, remain, s, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		s = nftnl_set_list_iter_next(si);
 
-		ret = snprintf(buf+offset, len, "%s",
+		ret = snprintf(buf+offset, remain, "%s",
 			       nftnl_ruleset_o_separator(s, type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	nftnl_set_list_iter_destroy(si);
 
@@ -816,7 +816,7 @@ nftnl_ruleset_snprintf_rule(char *buf, size_t size,
 {
 	struct nftnl_rule *r;
 	struct nftnl_rule_list_iter *ri;
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
 	ri = nftnl_rule_list_iter_create(rs->rule_list);
 	if (ri == NULL)
@@ -824,14 +824,14 @@ nftnl_ruleset_snprintf_rule(char *buf, size_t size,
 
 	r = nftnl_rule_list_iter_next(ri);
 	while (r != NULL) {
-		ret = nftnl_rule_snprintf(buf+offset, len, r, type, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nftnl_rule_snprintf(buf+offset, remain, r, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		r = nftnl_rule_list_iter_next(ri);
 
-		ret = snprintf(buf+offset, len, "%s",
+		ret = snprintf(buf+offset, remain, "%s",
 			       nftnl_ruleset_o_separator(r, type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	nftnl_rule_list_iter_destroy(ri);
 
@@ -842,24 +842,25 @@ static int
 nftnl_ruleset_do_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs,
 			uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 	void *prev = NULL;
 	uint32_t inner_flags = flags;
 
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
-	ret = snprintf(buf + offset, len, "%s", nftnl_ruleset_o_opentag(type));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf + offset, remain, "%s",
+		       nftnl_ruleset_o_opentag(type));
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (nftnl_ruleset_is_set(rs, NFTNL_RULESET_TABLELIST) &&
 	    (!nftnl_table_list_is_empty(rs->table_list))) {
-		ret = nftnl_ruleset_snprintf_table(buf+offset, len, rs,
+		ret = nftnl_ruleset_snprintf_table(buf+offset, remain, rs,
 						 type, inner_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (ret > 0)
 			prev = rs->table_list;
@@ -867,13 +868,13 @@ nftnl_ruleset_do_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs
 
 	if (nftnl_ruleset_is_set(rs, NFTNL_RULESET_CHAINLIST) &&
 	    (!nftnl_chain_list_is_empty(rs->chain_list))) {
-		ret = snprintf(buf+offset, len, "%s",
+		ret = snprintf(buf+offset, remain, "%s",
 			       nftnl_ruleset_o_separator(prev, type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_ruleset_snprintf_chain(buf+offset, len, rs,
+		ret = nftnl_ruleset_snprintf_chain(buf+offset, remain, rs,
 						 type, inner_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (ret > 0)
 			prev = rs->chain_list;
@@ -881,13 +882,13 @@ nftnl_ruleset_do_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs
 
 	if (nftnl_ruleset_is_set(rs, NFTNL_RULESET_SETLIST) &&
 	    (!nftnl_set_list_is_empty(rs->set_list))) {
-		ret = snprintf(buf+offset, len, "%s",
+		ret = snprintf(buf+offset, remain, "%s",
 			       nftnl_ruleset_o_separator(prev, type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_ruleset_snprintf_set(buf+offset, len, rs,
+		ret = nftnl_ruleset_snprintf_set(buf+offset, remain, rs,
 					       type, inner_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (ret > 0)
 			prev = rs->set_list;
@@ -895,20 +896,21 @@ nftnl_ruleset_do_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs
 
 	if (nftnl_ruleset_is_set(rs, NFTNL_RULESET_RULELIST) &&
 	    (!nftnl_rule_list_is_empty(rs->rule_list))) {
-		ret = snprintf(buf+offset, len, "%s",
+		ret = snprintf(buf+offset, remain, "%s",
 			       nftnl_ruleset_o_separator(prev, type));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_ruleset_snprintf_rule(buf+offset, len, rs,
+		ret = nftnl_ruleset_snprintf_rule(buf+offset, remain, rs,
 						type, inner_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf + offset, len, "%s", nftnl_ruleset_o_closetag(type));
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf + offset, remain, "%s",
+		       nftnl_ruleset_o_closetag(type));
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/set.c b/src/set.c
index 1158e38..720177b 100644
--- a/src/set.c
+++ b/src/set.c
@@ -738,95 +738,96 @@ static int nftnl_set_snprintf_json(char *buf, size_t size,
 				   const struct nftnl_set *s,
 				   uint32_t type, uint32_t flags)
 {
-	int len = size, offset = 0, ret;
+	int remain = size, offset = 0, ret;
 	struct nftnl_set_elem *elem;
 
-	ret = snprintf(buf, len, "{\"set\":{");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf, remain, "{\"set\":{");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (s->flags & (1 << NFTNL_SET_NAME)) {
-		ret = snprintf(buf + offset, len, "\"name\":\"%s\"",
+		ret = snprintf(buf + offset, remain, "\"name\":\"%s\"",
 			       s->name);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (s->flags & (1 << NFTNL_SET_TABLE)) {
-		ret = snprintf(buf + offset, len, ",\"table\":\"%s\"",
+		ret = snprintf(buf + offset, remain, ",\"table\":\"%s\"",
 			       s->table);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (s->flags & (1 << NFTNL_SET_FLAGS)) {
-		ret = snprintf(buf + offset, len, ",\"flags\":%u",
+		ret = snprintf(buf + offset, remain, ",\"flags\":%u",
 			       s->set_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (s->flags & (1 << NFTNL_SET_FAMILY)) {
-		ret = snprintf(buf + offset, len, ",\"family\":\"%s\"",
+		ret = snprintf(buf + offset, remain, ",\"family\":\"%s\"",
 			       nftnl_family2str(s->family));
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (s->flags & (1 << NFTNL_SET_KEY_TYPE)) {
-		ret = snprintf(buf + offset, len, ",\"key_type\":%u",
+		ret = snprintf(buf + offset, remain, ",\"key_type\":%u",
 			       s->key_type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (s->flags & (1 << NFTNL_SET_KEY_LEN)) {
-		ret = snprintf(buf + offset, len, ",\"key_len\":%u",
+		ret = snprintf(buf + offset, remain, ",\"key_len\":%u",
 			       s->key_len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if(s->flags & (1 << NFTNL_SET_DATA_TYPE)) {
-		ret = snprintf(buf + offset, len,
+		ret = snprintf(buf + offset, remain,
 				  ",\"data_type\":%u", s->data_type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if(s->flags & (1 << NFTNL_SET_DATA_LEN)) {
-		ret = snprintf(buf + offset, len, ",\"data_len\":%u", s->data_len);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, ",\"data_len\":%u",
+			       s->data_len);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	if (s->flags & (1 << NFTNL_SET_OBJ_TYPE)) {
-		ret = snprintf(buf + offset, len,
+		ret = snprintf(buf + offset, remain,
 				  ",\"obj_type\":%u", s->obj_type);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (s->flags & (1 << NFTNL_SET_POLICY)) {
-		ret = snprintf(buf + offset, len, ",\"policy\":%u",
+		ret = snprintf(buf + offset, remain, ",\"policy\":%u",
 			       s->policy);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (s->flags & (1 << NFTNL_SET_DESC_SIZE)) {
-		ret = snprintf(buf + offset, len, ",\"desc_size\":%u",
+		ret = snprintf(buf + offset, remain, ",\"desc_size\":%u",
 			       s->desc.size);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list)){
-		ret = snprintf(buf + offset, len, "}}");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "}}");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		return offset;
 	}
 
-	ret = snprintf(buf + offset, len, ",\"set_elem\":[");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf + offset, remain, ",\"set_elem\":[");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	list_for_each_entry(elem, &s->element_list, head) {
-		ret = snprintf(buf + offset, len, "{");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "{");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_set_elem_snprintf(buf + offset, len, elem, type,
+		ret = nftnl_set_elem_snprintf(buf + offset, remain, elem, type,
 					    flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = snprintf(buf + offset, len, "},");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "},");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	/* Overwrite trailing ", " from last set element */
 	offset --;
 
-	ret = snprintf(buf + offset, len, "]}}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf + offset, remain, "]}}");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
@@ -836,48 +837,49 @@ static int nftnl_set_snprintf_default(char *buf, size_t size,
 				      uint32_t type, uint32_t flags)
 {
 	int ret;
-	int len = size, offset = 0;
+	int remain = size, offset = 0;
 	struct nftnl_set_elem *elem;
 
-	ret = snprintf(buf, len, "%s %s %x",
+	ret = snprintf(buf, remain, "%s %s %x",
 			s->name, s->table, s->set_flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (s->flags & (1 << NFTNL_SET_TIMEOUT)) {
-		ret = snprintf(buf + offset, len, " timeout %"PRIu64"ms",
+		ret = snprintf(buf + offset, remain, " timeout %"PRIu64"ms",
 			       s->timeout);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (s->flags & (1 << NFTNL_SET_GC_INTERVAL)) {
-		ret = snprintf(buf + offset, len, " gc_interval %ums",
+		ret = snprintf(buf + offset, remain, " gc_interval %ums",
 			       s->gc_interval);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (s->flags & (1 << NFTNL_SET_POLICY)) {
-		ret = snprintf(buf + offset, len, " policy %u", s->policy);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, " policy %u", s->policy);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (s->flags & (1 << NFTNL_SET_DESC_SIZE)) {
-		ret = snprintf(buf + offset, len, " size %u", s->desc.size);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, " size %u", s->desc.size);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list))
 		return offset;
 
-	ret = snprintf(buf+offset, len, "\n");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, "\n");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	list_for_each_entry(elem, &s->element_list, head) {
-		ret = snprintf(buf+offset, len, "\t");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "\t");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_set_elem_snprintf(buf+offset, len, elem, type, flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = nftnl_set_elem_snprintf(buf+offset, remain, elem, type,
+					      flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
@@ -887,7 +889,7 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 				  const struct nftnl_set *s, uint32_t cmd,
 				  uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 	uint32_t inner_flags = flags;
 
 	if (type == NFTNL_OUTPUT_XML)
@@ -896,26 +898,26 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 	/* prevent set_elems to print as events */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_set_snprintf_default(buf+offset, len, s, type,
+		ret = nftnl_set_snprintf_default(buf+offset, remain, s, type,
 					       inner_flags);
 		break;
 	case NFTNL_OUTPUT_JSON:
-		ret = nftnl_set_snprintf_json(buf+offset, len, s, type,
+		ret = nftnl_set_snprintf_json(buf+offset, remain, s, type,
 					    inner_flags);
 		break;
 	default:
 		return -1;
 	}
 
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/set_elem.c b/src/set_elem.c
index 433b896..40fbf33 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -605,22 +605,22 @@ static int nftnl_set_elem_snprintf_json(char *buf, size_t size,
 					const struct nftnl_set_elem *e,
 					uint32_t flags)
 {
-	int ret, len = size, offset = 0, type = -1;
+	int ret, remain = size, offset = 0, type = -1;
 
 	if (e->flags & (1 << NFTNL_SET_ELEM_FLAGS)) {
-		ret = snprintf(buf, len, "\"flags\":%u,", e->set_elem_flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf, remain, "\"flags\":%u,", e->set_elem_flags);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = snprintf(buf + offset, len, "\"key\":{");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf + offset, remain, "\"key\":{");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, len, &e->key,
+	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key,
 				    NFTNL_OUTPUT_JSON, flags, DATA_VALUE);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf + offset, len, "}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf + offset, remain, "}");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->flags & (1 << NFTNL_SET_ELEM_DATA))
 		type = DATA_VALUE;
@@ -630,15 +630,15 @@ static int nftnl_set_elem_snprintf_json(char *buf, size_t size,
 		type = DATA_VERDICT;
 
 	if (type != -1) {
-		ret = snprintf(buf + offset, len, ",\"data\":{");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, ",\"data\":{");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_data_reg_snprintf(buf + offset, len, &e->data,
+		ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
 					    NFTNL_OUTPUT_JSON, flags, type);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = snprintf(buf + offset, len, "}");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf + offset, remain, "}");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
@@ -647,41 +647,41 @@ static int nftnl_set_elem_snprintf_json(char *buf, size_t size,
 static int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 					   const struct nftnl_set_elem *e)
 {
-	int ret, len = size, offset = 0, i;
+	int ret, remain = size, offset = 0, i;
 
-	ret = snprintf(buf, len, "element ");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf, remain, "element ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	for (i = 0; i < div_round_up(e->key.len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf+offset, len, "%.8x ", e->key.val[i]);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "%.8x ", e->key.val[i]);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = snprintf(buf+offset, len, " : ");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, " : ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	for (i = 0; i < div_round_up(e->data.len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf+offset, len, "%.8x ", e->data.val[i]);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "%.8x ", e->data.val[i]);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "%u [end]", e->set_elem_flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = snprintf(buf+offset, remain, "%u [end]", e->set_elem_flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->user.len) {
-		ret = snprintf(buf+offset, len, "  userdata = {");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, "  userdata = {");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		for (i = 0; i < e->user.len; i++) {
 			char *c = e->user.data;
 
-			ret = snprintf(buf+offset, len, "%c",
+			ret = snprintf(buf+offset, remain, "%c",
 				       isalnum(c[i]) ? c[i] : 0);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf+offset, len, " }\n");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		ret = snprintf(buf+offset, remain, " }\n");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
@@ -692,29 +692,30 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 				       uint32_t cmd, uint32_t type,
 				       uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
 	if (type == NFTNL_OUTPUT_XML)
 		return 0;
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_set_elem_snprintf_default(buf+offset, len, e);
+		ret = nftnl_set_elem_snprintf_default(buf+offset, remain, e);
 		break;
 	case NFTNL_OUTPUT_JSON:
-		ret = nftnl_set_elem_snprintf_json(buf+offset, len, e, flags);
+		ret = nftnl_set_elem_snprintf_json(buf+offset, remain, e,
+						   flags);
 		break;
 	default:
 		return -1;
 	}
 
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
diff --git a/src/table.c b/src/table.c
index a7d5a8f..d426bcb 100644
--- a/src/table.c
+++ b/src/table.c
@@ -376,26 +376,26 @@ static int nftnl_table_cmd_snprintf(char *buf, size_t size,
 				    const struct nftnl_table *t, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, remain = size, offset = 0;
 
-	ret = nftnl_cmd_header_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_table_snprintf_default(buf+offset, len, t);
+		ret = nftnl_table_snprintf_default(buf+offset, remain, t);
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
-		ret = nftnl_table_export(buf+offset, len, t, type);
+		ret = nftnl_table_export(buf+offset, remain, t, type);
 		break;
 	default:
 		return -1;
 	}
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_cmd_footer_snprintf(buf + offset, len, cmd, type, flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	ret = nftnl_cmd_footer_snprintf(buf + offset, remain, cmd, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
 }
-- 
2.13.5

