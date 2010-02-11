From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/08: ctnetlink: dump expectation helper name
Date: Thu, 11 Feb 2010 08:39:37 +0100 (MET)
Message-ID: <20100211073933.7894.28808.sendpatchset@x2.localnet>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35441 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0BKHjj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 02:39:39 -0500
In-Reply-To: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 3844404984222e1b9e6c32b90592fa7ecb51ee28
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Feb 11 07:40:29 2010 +0100

    netfilter: ctnetlink: dump expectation helper name
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5c103b8..db35eda 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1512,6 +1512,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
+	struct nf_conntrack_helper *helper;
 	long timeout = (exp->timeout.expires - jiffies) / HZ;
 
 	if (timeout < 0)
@@ -1528,6 +1529,9 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 
 	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
+	helper = rcu_dereference(nfct_help(master)->helper);
+	if (helper)
+		NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
 
 	return 0;
 
