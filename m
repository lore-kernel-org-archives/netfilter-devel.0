From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 40/64]: ctnetlink: fix expectation timeout dumping
Date: Tue, 18 Dec 2007 00:47:07 +0100 (MET)
Message-ID: <20071217234707.23601.94188.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39005 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760395AbXLQXrI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:08 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ctnetlink: fix expectation timeout dumping

When the timer is late its timeout might be before the current time,
in which case a very large value is dumped.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 56ffe07f8708058c5aab185ea4658257a5b9f709
tree 18f33542fe1a7ef7ac0ea0840b9686264ed5655b
parent 94c79530c678600dc80eb1ce09df60e6b059cddd
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:27 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:57 +0100

 net/netfilter/nf_conntrack_netlink.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dcd0c9a..7501258 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1356,7 +1356,10 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
-	__be32 timeout = htonl((exp->timeout.expires - jiffies) / HZ);
+	long timeout = (exp->timeout.expires - jiffies) / HZ;
+
+	if (timeout < 0)
+		timeout = 0;
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nla_put_failure;
@@ -1367,7 +1370,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 				 CTA_EXPECT_MASTER) < 0)
 		goto nla_put_failure;
 
-	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, timeout);
+	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
 
 	return 0;
