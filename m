From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 39/50] netfilter: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()
Date: Fri, 06 Jun 2008 18:02:54 -0700
Message-ID: <20080607010628.820120470@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:42541 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198AbYFGBJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:26 -0400
Content-Disposition: inline; filename=netfilter-nf_conntrack_ipv6-fix-inconsistent-lock-state-in-nf_ct_frag6_gather.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

upstream commit: b9c698964614f71b9c8afeca163a945b4c2e2d20

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -209,7 +209,9 @@ fq_find(__be32 id, struct in6_addr *src,
 	arg.dst = dst;
 	hash = ip6qhashfn(id, src, dst);
 
+	local_bh_disable();
 	q = inet_frag_find(&nf_init_frags, &nf_frags, &arg, hash);
+	local_bh_enable();
 	if (q == NULL)
 		goto oom;
 
@@ -638,10 +640,10 @@ struct sk_buff *nf_ct_frag6_gather(struc
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
@@ -652,7 +654,7 @@ struct sk_buff *nf_ct_frag6_gather(struc
 		if (ret_skb == NULL)
 			pr_debug("Can't reassemble fragmented packets\n");
 	}
-	spin_unlock(&fq->q.lock);
+	spin_unlock_bh(&fq->q.lock);
 
 	fq_put(fq);
 	return ret_skb;

-- 
