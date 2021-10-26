Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4757DC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Oct 2021 11:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266DC60C4B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Oct 2021 11:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhJZL2B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 07:28:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45258 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbhJZL1v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 07:27:51 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2621A63F4E
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Oct 2021 13:23:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nft_meta: infer ptktype from IP address from the output path
Date:   Tue, 26 Oct 2021 13:25:21 +0200
Message-Id: <20211026112521.1278472-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

meta pkttype always says 0 (host) from the output path. The code to
infer the packet type from the IP address is already in place for
loopback traffic, extend it to infer it the packet type from the output,
postrouting and egress path too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 516e74635bae..58a87205be8e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -371,7 +371,11 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	case NFT_META_PKTTYPE:
-		if (skb->pkt_type != PACKET_LOOPBACK) {
+		if (skb->pkt_type != PACKET_LOOPBACK &&
+		    nft_hook(pkt) != NF_INET_LOCAL_OUT &&
+		    nft_hook(pkt) != NF_INET_POST_ROUTING &&
+		    (nft_pf(pkt) == NFPROTO_NETDEV &&
+		     nft_hook(pkt) != NF_NETDEV_EGRESS)) {
 			nft_reg_store8(dest, skb->pkt_type);
 			break;
 		}
-- 
2.30.2

