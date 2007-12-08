From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH] More safe chain sorting, improving r7098
Date: Sat, 08 Dec 2007 23:59:47 +0100
Message-ID: <1197154787.19545.9.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Netfilter Developers <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:35110 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbXLHXDI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:03:08 -0500
Received: from comxexch02.comx.local (unknown [172.31.1.117])
	by lanfw001a.cxnet.dk (Postfix) with ESMTP id 8641B163510
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Dec 2007 00:03:05 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is an improvment of r7098 (made by me).

Assuring compatibility between 1.4.0 and older versions,
regarding chain sorting.
    
Chains from kernel are already sorted, as they are inserted
sorted. But there exists an issue when shifting to 1.4.0
from an older version, as old versions allow last created
chain to be unsorted.  This unsorted chain would survive in
1.4.0, as chains are now only sorted on creation.

This patch verifies that chains are sorted, if not it fixes the sorting.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 0598505..29f671e 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -415,12 +415,28 @@ static inline void iptc_insert_chain(TC_HANDLE_T h, struct chain_head *c)
 static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
 				unsigned int offset, unsigned int *num)
 {
+	struct list_head  *tail = h->chains.prev;
+	struct chain_head *ctail;
+
 	__iptcc_p_del_policy(h, *num);
 
 	c->head_offset = offset;
 	c->index = *num;
 
-	list_add_tail(&c->list, &h->chains); /* Its already sorted */
+	/* Chains from kernel are already sorted, as they are inserted
+	 * sorted. But there exists an issue when shifting to 1.4.0
+	 * from an older version, as old versions allow last created
+	 * chain to be unsorted.
+	 */
+	if (iptcc_is_builtin(c)) /* Only user defined chains are sorted*/
+		list_add_tail(&c->list, &h->chains);
+	else {
+		ctail = list_entry(tail, struct chain_head, list);
+		if (strcmp(c->name, ctail->name) > 0)
+			list_add_tail(&c->list, &h->chains);/* Already sorted*/
+		else
+			iptc_insert_chain(h, c);/* Was not sorted */
+	}
 
 	h->chain_iterator_cur = c;
 }

