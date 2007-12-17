From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/64]: arp_tables: use XT_ALIGN
Date: Tue, 18 Dec 2007 00:46:47 +0100 (MET)
Message-ID: <20071217234646.23601.3875.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38955 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbXLQXqs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:48 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: use XT_ALIGN

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9cd44c2375b2d30c90e0bef6d8a61b49f986ee17
tree 0b850ca7bf96413e762a8b4ac30cc69b96757f13
parent 66239de91b46299cad80509607b1793dd6131925
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:07 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:55 +0100

 include/linux/netfilter_arp/arp_tables.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index e44811b..7ade26b 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -280,6 +280,6 @@ extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct net_device *out,
 				  struct arpt_table *table);
 
-#define ARPT_ALIGN(s) (((s) + (__alignof__(struct arpt_entry)-1)) & ~(__alignof__(struct arpt_entry)-1))
+#define ARPT_ALIGN(s) XT_ALIGN(s)
 #endif /*__KERNEL__*/
 #endif /* _ARPTABLES_H */
