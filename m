Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716C1C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BD9F206CC
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ye5bnsbI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKURKX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:10:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43569 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726568AbfKURKW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574356220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3MlCslU468/Lby1l60A1ytATSDiuL8fVbWKYut/Q9Qk=;
        b=Ye5bnsbIMR8fVmjuL0hWLDzapIMUHvs+1XKpwep5NPcM9xCdFdPUy/YUALjj16/4Qz6GQk
        atT3wCX5/LOqHV5fIuVaj4YKCJQMuJuTOF+kfECA22JgtFKKH2JGP37Vunb2sdL/Pu/EdT
        QA4XvyjBJnrC1+A1IIQF8SIYF1Z5z88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-F9Bvz6YuMkyttBmqoscfKw-1; Thu, 21 Nov 2019 12:10:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCC748018A2;
        Thu, 21 Nov 2019 17:10:15 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 921696E3F9;
        Thu, 21 Nov 2019 17:10:13 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2 2/3] src: Add support for concatenated set ranges
Date:   Thu, 21 Nov 2019 18:10:05 +0100
Message-Id: <b944a7e42584df97bbded82118995a2505a469d9.1574353687.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574353687.git.sbrivio@redhat.com>
References: <cover.1574353687.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: F9Bvz6YuMkyttBmqoscfKw-1
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
 include/rule.h       |   6 +++
 src/evaluate.c       |  13 ++++-
 src/netlink.c        |  99 +++++++++++++++++++++++++-----------
 src/parser_bison.y   |  89 +++++++++++---------------------
 src/rule.c           |  10 ++--
 src/segtree.c        | 117 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 241 insertions(+), 94 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index b6d5adb2d981..3d97fa18f031 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -459,6 +459,7 @@ extern int set_to_intervals(struct list_head *msgs, str=
uct set *set,
 =09=09=09    struct expr *init, bool add,
 =09=09=09    unsigned int debug_mask, bool merge,
 =09=09=09    struct output_ctx *octx);
+extern void concat_range_aggregate(struct expr *set);
 extern void interval_map_decompose(struct expr *set);
=20
 extern struct expr *get_set_intervals(const struct set *set,
diff --git a/include/rule.h b/include/rule.h
index a263947da8fd..e99a427d9ba6 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -364,6 +364,12 @@ static inline bool set_is_meter(uint32_t set_flags)
 =09return set_is_anonymous(set_flags) && (set_flags & NFT_SET_EVAL);
 }
=20
+static inline bool set_is_non_concat_range(uint32_t set_flags)
+{
+=09return (set_flags &
+=09=09(NFT_SET_INTERVAL | NFT_SET_SUBKEY)) =3D=3D NFT_SET_INTERVAL;
+}
+
 #include <statement.h>
=20
 struct counter {
diff --git a/src/evaluate.c b/src/evaluate.c
index e1ecf4de243a..b6ba1bf02e52 100644
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
+=09if (ctx->set && ctx->set->flags & (NFT_SET_SUBKEY))
+=09=09set->set_flags |=3D NFT_SET_SUBKEY;
+
 =09set->set_flags |=3D NFT_SET_CONSTANT;
=20
 =09datatype_set(set, ctx->ectx.dtype);
diff --git a/src/netlink.c b/src/netlink.c
index 7306e358ca39..fc24161c30ce 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -171,7 +171,8 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const=
 struct expr *set,
 =09=09=09=09   nld.value, nld.len);
 =09}
=20
-=09if (expr->flags & EXPR_F_INTERVAL_END)
+=09if (expr->flags & EXPR_F_INTERVAL_END ||
+=09    key->flags & EXPR_F_INTERVAL_END)
 =09=09nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_FLAGS,
 =09=09=09=09       NFT_SET_ELEM_INTERVAL_END);
=20
@@ -186,28 +187,58 @@ void netlink_gen_raw_data(const mpz_t value, enum byt=
eorder byteorder,
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
+static int netlink_gen_concat_data_expr(int end, const struct expr *i,
+=09=09=09=09=09unsigned char *data)
+{
+=09switch (i->etype) {
+=09case EXPR_RANGE:
+=09=09i =3D end ? i->right : i->left;
+=09=09break;
+=09case EXPR_PREFIX:
+=09=09if (end) {
+=09=09=09int count;
+=09=09=09mpz_t v;
+
+=09=09=09mpz_init_bitmask(v, i->len - i->prefix_len);
+=09=09=09mpz_add(v, i->prefix->value, v);
+=09=09=09count =3D netlink_export_pad(data, v, i);
+=09=09=09mpz_clear(v);
+=09=09=09return count;
+=09=09}
+=09=09return netlink_export_pad(data, i->prefix->value, i);
+=09case EXPR_VALUE:
+=09=09break;
+=09default:
+=09=09BUG("invalid expression type '%s' in set", expr_ops(i)->name);
+=09}
+
+=09return netlink_export_pad(data, i->value, i);
+}
+
 static void netlink_gen_concat_data(const struct expr *expr,
 =09=09=09=09    struct nft_data_linearize *nld)
 {
+=09unsigned int len =3D expr->len / BITS_PER_BYTE, offset =3D 0;
+=09int end =3D expr->flags & EXPR_F_INTERVAL_END;
+=09unsigned char data[len];
 =09const struct expr *i;
-=09unsigned int len, offset;
-
-=09len =3D expr->len / BITS_PER_BYTE;
-=09if (1) {
-=09=09unsigned char data[len];
-
-=09=09memset(data, 0, sizeof(data));
-=09=09offset =3D 0;
-=09=09list_for_each_entry(i, &expr->expressions, list) {
-=09=09=09assert(i->etype =3D=3D EXPR_VALUE);
-=09=09=09mpz_export_data(data + offset, i->value, i->byteorder,
-=09=09=09=09=09div_round_up(i->len, BITS_PER_BYTE));
-=09=09=09offset +=3D netlink_padded_len(i->len) / BITS_PER_BYTE;
-=09=09}
=20
-=09=09memcpy(nld->value, data, len);
-=09=09nld->len =3D len;
-=09}
+=09memset(data, 0, len);
+
+=09list_for_each_entry(i, &expr->expressions, list)
+=09=09offset +=3D netlink_gen_concat_data_expr(end, i, data + offset);
+
+=09memcpy(nld->value, data, len);
+=09nld->len =3D len;
 }
=20
 static void netlink_gen_constant_data(const struct expr *expr,
@@ -714,6 +745,16 @@ void alloc_setelem_cache(const struct expr *set, struc=
t nftnl_set *nls)
 =09list_for_each_entry(expr, &set->expressions, list) {
 =09=09nlse =3D alloc_nftnl_setelem(set, expr);
 =09=09nftnl_set_elem_add(nls, nlse);
+
+=09=09if (set->set_flags & NFT_SET_SUBKEY) {
+=09=09=09expr->key->flags |=3D EXPR_F_INTERVAL_END;
+
+=09=09=09nlse =3D alloc_nftnl_setelem(set, expr);
+=09=09=09nftnl_set_elem_add(nls, nlse);
+
+=09=09=09expr->key->flags &=3D ~EXPR_F_INTERVAL_END;
+=09=09}
+
 =09}
 }
=20
@@ -907,15 +948,16 @@ int netlink_list_setelems(struct netlink_ctx *ctx, co=
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
@@ -924,6 +966,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const =
struct handle *h,
 =09=09=09struct set *set, struct expr *init)
 {
 =09struct nftnl_set *nls, *nls_out =3D NULL;
+=09int err =3D 0;
=20
 =09nls =3D nftnl_set_alloc();
 =09if (nls =3D=3D NULL)
@@ -947,18 +990,18 @@ int netlink_get_setelem(struct netlink_ctx *ctx, cons=
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
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 631b7d684555..243a217e050a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -102,6 +102,23 @@ static void location_update(struct location *loc, stru=
ct location *rhs, int n)
 =09}
 }
=20
+struct expr *compound_expr_alloc_or_add(struct location *loc,
+=09=09=09=09=09struct expr *compound,
+=09=09=09=09=09struct expr *left, struct expr *right)
+{
+=09if (compound->etype !=3D EXPR_CONCAT) {
+=09=09compound =3D concat_expr_alloc(loc);
+=09=09compound_expr_add(compound, left);
+=09} else {
+=09=09location_update(&right->location, loc + 1, 2);
+=09=09compound =3D left;
+=09=09compound->location =3D *loc;
+=09}
+=09compound_expr_add(compound, right);
+
+=09return compound;
+}
+
 #define YYLLOC_DEFAULT(Current, Rhs, N)=09location_update(&Current, Rhs, N=
)
=20
 #define symbol_value(loc, str) \
@@ -1878,20 +1895,7 @@ data_type_atom_expr=09:=09type_identifier
 data_type_expr=09=09:=09data_type_atom_expr
 =09=09=09|=09data_type_expr=09DOT=09data_type_atom_expr
 =09=09=09{
-=09=09=09=09if ($1->etype !=3D EXPR_CONCAT) {
-=09=09=09=09=09$$ =3D concat_expr_alloc(&@$);
-=09=09=09=09=09compound_expr_add($$, $1);
-=09=09=09=09} else {
-=09=09=09=09=09struct location rhs[] =3D {
-=09=09=09=09=09=09[1]=09=3D @2,
-=09=09=09=09=09=09[2]=09=3D @3,
-=09=09=09=09=09};
-=09=09=09=09=09location_update(&$3->location, rhs, 2);
-
-=09=09=09=09=09$$ =3D $1;
-=09=09=09=09=09$$->location =3D @$;
-=09=09=09=09}
-=09=09=09=09compound_expr_add($$, $3);
+=09=09=09=09$$ =3D compound_expr_alloc_or_add(&@$, $$, $1, $3);
 =09=09=09}
 =09=09=09;
=20
@@ -2992,20 +2996,7 @@ basic_stmt_expr=09=09:=09inclusive_or_stmt_expr
 concat_stmt_expr=09:=09basic_stmt_expr
 =09=09=09|=09concat_stmt_expr=09DOT=09primary_stmt_expr
 =09=09=09{
-=09=09=09=09if ($$->etype !=3D EXPR_CONCAT) {
-=09=09=09=09=09$$ =3D concat_expr_alloc(&@$);
-=09=09=09=09=09compound_expr_add($$, $1);
-=09=09=09=09} else {
-=09=09=09=09=09struct location rhs[] =3D {
-=09=09=09=09=09=09[1]=09=3D @2,
-=09=09=09=09=09=09[2]=09=3D @3,
-=09=09=09=09=09};
-=09=09=09=09=09location_update(&$3->location, rhs, 2);
-
-=09=09=09=09=09$$ =3D $1;
-=09=09=09=09=09$$->location =3D @$;
-=09=09=09=09}
-=09=09=09=09compound_expr_add($$, $3);
+=09=09=09=09$$ =3D compound_expr_alloc_or_add(&@$, $$, $1, $3);
 =09=09=09}
 =09=09=09;
=20
@@ -3525,20 +3516,7 @@ basic_expr=09=09:=09inclusive_or_expr
 concat_expr=09=09:=09basic_expr
 =09=09=09|=09concat_expr=09=09DOT=09=09basic_expr
 =09=09=09{
-=09=09=09=09if ($$->etype !=3D EXPR_CONCAT) {
-=09=09=09=09=09$$ =3D concat_expr_alloc(&@$);
-=09=09=09=09=09compound_expr_add($$, $1);
-=09=09=09=09} else {
-=09=09=09=09=09struct location rhs[] =3D {
-=09=09=09=09=09=09[1]=09=3D @2,
-=09=09=09=09=09=09[2]=09=3D @3,
-=09=09=09=09=09};
-=09=09=09=09=09location_update(&$3->location, rhs, 2);
-
-=09=09=09=09=09$$ =3D $1;
-=09=09=09=09=09$$->location =3D @$;
-=09=09=09=09}
-=09=09=09=09compound_expr_add($$, $3);
+=09=09=09=09$$ =3D compound_expr_alloc_or_add(&@$, $$, $1, $3);
 =09=09=09}
 =09=09=09;
=20
@@ -3556,7 +3534,6 @@ range_rhs_expr=09=09:=09basic_rhs_expr=09DASH=09basic=
_rhs_expr
=20
 multiton_rhs_expr=09:=09prefix_rhs_expr
 =09=09=09|=09range_rhs_expr
-=09=09=09|=09wildcard_expr
 =09=09=09;
=20
 map_expr=09=09:=09concat_expr=09MAP=09rhs_expr
@@ -3650,7 +3627,7 @@ set_elem_option=09=09:=09TIMEOUT=09=09=09time_spec
 =09=09=09;
=20
 set_lhs_expr=09=09:=09concat_rhs_expr
-=09=09=09|=09multiton_rhs_expr
+=09=09=09|=09wildcard_expr
 =09=09=09;
=20
 set_rhs_expr=09=09:=09concat_rhs_expr
@@ -3903,7 +3880,7 @@ list_rhs_expr=09=09:=09basic_rhs_expr=09=09COMMA=09=
=09basic_rhs_expr
 =09=09=09;
=20
 rhs_expr=09=09:=09concat_rhs_expr=09=09{ $$ =3D $1; }
-=09=09=09|=09multiton_rhs_expr=09{ $$ =3D $1; }
+=09=09=09|=09wildcard_expr=09=09{ $$ =3D $1; }
 =09=09=09|=09set_expr=09=09{ $$ =3D $1; }
 =09=09=09|=09set_ref_symbol_expr=09{ $$ =3D $1; }
 =09=09=09;
@@ -3944,22 +3921,14 @@ basic_rhs_expr=09=09:=09inclusive_or_rhs_expr
 =09=09=09;
=20
 concat_rhs_expr=09=09:=09basic_rhs_expr
-=09=09=09|=09concat_rhs_expr=09DOT=09basic_rhs_expr
+=09=09=09|=09multiton_rhs_expr
+=09=09=09|=09concat_rhs_expr=09=09DOT=09multiton_rhs_expr
 =09=09=09{
-=09=09=09=09if ($$->etype !=3D EXPR_CONCAT) {
-=09=09=09=09=09$$ =3D concat_expr_alloc(&@$);
-=09=09=09=09=09compound_expr_add($$, $1);
-=09=09=09=09} else {
-=09=09=09=09=09struct location rhs[] =3D {
-=09=09=09=09=09=09[1]=09=3D @2,
-=09=09=09=09=09=09[2]=09=3D @3,
-=09=09=09=09=09};
-=09=09=09=09=09location_update(&$3->location, rhs, 2);
-
-=09=09=09=09=09$$ =3D $1;
-=09=09=09=09=09$$->location =3D @$;
-=09=09=09=09}
-=09=09=09=09compound_expr_add($$, $3);
+=09=09=09=09$$ =3D compound_expr_alloc_or_add(&@$, $$, $1, $3);
+=09=09=09}
+=09=09=09|=09concat_rhs_expr=09=09DOT=09basic_rhs_expr
+=09=09=09{
+=09=09=09=09$$ =3D compound_expr_alloc_or_add(&@$, $$, $1, $3);
 =09=09=09}
 =09=09=09;
=20
diff --git a/src/rule.c b/src/rule.c
index 4abc13c993b8..d206aae08598 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1525,7 +1525,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, s=
truct cmd *cmd,
 =09table =3D table_lookup(h, &ctx->nft->cache);
 =09set =3D set_lookup(table, h->set.name);
=20
-=09if (set->flags & NFT_SET_INTERVAL &&
+=09if (set_is_non_concat_range(set->flags) &&
 =09    set_to_intervals(ctx->msgs, set, init, true,
 =09=09=09     ctx->nft->debug_mask, set->automerge,
 =09=09=09     &ctx->nft->output) < 0)
@@ -1540,7 +1540,7 @@ static int do_add_set(struct netlink_ctx *ctx, const =
struct cmd *cmd,
 =09struct set *set =3D cmd->set;
=20
 =09if (set->init !=3D NULL) {
-=09=09if (set->flags & NFT_SET_INTERVAL &&
+=09=09if (set_is_non_concat_range(set->flags) &&
 =09=09    set_to_intervals(ctx->msgs, set, set->init, true,
 =09=09=09=09     ctx->nft->debug_mask, set->automerge,
 =09=09=09=09     &ctx->nft->output) < 0)
@@ -1626,7 +1626,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx=
, struct cmd *cmd)
 =09table =3D table_lookup(h, &ctx->nft->cache);
 =09set =3D set_lookup(table, h->set.name);
=20
-=09if (set->flags & NFT_SET_INTERVAL &&
+=09if (set_is_non_concat_range(set->flags) &&
 =09    set_to_intervals(ctx->msgs, set, expr, false,
 =09=09=09     ctx->nft->debug_mask, set->automerge,
 =09=09=09     &ctx->nft->output) < 0)
@@ -2480,7 +2480,7 @@ static int do_get_setelems(struct netlink_ctx *ctx, s=
truct cmd *cmd,
 =09set =3D set_lookup(table, cmd->handle.set.name);
=20
 =09/* Create a list of elements based of what we got from command line. */
-=09if (set->flags & NFT_SET_INTERVAL)
+=09if (set_is_non_concat_range(set->flags))
 =09=09init =3D get_set_intervals(set, cmd->expr);
 =09else
 =09=09init =3D cmd->expr;
@@ -2493,7 +2493,7 @@ static int do_get_setelems(struct netlink_ctx *ctx, s=
truct cmd *cmd,
 =09if (err >=3D 0)
 =09=09__do_list_set(ctx, cmd, table, new_set);
=20
-=09if (set->flags & NFT_SET_INTERVAL)
+=09if (set_is_non_concat_range(set->flags))
 =09=09expr_free(init);
=20
 =09set_free(new_set);
diff --git a/src/segtree.c b/src/segtree.c
index 9f1eecc0ae7e..efa8ec9f0b5a 100644
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
@@ -834,6 +842,115 @@ static int expr_value_cmp(const void *p1, const void =
*p2)
 =09return ret;
 }
=20
+/* Given start and end elements of a range, check if it can be represented=
 as
+ * a single netmask, and if so, how long, by returning zero or a positive =
value.
+ */
+static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int=
 len)
+{
+=09mpz_t tmp_start, tmp_end;
+=09int ret;
+
+=09mpz_init_set_ui(tmp_start, mpz_get_ui(start));
+=09mpz_init_set_ui(tmp_end, mpz_get_ui(end));
+
+=09while (mpz_cmp(tmp_start, tmp_end) <=3D 0 &&
+=09=09!mpz_tstbit(tmp_start, 0) && mpz_tstbit(tmp_end, 0) &&
+=09=09len--) {
+=09=09mpz_fdiv_q_2exp(tmp_start, tmp_start, 1);
+=09=09mpz_fdiv_q_2exp(tmp_end, tmp_end, 1);
+=09}
+
+=09ret =3D !mpz_cmp(tmp_start, tmp_end) ? (int)len : -1;
+
+=09mpz_clear(tmp_start);
+=09mpz_clear(tmp_end);
+
+=09return ret;
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
2.20.1

