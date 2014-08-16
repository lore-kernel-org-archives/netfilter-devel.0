From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [libnftnl PATCH] Rename xfree() to libnftnl_xfree() to avoid symbol naming conflict
Date: Sat, 16 Aug 2014 15:39:49 +0200
Message-ID: <1408196389-15559-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:46004 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751431AbaHPNj4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2014 09:39:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When ELF binaries and shared libraries are used, the internal
functions of libnftnl such as xfree() are not visible to the outside
world (their visibility is 'hidden'). Therefore, the fact that other
programs (especially nftables) may have symbols with the same name
does not cause any problem.

However, when doing static linking on a non-ELF platform (such as
Blackfin, which uses the FLAT binary format), there is no way of
encoding this visibility. Therefore, the xfree() symbols of libnftnl
becomes visible to the outside world, causing a conflict with the
xfree() symbol defined by nftables.

To solve this, this patch renames the libnftnl xfree() function to
libnftnl_xfree().

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 src/chain.c          | 18 +++++++++---------
 src/common.c         |  2 +-
 src/expr.c           |  2 +-
 src/expr/data_reg.c  |  2 +-
 src/expr/immediate.c |  2 +-
 src/expr/log.c       |  6 +++---
 src/expr/match.c     |  6 +++---
 src/expr/target.c    |  6 +++---
 src/internal.h       |  2 +-
 src/mxml.c           |  2 +-
 src/rule.c           | 24 ++++++++++++------------
 src/ruleset.c        |  2 +-
 src/set.c            | 18 +++++++++---------
 src/set_elem.c       | 12 ++++++------
 src/table.c          | 12 ++++++------
 src/utils.c          |  4 ++--
 16 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index a056bab..1a07e7d 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -88,11 +88,11 @@ EXPORT_SYMBOL(nft_chain_alloc);
 void nft_chain_free(struct nft_chain *c)
 {
 	if (c->table != NULL)
-		xfree(c->table);
+		nftnl_xfree(c->table);
 	if (c->type != NULL)
-		xfree(c->type);
+		nftnl_xfree(c->type);
 
-	xfree(c);
+	nftnl_xfree(c);
 }
 EXPORT_SYMBOL(nft_chain_free);
 
@@ -110,7 +110,7 @@ void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
 	switch (attr) {
 	case NFT_CHAIN_ATTR_TABLE:
 		if (c->table) {
-			xfree(c->table);
+			nftnl_xfree(c->table);
 			c->table = NULL;
 		}
 		break;
@@ -118,7 +118,7 @@ void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
 		break;
 	case NFT_CHAIN_ATTR_TYPE:
 		if (c->type) {
-			xfree(c->type);
+			nftnl_xfree(c->type);
 			c->type = NULL;
 		}
 		break;
@@ -163,7 +163,7 @@ void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
 		break;
 	case NFT_CHAIN_ATTR_TABLE:
 		if (c->table)
-			xfree(c->table);
+			nftnl_xfree(c->table);
 
 		c->table = strdup(data);
 		break;
@@ -193,7 +193,7 @@ void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
 		break;
 	case NFT_CHAIN_ATTR_TYPE:
 		if (c->type)
-			xfree(c->type);
+			nftnl_xfree(c->type);
 
 		c->type = strdup(data);
 		break;
@@ -1025,7 +1025,7 @@ void nft_chain_list_free(struct nft_chain_list *list)
 		list_del(&r->head);
 		nft_chain_free(r);
 	}
-	xfree(list);
+	nftnl_xfree(list);
 }
 EXPORT_SYMBOL(nft_chain_list_free);
 
@@ -1104,6 +1104,6 @@ EXPORT_SYMBOL(nft_chain_list_iter_next);
 
 void nft_chain_list_iter_destroy(struct nft_chain_list_iter *iter)
 {
-	xfree(iter);
+	nftnl_xfree(iter);
 }
 EXPORT_SYMBOL(nft_chain_list_iter_destroy);
diff --git a/src/common.c b/src/common.c
index 1b600f1..e01de31 100644
--- a/src/common.c
+++ b/src/common.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL(nft_parse_err_alloc);
 
 void nft_parse_err_free(struct nft_parse_err *err)
 {
-	xfree(err);
+	nftnl_xfree(err);
 }
 EXPORT_SYMBOL(nft_parse_err_free);
 
diff --git a/src/expr.c b/src/expr.c
index 55557da..d23af01 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -52,7 +52,7 @@ void nft_rule_expr_free(struct nft_rule_expr *expr)
 	if (expr->ops->free)
 		expr->ops->free(expr);
 
-	xfree(expr);
+	nftnl_xfree(expr);
 }
 EXPORT_SYMBOL(nft_rule_expr_free);
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 28ad164..478e55d 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -130,7 +130,7 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg,
 				   NFT_XML_OPT, err);
 	if (chain != NULL) {
 		if (reg->chain)
-			xfree(reg->chain);
+			nftnl_xfree(reg->chain);
 
 		reg->chain = strdup(chain);
 	}
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 5f54129..56b9985 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -46,7 +46,7 @@ nft_rule_expr_immediate_set(struct nft_rule_expr *e, uint16_t type,
 		break;
 	case NFT_EXPR_IMM_CHAIN:
 		if (imm->data.chain)
-			xfree(imm->data.chain);
+			nftnl_xfree(imm->data.chain);
 
 		imm->data.chain = strdup(data);
 		break;
diff --git a/src/expr/log.c b/src/expr/log.c
index 98481c9..df74003 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -39,7 +39,7 @@ static int nft_rule_expr_log_set(struct nft_rule_expr *e, uint16_t type,
 	switch(type) {
 	case NFT_EXPR_LOG_PREFIX:
 		if (log->prefix)
-			xfree(log->prefix);
+			nftnl_xfree(log->prefix);
 
 		log->prefix = strdup(data);
 		break;
@@ -153,7 +153,7 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
 
 	if (tb[NFTA_LOG_PREFIX]) {
 		if (log->prefix)
-			xfree(log->prefix);
+			nftnl_xfree(log->prefix);
 
 		log->prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
 		e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
@@ -393,7 +393,7 @@ static void nft_rule_expr_log_free(struct nft_rule_expr *e)
 {
 	struct nft_expr_log *log = nft_expr_data(e);
 
-	xfree(log->prefix);
+	nftnl_xfree(log->prefix);
 }
 
 struct expr_ops expr_ops_log = {
diff --git a/src/expr/match.c b/src/expr/match.c
index 378d5dd..7328a56 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -50,7 +50,7 @@ nft_rule_expr_match_set(struct nft_rule_expr *e, uint16_t type,
 		break;
 	case NFT_EXPR_MT_INFO:
 		if (mt->data)
-			xfree(mt->data);
+			nftnl_xfree(mt->data);
 
 		mt->data = data;
 		mt->data_len = data_len;
@@ -147,7 +147,7 @@ static int nft_rule_expr_match_parse(struct nft_rule_expr *e, struct nlattr *att
 		void *match_data;
 
 		if (match->data)
-			xfree(match->data);
+			nftnl_xfree(match->data);
 
 		match_data = calloc(1, len);
 		if (match_data == NULL)
@@ -255,7 +255,7 @@ static void nft_rule_expr_match_free(struct nft_rule_expr *e)
 {
 	struct nft_expr_match *match = nft_expr_data(e);
 
-	xfree(match->data);
+	nftnl_xfree(match->data);
 }
 
 struct expr_ops expr_ops_match = {
diff --git a/src/expr/target.c b/src/expr/target.c
index b3966a6..305e739 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -50,7 +50,7 @@ nft_rule_expr_target_set(struct nft_rule_expr *e, uint16_t type,
 		break;
 	case NFT_EXPR_TG_INFO:
 		if (tg->data)
-			xfree(tg->data);
+			nftnl_xfree(tg->data);
 
 		tg->data = data;
 		tg->data_len = data_len;
@@ -147,7 +147,7 @@ static int nft_rule_expr_target_parse(struct nft_rule_expr *e, struct nlattr *at
 		void *target_data;
 
 		if (target->data)
-			xfree(target->data);
+			nftnl_xfree(target->data);
 
 		target_data = calloc(1, len);
 		if (target_data == NULL)
@@ -256,7 +256,7 @@ static void nft_rule_expr_target_free(struct nft_rule_expr *e)
 {
 	struct nft_expr_target *target = nft_expr_data(e);
 
-	xfree(target->data);
+	nftnl_xfree(target->data);
 }
 
 struct expr_ops expr_ops_target = {
diff --git a/src/internal.h b/src/internal.h
index e76a5cb..174526e 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -144,7 +144,7 @@ int nft_event_footer_snprintf(char *buf, size_t bufsize,
 			      uint32_t format, uint32_t flags);
 int nft_event_footer_fprintf(FILE *fp, uint32_t format, uint32_t flags);
 
-void xfree(const void *ptr);
+void nftnl_xfree(const void *ptr);
 
 struct expr_ops;
 
diff --git a/src/mxml.c b/src/mxml.c
index 5e4f022..caf57b4 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -82,7 +82,7 @@ struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 		goto err_expr;
 
 	tree = mxmlLoadString(NULL, xml_text, MXML_OPAQUE_CALLBACK);
-	xfree(xml_text);
+	nftnl_xfree(xml_text);
 
 	if (tree == NULL)
 		goto err_expr;
diff --git a/src/rule.c b/src/rule.c
index ec5f9a8..3cdc884 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -74,11 +74,11 @@ void nft_rule_free(struct nft_rule *r)
 		nft_rule_expr_free(e);
 
 	if (r->table != NULL)
-		xfree(r->table);
+		nftnl_xfree(r->table);
 	if (r->chain != NULL)
-		xfree(r->chain);
+		nftnl_xfree(r->chain);
 
-	xfree(r);
+	nftnl_xfree(r);
 }
 EXPORT_SYMBOL(nft_rule_free);
 
@@ -96,13 +96,13 @@ void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr)
 	switch (attr) {
 	case NFT_RULE_ATTR_TABLE:
 		if (r->table) {
-			xfree(r->table);
+			nftnl_xfree(r->table);
 			r->table = NULL;
 		}
 		break;
 	case NFT_RULE_ATTR_CHAIN:
 		if (r->chain) {
-			xfree(r->chain);
+			nftnl_xfree(r->chain);
 			r->chain = NULL;
 		}
 		break;
@@ -138,13 +138,13 @@ void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
 	switch(attr) {
 	case NFT_RULE_ATTR_TABLE:
 		if (r->table)
-			xfree(r->table);
+			nftnl_xfree(r->table);
 
 		r->table = strdup(data);
 		break;
 	case NFT_RULE_ATTR_CHAIN:
 		if (r->chain)
-			xfree(r->chain);
+			nftnl_xfree(r->chain);
 
 		r->chain = strdup(data);
 		break;
@@ -394,7 +394,7 @@ static int nft_rule_parse_expr2(struct nlattr *attr, struct nft_rule *r)
 
 	if (tb[NFTA_EXPR_DATA]) {
 		if (expr->ops->parse(expr, tb[NFTA_EXPR_DATA]) < 0) {
-			xfree(expr);
+			nftnl_xfree(expr);
 			return -1;
 		}
 	}
@@ -490,7 +490,7 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
 
 		if (r->user.data)
-			xfree(r->user.data);
+			nftnl_xfree(r->user.data);
 
 		r->user.len = mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
 
@@ -1058,7 +1058,7 @@ EXPORT_SYMBOL(nft_rule_expr_iter_next);
 
 void nft_rule_expr_iter_destroy(struct nft_rule_expr_iter *iter)
 {
-	xfree(iter);
+	nftnl_xfree(iter);
 }
 EXPORT_SYMBOL(nft_rule_expr_iter_destroy);
 
@@ -1088,7 +1088,7 @@ void nft_rule_list_free(struct nft_rule_list *list)
 		list_del(&r->head);
 		nft_rule_free(r);
 	}
-	xfree(list);
+	nftnl_xfree(list);
 }
 EXPORT_SYMBOL(nft_rule_list_free);
 
@@ -1173,6 +1173,6 @@ EXPORT_SYMBOL(nft_rule_list_iter_next);
 
 void nft_rule_list_iter_destroy(struct nft_rule_list_iter *iter)
 {
-	xfree(iter);
+	nftnl_xfree(iter);
 }
 EXPORT_SYMBOL(nft_rule_list_iter_destroy);
diff --git a/src/ruleset.c b/src/ruleset.c
index a19cbc1..c3fc4e9 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -48,7 +48,7 @@ void nft_ruleset_free(struct nft_ruleset *r)
 		nft_set_list_free(r->set_list);
 	if (r->flags & (1 << NFT_RULESET_ATTR_RULELIST))
 		nft_rule_list_free(r->rule_list);
-	xfree(r);
+	nftnl_xfree(r);
 }
 EXPORT_SYMBOL(nft_ruleset_free);
 
diff --git a/src/set.c b/src/set.c
index 3c38334..6982b61 100644
--- a/src/set.c
+++ b/src/set.c
@@ -46,15 +46,15 @@ void nft_set_free(struct nft_set *s)
 	struct nft_set_elem *elem, *tmp;
 
 	if (s->table != NULL)
-		xfree(s->table);
+		nftnl_xfree(s->table);
 	if (s->name != NULL)
-		xfree(s->name);
+		nftnl_xfree(s->name);
 
 	list_for_each_entry_safe(elem, tmp, &s->element_list, head) {
 		list_del(&elem->head);
 		nft_set_elem_free(elem);
 	}
-	xfree(s);
+	nftnl_xfree(s);
 }
 EXPORT_SYMBOL(nft_set_free);
 
@@ -70,14 +70,14 @@ void nft_set_attr_unset(struct nft_set *s, uint16_t attr)
 	case NFT_SET_ATTR_TABLE:
 		if (s->flags & (1 << NFT_SET_ATTR_TABLE))
 			if (s->table) {
-				xfree(s->table);
+				nftnl_xfree(s->table);
 				s->table = NULL;
 			}
 		break;
 	case NFT_SET_ATTR_NAME:
 		if (s->flags & (1 << NFT_SET_ATTR_NAME))
 			if (s->name) {
-				xfree(s->name);
+				nftnl_xfree(s->name);
 				s->name = NULL;
 			}
 		break;
@@ -121,13 +121,13 @@ void nft_set_attr_set_data(struct nft_set *s, uint16_t attr, const void *data,
 	switch(attr) {
 	case NFT_SET_ATTR_TABLE:
 		if (s->table)
-			xfree(s->table);
+			nftnl_xfree(s->table);
 
 		s->table = strdup(data);
 		break;
 	case NFT_SET_ATTR_NAME:
 		if (s->name)
-			xfree(s->name);
+			nftnl_xfree(s->name);
 
 		s->name = strdup(data);
 		break;
@@ -980,7 +980,7 @@ void nft_set_list_free(struct nft_set_list *list)
 		list_del(&s->head);
 		nft_set_free(s);
 	}
-	xfree(list);
+	nftnl_xfree(list);
 }
 EXPORT_SYMBOL(nft_set_list_free);
 
@@ -1064,6 +1064,6 @@ EXPORT_SYMBOL(nft_set_list_iter_next);
 
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter)
 {
-	xfree(iter);
+	nftnl_xfree(iter);
 }
 EXPORT_SYMBOL(nft_set_list_iter_destroy);
diff --git a/src/set_elem.c b/src/set_elem.c
index 93ecac6..e285eaa 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -44,11 +44,11 @@ void nft_set_elem_free(struct nft_set_elem *s)
 {
 	if (s->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN)) {
 		if (s->data.chain) {
-			xfree(s->data.chain);
+			nftnl_xfree(s->data.chain);
 			s->data.chain = NULL;
 		}
 	}
-	xfree(s);
+	nftnl_xfree(s);
 }
 EXPORT_SYMBOL(nft_set_elem_free);
 
@@ -64,7 +64,7 @@ void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)
 	case NFT_SET_ELEM_ATTR_CHAIN:
 		if (s->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN)) {
 			if (s->data.chain) {
-				xfree(s->data.chain);
+				nftnl_xfree(s->data.chain);
 				s->data.chain = NULL;
 			}
 		}
@@ -98,7 +98,7 @@ void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr,
 		break;
 	case NFT_SET_ELEM_ATTR_CHAIN:	/* NFTA_SET_ELEM_DATA */
 		if (s->data.chain)
-			xfree(s->data.chain);
+			nftnl_xfree(s->data.chain);
 
 		s->data.chain = strdup(data);
 		break;
@@ -300,7 +300,7 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 		}
         }
 	if (ret < 0) {
-		xfree(e);
+		nftnl_xfree(e);
 		return -1;
 	}
 
@@ -716,7 +716,7 @@ EXPORT_SYMBOL(nft_set_elems_iter_next);
 
 void nft_set_elems_iter_destroy(struct nft_set_elems_iter *iter)
 {
-	xfree(iter);
+	nftnl_xfree(iter);
 }
 EXPORT_SYMBOL(nft_set_elems_iter_destroy);
 
diff --git a/src/table.c b/src/table.c
index 53f6a4d..313c11e 100644
--- a/src/table.c
+++ b/src/table.c
@@ -44,9 +44,9 @@ EXPORT_SYMBOL(nft_table_alloc);
 void nft_table_free(struct nft_table *t)
 {
 	if (t->flags & (1 << NFT_TABLE_ATTR_NAME))
-		xfree(t->name);
+		nftnl_xfree(t->name);
 
-	xfree(t);
+	nftnl_xfree(t);
 }
 EXPORT_SYMBOL(nft_table_free);
 
@@ -64,7 +64,7 @@ void nft_table_attr_unset(struct nft_table *t, uint16_t attr)
 	switch (attr) {
 	case NFT_TABLE_ATTR_NAME:
 		if (t->name) {
-			xfree(t->name);
+			nftnl_xfree(t->name);
 			t->name = NULL;
 		}
 		break;
@@ -94,7 +94,7 @@ void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
 	switch (attr) {
 	case NFT_TABLE_ATTR_NAME:
 		if (t->name)
-			xfree(t->name);
+			nftnl_xfree(t->name);
 
 		t->name = strdup(data);
 		break;
@@ -538,7 +538,7 @@ void nft_table_list_free(struct nft_table_list *list)
 		list_del(&r->head);
 		nft_table_free(r);
 	}
-	xfree(list);
+	nftnl_xfree(list);
 }
 EXPORT_SYMBOL(nft_table_list_free);
 
@@ -617,6 +617,6 @@ EXPORT_SYMBOL(nft_table_list_iter_next);
 
 void nft_table_list_iter_destroy(struct nft_table_list_iter *iter)
 {
-	xfree(iter);
+	nftnl_xfree(iter);
 }
 EXPORT_SYMBOL(nft_table_list_iter_destroy);
diff --git a/src/utils.c b/src/utils.c
index 1878390..94a89e5 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -180,7 +180,7 @@ int nft_str2verdict(const char *verdict, int *verdict_num)
 	return -1;
 }
 
-void xfree(const void *ptr)
+void nftnl_xfree(const void *ptr)
 {
 	free((void *)ptr);
 }
@@ -214,7 +214,7 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 
 out:
 	if (buf != _buf)
-		xfree(buf);
+		nftnl_xfree(buf);
 
 	return ret;
 }
-- 
2.0.0

