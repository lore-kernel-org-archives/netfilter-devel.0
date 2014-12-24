From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH v2 1/2] conntrack: Flush connections with a given mark
Date: Wed, 24 Dec 2014 09:57:10 +0100
Message-ID: <1419411431-24715-2-git-send-email-kristian.evensen@gmail.com>
References: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42649 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaLXI5W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:57:22 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so13002106wiw.15
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Dec 2014 00:57:20 -0800 (PST)
In-Reply-To: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for selective flushing of conntrack mappings. By adding
CTA_MARK and CTA_MARK_MASK to a delete-message, the mark (and mask) is checked
before a connection is deleted while flushing.

Configuring the flush is moved out of ctnetlink_del_conntrack(), and instead of
calling nf_conntrack_flush_report(), we always call nf_ct_iterate_cleanup().
This enables us to only make one call from the new ctnetlink_flush_conntrack()
and makes it easy to add more filter parameters.

Filtering is done in the ctnetlink_apply_filter()-function, which is also called
from ctnetlink_dump_table(). ctnetlink_dump_filter has been renamed
ctnetlink_filter, to indicated that it is no longer only used when dumping
conntrack entries.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 57 ++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1bd9ed9..85046d3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -749,13 +749,29 @@ static int ctnetlink_done(struct netlink_callback *cb)
 	return 0;
 }
 
-struct ctnetlink_dump_filter {
+struct ctnetlink_filter {
 	struct {
 		u_int32_t val;
 		u_int32_t mask;
 	} mark;
 };
 
+static int ctnetlink_apply_filter(struct nf_conn *i, void *data)
+{
+	struct ctnetlink_filter *filter = data;
+
+	if (!filter)
+		return 1;
+
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if ((filter->mark.val && filter->mark.mask) &&
+	    (i->mark & filter->mark.mask) != filter->mark.val)
+		return 0;
+#endif
+
+	return 1;
+}
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -769,7 +785,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	spinlock_t *lockp;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	const struct ctnetlink_dump_filter *filter = cb->data;
+	const struct ctnetlink_filter *filter = cb->data;
 #endif
 
 	last = (struct nf_conn *)cb->args[1];
@@ -799,10 +815,9 @@ restart:
 				cb->args[1] = 0;
 			}
 #ifdef CONFIG_NF_CONNTRACK_MARK
-			if (filter && !((ct->mark & filter->mark.mask) ==
-					filter->mark.val)) {
+			if (filter &&
+			    !ctnetlink_apply_filter(ct, (void *)filter))
 				continue;
-			}
 #endif
 			rcu_read_lock();
 			res =
@@ -1001,6 +1016,25 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 };
 
+static void ctnetlink_flush_conntrack(struct net *net,
+				      const struct nlattr * const cda[],
+				      u32 portid, int report)
+{
+	struct ctnetlink_filter filter;
+
+	memset(&filter, 0, sizeof(filter));
+
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
+		filter.mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
+		filter.mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+	}
+#endif
+
+	nf_ct_iterate_cleanup(net, ctnetlink_apply_filter, &filter,
+			      portid, report);
+}
+
 static int
 ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			const struct nlmsghdr *nlh,
@@ -1024,10 +1058,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else {
-		/* Flush the whole table */
-		nf_conntrack_flush_report(net,
-					 NETLINK_CB(skb).portid,
-					 nlmsg_report(nlh));
+		/* Flush the table */
+		ctnetlink_flush_conntrack(net, cda, NETLINK_CB(skb).portid,
+					  nlmsg_report(nlh));
 		return 0;
 	}
 
@@ -1075,13 +1108,13 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_dump_table,
 			.done = ctnetlink_done,
+			.data = NULL,
 		};
 #ifdef CONFIG_NF_CONNTRACK_MARK
 		if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
-			struct ctnetlink_dump_filter *filter;
+			struct ctnetlink_filter *filter;
 
-			filter = kzalloc(sizeof(struct ctnetlink_dump_filter),
-					 GFP_ATOMIC);
+			filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
 			if (filter == NULL)
 				return -ENOMEM;
 
-- 
2.1.0

