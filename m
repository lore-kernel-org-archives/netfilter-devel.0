Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDD8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 22:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiAHW0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 17:26:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiAHW0u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 17:26:50 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 908606428F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 23:24:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 13/14] netfilter: nft_payload: cancel register tracking after payload update
Date:   Sat,  8 Jan 2022 23:26:37 +0100
Message-Id: <20220108222638.36037-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108222638.36037-1-pablo@netfilter.org>
References: <20220108222638.36037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The payload expression might mangle the packet, cancel register tracking
since any payload data in the registers is stale.

Finer grain register tracking cancellation by inspecting the payload
base, offset and length on the register is also possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b5a3c45727b3..940fed9a760b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -801,12 +801,33 @@ static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr
 	return -1;
 }
 
+static bool nft_payload_set_reduce(struct nft_regs_track *track,
+				   const struct nft_expr *expr)
+{
+	int i;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		if (track->regs[i].selector->ops != &nft_payload_ops &&
+		    track->regs[i].selector->ops != &nft_payload_fast_ops)
+			continue;
+
+		track->regs[i].selector = NULL;
+		track->regs[i].bitwise = NULL;
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_payload_set_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_set)),
 	.eval		= nft_payload_set_eval,
 	.init		= nft_payload_set_init,
 	.dump		= nft_payload_set_dump,
+	.reduce		= nft_payload_set_reduce,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

