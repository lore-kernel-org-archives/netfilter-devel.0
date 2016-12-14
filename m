From: joseph.j.conley@gmail.com
Subject: [PATCH] netfilter: conntrack: Fix ifdef checks for CONFIG_NF_CONNTRACK_MARK
Date: Wed, 14 Dec 2016 16:35:57 -0500
Message-ID: <1481751357-22893-1-git-send-email-joseph.j.conley@gmail.com>
Cc: Joe Conley <joe.conley@lairdtech.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33699 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752925AbcLNViS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Dec 2016 16:38:18 -0500
Received: by mail-io0-f195.google.com with SMTP id p13so6410598ioi.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 13:38:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Joe Conley <joe.conley@lairdtech.com>

Two missing ifdef checks for CONFIG_NF_CONNTRACK_MARK were causing
EOPNOTSUPP to be returned. Every single place that cda[CTA_MARK] or cda[CTA_MARK_MASK]
was checked was inside a #ifdef for CONFIG_NF_CONNTRACK_MARK except for these
two places. The reason for this change stems from this commit:
866476f323465a8afef10b14b48d5136bf5c51fe (netfilter: conntrack: Flush connections with a given mark)

This allows conntrack -L to be ran succesfully when CONFIG_NF_CONNTRACK_MARK
is not enabled.

Signed-off-by: Joe Conley <joe.conley@lairdtech.com>
---
 net/netfilter/nf_conntrack_netlink.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2754045..94146bd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1107,13 +1107,13 @@ static int ctnetlink_flush_conntrack(struct net *net,
 				     u32 portid, int report)
 {
 	struct ctnetlink_filter *filter = NULL;
-
+#ifdef CONFIG_NF_CONNTRACK_MARK
 	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
 		filter = ctnetlink_alloc_filter(cda);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
 	}
-
+#endif
 	nf_ct_iterate_cleanup(net, ctnetlink_filter_match, filter,
 			      portid, report);
 	kfree(filter);
@@ -1192,7 +1192,7 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 			.dump = ctnetlink_dump_table,
 			.done = ctnetlink_done,
 		};
-
+#ifdef CONFIG_NF_CONNTRACK_MARK
 		if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
 			struct ctnetlink_filter *filter;

@@ -1202,6 +1202,7 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,

 			c.data = filter;
 		}
+#endif
 		return netlink_dump_start(ctnl, skb, nlh, &c);
 	}

--
2.7.4

