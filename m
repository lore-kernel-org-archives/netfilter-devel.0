From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] Handle routing changes in MASQUERADE target, v4
Date: Fri, 30 Nov 2012 23:37:26 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211302336170.16789@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:44363 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab2K3Wh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:37:28 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id C142D1F42C5
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Nov 2012 23:37:26 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KYrBtj1shhcW for <netfilter-devel@vger.kernel.org>;
	Fri, 30 Nov 2012 23:37:26 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id A871D1F42C4
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Nov 2012 23:37:26 +0100 (CET)
In-Reply-To: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When the route changes (backup default route, VPNs) which affect a
masqueraded target, the packets were sent out with the outdated source
address. The patch addresses the issue by comparing the outgoing interface
directly with the masqueraded interface in the nat table.

Events are inefficient in this case, because it'd require adding route
events to the network core and then scanning the whole conntrack table
and re-checking the route for all entry.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/net/netfilter/nf_nat.h    |   15 +++++++++++++++
 net/ipv4/netfilter/iptable_nat.c  |    4 ++++
 net/ipv6/netfilter/ip6table_nat.c |    4 ++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index bd8eea7..ad14a79 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -68,4 +68,19 @@ static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 #endif
 }
 
+static inline bool nf_nat_oif_changed(unsigned int hooknum,
+				      enum ip_conntrack_info ctinfo,
+				      struct nf_conn_nat *nat,
+				      const struct net_device *out)
+{
+#if IS_ENABLED(CONFIG_IP_NF_TARGET_MASQUERADE) || \
+    IS_ENABLED(CONFIG_IP6_NF_TARGET_MASQUERADE)
+	return nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
+	       CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
+	       nat->masq_index != out->ifindex;
+#else
+	return false;
+#endif
+}
+
 #endif
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index ac635a7..da2c8a3 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -134,6 +134,10 @@ nf_nat_ipv4_fn(unsigned int hooknum,
 		/* ESTABLISHED */
 		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
 			     ctinfo == IP_CT_ESTABLISHED_REPLY);
+		if (nf_nat_oif_changed(hooknum, ctinfo, nat, out)) {
+			nf_ct_kill_acct(ct, ctinfo, skb);
+			return NF_DROP;
+		}
 	}
 
 	return nf_nat_packet(ct, ctinfo, hooknum, skb);
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index fa84cf8..6c8ae24 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -137,6 +137,10 @@ nf_nat_ipv6_fn(unsigned int hooknum,
 		/* ESTABLISHED */
 		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
 			     ctinfo == IP_CT_ESTABLISHED_REPLY);
+		if (nf_nat_oif_changed(hooknum, ctinfo, nat, out)) {
+			nf_ct_kill_acct(ct, ctinfo, skb);
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
