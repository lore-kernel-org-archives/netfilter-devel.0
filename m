From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/27] netfilter: reset netfilter state when duplicating packet
Date: Fri,  3 Feb 2017 13:25:31 +0100
Message-ID: <1486124738-3013-21-git-send-email-pablo@netfilter.org>
References: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486124738-3013-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We should also toss nf_bridge_info, if any -- packet is leaving via
ip_local_out, also, this skb isn't bridged -- it is a locally generated
copy.  Also this avoids the need to touch this later when skb->nfct is
replaced with 'unsigned long _nfct' in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_dup_ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index cf986e1c7bbd..a981ef7151ca 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -68,7 +68,7 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Avoid counting cloned packets towards the original connection. */
-	nf_conntrack_put(skb->nfct);
+	nf_reset(skb);
 	skb->nfct     = &nf_ct_untracked_get()->ct_general;
 	skb->nfctinfo = IP_CT_NEW;
 	nf_conntrack_get(skb->nfct);
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 4a84b5ad9ecb..5f52e5f90e7e 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -57,7 +57,7 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		return;
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	nf_conntrack_put(skb->nfct);
+	nf_reset(skb);
 	skb->nfct     = &nf_ct_untracked_get()->ct_general;
 	skb->nfctinfo = IP_CT_NEW;
 	nf_conntrack_get(skb->nfct);
-- 
2.1.4
