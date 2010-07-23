From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] nf_conntrack_acct: use skb->len for accounting
Date: Fri, 23 Jul 2010 11:39:59 +0800
Message-ID: <1279856399-9058-1-git-send-email-xiaosuo@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51533 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab0GWDkQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:40:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_conntrack_acct: use skb->len for accounting

use skb->len for accounting as xt_quota does. Since nf_conntrack works at
the network layer, skb_network_offset should always returns ZERO.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/netfilter/nf_conntrack_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 16b41b4..df3eedb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -966,8 +966,7 @@ acct:
 		if (acct) {
 			spin_lock_bh(&ct->lock);
 			acct[CTINFO2DIR(ctinfo)].packets++;
-			acct[CTINFO2DIR(ctinfo)].bytes +=
-				skb->len - skb_network_offset(skb);
+			acct[CTINFO2DIR(ctinfo)].bytes += skb->len;
 			spin_unlock_bh(&ct->lock);
 		}
 	}
