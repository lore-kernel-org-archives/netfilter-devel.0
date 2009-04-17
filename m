From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: ctnetlink: report error if event message
	allocation fails
Date: Fri, 17 Apr 2009 11:05:27 +0200
Message-ID: <20090417090527.11291.46129.stgit@Decadence>
References: <20090417090010.11291.31173.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59146 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbZDQJFg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:05:36 -0400
In-Reply-To: <20090417090010.11291.31173.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes an inconsistency that results in no error reports
to user-space listeners if we fail to allocate the event message.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c6439c7..5e8503c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -512,7 +512,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 
 	skb = ctnetlink_alloc_skb(tuple(ct, IP_CT_DIR_ORIGINAL), GFP_ATOMIC);
 	if (!skb)
-		return NOTIFY_DONE;
+		goto errout;
 
 	b = skb->tail;
 
@@ -591,8 +591,9 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 nla_put_failure:
 	rcu_read_unlock();
 nlmsg_failure:
-	nfnetlink_set_err(0, group, -ENOBUFS);
 	kfree_skb(skb);
+errout:
+	nfnetlink_set_err(0, group, -ENOBUFS);
 	return NOTIFY_DONE;
 }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */

