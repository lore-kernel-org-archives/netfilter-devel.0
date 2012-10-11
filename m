From: pablo@netfilter.org
Subject: [PATCH 2/3] netfilter: nf_conntrack: fix racy timer handling with reliable events
Date: Thu, 11 Oct 2012 12:07:33 +0200
Message-ID: <1349950054-12353-3-git-send-email-pablo@netfilter.org>
References: <1349950054-12353-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289Ab2JKKHs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:07:48 -0400
In-Reply-To: <1349950054-12353-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira <pablo@netfilter.org>

Existing code assumes that del_timer returns true for alive conntrack
entries. However, this is not true if reliable events are enabled.
In that case, del_timer may return true for entries that were
just inserted in the dying list. Note that packets / ctnetlink may
hold references to conntrack entries that were just inserted to such
list.

This patch fixes the issue by adding an independent timer for
event delivery. This increases the size of the ecache extension.
Still we can revisit this later and use variable size extensions
to allocate this area on demand.

Tested-by: Oliver Smith <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h |    1 +
 net/netfilter/nf_conntrack_core.c           |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index e1ce104..4a045cd 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -18,6 +18,7 @@ struct nf_conntrack_ecache {
 	u16 ctmask;		/* bitmask of ct events to be delivered */
 	u16 expmask;		/* bitmask of expect events to be delivered */
 	u32 pid;		/* netlink pid of destroyer */
+	struct timer_list timeout;
 };
 
 static inline struct nf_conntrack_ecache *
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index cf48755..2ceec64 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -249,12 +249,15 @@ static void death_by_event(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
+
+	BUG_ON(ecache == NULL);
 
 	if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
 		/* bad luck, let's retry again */
-		ct->timeout.expires = jiffies +
+		ecache->timeout.expires = jiffies +
 			(random32() % net->ct.sysctl_events_retry_timeout);
-		add_timer(&ct->timeout);
+		add_timer(&ecache->timeout);
 		return;
 	}
 	/* we've got the event delivered, now it's dying */
@@ -268,6 +271,9 @@ static void death_by_event(unsigned long ul_conntrack)
 void nf_ct_insert_dying_list(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
+
+	BUG_ON(ecache == NULL);
 
 	/* add this conntrack to the dying list */
 	spin_lock_bh(&nf_conntrack_lock);
@@ -275,10 +281,10 @@ void nf_ct_insert_dying_list(struct nf_conn *ct)
 			     &net->ct.dying);
 	spin_unlock_bh(&nf_conntrack_lock);
 	/* set a new timer to retry event delivery */
-	setup_timer(&ct->timeout, death_by_event, (unsigned long)ct);
-	ct->timeout.expires = jiffies +
+	setup_timer(&ecache->timeout, death_by_event, (unsigned long)ct);
+	ecache->timeout.expires = jiffies +
 		(random32() % net->ct.sysctl_events_retry_timeout);
-	add_timer(&ct->timeout);
+	add_timer(&ecache->timeout);
 }
 EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
 
-- 
1.7.10.4

