From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl, v2] fix some error checking in parser functions
Date: Mon, 20 Jun 2016 12:29:19 +0200
Message-ID: <1466418559-4495-1-git-send-email-carlosfg@riseup.net>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:35791 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbcFTKam (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 06:30:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use a variable 'ret' multiple times without treat the error between can
overwrite the previous error value, and may execute code which should not.

Bad way:
	int f() {
		int ret;

		ret = g();
		ret = h();

		return ret;
	}

Good way:
	int f() {
		int ret;

		ret = g();
		if (ret < 0)
			return ret;

		ret = h();
		if (ret < 0)
			return ret;

		return 0;
	}
---
 src/rule.c     | 14 ++++++++++----
 src/set.c      |  9 ++++++---
 src/set_elem.c | 41 ++++++++++++++++++++++++-----------------
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index b009c37..c87fea7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -427,7 +427,7 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 {
 	struct nlattr *tb[NFTA_RULE_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
-	int ret = 0;
+	int ret;
 
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_rule_parse_attr_cb, tb) < 0)
 		return -1;
@@ -452,10 +452,16 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 		r->handle = be64toh(mnl_attr_get_u64(tb[NFTA_RULE_HANDLE]));
 		r->flags |= (1 << NFTNL_RULE_HANDLE);
 	}
-	if (tb[NFTA_RULE_EXPRESSIONS])
+	if (tb[NFTA_RULE_EXPRESSIONS]) {
 		ret = nftnl_rule_parse_expr(tb[NFTA_RULE_EXPRESSIONS], r);
-	if (tb[NFTA_RULE_COMPAT])
+		if (ret < 0)
+			return ret;
+	}
+	if (tb[NFTA_RULE_COMPAT]) {
 		ret = nftnl_rule_parse_compat(tb[NFTA_RULE_COMPAT], r);
+		if (ret < 0)
+			return ret;
+	}
 	if (tb[NFTA_RULE_POSITION]) {
 		r->position = be64toh(mnl_attr_get_u64(tb[NFTA_RULE_POSITION]));
 		r->flags |= (1 << NFTNL_RULE_POSITION);
@@ -480,7 +486,7 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 	r->family = nfg->nfgen_family;
 	r->flags |= (1 << NFTNL_RULE_FAMILY);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_nlmsg_parse, nft_rule_nlmsg_parse);
 
diff --git a/src/set.c b/src/set.c
index 08d5797..47e0c45 100644
--- a/src/set.c
+++ b/src/set.c
@@ -433,7 +433,7 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 {
 	struct nlattr *tb[NFTA_SET_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
-	int ret = 0;
+	int ret;
 
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_set_parse_attr_cb, tb) < 0)
 		return -1;
@@ -490,13 +490,16 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		s->gc_interval = ntohl(mnl_attr_get_u32(tb[NFTA_SET_GC_INTERVAL]));
 		s->flags |= (1 << NFTNL_SET_GC_INTERVAL);
 	}
-	if (tb[NFTA_SET_DESC])
+	if (tb[NFTA_SET_DESC]) {
 		ret = nftnl_set_desc_parse(s, tb[NFTA_SET_DESC]);
+		if (ret < 0)
+			return ret;
+	}
 
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFTNL_SET_FAMILY);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_nlmsg_parse, nft_set_nlmsg_parse);
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 8cceeae..94b50f9 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -345,16 +345,15 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 {
 	struct nlattr *tb[NFTA_SET_ELEM_MAX+1] = {};
 	struct nftnl_set_elem *e;
-	int ret = 0, type;
+	int ret, type;
 
 	e = nftnl_set_elem_alloc();
 	if (e == NULL)
 		return -1;
 
-	if (mnl_attr_parse_nested(nest, nftnl_set_elem_parse_attr_cb, tb) < 0) {
-		nftnl_set_elem_free(e);
-		return -1;
-	}
+	ret = mnl_attr_parse_nested(nest, nftnl_set_elem_parse_attr_cb, tb);
+	if (ret < 0)
+		goto out_set_elem;
 
 	if (tb[NFTA_SET_ELEM_FLAGS]) {
 		e->set_elem_flags =
@@ -371,10 +370,14 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 	}
         if (tb[NFTA_SET_ELEM_KEY]) {
 		ret = nftnl_parse_data(&e->key, tb[NFTA_SET_ELEM_KEY], &type);
+		if (ret < 0)
+			goto out_set_elem;
 		e->flags |= (1 << NFTNL_SET_ELEM_KEY);
         }
         if (tb[NFTA_SET_ELEM_DATA]) {
 		ret = nftnl_parse_data(&e->data, tb[NFTA_SET_ELEM_DATA], &type);
+		if (ret < 0)
+			goto out_set_elem;
 		switch(type) {
 		case DATA_VERDICT:
 			e->flags |= (1 << NFTNL_SET_ELEM_VERDICT);
@@ -391,7 +394,7 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 	if (tb[NFTA_SET_ELEM_EXPR]) {
 		e->expr = nftnl_expr_parse(tb[NFTA_SET_ELEM_EXPR]);
 		if (e->expr == NULL)
-			goto err;
+			goto out_set_elem;
 		e->flags |= (1 << NFTNL_SET_ELEM_EXPR);
 	}
 	if (tb[NFTA_SET_ELEM_USERDATA]) {
@@ -404,20 +407,19 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 		e->user.len  = mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]);
 		e->user.data = malloc(e->user.len);
 		if (e->user.data == NULL)
-			goto err;
+			goto out_expr;
 		memcpy(e->user.data, udata, e->user.len);
 		e->flags |= (1 << NFTNL_RULE_USERDATA);
 	}
 
-	if (ret < 0) {
-err:
-		nftnl_set_elem_free(e);
-		return -1;
-	}
-
 	/* Add this new element to this set */
 	list_add_tail(&e->head, &s->element_list);
 
+	return 0;
+out_expr:
+	nftnl_expr_free(e->expr);
+out_set_elem:
+	nftnl_set_elem_free(e);
 	return ret;
 }
 
@@ -449,13 +451,15 @@ nftnl_set_elem_list_parse_attr_cb(const struct nlattr *attr, void *data)
 static int nftnl_set_elems_parse(struct nftnl_set *s, const struct nlattr *nest)
 {
 	struct nlattr *attr;
-	int ret = 0;
+	int ret;
 
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) != NFTA_LIST_ELEM)
 			return -1;
 
 		ret = nftnl_set_elems_parse2(s, attr);
+		if (ret < 0)
+			return ret;
 	}
 	return ret;
 }
@@ -464,7 +468,7 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 {
 	struct nlattr *tb[NFTA_SET_ELEM_LIST_MAX+1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
-	int ret = 0;
+	int ret;
 
 	if (mnl_attr_parse(nlh, sizeof(*nfg),
 			   nftnl_set_elem_list_parse_attr_cb, tb) < 0)
@@ -492,13 +496,16 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		s->id = ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_LIST_SET_ID]));
 		s->flags |= (1 << NFTNL_SET_ID);
 	}
-        if (tb[NFTA_SET_ELEM_LIST_ELEMENTS])
+        if (tb[NFTA_SET_ELEM_LIST_ELEMENTS]) {
 	 	ret = nftnl_set_elems_parse(s, tb[NFTA_SET_ELEM_LIST_ELEMENTS]);
+		if (ret < 0)
+			return ret;
+	}
 
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFTNL_SET_FAMILY);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elems_nlmsg_parse, nft_set_elems_nlmsg_parse);
 
-- 
2.5.1

