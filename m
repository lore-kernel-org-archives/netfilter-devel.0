Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B928C43219
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 23:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbiAIXQz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 18:16:55 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237378AbiAIXQx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 18:16:53 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B803E64690;
        Mon, 10 Jan 2022 00:14:02 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/32] netfilter: nf_tables: replace WARN_ON by WARN_ON_ONCE for unknown verdicts
Date:   Mon, 10 Jan 2022 00:16:14 +0100
Message-Id: <20220109231640.104123-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bug might trigger warning for each packet, call WARN_ON_ONCE instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index d026890a9842..d2ada666d889 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -260,7 +260,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	case NFT_RETURN:
 		break;
 	default:
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 	}
 
 	if (stackptr > 0) {
-- 
2.30.2

