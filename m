From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/8] [NETFILTER]: Remove unused callbacks in
 nf_conntrack_l3proto
Date: Sun, 6 Apr 2008 05:44:18 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804060543550.30794@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40610 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYDFDoT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 23:44:19 -0400
In-Reply-To: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 8a7f4283eb98f4c701620624bb89ad59e719b7bb
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Apr 1 20:28:04 2008 +0200

     [NETFILTER]: Remove unused callbacks in nf_conntrack_l3proto

     These functions are never called.

     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
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
