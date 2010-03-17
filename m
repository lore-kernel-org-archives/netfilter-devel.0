From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] netfilter: xtables: limit xt_mac to ethernet devices
Date: Wed, 17 Mar 2010 14:19:00 +0100
Message-ID: <1268831945-6041-6-git-send-email-jengelh@medozas.de>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59344 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0CQNTU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:19:20 -0400
In-Reply-To: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I do not see a point of allowing the MAC module to work with devices
that don't possibly have one, e.g. various tunnel interfaces such as
tun and sit.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_mac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 2039d07..b971ce9 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -10,6 +10,7 @@
 
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 
@@ -29,6 +30,8 @@ static bool mac_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	const struct xt_mac_info *info = par->matchinfo;
 	bool ret;
 
+	if (skb->dev == NULL || skb->dev->type != ARPHRD_ETHER)
+		return false;
 	if (skb_mac_header(skb) < skb->head)
 		return false;
 	if (skb_mac_header(skb) + ETH_HLEN > skb->data)
-- 
1.7.0.2

