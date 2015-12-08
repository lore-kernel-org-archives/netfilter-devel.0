From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ipv6: nf_defrag: fix NULL deref panic
Date: Tue,  8 Dec 2015 23:35:19 +0100
Message-ID: <1449614119-5584-1-git-send-email-fw@strlen.de>
Cc: Valdis.Kletnieks@vt.edu, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42396 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbbLHWfZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Dec 2015 17:35:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valdis reports NULL deref in nf_ct_frag6_gather.
Problem is bogus use of skb_queue_walk() -- we miss first skb in the list
since we start with head->next instead of head.

In case the element we're looking for was head->next we won't find
a result and then trip over NULL iter.

(defrag uses plain NULL-terminated list rather than one terminated by
 head-of-list-pointer, which is what skb_queue_walk expects).

Fixes: 029f7f3b8701cc7a ("netfilter: ipv6: nf_defrag: avoid/free clone operations")
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 nf-next since the faulty commit is only present there.

 net/ipv6/netfilter/nf_conntrack_reasm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 912bc3a..6e5f0e0d 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -441,11 +441,14 @@ nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *prev,  struct net_devic
 			return false;
 
 		fp->next = prev->next;
-		skb_queue_walk(head, iter) {
-			if (iter->next != prev)
-				continue;
-			iter->next = fp;
-			break;
+
+		iter = head;
+		while (iter) {
+			if (iter->next == prev) {
+				iter->next = fp;
+				break;
+			}
+			iter = iter->next;
 		}
 
 		skb_morph(prev, head);
-- 
2.4.10

