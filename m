From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] expression: Show the base which pre-defined constants
 are displayed
Date: Mon, 19 Dec 2016 19:11:04 -0300
Message-ID: <20161219221104.GA32044@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35921 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbcLSWLN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 17:11:13 -0500
Received: by mail-qk0-f193.google.com with SMTP id h201so1270413qke.3
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 14:11:12 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

so the user know how we express it.

The base was added to all symbol tables, which are associated with
datatype->sym_tbl, so they are displayed in the right base.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 src/ct.c         | 3 +++
 src/datatype.c   | 4 ++++
 src/expression.c | 6 +++++-
 src/exthdr.c     | 1 +
 src/fib.c        | 1 +
 src/meta.c       | 2 ++
 src/proto.c      | 8 ++++++++
 7 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/src/ct.c b/src/ct.c
index e532753..d079289 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -33,6 +33,7 @@
 #define CONNLABEL_CONF	DEFAULT_INCLUDE_PATH "/connlabel.conf"
 
 static const struct symbol_table ct_state_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("invalid",	NF_CT_STATE_INVALID_BIT),
 		SYMBOL("new",		NF_CT_STATE_BIT(IP_CT_NEW)),
@@ -54,6 +55,7 @@ static const struct datatype ct_state_type = {
 };
 
 static const struct symbol_table ct_dir_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("original",	IP_CT_DIR_ORIGINAL),
 		SYMBOL("reply",		IP_CT_DIR_REPLY),
@@ -75,6 +77,7 @@ static const struct symbol_table ct_status_tbl = {
 	/*
 	 * There are more, but most of them don't make sense for filtering.
 	 */
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("expected",	IPS_EXPECTED),
 		SYMBOL("seen-reply",	IPS_SEEN_REPLY),
diff --git a/src/datatype.c b/src/datatype.c
index ec0b120..f5f4f3a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -267,6 +267,7 @@ const struct datatype verdict_type = {
 };
 
 static const struct symbol_table nfproto_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("ipv4",		NFPROTO_IPV4),
 		SYMBOL("ipv6",		NFPROTO_IPV6),
@@ -726,6 +727,7 @@ const struct datatype mark_type = {
 };
 
 static const struct symbol_table icmp_code_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("net-unreachable",	ICMP_NET_UNREACH),
 		SYMBOL("host-unreachable",	ICMP_HOST_UNREACH),
@@ -749,6 +751,7 @@ const struct datatype icmp_code_type = {
 };
 
 static const struct symbol_table icmpv6_code_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("no-route",		ICMPV6_NOROUTE),
 		SYMBOL("admin-prohibited",	ICMPV6_ADM_PROHIBITED),
@@ -771,6 +774,7 @@ const struct datatype icmpv6_code_type = {
 };
 
 static const struct symbol_table icmpx_code_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("port-unreachable",	NFT_REJECT_ICMPX_PORT_UNREACH),
 		SYMBOL("admin-prohibited",	NFT_REJECT_ICMPX_ADMIN_PROHIBITED),
diff --git a/src/expression.c b/src/expression.c
index 2aada77..b7403c7 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -114,7 +114,11 @@ void expr_describe(const struct expr *expr)
 	printf("\n");
 
 	if (expr->dtype->sym_tbl != NULL) {
-		printf("\npre-defined symbolic constants:\n");
+		printf("\npre-defined symbolic constants ");
+		if (expr->dtype->sym_tbl->base == BASE_DECIMAL)
+			printf("(in decimal):\n");
+		else
+			printf("(in hexadecimal):\n");
 		symbol_table_print(expr->dtype->sym_tbl, expr->dtype,
 				   expr->byteorder);
 	}
diff --git a/src/exthdr.c b/src/exthdr.c
index f392cff..c641d4a 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -249,6 +249,7 @@ const struct exthdr_desc exthdr_dst = {
 	HDR_TEMPLATE(__name, __dtype, struct ip6_mh, __member)
 
 static const struct symbol_table mh_type_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("binding-refresh-request",	IP6_MH_TYPE_BRR),
 		SYMBOL("home-test-init",		IP6_MH_TYPE_HOTI),
diff --git a/src/fib.c b/src/fib.c
index 346cce3..c65677c 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -27,6 +27,7 @@ static const char *fib_result[NFT_FIB_RESULT_MAX + 1] = {
 };
 
 static const struct symbol_table addrtype_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("unspec",	RTN_UNSPEC),
 		SYMBOL("unicast",	RTN_UNICAST),
diff --git a/src/meta.c b/src/meta.c
index 574fc50..cb7c136 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -198,6 +198,7 @@ const struct datatype ifindex_type = {
 };
 
 static const struct symbol_table arphrd_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("ether",		ARPHRD_ETHER),
 		SYMBOL("ppp",		ARPHRD_PPP),
@@ -326,6 +327,7 @@ static const struct datatype gid_type = {
 };
 
 static const struct symbol_table pkttype_type_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("host", PACKET_HOST),
 		SYMBOL("unicast", PACKET_HOST), /* backwards compat */
diff --git a/src/proto.c b/src/proto.c
index 8930bed..fb96530 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -303,6 +303,7 @@ const struct proto_desc proto_comp = {
 #include <netinet/ip_icmp.h>
 
 static const struct symbol_table icmp_type_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("echo-reply",			ICMP_ECHOREPLY),
 		SYMBOL("destination-unreachable",	ICMP_DEST_UNREACH),
@@ -391,6 +392,7 @@ const struct proto_desc proto_udplite = {
 #include <netinet/tcp.h>
 
 static const struct symbol_table tcp_flag_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("fin",	TCP_FLAG_FIN),
 		SYMBOL("syn",	TCP_FLAG_SYN),
@@ -449,6 +451,7 @@ const struct proto_desc proto_tcp = {
  */
 
 static const struct symbol_table dccp_pkttype_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("request",	DCCP_PKT_REQUEST),
 		SYMBOL("response",	DCCP_PKT_RESPONSE),
@@ -514,6 +517,7 @@ const struct proto_desc proto_sctp = {
 #include <netinet/ip.h>
 
 static const struct symbol_table dscp_type_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("cs0",	0x00),
 		SYMBOL("cs1",	0x08),
@@ -553,6 +557,7 @@ static const struct datatype dscp_type = {
 };
 
 static const struct symbol_table ecn_type_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("not-ect",	0x00),
 		SYMBOL("ect1",		0x01),
@@ -628,6 +633,7 @@ const struct proto_desc proto_ip = {
 #include <netinet/icmp6.h>
 
 static const struct symbol_table icmp6_type_tbl = {
+	.base		= BASE_DECIMAL,
 	.symbols	= {
 		SYMBOL("destination-unreachable",	ICMP6_DST_UNREACH),
 		SYMBOL("packet-too-big",		ICMP6_PACKET_TOO_BIG),
@@ -778,6 +784,7 @@ const struct proto_desc proto_inet_service = {
 #include <net/if_arp.h>
 
 static const struct symbol_table arpop_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("request",	__constant_htons(ARPOP_REQUEST)),
 		SYMBOL("reply",		__constant_htons(ARPOP_REPLY)),
@@ -866,6 +873,7 @@ const struct datatype etheraddr_type = {
 };
 
 static const struct symbol_table ethertype_tbl = {
+	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("ip",		__constant_htons(ETH_P_IP)),
 		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
-- 
2.7.4

