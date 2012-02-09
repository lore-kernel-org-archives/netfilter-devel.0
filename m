From: pablo@netfilter.org
Subject: [PATCH 6/6] netfilter: ctnetlink: support kernel-space dump filterings
Date: Thu,  9 Feb 2012 20:33:07 +0100
Message-ID: <1328815987-28020-7-git-send-email-pablo@netfilter.org>
References: <1328815987-28020-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57826 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab2BITdj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:33:39 -0500
In-Reply-To: <1328815987-28020-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds CTA_MARK_MASK which, together with CTA_MARK, allows
you to selectively send conntrack entries to user-space by
returning those that match mark & mask.

With this, we can save cycles in the building and the parsing of
the entries that may be later on filtered out in user-space by using
the mark & mask.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_netlink.c          |   35 +++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 5ec1abc..e58e4b9 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -43,6 +43,7 @@ enum ctattr_type {
 	CTA_ZONE,
 	CTA_SECCTX,
 	CTA_TIMESTAMP,
+	CTA_MARK_MASK,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d7301f7..a823540 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -691,9 +691,18 @@ static int ctnetlink_done(struct netlink_callback *cb)
 {
 	if (cb->args[1])
 		nf_ct_put((struct nf_conn *)cb->args[1]);
+	if (cb->data)
+		kfree(cb->data);
 	return 0;
 }
 
+struct ctnetlink_dump_filter {
+	struct {
+		u_int32_t value;
+		u_int32_t mask;
+	} mark;
+};
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -703,6 +712,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct hlist_nulls_node *n;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
+	const struct ctnetlink_dump_filter *filter = cb->data;
 
 	spin_lock_bh(&nf_conntrack_lock);
 	last = (struct nf_conn *)cb->args[1];
@@ -723,6 +733,10 @@ restart:
 					continue;
 				cb->args[1] = 0;
 			}
+			if (filter->mark.mask &&
+			    !(filter->mark.value ==
+					(ct->mark & filter->mark.mask)))
+				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 						cb->nlh->nlmsg_seq,
 						NFNL_MSG_TYPE(
@@ -894,6 +908,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 	[CTA_NAT_DST]		= { .type = NLA_NESTED },
 	[CTA_TUPLE_MASTER]	= { .type = NLA_NESTED },
 	[CTA_ZONE]		= { .type = NLA_U16 },
+	[CTA_MARK_MASK]		= { .type = NLA_U32 },
 };
 
 static int
@@ -977,9 +992,25 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	u16 zone;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP)
+	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct ctnetlink_dump_filter *filter = NULL;
+
+#if defined(CONFIG_NF_CONNTRACK_MARK)
+		filter = kzalloc(sizeof(struct ctnetlink_dump_filter),
+				 GFP_KERNEL);
+		if (filter == NULL)
+			return -ENOMEM;
+
+		if (cda[CTA_MARK])
+			filter->mark.value = ntohl(nla_get_be32(cda[CTA_MARK]));
+		if (cda[CTA_MARK_MASK]) {
+			filter->mark.mask =
+				ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+		}
+#endif
 		return netlink_dump_start(ctnl, skb, nlh, ctnetlink_dump_table,
-					  ctnetlink_done, NULL, 0);
+					  ctnetlink_done, filter, 0);
+	}
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
 	if (err < 0)
-- 
1.7.7.3

