From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: ctnetlink: report error if event message
 allocation fails
Date: Fri, 17 Apr 2009 11:17:24 +0200
Message-ID: <49E84924.9010000@netfilter.org>
References: <20090417090010.11291.31173.stgit@Decadence> <20090417090527.11291.46129.stgit@Decadence>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000607060608030601060903"
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60373 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbZDQJRe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:17:34 -0400
In-Reply-To: <20090417090527.11291.46129.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000607060608030601060903
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> This patch fixes an inconsistency that results in no error reports
> to user-space listeners if we fail to allocate the event message.

I was missing the expectation part. New patch attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------000607060608030601060903
Content-Type: text/x-diff;
 name="ctnl-alloc-fails-report-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnl-alloc-fails-report-error.patch"

netfilter: ctnetlink: report error if event message allocation fails

This patch fixes an inconsistency that results in no error reports
to user-space listeners if we fail to allocate the event message.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c6439c7..0ea36e0 100644
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
@@ -1564,7 +1565,7 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
-		return NOTIFY_DONE;
+		goto errout;
 
 	b = skb->tail;
 
@@ -1589,8 +1590,9 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 nla_put_failure:
 	rcu_read_unlock();
 nlmsg_failure:
-	nfnetlink_set_err(0, 0, -ENOBUFS);
 	kfree_skb(skb);
+errout:
+	nfnetlink_set_err(0, 0, -ENOBUFS);
 	return NOTIFY_DONE;
 }
 #endif

--------------000607060608030601060903--
