From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/2] proto: add protocol key in some proto_desc for identifying it
Date: Fri, 11 Jul 2014 10:42:45 +0200
Message-ID: <1405068166-7174-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42218 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaGKInP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:43:15 -0400
Received: by mail-pd0-f170.google.com with SMTP id z10so1040304pdj.29
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2014 01:43:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have added this protocol_key for having more information
for making more easy identify it

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/proto.c |    8 ++++++++
 1 file changed, 8 insertions(+)

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
