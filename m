Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E957C43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 16:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiAYQ6i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356269AbiAYQz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 11:55:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928FBC061780
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 08:53:20 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nCP4J-0001dV-5Z; Tue, 25 Jan 2022 17:53:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 3/7] nft-shared: support native udp port delinearize
Date:   Tue, 25 Jan 2022 17:52:57 +0100
Message-Id: <20220125165301.5960-4-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125165301.5960-1-fw@strlen.de>
References: <20220125165301.5960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

same as previous patch, but for udp.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c | 117 ++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |   1 +
 2 files changed, 118 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 7f6b4ff392d9..19c82854f758 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -495,6 +495,24 @@ nft_create_match(struct nft_xt_ctx *ctx,
 	return match;
 }
 
+static struct xt_udp *nft_udp_match(struct nft_xt_ctx *ctx,
+			            struct iptables_command_state *cs)
+{
+	struct xt_udp *udp = ctx->tcpudp.udp;
+	struct xtables_match *match;
+
+	if (!udp) {
+		match = nft_create_match(ctx, cs, "udp");
+		if (!match)
+			return NULL;
+
+		udp = (void*)match->m->data;
+		ctx->tcpudp.udp = udp;
+	}
+
+	return udp;
+}
+
 static struct xt_tcp *nft_tcp_match(struct nft_xt_ctx *ctx,
 			            struct iptables_command_state *cs)
 {
@@ -513,6 +531,42 @@ static struct xt_tcp *nft_tcp_match(struct nft_xt_ctx *ctx,
 	return tcp;
 }
 
+static void nft_complete_udp_range(struct nft_xt_ctx *ctx,
+			           struct iptables_command_state *cs,
+			           int sport_from, int sport_to,
+			           int dport_from, int dport_to,
+				   uint8_t op)
+{
+	struct xt_udp *udp = nft_udp_match(ctx, cs);
+
+	if (!udp)
+		return;
+
+	if (sport_from >= 0) {
+		switch (op) {
+		case NFT_RANGE_NEQ:
+			udp->invflags |= XT_UDP_INV_SRCPT;
+			/* fallthrough */
+		case NFT_RANGE_EQ:
+			udp->spts[0] = sport_from;
+			udp->spts[1] = sport_to;
+			break;
+		}
+	}
+
+	if (dport_to >= 0) {
+		switch (op) {
+		case NFT_CMP_NEQ:
+			udp->invflags |= XT_UDP_INV_DSTPT;
+			/* fallthrough */
+		case NFT_CMP_EQ:
+			udp->dpts[0] = dport_from;
+			udp->dpts[1] = dport_to;
+			break;
+		}
+	}
+}
+
 static void nft_complete_tcp_range(struct nft_xt_ctx *ctx,
 			           struct iptables_command_state *cs,
 			           int sport_from, int sport_to,
@@ -549,6 +603,63 @@ static void nft_complete_tcp_range(struct nft_xt_ctx *ctx,
 	}
 }
 
+static void nft_complete_udp(struct nft_xt_ctx *ctx,
+			     struct iptables_command_state *cs,
+			     int sport, int dport,
+			     uint8_t op)
+{
+	struct xt_udp *udp = nft_udp_match(ctx, cs);
+
+	if (!udp)
+		return;
+
+	if (sport >= 0) {
+		switch (op) {
+		case NFT_CMP_NEQ:
+			udp->invflags |= XT_UDP_INV_SRCPT;
+			/* fallthrough */
+		case NFT_CMP_EQ:
+			udp->spts[0] = sport;
+			udp->spts[1] = sport;
+			break;
+		case NFT_CMP_LT:
+			udp->spts[1] = sport > 1 ? sport - 1 : 1;
+			break;
+		case NFT_CMP_LTE:
+			udp->spts[1] = sport;
+			break;
+		case NFT_CMP_GT:
+			udp->spts[0] = sport < 0xffff ? sport + 1 : 0xffff;
+			break;
+		case NFT_CMP_GTE:
+			udp->spts[0] = sport;
+			break;
+		}
+	}
+	if (dport >= 0) {
+		switch (op) {
+		case NFT_CMP_NEQ:
+			udp->invflags |= XT_UDP_INV_DSTPT;
+			/* fallthrough */
+		case NFT_CMP_EQ:
+			udp->dpts[0] = dport;
+			udp->dpts[1] = dport;
+			break;
+		case NFT_CMP_LT:
+			udp->dpts[1] = dport > 1 ? dport - 1 : 1;
+			break;
+		case NFT_CMP_LTE:
+			udp->dpts[1] = dport;
+			break;
+		case NFT_CMP_GT:
+			udp->dpts[0] = dport < 0xffff ? dport + 1 : 0xffff;
+			break;
+		case NFT_CMP_GTE:
+			udp->dpts[0] = dport;
+			break;
+		}
+	}
+}
 
 static void nft_complete_tcp(struct nft_xt_ctx *ctx,
 			     struct iptables_command_state *cs,
@@ -615,6 +726,9 @@ static void nft_complete_th_port(struct nft_xt_ctx *ctx,
 				 int sport, int dport, uint8_t op)
 {
 	switch (proto) {
+	case IPPROTO_UDP:
+		nft_complete_udp(ctx, cs, sport, dport, op);
+		break;
 	case IPPROTO_TCP:
 		nft_complete_tcp(ctx, cs, sport, dport, op);
 		break;
@@ -628,6 +742,9 @@ static void nft_complete_th_port_range(struct nft_xt_ctx *ctx,
 				       int dport_from, int dport_to, uint8_t op)
 {
 	switch (proto) {
+	case IPPROTO_UDP:
+		nft_complete_udp_range(ctx, cs, sport_from, sport_to, dport_from, dport_to, op);
+		break;
 	case IPPROTO_TCP:
 		nft_complete_tcp_range(ctx, cs, sport_from, sport_to, dport_from, dport_to, op);
 		break;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 1468d5608158..0716c8f4a509 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -56,6 +56,7 @@ struct nft_xt_ctx {
 	const char *table;
 	union {
 		struct xt_tcp *tcp;
+		struct xt_udp *udp;
 	} tcpudp;
 
 	uint32_t reg;
-- 
2.34.1

