From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/3 libnftnl] Consolidate setters
Date: Thu, 16 Jun 2016 12:20:12 +0200
Message-ID: <20160616102012.32036-3-carlosfg@riseup.net>
References: <20160616102012.32036-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:45681 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbcFPKUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 06:20:25 -0400
In-Reply-To: <20160616102012.32036-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use setter method in all place where we set an attribute instead of rep=
eat
the code.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/chain.c    | 91 ++++++++++++++++++++++++--------------------------=
------
 src/gen.c      |  7 ++---
 src/rule.c     | 72 ++++++++++++++++-----------------------------
 src/set.c      | 93 ++++++++++++++++++++++++--------------------------=
--------
 src/set_elem.c | 72 ++++++++++++++++++---------------------------
 src/table.c    | 30 ++++++++-----------
 6 files changed, 148 insertions(+), 217 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index bfffbe0..9c8b436 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -465,14 +465,12 @@ static int nftnl_chain_parse_counters(struct nlat=
tr *attr, struct nftnl_chain *c
 	if (mnl_attr_parse_nested(attr, nftnl_chain_parse_counters_cb, tb) < =
0)
 		return -1;
=20
-	if (tb[NFTA_COUNTER_PACKETS]) {
-		c->packets =3D be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_PACKETS]));
-		c->flags |=3D (1 << NFTNL_CHAIN_PACKETS);
-	}
-	if (tb[NFTA_COUNTER_BYTES]) {
-		c->bytes =3D be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_BYTES]));
-		c->flags |=3D (1 << NFTNL_CHAIN_BYTES);
-	}
+	if (tb[NFTA_COUNTER_PACKETS])
+		nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS,
+			be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_PACKETS])));
+	if (tb[NFTA_COUNTER_BYTES])
+		nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES,
+			be64toh(mnl_attr_get_u64(tb[NFTA_COUNTER_BYTES])));
=20
 	return 0;
 }
@@ -504,23 +502,22 @@ static int nftnl_chain_parse_hook_cb(const struct=
 nlattr *attr, void *data)
 static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_ch=
ain *c)
 {
 	struct nlattr *tb[NFTA_HOOK_MAX+1] =3D {};
+	int err;
=20
 	if (mnl_attr_parse_nested(attr, nftnl_chain_parse_hook_cb, tb) < 0)
 		return -1;
=20
-	if (tb[NFTA_HOOK_HOOKNUM]) {
-		c->hooknum =3D ntohl(mnl_attr_get_u32(tb[NFTA_HOOK_HOOKNUM]));
-		c->flags |=3D (1 << NFTNL_CHAIN_HOOKNUM);
-	}
-	if (tb[NFTA_HOOK_PRIORITY]) {
-		c->prio =3D ntohl(mnl_attr_get_u32(tb[NFTA_HOOK_PRIORITY]));
-		c->flags |=3D (1 << NFTNL_CHAIN_PRIO);
-	}
+	if (tb[NFTA_HOOK_HOOKNUM])
+		nftnl_chain_set_u32(c, NFTNL_CHAIN_HOOKNUM,
+			ntohl(mnl_attr_get_u32(tb[NFTA_HOOK_HOOKNUM])));
+	if (tb[NFTA_HOOK_PRIORITY])
+		nftnl_chain_set_s32(c, NFTNL_CHAIN_PRIO,
+			ntohl(mnl_attr_get_u32(tb[NFTA_HOOK_PRIORITY])));
 	if (tb[NFTA_HOOK_DEV]) {
-		c->dev =3D strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
-		if (!c->dev)
-			return -1;
-		c->flags |=3D (1 << NFTNL_CHAIN_DEV);
+		err =3D nftnl_chain_set_str(c, NFTNL_CHAIN_DEV,
+			mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
+		if (err)
+			return err;
 	}
=20
 	return 0;
@@ -536,54 +533,44 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr=
 *nlh, struct nftnl_chain *c)
 		return -1;
=20
 	if (tb[NFTA_CHAIN_NAME]) {
-		if (c->flags & (1 << NFTNL_CHAIN_NAME))
-			xfree(c->name);
-		c->name =3D strdup(mnl_attr_get_str(tb[NFTA_CHAIN_NAME]));
-		if (!c->name)
-			return -1;
-		c->flags |=3D (1 << NFTNL_CHAIN_NAME);
+		ret =3D nftnl_chain_set_str(c, NFTNL_CHAIN_NAME,
+			mnl_attr_get_str(tb[NFTA_CHAIN_NAME]));
+		if (ret)
+			return ret;
 	}
 	if (tb[NFTA_CHAIN_TABLE]) {
-		if (c->flags & (1 << NFTNL_CHAIN_TABLE))
-			xfree(c->table);
-		c->table =3D strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
-		if (!c->table)
-			return -1;
-		c->flags |=3D (1 << NFTNL_CHAIN_TABLE);
+		ret =3D nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE,
+			mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
+		if (ret)
+			return ret;
 	}
 	if (tb[NFTA_CHAIN_HOOK]) {
 		ret =3D nftnl_chain_parse_hook(tb[NFTA_CHAIN_HOOK], c);
 		if (ret < 0)
 			return ret;
 	}
-	if (tb[NFTA_CHAIN_POLICY]) {
-		c->policy =3D ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_POLICY]));
-		c->flags |=3D (1 << NFTNL_CHAIN_POLICY);
-	}
-	if (tb[NFTA_CHAIN_USE]) {
-		c->use =3D ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_USE]));
-		c->flags |=3D (1 << NFTNL_CHAIN_USE);
-	}
+	if (tb[NFTA_CHAIN_POLICY])
+		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY,
+			ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_POLICY])));
+	if (tb[NFTA_CHAIN_USE])
+		nftnl_chain_set_u32(c, NFTNL_CHAIN_USE,
+			ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_USE])));
 	if (tb[NFTA_CHAIN_COUNTERS]) {
 		ret =3D nftnl_chain_parse_counters(tb[NFTA_CHAIN_COUNTERS], c);
 		if (ret < 0)
 			return ret;
 	}
-	if (tb[NFTA_CHAIN_HANDLE]) {
-		c->handle =3D be64toh(mnl_attr_get_u64(tb[NFTA_CHAIN_HANDLE]));
-		c->flags |=3D (1 << NFTNL_CHAIN_HANDLE);
-	}
+	if (tb[NFTA_CHAIN_HANDLE])
+		nftnl_chain_set_u64(c, NFTNL_CHAIN_HANDLE,
+			be64toh(mnl_attr_get_u64(tb[NFTA_CHAIN_HANDLE])));
 	if (tb[NFTA_CHAIN_TYPE]) {
-		if (c->flags & (1 << NFTNL_CHAIN_TYPE))
-			xfree(c->type);
-		c->type =3D strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TYPE]));
-		if (!c->type)
-			return -1;
-		c->flags |=3D (1 << NFTNL_CHAIN_TYPE);
+		ret =3D nftnl_chain_set_str(c, NFTNL_CHAIN_TYPE,
+			mnl_attr_get_str(tb[NFTA_CHAIN_TYPE]));
+		if (ret)
+			return ret;
 	}
=20
-	c->family =3D nfg->nfgen_family;
-	c->flags |=3D (1 << NFTNL_CHAIN_FAMILY);
+	nftnl_chain_set_u32(c, NFTNL_CHAIN_FAMILY, nfg->nfgen_family);
=20
 	return ret;
 }
diff --git a/src/gen.c b/src/gen.c
index 37a9049..d73b00f 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -147,10 +147,9 @@ int nftnl_gen_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nftnl_gen *gen)
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_gen_parse_attr_cb, tb) < =
0)
 		return -1;
=20
-	if (tb[NFTA_GEN_ID]) {
-		gen->id =3D ntohl(mnl_attr_get_u32(tb[NFTA_GEN_ID]));
-		gen->flags |=3D (1 << NFTNL_GEN_ID);
-	}
+	if (tb[NFTA_GEN_ID])
+		nftnl_gen_set_u32(gen, NFTNL_GEN_ID,
+				ntohl(mnl_attr_get_u32(tb[NFTA_GEN_ID])));
 	return 0;
 }
 EXPORT_SYMBOL_ALIAS(nftnl_gen_nlmsg_parse, nft_gen_nlmsg_parse);
diff --git a/src/rule.c b/src/rule.c
index 930ecc0..fa31357 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -410,16 +410,12 @@ static int nftnl_rule_parse_compat(struct nlattr =
*nest, struct nftnl_rule *r)
 	if (mnl_attr_parse_nested(nest, nftnl_rule_parse_compat_cb, tb) < 0)
 		return -1;
=20
-	if (tb[NFTA_RULE_COMPAT_PROTO]) {
-		r->compat.proto =3D
-			ntohl(mnl_attr_get_u32(tb[NFTA_RULE_COMPAT_PROTO]));
-		r->flags |=3D (1 << NFTNL_RULE_COMPAT_PROTO);
-	}
-	if (tb[NFTA_RULE_COMPAT_FLAGS]) {
-		r->compat.flags =3D
-			ntohl(mnl_attr_get_u32(tb[NFTA_RULE_COMPAT_FLAGS]));
-		r->flags |=3D (1 << NFTNL_RULE_COMPAT_FLAGS);
-	}
+	if (tb[NFTA_RULE_COMPAT_PROTO])
+		nftnl_rule_set_u32(r, NFTNL_RULE_COMPAT_PROTO,
+			ntohl(mnl_attr_get_u32(tb[NFTA_RULE_COMPAT_PROTO])));
+	if (tb[NFTA_RULE_COMPAT_FLAGS])
+		nftnl_rule_set_u32(r, NFTNL_RULE_COMPAT_FLAGS,
+			ntohl(mnl_attr_get_u32(tb[NFTA_RULE_COMPAT_FLAGS])));
 	return 0;
 }
=20
@@ -433,25 +429,20 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_rule *r)
 		return -1;
=20
 	if (tb[NFTA_RULE_TABLE]) {
-		if (r->flags & (1 << NFTNL_RULE_TABLE))
-			xfree(r->table);
-		r->table =3D strdup(mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
-		if (!r->table)
-			return -1;
-		r->flags |=3D (1 << NFTNL_RULE_TABLE);
+		ret =3D nftnl_rule_set_str(r, NFTNL_RULE_TABLE,
+				mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
+		if (ret)
+			return ret;
 	}
 	if (tb[NFTA_RULE_CHAIN]) {
-		if (r->flags & (1 << NFTNL_RULE_CHAIN))
-			xfree(r->chain);
-		r->chain =3D strdup(mnl_attr_get_str(tb[NFTA_RULE_CHAIN]));
-		if (!r->chain)
-			return -1;
-		r->flags |=3D (1 << NFTNL_RULE_CHAIN);
-	}
-	if (tb[NFTA_RULE_HANDLE]) {
-		r->handle =3D be64toh(mnl_attr_get_u64(tb[NFTA_RULE_HANDLE]));
-		r->flags |=3D (1 << NFTNL_RULE_HANDLE);
+		ret =3D nftnl_rule_set_str(r, NFTNL_RULE_CHAIN,
+			mnl_attr_get_str(tb[NFTA_RULE_CHAIN]));
+		if (ret)
+			return ret;
 	}
+	if (tb[NFTA_RULE_HANDLE])
+		nftnl_rule_set_u64(r, NFTNL_RULE_HANDLE,
+			be64toh(mnl_attr_get_u64(tb[NFTA_RULE_HANDLE])));
 	if (tb[NFTA_RULE_EXPRESSIONS]) {
 		ret =3D nftnl_rule_parse_expr(tb[NFTA_RULE_EXPRESSIONS], r);
 		if (ret)
@@ -462,29 +453,18 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr =
*nlh, struct nftnl_rule *r)
 		if (ret)
 			return ret;
 	}
-	if (tb[NFTA_RULE_POSITION]) {
-		r->position =3D be64toh(mnl_attr_get_u64(tb[NFTA_RULE_POSITION]));
-		r->flags |=3D (1 << NFTNL_RULE_POSITION);
-	}
+	if (tb[NFTA_RULE_POSITION])
+		nftnl_rule_set_u64(r, NFTNL_RULE_POSITION,
+			be64toh(mnl_attr_get_u64(tb[NFTA_RULE_POSITION])));
 	if (tb[NFTA_RULE_USERDATA]) {
-		const void *udata =3D
-			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
-
-		if (r->flags & (1 << NFTNL_RULE_USERDATA))
-			xfree(r->user.data);
-
-		r->user.len =3D mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
-
-		r->user.data =3D malloc(r->user.len);
-		if (r->user.data =3D=3D NULL)
-			return -1;
-
-		memcpy(r->user.data, udata, r->user.len);
-		r->flags |=3D (1 << NFTNL_RULE_USERDATA);
+		nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
+			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]),
+			mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]));
+		if (ret)
+			return ret;
 	}
=20
-	r->family =3D nfg->nfgen_family;
-	r->flags |=3D (1 << NFTNL_RULE_FAMILY);
+	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, nfg->nfgen_family);
=20
 	return 0;
 }
diff --git a/src/set.c b/src/set.c
index e1691c7..4042cc0 100644
--- a/src/set.c
+++ b/src/set.c
@@ -421,10 +421,9 @@ static int nftnl_set_desc_parse(struct nftnl_set *=
s,
 	if (mnl_attr_parse_nested(attr, nftnl_set_desc_parse_attr_cb, tb) < 0=
)
 		return -1;
=20
-	if (tb[NFTA_SET_DESC_SIZE]) {
-		s->desc.size =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_DESC_SIZE]));
-		s->flags |=3D (1 << NFTNL_SET_DESC_SIZE);
-	}
+	if (tb[NFTA_SET_DESC_SIZE])
+		nftnl_set_set_u32(s, NFTNL_SET_DESC_SIZE,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_DESC_SIZE])));
=20
 	return 0;
 }
@@ -439,65 +438,51 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nftnl_set *s)
 		return -1;
=20
 	if (tb[NFTA_SET_TABLE]) {
-		if (s->flags & (1 << NFTNL_SET_TABLE))
-			xfree(s->table);
-		s->table =3D strdup(mnl_attr_get_str(tb[NFTA_SET_TABLE]));
-		if (!s->table)
-			return -1;
-		s->flags |=3D (1 << NFTNL_SET_TABLE);
+		ret =3D nftnl_set_set_str(s, NFTNL_SET_TABLE,
+			mnl_attr_get_str(tb[NFTA_SET_TABLE]));
+		if (ret)
+			return ret;
 	}
 	if (tb[NFTA_SET_NAME]) {
-		if (s->flags & (1 << NFTNL_SET_NAME))
-			xfree(s->name);
-		s->name =3D strdup(mnl_attr_get_str(tb[NFTA_SET_NAME]));
-		if (!s->name)
-			return -1;
-		s->flags |=3D (1 << NFTNL_SET_NAME);
-	}
-	if (tb[NFTA_SET_FLAGS]) {
-		s->set_flags =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_FLAGS]));
-		s->flags |=3D (1 << NFTNL_SET_FLAGS);
-	}
-	if (tb[NFTA_SET_KEY_TYPE]) {
-		s->key_type =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_KEY_TYPE]));
-		s->flags |=3D (1 << NFTNL_SET_KEY_TYPE);
-	}
-	if (tb[NFTA_SET_KEY_LEN]) {
-		s->key_len =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_KEY_LEN]));
-		s->flags |=3D (1 << NFTNL_SET_KEY_LEN);
-	}
-	if (tb[NFTA_SET_DATA_TYPE]) {
-		s->data_type =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_DATA_TYPE]));
-		s->flags |=3D (1 << NFTNL_SET_DATA_TYPE);
-	}
-	if (tb[NFTA_SET_DATA_LEN]) {
-		s->data_len =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_DATA_LEN]));
-		s->flags |=3D (1 << NFTNL_SET_DATA_LEN);
-	}
-	if (tb[NFTA_SET_ID]) {
-		s->id =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_ID]));
-		s->flags |=3D (1 << NFTNL_SET_ID);
-	}
-	if (tb[NFTA_SET_POLICY]) {
-		s->policy =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_POLICY]));
-		s->flags |=3D (1 << NFTNL_SET_POLICY);
-	}
-	if (tb[NFTA_SET_TIMEOUT]) {
-		s->timeout =3D be64toh(mnl_attr_get_u64(tb[NFTA_SET_TIMEOUT]));
-		s->flags |=3D (1 << NFTNL_SET_TIMEOUT);
-	}
-	if (tb[NFTA_SET_GC_INTERVAL]) {
-		s->gc_interval =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_GC_INTERVAL]))=
;
-		s->flags |=3D (1 << NFTNL_SET_GC_INTERVAL);
+		ret =3D nftnl_set_set_str(s, NFTNL_SET_NAME,
+			mnl_attr_get_str(tb[NFTA_SET_NAME]));
+		if (ret)
+			return ret;
 	}
+	if (tb[NFTA_SET_FLAGS])
+		nftnl_set_set_u32(s, NFTNL_SET_FLAGS,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_FLAGS])));
+	if (tb[NFTA_SET_KEY_TYPE])
+		nftnl_set_set_u32(s, NFTNL_SET_KEY_TYPE,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_KEY_TYPE])));
+	if (tb[NFTA_SET_KEY_LEN])
+		nftnl_set_set_u32(s, NFTNL_SET_KEY_LEN,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_KEY_LEN])));
+	if (tb[NFTA_SET_DATA_TYPE])
+		nftnl_set_set_u32(s, NFTNL_SET_DATA_TYPE,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_DATA_TYPE])));
+	if (tb[NFTA_SET_DATA_LEN])
+		nftnl_set_set_u32(s, NFTNL_SET_DATA_LEN,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_DATA_LEN])));
+	if (tb[NFTA_SET_ID])
+		nftnl_set_set_u32(s, NFTNL_SET_ID,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_ID])));
+	if (tb[NFTA_SET_POLICY])
+		nftnl_set_set_u32(s, NFTNL_SET_POLICY,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_POLICY])));
+	if (tb[NFTA_SET_TIMEOUT])
+		nftnl_set_set_u64(s, NFTNL_SET_TIMEOUT,
+			be64toh(mnl_attr_get_u64(tb[NFTA_SET_TIMEOUT])));
+	if (tb[NFTA_SET_GC_INTERVAL])
+		nftnl_set_set_u32(s, NFTNL_SET_GC_INTERVAL,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_GC_INTERVAL])));
 	if (tb[NFTA_SET_DESC]) {
 		ret =3D nftnl_set_desc_parse(s, tb[NFTA_SET_DESC]);
 		if (ret)
 			return ret;
 	}
=20
-	s->family =3D nfg->nfgen_family;
-	s->flags |=3D (1 << NFTNL_SET_FAMILY);
+	nftnl_set_set_u32(s, NFTNL_SET_FAMILY, nfg->nfgen_family);
=20
 	return 0;
 }
diff --git a/src/set_elem.c b/src/set_elem.c
index e4dd313..a3467b4 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -119,6 +119,9 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, ui=
nt16_t attr,
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 		s->timeout =3D *((uint64_t *)data);
 		break;
+	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
+		s->expiration =3D *((uint64_t *)data);
+		break;
 	case NFTNL_SET_ELEM_USERDATA: /* NFTA_SET_ELEM_USERDATA */
 		if (s->flags & (1 << NFTNL_SET_ELEM_USERDATA))
 			xfree(s->user.data);
@@ -355,19 +358,15 @@ static int nftnl_set_elems_parse2(struct nftnl_se=
t *s, const struct nlattr *nest
 	if (ret)
 		goto out_set_elem;
=20
-	if (tb[NFTA_SET_ELEM_FLAGS]) {
-		e->set_elem_flags =3D
-			ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_FLAGS]));
-		e->flags |=3D (1 << NFTNL_SET_ELEM_FLAGS);
-	}
-	if (tb[NFTA_SET_ELEM_TIMEOUT]) {
-		e->timeout =3D be64toh(mnl_attr_get_u64(tb[NFTA_SET_ELEM_TIMEOUT]));
-		e->flags |=3D (1 << NFTNL_SET_ELEM_TIMEOUT);
-	}
-	if (tb[NFTA_SET_ELEM_EXPIRATION]) {
-		e->expiration =3D be64toh(mnl_attr_get_u64(tb[NFTA_SET_ELEM_EXPIRATI=
ON]));
-		e->flags |=3D (1 << NFTNL_SET_ELEM_EXPIRATION);
-	}
+	if (tb[NFTA_SET_ELEM_FLAGS])
+		nftnl_set_elem_set_u32(e, NFTNL_SET_ELEM_FLAGS,
+			ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_FLAGS])));
+	if (tb[NFTA_SET_ELEM_TIMEOUT])
+		nftnl_set_elem_set_u64(e, NFTNL_SET_ELEM_TIMEOUT,
+			be64toh(mnl_attr_get_u64(tb[NFTA_SET_ELEM_TIMEOUT])));
+	if (tb[NFTA_SET_ELEM_EXPIRATION])
+		nftnl_set_elem_set_u64(e, NFTNL_SET_ELEM_EXPIRATION,
+			be64toh(mnl_attr_get_u64(tb[NFTA_SET_ELEM_EXPIRATION])));
         if (tb[NFTA_SET_ELEM_KEY]) {
 		ret =3D nftnl_parse_data(&e->key, tb[NFTA_SET_ELEM_KEY], &type);
 		if (ret)
@@ -398,18 +397,11 @@ static int nftnl_set_elems_parse2(struct nftnl_se=
t *s, const struct nlattr *nest
 		e->flags |=3D (1 << NFTNL_SET_ELEM_EXPR);
 	}
 	if (tb[NFTA_SET_ELEM_USERDATA]) {
-		const void *udata =3D
-			mnl_attr_get_payload(tb[NFTA_SET_ELEM_USERDATA]);
-
-		if (e->flags & (1 << NFTNL_RULE_USERDATA))
-			xfree(e->user.data);
-
-		e->user.len  =3D mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]=
);
-		e->user.data =3D malloc(e->user.len);
-		if (e->user.data =3D=3D NULL)
+		ret =3D nftnl_set_elem_set(e, NFTNL_SET_ELEM_USERDATA,
+			mnl_attr_get_payload(tb[NFTA_SET_ELEM_USERDATA]),
+			mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]));
+		if (ret)
 			goto out_expr;
-		memcpy(e->user.data, udata, e->user.len);
-		e->flags |=3D (1 << NFTNL_RULE_USERDATA);
 	}
=20
 	/* Add this new element to this set */
@@ -475,35 +467,27 @@ int nftnl_set_elems_nlmsg_parse(const struct nlms=
ghdr *nlh, struct nftnl_set *s)
 		return -1;
=20
 	if (tb[NFTA_SET_ELEM_LIST_TABLE]) {
-		if (s->flags & (1 << NFTNL_SET_TABLE))
-			xfree(s->table);
-		s->table =3D
-			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_TABLE]));
-		if (!s->table)
-			return -1;
-		s->flags |=3D (1 << NFTNL_SET_TABLE);
+		ret =3D nftnl_set_set_str(s, NFTNL_SET_TABLE,
+			mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_TABLE]));
+		if (ret)
+			return ret;
 	}
 	if (tb[NFTA_SET_ELEM_LIST_SET]) {
-		if (s->flags & (1 << NFTNL_SET_NAME))
-			xfree(s->name);
-		s->name =3D
-			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
-		if (!s->name)
-			return -1;
-		s->flags |=3D (1 << NFTNL_SET_NAME);
-	}
-	if (tb[NFTA_SET_ELEM_LIST_SET_ID]) {
-		s->id =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_LIST_SET_ID]));
-		s->flags |=3D (1 << NFTNL_SET_ID);
+		ret =3D nftnl_set_set_str(s, NFTNL_SET_NAME,
+			mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
+		if (ret)
+			return ret;
 	}
+	if (tb[NFTA_SET_ELEM_LIST_SET_ID])
+		nftnl_set_set_u32(s, NFTNL_SET_ID,
+			mnl_attr_get_u32(tb[NFTA_SET_ELEM_LIST_SET_ID]));
         if (tb[NFTA_SET_ELEM_LIST_ELEMENTS]) {
 	 	ret =3D nftnl_set_elems_parse(s, tb[NFTA_SET_ELEM_LIST_ELEMENTS]);
 		if (ret)
 			return ret;
 	}
=20
-	s->family =3D nfg->nfgen_family;
-	s->flags |=3D (1 << NFTNL_SET_FAMILY);
+	nftnl_set_set_u32(s, NFTNL_SET_FAMILY, nfg->nfgen_family);
=20
 	return 0;
 }
diff --git a/src/table.c b/src/table.c
index 32d119f..8b72a69 100644
--- a/src/table.c
+++ b/src/table.c
@@ -222,29 +222,25 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr=
 *nlh, struct nftnl_table *t)
 {
 	struct nlattr *tb[NFTA_TABLE_MAX+1] =3D {};
 	struct nfgenmsg *nfg =3D mnl_nlmsg_get_payload(nlh);
+	int err;
=20
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_table_parse_attr_cb, tb) =
< 0)
 		return -1;
=20
 	if (tb[NFTA_TABLE_NAME]) {
-		if (t->flags & (1 << NFTNL_TABLE_NAME))
-			xfree(t->name);
-		t->name =3D strdup(mnl_attr_get_str(tb[NFTA_TABLE_NAME]));
-		if (!t->name)
-			return -1;
-		t->flags |=3D (1 << NFTNL_TABLE_NAME);
+		err =3D nftnl_table_set_str(t, NFTNL_TABLE_NAME,
+			mnl_attr_get_str(tb[NFTA_TABLE_NAME]));
+		if (err)
+			return err;
 	}
-	if (tb[NFTA_TABLE_FLAGS]) {
-		t->table_flags =3D ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_FLAGS]));
-		t->flags |=3D (1 << NFTNL_TABLE_FLAGS);
-	}
-	if (tb[NFTA_TABLE_USE]) {
-		t->use =3D ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_USE]));
-		t->flags |=3D (1 << NFTNL_TABLE_USE);
-	}
-
-	t->family =3D nfg->nfgen_family;
-	t->flags |=3D (1 << NFTNL_TABLE_FAMILY);
+	if (tb[NFTA_TABLE_FLAGS])
+		nftnl_table_set_u32(t, NFTNL_TABLE_FLAGS,
+			ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_FLAGS])));
+	if (tb[NFTA_TABLE_USE])
+		nftnl_table_set_u32(t, NFTNL_TABLE_USE,
+			ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_USE])));
+
+	nftnl_table_set_u32(t, NFTNL_TABLE_FAMILY, nfg->nfgen_family);
=20
 	return 0;
 }
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
