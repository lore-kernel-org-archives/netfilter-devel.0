From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 048/103] netfilter: ebtables: change ebt_basic_match to xt convention
Date: Tue,  4 Aug 2009 09:25:32 +0200
Message-ID: <1249370787-17583-49-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbZHDH1Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:25 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When this will become an xt_match, it needs the xt semantics;
this mandates changing the return values from 1/0 to 0/1.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtables.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index df68825..9f871e4 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -101,7 +101,7 @@ ebt_dev_check(const char *entry, const struct net_device *device)
 
 #define FWINV2(bool,invflg) ((bool) ^ !!(e->invflags & invflg))
 /* process standard matches */
-static inline int
+static inline bool
 ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
                 const struct net_device *in, const struct net_device *out)
 {
@@ -109,21 +109,21 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 
 	if (e->bitmask & EBT_802_3) {
 		if (FWINV2(ntohs(h->h_proto) >= 1536, EBT_IPROTO))
-			return 1;
+			return false;
 	} else if (!(e->bitmask & EBT_NOPROTO) &&
 	   FWINV2(e->ethproto != h->h_proto, EBT_IPROTO))
-		return 1;
+		return false;
 
 	if (FWINV2(ebt_dev_check(e->in, in), EBT_IIN))
-		return 1;
+		return false;
 	if (FWINV2(ebt_dev_check(e->out, out), EBT_IOUT))
-		return 1;
+		return false;
 	if ((!in || !in->br_port) ? 0 : FWINV2(ebt_dev_check(
 	   e->logical_in, in->br_port->br->dev), EBT_ILOGICALIN))
-		return 1;
+		return false;
 	if ((!out || !out->br_port) ? 0 : FWINV2(ebt_dev_check(
 	   e->logical_out, out->br_port->br->dev), EBT_ILOGICALOUT))
-		return 1;
+		return false;
 
 	if (e->bitmask & EBT_SOURCEMAC) {
 		verdict = 0;
@@ -131,7 +131,7 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 			verdict |= (h->h_source[i] ^ e->sourcemac[i]) &
 			   e->sourcemsk[i];
 		if (FWINV2(verdict != 0, EBT_ISOURCE) )
-			return 1;
+			return false;
 	}
 	if (e->bitmask & EBT_DESTMAC) {
 		verdict = 0;
@@ -139,9 +139,9 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 			verdict |= (h->h_dest[i] ^ e->destmac[i]) &
 			   e->destmsk[i];
 		if (FWINV2(verdict != 0, EBT_IDEST) )
-			return 1;
+			return false;
 	}
-	return 0;
+	return true;
 }
 
 static inline __pure
@@ -188,7 +188,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	base = private->entries;
 	i = 0;
 	while (i < nentries) {
-		if (ebt_basic_match(point, eth_hdr(skb), in, out))
+		if (!ebt_basic_match(point, eth_hdr(skb), in, out))
 			goto letscontinue;
 
 		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
-- 
1.6.3.3

