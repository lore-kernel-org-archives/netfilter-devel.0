From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] netfilter: ctnetlink: send event when conntrack label was modified
Date: Fri, 21 Jun 2013 16:51:30 +0200
Message-ID: <1371826290-302-1-git-send-email-fw@strlen.de>
References: <y>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40868 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161419Ab3FUOtp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:49:45 -0400
In-Reply-To: <y>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
---
 net/netfilter/nf_conntrack_labels.c  |    2 +-
 net/netfilter/nf_conntrack_netlink.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

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
index 6d0f8a1..ecf065f 100644
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
1.7.8.6

