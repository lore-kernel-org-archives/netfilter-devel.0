From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] proto: fix byteorder of ETH_P_* values
Date: Tue, 19 Aug 2014 00:27:31 +0100
Message-ID: <1408404451-9075-4-git-send-email-kaber@trash.net>
References: <1408404451-9075-1-git-send-email-kaber@trash.net>
Cc: alvaroneay@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53278 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaHRX1k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:27:40 -0400
In-Reply-To: <1408404451-9075-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ethernet header type is in big endian byte order, the ETH_P_* values
are in host byte order however. Fix this using __constant_htons().

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/proto.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index e5f49cb..15a456a 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -712,10 +712,10 @@ const struct proto_desc proto_vlan = {
 	.base		= PROTO_BASE_LL_HDR,
 	.protocol_key	= VLANHDR_TYPE,
 	.protocols	= {
-		PROTO_LINK(ETH_P_IP,		&proto_ip),
-		PROTO_LINK(ETH_P_ARP,		&proto_arp),
-		PROTO_LINK(ETH_P_IPV6,		&proto_ip6),
-		PROTO_LINK(ETH_P_8021Q,		&proto_vlan),
+		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
+		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
+		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
+		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
 
 	},
 	.templates	= {
@@ -741,10 +741,10 @@ const struct datatype etheraddr_type = {
 
 static const struct symbol_table ethertype_tbl = {
 	.symbols	= {
-		SYMBOL("ip",		ETH_P_IP),
-		SYMBOL("arp",		ETH_P_ARP),
-		SYMBOL("ip6",		ETH_P_IPV6),
-		SYMBOL("vlan",		ETH_P_8021Q),
+		SYMBOL("ip",		__constant_htons(ETH_P_IP)),
+		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
+		SYMBOL("ip6",		__constant_htons(ETH_P_IPV6)),
+		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
 		SYMBOL_LIST_END
 	},
 };
@@ -792,10 +792,10 @@ const struct proto_desc proto_eth = {
 	.base		= PROTO_BASE_LL_HDR,
 	.protocol_key	= ETHHDR_TYPE,
 	.protocols	= {
-		PROTO_LINK(ETH_P_IP,		&proto_ip),
-		PROTO_LINK(ETH_P_ARP,		&proto_arp),
-		PROTO_LINK(ETH_P_IPV6,		&proto_ip6),
-		PROTO_LINK(ETH_P_8021Q,		&proto_vlan),
+		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
+		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
+		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
+		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
 	},
 	.templates	= {
 		[ETHHDR_DADDR]		= ETHHDR_ADDR("daddr", ether_dhost),
-- 
1.9.3

