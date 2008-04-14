From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/41]: nf_nat: don't add NAT extension for confirmed conntracks
Date: Mon, 14 Apr 2008 12:16:56 +0200 (MEST)
Message-ID: <20080414101653.32717.55084.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36325 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbYDNKQ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:58 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: don't add NAT extension for confirmed conntracks

Adding extensions to confirmed conntracks is not allowed to avoid races
on reallocation. Don't setup NAT for confirmed conntracks in case NAT
module is loaded late.

The has one side-effect, the connections existing before the NAT module
was loaded won't enter the bysource hash. The only case where this actually
makes a difference is in case of SNAT to a multirange where the IP before
NAT is also part of the range. Since old connections don't enter the
bysource hash the first new connection from the IP will have a new address
selected. This shouldn't matter at all.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6cad3b7ff5971feef96758c159ee689ab14118ee
tree 63a276412e0ff19d01bb0e97b56370caa3b66672
parent 021e7d24124820256a4789b5576bdbd1dbc1a274
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200

 include/net/netfilter/nf_nat_rule.h    |    3 ---
 net/ipv4/netfilter/nf_nat_rule.c       |   19 -------------------
 net/ipv4/netfilter/nf_nat_standalone.c |    8 ++++----
 3 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_nat_rule.h b/include/net/netfilter/nf_nat_rule.h
index 75d1825..e4a18ae 100644
--- a/include/net/netfilter/nf_nat_rule.h
+++ b/include/net/netfilter/nf_nat_rule.h
@@ -14,7 +14,4 @@ extern int nf_nat_rule_find(struct sk_buff *skb,
 
 extern unsigned int
 alloc_null_binding(struct nf_conn *ct, unsigned int hooknum);
-
-extern unsigned int
-alloc_null_binding_confirmed(struct nf_conn *ct, unsigned int hooknum);
 #endif /* _NF_NAT_RULE_H */
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index ebe0c79..e8b4d0d 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -188,25 +188,6 @@ alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
 }
 
-unsigned int
-alloc_null_binding_confirmed(struct nf_conn *ct, unsigned int hooknum)
-{
-	__be32 ip
-		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
-		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
-		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
-	__be16 all
-		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
-		   ? ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.all
-		   : ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.all);
-	struct nf_nat_range range
-		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { all }, { all } };
-
-	pr_debug("Allocating NULL binding for confirmed %p (%u.%u.%u.%u)\n",
-		 ct, NIPQUAD(ip));
-	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
-}
-
 int nf_nat_rule_find(struct sk_buff *skb,
 		     unsigned int hooknum,
 		     const struct net_device *in,
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index c362f67..a366b58 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -102,6 +102,9 @@ nf_nat_fn(unsigned int hooknum,
 
 	nat = nfct_nat(ct);
 	if (!nat) {
+		/* NAT module was loaded late. */
+		if (nf_ct_is_confirmed(ct))
+			return NF_ACCEPT;
 		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
 		if (nat == NULL) {
 			pr_debug("failed to add NAT extension\n");
@@ -127,10 +130,7 @@ nf_nat_fn(unsigned int hooknum,
 		if (!nf_nat_initialized(ct, maniptype)) {
 			unsigned int ret;
 
-			if (unlikely(nf_ct_is_confirmed(ct)))
-				/* NAT module was loaded late */
-				ret = alloc_null_binding_confirmed(ct, hooknum);
-			else if (hooknum == NF_INET_LOCAL_IN)
+			if (hooknum == NF_INET_LOCAL_IN)
 				/* LOCAL_IN hook doesn't have a chain!  */
 				ret = alloc_null_binding(ct, hooknum);
 			else
