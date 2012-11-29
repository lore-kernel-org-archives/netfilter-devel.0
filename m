From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [RFC] [PATCH] Handle routing changes for the MASQUERADE target
Date: Thu, 29 Nov 2012 22:12:54 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211292202150.25841@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51495 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2K2VM4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:12:56 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id CB5C94D4123
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2012 22:12:54 +0100 (CET)
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cBRLyIIAkilO for <netfilter-devel@vger.kernel.org>;
	Thu, 29 Nov 2012 22:12:54 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp0.kfki.hu (Postfix) with ESMTP id A63D94D4004
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2012 22:12:54 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is the second variant of the patch which addresses the route 
changes affecting already masqueraded connections.

When the route changes (backup default route, VPNs), the packets are sent 
out with wrong source address. The patch addresses the issue by comparing 
the outgoing interface directly with the masquerade interface in the nat 
table. It *is* MASQUERADE specific, so probably the inserted code could be 
enclosed in a proper ifdef.

Events are inefficient, because it'd require scanning the whole conntrack 
table at any route change and re-checking the route for all entry, which 
is simply way too expensive.

Comments are highly welcomed.

Best regards,
Jozsef

---
 net/ipv4/netfilter/iptable_nat.c  |   19 +++++++++++++++++++
 net/ipv6/netfilter/ip6table_nat.c |   19 +++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index ac635a7..128885d 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -17,6 +17,7 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l3proto.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 static const struct xt_table nf_nat_ipv4_table = {
 	.name		= "nat",
@@ -134,6 +135,24 @@ nf_nat_ipv4_fn(unsigned int hooknum,
 		/* ESTABLISHED */
 		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
 			     ctinfo == IP_CT_ESTABLISHED_REPLY);
+		if (hooknum == NF_INET_POST_ROUTING &&
+		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
+		    nat->masq_index && nat->masq_index != out->ifindex) {
+			/* Outgoing interface changed, kill ct.  */
+			if (del_timer(&ct->timeout)) {
+				if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
+					nf_ct_delete_from_lists(ct);
+					nf_ct_insert_dying_list(ct);
+					nf_ct_put(ct);
+					return NF_DROP;
+				}
+				set_bit(IPS_DYING_BIT, &ct->status);
+				nf_ct_delete_from_lists(ct);
+				nf_ct_put(ct);
+			}
+			nf_ct_put(ct);
+			return NF_DROP;
+		}
 	}
 
 	return nf_nat_packet(ct, ctinfo, hooknum, skb);
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index fa84cf8..d06d7de 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -19,6 +19,7 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l3proto.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 static const struct xt_table nf_nat_ipv6_table = {
 	.name		= "nat",
@@ -137,6 +138,24 @@ nf_nat_ipv6_fn(unsigned int hooknum,
 		/* ESTABLISHED */
 		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
 			     ctinfo == IP_CT_ESTABLISHED_REPLY);
+		if (hooknum == NF_INET_POST_ROUTING &&
+		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
+		    nat->masq_index && nat->masq_index != out->ifindex) {
+			/* Outgoing interface changed, kill ct.  */
+			if (del_timer(&ct->timeout)) {
+				if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
+					nf_ct_delete_from_lists(ct);
+					nf_ct_insert_dying_list(ct);
+					nf_ct_put(ct);
+					return NF_DROP;
+				}
+				set_bit(IPS_DYING_BIT, &ct->status);
+				nf_ct_delete_from_lists(ct);
+				nf_ct_put(ct);
+			}
+			nf_ct_put(ct);
+			return NF_DROP;
+		}
 	}
 
 	return nf_nat_packet(ct, ctinfo, hooknum, skb);
-- 
1.7.0.4


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
