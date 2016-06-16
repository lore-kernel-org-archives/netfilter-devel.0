From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/3 libnftnl] fix some error checking in parser functions
Date: Thu, 16 Jun 2016 12:20:11 +0200
Message-ID: <20160616102012.32036-2-carlosfg@riseup.net>
References: <20160616102012.32036-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:45675 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbcFPKUX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 06:20:23 -0400
In-Reply-To: <20160616102012.32036-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use a variable 'ret' multiple times without treat the error between can
overwrite the previous error value, and may execute code which should n=
ot.

Bad way:
	int f() {
		int ret;

		ret =3D g();
		ret =3D h();

		return ret;
	}

Good way:
	int f() {
		int ret;

		ret =3D g();
		if (ret)
			return ret;

		ret =3D h();
		if (ret)
			return ret;

		return 0;
	}

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/rule.c     | 14 ++++++++++----
 src/set.c      |  9 ++++++---
 src/set_elem.c | 41 ++++++++++++++++++++++++-----------------
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index b009c37..930ecc0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -427,7 +427,7 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nftnl_rule *r)
 {
 	struct nlattr *tb[NFTA_RULE_MAX+1] =3D {};
 	struct nfgenmsg *nfg =3D mnl_nlmsg_get_payload(nlh);
-	int ret =3D 0;
+	int ret;
=20
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_rule_parse_attr_cb, tb) <=
 0)
 		return -1;
@@ -452,10 +452,16 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_rule *r)
 		r->handle =3D be64toh(mnl_attr_get_u64(tb[NFTA_RULE_HANDLE]));
 		r->flags |=3D (1 << NFTNL_RULE_HANDLE);
 	}
-	if (tb[NFTA_RULE_EXPRESSIONS])
+	if (tb[NFTA_RULE_EXPRESSIONS]) {
 		ret =3D nftnl_rule_parse_expr(tb[NFTA_RULE_EXPRESSIONS], r);
-	if (tb[NFTA_RULE_COMPAT])
+		if (ret)
+			return ret;
+	}
+	if (tb[NFTA_RULE_COMPAT]) {
 		ret =3D nftnl_rule_parse_compat(tb[NFTA_RULE_COMPAT], r);
+		if (ret)
+			return ret;
+	}
 	if (tb[NFTA_RULE_POSITION]) {
 		r->position =3D be64toh(mnl_attr_get_u64(tb[NFTA_RULE_POSITION]));
 		r->flags |=3D (1 << NFTNL_RULE_POSITION);
@@ -480,7 +486,7 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nftnl_rule *r)
 	r->family =3D nfg->nfgen_family;
 	r->flags |=3D (1 << NFTNL_RULE_FAMILY);
=20
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_nlmsg_parse, nft_rule_nlmsg_parse);
=20
diff --git a/src/set.c b/src/set.c
index 08d5797..e1691c7 100644
--- a/src/set.c
+++ b/src/set.c
@@ -433,7 +433,7 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nl=
h, struct nftnl_set *s)
 {
 	struct nlattr *tb[NFTA_SET_MAX+1] =3D {};
 	struct nfgenmsg *nfg =3D mnl_nlmsg_get_payload(nlh);
-	int ret =3D 0;
+	int ret;
=20
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_set_parse_attr_cb, tb) < =
0)
 		return -1;
@@ -490,13 +490,16 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nftnl_set *s)
 		s->gc_interval =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_GC_INTERVAL]))=
;
 		s->flags |=3D (1 << NFTNL_SET_GC_INTERVAL);
 	}
-	if (tb[NFTA_SET_DESC])
+	if (tb[NFTA_SET_DESC]) {
 		ret =3D nftnl_set_desc_parse(s, tb[NFTA_SET_DESC]);
+		if (ret)
+			return ret;
+	}
=20
 	s->family =3D nfg->nfgen_family;
 	s->flags |=3D (1 << NFTNL_SET_FAMILY);
=20
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_nlmsg_parse, nft_set_nlmsg_parse);
=20
diff --git a/src/set_elem.c b/src/set_elem.c
index 8cceeae..e4dd313 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -345,16 +345,15 @@ static int nftnl_set_elems_parse2(struct nftnl_se=
t *s, const struct nlattr *nest
 {
 	struct nlattr *tb[NFTA_SET_ELEM_MAX+1] =3D {};
 	struct nftnl_set_elem *e;
-	int ret =3D 0, type;
+	int ret, type;
=20
 	e =3D nftnl_set_elem_alloc();
 	if (e =3D=3D NULL)
 		return -1;
=20
-	if (mnl_attr_parse_nested(nest, nftnl_set_elem_parse_attr_cb, tb) < 0=
) {
-		nftnl_set_elem_free(e);
-		return -1;
-	}
+	ret =3D mnl_attr_parse_nested(nest, nftnl_set_elem_parse_attr_cb, tb)=
;
+	if (ret)
+		goto out_set_elem;
=20
 	if (tb[NFTA_SET_ELEM_FLAGS]) {
 		e->set_elem_flags =3D
@@ -371,10 +370,14 @@ static int nftnl_set_elems_parse2(struct nftnl_se=
t *s, const struct nlattr *nest
 	}
         if (tb[NFTA_SET_ELEM_KEY]) {
 		ret =3D nftnl_parse_data(&e->key, tb[NFTA_SET_ELEM_KEY], &type);
+		if (ret)
+			goto out_set_elem;
 		e->flags |=3D (1 << NFTNL_SET_ELEM_KEY);
         }
         if (tb[NFTA_SET_ELEM_DATA]) {
 		ret =3D nftnl_parse_data(&e->data, tb[NFTA_SET_ELEM_DATA], &type);
+		if (ret)
+			goto out_set_elem;
 		switch(type) {
 		case DATA_VERDICT:
 			e->flags |=3D (1 << NFTNL_SET_ELEM_VERDICT);
@@ -391,7 +394,7 @@ static int nftnl_set_elems_parse2(struct nftnl_set =
*s, const struct nlattr *nest
 	if (tb[NFTA_SET_ELEM_EXPR]) {
 		e->expr =3D nftnl_expr_parse(tb[NFTA_SET_ELEM_EXPR]);
 		if (e->expr =3D=3D NULL)
-			goto err;
+			goto out_set_elem;
 		e->flags |=3D (1 << NFTNL_SET_ELEM_EXPR);
 	}
 	if (tb[NFTA_SET_ELEM_USERDATA]) {
@@ -404,20 +407,19 @@ static int nftnl_set_elems_parse2(struct nftnl_se=
t *s, const struct nlattr *nest
 		e->user.len  =3D mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]=
);
 		e->user.data =3D malloc(e->user.len);
 		if (e->user.data =3D=3D NULL)
-			goto err;
+			goto out_expr;
 		memcpy(e->user.data, udata, e->user.len);
 		e->flags |=3D (1 << NFTNL_RULE_USERDATA);
 	}
=20
-	if (ret < 0) {
-err:
-		nftnl_set_elem_free(e);
-		return -1;
-	}
-
 	/* Add this new element to this set */
 	list_add_tail(&e->head, &s->element_list);
=20
+	return 0;
+out_expr:
+	nftnl_expr_free(e->expr);
+out_set_elem:
+	nftnl_set_elem_free(e);
 	return ret;
 }
=20
@@ -449,13 +451,15 @@ nftnl_set_elem_list_parse_attr_cb(const struct nl=
attr *attr, void *data)
 static int nftnl_set_elems_parse(struct nftnl_set *s, const struct nla=
ttr *nest)
 {
 	struct nlattr *attr;
-	int ret =3D 0;
+	int ret;
=20
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) !=3D NFTA_LIST_ELEM)
 			return -1;
=20
 		ret =3D nftnl_set_elems_parse2(s, attr);
+		if (ret)
+			return ret;
 	}
 	return ret;
 }
@@ -464,7 +468,7 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsgh=
dr *nlh, struct nftnl_set *s)
 {
 	struct nlattr *tb[NFTA_SET_ELEM_LIST_MAX+1] =3D {};
 	struct nfgenmsg *nfg =3D mnl_nlmsg_get_payload(nlh);
-	int ret =3D 0;
+	int ret;
=20
 	if (mnl_attr_parse(nlh, sizeof(*nfg),
 			   nftnl_set_elem_list_parse_attr_cb, tb) < 0)
@@ -492,13 +496,16 @@ int nftnl_set_elems_nlmsg_parse(const struct nlms=
ghdr *nlh, struct nftnl_set *s)
 		s->id =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_LIST_SET_ID]));
 		s->flags |=3D (1 << NFTNL_SET_ID);
 	}
-        if (tb[NFTA_SET_ELEM_LIST_ELEMENTS])
+        if (tb[NFTA_SET_ELEM_LIST_ELEMENTS]) {
 	 	ret =3D nftnl_set_elems_parse(s, tb[NFTA_SET_ELEM_LIST_ELEMENTS]);
+		if (ret)
+			return ret;
+	}
=20
 	s->family =3D nfg->nfgen_family;
 	s->flags |=3D (1 << NFTNL_SET_FAMILY);
=20
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elems_nlmsg_parse, nft_set_elems_nlmsg_p=
arse);
=20
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
