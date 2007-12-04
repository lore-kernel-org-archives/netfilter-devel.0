From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/49]: nf_queue: remove unnecessary hook existance check
Date: Tue,  4 Dec 2007 13:02:30 +0100 (MET)
Message-ID: <20071204120230.2442.37748.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbXLDMCc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:32 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: remove unnecessary hook existance check

We hold a module reference for each queued packet, so the hook that
queued the packet can't disappear. Also remove an obsolete  comment
stating the opposite.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4e99305d42d41620d4009da54be297970da7c0f7
tree 0794bda7d7cfe7c93a07e671b1b3d6a93460d54c
parent 327c86b66756bd289a3ddde5f390411406534acf
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:24 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:30:42 +0100

 net/netfilter/core.c     |    5 -----
 net/netfilter/nf_queue.c |   13 -------------
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index e6d3a69..6819a41 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -51,11 +51,6 @@ void nf_unregister_afinfo(struct nf_afinfo *afinfo)
 }
 EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
 
-/* In this code, we can be waiting indefinitely for userspace to
- * service a packet if a hook returns NF_QUEUE.  We could keep a count
- * of skbuffs queued for userspace, and not deregister a hook unless
- * this is zero, but that sucks.  Now, we simply check when the
- * packets come back: if the hook is gone, the packet is discarded. */
 struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS] __read_mostly;
 EXPORT_SYMBOL(nf_hooks);
 static DEFINE_MUTEX(nf_hook_mutex);
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 81d010a..0bea88c 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -223,7 +223,6 @@ void nf_reinject(struct sk_buff *skb, struct nf_info *info,
 		 unsigned int verdict)
 {
 	struct list_head *elem = &info->elem->list;
-	struct list_head *i;
 	struct nf_afinfo *afinfo;
 
 	rcu_read_lock();
@@ -245,18 +244,6 @@ void nf_reinject(struct sk_buff *skb, struct nf_info *info,
 	/* Drop reference to owner of hook which queued us. */
 	module_put(info->elem->owner);
 
-	list_for_each_rcu(i, &nf_hooks[info->pf][info->hook]) {
-		if (i == elem)
-			break;
-	}
-
-	if (i == &nf_hooks[info->pf][info->hook]) {
-		/* The module which sent it to userspace is gone. */
-		NFDEBUG("%s: module disappeared, dropping packet.\n",
-			__FUNCTION__);
-		verdict = NF_DROP;
-	}
-
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT) {
 		elem = elem->prev;
