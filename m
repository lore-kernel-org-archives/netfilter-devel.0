Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5310C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92BAF206A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgOIHz8p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgA3ARV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:17:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43882 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgA3ARV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580343438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0GnpZOZmuwgLZ6mlUtDYUEb5cNLWEyCKlpHJd1dxB0=;
        b=HgOIHz8pS7wfSANjA0VsBzFFQjN1jEiZc9ouNb4vPelPkfATNqwnCAMjRfpDb+5j9eetL9
        WECkR9XPQVDs8R2pj1i7MZm1lJxHBMzD3e0mCfIWEQON3fycH+XSXqU4asmKmix4AxdApT
        UFHcxN5wDy8t4700TjIe9IXZ05l203U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-3zJwb-w5PxaT2z4JNi1UTQ-1; Wed, 29 Jan 2020 19:17:12 -0500
X-MC-Unique: 3zJwb-w5PxaT2z4JNi1UTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73DEF107ACC7;
        Thu, 30 Jan 2020 00:17:11 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B375CFC2;
        Thu, 30 Jan 2020 00:17:08 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v4 3/4] src: Add support for concatenated set ranges
Date:   Thu, 30 Jan 2020 01:16:57 +0100
Message-Id: <92d2e10dda6dbb8443383606bde835ca1e9da834.1580342294.git.sbrivio@redhat.com>
In-Reply-To: <cover.1580342294.git.sbrivio@redhat.com>
References: <cover.1580342294.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After exporting field lengths via NFTNL_SET_DESC_CONCAT attributes,
we now need to adjust parsing of user input and generation of
netlink key data to complete support for concatenation of set
ranges.

Instead of using separate elements for start and end of a range,
denoting the end element by the NFT_SET_ELEM_INTERVAL_END flag,
as it's currently done for ranges without concatenation, we'll use
the new attribute NFTNL_SET_ELEM_KEY_END as suggested by Pablo. It
behaves in the same way as NFTNL_SET_ELEM_KEY, but it indicates
that the included key represents the upper bound of a range.

For example, "packets with an IPv4 address between 192.0.2.0 and
192.0.2.42, with destination port between 22 and 25", needs to be
expressed as a single element with two keys:

  NFTA_SET_ELEM_KEY:		192.0.2.0 . 22
  NFTA_SET_ELEM_KEY_END:	192.0.2.42 . 25

To achieve this, we need to:

- adjust the lexer rules to allow multiton expressions as elements
  of a concatenation. As wildcards are not allowed (semantics would
  be ambiguous), exclude wildcards expressions from the set of
  possible multiton expressions, and allow them directly where
  needed. Concatenations now admit prefixes and ranges

- generate, for each element in a range concatenation, a second key
  attribute, that includes the upper bound for the range

- also expand prefixes and non-ranged values in the concatenation
  to ranges: given a set with interval and concatenation support,
  the kernel has no way to tell which elements are ranged, so they
  all need to be. For example, 192.0.2.0 . 192.0.2.9 : 1024 is
  sent as:

  NFTA_SET_ELEM_KEY:		192.0.2.0 . 1024
  NFTA_SET_ELEM_KEY_END:	192.0.2.9 . 1024

- aggregate ranges when elements received by the kernel represent
  concatenated ranges, see concat_range_aggregate()

- perform a few minor adjustments where interval expressions
  are already handled: we have intervals in these sets, but
  the set specification isn't just an interval, so we can't
  just aggregate and deaggregate interval ranges linearly

v4: No changes
v3:
 - rework to use a separate key for closing element of range instead of
   a separate element with EXPR_F_INTERVAL_END set (Pablo Neira Ayuso)
v2:
 - reworked netlink_gen_concat_data(), moved loop body to a new function,
   netlink_gen_concat_data_expr() (Phil Sutter)
 - dropped repeated pattern in bison file, replaced by a new helper,
   compound_expr_alloc_or_add() (Phil Sutter)
 - added set_is_nonconcat_range() helper (Phil Sutter)
 - in expr_evaluate_set(), we need to set NFT_SET_SUBKEY also on empty
   sets where the set in the context already has the flag
 - dropped additional 'end' parameter from netlink_gen_data(),
   temporarily set EXPR_F_INTERVAL_END on expressions and use that from
   netlink_gen_concat_data() to figure out we need to add the 'end'
   element (Phil Sutter)
 - replace range_mask_len() by a simplified version, as we don't need
   to actually store the composing masks of a range (Phil Sutter)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/expression.h |   1 +
 include/rule.h       |   5 ++
 src/evaluate.c       |   5 ++
 src/netlink.c        | 109 +++++++++++++++++++++++++++++-----------
 src/parser_bison.y   |  17 +++++--
 src/rule.c           |  13 ++---
 src/segtree.c        | 117 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 229 insertions(+), 38 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 6196be58c2a6..cbf09b59c82b 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -465,6 +465,7 @@ extern int set_to_intervals(struct list_head *msgs, s=
truct set *set,
 			    struct expr *init, bool add,
 			    unsigned int debug_mask, bool merge,
 			    struct output_ctx *octx);
+extern void concat_range_aggregate(struct expr *set);
 extern void interval_map_decompose(struct expr *set);
=20
 extern struct expr *get_set_intervals(const struct set *set,
diff --git a/include/rule.h b/include/rule.h
index a7f106f715cf..c232221e541b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -372,6 +372,11 @@ static inline bool set_is_interval(uint32_t set_flag=
s)
 	return set_flags & NFT_SET_INTERVAL;
 }
=20
+static inline bool set_is_non_concat_range(struct set *s)
+{
+	return (s->flags & NFT_SET_INTERVAL) && s->desc.field_count <=3D 1;
+}
+
 #include <statement.h>
=20
 struct counter {
diff --git a/src/evaluate.c b/src/evaluate.c
index 55591f5f3526..208250715e1f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -136,6 +136,11 @@ static int byteorder_conversion(struct eval_ctx *ctx=
, struct expr **expr,
=20
 	if ((*expr)->byteorder =3D=3D byteorder)
 		return 0;
+
+	/* Conversion for EXPR_CONCAT is handled for single composing ranges */
+	if ((*expr)->etype =3D=3D EXPR_CONCAT)
+		return 0;
+
 	if (expr_basetype(*expr)->type !=3D TYPE_INTEGER)
 		return expr_error(ctx->msgs, *expr,
 			 	  "Byteorder mismatch: expected %s, got %s",
diff --git a/src/netlink.c b/src/netlink.c
index 791943b4d926..e41289631380 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -100,10 +100,11 @@ struct nftnl_expr *alloc_nft_expr(const char *name)
 static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set=
,
 						  const struct expr *expr)
 {
-	const struct expr *elem, *key, *data;
+	const struct expr *elem, *data;
 	struct nftnl_set_elem *nlse;
 	struct nft_data_linearize nld;
 	struct nftnl_udata_buf *udbuf =3D NULL;
+	struct expr *key;
=20
 	nlse =3D nftnl_set_elem_alloc();
 	if (nlse =3D=3D NULL)
@@ -121,6 +122,16 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(co=
nst struct expr *set,
=20
 	netlink_gen_data(key, &nld);
 	nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
+
+	if (set->set_flags & NFT_SET_INTERVAL && expr->key->field_count > 1) {
+		key->flags |=3D EXPR_F_INTERVAL_END;
+		netlink_gen_data(key, &nld);
+		key->flags &=3D ~EXPR_F_INTERVAL_END;
+
+		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END, &nld.value,
+				   nld.len);
+	}
+
 	if (elem->timeout)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
 				       elem->timeout);
@@ -188,28 +199,58 @@ void netlink_gen_raw_data(const mpz_t value, enum b=
yteorder byteorder,
 	data->len =3D len;
 }
=20
+static int netlink_export_pad(unsigned char *data, const mpz_t v,
+			      const struct expr *i)
+{
+	mpz_export_data(data, v, i->byteorder,
+			div_round_up(i->len, BITS_PER_BYTE));
+
+	return netlink_padded_len(i->len) / BITS_PER_BYTE;
+}
+
+static int netlink_gen_concat_data_expr(int end, const struct expr *i,
+					unsigned char *data)
+{
+	switch (i->etype) {
+	case EXPR_RANGE:
+		i =3D end ? i->right : i->left;
+		break;
+	case EXPR_PREFIX:
+		if (end) {
+			int count;
+			mpz_t v;
+
+			mpz_init_bitmask(v, i->len - i->prefix_len);
+			mpz_add(v, i->prefix->value, v);
+			count =3D netlink_export_pad(data, v, i);
+			mpz_clear(v);
+			return count;
+		}
+		return netlink_export_pad(data, i->prefix->value, i);
+	case EXPR_VALUE:
+		break;
+	default:
+		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
+	}
+
+	return netlink_export_pad(data, i->value, i);
+}
+
 static void netlink_gen_concat_data(const struct expr *expr,
 				    struct nft_data_linearize *nld)
 {
+	unsigned int len =3D expr->len / BITS_PER_BYTE, offset =3D 0;
+	int end =3D expr->flags & EXPR_F_INTERVAL_END;
+	unsigned char data[len];
 	const struct expr *i;
-	unsigned int len, offset;
-
-	len =3D expr->len / BITS_PER_BYTE;
-	if (1) {
-		unsigned char data[len];
-
-		memset(data, 0, sizeof(data));
-		offset =3D 0;
-		list_for_each_entry(i, &expr->expressions, list) {
-			assert(i->etype =3D=3D EXPR_VALUE);
-			mpz_export_data(data + offset, i->value, i->byteorder,
-					div_round_up(i->len, BITS_PER_BYTE));
-			offset +=3D netlink_padded_len(i->len) / BITS_PER_BYTE;
-		}
=20
-		memcpy(nld->value, data, len);
-		nld->len =3D len;
-	}
+	memset(data, 0, len);
+
+	list_for_each_entry(i, &expr->expressions, list)
+		offset +=3D netlink_gen_concat_data_expr(end, i, data + offset);
+
+	memcpy(nld->value, data, len);
+	nld->len =3D len;
 }
=20
 static void netlink_gen_constant_data(const struct expr *expr,
@@ -913,6 +954,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem=
 *nlse,
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_FLAGS))
 		flags =3D nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_FLAGS);
=20
+key_end:
 	key =3D netlink_alloc_value(&netlink_location, &nld);
 	datatype_set(key, set->key->dtype);
 	key->byteorder	=3D set->key->byteorder;
@@ -984,6 +1026,15 @@ int netlink_delinearize_setelem(struct nftnl_set_el=
em *nlse,
 	}
 out:
 	compound_expr_add(set->init, expr);
+
+	if (!(flags & NFT_SET_ELEM_INTERVAL_END) &&
+	    nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_KEY_END)) {
+		flags |=3D NFT_SET_ELEM_INTERVAL_END;
+		nld.value =3D nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_KEY_END,
+					       &nld.len);
+		goto key_end;
+	}
+
 	return 0;
 }
=20
@@ -1022,15 +1073,16 @@ int netlink_list_setelems(struct netlink_ctx *ctx=
, const struct handle *h,
 	set->init =3D set_expr_alloc(&internal_location, set);
 	nftnl_set_elem_foreach(nls, list_setelem_cb, ctx);
=20
-	if (!(set->flags & NFT_SET_INTERVAL))
+	if (set->flags & NFT_SET_INTERVAL && set->desc.field_count > 1)
+		concat_range_aggregate(set->init);
+	else if (set->flags & NFT_SET_INTERVAL)
+		interval_map_decompose(set->init);
+	else
 		list_expr_sort(&ctx->set->init->expressions);
=20
 	nftnl_set_free(nls);
 	ctx->set =3D NULL;
=20
-	if (set->flags & NFT_SET_INTERVAL)
-		interval_map_decompose(set->init);
-
 	return 0;
 }
=20
@@ -1039,6 +1091,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, co=
nst struct handle *h,
 			struct set *set, struct expr *init)
 {
 	struct nftnl_set *nls, *nls_out =3D NULL;
+	int err =3D 0;
=20
 	nls =3D nftnl_set_alloc();
 	if (nls =3D=3D NULL)
@@ -1062,18 +1115,18 @@ int netlink_get_setelem(struct netlink_ctx *ctx, =
const struct handle *h,
 	set->init =3D set_expr_alloc(loc, set);
 	nftnl_set_elem_foreach(nls_out, list_setelem_cb, ctx);
=20
-	if (!(set->flags & NFT_SET_INTERVAL))
+	if (set->flags & NFT_SET_INTERVAL && set->desc.field_count > 1)
+		concat_range_aggregate(set->init);
+	else if (set->flags & NFT_SET_INTERVAL)
+		err =3D get_set_decompose(table, set);
+	else
 		list_expr_sort(&ctx->set->init->expressions);
=20
 	nftnl_set_free(nls);
 	nftnl_set_free(nls_out);
 	ctx->set =3D NULL;
=20
-	if (set->flags & NFT_SET_INTERVAL &&
-	    get_set_decompose(table, set) < 0)
-		return -1;
-
-	return 0;
+	return err;
 }
=20
 void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 799f7a308b07..e86cf7a9a6ff 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3592,7 +3592,6 @@ range_rhs_expr		:	basic_rhs_expr	DASH	basic_rhs_exp=
r
=20
 multiton_rhs_expr	:	prefix_rhs_expr
 			|	range_rhs_expr
-			|	wildcard_expr
 			;
=20
 map_expr		:	concat_expr	MAP	rhs_expr
@@ -3686,7 +3685,7 @@ set_elem_option		:	TIMEOUT			time_spec
 			;
=20
 set_lhs_expr		:	concat_rhs_expr
-			|	multiton_rhs_expr
+			|	wildcard_expr
 			;
=20
 set_rhs_expr		:	concat_rhs_expr
@@ -3939,7 +3938,7 @@ list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_e=
xpr
 			;
=20
 rhs_expr		:	concat_rhs_expr		{ $$ =3D $1; }
-			|	multiton_rhs_expr	{ $$ =3D $1; }
+			|	wildcard_expr		{ $$ =3D $1; }
 			|	set_expr		{ $$ =3D $1; }
 			|	set_ref_symbol_expr	{ $$ =3D $1; }
 			;
@@ -3980,7 +3979,17 @@ basic_rhs_expr		:	inclusive_or_rhs_expr
 			;
=20
 concat_rhs_expr		:	basic_rhs_expr
-			|	concat_rhs_expr	DOT	basic_rhs_expr
+			|	multiton_rhs_expr
+			|	concat_rhs_expr		DOT	multiton_rhs_expr
+			{
+				struct location rhs[] =3D {
+					[1]	=3D @2,
+					[2]	=3D @3,
+				};
+
+				$$ =3D handle_concat_expr(&@$, $$, $1, $3, rhs);
+			}
+			|	concat_rhs_expr		DOT	basic_rhs_expr
 			{
 				struct location rhs[] =3D {
 					[1]	=3D @2,
diff --git a/src/rule.c b/src/rule.c
index 4853c4f302ee..337a66bbd5fa 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1540,7 +1540,8 @@ static int __do_add_setelems(struct netlink_ctx *ct=
x, struct set *set,
 		return -1;
=20
 	if (set->init !=3D NULL &&
-	    set->flags & NFT_SET_INTERVAL) {
+	    set->flags & NFT_SET_INTERVAL &&
+	    set->desc.field_count <=3D 1) {
 		interval_map_decompose(expr);
 		list_splice_tail_init(&expr->expressions, &set->init->expressions);
 		set->init->size +=3D expr->size;
@@ -1561,7 +1562,7 @@ static int do_add_setelems(struct netlink_ctx *ctx,=
 struct cmd *cmd,
 	table =3D table_lookup(h, &ctx->nft->cache);
 	set =3D set_lookup(table, h->set.name);
=20
-	if (set->flags & NFT_SET_INTERVAL &&
+	if (set_is_non_concat_range(set) &&
 	    set_to_intervals(ctx->msgs, set, init, true,
 			     ctx->nft->debug_mask, set->automerge,
 			     &ctx->nft->output) < 0)
@@ -1576,7 +1577,7 @@ static int do_add_set(struct netlink_ctx *ctx, cons=
t struct cmd *cmd,
 	struct set *set =3D cmd->set;
=20
 	if (set->init !=3D NULL) {
-		if (set->flags & NFT_SET_INTERVAL &&
+		if (set_is_non_concat_range(set) &&
 		    set_to_intervals(ctx->msgs, set, set->init, true,
 				     ctx->nft->debug_mask, set->automerge,
 				     &ctx->nft->output) < 0)
@@ -1662,7 +1663,7 @@ static int do_delete_setelems(struct netlink_ctx *c=
tx, struct cmd *cmd)
 	table =3D table_lookup(h, &ctx->nft->cache);
 	set =3D set_lookup(table, h->set.name);
=20
-	if (set->flags & NFT_SET_INTERVAL &&
+	if (set_is_non_concat_range(set) &&
 	    set_to_intervals(ctx->msgs, set, expr, false,
 			     ctx->nft->debug_mask, set->automerge,
 			     &ctx->nft->output) < 0)
@@ -2516,7 +2517,7 @@ static int do_get_setelems(struct netlink_ctx *ctx,=
 struct cmd *cmd,
 	set =3D set_lookup(table, cmd->handle.set.name);
=20
 	/* Create a list of elements based of what we got from command line. */
-	if (set->flags & NFT_SET_INTERVAL)
+	if (set_is_non_concat_range(set))
 		init =3D get_set_intervals(set, cmd->expr);
 	else
 		init =3D cmd->expr;
@@ -2529,7 +2530,7 @@ static int do_get_setelems(struct netlink_ctx *ctx,=
 struct cmd *cmd,
 	if (err >=3D 0)
 		__do_list_set(ctx, cmd, table, new_set);
=20
-	if (set->flags & NFT_SET_INTERVAL)
+	if (set_is_non_concat_range(set))
 		expr_free(init);
=20
 	set_free(new_set);
diff --git a/src/segtree.c b/src/segtree.c
index e8e32412f3a4..8d79332d8578 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -650,6 +650,11 @@ struct expr *get_set_intervals(const struct set *set=
, const struct expr *init)
 			set_elem_add(set, new_init, i->key->value,
 				     i->flags, i->byteorder);
 			break;
+		case EXPR_CONCAT:
+			compound_expr_add(new_init, expr_clone(i));
+			i->flags |=3D EXPR_F_INTERVAL_END;
+			compound_expr_add(new_init, expr_clone(i));
+			break;
 		default:
 			range_expr_value_low(low, i);
 			set_elem_add(set, new_init, low, 0, i->byteorder);
@@ -821,6 +826,9 @@ static int expr_value_cmp(const void *p1, const void =
*p2)
 	struct expr *e2 =3D *(void * const *)p2;
 	int ret;
=20
+	if (expr_value(e1)->etype =3D=3D EXPR_CONCAT)
+		return -1;
+
 	ret =3D mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
 	if (ret =3D=3D 0) {
 		if (e1->flags & EXPR_F_INTERVAL_END)
@@ -832,6 +840,115 @@ static int expr_value_cmp(const void *p1, const voi=
d *p2)
 	return ret;
 }
=20
+/* Given start and end elements of a range, check if it can be represent=
ed as
+ * a single netmask, and if so, how long, by returning zero or a positiv=
e value.
+ */
+static int range_mask_len(const mpz_t start, const mpz_t end, unsigned i=
nt len)
+{
+	mpz_t tmp_start, tmp_end;
+	int ret;
+
+	mpz_init_set_ui(tmp_start, mpz_get_ui(start));
+	mpz_init_set_ui(tmp_end, mpz_get_ui(end));
+
+	while (mpz_cmp(tmp_start, tmp_end) <=3D 0 &&
+		!mpz_tstbit(tmp_start, 0) && mpz_tstbit(tmp_end, 0) &&
+		len--) {
+		mpz_fdiv_q_2exp(tmp_start, tmp_start, 1);
+		mpz_fdiv_q_2exp(tmp_end, tmp_end, 1);
+	}
+
+	ret =3D !mpz_cmp(tmp_start, tmp_end) ? (int)len : -1;
+
+	mpz_clear(tmp_start);
+	mpz_clear(tmp_end);
+
+	return ret;
+}
+
+/* Given a set with two elements (start and end), transform them into a
+ * concatenation of ranges. That is, from a list of start expressions an=
d a list
+ * of end expressions, form a list of start - end expressions.
+ */
+void concat_range_aggregate(struct expr *set)
+{
+	struct expr *i, *start =3D NULL, *end, *r1, *r2, *next, *r1_next, *tmp;
+	struct list_head *r2_next;
+	int prefix_len, free_r1;
+	mpz_t range, p;
+
+	list_for_each_entry_safe(i, next, &set->expressions, list) {
+		if (!start) {
+			start =3D i;
+			continue;
+		}
+		end =3D i;
+
+		/* Walk over r1 (start expression) and r2 (end) in parallel,
+		 * form ranges between corresponding r1 and r2 expressions,
+		 * store them by replacing r2 expressions, and free r1
+		 * expressions.
+		 */
+		r2 =3D list_first_entry(&expr_value(end)->expressions,
+				      struct expr, list);
+		list_for_each_entry_safe(r1, r1_next,
+					 &expr_value(start)->expressions,
+					 list) {
+			mpz_init(range);
+			mpz_init(p);
+
+			r2_next =3D r2->list.next;
+			free_r1 =3D 0;
+
+			if (!mpz_cmp(r1->value, r2->value)) {
+				free_r1 =3D 1;
+				goto next;
+			}
+
+			mpz_sub(range, r2->value, r1->value);
+			mpz_sub_ui(range, range, 1);
+			mpz_and(p, r1->value, range);
+
+			/* Check if we are forced, or if it's anyway preferable,
+			 * to express the range as two points instead of a
+			 * netmask.
+			 */
+			prefix_len =3D range_mask_len(r1->value, r2->value,
+						    r1->len);
+			if (prefix_len < 0 ||
+			    !(r1->dtype->flags & DTYPE_F_PREFIX)) {
+				tmp =3D range_expr_alloc(&r1->location, r1,
+						       r2);
+
+				list_replace(&r2->list, &tmp->list);
+				r2_next =3D tmp->list.next;
+			} else {
+				tmp =3D prefix_expr_alloc(&r1->location, r1,
+							prefix_len);
+				tmp->len =3D r2->len;
+
+				list_replace(&r2->list, &tmp->list);
+				r2_next =3D tmp->list.next;
+				expr_free(r2);
+			}
+
+next:
+			mpz_clear(p);
+			mpz_clear(range);
+
+			r2 =3D list_entry(r2_next, typeof(*r2), list);
+			compound_expr_remove(start, r1);
+
+			if (free_r1)
+				expr_free(r1);
+		}
+
+		compound_expr_remove(set, start);
+		expr_free(start);
+		start =3D NULL;
+	}
+}
+
 void interval_map_decompose(struct expr *set)
 {
 	struct expr **elements, **ranges;
--=20
2.24.1

