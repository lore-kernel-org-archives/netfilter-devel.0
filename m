Return-Path: <SRS0=4Kr+=Y2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,HK_RANDOM_REPLYTO,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8742CA9ECF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 02:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 257CD208E3
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 02:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Yj/+nuK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfKBCdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 22:33:50 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:49933 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfKBCdu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 22:33:50 -0400
Date:   Sat, 02 Nov 2019 02:33:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1572662025;
        bh=zP1Zeo8RdNvNh1w9OBNAUsDZSr4WnldAb1BStAtvB68=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=Yj/+nuK5ToTnJCluSfD+OWnTnm7wb96thasLJUx6ofLOQAC3lSrOi5nOinTG2eciz
         ZphEZvalJ38DURpGSmW/j8agA4kLoswRlYqBNjIdynNUTLvy84cTZeS1984Av3Krcx
         51lgvArUheeGI9CJK+nH84jVakABpAZLPgPXzJZQ=
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: "Sets" element cannot update "struct proto_ctx"
Message-ID: <qUQjvTtf9MX8t_J5dBPxzNIQqO46Jr-Z6xi1-mh1YCLr32Y-NWblcJQWmiprYNoIhwKgqxUW8XxybTTM-o5oLFNdk42DoHYjQq1yOTrmIS8=@protonmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recently I was trying to set up tproxy, I need to transparently proxy TCP a=
nd UDP at the same time, naturally I would think of using the following com=
mand.

nft add rule inet myproxy prerouting iif wlan0 meta pkttype unicast meta l4=
proto {tcp,udp} tproxy to :5555 meta mark set 1 accept

Error: Transparent proxy support requires transport protocol match
add rule inet myproxy prerouting iif wlan0 meta pkttype unicast meta l4prot=
o {tcp,udp} tproxy to :5555 meta mark set 1 accept
                                                                           =
         ^^^^^^^^^^^^^^^
This command is wrong.

But the strange thing is if I use the following command

nft add rule inet myproxy prerouting iif wlan0 meta pkttype unicast meta l4=
proto tcp tproxy to :5555 meta mark set 1 accept

There is no problem, "tproxy" seems to conflict with "Sets".

In order to find the root cause, I can only start analyzing the source code=
 of nft.

static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
{
...
=09if (ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR].desc =3D=3D NULL)
=09=09return stmt_error(ctx, stmt, "Transparent proxy support requires"
=09=09=09=09=09     " transport protocol match");
...
}

Eventually I found the above code, the error condition is that protocol[PRO=
TO_BASE_TRANSPORT_HDR].desc is NULL.

Then I used the debugging function in nft and executed the following two co=
mmands respectively.

nft --debug all add rule inet myproxy prerouting iif wlan0 meta pkttype uni=
cast meta l4proto {tcp,udp} tproxy to :5555 meta mark set 1 accept

nft --debug all add rule inet myproxy prerouting iif wlan0 meta pkttype uni=
cast meta l4proto tcp tproxy to :5555 meta mark set 1 accept


Evaluate value
add rule inet mitm prerouting iif wlan0 meta pkttype unicast meta l4proto t=
cp tproxy to :5555 meta mark set 1 accept
                                                                          ^=
^^
tcp

update transport layer protocol context:
 link layer          : inet
 network layer       : none
 transport layer     : tcp <-

I found the difference. If it is a protocol value, it will update the trans=
port layer protocol context. If it is "Sets", it will not be updated.

In order to figure out which line of code is causing, I continue to analyze=
 the source code.

static void meta_expr_pctx_update(struct proto_ctx *ctx,
=09=09=09=09  const struct expr *expr)
{
...
=09case NFT_META_L4PROTO:
=09=09desc =3D proto_find_upper(&proto_inet_service,
=09=09=09=09=09mpz_get_uint8(right->value));
=09=09if (desc =3D=3D NULL)
=09=09=09desc =3D &proto_unknown;

=09=09proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, desc=
);
=09=09break;
...
}

Update the transport layer protocol context is executed in the meta_expr_pc=
tx_update function

const struct expr_ops meta_expr_ops =3D {
=09.type=09=09=3D EXPR_META,
=09.name=09=09=3D "meta",
=09.print=09=09=3D meta_expr_print,
=09.json=09=09=3D meta_expr_json,
=09.cmp=09=09=3D meta_expr_cmp,
=09.clone=09=09=3D meta_expr_clone,
=09.pctx_update=09=3D meta_expr_pctx_update,
};

Meta_expr_pctx_update is a function in meta_expr_ops

void relational_expr_pctx_update(struct proto_ctx *ctx,
=09=09=09=09 const struct expr *expr)
{
...
=09ops =3D expr_ops(left);
=09if (ops->pctx_update &&
=09    (left->flags & EXPR_F_PROTOCOL))
=09=09ops->pctx_update(ctx, expr);
}

Relational_expr_pctx_update will call ops->pctx_update

static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
=09=09=09=09       const struct expr *expr,
=09=09=09=09       enum proto_bases base)
{
...
=09switch (expr->op) {
=09case OP_EQ:
=09=09if (expr->right->etype =3D=3D EXPR_RANGE ||
=09=09    expr->right->etype =3D=3D EXPR_SET ||
=09=09    expr->right->etype =3D=3D EXPR_SET_REF)
=09=09=09break;

=09=09relational_expr_pctx_update(&ctx->pctx, expr);
...
}

Eventually I found the problem in the ct_meta_common_postprocess function, =
which specifies that if it is a "Sets" or "Range" or a "Sets" reference, it=
 will not call relational_expr_pctx_update

static void meta_match_postprocess(struct rule_pp_ctx *ctx,
=09=09=09=09   const struct expr *expr)
{
=09const struct expr *left =3D expr->left;

=09ct_meta_common_postprocess(ctx, expr, left->meta.base);
}

The ct_meta_common_postprocess function is called by meta_match_postprocess=
, which looks like a handler for a "meta" expression.

The above analysis is only a personal guess. I don't know much about nft's =
source structure. I don't know if my analysis is correct.

But the above problem does exist. This may not be a "BUG", but it must be a=
 "TODO".

struct proto_ctx {
=09unsigned int=09=09=09debug_mask;
=09unsigned int=09=09=09family;
=09struct {
=09=09struct location=09=09=09location;
=09=09const struct proto_desc=09=09*desc;
=09=09unsigned int=09=09=09offset;
=09} protocol[PROTO_BASE_MAX + 1];
};

The design of struct proto_ctx is flawed. Because users are likely to use m=
ore than one network protocol, whether it is the network layer or the trans=
port layer.

Only support setting a single protocol will lose a lot of flexibility

The "inet" protocol family, although it can support ipv4 and ipv6, may not =
be a good design, maybe ipv8 will appear in the future? A better design is =
that each layer of protocol can support "Sets" and support multiple protoco=
ls, so the scalability is much higher, at least the user can manipulate eve=
rything.

We can add a list_head to the struct protocol, use a linked list to concate=
nate multiple protocols, and only need to traverse the linked list when usi=
ng it.

Of course, this may have to modify a lot of code, but also a big project, b=
ut the above is my personal suggestion, I also hope that nftables will deve=
lop better.
