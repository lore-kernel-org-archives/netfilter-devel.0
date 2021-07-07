Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FC7C11F67
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A0861CC2
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhGGQVo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 12:21:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55186 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhGGQVj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 12:21:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C8206244F;
        Wed,  7 Jul 2021 18:18:44 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 10/11] netfilter: nft_last: incorrect arithmetics when restoring last used
Date:   Wed,  7 Jul 2021 18:18:43 +0200
Message-Id: <20210707161844.20827-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Subtract the jiffies that have passed by to current jiffies to fix last
used restoration.

Fixes: 836382dc2471 ("netfilter: nf_tables: add last expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_last.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index bbb352b64c73..8088b99f2ee3 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -37,7 +37,7 @@ static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		if (err < 0)
 			return err;
 
-		priv->last_jiffies = jiffies + (unsigned long)last_jiffies;
+		priv->last_jiffies = jiffies - (unsigned long)last_jiffies;
 	}
 
 	return 0;
-- 
2.20.1

