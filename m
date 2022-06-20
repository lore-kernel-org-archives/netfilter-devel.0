Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326DCCCA47C
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 14:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiFTO5g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242925AbiFTO5K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 10:57:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FDD25297
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 07:17:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o3IDk-00052V-FS; Mon, 20 Jun 2022 16:17:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Garver <eric@garver.life>
Subject: [PATCH nf 1/2] netfilter: nf_dup_netdev: do not push mac header a second time
Date:   Mon, 20 Jun 2022 16:17:30 +0200
Message-Id: <20220620141731.7362-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620141731.7362-1-fw@strlen.de>
References: <20220620141731.7362-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric reports skb_under_panic when using dup/fwd via bond+egress hook.
Before pushing mac header, we should make sure that we're called from
ingress to put back what was pulled earlier.

In egress case, the MAC header is already there; we should leave skb
alone.

While at it be more careful here: skb might have been altered and
headroom reduced, so add a skb_cow() before so that headroom is
increased if necessary.

nf_do_netdev_egress() assumes skb ownership (it normally ends with
a call to dev_queue_xmit), so we must free the packet on error.

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_dup_netdev.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 7873bd1389c3..13b7f6a66086 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,10 +13,16 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
+static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
+				enum nf_dev_hooks hook)
 {
-	if (skb_mac_header_was_set(skb))
+	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
+		if (skb_cow_head(skb, skb->mac_len)) {
+			kfree_skb(skb);
+			return;
+		}
 		skb_push(skb, skb->mac_len);
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
@@ -33,7 +39,7 @@ void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 		return;
 	}
 
-	nf_do_netdev_egress(pkt->skb, dev);
+	nf_do_netdev_egress(pkt->skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_fwd_netdev_egress);
 
@@ -48,7 +54,7 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
 	if (skb)
-		nf_do_netdev_egress(skb, dev);
+		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
-- 
2.35.1

