From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH v2 libnftnl] Check all strdup
Date: Tue, 31 May 2016 12:08:32 +0200
Message-ID: <1464689312-8136-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50292 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbcEaKIl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 06:08:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check all strdup possible error and treat it consequently.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/chain.c          | 12 ++++++++++++
 src/expr/data_reg.c  |  6 ++++++
 src/expr/dynset.c    |  4 ++++
 src/expr/immediate.c |  2 ++
 src/expr/log.c       |  4 ++++
 src/expr/lookup.c    |  4 ++++
 src/rule.c           |  8 ++++++++
 src/set.c            | 18 ++++++++++++++++--
 src/set_elem.c       | 14 +++++++++++++-
 9 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 990c576..b20e007 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -182,6 +182,8 @@ void nftnl_chain_set_data(struct nftnl_chain *c, ui=
nt16_t attr,
 			xfree(c->table);
=20
 		c->table =3D strdup(data);
+		if (!c->table)
+			return;
 		break;
 	case NFTNL_CHAIN_HOOKNUM:
 		memcpy(&c->hooknum, data, sizeof(c->hooknum));
@@ -212,12 +214,16 @@ void nftnl_chain_set_data(struct nftnl_chain *c, =
uint16_t attr,
 			xfree(c->type);
=20
 		c->type =3D strdup(data);
+		if (!c->type)
+			return;
 		break;
 	case NFTNL_CHAIN_DEV:
 		if (c->dev)
 			xfree(c->dev);
=20
 		c->dev =3D strdup(data);
+		if (!c->dev)
+			return;
 		break;
 	}
 	c->flags |=3D (1 << attr);
@@ -514,6 +520,8 @@ static int nftnl_chain_parse_hook(struct nlattr *at=
tr, struct nftnl_chain *c)
 	}
 	if (tb[NFTA_HOOK_DEV]) {
 		c->dev =3D strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
+		if (!c->dev)
+			return -1;
 		c->flags |=3D (1 << NFTNL_CHAIN_DEV);
 	}
=20
@@ -537,6 +545,8 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nftnl_chain *c)
 	if (tb[NFTA_CHAIN_TABLE]) {
 		xfree(c->table);
 		c->table =3D strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
+		if (!c->table)
+			return -1;
 		c->flags |=3D (1 << NFTNL_CHAIN_TABLE);
 	}
 	if (tb[NFTA_CHAIN_HOOK]) {
@@ -564,6 +574,8 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nftnl_chain *c)
 	if (tb[NFTA_CHAIN_TYPE]) {
 		xfree(c->type);
 		c->type =3D strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TYPE]));
+		if (!c->type)
+			return -1;
 		c->flags |=3D (1 << NFTNL_CHAIN_TYPE);
 	}
=20
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 2a23285..f4e7125 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -51,6 +51,8 @@ static int nftnl_data_reg_verdict_json_parse(union nf=
tnl_data_reg *reg, json_t *
 			return DATA_NONE;
=20
 		reg->chain =3D strdup(chain);
+		if (!reg->chain)
+			return -1;
 	}
=20
 	return DATA_VERDICT;
@@ -126,6 +128,8 @@ static int nftnl_data_reg_verdict_xml_parse(union n=
ftnl_data_reg *reg,
 			xfree(reg->chain);
=20
 		reg->chain =3D strdup(chain);
+		if (!reg->chain)
+			return -1;
 	}
=20
 	return DATA_VERDICT;
@@ -455,6 +459,8 @@ nftnl_parse_verdict(union nftnl_data_reg *data, con=
st struct nlattr *attr, int *
 			return -1;
=20
 		data->chain =3D strdup(mnl_attr_get_str(tb[NFTA_VERDICT_CHAIN]));
+		if (!data->chain)
+			return -1;
 		if (type)
 			*type =3D DATA_CHAIN;
 		break;
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index c8d97a5..0404359 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -53,6 +53,8 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t =
type,
 		break;
 	case NFTNL_EXPR_DYNSET_SET_NAME:
 		dynset->set_name =3D strdup((const char *)data);
+		if (!dynset->set_name)
+			return -1;
 		break;
 	case NFTNL_EXPR_DYNSET_SET_ID:
 		dynset->set_id =3D *((uint32_t *)data);
@@ -183,6 +185,8 @@ nftnl_expr_dynset_parse(struct nftnl_expr *e, struc=
t nlattr *attr)
 	if (tb[NFTA_DYNSET_SET_NAME]) {
 		dynset->set_name =3D
 			strdup(mnl_attr_get_str(tb[NFTA_DYNSET_SET_NAME]));
+		if (!dynset->set_name)
+			return -1;
 		e->flags |=3D (1 << NFTNL_EXPR_DYNSET_SET_NAME);
 	}
 	if (tb[NFTA_DYNSET_SET_ID]) {
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index eb2ca0f..243f0e0 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -47,6 +47,8 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16=
_t type,
 			xfree(imm->data.chain);
=20
 		imm->data.chain =3D strdup(data);
+		if (!imm->data.chain)
+			return -1;
 		break;
 	default:
 		return -1;
diff --git a/src/expr/log.c b/src/expr/log.c
index c3dc0a6..5b774a4 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -41,6 +41,8 @@ static int nftnl_expr_log_set(struct nftnl_expr *e, u=
int16_t type,
 			xfree(log->prefix);
=20
 		log->prefix =3D strdup(data);
+		if (!log->prefix)
+			return -1;
 		break;
 	case NFTNL_EXPR_LOG_GROUP:
 		log->group =3D *((uint16_t *)data);
@@ -155,6 +157,8 @@ nftnl_expr_log_parse(struct nftnl_expr *e, struct n=
lattr *attr)
 			xfree(log->prefix);
=20
 		log->prefix =3D strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
+		if (!log->prefix)
+			return -1;
 		e->flags |=3D (1 << NFTNL_EXPR_LOG_PREFIX);
 	}
 	if (tb[NFTA_LOG_GROUP]) {
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index ed32ba6..727c287 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -43,6 +43,8 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t =
type,
 		break;
 	case NFTNL_EXPR_LOOKUP_SET:
 		lookup->set_name =3D strdup((const char *)data);
+		if (!lookup->set_name)
+			return -1;
 		break;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
 		lookup->set_id =3D *((uint32_t *)data);
@@ -137,6 +139,8 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struc=
t nlattr *attr)
 	if (tb[NFTA_LOOKUP_SET]) {
 		lookup->set_name =3D
 			strdup(mnl_attr_get_str(tb[NFTA_LOOKUP_SET]));
+		if (!lookup->set_name)
+			return -1;
 		e->flags |=3D (1 << NFTNL_EXPR_LOOKUP_SET);
 	}
 	if (tb[NFTA_LOOKUP_SET_ID]) {
diff --git a/src/rule.c b/src/rule.c
index 8ee8648..c5cf415 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -141,12 +141,16 @@ void nftnl_rule_set_data(struct nftnl_rule *r, ui=
nt16_t attr,
 			xfree(r->table);
=20
 		r->table =3D strdup(data);
+		if (!r->table)
+			return;
 		break;
 	case NFTNL_RULE_CHAIN:
 		if (r->chain)
 			xfree(r->chain);
=20
 		r->chain =3D strdup(data);
+		if (!r->chain)
+			return;
 		break;
 	case NFTNL_RULE_HANDLE:
 		r->handle =3D *((uint64_t *)data);
@@ -436,11 +440,15 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_rule *r)
 	if (tb[NFTA_RULE_TABLE]) {
 		xfree(r->table);
 		r->table =3D strdup(mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
+		if (!r->table)
+			return -1;
 		r->flags |=3D (1 << NFTNL_RULE_TABLE);
 	}
 	if (tb[NFTA_RULE_CHAIN]) {
 		xfree(r->chain);
 		r->chain =3D strdup(mnl_attr_get_str(tb[NFTA_RULE_CHAIN]));
+		if (!r->chain)
+			return -1;
 		r->flags |=3D (1 << NFTNL_RULE_CHAIN);
 	}
 	if (tb[NFTA_RULE_HANDLE]) {
diff --git a/src/set.c b/src/set.c
index dbea93b..eac44e1 100644
--- a/src/set.c
+++ b/src/set.c
@@ -127,12 +127,16 @@ void nftnl_set_set_data(struct nftnl_set *s, uint=
16_t attr, const void *data,
 			xfree(s->table);
=20
 		s->table =3D strdup(data);
+		if (!s->table)
+			return;
 		break;
 	case NFTNL_SET_NAME:
 		if (s->name)
 			xfree(s->name);
=20
 		s->name =3D strdup(data);
+		if (!s->name)
+			return;
 		break;
 	case NFTNL_SET_FLAGS:
 		s->set_flags =3D *((uint32_t *)data);
@@ -291,10 +295,16 @@ struct nftnl_set *nftnl_set_clone(const struct nf=
tnl_set *set)
=20
 	memcpy(newset, set, sizeof(*set));
=20
-	if (set->flags & (1 << NFTNL_SET_TABLE))
+	if (set->flags & (1 << NFTNL_SET_TABLE)) {
 		newset->table =3D strdup(set->table);
-	if (set->flags & (1 << NFTNL_SET_NAME))
+		if (!newset->table)
+			goto err;
+	}
+	if (set->flags & (1 << NFTNL_SET_NAME)) {
 		newset->name =3D strdup(set->name);
+		if (!newset->name)
+			goto err;
+	}
=20
 	INIT_LIST_HEAD(&newset->element_list);
 	list_for_each_entry(elem, &set->element_list, head) {
@@ -437,11 +447,15 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nftnl_set *s)
 	if (tb[NFTA_SET_TABLE]) {
 		xfree(s->table);
 		s->table =3D strdup(mnl_attr_get_str(tb[NFTA_SET_TABLE]));
+		if (!s->table)
+			return -1;
 		s->flags |=3D (1 << NFTNL_SET_TABLE);
 	}
 	if (tb[NFTA_SET_NAME]) {
 		xfree(s->name);
 		s->name =3D strdup(mnl_attr_get_str(tb[NFTA_SET_NAME]));
+		if (!s->name)
+			return -1;
 		s->flags |=3D (1 << NFTNL_SET_NAME);
 	}
 	if (tb[NFTA_SET_FLAGS]) {
diff --git a/src/set_elem.c b/src/set_elem.c
index b9c7e1e..34c0e9b 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -116,6 +116,8 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s, u=
int16_t attr,
 			xfree(s->data.chain);
=20
 		s->data.chain =3D strdup(data);
+		if (!s->data.chain)
+			return;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
 		memcpy(s->data.val, data, data_len);
@@ -225,10 +227,16 @@ struct nftnl_set_elem *nftnl_set_elem_clone(struc=
t nftnl_set_elem *elem)
=20
 	memcpy(newelem, elem, sizeof(*elem));
=20
-	if (elem->flags & (1 << NFTNL_SET_ELEM_CHAIN))
+	if (elem->flags & (1 << NFTNL_SET_ELEM_CHAIN)) {
 		newelem->data.chain =3D strdup(elem->data.chain);
+		if (!newelem->data.chain)
+			goto err;
+	}
=20
 	return newelem;
+err:
+	nftnl_set_elem_free(newelem);
+	return NULL;
 }
=20
 void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
@@ -474,12 +482,16 @@ int nftnl_set_elems_nlmsg_parse(const struct nlms=
ghdr *nlh, struct nftnl_set *s)
 		xfree(s->table);
 		s->table =3D
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_TABLE]));
+		if (!s->table)
+			return -1;
 		s->flags |=3D (1 << NFTNL_SET_TABLE);
 	}
 	if (tb[NFTA_SET_ELEM_LIST_SET]) {
 		xfree(s->name);
 		s->name =3D
 			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
+		if (!s->name)
+			return -1;
 		s->flags |=3D (1 << NFTNL_SET_NAME);
 	}
 	if (tb[NFTA_SET_ELEM_LIST_SET_ID]) {
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
