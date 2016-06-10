From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2 libnftnl] Check memory allocations in setters
Date: Fri, 10 Jun 2016 12:20:54 +0200
Message-ID: <1465554054-16283-2-git-send-email-carlosfg@riseup.net>
References: <1465554054-16283-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:39697 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbcFJKVE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 06:21:04 -0400
In-Reply-To: <1465554054-16283-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When you set an object attribute the memory is copied, sometimes an
allocations is needed and it must be checked. Before this patch all set=
ters
method return void, so this patch makes all setters return int instead =
void
to communicate the error to user.

Summary:
	* All setters return int instead void
	* All memory allocations inside setters are checked
	* Unsetters are used if is possible in order to consolidate

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/libnftnl/chain.h   | 16 +++++++-------
 include/libnftnl/expr.h    | 12 +++++------
 include/libnftnl/gen.h     |  8 +++----
 include/libnftnl/rule.h    | 12 +++++------
 include/libnftnl/ruleset.h |  2 +-
 include/libnftnl/set.h     | 20 ++++++++---------
 include/libnftnl/table.h   | 12 +++++------
 src/chain.c                | 54 +++++++++++++++++++++++++-------------=
--------
 src/expr.c                 | 36 ++++++++++++++++++-------------
 src/expr/dynset.c          |  5 ++++-
 src/expr/immediate.c       |  6 +++---
 src/expr/log.c             |  7 ++++--
 src/expr/lookup.c          |  5 ++++-
 src/gen.c                  | 20 ++++++++++-------
 src/rule.c                 | 46 ++++++++++++++++++++------------------=
-
 src/ruleset.c              | 19 ++++++++++------
 src/set.c                  | 40 ++++++++++++++++++----------------
 src/set_elem.c             | 33 ++++++++++++++--------------
 src/table.c                | 28 +++++++++++++-----------
 19 files changed, 210 insertions(+), 171 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 954b39f..6419dee 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -36,14 +36,14 @@ enum nftnl_chain_attr {
=20
 bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr);
-void nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const void =
*data);
-void nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
-			     const void *data, uint32_t data_len);
-void nftnl_chain_set_u8(struct nftnl_chain *t, uint16_t attr, uint8_t =
data);
-void nftnl_chain_set_u32(struct nftnl_chain *t, uint16_t attr, uint32_=
t data);
-void nftnl_chain_set_s32(struct nftnl_chain *t, uint16_t attr, int32_t=
 data);
-void nftnl_chain_set_u64(struct nftnl_chain *t, uint16_t attr, uint64_=
t data);
-void nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const c=
har *str);
+int nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const void *=
data);
+int nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
+			 const void *data, uint32_t data_len);
+int nftnl_chain_set_u8(struct nftnl_chain *t, uint16_t attr, uint8_t d=
ata);
+int nftnl_chain_set_u32(struct nftnl_chain *t, uint16_t attr, uint32_t=
 data);
+int nftnl_chain_set_s32(struct nftnl_chain *t, uint16_t attr, int32_t =
data);
+int nftnl_chain_set_u64(struct nftnl_chain *t, uint16_t attr, uint64_t=
 data);
+int nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const ch=
ar *str);
=20
 const void *nftnl_chain_get(const struct nftnl_chain *c, uint16_t attr=
);
 const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t=
 attr,
diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index f192103..d6ad630 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -20,13 +20,13 @@ struct nftnl_expr *nftnl_expr_alloc(const char *nam=
e);
 void nftnl_expr_free(const struct nftnl_expr *expr);
=20
 bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type);
-void nftnl_expr_set(struct nftnl_expr *expr, uint16_t type, const void=
 *data, uint32_t data_len);
+int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type, const void =
*data, uint32_t data_len);
 #define nftnl_expr_set_data nftnl_expr_set
-void nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t=
 data);
-void nftnl_expr_set_u16(struct nftnl_expr *expr, uint16_t type, uint16=
_t data);
-void nftnl_expr_set_u32(struct nftnl_expr *expr, uint16_t type, uint32=
_t data);
-void nftnl_expr_set_u64(struct nftnl_expr *expr, uint16_t type, uint64=
_t data);
-void nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const =
char *str);
+int nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t =
data);
+int nftnl_expr_set_u16(struct nftnl_expr *expr, uint16_t type, uint16_=
t data);
+int nftnl_expr_set_u32(struct nftnl_expr *expr, uint16_t type, uint32_=
t data);
+int nftnl_expr_set_u64(struct nftnl_expr *expr, uint16_t type, uint64_=
t data);
+int nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const c=
har *str);
=20
 const void *nftnl_expr_get(const struct nftnl_expr *expr, uint16_t typ=
e, uint32_t *data_len);
 #define nftnl_expr_get_data nftnl_expr_get
diff --git a/include/libnftnl/gen.h b/include/libnftnl/gen.h
index d0f638f..04054c7 100644
--- a/include/libnftnl/gen.h
+++ b/include/libnftnl/gen.h
@@ -25,14 +25,14 @@ enum {
=20
 bool nftnl_gen_is_set(const struct nftnl_gen *gen, uint16_t attr);
 void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr);
-void nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *d=
ata);
-void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
-			     const void *data, uint32_t data_len);
+int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *da=
ta);
+int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
+		       const void *data, uint32_t data_len);
 const void *nftnl_gen_get(const struct nftnl_gen *gen, uint16_t attr);
 const void *nftnl_gen_get_data(const struct nftnl_gen *gen, uint16_t a=
ttr,
 			       uint32_t *data_len);
=20
-void nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t =
data);
+int nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t d=
ata);
 uint32_t nftnl_gen_get_u32(const struct nftnl_gen *gen, uint16_t attr)=
;
=20
 struct nlmsghdr;
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 6f9d8c1..103f2cf 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -33,12 +33,12 @@ enum nftnl_rule_attr {
=20
 void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr);
 bool nftnl_rule_is_set(const struct nftnl_rule *r, uint16_t attr);
-void nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *d=
ata);
-void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
-			    const void *data, uint32_t data_len);
-void nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t =
val);
-void nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t =
val);
-void nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const cha=
r *str);
+int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *da=
ta);
+int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
+			const void *data, uint32_t data_len);
+int nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t v=
al);
+int nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t v=
al);
+int nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char=
 *str);
=20
 const void *nftnl_rule_get(const struct nftnl_rule *r, uint16_t attr);
 const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t a=
ttr,
diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index 83c2334..af9361f 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -37,7 +37,7 @@ enum nftnl_ruleset_type {
=20
 bool nftnl_ruleset_is_set(const struct nftnl_ruleset *r, uint16_t attr=
);
 void nftnl_ruleset_unset(struct nftnl_ruleset *r, uint16_t attr);
-void nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *d=
ata);
+int nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *da=
ta);
 void *nftnl_ruleset_get(const struct nftnl_ruleset *r, uint16_t attr);
=20
 enum {
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index c9a879a..3ff9cb8 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -35,12 +35,12 @@ struct nftnl_set *nftnl_set_clone(const struct nftn=
l_set *set);
=20
 bool nftnl_set_is_set(const struct nftnl_set *s, uint16_t attr);
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr);
-void nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *dat=
a);
-void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void=
 *data,
-			   uint32_t data_len);
-void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t va=
l);
-void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t va=
l);
-void nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char =
*str);
+int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data=
);
+int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void =
*data,
+		       uint32_t data_len);
+int nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val=
);
+int nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val=
);
+int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *=
str);
=20
 const void *nftnl_set_get(const struct nftnl_set *s, uint16_t attr);
 const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t att=
r,
@@ -106,10 +106,10 @@ struct nftnl_set_elem *nftnl_set_elem_clone(struc=
t nftnl_set_elem *elem);
 void nftnl_set_elem_add(struct nftnl_set *s, struct nftnl_set_elem *el=
em);
=20
 void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr);
-void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const=
 void *data, uint32_t data_len);
-void nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, u=
int32_t val);
-void nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, u=
int64_t val);
-void nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, c=
onst char *str);
+int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const =
void *data, uint32_t data_len);
+int nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, ui=
nt32_t val);
+int nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, ui=
nt64_t val);
+int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, co=
nst char *str);
=20
 const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr=
, uint32_t *data_len);
 const char *nftnl_set_elem_get_str(struct nftnl_set_elem *s, uint16_t =
attr);
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 8972d09..23b677c 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -28,16 +28,16 @@ enum nftnl_table_attr {
=20
 bool nftnl_table_is_set(const struct nftnl_table *t, uint16_t attr);
 void nftnl_table_unset(struct nftnl_table *t, uint16_t attr);
-void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void =
*data);
-void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
-			     const void *data, uint32_t data_len);
+int nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *=
data);
+int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
+			 const void *data, uint32_t data_len);
 const void *nftnl_table_get(const struct nftnl_table *t, uint16_t attr=
);
 const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t=
 attr,
 				 uint32_t *data_len);
=20
-void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t =
data);
-void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_=
t data);
-void nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const c=
har *str);
+int nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t d=
ata);
+int nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t=
 data);
+int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const ch=
ar *str);
 uint8_t nftnl_table_get_u8(const struct nftnl_table *t, uint16_t attr)=
;
 uint32_t nftnl_table_get_u32(const struct nftnl_table *t, uint16_t att=
r);
 const char *nftnl_table_get_str(const struct nftnl_table *t, uint16_t =
attr);
diff --git a/src/chain.c b/src/chain.c
index 70daaf3..3c545a3 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -165,11 +165,13 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_=
MAX + 1] =3D {
 	[NFTNL_CHAIN_FAMILY]		=3D sizeof(uint32_t),
 };
=20
-void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
-			     const void *data, uint32_t data_len)
+int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
+			 const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_CHAIN_MAX)
-		return;
+	if (attr > NFTNL_CHAIN_MAX) {
+		errno =3D EOPNOTSUPP;
+		return -1;
+	}
=20
 	nftnl_assert_validate(data, nftnl_chain_validate, attr, data_len);
=20
@@ -178,10 +180,10 @@ void nftnl_chain_set_data(struct nftnl_chain *c, =
uint16_t attr,
 		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
 		break;
 	case NFTNL_CHAIN_TABLE:
-		if (c->table)
-			xfree(c->table);
-
+		nftnl_chain_unset(c, attr);
 		c->table =3D strdup(data);
+		if (!c->table)
+			return -1;
 		break;
 	case NFTNL_CHAIN_HOOKNUM:
 		memcpy(&c->hooknum, data, sizeof(c->hooknum));
@@ -208,55 +210,57 @@ void nftnl_chain_set_data(struct nftnl_chain *c, =
uint16_t attr,
 		c->family =3D *((uint32_t *)data);
 		break;
 	case NFTNL_CHAIN_TYPE:
-		if (c->type)
-			xfree(c->type);
-
+		nftnl_chain_unset(c, attr);
 		c->type =3D strdup(data);
+		if (!c->type)
+			return -1;
 		break;
 	case NFTNL_CHAIN_DEV:
-		if (c->dev)
-			xfree(c->dev);
-
+		nftnl_chain_unset(c, attr);
 		c->dev =3D strdup(data);
+		if (!c->dev)
+			return -1;
 		break;
 	}
 	c->flags |=3D (1 << attr);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_chain_set_data);
=20
-void nftnl_chain_set(struct nftnl_chain *c, uint16_t attr, const void =
*data)
+int nftnl_chain_set(struct nftnl_chain *c, uint16_t attr, const void *=
data)
 {
-	nftnl_chain_set_data(c, attr, data, nftnl_chain_validate[attr]);
+	return nftnl_chain_set_data(c, attr, data, nftnl_chain_validate[attr]=
);
 }
 EXPORT_SYMBOL(nftnl_chain_set);
=20
-void nftnl_chain_set_u32(struct nftnl_chain *c, uint16_t attr, uint32_=
t data)
+int nftnl_chain_set_u32(struct nftnl_chain *c, uint16_t attr, uint32_t=
 data)
 {
-	nftnl_chain_set_data(c, attr, &data, sizeof(uint32_t));
+	return nftnl_chain_set_data(c, attr, &data, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nftnl_chain_set_u32);
=20
-void nftnl_chain_set_s32(struct nftnl_chain *c, uint16_t attr, int32_t=
 data)
+int nftnl_chain_set_s32(struct nftnl_chain *c, uint16_t attr, int32_t =
data)
 {
-	nftnl_chain_set_data(c, attr, &data, sizeof(int32_t));
+	return nftnl_chain_set_data(c, attr, &data, sizeof(int32_t));
 }
 EXPORT_SYMBOL(nftnl_chain_set_s32);
=20
-void nftnl_chain_set_u64(struct nftnl_chain *c, uint16_t attr, uint64_=
t data)
+int nftnl_chain_set_u64(struct nftnl_chain *c, uint16_t attr, uint64_t=
 data)
 {
-	nftnl_chain_set_data(c, attr, &data, sizeof(uint64_t));
+	return nftnl_chain_set_data(c, attr, &data, sizeof(uint64_t));
 }
 EXPORT_SYMBOL(nftnl_chain_set_u64);
=20
-void nftnl_chain_set_u8(struct nftnl_chain *c, uint16_t attr, uint8_t =
data)
+int nftnl_chain_set_u8(struct nftnl_chain *c, uint16_t attr, uint8_t d=
ata)
 {
-	nftnl_chain_set_data(c, attr, &data, sizeof(uint8_t));
+	return nftnl_chain_set_data(c, attr, &data, sizeof(uint8_t));
 }
 EXPORT_SYMBOL(nftnl_chain_set_u8);
=20
-void nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const c=
har *str)
+int nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const ch=
ar *str)
 {
-	nftnl_chain_set_data(c, attr, str, strlen(str));
+	return nftnl_chain_set_data(c, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nftnl_chain_set_str);
=20
diff --git a/src/expr.c b/src/expr.c
index aa920dd..0c0dafb 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -60,53 +60,59 @@ bool nftnl_expr_is_set(const struct nftnl_expr *exp=
r, uint16_t type)
 }
 EXPORT_SYMBOL(nftnl_expr_is_set);
=20
-void
+int
 nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
-		  const void *data, uint32_t data_len)
+	       const void *data, uint32_t data_len)
 {
+	int ret;
+
 	switch(type) {
 	case NFTNL_EXPR_NAME:	/* cannot be modified */
-		return;
+		errno =3D EOPNOTSUPP;
+		return -1;
 	default:
-		if (expr->ops->set(expr, type, data, data_len) < 0)
-			return;
+		ret =3D expr->ops->set(expr, type, data, data_len);
+		if (ret !=3D 0)
+			return ret;
 	}
 	expr->flags |=3D (1 << type);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_expr_set);
=20
-void
+int
 nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t data=
)
 {
-	nftnl_expr_set(expr, type, &data, sizeof(uint8_t));
+	return nftnl_expr_set(expr, type, &data, sizeof(uint8_t));
 }
 EXPORT_SYMBOL(nftnl_expr_set_u8);
=20
-void
+int
 nftnl_expr_set_u16(struct nftnl_expr *expr, uint16_t type, uint16_t da=
ta)
 {
-	nftnl_expr_set(expr, type, &data, sizeof(uint16_t));
+	return nftnl_expr_set(expr, type, &data, sizeof(uint16_t));
 }
 EXPORT_SYMBOL(nftnl_expr_set_u16);
=20
-void
+int
 nftnl_expr_set_u32(struct nftnl_expr *expr, uint16_t type, uint32_t da=
ta)
 {
-	nftnl_expr_set(expr, type, &data, sizeof(uint32_t));
+	return nftnl_expr_set(expr, type, &data, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nftnl_expr_set_u32);
=20
-void
+int
 nftnl_expr_set_u64(struct nftnl_expr *expr, uint16_t type, uint64_t da=
ta)
 {
-	nftnl_expr_set(expr, type, &data, sizeof(uint64_t));
+	return nftnl_expr_set(expr, type, &data, sizeof(uint64_t));
 }
 EXPORT_SYMBOL(nftnl_expr_set_u64);
=20
-void
+int
 nftnl_expr_set_str(struct nftnl_expr *expr, uint16_t type, const char =
*str)
 {
-	nftnl_expr_set(expr, type, str, strlen(str)+1);
+	return nftnl_expr_set(expr, type, str, strlen(str)+1);
 }
 EXPORT_SYMBOL(nftnl_expr_set_str);
=20
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index c8d97a5..dca62b7 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -52,7 +52,10 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t=
 type,
 		dynset->timeout =3D *((uint64_t *)data);
 		break;
 	case NFTNL_EXPR_DYNSET_SET_NAME:
-		dynset->set_name =3D strdup((const char *)data);
+		xfree(dynset->set_name);
+		dynset->set_name =3D strdup(data);
+		if (!dynset->set_name)
+			return -1;
 		break;
 	case NFTNL_EXPR_DYNSET_SET_ID:
 		dynset->set_id =3D *((uint32_t *)data);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index eb2ca0f..40b27f9 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -43,10 +43,10 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint=
16_t type,
 		imm->data.verdict =3D *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_IMM_CHAIN:
-		if (imm->data.chain)
-			xfree(imm->data.chain);
-
+		xfree(imm->data.chain);
 		imm->data.chain =3D strdup(data);
+		if (!imm->data.chain)
+			return -1;
 		break;
 	default:
 		return -1;
diff --git a/src/expr/log.c b/src/expr/log.c
index c3dc0a6..b9bc668 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -37,10 +37,11 @@ static int nftnl_expr_log_set(struct nftnl_expr *e,=
 uint16_t type,
=20
 	switch(type) {
 	case NFTNL_EXPR_LOG_PREFIX:
-		if (log->prefix)
+		if (log->flags & (1 << NFTNL_EXPR_LOG_PREFIX))
 			xfree(log->prefix);
-
 		log->prefix =3D strdup(data);
+		if (!log->prefix)
+			return -1;
 		break;
 	case NFTNL_EXPR_LOG_GROUP:
 		log->group =3D *((uint16_t *)data);
@@ -60,6 +61,8 @@ static int nftnl_expr_log_set(struct nftnl_expr *e, u=
int16_t type,
 	default:
 		return -1;
 	}
+
+	log->flags |=3D (1 << type);
 	return 0;
 }
=20
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index ed32ba6..3088711 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -42,7 +42,10 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t=
 type,
 		lookup->dreg =3D *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_LOOKUP_SET:
-		lookup->set_name =3D strdup((const char *)data);
+		xfree(lookup->set_name);
+		lookup->set_name =3D strdup(data);
+		if (!lookup->set_name)
+			return -1;
 		break;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
 		lookup->set_id =3D *((uint32_t *)data);
diff --git a/src/gen.c b/src/gen.c
index 8533f38..8411662 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -64,11 +64,13 @@ static uint32_t nftnl_gen_validate[NFTNL_GEN_MAX + =
1] =3D {
 	[NFTNL_GEN_ID]	=3D sizeof(uint32_t),
 };
=20
-void nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
-			   const void *data, uint32_t data_len)
+int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
+		       const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_GEN_MAX)
-		return;
+	if (attr > NFTNL_GEN_MAX) {
+		errno =3D EOPNOTSUPP;
+		return -1;
+	}
=20
 	nftnl_assert_validate(data, nftnl_gen_validate, attr, data_len);
=20
@@ -78,18 +80,20 @@ void nftnl_gen_set_data(struct nftnl_gen *gen, uint=
16_t attr,
 		break;
 	}
 	gen->flags |=3D (1 << attr);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_gen_set_data);
=20
-void nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *d=
ata)
+int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *da=
ta)
 {
-	nftnl_gen_set_data(gen, attr, data, nftnl_gen_validate[attr]);
+	return nftnl_gen_set_data(gen, attr, data, nftnl_gen_validate[attr]);
 }
 EXPORT_SYMBOL(nftnl_gen_set);
=20
-void nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t =
val)
+int nftnl_gen_set_u32(struct nftnl_gen *gen, uint16_t attr, uint32_t v=
al)
 {
-	nftnl_gen_set_data(gen, attr, &val, sizeof(uint32_t));
+	return nftnl_gen_set_data(gen, attr, &val, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nftnl_gen_set_u32);
=20
diff --git a/src/rule.c b/src/rule.c
index 4c22436..dbc5da3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -128,26 +128,28 @@ static uint32_t nftnl_rule_validate[NFTNL_RULE_MA=
X + 1] =3D {
 	[NFTNL_RULE_POSITION]	=3D sizeof(uint64_t),
 };
=20
-void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
-			    const void *data, uint32_t data_len)
+int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
+			const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_RULE_MAX)
-		return;
+	if (attr > NFTNL_RULE_MAX) {
+		errno =3D EOPNOTSUPP;
+		return -1;
+	}
=20
 	nftnl_assert_validate(data, nftnl_rule_validate, attr, data_len);
=20
 	switch(attr) {
 	case NFTNL_RULE_TABLE:
-		if (r->table)
-			xfree(r->table);
-
+		nftnl_rule_unset(r, attr);
 		r->table =3D strdup(data);
+		if (!r->table)
+			return -1;
 		break;
 	case NFTNL_RULE_CHAIN:
-		if (r->chain)
-			xfree(r->chain);
-
+		nftnl_rule_unset(r, attr);
 		r->chain =3D strdup(data);
+		if (!r->chain)
+			return -1;
 		break;
 	case NFTNL_RULE_HANDLE:
 		r->handle =3D *((uint64_t *)data);
@@ -165,42 +167,42 @@ void nftnl_rule_set_data(struct nftnl_rule *r, ui=
nt16_t attr,
 		r->position =3D *((uint64_t *)data);
 		break;
 	case NFTNL_RULE_USERDATA:
-		if (r->user.data !=3D NULL)
-			xfree(r->user.data);
-
+		nftnl_rule_unset(r, attr);
 		r->user.data =3D malloc(data_len);
 		if (!r->user.data)
-			return;
+			return -1;
=20
 		memcpy(r->user.data, data, data_len);
 		r->user.len =3D data_len;
 		break;
 	}
 	r->flags |=3D (1 << attr);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_rule_set_data);
=20
-void nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *d=
ata)
+int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *da=
ta)
 {
-	nftnl_rule_set_data(r, attr, data, nftnl_rule_validate[attr]);
+	return nftnl_rule_set_data(r, attr, data, nftnl_rule_validate[attr]);
 }
 EXPORT_SYMBOL(nftnl_rule_set);
=20
-void nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t =
val)
+int nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t v=
al)
 {
-	nftnl_rule_set_data(r, attr, &val, sizeof(uint32_t));
+	return nftnl_rule_set_data(r, attr, &val, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nftnl_rule_set_u32);
=20
-void nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t =
val)
+int nftnl_rule_set_u64(struct nftnl_rule *r, uint16_t attr, uint64_t v=
al)
 {
-	nftnl_rule_set_data(r, attr, &val, sizeof(uint64_t));
+	return nftnl_rule_set_data(r, attr, &val, sizeof(uint64_t));
 }
 EXPORT_SYMBOL(nftnl_rule_set_u64);
=20
-void nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const cha=
r *str)
+int nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char=
 *str)
 {
-	nftnl_rule_set_data(r, attr, str, strlen(str));
+	return nftnl_rule_set_data(r, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nftnl_rule_set_str);
=20
diff --git a/src/ruleset.c b/src/ruleset.c
index cbe1438..19f2a4c 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -111,7 +111,7 @@ void nftnl_ruleset_unset(struct nftnl_ruleset *r, u=
int16_t attr)
 }
 EXPORT_SYMBOL(nftnl_ruleset_unset);
=20
-void nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *d=
ata)
+int nftnl_ruleset_set(struct nftnl_ruleset *r, uint16_t attr, void *da=
ta)
 {
 	switch (attr) {
 	case NFTNL_RULESET_TABLELIST:
@@ -131,9 +131,12 @@ void nftnl_ruleset_set(struct nftnl_ruleset *r, ui=
nt16_t attr, void *data)
 		r->rule_list =3D data;
 		break;
 	default:
-		return;
+		errno =3D EOPNOTSUPP;
+		return -1;
 	}
 	r->flags |=3D (1 << attr);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_ruleset_set);
=20
@@ -220,8 +223,8 @@ uint32_t nftnl_ruleset_ctx_get_u32(const struct nft=
nl_parse_ctx *ctx, uint16_t a
 EXPORT_SYMBOL(nftnl_ruleset_ctx_get_u32);
=20
 #if defined(JSON_PARSING) || defined(XML_PARSING)
-static void nftnl_ruleset_ctx_set(struct nftnl_parse_ctx *ctx, uint16_=
t attr,
-				void *data)
+static int nftnl_ruleset_ctx_set(struct nftnl_parse_ctx *ctx, uint16_t=
 attr,
+				 void *data)
 {
 	switch (attr) {
 	case NFTNL_RULESET_CTX_CMD:
@@ -247,12 +250,14 @@ static void nftnl_ruleset_ctx_set(struct nftnl_pa=
rse_ctx *ctx, uint16_t attr,
 		break;
 	}
 	ctx->flags |=3D (1 << attr);
+
+	return 0;
 }
=20
-static void nftnl_ruleset_ctx_set_u32(struct nftnl_parse_ctx *ctx, uin=
t16_t attr,
-				    uint32_t val)
+static int nftnl_ruleset_ctx_set_u32(struct nftnl_parse_ctx *ctx, uint=
16_t attr,
+				     uint32_t val)
 {
-	nftnl_ruleset_ctx_set(ctx, attr, &val);
+	return nftnl_ruleset_ctx_set(ctx, attr, &val);
 }
=20
 static int nftnl_ruleset_parse_tables(struct nftnl_parse_ctx *ctx,
diff --git a/src/set.c b/src/set.c
index 3caaf39..a4cca0a 100644
--- a/src/set.c
+++ b/src/set.c
@@ -113,26 +113,28 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX =
+ 1] =3D {
 	[NFTNL_SET_GC_INTERVAL]	=3D sizeof(uint32_t),
 };
=20
-void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void=
 *data,
-			   uint32_t data_len)
+int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void =
*data,
+		       uint32_t data_len)
 {
-	if (attr > NFTNL_SET_MAX)
-		return;
+	if (attr > NFTNL_SET_MAX) {
+		errno =3D EOPNOTSUPP;
+		return -1;
+	}
=20
 	nftnl_assert_validate(data, nftnl_set_validate, attr, data_len);
=20
 	switch(attr) {
 	case NFTNL_SET_TABLE:
-		if (s->table)
-			xfree(s->table);
-
+		nftnl_set_unset(s, attr);
 		s->table =3D strdup(data);
+		if (!s->table)
+			return -1;
 		break;
 	case NFTNL_SET_NAME:
-		if (s->name)
-			xfree(s->name);
-
+		nftnl_set_unset(s, attr);
 		s->name =3D strdup(data);
+		if (!s->name)
+			return -1;
 		break;
 	case NFTNL_SET_FLAGS:
 		s->set_flags =3D *((uint32_t *)data);
@@ -169,30 +171,32 @@ void nftnl_set_set_data(struct nftnl_set *s, uint=
16_t attr, const void *data,
 		break;
 	}
 	s->flags |=3D (1 << attr);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_set_set_data);
=20
-void nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *dat=
a)
+int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data=
)
 {
-	nftnl_set_set_data(s, attr, data, nftnl_set_validate[attr]);
+	return nftnl_set_set_data(s, attr, data, nftnl_set_validate[attr]);
 }
 EXPORT_SYMBOL(nftnl_set_set);
=20
-void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t va=
l)
+int nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val=
)
 {
-	nftnl_set_set(s, attr, &val);
+	return nftnl_set_set(s, attr, &val);
 }
 EXPORT_SYMBOL(nftnl_set_set_u32);
=20
-void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t va=
l)
+int nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val=
)
 {
-	nftnl_set_set(s, attr, &val);
+	return nftnl_set_set(s, attr, &val);
 }
 EXPORT_SYMBOL(nftnl_set_set_u64);
=20
-void nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char =
*str)
+int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *=
str)
 {
-	nftnl_set_set(s, attr, str);
+	return nftnl_set_set(s, attr, str);
 }
 EXPORT_SYMBOL(nftnl_set_set_str);
=20
diff --git a/src/set_elem.c b/src/set_elem.c
index e585d84..b09d2d3 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -98,8 +98,8 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, u=
int16_t attr)
 }
 EXPORT_SYMBOL(nftnl_set_elem_unset);
=20
-void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
-			   const void *data, uint32_t data_len)
+int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
+		       const void *data, uint32_t data_len)
 {
 	switch(attr) {
 	case NFTNL_SET_ELEM_FLAGS:
@@ -113,10 +113,10 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s,=
 uint16_t attr,
 		s->data.verdict =3D *((uint32_t *)data);
 		break;
 	case NFTNL_SET_ELEM_CHAIN:	/* NFTA_SET_ELEM_DATA */
-		if (s->data.chain)
-			xfree(s->data.chain);
-
+		nftnl_set_elem_unset(s, attr);
 		s->data.chain =3D strdup(data);
+		if (!s->data.chain)
+			return -1;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
 		memcpy(s->data.val, data, data_len);
@@ -126,37 +126,38 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s,=
 uint16_t attr,
 		s->timeout =3D *((uint64_t *)data);
 		break;
 	case NFTNL_SET_ELEM_USERDATA: /* NFTA_SET_ELEM_USERDATA */
-		if (s->user.data !=3D NULL)
-			xfree(s->user.data);
-
+		nftnl_set_elem_unset(s, attr);
 		s->user.data =3D malloc(data_len);
 		if (!s->user.data)
-			return;
+			return -1;
 		memcpy(s->user.data, data, data_len);
 		s->user.len =3D data_len;
 		break;
 	default:
-		return;
+		errno =3D EOPNOTSUPP;
+		return -1;
 	}
 	s->flags |=3D (1 << attr);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_set_elem_set);
=20
-void nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, u=
int32_t val)
+int nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, ui=
nt32_t val)
 {
-	nftnl_set_elem_set(s, attr, &val, sizeof(uint32_t));
+	return nftnl_set_elem_set(s, attr, &val, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nftnl_set_elem_set_u32);
=20
-void nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, u=
int64_t val)
+int nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, ui=
nt64_t val)
 {
-	nftnl_set_elem_set(s, attr, &val, sizeof(uint64_t));
+	return nftnl_set_elem_set(s, attr, &val, sizeof(uint64_t));
 }
 EXPORT_SYMBOL(nftnl_set_elem_set_u64);
=20
-void nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, c=
onst char *str)
+int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, co=
nst char *str)
 {
-	nftnl_set_elem_set(s, attr, str, strlen(str));
+	return nftnl_set_elem_set(s, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nftnl_set_elem_set_str);
=20
diff --git a/src/table.c b/src/table.c
index 6e5e267..8de0a7f 100644
--- a/src/table.c
+++ b/src/table.c
@@ -84,11 +84,13 @@ static uint32_t nftnl_table_validate[NFTNL_TABLE_MA=
X + 1] =3D {
 	[NFTNL_TABLE_FAMILY]	=3D sizeof(uint32_t),
 };
=20
-void nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
-			     const void *data, uint32_t data_len)
+int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
+			 const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_TABLE_MAX)
-		return;
+	if (attr > NFTNL_TABLE_MAX) {
+		errno =3D EOPNOTSUPP;
+		return -1;
+	}
=20
 	nftnl_assert_validate(data, nftnl_table_validate, attr, data_len);
=20
@@ -110,30 +112,32 @@ void nftnl_table_set_data(struct nftnl_table *t, =
uint16_t attr,
 		break;
 	}
 	t->flags |=3D (1 << attr);
+
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_table_set_data);
=20
-void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void =
*data)
+int nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *=
data)
 {
-	nftnl_table_set_data(t, attr, data, nftnl_table_validate[attr]);
+	return nftnl_table_set_data(t, attr, data, nftnl_table_validate[attr]=
);
 }
 EXPORT_SYMBOL(nftnl_table_set);
=20
-void nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_=
t val)
+int nftnl_table_set_u32(struct nftnl_table *t, uint16_t attr, uint32_t=
 val)
 {
-	nftnl_table_set_data(t, attr, &val, sizeof(uint32_t));
+	return nftnl_table_set_data(t, attr, &val, sizeof(uint32_t));
 }
 EXPORT_SYMBOL(nftnl_table_set_u32);
=20
-void nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t =
val)
+int nftnl_table_set_u8(struct nftnl_table *t, uint16_t attr, uint8_t v=
al)
 {
-	nftnl_table_set_data(t, attr, &val, sizeof(uint8_t));
+	return nftnl_table_set_data(t, attr, &val, sizeof(uint8_t));
 }
 EXPORT_SYMBOL(nftnl_table_set_u8);
=20
-void nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const c=
har *str)
+int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const ch=
ar *str)
 {
-	nftnl_table_set_data(t, attr, str, 0);
+	return nftnl_table_set_data(t, attr, str, 0);
 }
 EXPORT_SYMBOL(nftnl_table_set_str);
=20
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
