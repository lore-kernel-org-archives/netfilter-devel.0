From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] nf_nat: no IP_NAT_RANGE_MAP_IPS flags when alloc_null_binding()
Date: Sun,  1 Aug 2010 02:15:59 +0800
Message-ID: <1280600159-2984-1-git-send-email-xiaosuo@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55687 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0HABsY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Jul 2010 21:48:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

when alloc_null_binding(), no IP_NAT_RNAGE_MAP_IPS in flags means no IP address
translation is needed. It isn't necessary to specify the address explicitly.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/ipv4/netfilter/nf_nat_rule.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index ebbd319..fe8c90e 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -108,14 +108,12 @@ alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 	   per-proto parts (hence not IP_NAT_RANGE_PROTO_SPECIFIED).
 	   Use reply in case it's already been mangled (eg local packet).
 	*/
-	__be32 ip
-		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
-		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
-		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
-	struct nf_nat_range range
-		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { 0 }, { 0 } };
-
-	pr_debug("Allocating NULL binding for %p (%pI4)\n", ct, &ip);
+	struct nf_nat_range range = { 0 };
+
+	pr_debug("Allocating NULL binding for %p (%pI4)\n", ct,
+		 HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC ?
+		 &ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip :
+		 &ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
 	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
 }
 
