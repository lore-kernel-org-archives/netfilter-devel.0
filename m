Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA5DC432C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5849122313
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4k5/cCS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfKSBH1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:07:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726962AbfKSBH0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 20:07:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574125644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qF4w1mL4O5ZA8Ridr5ugaiulSTEulOZtpnG0wP59aPQ=;
        b=N4k5/cCSGNkC1Aw8W/u9se+WISedZdDd0dPlneZOPxLtrJtnpT3cplheK97Si2hDSWW3np
        oFX0XFjZQr4vs5udI462twAHvaXtI5a/J46OIgsmF4/Ds7ovvJvqTRjbmXtVohv4awFOOr
        mKV1rjRmO+E0lnXudSRXJoiR2sFdoeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-9lMo6gzGPiGcwDB14ckOeg-1; Mon, 18 Nov 2019 20:07:21 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 996AD64A7E;
        Tue, 19 Nov 2019 01:07:20 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55953BA45;
        Tue, 19 Nov 2019 01:07:18 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 2/3] src: Add support for concatenated set ranges
Date:   Tue, 19 Nov 2019 02:07:11 +0100
Message-Id: <20191119010712.39316-3-sbrivio@redhat.com>
In-Reply-To: <20191119010712.39316-1-sbrivio@redhat.com>
References: <20191119010712.39316-1-sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 9lMo6gzGPiGcwDB14ckOeg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After exporting subkey (field) lengths via netlink attributes, we now
need to adjust parsing of user input and generation of netlink key
data to complete support for concatenation of set ranges.

The expression of concatenated ranges is described in the kernel
counterpart for this change, quoted here:

--
In order to specify the interval for a set entry, userspace would
simply keep using two elements per entry, as it happens now, with the
end element indicating the upper interval bound. As a single element
can now be a concatenation of several fields, with or without the
NFT_SET_ELEM_INTERVAL_END flag, we obtain a convenient way to support
multiple ranged fields in a set.

[...]

For example, "packets with an IPv4 address between 192.0.2.0 and
192.0.2.42, with destination port between 22 and 25", can be
expressed as two concatenated elements:

  192.0.2.0 . 22
  192.0.2.42 . 25 with NFT_SET_ELEM_INTERVAL_END

and the NFTA_SET_SUBKEY attributes would be 32, 16, in that order.

Note that this does *not* represent the concatenated range:

  0xc0 0x00 0x02 0x00 0x00 0x16 - 0xc0 0x00 0x02 0x2a 0x00 0x25

on the six packet bytes of interest. That is, the range specified
does *not* include e.g. 0xc0 0x00 0x02 0x29 0x00 0x42, which is:
  192.0.0.41 . 66
--

To achieve this, we need to:

- adjust the lexer rules to allow multiton expressions as elements
  of a concatenation. As wildcards are not allowed (semantics would
  be ambiguous), exclude wildcards expressions from the set of
  possible multiton expressions, and allow them directly where
  needed. Concatenations now admit prefixes and ranges

- generate, for each concatenated range, two elements: one
  containing the start expressions, and one containing the
  end expressions for all fields in the concatenation

- also expand prefixes and non-ranged values in the concatenation
  to ranges: given a set with interval and subkey support, the
  kernel has no way to tell which elements are ranged, so they all
  need to be. So, for example, 192.0.2.0 . 192.0.2.9 : 1024 is
  sent as the two elements:
    192.0.2.0 : 1024
    192.0.2.9 : 1024 [end]

- aggregate ranges when elements for NFT_SET_SUBKEY sets are
  received by the kernel, see concat_range_aggregate()

- perform a few minor adjustments where interval expressions
  are already handled: we have intervals in these sets, but
  the set specification isn't just an interval, so we can't
  just aggregate and deaggregate interval ranges linearly

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/expression.h    |   3 +
 include/netlink.h       |   2 +-
 src/evaluate.c          |  13 +++-
 src/netlink.c           |  95 +++++++++++++++++++++-------
 src/netlink_linearize.c |  16 ++---
 src/parser_bison.y      |  25 ++++++--
 src/rule.c              |  10 +--
 src/segtree.c           | 134 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 256 insertions(+), 42 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index b6d5adb2..61596c2e 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -459,10 +459,13 @@ extern int set_to_intervals(struct list_head *msgs, s=
truct set *set,
 =09=09=09    struct expr *init, bool add,
 =09=09=09    unsigned int debug_mask, bool merge,
 =09=09=09    struct output_ctx *octx);
+extern void concat_range_aggregate(struct expr *set);
 extern void interval_map_decompose(struct expr *set);
=20
 extern struct expr *get_set_intervals(const struct set *set,
 =09=09=09=09      const struct expr *init);
+static void set_elem_add(const struct set *set, struct expr *init, mpz_t v=
alue,
+=09=09=09 uint32_t flags);
 struct table;
 extern int get_set_decompose(struct table *table, struct set *set);
=20
diff --git a/include/netlink.h b/include/netlink.h
index e6941714..ad9e0d2a 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -93,7 +93,7 @@ static inline unsigned int netlink_padding_len(unsigned i=
nt size)
 }
=20
 extern void netlink_gen_data(const struct expr *expr,
-=09=09=09     struct nft_data_linearize *data);
+=09=09=09     struct nft_data_linearize *data, int is_range_end);
 extern void netlink_gen_raw_data(const mpz_t value, enum byteorder byteord=
er,
 =09=09=09=09 unsigned int len,
 =09=09=09=09 struct nft_data_linearize *data);
diff --git a/src/evaluate.c b/src/evaluate.c
index e1ecf4de..8cbb0cbe 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -136,6 +136,11 @@ static int byteorder_conversion(struct eval_ctx *ctx, =
struct expr **expr,
=20
 =09if ((*expr)->byteorder =3D=3D byteorder)
 =09=09return 0;
+
+=09/* Conversion for EXPR_CONCAT is handled for single composing ranges */
+=09if ((*expr)->etype =3D=3D EXPR_CONCAT)
+=09=09return 0;
+
 =09if (expr_basetype(*expr)->type !=3D TYPE_INTEGER)
 =09=09return expr_error(ctx->msgs, *expr,
 =09=09=09 =09  "Byteorder mismatch: expected %s, got %s",
@@ -1352,10 +1357,16 @@ static int expr_evaluate_set(struct eval_ctx *ctx, =
struct expr **expr)
 =09=09=09set->size      +=3D i->size - 1;
 =09=09=09set->set_flags |=3D i->set_flags;
 =09=09=09expr_free(i);
-=09=09} else if (!expr_is_singleton(i))
+=09=09} else if (!expr_is_singleton(i)) {
 =09=09=09set->set_flags |=3D NFT_SET_INTERVAL;
+=09=09=09if (i->key->etype =3D=3D EXPR_CONCAT)
+=09=09=09=09set->set_flags |=3D NFT_SET_SUBKEY;
+=09=09}
 =09}
=20
+=09if (ctx->set->flags & (NFT_SET_SUBKEY))
+=09=09set->set_flags |=3D NFT_SET_SUBKEY;
+
 =09set->set_flags |=3D NFT_SET_CONSTANT;
=20
 =09datatype_set(set, ctx->ectx.dtype);
diff --git a/src/netlink.c b/src/netlink.c
index 7306e358..b8bfd199 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -96,7 +96,8 @@ struct nftnl_expr *alloc_nft_expr(const char *name)
 }
=20
 static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
-=09=09=09=09=09=09  const struct expr *expr)
+=09=09=09=09=09=09  const struct expr *expr,
+=09=09=09=09=09=09  int is_range_end)
 {
 =09const struct expr *elem, *key, *data;
 =09struct nftnl_set_elem *nlse;
@@ -117,7 +118,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const=
 struct expr *set,
 =09}
 =09key =3D elem->key;
=20
-=09netlink_gen_data(key, &nld);
+=09netlink_gen_data(key, &nld, is_range_end);
 =09nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 =09if (elem->timeout)
 =09=09nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
@@ -147,7 +148,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const=
 struct expr *set,
 =09=09nftnl_udata_buf_free(udbuf);
 =09}
 =09if (set_is_datamap(set->set_flags) && data !=3D NULL) {
-=09=09netlink_gen_data(data, &nld);
+=09=09netlink_gen_data(data, &nld, 0);
 =09=09switch (data->etype) {
 =09=09case EXPR_VERDICT:
 =09=09=09nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_VERDICT,
@@ -166,12 +167,12 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(con=
st struct expr *set,
 =09=09}
 =09}
 =09if (set_is_objmap(set->set_flags) && data !=3D NULL) {
-=09=09netlink_gen_data(data, &nld);
+=09=09netlink_gen_data(data, &nld, 0);
 =09=09nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_OBJREF,
 =09=09=09=09   nld.value, nld.len);
 =09}
=20
-=09if (expr->flags & EXPR_F_INTERVAL_END)
+=09if (is_range_end || expr->flags & EXPR_F_INTERVAL_END)
 =09=09nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_FLAGS,
 =09=09=09=09       NFT_SET_ELEM_INTERVAL_END);
=20
@@ -186,8 +187,18 @@ void netlink_gen_raw_data(const mpz_t value, enum byte=
order byteorder,
 =09data->len =3D len;
 }
=20
+static int netlink_export_pad(unsigned char *data, const mpz_t v,
+=09=09=09      const struct expr *i)
+{
+=09mpz_export_data(data, v, i->byteorder,
+=09=09=09div_round_up(i->len, BITS_PER_BYTE));
+
+=09return netlink_padded_len(i->len) / BITS_PER_BYTE;
+}
+
 static void netlink_gen_concat_data(const struct expr *expr,
-=09=09=09=09    struct nft_data_linearize *nld)
+=09=09=09=09    struct nft_data_linearize *nld,
+=09=09=09=09    int is_range_end)
 {
 =09const struct expr *i;
 =09unsigned int len, offset;
@@ -199,10 +210,39 @@ static void netlink_gen_concat_data(const struct expr=
 *expr,
 =09=09memset(data, 0, sizeof(data));
 =09=09offset =3D 0;
 =09=09list_for_each_entry(i, &expr->expressions, list) {
-=09=09=09assert(i->etype =3D=3D EXPR_VALUE);
-=09=09=09mpz_export_data(data + offset, i->value, i->byteorder,
-=09=09=09=09=09div_round_up(i->len, BITS_PER_BYTE));
-=09=09=09offset +=3D netlink_padded_len(i->len) / BITS_PER_BYTE;
+=09=09=09if (i->etype =3D=3D EXPR_RANGE) {
+=09=09=09=09const struct expr *e;
+
+=09=09=09=09if (is_range_end)
+=09=09=09=09=09e =3D i->right;
+=09=09=09=09else
+=09=09=09=09=09e =3D i->left;
+
+=09=09=09=09offset +=3D netlink_export_pad(data + offset,
+=09=09=09=09=09=09=09     e->value, e);
+=09=09=09} else if (i->etype =3D=3D EXPR_PREFIX) {
+=09=09=09=09if (is_range_end) {
+=09=09=09=09=09mpz_t v;
+
+=09=09=09=09=09mpz_init_bitmask(v, i->len -
+=09=09=09=09=09=09=09    i->prefix_len);
+=09=09=09=09=09mpz_add(v, i->prefix->value, v);
+=09=09=09=09=09offset +=3D netlink_export_pad(data +
+=09=09=09=09=09=09=09=09     offset,
+=09=09=09=09=09=09=09=09     v, i);
+=09=09=09=09=09mpz_clear(v);
+=09=09=09=09=09continue;
+=09=09=09=09}
+
+=09=09=09=09offset +=3D netlink_export_pad(data + offset,
+=09=09=09=09=09=09=09     i->prefix->value,
+=09=09=09=09=09=09=09     i);
+=09=09=09} else {
+=09=09=09=09assert(i->etype =3D=3D EXPR_VALUE);
+
+=09=09=09=09offset +=3D netlink_export_pad(data + offset,
+=09=09=09=09=09=09=09     i->value, i);
+=09=09=09}
 =09=09}
=20
 =09=09memcpy(nld->value, data, len);
@@ -247,13 +287,14 @@ static void netlink_gen_verdict(const struct expr *ex=
pr,
 =09}
 }
=20
-void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *=
data)
+void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *=
data,
+=09=09      int end)
 {
 =09switch (expr->etype) {
 =09case EXPR_VALUE:
 =09=09return netlink_gen_constant_data(expr, data);
 =09case EXPR_CONCAT:
-=09=09return netlink_gen_concat_data(expr, data);
+=09=09return netlink_gen_concat_data(expr, data, end);
 =09case EXPR_VERDICT:
 =09=09return netlink_gen_verdict(expr, data);
 =09default:
@@ -712,8 +753,14 @@ void alloc_setelem_cache(const struct expr *set, struc=
t nftnl_set *nls)
 =09const struct expr *expr;
=20
 =09list_for_each_entry(expr, &set->expressions, list) {
-=09=09nlse =3D alloc_nftnl_setelem(set, expr);
+=09=09nlse =3D alloc_nftnl_setelem(set, expr, 0);
 =09=09nftnl_set_elem_add(nls, nlse);
+
+=09=09if (set->set_flags & NFT_SET_SUBKEY) {
+=09=09=09nlse =3D alloc_nftnl_setelem(set, expr, 1);
+=09=09=09nftnl_set_elem_add(nls, nlse);
+=09=09}
+
 =09}
 }
=20
@@ -907,15 +954,16 @@ int netlink_list_setelems(struct netlink_ctx *ctx, co=
nst struct handle *h,
 =09set->init =3D set_expr_alloc(&internal_location, set);
 =09nftnl_set_elem_foreach(nls, list_setelem_cb, ctx);
=20
-=09if (!(set->flags & NFT_SET_INTERVAL))
+=09if (set->flags & NFT_SET_SUBKEY)
+=09=09concat_range_aggregate(set->init);
+=09else if (set->flags & NFT_SET_INTERVAL)
+=09=09interval_map_decompose(set->init);
+=09else
 =09=09list_expr_sort(&ctx->set->init->expressions);
=20
 =09nftnl_set_free(nls);
 =09ctx->set =3D NULL;
=20
-=09if (set->flags & NFT_SET_INTERVAL)
-=09=09interval_map_decompose(set->init);
-
 =09return 0;
 }
=20
@@ -924,6 +972,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const =
struct handle *h,
 =09=09=09struct set *set, struct expr *init)
 {
 =09struct nftnl_set *nls, *nls_out =3D NULL;
+=09int err =3D 0;
=20
 =09nls =3D nftnl_set_alloc();
 =09if (nls =3D=3D NULL)
@@ -947,18 +996,18 @@ int netlink_get_setelem(struct netlink_ctx *ctx, cons=
t struct handle *h,
 =09set->init =3D set_expr_alloc(loc, set);
 =09nftnl_set_elem_foreach(nls_out, list_setelem_cb, ctx);
=20
-=09if (!(set->flags & NFT_SET_INTERVAL))
+=09if (set->flags & NFT_SET_SUBKEY)
+=09=09concat_range_aggregate(set->init);
+=09else if (set->flags & NFT_SET_INTERVAL)
+=09=09err =3D get_set_decompose(table, set);
+=09else
 =09=09list_expr_sort(&ctx->set->init->expressions);
=20
 =09nftnl_set_free(nls);
 =09nftnl_set_free(nls_out);
 =09ctx->set =3D NULL;
=20
-=09if (set->flags & NFT_SET_INTERVAL &&
-=09    get_set_decompose(table, set) < 0)
-=09=09return -1;
-
-=09return 0;
+=09return err;
 }
=20
 void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 498326d0..ef696336 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -393,10 +393,10 @@ static void netlink_gen_range(struct netlink_lineariz=
e_ctx *ctx,
 =09=09nle =3D alloc_nft_expr("range");
 =09=09netlink_put_register(nle, NFTNL_EXPR_RANGE_SREG, sreg);
 =09=09nftnl_expr_set_u32(nle, NFTNL_EXPR_RANGE_OP, NFT_RANGE_NEQ);
-=09=09netlink_gen_data(range->left, &nld);
+=09=09netlink_gen_data(range->left, &nld, 0);
 =09=09nftnl_expr_set(nle, NFTNL_EXPR_RANGE_FROM_DATA,
 =09=09=09       nld.value, nld.len);
-=09=09netlink_gen_data(range->right, &nld);
+=09=09netlink_gen_data(range->right, &nld, 0);
 =09=09nftnl_expr_set(nle, NFTNL_EXPR_RANGE_TO_DATA,
 =09=09=09       nld.value, nld.len);
 =09=09nftnl_rule_add_expr(ctx->nlr, nle);
@@ -407,7 +407,7 @@ static void netlink_gen_range(struct netlink_linearize_=
ctx *ctx,
 =09=09netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 =09=09nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 =09=09=09=09   netlink_gen_cmp_op(OP_GTE));
-=09=09netlink_gen_data(range->left, &nld);
+=09=09netlink_gen_data(range->left, &nld, 0);
 =09=09nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
 =09=09nftnl_rule_add_expr(ctx->nlr, nle);
=20
@@ -415,7 +415,7 @@ static void netlink_gen_range(struct netlink_linearize_=
ctx *ctx,
 =09=09netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 =09=09nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 =09=09=09=09   netlink_gen_cmp_op(OP_LTE));
-=09=09netlink_gen_data(range->right, &nld);
+=09=09netlink_gen_data(range->right, &nld, 0);
 =09=09nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
 =09=09nftnl_rule_add_expr(ctx->nlr, nle);
 =09=09break;
@@ -446,7 +446,7 @@ static void netlink_gen_flagcmp(struct netlink_lineariz=
e_ctx *ctx,
 =09mpz_init_set_ui(zero, 0);
=20
 =09netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
-=09netlink_gen_data(expr->right, &nld2);
+=09netlink_gen_data(expr->right, &nld2, 0);
=20
 =09nle =3D alloc_nft_expr("bitwise");
 =09netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
@@ -529,7 +529,7 @@ static void netlink_gen_relational(struct netlink_linea=
rize_ctx *ctx,
 =09netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 =09nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 =09=09=09   netlink_gen_cmp_op(expr->op));
-=09netlink_gen_data(right, &nld);
+=09netlink_gen_data(right, &nld, 0);
 =09nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
 =09release_register(ctx, expr->left);
=20
@@ -662,7 +662,7 @@ static void netlink_gen_immediate(struct netlink_linear=
ize_ctx *ctx,
=20
 =09nle =3D alloc_nft_expr("immediate");
 =09netlink_put_register(nle, NFTNL_EXPR_IMM_DREG, dreg);
-=09netlink_gen_data(expr, &nld);
+=09netlink_gen_data(expr, &nld, 0);
 =09switch (expr->etype) {
 =09case EXPR_VALUE:
 =09=09nftnl_expr_set(nle, NFTNL_EXPR_IMM_DATA, nld.value, nld.len);
@@ -766,7 +766,7 @@ static void netlink_gen_objref_stmt(struct netlink_line=
arize_ctx *ctx,
 =09=09=09=09   expr->mappings->set->handle.set_id);
 =09=09break;
 =09case EXPR_VALUE:
-=09=09netlink_gen_data(stmt->objref.expr, &nld);
+=09=09netlink_gen_data(stmt->objref.expr, &nld, 0);
 =09=09nftnl_expr_set(nle, NFTNL_EXPR_OBJREF_IMM_NAME,
 =09=09=09       nld.value, nld.len);
 =09=09nftnl_expr_set_u32(nle, NFTNL_EXPR_OBJREF_IMM_TYPE,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3f283256..2b718971 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3554,7 +3554,6 @@ range_rhs_expr=09=09:=09basic_rhs_expr=09DASH=09basic=
_rhs_expr
=20
 multiton_rhs_expr=09:=09prefix_rhs_expr
 =09=09=09|=09range_rhs_expr
-=09=09=09|=09wildcard_expr
 =09=09=09;
=20
 map_expr=09=09:=09concat_expr=09MAP=09rhs_expr
@@ -3648,7 +3647,7 @@ set_elem_option=09=09:=09TIMEOUT=09=09=09time_spec
 =09=09=09;
=20
 set_lhs_expr=09=09:=09concat_rhs_expr
-=09=09=09|=09multiton_rhs_expr
+=09=09=09|=09wildcard_expr
 =09=09=09;
=20
 set_rhs_expr=09=09:=09concat_rhs_expr
@@ -3901,7 +3900,7 @@ list_rhs_expr=09=09:=09basic_rhs_expr=09=09COMMA=09=
=09basic_rhs_expr
 =09=09=09;
=20
 rhs_expr=09=09:=09concat_rhs_expr=09=09{ $$ =3D $1; }
-=09=09=09|=09multiton_rhs_expr=09{ $$ =3D $1; }
+=09=09=09|=09wildcard_expr=09=09{ $$ =3D $1; }
 =09=09=09|=09set_expr=09=09{ $$ =3D $1; }
 =09=09=09;
=20
@@ -3941,7 +3940,24 @@ basic_rhs_expr=09=09:=09inclusive_or_rhs_expr
 =09=09=09;
=20
 concat_rhs_expr=09=09:=09basic_rhs_expr
-=09=09=09|=09concat_rhs_expr=09DOT=09basic_rhs_expr
+=09=09=09|=09multiton_rhs_expr
+=09=09=09|=09concat_rhs_expr=09=09DOT=09multiton_rhs_expr
+=09=09=09{
+=09=09=09=09if ($$->etype !=3D EXPR_CONCAT) {
+=09=09=09=09=09$$ =3D concat_expr_alloc(&@$);
+=09=09=09=09=09compound_expr_add($$, $1);
+=09=09=09=09} else {
+=09=09=09=09=09struct location rhs[] =3D {
+=09=09=09=09=09=09[1]=09=3D @2,
+=09=09=09=09=09=09[2]=09=3D @3,
+=09=09=09=09=09};
+=09=09=09=09=09location_update(&$3->location, rhs, 2);
+=09=09=09=09=09$$ =3D $1;
+=09=09=09=09=09$$->location =3D @$;
+=09=09=09=09}
+=09=09=09=09compound_expr_add($$, $3);
+=09=09=09}
+=09=09=09|=09concat_rhs_expr=09=09DOT=09basic_rhs_expr
 =09=09=09{
 =09=09=09=09if ($$->etype !=3D EXPR_CONCAT) {
 =09=09=09=09=09$$ =3D concat_expr_alloc(&@$);
@@ -3952,7 +3968,6 @@ concat_rhs_expr=09=09:=09basic_rhs_expr
 =09=09=09=09=09=09[2]=09=3D @3,
 =09=09=09=09=09};
 =09=09=09=09=09location_update(&$3->location, rhs, 2);
-
 =09=09=09=09=09$$ =3D $1;
 =09=09=09=09=09$$->location =3D @$;
 =09=09=09=09}
diff --git a/src/rule.c b/src/rule.c
index 4abc13c9..377781b1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1526,6 +1526,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, s=
truct cmd *cmd,
 =09set =3D set_lookup(table, h->set.name);
=20
 =09if (set->flags & NFT_SET_INTERVAL &&
+=09    !(set->flags & NFT_SET_SUBKEY) &&
 =09    set_to_intervals(ctx->msgs, set, init, true,
 =09=09=09     ctx->nft->debug_mask, set->automerge,
 =09=09=09     &ctx->nft->output) < 0)
@@ -1541,6 +1542,7 @@ static int do_add_set(struct netlink_ctx *ctx, const =
struct cmd *cmd,
=20
 =09if (set->init !=3D NULL) {
 =09=09if (set->flags & NFT_SET_INTERVAL &&
+=09=09    !(set->flags & NFT_SET_SUBKEY) &&
 =09=09    set_to_intervals(ctx->msgs, set, set->init, true,
 =09=09=09=09     ctx->nft->debug_mask, set->automerge,
 =09=09=09=09     &ctx->nft->output) < 0)
@@ -1618,15 +1620,15 @@ static int do_command_insert(struct netlink_ctx *ct=
x, struct cmd *cmd)
=20
 static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-=09struct handle *h =3D &cmd->handle;
 =09struct expr *expr =3D cmd->expr;
+=09struct handle *h =3D &cmd->handle;
 =09struct table *table;
 =09struct set *set;
=20
 =09table =3D table_lookup(h, &ctx->nft->cache);
 =09set =3D set_lookup(table, h->set.name);
=20
-=09if (set->flags & NFT_SET_INTERVAL &&
+=09if (set->flags & NFT_SET_INTERVAL && !(set->flags & NFT_SET_SUBKEY) &&
 =09    set_to_intervals(ctx->msgs, set, expr, false,
 =09=09=09     ctx->nft->debug_mask, set->automerge,
 =09=09=09     &ctx->nft->output) < 0)
@@ -2480,7 +2482,7 @@ static int do_get_setelems(struct netlink_ctx *ctx, s=
truct cmd *cmd,
 =09set =3D set_lookup(table, cmd->handle.set.name);
=20
 =09/* Create a list of elements based of what we got from command line. */
-=09if (set->flags & NFT_SET_INTERVAL)
+=09if (set->flags & NFT_SET_INTERVAL && !(set->flags & NFT_SET_SUBKEY))
 =09=09init =3D get_set_intervals(set, cmd->expr);
 =09else
 =09=09init =3D cmd->expr;
@@ -2493,7 +2495,7 @@ static int do_get_setelems(struct netlink_ctx *ctx, s=
truct cmd *cmd,
 =09if (err >=3D 0)
 =09=09__do_list_set(ctx, cmd, table, new_set);
=20
-=09if (set->flags & NFT_SET_INTERVAL)
+=09if (set->flags & NFT_SET_INTERVAL && !(set->flags & NFT_SET_SUBKEY))
 =09=09expr_free(init);
=20
 =09set_free(new_set);
diff --git a/src/segtree.c b/src/segtree.c
index 9f1eecc0..e49576bc 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -652,6 +652,11 @@ struct expr *get_set_intervals(const struct set *set, =
const struct expr *init)
 =09=09=09set_elem_add(set, new_init, i->key->value,
 =09=09=09=09     i->flags, i->byteorder);
 =09=09=09break;
+=09=09case EXPR_CONCAT:
+=09=09=09compound_expr_add(new_init, expr_clone(i));
+=09=09=09i->flags |=3D EXPR_F_INTERVAL_END;
+=09=09=09compound_expr_add(new_init, expr_clone(i));
+=09=09=09break;
 =09=09default:
 =09=09=09range_expr_value_low(low, i);
 =09=09=09set_elem_add(set, new_init, low, 0, i->byteorder);
@@ -823,6 +828,9 @@ static int expr_value_cmp(const void *p1, const void *p=
2)
 =09struct expr *e2 =3D *(void * const *)p2;
 =09int ret;
=20
+=09if (expr_value(e1)->etype =3D=3D EXPR_CONCAT)
+=09=09return -1;
+
 =09ret =3D mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
 =09if (ret =3D=3D 0) {
 =09=09if (e1->flags & EXPR_F_INTERVAL_END)
@@ -834,6 +842,132 @@ static int expr_value_cmp(const void *p1, const void =
*p2)
 =09return ret;
 }
=20
+/* Given start and end elements of a range, check if it can be represented=
 as
+ * a single netmask, and if so, how long, by returning a zero or positive =
value.
+ */
+static int range_mask_len(mpz_t start, mpz_t end, unsigned int len)
+{
+=09unsigned int step =3D 0, i;
+=09mpz_t base, tmp;
+=09int masks =3D 0;
+
+=09mpz_init_set_ui(base, mpz_get_ui(start));
+
+=09while (mpz_cmp(base, end) <=3D 0) {
+=09=09step =3D 0;
+=09=09while (!mpz_tstbit(base, step)) {
+=09=09=09mpz_init_set_ui(tmp, mpz_get_ui(base));
+=09=09=09for (i =3D 0; i <=3D step; i++)
+=09=09=09=09mpz_setbit(tmp, i);
+=09=09=09if (mpz_cmp(tmp, end) > 0) {
+=09=09=09=09mpz_clear(tmp);
+=09=09=09=09break;
+=09=09=09}
+=09=09=09mpz_clear(tmp);
+
+=09=09=09step++;
+
+=09=09=09if (step >=3D len)
+=09=09=09=09goto out;
+=09=09}
+
+=09=09if (masks++)
+=09=09=09goto out;
+
+=09=09mpz_add_ui(base, base, 1 << step);
+=09}
+
+out:
+=09mpz_clear(base);
+
+=09if (masks > 1)
+=09=09return -1;
+=09return len - step;
+}
+
+/* Given a set with two elements (start and end), transform them into a
+ * concatenation of ranges. That is, from a list of start expressions and =
a list
+ * of end expressions, form a list of start - end expressions.
+ */
+void concat_range_aggregate(struct expr *set)
+{
+=09struct expr *i, *start =3D NULL, *end, *r1, *r2, *next, *r1_next, *tmp;
+=09struct list_head *r2_next;
+=09int prefix_len, free_r1;
+=09mpz_t range, p;
+
+=09list_for_each_entry_safe(i, next, &set->expressions, list) {
+=09=09if (!start) {
+=09=09=09start =3D i;
+=09=09=09continue;
+=09=09}
+=09=09end =3D i;
+
+=09=09/* Walk over r1 (start expression) and r2 (end) in parallel,
+=09=09 * form ranges between corresponding r1 and r2 expressions,
+=09=09 * store them by replacing r2 expressions, and free r1
+=09=09 * expressions.
+=09=09 */
+=09=09r2 =3D list_first_entry(&expr_value(end)->expressions,
+=09=09=09=09      struct expr, list);
+=09=09list_for_each_entry_safe(r1, r1_next,
+=09=09=09=09=09 &expr_value(start)->expressions,
+=09=09=09=09=09 list) {
+=09=09=09mpz_init(range);
+=09=09=09mpz_init(p);
+
+=09=09=09r2_next =3D r2->list.next;
+=09=09=09free_r1 =3D 0;
+
+=09=09=09if (!mpz_cmp(r1->value, r2->value)) {
+=09=09=09=09free_r1 =3D 1;
+=09=09=09=09goto next;
+=09=09=09}
+
+=09=09=09mpz_sub(range, r2->value, r1->value);
+=09=09=09mpz_sub_ui(range, range, 1);
+=09=09=09mpz_and(p, r1->value, range);
+
+=09=09=09/* Check if we are forced, or if it's anyway preferable,
+=09=09=09 * to express the range as two points instead of a
+=09=09=09 * netmask.
+=09=09=09 */
+=09=09=09prefix_len =3D range_mask_len(r1->value, r2->value,
+=09=09=09=09=09=09    r1->len);
+=09=09=09if (prefix_len < 0 ||
+=09=09=09    !(r1->dtype->flags & DTYPE_F_PREFIX)) {
+=09=09=09=09tmp =3D range_expr_alloc(&r1->location, r1,
+=09=09=09=09=09=09       r2);
+
+=09=09=09=09list_replace(&r2->list, &tmp->list);
+=09=09=09=09r2_next =3D tmp->list.next;
+=09=09=09} else {
+=09=09=09=09tmp =3D prefix_expr_alloc(&r1->location, r1,
+=09=09=09=09=09=09=09prefix_len);
+=09=09=09=09tmp->len =3D r2->len;
+
+=09=09=09=09list_replace(&r2->list, &tmp->list);
+=09=09=09=09r2_next =3D tmp->list.next;
+=09=09=09=09expr_free(r2);
+=09=09=09}
+
+next:
+=09=09=09mpz_clear(p);
+=09=09=09mpz_clear(range);
+
+=09=09=09r2 =3D list_entry(r2_next, typeof(*r2), list);
+=09=09=09compound_expr_remove(start, r1);
+
+=09=09=09if (free_r1)
+=09=09=09=09expr_free(r1);
+=09=09}
+
+=09=09compound_expr_remove(set, start);
+=09=09expr_free(start);
+=09=09start =3D NULL;
+=09}
+}
+
 void interval_map_decompose(struct expr *set)
 {
 =09struct expr **elements, **ranges;
--=20
2.23.0

