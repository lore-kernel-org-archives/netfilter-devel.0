From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/23] netfilter: ipv6: nf_defrag: fix NULL deref panic
Date: Fri, 18 Dec 2015 21:26:42 +0100
Message-ID: <1450470409-31427-17-git-send-email-pablo@netfilter.org>
References: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.1.4
