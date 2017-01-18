From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ctnetlink: make more information available in DESTROY events
Date: Wed, 18 Jan 2017 15:54:32 +0100
Message-ID: <1484751272-5489-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>, Jarno Rajahalme <jarno@ovn.org>,
        Victor Julien <lists@inliniac.net>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:32886 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752390AbdAROyZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 09:54:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

destroy events currently don't contain the tcp state info and no
secmark and conntrack labels.

Quoting Victor:
 "I was hoping to get the last TCP state in a conntrack destroy event,
  however it seems to be unavailable."

Quoting Jarno:
 "I have a use case where we want to log terminating connections, but
 only if a specific label bit is set."

While at it, also include SECMARK in destroy events if one is available.

Cc: Jarno Rajahalme <jarno@ovn.org>
Cc: Victor Julien <lists@inliniac.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 27540455dc62..b984c1b5b3ec 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -347,7 +347,7 @@ static inline int ctnetlink_label_size(const struct nf_conn *ct)
 }
 
 static int
-ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
+ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct, bool force)
 {
 	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
 	unsigned int i;
@@ -357,7 +357,7 @@ ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
 
 	i = 0;
 	do {
-		if (labels->bits[i] != 0)
+		if (labels->bits[i] != 0 || force)
 			return nla_put(skb, CTA_LABELS, sizeof(labels->bits),
 				       labels->bits);
 		i++;
@@ -366,7 +366,7 @@ ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
 	return 0;
 }
 #else
-#define ctnetlink_dump_labels(a, b) (0)
+#define ctnetlink_dump_labels(a, b, c) (0)
 #define ctnetlink_label_size(a)	(0)
 #endif
 
@@ -511,7 +511,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
-	    ctnetlink_dump_labels(skb, ct) < 0 ||
+	    ctnetlink_dump_labels(skb, ct, false) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
 	    ctnetlink_dump_master(skb, ct) < 0 ||
@@ -697,7 +697,8 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 
 	if (events & (1 << IPCT_DESTROY)) {
 		if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
-		    ctnetlink_dump_timestamp(skb, ct) < 0)
+		    ctnetlink_dump_timestamp(skb, ct) < 0 ||
+		    ctnetlink_dump_protoinfo(skb, ct) < 0)
 			goto nla_put_failure;
 	} else {
 		if (ctnetlink_dump_timeout(skb, ct) < 0)
@@ -711,15 +712,6 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 			goto nla_put_failure;
 
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
-		if ((events & (1 << IPCT_SECMARK) || ct->secmark)
-		    && ctnetlink_dump_secctx(skb, ct) < 0)
-			goto nla_put_failure;
-#endif
-		if (events & (1 << IPCT_LABEL) &&
-		     ctnetlink_dump_labels(skb, ct) < 0)
-			goto nla_put_failure;
-
 		if (events & (1 << IPCT_RELATED) &&
 		    ctnetlink_dump_master(skb, ct) < 0)
 			goto nla_put_failure;
@@ -734,6 +726,14 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	    && ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	if ((events & (1 << IPCT_SECMARK) || ct->secmark) &&
+	    ctnetlink_dump_secctx(skb, ct) < 0)
+		goto nla_put_failure;
+#endif
+	if (ctnetlink_dump_labels(skb, ct, events & (1 << IPCT_LABEL)) < 0)
+		goto nla_put_failure;
+
 	rcu_read_unlock();
 
 	nlmsg_end(skb, nlh);
@@ -2234,7 +2234,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 	if (ct->mark && ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
-	if (ctnetlink_dump_labels(skb, ct) < 0)
+	if (ctnetlink_dump_labels(skb, ct, false) < 0)
 		goto nla_put_failure;
 	rcu_read_unlock();
 	return 0;
-- 
2.7.3

