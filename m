From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ipv6: nf_defrag: drop mangled skb on ream error
Date: Tue, 29 Nov 2016 02:17:34 +0100
Message-ID: <1480382254-13277-1-git-send-email-fw@strlen.de>
Cc: andreyknvl@google.com, dvyukov@google.com, eric.dumazet@gmail.com,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39262 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754574AbcK2BRR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 20:17:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dmitry Vyukov reported GPF in network stack that Andrey traced down to
negative nh offset in nf_ct_frag6_queue().

Problem is that all network headers before fragment header are pulled.
Normal ipv6 reassembly will drop the skb when errors occur further down
the line.

netfilter doesn't do this, and instead passed the original fragment
along.  That was also fine back when netfilter ipv6 defrag worked with
cloned fragments, as the original, pristine fragment was passed on.

So we either have to undo the pull op, or discard such fragments.
Since they're malformed after all (e.g. overlapping fragment) it seems
preferrable to just drop them.

Same for temporary errors -- it doesn't make sense to accept (and
perhaps forward!) only some fragments of same datagram.

Fixes: 029f7f3b8701cc7ac ("netfilter: ipv6: nf_defrag: avoid/free clone operations")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Debugged-by: Andrey Konovalov <andreyknvl@google.com>
Diagnosed-by: Eric Dumazet <Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 KASAN no longer complains, ping6 -s $bignum still works and gets picked up
 by ipv6 conntrack.

 Eric, I did think about changing nf_ct_frag6_gather but since its not a
 netfilter hook a hook retval doesn't seem to be appropriate (and also
 increases patch size).

 This doesn't conflict with recent
 'openvswitch: Fix skb leak in IPv6 reassembly' patch.

 net/ipv6/netfilter/nf_conntrack_reasm.c   | 4 ++--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index e4347aeb2e65..9948b5ce52da 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -576,11 +576,11 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	/* Jumbo payload inhibits frag. header */
 	if (ipv6_hdr(skb)->payload_len == 0) {
 		pr_debug("payload len = 0\n");
-		return -EINVAL;
+		return 0;
 	}
 
 	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0)
-		return -EINVAL;
+		return 0;
 
 	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index f7aab5ab93a5..f06b0471f39f 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -69,7 +69,7 @@ static unsigned int ipv6_defrag(void *priv,
 	if (err == -EINPROGRESS)
 		return NF_STOLEN;
 
-	return NF_ACCEPT;
+	return err == 0 ? NF_ACCEPT : NF_DROP;
 }
 
 static struct nf_hook_ops ipv6_defrag_ops[] = {
-- 
2.7.3

