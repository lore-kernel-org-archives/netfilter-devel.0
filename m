From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH v2] payload: generate dependency with wrong byteorder value format
Date: Fri, 11 Jul 2014 13:09:34 +0200
Message-ID: <1405076974-20899-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36945 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaGKLKB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:10:01 -0400
Received: by mail-pd0-f179.google.com with SMTP id w10so1224505pde.24
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2014 04:10:01 -0700 (PDT)
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
 src/proto.c   |    8 ++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

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
diff --git a/src/proto.c b/src/proto.c
index 546ef10..4192108 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -249,6 +249,7 @@ const struct proto_desc proto_ah =3D {
 const struct proto_desc proto_esp =3D {
 	.name		=3D "esp",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_ESP,
 	.templates	=3D {
 		[ESPHDR_SPI]		=3D ESPHDR_FIELD("spi", spi),
 		[ESPHDR_SEQUENCE]	=3D ESPHDR_FIELD("sequence", seq_no),
@@ -326,6 +327,7 @@ static const struct datatype icmp_type_type =3D {
 const struct proto_desc proto_icmp =3D {
 	.name		=3D "icmp",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_ICMP,
 	.templates	=3D {
 		[ICMPHDR_TYPE]		=3D ICMPHDR_TYPE("type", &icmp_type_type, type),
 		[ICMPHDR_CODE]		=3D ICMPHDR_FIELD("code", code),
@@ -348,6 +350,7 @@ const struct proto_desc proto_icmp =3D {
 const struct proto_desc proto_udp =3D {
 	.name		=3D "udp",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_UDP,
 	.templates	=3D {
 		[UDPHDR_SPORT]		=3D INET_SERVICE("sport", struct udphdr, source),
 		[UDPHDR_DPORT]		=3D INET_SERVICE("dport", struct udphdr, dest),
@@ -359,6 +362,7 @@ const struct proto_desc proto_udp =3D {
 const struct proto_desc proto_udplite =3D {
 	.name		=3D "udplite",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_UDPLITE,
 	.templates	=3D {
 		[UDPHDR_SPORT]		=3D INET_SERVICE("sport", struct udphdr, source),
 		[UDPHDR_DPORT]		=3D INET_SERVICE("dport", struct udphdr, dest),
@@ -403,6 +407,7 @@ static const struct datatype tcp_flag_type =3D {
 const struct proto_desc proto_tcp =3D {
 	.name		=3D "tcp",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_TCP,
 	.templates	=3D {
 		[TCPHDR_SPORT]		=3D INET_SERVICE("sport", struct tcphdr, source),
 		[TCPHDR_DPORT]		=3D INET_SERVICE("dport", struct tcphdr, dest),
@@ -456,6 +461,7 @@ static const struct datatype dccp_pkttype_type =3D =
{
 const struct proto_desc proto_dccp =3D {
 	.name		=3D "dccp",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_DCCP,
 	.templates	=3D {
 		[DCCPHDR_SPORT]		=3D INET_SERVICE("sport", struct dccp_hdr, dccph_sp=
ort),
 		[DCCPHDR_DPORT]		=3D INET_SERVICE("dport", struct dccp_hdr, dccph_dp=
ort),
@@ -473,6 +479,7 @@ const struct proto_desc proto_dccp =3D {
 const struct proto_desc proto_sctp =3D {
 	.name		=3D "sctp",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_SCTP,
 	.templates	=3D {
 		[SCTPHDR_SPORT]		=3D INET_SERVICE("sport", struct sctphdr, source),
 		[SCTPHDR_DPORT]		=3D INET_SERVICE("dport", struct sctphdr, dest),
@@ -566,6 +573,7 @@ static const struct datatype icmp6_type_type =3D {
 const struct proto_desc proto_icmp6 =3D {
 	.name		=3D "icmpv6",
 	.base		=3D PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	=3D IPPROTO_ICMPV6,
 	.templates	=3D {
 		[ICMP6HDR_TYPE]		=3D ICMP6HDR_TYPE("type", &icmp6_type_type, icmp6_t=
ype),
 		[ICMP6HDR_CODE]		=3D ICMP6HDR_FIELD("code", icmp6_code),
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
