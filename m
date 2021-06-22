Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD274C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF126134F
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhFVWC6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 18:02:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59248 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhFVWC5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 18:02:57 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DCFCB64252;
        Tue, 22 Jun 2021 23:59:15 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/8] netfilter: nft_exthdr: check for IPv6 packet before further processing
Date:   Tue, 22 Jun 2021 23:59:55 +0200
Message-Id: <20210622220001.198508-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622220001.198508-1-pablo@netfilter.org>
References: <20210622220001.198508-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ipv6_find_hdr() does not validate that this is an IPv6 packet. Add a
sanity check for calling ipv6_find_hdr() to make sure an IPv6 packet
is passed for parsing.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index f64f0017e9a5..670dd146fb2b 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -42,6 +42,9 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	unsigned int offset = 0;
 	int err;
 
+	if (pkt->skb->protocol != htons(ETH_P_IPV6))
+		goto err;
+
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
 		nft_reg_store8(dest, err >= 0);
-- 
2.30.2

