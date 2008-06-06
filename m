From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/03: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()
Date: Fri,  6 Jun 2008 19:18:45 +0200 (MEST)
Message-ID: <20080606171843.28097.94850.sendpatchset@localhost.localdomain>
References: <20080606171839.28097.47793.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51328 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYFFRSq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:18:46 -0400
In-Reply-To: <20080606171839.28097.47793.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()

Upstream commit b9c698964614f71b9c8afeca163a945b4c2e2d20:

[   63.531438] =================================
[   63.531520] [ INFO: inconsistent lock state ]
[   63.531520] 2.6.26-rc4 #7
[   63.531520] ---------------------------------
[   63.531520] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
[   63.531520] tcpsic6/3864 [HC0[0]:SC1[1]:HE1:SE0] takes:
[   63.531520]  (&q->lock#2){-+..}, at: [<c07175b0>] ipv6_frag_rcv+0xd0/0xbd0
[   63.531520] {softirq-on-W} state was registered at:
[   63.531520]   [<c0143bba>] __lock_acquire+0x3aa/0x1080
[   63.531520]   [<c0144906>] lock_acquire+0x76/0xa0
[   63.531520]   [<c07a8f0b>] _spin_lock+0x2b/0x40
[   63.531520]   [<c0727636>] nf_ct_frag6_gather+0x3f6/0x910
 ...

According to this and another similar lockdep report inet_fragment
locks are taken from nf_ct_frag6_gather() with softirqs enabled, but
these locks are mainly used in softirq context, so disabling BHs is
necessary.

Reported-and-tested-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 172060857e309af8d2300eea08b64cc3aea69895
tree 32bd685ce49c758bd0c9e9e93509296e7519903e
parent 8a39ae5d24374801df08b7aa634ca03080e6b72a
author Jarek Poplawski <jarkao2@gmail.com> Fri, 06 Jun 2008 19:07:57 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 19:07:57 +0200

 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 24c0d03..b8a917b 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -209,7 +209,9 @@ fq_find(__be32 id, struct in6_addr *src, struct in6_addr *dst)
 	arg.dst = dst;
 	hash = ip6qhashfn(id, src, dst);
 
+	local_bh_disable();
 	q = inet_frag_find(&nf_init_frags, &nf_frags, &arg, hash);
+	local_bh_enable();
 	if (q == NULL)
 		goto oom;
 
@@ -638,10 +640,10 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 		goto ret_orig;
 	}
 
-	spin_lock(&fq->q.lock);
+	spin_lock_bh(&fq->q.lock);
 
 	if (nf_ct_frag6_queue(fq, clone, fhdr, nhoff) < 0) {
-		spin_unlock(&fq->q.lock);
+		spin_unlock_bh(&fq->q.lock);
 		pr_debug("Can't insert skb to queue\n");
 		fq_put(fq);
 		goto ret_orig;
@@ -652,7 +654,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 		if (ret_skb == NULL)
 			pr_debug("Can't reassemble fragmented packets\n");
 	}
-	spin_unlock(&fq->q.lock);
+	spin_unlock_bh(&fq->q.lock);
 
 	fq_put(fq);
 	return ret_skb;
