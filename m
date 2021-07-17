Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D48C636C9
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 08:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0E54613C4
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 08:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhGQIb3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Jul 2021 04:31:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46238 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhGQIb3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 04:31:29 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5C44B63089
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 10:28:11 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nft_last: avoid possible false sharing
Date:   Sat, 17 Jul 2021 10:28:30 +0200
Message-Id: <20210717082830.7169-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210717082830.7169-1-pablo@netfilter.org>
References: <20210717082830.7169-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the idiom described in:

https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance

Moreover, prevent a compiler optimization.

Fixes: 836382dc2471 ("netfilter: nf_tables: add last expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_last.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 8088b99f2ee3..f29f205e9992 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -48,24 +48,30 @@ static void nft_last_eval(const struct nft_expr *expr,
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
 
-	priv->last_jiffies = jiffies;
-	priv->last_set = 1;
+	if (READ_ONCE(priv->last_set) == 0)
+		WRITE_ONCE(priv->last_set, 1);
+	if (READ_ONCE(priv->last_jiffies) != jiffies)
+		WRITE_ONCE(priv->last_jiffies, jiffies);
 }
 
 static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
+	unsigned long last_jiffies = READ_ONCE(priv->last_jiffies);
+	u32 last_set = READ_ONCE(priv->last_set);
 	__be64 msecs;
 
-	if (time_before(jiffies, priv->last_jiffies))
-		priv->last_set = 0;
+	if (time_before(jiffies, last_jiffies)) {
+		WRITE_ONCE(priv->last_set, 0);
+		last_set = 0;
+	}
 
-	if (priv->last_set)
-		msecs = nf_jiffies64_to_msecs(jiffies - priv->last_jiffies);
+	if (last_set)
+		msecs = nf_jiffies64_to_msecs(jiffies - last_jiffies);
 	else
 		msecs = 0;
 
-	if (nla_put_be32(skb, NFTA_LAST_SET, htonl(priv->last_set)) ||
+	if (nla_put_be32(skb, NFTA_LAST_SET, htonl(last_set)) ||
 	    nla_put_be64(skb, NFTA_LAST_MSECS, msecs, NFTA_LAST_PAD))
 		goto nla_put_failure;
 
-- 
2.30.2

