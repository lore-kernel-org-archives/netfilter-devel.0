From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: nf_conntrack_ipv6: fix inconsistent lock state
 in nf_ct_frag6_gather()
Date: Wed, 04 Jun 2008 18:17:57 +0200
Message-ID: <4846C035.8040607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080202030004020702080009"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbYFDQR7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:17:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080202030004020702080009
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------080202030004020702080009
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()

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
commit fce449632252673d7cd005c113f00c2b7d0e224c
tree 7f346aea214c68fcdc521b40a7348c7af6e03706
parent df31d38473b31c8c18449419fbe9af219f3579f3
author Jarek Poplawski <jarkao2@gmail.com> Mon, 02 Jun 2008 16:47:27 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 02 Jun 2008 16:47:27 +0200

 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 2dccad4..e65e26e 100644
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
@@ -653,7 +655,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 		if (ret_skb == NULL)
 			pr_debug("Can't reassemble fragmented packets\n");
 	}
-	spin_unlock(&fq->q.lock);
+	spin_unlock_bh(&fq->q.lock);
 
 	fq_put(fq);
 	return ret_skb;

--------------080202030004020702080009--
