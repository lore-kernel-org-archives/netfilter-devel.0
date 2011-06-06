From: pablo@netfilter.org
Subject: [PATCH 6/7] netfilter: nf_conntrack: fix ct refcount leak in l4proto->error()
Date: Mon,  6 Jun 2011 02:11:39 +0200
Message-ID: <1307319100-21827-7-git-send-email-pablo@netfilter.org>
References: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54952 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1FFAMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:12:06 -0400
In-Reply-To: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch fixes a refcount leak of ct objects that may occur if
l4proto->error() assigns one conntrack object to one skbuff. In
that case, we have to skip further processing in nf_conntrack_in().

With this patch, we can also fix wrong return values (-NF_ACCEPT)
for special cases in ICMP[v6] that should not bump the invalid/error
statistic counters.

Reported-by: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 7404bde..ab5b27a 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -160,7 +160,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	/* Update skb to refer to this connection */
 	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
-	return -NF_ACCEPT;
+	return NF_ACCEPT;
 }
 
 /* Small and modified version of icmp_rcv */
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 1df3c8b..7c05e7e 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -177,7 +177,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	/* Update skb to refer to this connection */
 	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
-	return -NF_ACCEPT;
+	return NF_ACCEPT;
 }
 
 static int
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0bd5689..f7af8b8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -922,6 +922,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 			ret = -ret;
 			goto out;
 		}
+		/* ICMP[v6] protocol trackers may assign one conntrack. */
+		if (skb->nfct)
+			goto out;
 	}
 
 	ct = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum,
-- 
1.7.2.5

