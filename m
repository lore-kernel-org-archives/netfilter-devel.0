Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BDCC2D0D3
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5E8206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfL3LWR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:22:17 -0500
Received: from correo.us.es ([193.147.175.20]:59262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbfL3LWH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00AE44DE72A
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8323DA723
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD02CDA716; Mon, 30 Dec 2019 12:22:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8580DA715;
        Mon, 30 Dec 2019 12:22:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:22:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4F92841E4800;
        Mon, 30 Dec 2019 12:22:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/17] netfilter: nft_meta: place prandom handling in a helper
Date:   Mon, 30 Dec 2019 12:21:41 +0100
Message-Id: <20191230112143.121708-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Move this out of the main eval loop, the numgen expression
provides a better alternative to meta random.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 022f1473ddd1..ac6fc95387dc 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -266,6 +266,13 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 	return true;
 }
 
+static noinline u32 nft_prandom_u32(void)
+{
+	struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
+
+	return prandom_u32_state(state);
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -344,11 +351,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 #endif
-	case NFT_META_PRANDOM: {
-		struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
-		*dest = prandom_u32_state(state);
+	case NFT_META_PRANDOM:
+		*dest = nft_prandom_u32();
 		break;
-	}
 #ifdef CONFIG_XFRM
 	case NFT_META_SECPATH:
 		nft_reg_store8(dest, secpath_exists(skb));
-- 
2.11.0

