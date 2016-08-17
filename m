From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/3 v5 libnftnl] Implement rule comparison
Date: Wed, 17 Aug 2016 13:00:08 +0200
Message-ID: <20160817110010.28943-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:52912 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbcHQLAx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 07:00:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements the function 'bool nftnl_rule_cmp(const struct
nftnl_rule *r, const struct nftnl_rule *r2)' for rule comparison.

Expressions within rules need to be compared, so also has been created the
function 'nftnl_expr_cmp' which calls new field within
'nfntl_expr_<expression>': a function pointer to a comparator.

Also includes all expression comparators.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 include/data_reg.h      |  3 +++
 include/expr_ops.h      |  1 +
 include/libnftnl/expr.h |  2 ++
 include/libnftnl/rule.h |  2 ++
 src/expr.c              | 11 +++++++++++
 src/expr/bitwise.c      | 22 ++++++++++++++++++++++
 src/expr/byteorder.c    | 22 ++++++++++++++++++++++
 src/expr/cmp.c          | 18 ++++++++++++++++++
 src/expr/counter.c      | 16 ++++++++++++++++
 src/expr/ct.c           | 20 ++++++++++++++++++++
 src/expr/data_reg.c     | 16 ++++++++++++++++
 src/expr/dup.c          | 16 ++++++++++++++++
 src/expr/dynset.c       | 26 ++++++++++++++++++++++++++
 src/expr/exthdr.c       | 20 ++++++++++++++++++++
 src/expr/fwd.c          | 14 ++++++++++++++
 src/expr/immediate.c    | 18 ++++++++++++++++++
 src/expr/limit.c        | 22 ++++++++++++++++++++++
 src/expr/log.c          | 24 ++++++++++++++++++++++++
 src/expr/lookup.c       | 22 ++++++++++++++++++++++
 src/expr/masq.c         | 18 ++++++++++++++++++
 src/expr/match.c        | 20 ++++++++++++++++++++
 src/expr/meta.c         | 18 ++++++++++++++++++
 src/expr/nat.c          | 25 +++++++++++++++++++++++++
 src/expr/payload.c      | 26 ++++++++++++++++++++++++++
 src/expr/queue.c        | 18 ++++++++++++++++++
 src/expr/redir.c        | 18 ++++++++++++++++++
 src/expr/reject.c       | 16 ++++++++++++++++
 src/expr/target.c       | 20 ++++++++++++++++++++
 src/libnftnl.map        |  5 +++++
 src/rule.c              | 30 ++++++++++++++++++++++++++++++
 30 files changed, 509 insertions(+)

diff --git a/include/data_reg.h b/include/data_reg.h
index e749b5b..3fec7cd 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -3,6 +3,7 @@
 
 #include <linux/netfilter/nf_tables.h>
 #include <stdint.h>
+#include <stdbool.h>
 #include <unistd.h>
 
 enum {
@@ -27,6 +28,8 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    const union nftnl_data_reg *reg,
 			    uint32_t output_format, uint32_t flags,
 			    int reg_type);
+bool nftnl_data_reg_cmp(const union nftnl_data_reg *r1,
+		        const union nftnl_data_reg *r2, int reg_type);
 struct nlattr;
 
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
diff --git a/include/expr_ops.h b/include/expr_ops.h
index 3c0cb18..a334732 100644
--- a/include/expr_ops.h
+++ b/include/expr_ops.h
@@ -13,6 +13,7 @@ struct expr_ops {
 	uint32_t alloc_len;
 	int	max_attr;
 	void	(*free)(const struct nftnl_expr *e);
+	bool    (*cmp)(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
 	int	(*set)(struct nftnl_expr *e, uint16_t type, const void *data, uint32_t data_len);
 	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
 	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 17f60bd..8ae6f57 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -36,6 +36,8 @@ uint32_t nftnl_expr_get_u32(const struct nftnl_expr *expr, uint16_t type);
 uint64_t nftnl_expr_get_u64(const struct nftnl_expr *expr, uint16_t type);
 const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type);
 
+bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2);
+
 int nftnl_expr_snprintf(char *buf, size_t buflen, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 
 enum {
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index e3bd6b8..adeedf2 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -50,6 +50,8 @@ uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr);
 
 void nftnl_rule_add_expr(struct nftnl_rule *r, struct nftnl_expr *expr);
 
+bool nftnl_rule_cmp(const struct nftnl_rule *r1, const struct nftnl_rule *r2);
+
 struct nlmsghdr;
 
 void nftnl_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_rule *t);
diff --git a/src/expr.c b/src/expr.c
index e5c1dd3..1f57fb2 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -203,6 +203,17 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_expr_get_str, nft_rule_expr_get_str);
 
+bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
+{
+	if (e1->flags != e2->flags || strcmp(e1->ops->name, e2->ops->name))
+		return false;
+	if (e1->ops->cmp)
+		return e1->ops->cmp(e1, e2);
+
+	return false;
+}
+EXPORT_SYMBOL(nftnl_expr_cmp);
+
 void
 nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr)
 {
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 2fd4b74..1cfef0f 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -310,10 +310,32 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_bitwise_cmp(const struct nftnl_expr *e1,
+				   const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_bitwise *b1 = nftnl_expr_data(e1);
+	struct nftnl_expr_bitwise *b2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_BITWISE_SREG))
+		eq &= b1->sreg == b2->sreg;
+	if (e1->flags & (1 << NFTNL_EXPR_BITWISE_DREG))
+		eq &= b1->dreg == b2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_BITWISE_LEN))
+		eq &= b1->len == b2->len;
+	if (e1->flags & (1 << NFTNL_EXPR_BITWISE_MASK))
+		eq &= nftnl_data_reg_cmp(&b1->mask, &b2->mask, DATA_VALUE);
+	if (e1->flags & (1 << NFTNL_EXPR_BITWISE_XOR))
+		eq &= nftnl_data_reg_cmp(&b1->xor, &b2->xor, DATA_VALUE);
+
+	return eq;
+}
+
 struct expr_ops expr_ops_bitwise = {
 	.name		= "bitwise",
 	.alloc_len	= sizeof(struct nftnl_expr_bitwise),
 	.max_attr	= NFTA_BITWISE_MAX,
+	.cmp		= nftnl_expr_bitwise_cmp,
 	.set		= nftnl_expr_bitwise_set,
 	.get		= nftnl_expr_bitwise_get,
 	.parse		= nftnl_expr_bitwise_parse,
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index ca697cf..2132a51 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -326,10 +326,32 @@ nftnl_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_byteorder_cmp(const struct nftnl_expr *e1,
+				     const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_byteorder *b1 = nftnl_expr_data(e1);
+	struct nftnl_expr_byteorder *b2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_BYTEORDER_SREG))
+		eq &= b1->sreg == b2->sreg;
+	if (e1->flags & (1 << NFTNL_EXPR_BYTEORDER_DREG))
+		eq &= b1->dreg == b2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_BYTEORDER_OP))
+		eq &= b1->op == b2->op;
+	if (e1->flags & (1 << NFTNL_EXPR_BYTEORDER_LEN))
+		eq &= b1->len == b2->len;
+	if (e1->flags & (1 << NFTNL_EXPR_BYTEORDER_SIZE))
+		eq &= b1->size == b2->size;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_byteorder = {
 	.name		= "byteorder",
 	.alloc_len	= sizeof(struct nftnl_expr_byteorder),
 	.max_attr	= NFTA_BYTEORDER_MAX,
+	.cmp		= nftnl_expr_byteorder_cmp,
 	.set		= nftnl_expr_byteorder_set,
 	.get		= nftnl_expr_byteorder_get,
 	.parse		= nftnl_expr_byteorder_parse,
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 5d51958..55f23bc 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -293,10 +293,28 @@ nftnl_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_cmp_cmp(const struct nftnl_expr *e1,
+			       const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_cmp *c1 = nftnl_expr_data(e1);
+	struct nftnl_expr_cmp *c2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_CMP_DATA))
+		eq &= nftnl_data_reg_cmp(&c1->data, &c2->data, DATA_VALUE);
+	if (e1->flags & (1 << NFTNL_EXPR_CMP_SREG))
+		eq &= c1->sreg == c2->sreg;
+	if (e1->flags & (1 << NFTNL_EXPR_CMP_OP))
+		eq &= c1->op == c2->op;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_cmp = {
 	.name		= "cmp",
 	.alloc_len	= sizeof(struct nftnl_expr_cmp),
 	.max_attr	= NFTA_CMP_MAX,
+	.cmp		= nftnl_expr_cmp_cmp,
 	.set		= nftnl_expr_cmp_set,
 	.get		= nftnl_expr_cmp_get,
 	.parse		= nftnl_expr_cmp_parse,
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 1f818c4..89221b5 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -198,10 +198,26 @@ static int nftnl_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_counter_cmp(const struct nftnl_expr *e1,
+				   const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_counter *c1 = nftnl_expr_data(e1);
+	struct nftnl_expr_counter *c2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_CTR_PACKETS))
+		eq &= c1->pkts == c2->pkts;
+	if (e1->flags & (1 << NFTNL_EXPR_CTR_BYTES))
+		eq &= c1->pkts == c2->pkts;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_counter = {
 	.name		= "counter",
 	.alloc_len	= sizeof(struct nftnl_expr_counter),
 	.max_attr	= NFTA_COUNTER_MAX,
+	.cmp		= nftnl_expr_counter_cmp,
 	.set		= nftnl_expr_counter_set,
 	.get		= nftnl_expr_counter_get,
 	.parse		= nftnl_expr_counter_parse,
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 1a53b49..dbe96d1 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -373,10 +373,30 @@ nftnl_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_ct_cmp(const struct nftnl_expr *e1,
+			      const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_ct *c1 = nftnl_expr_data(e1);
+	struct nftnl_expr_ct *c2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_CT_KEY))
+		eq &= c1->key == c2->key;
+	if (e1->flags & (1 << NFTNL_EXPR_CT_DREG))
+		eq &= c1->dreg == c2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_CT_SREG))
+		eq &= c1->sreg == c2->sreg;
+	if (e1->flags & (1 << NFTNL_EXPR_CT_DIR))
+		eq &= c1->dir == c2->dir;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_ct = {
 	.name		= "ct",
 	.alloc_len	= sizeof(struct nftnl_expr_ct),
 	.max_attr	= NFTA_CT_MAX,
+	.cmp		= nftnl_expr_ct_cmp,
 	.set		= nftnl_expr_ct_set,
 	.get		= nftnl_expr_ct_get,
 	.parse		= nftnl_expr_ct_parse,
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 688823b..a954e95 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -379,6 +379,22 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 	return -1;
 }
 
+bool nftnl_data_reg_cmp(const union nftnl_data_reg *r1,
+		        const union nftnl_data_reg *r2, int reg_type)
+{
+	switch (reg_type) {
+	case DATA_VALUE:
+		return	r1->len == r2->len &&
+			!memcmp(r1->val, r2->val, r1->len);
+	case DATA_VERDICT:
+	case DATA_CHAIN:
+		return	r1->verdict == r2->verdict &&
+			!strcmp(r1->chain, r2->chain);
+	default:
+		return false;
+	}
+}
+
 static int nftnl_data_parse_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 694db32..5bef6f1 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -202,10 +202,26 @@ static int nftnl_expr_dup_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_dup_cmp(const struct nftnl_expr *e1,
+			       const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_dup *d1 = nftnl_expr_data(e1);
+	struct nftnl_expr_dup *d2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_DUP_SREG_ADDR))
+		eq &= d1->sreg_addr == d2->sreg_addr;
+	if (e1->flags & (1 << NFTNL_EXPR_DUP_SREG_DEV))
+		eq &= d1->sreg_dev == d2->sreg_dev;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_dup = {
 	.name		= "dup",
 	.alloc_len	= sizeof(struct nftnl_expr_dup),
 	.max_attr	= NFTA_DUP_MAX,
+	.cmp		= nftnl_expr_dup_cmp,
 	.set		= nftnl_expr_dup_set,
 	.get		= nftnl_expr_dup_get,
 	.parse		= nftnl_expr_dup_parse,
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 0eaa409..6fc5bc1 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -370,11 +370,37 @@ static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
 	xfree(dynset->set_name);
 }
 
+static bool nftnl_expr_dynset_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_dynset *d1 = nftnl_expr_data(e1);
+	struct nftnl_expr_dynset *d2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_DYNSET_SREG_KEY))
+		eq &= d1->sreg_key == d2->sreg_key;
+	if (e1->flags & (1 << NFTNL_EXPR_DYNSET_SREG_DATA))
+		eq &= d1->sreg_data == d2->sreg_data;
+	if (e1->flags & (1 << NFTNL_EXPR_DYNSET_OP))
+		eq &= d1->op == d2->op;
+	if (e1->flags & (1 << NFTNL_EXPR_DYNSET_TIMEOUT))
+		eq &= d1->timeout == d2->timeout;
+	if (e1->flags & (1 << NFTNL_EXPR_DYNSET_EXPR))
+		eq &= nftnl_expr_cmp(d1->expr, d2->expr);
+	if (e1->flags & (1 << NFTNL_EXPR_DYNSET_SET_NAME))
+		eq &= !strcmp(d1->set_name, d2->set_name);
+	if (e1->flags & (1 << NFTNL_EXPR_DYNSET_SET_ID))
+		eq &= d1->set_id == d2->set_id;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_dynset = {
 	.name		= "dynset",
 	.alloc_len	= sizeof(struct nftnl_expr_dynset),
 	.max_attr	= NFTA_DYNSET_MAX,
 	.free		= nftnl_expr_dynset_free,
+	.cmp		= nftnl_expr_dynset_cmp,
 	.set		= nftnl_expr_dynset_set,
 	.get		= nftnl_expr_dynset_get,
 	.parse		= nftnl_expr_dynset_parse,
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 6489a48..f981b2c 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -304,10 +304,30 @@ nftnl_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_exthdr_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_exthdr *h1 = nftnl_expr_data(e1);
+	struct nftnl_expr_exthdr *h2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_DREG))
+		eq &= h1->dreg == h2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_OFFSET))
+		eq &= h1->offset == h2->offset;
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_LEN))
+		eq &= h1->len == h2->len;
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_TYPE))
+		eq &= h1->type == h2->type;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_exthdr = {
 	.name		= "exthdr",
 	.alloc_len	= sizeof(struct nftnl_expr_exthdr),
 	.max_attr	= NFTA_EXTHDR_MAX,
+	.cmp		= nftnl_expr_exthdr_cmp,
 	.set		= nftnl_expr_exthdr_set,
 	.get		= nftnl_expr_exthdr_get,
 	.parse		= nftnl_expr_exthdr_parse,
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 8fa6d66..694aad7 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -175,10 +175,24 @@ static int nftnl_expr_fwd_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_fwd_cmp(const struct nftnl_expr *e1,
+			       const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_fwd *f1 = nftnl_expr_data(e1);
+	struct nftnl_expr_fwd *f2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_FWD_SREG_DEV))
+		eq &= f1->sreg_dev == f2->sreg_dev;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_fwd = {
 	.name		= "fwd",
 	.alloc_len	= sizeof(struct nftnl_expr_fwd),
 	.max_attr	= NFTA_FWD_MAX,
+	.cmp		= nftnl_expr_fwd_cmp,
 	.set		= nftnl_expr_fwd_set,
 	.get		= nftnl_expr_fwd_get,
 	.parse		= nftnl_expr_fwd_parse,
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 22ec864..eba2e60 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -320,11 +320,29 @@ static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 		nftnl_free_verdict(&imm->data);
 }
 
+static bool nftnl_expr_immediate_cmp(const struct nftnl_expr *e1,
+				     const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_immediate *i1 = nftnl_expr_data(e1);
+	struct nftnl_expr_immediate *i2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_IMM_DREG))
+		eq &= i1->dreg == i2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
+		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VERDICT);
+	else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA))
+		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VALUE);
+
+	return eq;
+}
+
 struct expr_ops expr_ops_immediate = {
 	.name		= "immediate",
 	.alloc_len	= sizeof(struct nftnl_expr_immediate),
 	.max_attr	= NFTA_IMMEDIATE_MAX,
 	.free		= nftnl_expr_immediate_free,
+	.cmp		= nftnl_expr_immediate_cmp,
 	.set		= nftnl_expr_immediate_set,
 	.get		= nftnl_expr_immediate_get,
 	.parse		= nftnl_expr_immediate_parse,
diff --git a/src/expr/limit.c b/src/expr/limit.c
index cdff81d..f60902d 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -287,11 +287,33 @@ nftnl_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_limit_cmp(const struct nftnl_expr *e1,
+				 const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_limit *l1 = nftnl_expr_data(e1);
+	struct nftnl_expr_limit *l2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_LIMIT_RATE))
+		eq &= l1->rate == l2->rate;
+	if (e1->flags & (1 << NFTNL_EXPR_LIMIT_UNIT))
+		eq &= l1->unit == l2->unit;
+	if (e1->flags & (1 << NFTNL_EXPR_LIMIT_BURST))
+		eq &= l1->burst == l2->burst;
+	if (e1->flags & (1 << NFTNL_EXPR_LIMIT_TYPE))
+		eq &= l1->type == l2->type;
+	if (e1->flags & (1 << NFTNL_EXPR_LIMIT_FLAGS))
+		eq &= l1->flags == l2->flags;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_limit = {
 	.name		= "limit",
 	.alloc_len	= sizeof(struct nftnl_expr_limit),
 	.max_attr	= NFTA_LIMIT_MAX,
 	.set		= nftnl_expr_limit_set,
+	.cmp		= nftnl_expr_limit_cmp,
 	.get		= nftnl_expr_limit_get,
 	.parse		= nftnl_expr_limit_parse,
 	.build		= nftnl_expr_limit_build,
diff --git a/src/expr/log.c b/src/expr/log.c
index b9b3951..b2aa259 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -336,11 +336,35 @@ static void nftnl_expr_log_free(const struct nftnl_expr *e)
 	xfree(log->prefix);
 }
 
+static bool nftnl_expr_log_cmp(const struct nftnl_expr *e1,
+				     const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_log *l1 = nftnl_expr_data(e1);
+	struct nftnl_expr_log *l2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_LOG_SNAPLEN))
+		eq &= l1->snaplen == l2->snaplen;
+	if (e1->flags & (1 << NFTNL_EXPR_LOG_GROUP))
+		eq &= l1->group == l2->group;
+	if (e1->flags & (1 << NFTNL_EXPR_LOG_QTHRESHOLD))
+		eq &= l1->qthreshold == l2->qthreshold;
+	if (e1->flags & (1 << NFTNL_EXPR_LOG_LEVEL))
+		eq &= l1->level == l2->level;
+	if (e1->flags & (1 << NFTNL_EXPR_LOG_FLAGS))
+		eq &= l1->flags == l2->flags;
+	if (e1->flags & (1 << NFTNL_EXPR_LOG_PREFIX))
+		eq &= !strcmp(l1->prefix, l2->prefix);
+
+	return eq;
+}
+
 struct expr_ops expr_ops_log = {
 	.name		= "log",
 	.alloc_len	= sizeof(struct nftnl_expr_log),
 	.max_attr	= NFTA_LOG_MAX,
 	.free		= nftnl_expr_log_free,
+	.cmp		= nftnl_expr_log_cmp,
 	.set		= nftnl_expr_log_set,
 	.get		= nftnl_expr_log_get,
 	.parse		= nftnl_expr_log_parse,
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 639470d..31d588b 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -295,11 +295,33 @@ static void nftnl_expr_lookup_free(const struct nftnl_expr *e)
 	xfree(lookup->set_name);
 }
 
+static bool nftnl_expr_lookup_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_lookup *l1 = nftnl_expr_data(e1);
+	struct nftnl_expr_lookup *l2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_LOOKUP_SREG))
+		eq &= l1->sreg == l2->sreg;
+	if (e1->flags & (1 << NFTNL_EXPR_LOOKUP_DREG))
+		eq &= l1->dreg == l2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_LOOKUP_SET))
+		eq &= !strcmp(l1->set_name, l2->set_name);
+	if (e1->flags & (1 << NFTNL_EXPR_LOOKUP_SET_ID))
+		eq &= l1->set_id == l2->set_id;
+	if (e1->flags & (1 << NFTNL_EXPR_LOOKUP_FLAGS))
+		eq &= l1->flags == l2->flags;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_lookup = {
 	.name		= "lookup",
 	.alloc_len	= sizeof(struct nftnl_expr_lookup),
 	.max_attr	= NFTA_LOOKUP_MAX,
 	.free		= nftnl_expr_lookup_free,
+	.cmp		= nftnl_expr_lookup_cmp,
 	.set		= nftnl_expr_lookup_set,
 	.get		= nftnl_expr_lookup_get,
 	.parse		= nftnl_expr_lookup_parse,
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 7296590..32b9b5a 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -228,10 +228,28 @@ static int nftnl_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_masq_cmp(const struct nftnl_expr *e1,
+				const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_masq *m1 = nftnl_expr_data(e1);
+	struct nftnl_expr_masq *m2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_MASQ_FLAGS))
+		eq &= m1->flags == m2->flags;
+	if (e1->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MIN))
+		eq &= m1->sreg_proto_min == m2->sreg_proto_min;
+	if (e1->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MAX))
+		eq &= m1->sreg_proto_max == m2->sreg_proto_max;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_masq = {
 	.name		= "masq",
 	.alloc_len	= sizeof(struct nftnl_expr_masq),
 	.max_attr	= NFTA_MASQ_MAX,
+	.cmp		= nftnl_expr_masq_cmp,
 	.set		= nftnl_expr_masq_set,
 	.get		= nftnl_expr_masq_get,
 	.parse		= nftnl_expr_masq_parse,
diff --git a/src/expr/match.c b/src/expr/match.c
index 3342e2c..c7b956b 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -240,11 +240,31 @@ static void nftnl_expr_match_free(const struct nftnl_expr *e)
 	xfree(match->data);
 }
 
+static bool nftnl_expr_match_cmp(const struct nftnl_expr *e1,
+				 const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_match *m1 = nftnl_expr_data(e1);
+	struct nftnl_expr_match *m2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_MT_NAME))
+		eq &= !strcmp(m1->name, m2->name);
+	if (e1->flags & (1 << NFTNL_EXPR_MT_REV))
+		eq &= m1->rev == m2->rev;
+	if (e1->flags & (1 << NFTNL_EXPR_MT_INFO)) {
+		eq &= m1->data_len == m2->data_len;
+		eq &= !memcmp(m1->data, m2->data, m1->data_len);
+	}
+
+	return eq;
+}
+
 struct expr_ops expr_ops_match = {
 	.name		= "match",
 	.alloc_len	= sizeof(struct nftnl_expr_match),
 	.max_attr	= NFTA_MATCH_MAX,
 	.free		= nftnl_expr_match_free,
+	.cmp		= nftnl_expr_match_cmp,
 	.set		= nftnl_expr_match_set,
 	.get		= nftnl_expr_match_get,
 	.parse		= nftnl_expr_match_parse,
diff --git a/src/expr/meta.c b/src/expr/meta.c
index a478a89..b4aaf61 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -296,10 +296,28 @@ nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_meta_cmp(const struct nftnl_expr *e1,
+				     const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_meta *m1 = nftnl_expr_data(e1);
+	struct nftnl_expr_meta *m2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_META_KEY))
+		eq &= m1->key == m2->key;
+	if (e1->flags & (1 << NFTNL_EXPR_META_DREG))
+		eq &= m1->dreg == m2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_META_SREG))
+		eq &= m1->sreg == m2->sreg;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_meta = {
 	.name		= "meta",
 	.alloc_len	= sizeof(struct nftnl_expr_meta),
 	.max_attr	= NFTA_META_MAX,
+	.cmp		= nftnl_expr_meta_cmp,
 	.set		= nftnl_expr_meta_set,
 	.get		= nftnl_expr_meta_get,
 	.parse		= nftnl_expr_meta_parse,
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 1ae7f77..069743b 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -404,10 +404,35 @@ nftnl_expr_nat_snprintf(char *buf, size_t size, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_nat_cmp(const struct nftnl_expr *e1,
+			       const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_nat *n1 = nftnl_expr_data(e1);
+	struct nftnl_expr_nat *n2 = nftnl_expr_data(e2);
+	bool eq = true;
+	if (e1->flags & (1 << NFTNL_EXPR_NAT_REG_ADDR_MIN))
+		eq &= n1->sreg_addr_min == n2->sreg_addr_min;
+	if (e1->flags & (1 << NFTNL_EXPR_NAT_REG_ADDR_MAX))
+		eq &= n1->sreg_addr_max == n2->sreg_addr_max;
+	if (e1->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_MIN))
+		eq &= n1->sreg_proto_min == n2->sreg_proto_min;
+	if (e1->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_MAX))
+		eq &= n1->sreg_proto_max == n2->sreg_proto_max;
+	if (e1->flags & (1 << NFTNL_EXPR_NAT_FAMILY))
+		eq &= n1->family == n2->family;
+	if (e1->flags & (1 << NFTNL_EXPR_NAT_TYPE))
+		eq &= n1->type == n2->type;
+	if (e1->flags & (1 << NFTNL_EXPR_NAT_FLAGS))
+		eq &= n1->flags == n2->flags;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_nat = {
 	.name		= "nat",
 	.alloc_len	= sizeof(struct nftnl_expr_nat),
 	.max_attr	= NFTA_NAT_MAX,
+	.cmp		= nftnl_expr_nat_cmp,
 	.set		= nftnl_expr_nat_set,
 	.get		= nftnl_expr_nat_get,
 	.parse		= nftnl_expr_nat_parse,
diff --git a/src/expr/payload.c b/src/expr/payload.c
index d4f9ef9..0ed14a9 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -335,10 +335,36 @@ nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_payload_cmp(const struct nftnl_expr *e1,
+				   const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_payload *p1 = nftnl_expr_data(e1);
+	struct nftnl_expr_payload *p2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_SREG))
+		eq &= p1->sreg == p2->sreg;
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_DREG))
+		eq &= p1->dreg == p2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_BASE))
+		eq &= p1->base == p2->base;
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_OFFSET))
+		eq &= p1->offset == p2->offset;
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_LEN))
+		eq &= p1->len == p2->len;
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_CSUM_TYPE))
+		eq &= p1->csum_type == p2->csum_type;
+	if (e1->flags & (1 << NFTNL_EXPR_PAYLOAD_CSUM_OFFSET))
+		eq &= p1->csum_offset == p2->csum_offset;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_payload = {
 	.name		= "payload",
 	.alloc_len	= sizeof(struct nftnl_expr_payload),
 	.max_attr	= NFTA_PAYLOAD_MAX,
+	.cmp		= nftnl_expr_payload_cmp,
 	.set		= nftnl_expr_payload_set,
 	.get		= nftnl_expr_payload_get,
 	.parse		= nftnl_expr_payload_parse,
diff --git a/src/expr/queue.c b/src/expr/queue.c
index a2e6ed5..cffc23a 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -243,10 +243,28 @@ nftnl_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_queue_cmp(const struct nftnl_expr *e1,
+			    const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_queue *q1 = nftnl_expr_data(e1);
+	struct nftnl_expr_queue *q2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_NUM))
+		eq &= q1->queuenum == q2->queuenum;
+	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_TOTAL))
+		eq &= q1->queues_total == q2->queues_total;
+	if (e1->flags & (1 << NFTNL_EXPR_QUEUE_FLAGS))
+		eq &= q1->flags == q2->flags;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_queue = {
 	.name		= "queue",
 	.alloc_len	= sizeof(struct nftnl_expr_queue),
 	.max_attr	= NFTA_QUEUE_MAX,
+	.cmp		= nftnl_expr_queue_cmp,
 	.set		= nftnl_expr_queue_set,
 	.get		= nftnl_expr_queue_get,
 	.parse		= nftnl_expr_queue_parse,
diff --git a/src/expr/redir.c b/src/expr/redir.c
index c6eedfb..3116319 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -242,10 +242,28 @@ nftnl_expr_redir_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_redir_cmp(const struct nftnl_expr *e1,
+				 const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_redir *r1 = nftnl_expr_data(e1);
+	struct nftnl_expr_redir *r2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_REDIR_REG_PROTO_MIN))
+		eq &= r1->sreg_proto_min== r2->sreg_proto_min;
+	if (e1->flags & (1 << NFTNL_EXPR_REDIR_REG_PROTO_MAX))
+		eq &= r1->sreg_proto_max== r2->sreg_proto_max;
+	if (e1->flags & (1 << NFTNL_EXPR_REDIR_FLAGS))
+		eq &= r1->flags== r2->flags;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_redir = {
 	.name		= "redir",
 	.alloc_len	= sizeof(struct nftnl_expr_redir),
 	.max_attr	= NFTA_REDIR_MAX,
+	.cmp		= nftnl_expr_redir_cmp,
 	.set		= nftnl_expr_redir_set,
 	.get		= nftnl_expr_redir_get,
 	.parse		= nftnl_expr_redir_parse,
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 1953328..fc4de13 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -199,10 +199,26 @@ nftnl_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_reject_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_reject *r1 = nftnl_expr_data(e1);
+	struct nftnl_expr_reject *r2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_REJECT_TYPE))
+		eq &= r1->type == r2->type;
+	if (e1->flags & (1 << NFTNL_EXPR_REJECT_CODE))
+		eq &= r1->icmp_code == r2->icmp_code;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_reject = {
 	.name		= "reject",
 	.alloc_len	= sizeof(struct nftnl_expr_reject),
 	.max_attr	= NFTA_REJECT_MAX,
+	.cmp		= nftnl_expr_reject_cmp,
 	.set		= nftnl_expr_reject_set,
 	.get		= nftnl_expr_reject_get,
 	.parse		= nftnl_expr_reject_parse,
diff --git a/src/expr/target.c b/src/expr/target.c
index d4c0091..fca5cb8 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -241,11 +241,31 @@ static void nftnl_expr_target_free(const struct nftnl_expr *e)
 	xfree(target->data);
 }
 
+static bool nftnl_expr_target_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_target *t1 = nftnl_expr_data(e1);
+	struct nftnl_expr_target *t2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_TG_NAME))
+		eq &= !strcmp(t1->name, t2->name);
+	if (e1->flags & (1 << NFTNL_EXPR_TG_REV))
+		eq &= t1->rev == t2->rev;
+	if (e1->flags & (1 << NFTNL_EXPR_TG_INFO)) {
+		eq &= t1->data_len == t2->data_len;
+		eq &= !memcmp(t1->data, t2->data, t1->data_len);
+	}
+
+	return eq;
+}
+
 struct expr_ops expr_ops_target = {
 	.name		= "target",
 	.alloc_len	= sizeof(struct nftnl_expr_target),
 	.max_attr	= NFTA_TARGET_MAX,
 	.free		= nftnl_expr_target_free,
+	.cmp		= nftnl_expr_target_cmp,
 	.set		= nftnl_expr_target_set,
 	.get		= nftnl_expr_target_get,
 	.parse		= nftnl_expr_target_parse,
diff --git a/src/libnftnl.map b/src/libnftnl.map
index c38e081..abed8b9 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -528,3 +528,8 @@ LIBNFTNL_4.1 {
 	nftnl_udata_next;
 	nftnl_udata_parse;
 } LIBNFTNL_4;
+
+LIBNFTNL_4.2 {
+	nftnl_rule_cmp;
+	nftnl_expr_cmp;
+} LIBNFTNL_4.1;
diff --git a/src/rule.c b/src/rule.c
index 8aeefbe..9f833b4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1077,6 +1077,36 @@ void nftnl_expr_iter_destroy(struct nftnl_expr_iter *iter)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_expr_iter_destroy, nft_rule_expr_iter_destroy);
 
+bool nftnl_rule_cmp(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
+{
+	struct nftnl_expr_iter it1, it2;
+	struct nftnl_expr *e1, *e2;
+	unsigned int eq = 1;
+
+	if (r1->flags & r1->flags & (1 << NFTNL_RULE_TABLE))
+		eq &= !strcmp(r1->table, r2->table);
+	if (r1->flags & r1->flags & (1 << NFTNL_RULE_CHAIN))
+		eq &= !strcmp(r1->chain, r2->chain);
+	if (r1->flags & r1->flags & (1 << NFTNL_RULE_COMPAT_FLAGS))
+		eq &= r1->compat.flags == r2->compat.flags;
+	if (r1->flags & r1->flags & (1 << NFTNL_RULE_COMPAT_PROTO))
+		eq &= r1->compat.proto == r2->compat.proto;
+
+	nftnl_expr_iter_init(r1, &it1);
+	nftnl_expr_iter_init(r2, &it2);
+	e1 = nftnl_expr_iter_next(&it1);
+	e2 = nftnl_expr_iter_next(&it2);
+	while (eq && e1 && e2) {
+		eq = nftnl_expr_cmp(e1, e2);
+
+		e1 = nftnl_expr_iter_next(&it1);
+		e2 = nftnl_expr_iter_next(&it2);
+	}
+
+	return eq;
+}
+EXPORT_SYMBOL(nftnl_rule_cmp);
+
 struct nftnl_rule_list {
 	struct list_head list;
 };
-- 
2.8.3

