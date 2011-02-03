From: Pierre Chifflier <chifflier@edenwall.com>
Subject: [PATCH 1/3] Make the afinfo structure optional in nf_queue and nf_reinject
Date: Thu,  3 Feb 2011 15:32:18 +0100
Message-ID: <1296743540-8148-2-git-send-email-chifflier@edenwall.com>
References: <4D49E1E0.50304@trash.net>
Cc: Pierre Chifflier <chifflier@edenwall.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:44572 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756209Ab1BCPMD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:12:03 -0500
Received: from [88.171.131.12] (helo=fydelkass.edenwall.com)
	by sd-6807.edenwall.com with esmtp (Exim 4.69)
	(envelope-from <chifflier@edenwall.com>)
	id 1Pl0ER-0007TY-6t
	for netfilter-devel@vger.kernel.org; Thu, 03 Feb 2011 15:32:23 +0100
In-Reply-To: <4D49E1E0.50304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Packets coming from the bridge do not have an afinfo registered,
so make the call to get the structure optional.

Signed-off-by: Pierre Chifflier <chifflier@edenwall.com>
---
 net/netfilter/nf_queue.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 5ab22e2..a725487 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -131,8 +131,9 @@ static int __nf_queue(struct sk_buff *skb,
 	struct net_device *physindev;
 	struct net_device *physoutdev;
 #endif
-	const struct nf_afinfo *afinfo;
+	const struct nf_afinfo *afinfo = NULL;
 	const struct nf_queue_handler *qh;
+	int route_key_size = 0;
 
 	/* QUEUE == DROP if noone is waiting, to be safe. */
 	rcu_read_lock();
@@ -144,10 +145,10 @@ static int __nf_queue(struct sk_buff *skb,
 	}
 
 	afinfo = nf_get_afinfo(pf);
-	if (!afinfo)
-		goto err_unlock;
+	if (afinfo)
+		route_key_size = afinfo->route_key_size;
 
-	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
 	if (!entry) {
 		status = -ENOMEM;
 		goto err_unlock;
@@ -184,7 +185,8 @@ static int __nf_queue(struct sk_buff *skb,
 	}
 #endif
 	skb_dst_force(skb);
-	afinfo->saveroute(skb, entry);
+	if (afinfo)
+		afinfo->saveroute(skb, entry);
 	status = qh->outfn(entry, queuenum);
 
 	rcu_read_unlock();
@@ -264,7 +266,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct sk_buff *skb = entry->skb;
 	struct list_head *elem = &entry->elem->list;
-	const struct nf_afinfo *afinfo;
+	const struct nf_afinfo *afinfo = NULL;
 	int err;
 
 	rcu_read_lock();
@@ -279,7 +281,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	if (verdict == NF_ACCEPT) {
 		afinfo = nf_get_afinfo(entry->pf);
-		if (!afinfo || afinfo->reroute(skb, entry) < 0)
+		if (afinfo && afinfo->reroute(skb, entry) < 0)
 			verdict = NF_DROP;
 	}
 
-- 
1.7.2.3

