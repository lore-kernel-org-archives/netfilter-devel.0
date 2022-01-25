Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF6BC4167E
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 16:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiAYQ6k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381045AbiAYQ4l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 11:56:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B81CC061787
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 08:53:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nCP4V-0001e1-L8; Tue, 25 Jan 2022 17:53:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 6/7] nft-shared: add tcp flag dissection
Date:   Tue, 25 Jan 2022 17:53:00 +0100
Message-Id: <20220125165301.5960-7-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125165301.5960-1-fw@strlen.de>
References: <20220125165301.5960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Detect payload load of th->flags and convert it to xt tcp match
structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 19c82854f758..74f08c8966ee 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -751,6 +751,22 @@ static void nft_complete_th_port_range(struct nft_xt_ctx *ctx,
 	}
 }
 
+static void nft_complete_tcp_flags(struct nft_xt_ctx *ctx,
+				   struct iptables_command_state *cs,
+				   uint8_t op,
+				   uint8_t flags,
+				   uint8_t mask)
+{
+	struct xt_tcp *tcp = nft_tcp_match(ctx, cs);
+
+	if (!tcp)
+		return;
+
+	if (op == NFT_CMP_NEQ)
+		tcp->invflags |= XT_TCP_INV_FLAGS;
+	tcp->flg_cmp = flags;
+	tcp->flg_mask = mask;
+}
 
 static void nft_complete_transport(struct nft_xt_ctx *ctx,
 				   struct nftnl_expr *e, void *data)
@@ -797,6 +813,18 @@ static void nft_complete_transport(struct nft_xt_ctx *ctx,
 			return;
 		}
 		break;
+	case 13: /* th->flags */
+		if (len == 1 && proto == IPPROTO_TCP) {
+			uint8_t flags = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
+			uint8_t mask = ~0;
+
+			if (ctx->flags & NFT_XT_CTX_BITWISE) {
+				memcpy(&mask, &ctx->bitwise.mask, sizeof(mask));
+				ctx->flags &= ~NFT_XT_CTX_BITWISE;
+			}
+			nft_complete_tcp_flags(ctx, cs, op, flags, mask);
+		}
+		return;
 	}
 }
 
-- 
2.34.1

