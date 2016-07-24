From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] l2tp for nftables
Date: Sun, 24 Jul 2016 19:30:07 +0200
Message-ID: <20160724173007.GA2313@salvia>
References: <20160724172530.GA1655@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56348 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbcGXRaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jul 2016 13:30:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 851F8EAA63
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 19:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 727F1FF2FD
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 19:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E77DFFAB58
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 19:30:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160724172530.GA1655@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 24, 2016 at 07:25:30PM +0200, Pablo Neira Ayuso wrote:
> Hi James,
> 
> I'm looking what is missing to add l2tp for nftables, after a quick
> glance this is what I found.
> 
> The L2TPv3 over IP (after quick reading of the RFC) seems easy to add.
> I'm attaching a patch for the header layout definition (still parser
> side is missing, so this patch is incomplete).

Forgot attachment.

--cWoXeonUoKmBZSoM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-add-l2tp.patch"

>From 33da2458d250cedb8e2f1bded636e2fcec86c7b5 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 24 Jul 2016 19:10:02 +0200
Subject: [PATCH] proto: add support l2tp protocol

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Patch incomplete, parser side is missing.

 include/headers.h | 15 +++++++++++++++
 include/proto.h   | 11 +++++++++++
 src/proto.c       | 23 +++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/include/headers.h b/include/headers.h
index 469d674..8faff26 100644
--- a/include/headers.h
+++ b/include/headers.h
@@ -130,4 +130,19 @@ struct ip6_mh {
 /* RFC 5142 */
 #define IP6_MH_TYPE_HASM	12	/* Home Agent Switch Message	*/
 
+struct l2tphdr {
+	uint32_t	sid;
+	uint16_t	flags:12,
+			ver:4;
+	uint16_t	length;
+	uint32_t	cid;
+	uint16_t	ns;
+	uint16_t	nr;
+};
+
+/* RFC 3931 */
+#ifndef IPPROTO_L2TP
+# define IPPROTO_L2TP		115
+#endif
+
 #endif /* NFTABLES_HEADERS_H */
diff --git a/include/proto.h b/include/proto.h
index 4fa54a7..dc250e6 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -293,6 +293,16 @@ enum sctp_hdr_fields {
 	SCTPHDR_CHECKSUM,
 };
 
+enum l2tp_hdr_fields {
+	L2TPHDR_SID,
+	L2TPHDR_FLAGS,
+	L2TPHDR_VERSION,
+	L2TPHDR_LENGTH,
+	L2TPHDR_CID,
+	L2TPHDR_NS,
+	L2TPHDR_NR,
+};
+
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_ah;
 extern const struct proto_desc proto_esp;
@@ -303,6 +313,7 @@ extern const struct proto_desc proto_tcp;
 extern const struct proto_desc proto_dccp;
 extern const struct proto_desc proto_sctp;
 extern const struct proto_desc proto_icmp6;
+extern const struct proto_desc proto_l2tp;
 
 extern const struct proto_desc proto_ip;
 extern const struct proto_desc proto_ip6;
diff --git a/src/proto.c b/src/proto.c
index 4c12977..1ee128b 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -508,6 +508,27 @@ const struct proto_desc proto_sctp = {
 };
 
 /*
+ * L2TPv3 (RFC3931)
+ */
+
+#define L2TPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct l2tphdr, __member)
+
+const struct proto_desc proto_l2tp = {
+	.name		= "l2tp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[L2TPHDR_SID]		= L2TPHDR_FIELD("sid", sid),
+		[L2TPHDR_FLAGS]		= HDR_BITFIELD("flags", &integer_type, 32, 44),
+		[L2TPHDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 44, 48),
+		[L2TPHDR_LENGTH]	= L2TPHDR_FIELD("length", length),
+		[L2TPHDR_CID]		= L2TPHDR_FIELD("cid", cid),
+		[L2TPHDR_NS]		= L2TPHDR_FIELD("ns", ns),
+		[L2TPHDR_NR]		= L2TPHDR_FIELD("nr", nr),
+	},
+};
+
+/*
  * IPv4
  */
 
@@ -593,6 +614,7 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+		PROTO_LINK(IPPROTO_L2TP,	&proto_l2tp),
 	},
 	.templates	= {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
@@ -701,6 +723,7 @@ const struct proto_desc proto_ip6 = {
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
+		PROTO_LINK(IPPROTO_L2TP,	&proto_l2tp),
 	},
 	.templates	= {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
-- 
2.1.4


--cWoXeonUoKmBZSoM--
