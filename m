From: Jan Engelhardt <jengelh@medozas.de>
Subject: 09/11 [NETFILTER]: Implement hotdrop for Ebtables
Date: Wed, 10 Sep 2008 22:45:58 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809102245520.8838@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36413 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYIKCqA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:46:00 -0400
In-Reply-To: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit e1a72f21ba58aca6980681ac745e2b046a4cc37c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Sep 10 22:35:22 2008 -0400

[NETFILTER]: Implement hotdrop for Ebtables

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtables.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index e45d787..2bf098a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -77,9 +77,10 @@ static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
 
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
@@ -155,6 +156,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	struct ebt_entries *chaininfo;
 	char *base;
 	struct ebt_table_info *private;
+	bool hotdrop = false;
 
 	read_lock_bh(&table->lock);
 	private = table->private;
@@ -175,8 +177,13 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
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
