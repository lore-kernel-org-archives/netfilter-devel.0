From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 7/9] src: check for flags before releasing attributes
Date: Tue, 14 Jun 2016 15:18:43 +0200
Message-ID: <1465910325-13286-7-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbcFNNS7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:18:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 35371E7DBD
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2253A9EBA8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 960739EBA8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:55 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that unsetters don't set pointers to NULL, check if the attribute is
set before trying to release it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c          | 18 ++++++++++--------
 src/expr/immediate.c |  2 +-
 src/expr/log.c       |  2 +-
 src/expr/match.c     |  4 ++--
 src/expr/target.c    |  2 +-
 src/rule.c           | 20 +++++++++++---------
 src/set.c            | 14 ++++++++------
 src/set_elem.c       | 20 +++++++++-----------
 src/table.c          |  5 +++--
 9 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index e0f548c..86ccef6 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -95,11 +95,11 @@ EXPORT_SYMBOL(nftnl_chain_alloc);
 
 void nftnl_chain_free(const struct nftnl_chain *c)
 {
-	if (c->table != NULL)
+	if (c->flags & (1 << NFTNL_CHAIN_TABLE))
 		xfree(c->table);
-	if (c->type != NULL)
+	if (c->flags & (1 << NFTNL_CHAIN_TYPE))
 		xfree(c->type);
-	if (c->dev != NULL)
+	if (c->flags & (1 << NFTNL_CHAIN_DEV))
 		xfree(c->dev);
 
 	xfree(c);
@@ -167,7 +167,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
 		break;
 	case NFTNL_CHAIN_TABLE:
-		if (c->table)
+		if (c->flags & (1 << NFTNL_CHAIN_TABLE))
 			xfree(c->table);
 
 		c->table = strdup(data);
@@ -199,7 +199,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 		c->family = *((uint32_t *)data);
 		break;
 	case NFTNL_CHAIN_TYPE:
-		if (c->type)
+		if (c->flags & (1 << NFTNL_CHAIN_TYPE))
 			xfree(c->type);
 
 		c->type = strdup(data);
@@ -207,7 +207,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			return -1;
 		break;
 	case NFTNL_CHAIN_DEV:
-		if (c->dev)
+		if (c->flags & (1 << NFTNL_CHAIN_DEV))
 			xfree(c->dev);
 
 		c->dev = strdup(data);
@@ -533,7 +533,8 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 		c->flags |= (1 << NFTNL_CHAIN_NAME);
 	}
 	if (tb[NFTA_CHAIN_TABLE]) {
-		xfree(c->table);
+		if (c->flags & (1 << NFTNL_CHAIN_TABLE))
+			xfree(c->table);
 		c->table = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
 		if (!c->table)
 			return -1;
@@ -562,7 +563,8 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 		c->flags |= (1 << NFTNL_CHAIN_HANDLE);
 	}
 	if (tb[NFTA_CHAIN_TYPE]) {
-		xfree(c->type);
+		if (c->flags & (1 << NFTNL_CHAIN_TYPE))
+			xfree(c->type);
 		c->type = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TYPE]));
 		if (!c->type)
 			return -1;
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 243f0e0..22ec864 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -43,7 +43,7 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 		imm->data.verdict = *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_IMM_CHAIN:
-		if (imm->data.chain)
+		if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
 			xfree(imm->data.chain);
 
 		imm->data.chain = strdup(data);
diff --git a/src/expr/log.c b/src/expr/log.c
index 5b774a4..b9b3951 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -37,7 +37,7 @@ static int nftnl_expr_log_set(struct nftnl_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFTNL_EXPR_LOG_PREFIX:
-		if (log->prefix)
+		if (log->flags & (1 << NFTNL_EXPR_LOG_PREFIX))
 			xfree(log->prefix);
 
 		log->prefix = strdup(data);
diff --git a/src/expr/match.c b/src/expr/match.c
index 2929b43..3342e2c 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -49,7 +49,7 @@ nftnl_expr_match_set(struct nftnl_expr *e, uint16_t type,
 		mt->rev = *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_MT_INFO:
-		if (mt->data)
+		if (e->flags & (1 << NFTNL_EXPR_MT_INFO))
 			xfree(mt->data);
 
 		mt->data = data;
@@ -146,7 +146,7 @@ static int nftnl_expr_match_parse(struct nftnl_expr *e, struct nlattr *attr)
 		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_MATCH_INFO]);
 		void *match_data;
 
-		if (match->data)
+		if (e->flags & (1 << NFTNL_EXPR_MT_INFO))
 			xfree(match->data);
 
 		match_data = calloc(1, len);
diff --git a/src/expr/target.c b/src/expr/target.c
index 68a7d8a..d4c0091 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -49,7 +49,7 @@ nftnl_expr_target_set(struct nftnl_expr *e, uint16_t type,
 		tg->rev = *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_TG_INFO:
-		if (tg->data)
+		if (e->flags & (1 << NFTNL_EXPR_TG_INFO))
 			xfree(tg->data);
 
 		tg->data = data;
diff --git a/src/rule.c b/src/rule.c
index 375552e..c46c325 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -71,11 +71,11 @@ void nftnl_rule_free(const struct nftnl_rule *r)
 	list_for_each_entry_safe(e, tmp, &r->expr_list, head)
 		nftnl_expr_free(e);
 
-	if (r->table != NULL)
+	if (r->flags & (1 << (NFTNL_RULE_TABLE)))
 		xfree(r->table);
-	if (r->chain != NULL)
+	if (r->flags & (1 << (NFTNL_RULE_CHAIN)))
 		xfree(r->chain);
-	if (r->user.data != NULL)
+	if (r->flags & (1 << (NFTNL_RULE_USERDATA)))
 		xfree(r->user.data);
 
 	xfree(r);
@@ -129,7 +129,7 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 
 	switch(attr) {
 	case NFTNL_RULE_TABLE:
-		if (r->table)
+		if (r->flags & (1 << NFTNL_RULE_TABLE))
 			xfree(r->table);
 
 		r->table = strdup(data);
@@ -137,7 +137,7 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 			return -1;
 		break;
 	case NFTNL_RULE_CHAIN:
-		if (r->chain)
+		if (r->flags & (1 << NFTNL_RULE_CHAIN))
 			xfree(r->chain);
 
 		r->chain = strdup(data);
@@ -160,7 +160,7 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 		r->position = *((uint64_t *)data);
 		break;
 	case NFTNL_RULE_USERDATA:
-		if (r->user.data != NULL)
+		if (r->flags & (1 << NFTNL_RULE_USERDATA))
 			xfree(r->user.data);
 
 		r->user.data = malloc(data_len);
@@ -431,14 +431,16 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 		return -1;
 
 	if (tb[NFTA_RULE_TABLE]) {
-		xfree(r->table);
+		if (r->flags & (1 << NFTNL_RULE_TABLE))
+			xfree(r->table);
 		r->table = strdup(mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
 		if (!r->table)
 			return -1;
 		r->flags |= (1 << NFTNL_RULE_TABLE);
 	}
 	if (tb[NFTA_RULE_CHAIN]) {
-		xfree(r->chain);
+		if (r->flags & (1 << NFTNL_RULE_CHAIN))
+			xfree(r->chain);
 		r->chain = strdup(mnl_attr_get_str(tb[NFTA_RULE_CHAIN]));
 		if (!r->chain)
 			return -1;
@@ -460,7 +462,7 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 		const void *udata =
 			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
 
-		if (r->user.data)
+		if (r->flags & (1 << NFTNL_RULE_USERDATA))
 			xfree(r->user.data);
 
 		r->user.len = mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
diff --git a/src/set.c b/src/set.c
index ccea313..132e913 100644
--- a/src/set.c
+++ b/src/set.c
@@ -44,9 +44,9 @@ void nftnl_set_free(const struct nftnl_set *s)
 {
 	struct nftnl_set_elem *elem, *tmp;
 
-	if (s->table != NULL)
+	if (s->flags & (1 << NFTNL_SET_TABLE))
 		xfree(s->table);
-	if (s->name != NULL)
+	if (s->flags & (1 << NFTNL_SET_NAME))
 		xfree(s->name);
 
 	list_for_each_entry_safe(elem, tmp, &s->element_list, head) {
@@ -116,7 +116,7 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 
 	switch(attr) {
 	case NFTNL_SET_TABLE:
-		if (s->table)
+		if (s->flags & (1 << NFTNL_SET_TABLE))
 			xfree(s->table);
 
 		s->table = strdup(data);
@@ -124,7 +124,7 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 			return -1;
 		break;
 	case NFTNL_SET_NAME:
-		if (s->name)
+		if (s->flags & (1 << NFTNL_SET_NAME))
 			xfree(s->name);
 
 		s->name = strdup(data);
@@ -439,14 +439,16 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		return -1;
 
 	if (tb[NFTA_SET_TABLE]) {
-		xfree(s->table);
+		if (s->flags & (1 << NFTNL_SET_TABLE))
+			xfree(s->table);
 		s->table = strdup(mnl_attr_get_str(tb[NFTA_SET_TABLE]));
 		if (!s->table)
 			return -1;
 		s->flags |= (1 << NFTNL_SET_TABLE);
 	}
 	if (tb[NFTA_SET_NAME]) {
-		xfree(s->name);
+		if (s->flags & (1 << NFTNL_SET_NAME))
+			xfree(s->name);
 		s->name = strdup(mnl_attr_get_str(tb[NFTA_SET_NAME]));
 		if (!s->name)
 			return -1;
diff --git a/src/set_elem.c b/src/set_elem.c
index dbf4176..596ba8a 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -41,12 +41,8 @@ EXPORT_SYMBOL(nftnl_set_elem_alloc);
 
 void nftnl_set_elem_free(struct nftnl_set_elem *s)
 {
-	if (s->flags & (1 << NFTNL_SET_ELEM_CHAIN)) {
-		if (s->data.chain) {
-			xfree(s->data.chain);
-			s->data.chain = NULL;
-		}
-	}
+	if (s->flags & (1 << NFTNL_SET_ELEM_CHAIN))
+		xfree(s->data.chain);
 
 	if (s->flags & (1 << NFTNL_SET_ELEM_EXPR))
 		nftnl_expr_free(s->expr);
@@ -107,7 +103,7 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		s->data.verdict = *((uint32_t *)data);
 		break;
 	case NFTNL_SET_ELEM_CHAIN:	/* NFTA_SET_ELEM_DATA */
-		if (s->data.chain)
+		if (s->flags & (1 << NFTNL_SET_ELEM_CHAIN))
 			xfree(s->data.chain);
 
 		s->data.chain = strdup(data);
@@ -122,7 +118,7 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		s->timeout = *((uint64_t *)data);
 		break;
 	case NFTNL_SET_ELEM_USERDATA: /* NFTA_SET_ELEM_USERDATA */
-		if (s->user.data != NULL)
+		if (s->flags & (1 << NFTNL_SET_ELEM_USERDATA))
 			xfree(s->user.data);
 
 		s->user.data = malloc(data_len);
@@ -400,7 +396,7 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 		const void *udata =
 			mnl_attr_get_payload(tb[NFTA_SET_ELEM_USERDATA]);
 
-		if (e->user.data)
+		if (e->flags & (1 << NFTNL_RULE_USERDATA))
 			xfree(e->user.data);
 
 		e->user.len  = mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]);
@@ -473,7 +469,8 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		return -1;
 
 	if (tb[NFTA_SET_ELEM_LIST_TABLE]) {
-		xfree(s->table);
+		if (s->flags & (1 << NFTNL_SET_TABLE))
+			xfree(s->table);
 		s->table =
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_TABLE]));
 		if (!s->table)
@@ -481,7 +478,8 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		s->flags |= (1 << NFTNL_SET_TABLE);
 	}
 	if (tb[NFTA_SET_ELEM_LIST_SET]) {
-		xfree(s->name);
+		if (s->flags & (1 << NFTNL_SET_NAME))
+			xfree(s->name);
 		s->name =
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
 		if (!s->name)
diff --git a/src/table.c b/src/table.c
index 03b618f..9231937 100644
--- a/src/table.c
+++ b/src/table.c
@@ -89,7 +89,7 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 
 	switch (attr) {
 	case NFTNL_TABLE_NAME:
-		if (t->name)
+		if (t->flags & (1 << NFTNL_TABLE_NAME))
 			xfree(t->name);
 
 		t->name = strdup(data);
@@ -227,7 +227,8 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 		return -1;
 
 	if (tb[NFTA_TABLE_NAME]) {
-		xfree(t->name);
+		if (t->flags & (1 << NFTNL_TABLE_NAME))
+			xfree(t->name);
 		t->name = strdup(mnl_attr_get_str(tb[NFTA_TABLE_NAME]));
 		if (!t->name)
 			return -1;
-- 
2.1.4

