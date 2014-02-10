From: Eric Leblond <eric@regit.org>
Subject: [nftables RFC PATCH] icmp: add code filtering with name
Date: Mon, 10 Feb 2014 13:33:25 +0100
Message-ID: <1392035605-2889-2-git-send-email-eric@regit.org>
References: <1392035605-2889-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:58854 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaBJMdr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:33:47 -0500
In-Reply-To: <1392035605-2889-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch define names for code field allowing to use string
instead of integer when filtering on icmp code.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/datatype.h |  2 ++
 src/proto.c        | 43 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/datatype.h b/include/datatype.h
index 9e609cf..033ae08 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -34,6 +34,7 @@
  * @TYPE_CT_DIR:	conntrack direction
  * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
+ * @TYPE_ICMP_CODE:	ICMP code codes (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -66,6 +67,7 @@ enum datatypes {
 	TYPE_CT_DIR,
 	TYPE_CT_STATUS,
 	TYPE_ICMP6_TYPE,
+	TYPE_ICMP_CODE,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/src/proto.c b/src/proto.c
index cc073af..bb56766 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -315,12 +315,52 @@ static const struct datatype icmp_type_type = {
 #define ICMPHDR_TYPE(__name, __type, __member) \
 	HDR_TYPE(__name, __type, struct icmphdr, __member)
 
+static const struct symbol_table icmp_code_tbl = {
+	.symbols	= {
+		SYMBOL("network-unreachable",		ICMP_NET_UNREACH),
+		SYMBOL("host-unreachable",		ICMP_HOST_UNREACH),
+		SYMBOL("protocol-unreachable",		ICMP_PROT_UNREACH),
+		SYMBOL("port-unreachable",		ICMP_PORT_UNREACH),
+		SYMBOL("fragmentation-needed",		ICMP_FRAG_NEEDED),
+		SYMBOL("source-route-failed",		ICMP_SR_FAILED),
+		SYMBOL("network-unknown",		ICMP_NET_UNKNOWN),
+		SYMBOL("host-unknown",			ICMP_HOST_UNKNOWN),
+		SYMBOL("host-isolated",			ICMP_HOST_ISOLATED),
+		SYMBOL("network-prohibited",		ICMP_NET_ANO),
+		SYMBOL("host-prohibited",		ICMP_HOST_ANO),
+		SYMBOL("TOS-network-unreachable",	ICMP_NET_UNR_TOS),
+		SYMBOL("TOS-host-unreachable",		ICMP_HOST_UNR_TOS),
+		SYMBOL("communication-prohibited",	ICMP_PKT_FILTERED),
+		SYMBOL("host-precedence-violation",	ICMP_PREC_VIOLATION),
+		SYMBOL("precedence-cutoff",		ICMP_PREC_CUTOFF),
+
+		SYMBOL("network-redirect",		ICMP_REDIR_NET),
+		SYMBOL("host-redirect",			ICMP_REDIR_HOST),
+		SYMBOL("network-redirect-tos",		ICMP_REDIR_NETTOS),
+		SYMBOL("host-redirect-tos",		ICMP_REDIR_HOSTTOS),
+
+		SYMBOL("ttl-exceeded",			ICMP_EXC_TTL),
+		SYMBOL("fragtime-exceeded",		ICMP_EXC_FRAGTIME),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype icmp_code_type = {
+	.type		= TYPE_ICMP_CODE,
+	.name		= "icmp_code",
+	.desc		= "ICMP code",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.sym_tbl	= &icmp_code_tbl,
+};
+
 const struct proto_desc proto_icmp = {
 	.name		= "icmp",
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.templates	= {
 		[ICMPHDR_TYPE]		= ICMPHDR_TYPE("type", &icmp_type_type, type),
-		[ICMPHDR_CODE]		= ICMPHDR_FIELD("code", code),
+		[ICMPHDR_CODE]		= ICMPHDR_TYPE("code", &icmp_code_type, code),
 		[ICMPHDR_CHECKSUM]	= ICMPHDR_FIELD("checksum", checksum),
 		[ICMPHDR_ID]		= ICMPHDR_FIELD("id", un.echo.id),
 		[ICMPHDR_SEQ]		= ICMPHDR_FIELD("sequence", un.echo.sequence),
@@ -806,6 +846,7 @@ const struct proto_desc proto_eth = {
 static void __init proto_init(void)
 {
 	datatype_register(&icmp_type_type);
+	datatype_register(&icmp_code_type);
 	datatype_register(&tcp_flag_type);
 	datatype_register(&dccp_pkttype_type);
 	datatype_register(&arpop_type);
-- 
1.9.0.rc3

