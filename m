From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 49/69]: nf_conntrack_netlink: transmit mark during all events
Date: Wed, 30 Jan 2008 21:18:09 +0100 (MET)
Message-ID: <20080130201807.29874.92259.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbYA3USK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:10 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_netlink: transmit mark during all events

The following feature was submitted some months ago. It forces the dump
of mark during the connection destruction event. The induced load is
quiet small and the patch is usefull to provide an easy way to filter
event on user side without having to keep an hash in userspace.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8bf50a16334291fa18d090ad11221e802327b26f
tree 41e125cf8230f6ffd0cc8f94679247e82c2c57c4
parent bc81193022f55c5cc719728b1bdf67648054bce6
author Eric Leblond <eric@inl.fr> Tue, 29 Jan 2008 16:22:16 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:11 +0100

 net/netfilter/nf_conntrack_netlink.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bf86fdd..4a1b42b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -491,11 +491,6 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 			goto nla_put_failure;
 
-#ifdef CONFIG_NF_CONNTRACK_MARK
-		if ((events & IPCT_MARK || ct->mark)
-		    && ctnetlink_dump_mark(skb, ct) < 0)
-			goto nla_put_failure;
-#endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 		if ((events & IPCT_SECMARK || ct->secmark)
 		    && ctnetlink_dump_secmark(skb, ct) < 0)
@@ -516,6 +511,12 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 			goto nla_put_failure;
 	}
 
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if ((events & IPCT_MARK || ct->mark)
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nla_put_failure;
+#endif
+
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
 	return NOTIFY_DONE;
