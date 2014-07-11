From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/2] payload: generate dependency with wrong byteorder value format
Date: Fri, 11 Jul 2014 10:44:14 +0200
Message-ID: <1405068254-7316-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63990 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaGKIoj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:44:39 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so1039991pdi.18
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2014 01:44:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

In all case that we have added a payload dependency, we have supposed
that the byteorder must to be BYTEORDER_HOST_ENDIAN, the problem is
when we want to add a dependency that the value has another byteorder.
=46or example, if we try to add a new payload dependency in a bridge ta=
ble
and we use ether type, the byteorder is BYTEORDER_BIG_ENDIAN. The value
of the type ip is 0x0800 in ether but when we add the payload dependenc=
y
for this specific protocol, we will have a payload like this:

[ payload load 2b @ link header + 12 =3D> reg 1 ]
  [ cmp eq reg 1 0x00000008 ]

This patch allows to create payload dependency with the byteorder of th=
e
template. For that I have updated the function for updating the context=
 for
using the byteorder of the template too. With this changes we have a pa=
yload
with the correct format:

[ payload load 2b @ link header + 12 =3D> reg 1 ]
  [ cmp eq reg 1 0x00000800 ]

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[tested with the rules]

nft add rule filter input ip protocol tcp counter
nft add rule filter input ip protocol udp counter
nft add rule filter input tcp dport 22 counter

 src/payload.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index a1785a5..fb78ba5 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -69,13 +69,18 @@ static void payload_expr_pctx_update(struct proto_c=
tx *ctx,
 {
 	const struct expr *left =3D expr->left, *right =3D expr->right;
 	const struct proto_desc *base, *desc;
+	const struct proto_hdr_template *tmpl;
+	uint32_t value =3D 0;
=20
 	if (!(left->flags & EXPR_F_PROTOCOL))
 		return;
=20
 	assert(expr->op =3D=3D OP_EQ);
 	base =3D ctx->protocol[left->payload.base].desc;
-	desc =3D proto_find_upper(base, mpz_get_uint32(right->value));
+	tmpl =3D &base->templates[base->protocol_key];
+	mpz_export_data(&value, right->value, tmpl->dtype->byteorder,
+			div_round_up(tmpl->len, BITS_PER_BYTE));
+	desc =3D proto_find_upper(base, value);
=20
 	proto_ctx_update(ctx, left->payload.base + 1, &expr->location, desc);
 }
@@ -208,7 +213,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, co=
nst struct expr *expr,
 		left =3D payload_expr_alloc(&expr->location, desc, desc->protocol_ke=
y);
=20
 	right =3D constant_expr_alloc(&expr->location, tmpl->dtype,
-				    BYTEORDER_HOST_ENDIAN,
+				    tmpl->dtype->byteorder,
 				    tmpl->len,
 				    constant_data_ptr(protocol, tmpl->len));
=20
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
