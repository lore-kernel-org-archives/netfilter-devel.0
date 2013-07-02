From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 15/15] netfilter: ctnetlink: send event when conntrack label was modified
Date: Tue,  2 Jul 2013 16:51:05 +0200
Message-ID: <1372776665-6795-15-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 0ceabd83875b72a29f33db4ab703d6ba40ea4c58
(netfilter: ctnetlink: deliver labels to userspace) sets the event bit
when we raced with another packet, instead of raising the event bit
when the label bit is set for the first time.

commit 9b21f6a90924dfe8e5e686c314ddb441fb06501e
(netfilter: ctnetlink: allow userspace to modify labels) forgot to update
the event mask in the "conntrack already exists" case.

Both issues result in CTA_LABELS attribute not getting included in the
conntrack event.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: 797a7d66d2048fe8a4ac1ba58c5d4752d64b1ac4

 net/netfilter/nf_conntrack_labels.c  |    2 +-
 net/netfilter/nf_conntrack_netlink.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 8fe2e99..355d2ef 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -45,7 +45,7 @@ int nf_connlabel_set(struct nf_conn *ct, u16 bit)
 	if (test_bit(bit, labels->bits))
 		return 0;
 
-	if (test_and_set_bit(bit, labels->bits))
+	if (!test_and_set_bit(bit, labels->bits))
 		nf_conntrack_event_cache(IPCT_LABEL, ct);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9904b15..23af264 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1825,6 +1825,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |
 						      (1 << IPCT_ASSURED) |
 						      (1 << IPCT_HELPER) |
+						      (1 << IPCT_LABEL) |
 						      (1 << IPCT_PROTOINFO) |
 						      (1 << IPCT_NATSEQADJ) |
 						      (1 << IPCT_MARK),
-- 
1.7.10.4
