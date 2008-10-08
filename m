From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 60/79: implement hotdrop for Ebtables
Date: Wed,  8 Oct 2008 12:47:42 +0200 (MEST)
Message-ID: <20081008104741.10423.15636.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46036 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYJHKrm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:42 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 5365f8022e04310f0276c95e82548da917d514db
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:16 2008 +0200

    netfilter: implement hotdrop for Ebtables
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c4f7a2e..7964d3f 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -78,9 +78,10 @@ static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
 
 static inline int ebt_do_match (struct ebt_entry_match *m,
    const struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out)
+   const struct net_device *out, bool *hotdrop)
 {
-	return m->u.match->match(skb, in, out, m->u.match, m->data, 0, 0, NULL);
+	return m->u.match->match(skb, in, out, m->u.match,
+	       m->data, 0, 0, hotdrop);
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
@@ -156,6 +157,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	struct ebt_entries *chaininfo;
 	char *base;
 	struct ebt_table_info *private;
+	bool hotdrop = false;
 
 	read_lock_bh(&table->lock);
 	private = table->private;
@@ -176,8 +178,13 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		if (ebt_basic_match(point, eth_hdr(skb), in, out))
 			goto letscontinue;
 
-		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, in, out) != 0)
+		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb,
+		    in, out, &hotdrop) != 0)
 			goto letscontinue;
+		if (hotdrop) {
+			read_unlock_bh(&table->lock);
+			return NF_DROP;
+		}
 
 		/* increase counter */
 		(*(counter_base + i)).pcnt++;
