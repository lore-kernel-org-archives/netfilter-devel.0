From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH v3, libnftnl] Fix nftnl_*_get to set data_len
Date: Mon, 11 Jul 2016 18:07:40 +0200
Message-ID: <1468253260-9384-1-git-send-email-carlosfg@riseup.net>
References: <20160711114807.GA1788@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:57249 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbcGKQIj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 12:08:39 -0400
In-Reply-To: <20160711114807.GA1788@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All getters must set the output parameter 'data_len'

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/chain.c       | 3 +++
 src/expr.c        | 1 +
 src/expr/dynset.c | 3 +++
 src/expr/lookup.c | 3 +++
 src/gen.c         | 1 +
 src/rule.c        | 2 ++
 src/set.c         | 2 ++
 src/set_elem.c    | 6 ++++++
 src/table.c       | 1 +
 src/trace.c       | 6 +++---
 10 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index cab64b5..4c562fe 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -272,8 +272,10 @@ const void *nftnl_chain_get_data(const struct nftn=
l_chain *c, uint16_t attr,
=20
 	switch(attr) {
 	case NFTNL_CHAIN_NAME:
+		*data_len =3D strlen(c->name) + 1;
 		return c->name;
 	case NFTNL_CHAIN_TABLE:
+		*data_len =3D strlen(c->table) + 1;
 		return c->table;
 	case NFTNL_CHAIN_HOOKNUM:
 		*data_len =3D sizeof(uint32_t);
@@ -303,6 +305,7 @@ const void *nftnl_chain_get_data(const struct nftnl=
_chain *c, uint16_t attr,
 		*data_len =3D sizeof(uint32_t);
 		return c->type;
 	case NFTNL_CHAIN_DEV:
+		*data_len =3D strlen(c->dev) + 1;
 		return c->dev;
 	}
 	return NULL;
diff --git a/src/expr.c b/src/expr.c
index f802725..e5c1dd3 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -119,6 +119,7 @@ const void *nftnl_expr_get(const struct nftnl_expr =
*expr,
=20
 	switch(type) {
 	case NFTNL_EXPR_NAME:
+		*data_len =3D strlen(expr->ops->name) + 1;
 		ret =3D expr->ops->name;
 		break;
 	default:
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 0404359..111bf8c 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -88,10 +88,13 @@ nftnl_expr_dynset_get(const struct nftnl_expr *e, u=
int16_t type,
 		*data_len =3D sizeof(dynset->timeout);
 		return &dynset->timeout;
 	case NFTNL_EXPR_DYNSET_SET_NAME:
+		*data_len =3D strlen(dynset->set_name) + 1;
 		return dynset->set_name;
 	case NFTNL_EXPR_DYNSET_SET_ID:
+		*data_len =3D sizeof(dynset->set_id);
 		return &dynset->set_id;
 	case NFTNL_EXPR_DYNSET_EXPR:
+		*data_len =3D 0;
 		return dynset->expr;
 	}
 	return NULL;
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 7f68f74..16cfce2 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -73,10 +73,13 @@ nftnl_expr_lookup_get(const struct nftnl_expr *e, u=
int16_t type,
 		*data_len =3D sizeof(lookup->dreg);
 		return &lookup->dreg;
 	case NFTNL_EXPR_LOOKUP_SET:
+		*data_len =3D strlen(lookup->set_name) + 1;
 		return lookup->set_name;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
+		*data_len =3D sizeof(lookup->set_id);
 		return &lookup->set_id;
 	case NFTNL_EXPR_LOOKUP_FLAGS:
+		*data_len =3D sizeof(lookup->flags);
 		return &lookup->flags;
 	}
 	return NULL;
diff --git a/src/gen.c b/src/gen.c
index 37a9049..c69d2f8 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -100,6 +100,7 @@ const void *nftnl_gen_get_data(const struct nftnl_g=
en *gen, uint16_t attr,
=20
 	switch(attr) {
 	case NFTNL_GEN_ID:
+		*data_len =3D sizeof(gen->id);
 		return &gen->id;
 	}
 	return NULL;
diff --git a/src/rule.c b/src/rule.c
index 2b23c8e..a0edca7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -213,8 +213,10 @@ const void *nftnl_rule_get_data(const struct nftnl=
_rule *r, uint16_t attr,
 		*data_len =3D sizeof(uint32_t);
 		return &r->family;
 	case NFTNL_RULE_TABLE:
+		*data_len =3D strlen(r->table) + 1;
 		return r->table;
 	case NFTNL_RULE_CHAIN:
+		*data_len =3D strlen(r->chain) + 1;
 		return r->chain;
 	case NFTNL_RULE_HANDLE:
 		*data_len =3D sizeof(uint64_t);
diff --git a/src/set.c b/src/set.c
index e48ff78..8a592db 100644
--- a/src/set.c
+++ b/src/set.c
@@ -215,8 +215,10 @@ const void *nftnl_set_get_data(const struct nftnl_=
set *s, uint16_t attr,
=20
 	switch(attr) {
 	case NFTNL_SET_TABLE:
+		*data_len =3D strlen(s->table) + 1;
 		return s->table;
 	case NFTNL_SET_NAME:
+		*data_len =3D strlen(s->name) + 1;
 		return s->name;
 	case NFTNL_SET_FLAGS:
 		*data_len =3D sizeof(uint32_t);
diff --git a/src/set_elem.c b/src/set_elem.c
index 40b5bfe..4e89210 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -160,25 +160,31 @@ const void *nftnl_set_elem_get(struct nftnl_set_e=
lem *s, uint16_t attr, uint32_t
=20
 	switch(attr) {
 	case NFTNL_SET_ELEM_FLAGS:
+		*data_len =3D sizeof(s->set_elem_flags);
 		return &s->set_elem_flags;
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
 		*data_len =3D s->key.len;
 		return &s->key.val;
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
+		*data_len =3D sizeof(s->data.verdict);
 		return &s->data.verdict;
 	case NFTNL_SET_ELEM_CHAIN:	/* NFTA_SET_ELEM_DATA */
+		*data_len =3D strlen(s->data.chain) + 1;
 		return s->data.chain;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
 		*data_len =3D s->data.len;
 		return &s->data.val;
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
+		*data_len =3D sizeof(s->timeout);
 		return &s->timeout;
 	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
+		*data_len =3D sizeof(s->expiration);
 		return &s->expiration;
 	case NFTNL_SET_ELEM_USERDATA:
 		*data_len =3D s->user.len;
 		return s->user.data;
 	case NFTNL_SET_ELEM_EXPR:
+		*data_len =3D 0;
 		return s->expr;
 	}
 	return NULL;
diff --git a/src/table.c b/src/table.c
index 966b923..3d4d7b9 100644
--- a/src/table.c
+++ b/src/table.c
@@ -143,6 +143,7 @@ const void *nftnl_table_get_data(const struct nftnl=
_table *t, uint16_t attr,
=20
 	switch(attr) {
 	case NFTNL_TABLE_NAME:
+		*data_len =3D strlen(t->name) + 1;
 		return t->name;
 	case NFTNL_TABLE_FLAGS:
 		*data_len =3D sizeof(uint32_t);
diff --git a/src/trace.c b/src/trace.c
index d8f561d..1a50390 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -165,13 +165,13 @@ const void *nftnl_trace_get_data(const struct nft=
nl_trace *trace,
 		*data_len =3D sizeof(uint32_t);
 		return &trace->type;
 	case NFTNL_TRACE_CHAIN:
-		*data_len =3D strlen(trace->chain);
+		*data_len =3D strlen(trace->chain) + 1;
 		return trace->chain;
 	case NFTNL_TRACE_TABLE:
-		*data_len =3D strlen(trace->table);
+		*data_len =3D strlen(trace->table) + 1;
 		return trace->table;
 	case NFTNL_TRACE_JUMP_TARGET:
-		*data_len =3D strlen(trace->jump_target);
+		*data_len =3D strlen(trace->jump_target) + 1;
 		return trace->jump_target;
 	case NFTNL_TRACE_TRANSPORT_HEADER:
 		*data_len =3D trace->th.len;
--=20
2.5.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
