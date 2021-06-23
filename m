Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EABC49EA5
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 17:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98FA9611CB
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 17:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFWRFa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 13:05:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33514 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhFWRF3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 13:05:29 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 011B06427E;
        Wed, 23 Jun 2021 19:01:45 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 2/6] netfilter: nft_extdhr: Drop pointless check of tprot_set
Date:   Wed, 23 Jun 2021 19:02:57 +0200
Message-Id: <20210623170301.59973-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623170301.59973-1-pablo@netfilter.org>
References: <20210623170301.59973-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Pablo says, tprot_set is only there to detect if tprot was set to
IPPROTO_IP as that evaluates to zero. Therefore, code asserting a
different value in tprot does not need to check tprot_set.

Fixes: 935b7f6430188 ("netfilter: nft_exthdr: add TCP option matching")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 9cf86be2cff4..4f583d2e220e 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -164,7 +164,7 @@ nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 {
 	struct tcphdr *tcph;
 
-	if (!pkt->tprot_set || pkt->tprot != IPPROTO_TCP)
+	if (pkt->tprot != IPPROTO_TCP)
 		return NULL;
 
 	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(*tcph), buffer);
-- 
2.30.2

