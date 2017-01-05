From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/4] netfilter: reset netfilter state when duplicating packet
Date: Thu,  5 Jan 2017 12:26:47 +0100
Message-ID: <1483615609-29155-3-git-send-email-fw@strlen.de>
References: <1483615609-29155-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48198 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032320AbdAEL7A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 06:59:00 -0500
In-Reply-To: <1483615609-29155-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We should also toss nf_bridge_info, if any -- packet is leaving via
ip_local_out, also, this skb isn't bridged -- it is a locally generated
copy.  Also this avoids the need to touch this later when skb->nfct is
replaced with 'unsigned long _nfct' in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes in v2.
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
2.7.3

