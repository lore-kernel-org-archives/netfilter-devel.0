Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E1BCCA479
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 14:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbiFTO5h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242963AbiFTO5K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 10:57:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1878B1D32F
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 07:17:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o3IDo-00052h-Kh; Mon, 20 Jun 2022 16:17:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: nf_dup_netdev: add and use recursion counter
Date:   Mon, 20 Jun 2022 16:17:31 +0200
Message-Id: <20220620141731.7362-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620141731.7362-1-fw@strlen.de>
References: <20220620141731.7362-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that the egress function can be called from egress hook, we need
to avoid recursive calls into the nf_tables traverser, else crash.

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_dup_netdev.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 13b7f6a66086..a8e2425e43b0 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,20 +13,31 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
+#define NF_RECURSION_LIMIT	2
+
+static DEFINE_PER_CPU(u8, nf_dup_skb_recursion);
+
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
+	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+		goto err;
+
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
-		if (skb_cow_head(skb, skb->mac_len)) {
-			kfree_skb(skb);
-			return;
-		}
+		if (skb_cow_head(skb, skb->mac_len))
+			goto err;
+
 		skb_push(skb, skb->mac_len);
 	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	__this_cpu_inc(nf_dup_skb_recursion);
 	dev_queue_xmit(skb);
+	__this_cpu_dec(nf_dup_skb_recursion);
+	return;
+err:
+	kfree_skb(skb);
 }
 
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
-- 
2.35.1

