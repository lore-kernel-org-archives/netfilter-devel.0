From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/23] netfilter: implement hotdrop for Ebtables
Date: Mon,  6 Oct 2008 08:15:07 -0400
Message-ID: <832869e20bfc3ecc3994998ff0e9c3593cb0ee1e.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57091 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYJFMP3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:29 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/bridge/netfilter/ebtables.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index d12ad58..47624b1 100644
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
-- 
1.6.0.1

