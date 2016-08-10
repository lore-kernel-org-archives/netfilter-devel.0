From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/4, V3, libnftnl] Implement rule comparison
Date: Wed, 10 Aug 2016 11:48:55 +0200
Message-ID: <20160810094857.14227-2-carlosfg@riseup.net>
References: <20160808144834.GB6264@salvia>
 <20160810094857.14227-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:36374 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933961AbcHJTMR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:12:17 -0400
In-Reply-To: <20160810094857.14227-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements the function 'bool nftnl_rule_cmp(const struct
nftnl_rule *r, const struct nftnl_rule *r2)' for rule comparison.

Expressions within rules need to be compared, so also has been created the
function 'nftnl_expr_cmp' which calls new field within
'nfntl_expr_<expression>': a function pointer to a comparator. The
expressions that can be compared with memcmp have this new field set to
NULL, otherwise they have implemented a comparator.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 include/data_reg.h      |  3 +++
 include/expr_ops.h      |  1 +
 include/libnftnl/expr.h |  2 ++
 include/libnftnl/rule.h |  2 ++
 src/expr.c              | 14 ++++++++++++++
 src/expr/data_reg.c     | 16 ++++++++++++++++
 src/expr/dynset.c       | 16 ++++++++++++++++
 src/expr/immediate.c    | 17 +++++++++++++++++
 src/expr/log.c          | 15 +++++++++++++++
 src/expr/lookup.c       | 14 ++++++++++++++
 src/expr/match.c        | 13 +++++++++++++
 src/expr/target.c       | 13 +++++++++++++
 src/libnftnl.map        |  5 +++++
 src/rule.c              | 30 ++++++++++++++++++++++++++++++
 14 files changed, 161 insertions(+)

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
index e5c1dd3..7f32055 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -203,6 +203,20 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_expr_get_str, nft_rule_expr_get_str);
 
+bool nftnl_expr_cmp(const struct nftnl_expr *e1, const struct nftnl_expr *e2)
+{
+	if (e1->flags != e2->flags)
+		return false;
+
+	if (strcmp(e1->ops->name, e2->ops->name))
+		return false;
+	if (e1->ops->cmp)
+		return e1->ops->cmp(e1, e2);
+	else
+		return !memcmp(e1->data, e2->data, e1->ops->alloc_len);
+}
+EXPORT_SYMBOL(nftnl_expr_cmp);
+
 void
 nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr)
 {
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
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 0eaa409..83311f1 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -370,11 +370,27 @@ static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
 	xfree(dynset->set_name);
 }
 
+static bool nftnl_expr_dynset_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_dynset *d1 = nftnl_expr_data(e1);
+	struct nftnl_expr_dynset *d2 = nftnl_expr_data(e2);
+
+	return	d1->sreg_key  == d2->sreg_key       &&
+		d1->sreg_data == d2->sreg_data      &&
+		d1->op        == d2->op             &&
+		d1->timeout   == d2->timeout        &&
+		nftnl_expr_cmp(d1->expr, d2->expr)  &&
+		!strcmp(d1->set_name, d2->set_name) &&
+		d1->set_id    == d2->set_id;
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
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 22ec864..ec0613d 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -320,11 +320,28 @@ static void nftnl_expr_immediate_free(const struct nftnl_expr *e)
 		nftnl_free_verdict(&imm->data);
 }
 
+static bool nftnl_expr_immediate_cmp(const struct nftnl_expr *e1,
+				     const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_immediate *i1 = nftnl_expr_data(e1);
+	struct nftnl_expr_immediate *i2 = nftnl_expr_data(e2);
+	int reg_type;
+
+	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
+		reg_type = DATA_VERDICT;
+	else
+		reg_type = DATA_VALUE;
+
+	return	i1->dreg == i2->dreg &&
+		nftnl_data_reg_cmp(&i1->data, &i2->data, reg_type);
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
diff --git a/src/expr/log.c b/src/expr/log.c
index b9b3951..d8e2572 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -336,11 +336,26 @@ static void nftnl_expr_log_free(const struct nftnl_expr *e)
 	xfree(log->prefix);
 }
 
+static bool nftnl_expr_log_cmp(const struct nftnl_expr *e1,
+				     const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_log *l1 = nftnl_expr_data(e1);
+	struct nftnl_expr_log *l2 = nftnl_expr_data(e2);
+
+	return	l1->snaplen     == l2->snaplen    &&
+		l1->group       == l2->group      &&
+		l1->qthreshold  == l2->qthreshold &&
+		l1->level       == l2->level      &&
+		l1->flags       == l2->flags      &&
+		!strcmp(l1->prefix, l2->prefix);
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
index 97478c2..5e5d3d4 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -296,11 +296,25 @@ static void nftnl_expr_lookup_free(const struct nftnl_expr *e)
 	xfree(lookup->set_name);
 }
 
+static bool nftnl_expr_lookup_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_lookup *l1 = nftnl_expr_data(e1);
+	struct nftnl_expr_lookup *l2 = nftnl_expr_data(e2);
+
+	return	l1->sreg   == l2->sreg              &&
+		l1->dreg   == l2->dreg              &&
+		!strcmp(l1->set_name, l2->set_name) &&
+		l1->set_id == l2->set_id            &&
+		l1->flags  == l2->flags;
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
diff --git a/src/expr/match.c b/src/expr/match.c
index 3342e2c..8d9001f 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -240,11 +240,24 @@ static void nftnl_expr_match_free(const struct nftnl_expr *e)
 	xfree(match->data);
 }
 
+static bool nftnl_expr_match_cmp(const struct nftnl_expr *e1,
+				 const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_match *m1 = nftnl_expr_data(e1);
+	struct nftnl_expr_match *m2 = nftnl_expr_data(e2);
+
+	return	!strcmp(m1->name, m2->name)  &&
+		m1->rev == m2->rev           &&
+		m1->data_len == m2->data_len &&
+		!memcmp(m1->data, m2->data, m1->data_len);
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
diff --git a/src/expr/target.c b/src/expr/target.c
index d4c0091..55a0af3 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -241,11 +241,24 @@ static void nftnl_expr_target_free(const struct nftnl_expr *e)
 	xfree(target->data);
 }
 
+static bool nftnl_expr_target_cmp(const struct nftnl_expr *e1,
+				  const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_target *t1 = nftnl_expr_data(e1);
+	struct nftnl_expr_target *t2 = nftnl_expr_data(e2);
+
+	return	!strcmp(t1->name, t2->name)  &&
+		t1->rev == t2->rev           &&
+		t1->data_len == t2->data_len &&
+		!memcmp(t1->data, t2->data, t1->data_len);
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
index 69ffc7e..d4c3a6b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -339,6 +339,36 @@ void nftnl_rule_add_expr(struct nftnl_rule *r, struct nftnl_expr *expr)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_add_expr, nft_rule_add_expr);
 
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
 static int nftnl_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
-- 
2.8.3

