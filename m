Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605D9C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiKLAVg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiKLAVf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C494ED2E0
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MFIsgMzAkQdR3TkWjWNpG0Hf2lZ9gq0YMmYQHmRz0lY=; b=UyVeHrZKZ1Gu5/91nXvD+hgRgQ
        KQ6qYXFi81GrEvcHy/gYLtG3YRkuagzAHVqQ3jg+cdcF/bsG5I/3IjGfnu7jwhpb/3DkR3OR56gZA
        QlOhxPLF+HYeMtxSsVZ4XrfAtu5ZMxDgh1GWlYieGOXr/GixZdMms9yQS3pND3uIhrpvOICge877+
        J1hj4wTl3TuVd02nCuddcDHtYS/JGW1YTTP4mj0TfgKvTQAzW+kO7cmb7z/I6qm4FQzklJvvQuqNO
        Svs+zqJIXtKumf6kx5IJdv2omYGsJnRrEk1LFyOgpHJ8Myt+duoleJfcvWQwcr4CGzkfxLxqlP3cp
        dRmr+Fhg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteH7-00023W-53
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/7] nft-shared: Introduce port_match_single_to_range()
Date:   Sat, 12 Nov 2022 01:20:51 +0100
Message-Id: <20221112002056.31917-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112002056.31917-1-phil@nwl.cc>
References: <20221112002056.31917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The same algorithm was present four times, outsource it. Also use
max()/min() macros for a more readable boundary notation.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 130 ++++++++++++------------------------------
 1 file changed, 37 insertions(+), 93 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 996cff996c151..e5e3ac0bada56 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -747,6 +747,35 @@ static void nft_parse_tcp_range(struct nft_xt_ctx *ctx,
 	}
 }
 
+static void port_match_single_to_range(__u16 *ports, __u8 *invflags,
+				       uint8_t op, int port, __u8 invflag)
+{
+	if (port < 0)
+		return;
+
+	switch (op) {
+	case NFT_CMP_NEQ:
+		*invflags |= invflag;
+		/* fallthrough */
+	case NFT_CMP_EQ:
+		ports[0] = port;
+		ports[1] = port;
+		break;
+	case NFT_CMP_LT:
+		ports[1] = max(port - 1, 1);
+		break;
+	case NFT_CMP_LTE:
+		ports[1] = port;
+		break;
+	case NFT_CMP_GT:
+		ports[0] = min(port + 1, UINT16_MAX);
+		break;
+	case NFT_CMP_GTE:
+		ports[0] = port;
+		break;
+	}
+}
+
 static void nft_parse_udp(struct nft_xt_ctx *ctx,
 			  struct iptables_command_state *cs,
 			  int sport, int dport,
@@ -757,52 +786,10 @@ static void nft_parse_udp(struct nft_xt_ctx *ctx,
 	if (!udp)
 		return;
 
-	if (sport >= 0) {
-		switch (op) {
-		case NFT_CMP_NEQ:
-			udp->invflags |= XT_UDP_INV_SRCPT;
-			/* fallthrough */
-		case NFT_CMP_EQ:
-			udp->spts[0] = sport;
-			udp->spts[1] = sport;
-			break;
-		case NFT_CMP_LT:
-			udp->spts[1] = sport > 1 ? sport - 1 : 1;
-			break;
-		case NFT_CMP_LTE:
-			udp->spts[1] = sport;
-			break;
-		case NFT_CMP_GT:
-			udp->spts[0] = sport < 0xffff ? sport + 1 : 0xffff;
-			break;
-		case NFT_CMP_GTE:
-			udp->spts[0] = sport;
-			break;
-		}
-	}
-	if (dport >= 0) {
-		switch (op) {
-		case NFT_CMP_NEQ:
-			udp->invflags |= XT_UDP_INV_DSTPT;
-			/* fallthrough */
-		case NFT_CMP_EQ:
-			udp->dpts[0] = dport;
-			udp->dpts[1] = dport;
-			break;
-		case NFT_CMP_LT:
-			udp->dpts[1] = dport > 1 ? dport - 1 : 1;
-			break;
-		case NFT_CMP_LTE:
-			udp->dpts[1] = dport;
-			break;
-		case NFT_CMP_GT:
-			udp->dpts[0] = dport < 0xffff ? dport + 1 : 0xffff;
-			break;
-		case NFT_CMP_GTE:
-			udp->dpts[0] = dport;
-			break;
-		}
-	}
+	port_match_single_to_range(udp->spts, &udp->invflags,
+				   op, sport, XT_UDP_INV_SRCPT);
+	port_match_single_to_range(udp->dpts, &udp->invflags,
+				   op, dport, XT_UDP_INV_DSTPT);
 }
 
 static void nft_parse_tcp(struct nft_xt_ctx *ctx,
@@ -815,53 +802,10 @@ static void nft_parse_tcp(struct nft_xt_ctx *ctx,
 	if (!tcp)
 		return;
 
-	if (sport >= 0) {
-		switch (op) {
-		case NFT_CMP_NEQ:
-			tcp->invflags |= XT_TCP_INV_SRCPT;
-			/* fallthrough */
-		case NFT_CMP_EQ:
-			tcp->spts[0] = sport;
-			tcp->spts[1] = sport;
-			break;
-		case NFT_CMP_LT:
-			tcp->spts[1] = sport > 1 ? sport - 1 : 1;
-			break;
-		case NFT_CMP_LTE:
-			tcp->spts[1] = sport;
-			break;
-		case NFT_CMP_GT:
-			tcp->spts[0] = sport < 0xffff ? sport + 1 : 0xffff;
-			break;
-		case NFT_CMP_GTE:
-			tcp->spts[0] = sport;
-			break;
-		}
-	}
-
-	if (dport >= 0) {
-		switch (op) {
-		case NFT_CMP_NEQ:
-			tcp->invflags |= XT_TCP_INV_DSTPT;
-			/* fallthrough */
-		case NFT_CMP_EQ:
-			tcp->dpts[0] = dport;
-			tcp->dpts[1] = dport;
-			break;
-		case NFT_CMP_LT:
-			tcp->dpts[1] = dport > 1 ? dport - 1 : 1;
-			break;
-		case NFT_CMP_LTE:
-			tcp->dpts[1] = dport;
-			break;
-		case NFT_CMP_GT:
-			tcp->dpts[0] = dport < 0xffff ? dport + 1 : 0xffff;
-			break;
-		case NFT_CMP_GTE:
-			tcp->dpts[0] = dport;
-			break;
-		}
-	}
+	port_match_single_to_range(tcp->spts, &tcp->invflags,
+				   op, sport, XT_TCP_INV_SRCPT);
+	port_match_single_to_range(tcp->dpts, &tcp->invflags,
+				   op, dport, XT_TCP_INV_DSTPT);
 }
 
 static void nft_parse_th_port(struct nft_xt_ctx *ctx,
-- 
2.38.0

