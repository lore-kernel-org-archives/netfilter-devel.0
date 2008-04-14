From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 33/41]: Remove unused callbacks in nf_conntrack_l3proto
Date: Mon, 14 Apr 2008 12:17:03 +0200 (MEST)
Message-ID: <20080414101700.32717.81561.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36331 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbYDNKRE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:04 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Remove unused callbacks in nf_conntrack_l3proto

These functions are never called.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cc83490eebaf7334c3403a7af322aa471f0b644c
tree a9a1e7f47301eac39e9f2353590903f4a9386e00
parent 94ab8bc42cb5b451913d470adb06659fec70cc9d
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Apr 2008 12:10:55 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:55 +0200

 include/net/netfilter/nf_conntrack_l3proto.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index b886e3a..db08258 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -42,17 +42,6 @@ struct nf_conntrack_l3proto
 	int (*print_tuple)(struct seq_file *s,
 			   const struct nf_conntrack_tuple *);
 
-	/* Returns verdict for packet, or -1 for invalid. */
-	int (*packet)(struct nf_conn *ct,
-		      const struct sk_buff *skb,
-		      enum ip_conntrack_info ctinfo);
-
-	/*
-	 * Called when a new connection for this protocol found;
-	 * returns TRUE if it's OK.  If so, packet() called next.
-	 */
-	int (*new)(struct nf_conn *ct, const struct sk_buff *skb);
-
 	/*
 	 * Called before tracking. 
 	 *	*dataoff: offset of protocol header (TCP, UDP,...) in skb
