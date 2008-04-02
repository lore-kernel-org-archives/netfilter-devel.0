From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 24/24] [NETFILTER]: Remove unused callbacks in nf_conntrack_l3proto
Date: Wed,  2 Apr 2008 13:12:06 +0200
Message-ID: <13025d3419bf0d9073e03b0028eea4bb0d86156c.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43174 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbYDBLMN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:13 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_conntrack_l3proto.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index d018c69..6fc2f12 100644
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
-	bool (*new)(struct nf_conn *ct, const struct sk_buff *skb);
-
 	/*
 	 * Called before tracking. 
 	 *	*dataoff: offset of protocol header (TCP, UDP,...) in skb
-- 
1.5.4.4

