From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] parser: fix parsing of ethernet protocol types
Date: Wed, 15 Jan 2014 21:30:21 +0100
Message-ID: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52336 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaAOUac (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:30:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to use the protocol type keyword, eg.

nft add rule ip filter output meta protocol ip6 counte
                                            ^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser.y |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/src/parser.y b/src/parser.y
index 038282e..23662f7 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -23,6 +23,7 @@
 #include <expression.h>
 #include <utils.h>
 #include <parser.h>
+#include <if_ether.h>
 #include <erec.h>
 
 #include "parser.h"
@@ -1418,6 +1419,13 @@ vlan_hdr_expr		:	VLAN	vlan_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &payload_vlan, $2);
 			}
+			|	VLAN
+			{
+				uint16_t data = ETH_P_8021Q;
+				$$ = constant_expr_alloc(&@$, &ethertype_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			;
 
 vlan_hdr_field		:	ID		{ $$ = VLANHDR_VID; }
@@ -1430,6 +1438,13 @@ arp_hdr_expr		:	ARP	arp_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &payload_arp, $2);
 			}
+			|	ARP
+			{
+				uint16_t data = ETH_P_ARP;
+				$$ = constant_expr_alloc(&@$, &ethertype_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			;
 
 arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
@@ -1443,6 +1458,13 @@ ip_hdr_expr		:	IP	ip_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &payload_ip, $2);
 			}
+			|	IP
+			{
+				uint16_t data = ETH_P_IP;
+				$$ = constant_expr_alloc(&@$, &ethertype_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			;
 
 ip_hdr_field		:	VERSION		{ $$ = IPHDR_VERSION; }
@@ -1484,6 +1506,13 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
 			{
 				$$ = payload_expr_alloc(&@$, &payload_ip6, $2);
 			}
+			|	IP6
+			{
+				uint16_t data = ETH_P_IPV6;
+				$$ = constant_expr_alloc(&@$, &ethertype_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			;
 
 ip6_hdr_field		:	VERSION		{ $$ = IP6HDR_VERSION; }
-- 
1.7.10.4

