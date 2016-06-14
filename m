From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 4/9] src: check for strdup() errors from setters and parsers
Date: Tue, 14 Jun 2016 15:18:40 +0200
Message-ID: <1465910325-13286-4-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55952 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbcFNNTA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:19:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 32D30E7DC1
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 146DD9EBA9
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A3EFF9EBA9
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:53 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

And pass up an error to the caller.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c          |  6 ++++++
 src/expr/data_reg.c  |  3 +++
 src/expr/dynset.c    |  4 ++++
 src/expr/immediate.c |  2 ++
 src/expr/log.c       |  4 ++++
 src/expr/lookup.c    |  4 ++++
 src/rule.c           |  4 ++++
 src/set.c            | 14 ++++++++++++--
 src/set_elem.c       | 14 +++++++++++++-
 src/table.c          |  2 ++
 src/trace.c          | 24 +++++++++++++++++-------
 11 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 6a2cfae..0c79dd5 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -519,6 +519,8 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
 	}
 	if (tb[NFTA_HOOK_DEV]) {
 		c->dev = strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
+		if (!c->dev)
+			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_DEV);
 	}
 
@@ -542,6 +544,8 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 	if (tb[NFTA_CHAIN_TABLE]) {
 		xfree(c->table);
 		c->table = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
+		if (!c->table)
+			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_TABLE);
 	}
 	if (tb[NFTA_CHAIN_HOOK]) {
@@ -569,6 +573,8 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 	if (tb[NFTA_CHAIN_TYPE]) {
 		xfree(c->type);
 		c->type = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TYPE]));
+		if (!c->type)
+			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_TYPE);
 	}
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 2a23285..6aa47bc 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -455,6 +455,9 @@ nftnl_parse_verdict(union nftnl_data_reg *data, const struct nlattr *attr, int *
 			return -1;
 
 		data->chain = strdup(mnl_attr_get_str(tb[NFTA_VERDICT_CHAIN]));
+		if (!data->chain)
+			return -1;
+
 		if (type)
 			*type = DATA_CHAIN;
 		break;
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index c8d97a5..0404359 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -53,6 +53,8 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t type,
 		break;
 	case NFTNL_EXPR_DYNSET_SET_NAME:
 		dynset->set_name = strdup((const char *)data);
+		if (!dynset->set_name)
+			return -1;
 		break;
 	case NFTNL_EXPR_DYNSET_SET_ID:
 		dynset->set_id = *((uint32_t *)data);
@@ -183,6 +185,8 @@ nftnl_expr_dynset_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (tb[NFTA_DYNSET_SET_NAME]) {
 		dynset->set_name =
 			strdup(mnl_attr_get_str(tb[NFTA_DYNSET_SET_NAME]));
+		if (!dynset->set_name)
+			return -1;
 		e->flags |= (1 << NFTNL_EXPR_DYNSET_SET_NAME);
 	}
 	if (tb[NFTA_DYNSET_SET_ID]) {
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index eb2ca0f..243f0e0 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -47,6 +47,8 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 			xfree(imm->data.chain);
 
 		imm->data.chain = strdup(data);
+		if (!imm->data.chain)
+			return -1;
 		break;
 	default:
 		return -1;
diff --git a/src/expr/log.c b/src/expr/log.c
index c3dc0a6..5b774a4 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -41,6 +41,8 @@ static int nftnl_expr_log_set(struct nftnl_expr *e, uint16_t type,
 			xfree(log->prefix);
 
 		log->prefix = strdup(data);
+		if (!log->prefix)
+			return -1;
 		break;
 	case NFTNL_EXPR_LOG_GROUP:
 		log->group = *((uint16_t *)data);
@@ -155,6 +157,8 @@ nftnl_expr_log_parse(struct nftnl_expr *e, struct nlattr *attr)
 			xfree(log->prefix);
 
 		log->prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
+		if (!log->prefix)
+			return -1;
 		e->flags |= (1 << NFTNL_EXPR_LOG_PREFIX);
 	}
 	if (tb[NFTA_LOG_GROUP]) {
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index ed32ba6..daafdb2 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -43,6 +43,8 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t type,
 		break;
 	case NFTNL_EXPR_LOOKUP_SET:
 		lookup->set_name = strdup((const char *)data);
+		if (!lookup->set_name)
+			return -1;
 		break;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
 		lookup->set_id = *((uint32_t *)data);
@@ -137,6 +139,8 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (tb[NFTA_LOOKUP_SET]) {
 		lookup->set_name =
 			strdup(mnl_attr_get_str(tb[NFTA_LOOKUP_SET]));
+		if (lookup->set_name)
+			return -1;
 		e->flags |= (1 << NFTNL_EXPR_LOOKUP_SET);
 	}
 	if (tb[NFTA_LOOKUP_SET_ID]) {
diff --git a/src/rule.c b/src/rule.c
index 310332f..293c0cf 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -439,11 +439,15 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 	if (tb[NFTA_RULE_TABLE]) {
 		xfree(r->table);
 		r->table = strdup(mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
+		if (!r->table)
+			return -1;
 		r->flags |= (1 << NFTNL_RULE_TABLE);
 	}
 	if (tb[NFTA_RULE_CHAIN]) {
 		xfree(r->chain);
 		r->chain = strdup(mnl_attr_get_str(tb[NFTA_RULE_CHAIN]));
+		if (!r->chain)
+			return -1;
 		r->flags |= (1 << NFTNL_RULE_CHAIN);
 	}
 	if (tb[NFTA_RULE_HANDLE]) {
diff --git a/src/set.c b/src/set.c
index 797c6ca..a35c4ec 100644
--- a/src/set.c
+++ b/src/set.c
@@ -294,10 +294,16 @@ struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
 
 	memcpy(newset, set, sizeof(*set));
 
-	if (set->flags & (1 << NFTNL_SET_TABLE))
+	if (set->flags & (1 << NFTNL_SET_TABLE)) {
 		newset->table = strdup(set->table);
-	if (set->flags & (1 << NFTNL_SET_NAME))
+		if (!newset->table)
+			goto err;
+	}
+	if (set->flags & (1 << NFTNL_SET_NAME)) {
 		newset->name = strdup(set->name);
+		if (!newset->name)
+			goto err;
+	}
 
 	INIT_LIST_HEAD(&newset->element_list);
 	list_for_each_entry(elem, &set->element_list, head) {
@@ -440,11 +446,15 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 	if (tb[NFTA_SET_TABLE]) {
 		xfree(s->table);
 		s->table = strdup(mnl_attr_get_str(tb[NFTA_SET_TABLE]));
+		if (!s->table)
+			return -1;
 		s->flags |= (1 << NFTNL_SET_TABLE);
 	}
 	if (tb[NFTA_SET_NAME]) {
 		xfree(s->name);
 		s->name = strdup(mnl_attr_get_str(tb[NFTA_SET_NAME]));
+		if (!s->name)
+			return -1;
 		s->flags |= (1 << NFTNL_SET_NAME);
 	}
 	if (tb[NFTA_SET_FLAGS]) {
diff --git a/src/set_elem.c b/src/set_elem.c
index 645bca8..ec0a4b7 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -116,6 +116,8 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 			xfree(s->data.chain);
 
 		s->data.chain = strdup(data);
+		if (!s->data.chain)
+			return -1;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
 		memcpy(s->data.val, data, data_len);
@@ -224,10 +226,16 @@ struct nftnl_set_elem *nftnl_set_elem_clone(struct nftnl_set_elem *elem)
 
 	memcpy(newelem, elem, sizeof(*elem));
 
-	if (elem->flags & (1 << NFTNL_SET_ELEM_CHAIN))
+	if (elem->flags & (1 << NFTNL_SET_ELEM_CHAIN)) {
 		newelem->data.chain = strdup(elem->data.chain);
+		if (!newelem->data.chain)
+			goto err;
+	}
 
 	return newelem;
+err:
+	nftnl_set_elem_free(newelem);
+	return NULL;
 }
 
 void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
@@ -473,12 +481,16 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		xfree(s->table);
 		s->table =
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_TABLE]));
+		if (!s->table)
+			return -1;
 		s->flags |= (1 << NFTNL_SET_TABLE);
 	}
 	if (tb[NFTA_SET_ELEM_LIST_SET]) {
 		xfree(s->name);
 		s->name =
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
+		if (!s->name)
+			return -1;
 		s->flags |= (1 << NFTNL_SET_NAME);
 	}
 	if (tb[NFTA_SET_ELEM_LIST_SET_ID]) {
diff --git a/src/table.c b/src/table.c
index 595b0ac..4f86426 100644
--- a/src/table.c
+++ b/src/table.c
@@ -232,6 +232,8 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 	if (tb[NFTA_TABLE_NAME]) {
 		xfree(t->name);
 		t->name = strdup(mnl_attr_get_str(tb[NFTA_TABLE_NAME]));
+		if (!t->name)
+			return -1;
 		t->flags |= (1 << NFTNL_TABLE_NAME);
 	}
 	if (tb[NFTA_TABLE_FLAGS]) {
diff --git a/src/trace.c b/src/trace.c
index 921fa21..d8f561d 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -296,8 +296,8 @@ static int nftnl_trace_parse_verdict_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static void
-nftnl_trace_parse_verdict(const struct nlattr *attr, struct nftnl_trace *t)
+static int nftnl_trace_parse_verdict(const struct nlattr *attr,
+				     struct nftnl_trace *t)
 {
 	struct nlattr *tb[NFTA_VERDICT_MAX+1];
 
@@ -315,13 +315,16 @@ nftnl_trace_parse_verdict(const struct nlattr *attr, struct nftnl_trace *t)
 		if (!tb[NFTA_VERDICT_CHAIN])
 			abi_breakage();
 		t->jump_target = strdup(mnl_attr_get_str(tb[NFTA_VERDICT_CHAIN]));
-		if (t->jump_target)
-			t->flags |= (1 << NFTNL_TRACE_JUMP_TARGET);
+		if (!t->jump_target)
+			return -1;
+
+		t->flags |= (1 << NFTNL_TRACE_JUMP_TARGET);
 		break;
 	}
+	return 0;
 }
-
 EXPORT_SYMBOL(nftnl_trace_nlmsg_parse);
+
 int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 {
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
@@ -347,11 +350,17 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 
 	if (tb[NFTA_TRACE_TABLE]) {
 		t->table = strdup(mnl_attr_get_str(tb[NFTA_TRACE_TABLE]));
+		if (!t->table)
+			return -1;
+
 		t->flags |= (1 << NFTNL_TRACE_TABLE);
 	}
 
 	if (tb[NFTA_TRACE_CHAIN]) {
 		t->chain = strdup(mnl_attr_get_str(tb[NFTA_TRACE_CHAIN]));
+		if (!t->chain)
+			return -1;
+
 		t->flags |= (1 << NFTNL_TRACE_CHAIN);
 	}
 
@@ -385,8 +394,9 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 		t->flags |= (1 << NFTNL_TRACE_RULE_HANDLE);
 	}
 
-	if (tb[NFTA_TRACE_VERDICT])
-		nftnl_trace_parse_verdict(tb[NFTA_TRACE_VERDICT], t);
+	if (tb[NFTA_TRACE_VERDICT] &&
+	    nftnl_trace_parse_verdict(tb[NFTA_TRACE_VERDICT], t) < 0)
+		return -1;
 
 	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_LL_HEADER], &t->ll))
 		t->flags |= (1 << NFTNL_TRACE_LL_HEADER);
-- 
2.1.4

