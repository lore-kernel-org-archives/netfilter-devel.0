Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A737CC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 19:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiAYTGX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 14:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiAYTGR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 14:06:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF8EC06173B
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 11:06:13 -0800 (PST)
Received: from localhost ([::1]:59148 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nCR8r-0007cx-Lo; Tue, 25 Jan 2022 20:06:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        "Jose M . Guisado Gomez" <guigom@riseup.net>
Subject: [nf PATCH] netfilter: nft_reject_bridge: Fix for missing reply from prerouting
Date:   Tue, 25 Jan 2022 20:06:03 +0100
Message-Id: <20220125190603.20182-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prior to commit fa538f7cf05aa ("netfilter: nf_reject: add reject skbuff
creation helpers"), nft_reject_bridge did not assign to nskb->dev before
passing nskb on to br_forward(). The shared skbuff creation helpers
introduced in above commit do which seems to confuse br_forward() as
reject statements in prerouting hook won't emit a packet anymore.

Fix this by simply passing NULL instead of 'dev' to the helpers - they
use the pointer for just that assignment, nothing else.

Fixes: fa538f7cf05aa ("netfilter: nf_reject: add reject skbuff creation helpers")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/bridge/netfilter/nft_reject_bridge.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index eba0efe64d05a..fbf858ddec352 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -49,7 +49,7 @@ static void nft_reject_br_send_v4_tcp_reset(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -65,7 +65,7 @@ static void nft_reject_br_send_v4_unreach(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v4_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 
@@ -81,7 +81,7 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -98,7 +98,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v6_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 
-- 
2.34.1

