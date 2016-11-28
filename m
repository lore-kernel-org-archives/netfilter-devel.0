From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ingress: translate 0 nf_hook_slow retval to -EINPROGRESS
Date: Mon, 28 Nov 2016 11:40:05 +0100
Message-ID: <1480329606-6592-2-git-send-email-fw@strlen.de>
References: <1480329606-6592-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35036 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754289AbcK1Kjw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 05:39:52 -0500
In-Reply-To: <1480329606-6592-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The caller assumes that < 0 means that skb was stolen (or free'd).

All other return values continue skb processing.

nf_hook_slow returns 3 different return value types:

A) a (negative) errno value: the skb was dropped (NF_DROP, e.g.
by iptables '-j DROP' rule).

B) 0. The skb was stolen by the hook or queued to userspace.

C) 1. all hooks returned NF_ACCEPT so the caller should invoke
   the okfn so packet processing can continue.

nft ingress facility currently doesn't have the 'okfn' that
the NF_HOOK() macros use; there is no nfqueue support either.

So 1 means that nf_hook_ingress() caller should go on processing the skb.

In order to allow use of NF_STOLEN from ingress we need to translate
this to an errno number, else we'd crash because we continue with
already-free'd (or about to be free-d) skb.

Random dice roll has chosen EINPROGRESS.  The errno value isn't checked,
its just important that its less than 0.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_ingress.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index 2dc3b49b804a..d5027e470a24 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -19,6 +19,7 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 {
 	struct nf_hook_entry *e = rcu_dereference(skb->dev->nf_hooks_ingress);
 	struct nf_hook_state state;
+	int ret;
 
 	/* Must recheck the ingress hook head, in the event it became NULL
 	 * after the check in nf_hook_ingress_active evaluated to true.
@@ -29,7 +30,11 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	nf_hook_state_init(&state, NF_NETDEV_INGRESS,
 			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
 			   dev_net(skb->dev), NULL);
-	return nf_hook_slow(skb, &state, e);
+	ret = nf_hook_slow(skb, &state, e);
+	if (unlikely(ret == 0))
+		return -EINPROGRESS;
+
+	return ret;
 }
 
 static inline void nf_hook_ingress_init(struct net_device *dev)
-- 
2.7.3

