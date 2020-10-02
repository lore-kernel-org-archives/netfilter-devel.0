Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A20C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 08:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 603BC206B8
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 08:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgJBIpW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 04:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBIpW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 04:45:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76550C0613D0
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2020 01:45:22 -0700 (PDT)
Received: from localhost ([::1]:49680 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kOGgq-0005jZ-9l; Fri, 02 Oct 2020 10:45:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Optimize class-based IP prefix matches
Date:   Fri,  2 Oct 2020 11:03:34 +0200
Message-Id: <20201002090334.29788-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Payload expression works on byte-boundaries, leverage this with suitable
prefix lengths.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ipv4.c   |  6 ++++--
 iptables/nft-ipv6.c   |  6 ++++--
 iptables/nft-shared.c | 14 ++++++++++----
 iptables/nft-shared.h |  4 ++++
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index afdecf9711e64..ce702041af0f4 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -199,7 +199,8 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 			parse_mask_ipv4(ctx, &cs->fw.ip.smsk);
 			ctx->flags &= ~NFT_XT_CTX_BITWISE;
 		} else {
-			cs->fw.ip.smsk.s_addr = 0xffffffff;
+			memset(&cs->fw.ip.smsk, 0xff,
+			       min(ctx->payload.len, sizeof(struct in_addr)));
 		}
 
 		if (inv)
@@ -212,7 +213,8 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 			parse_mask_ipv4(ctx, &cs->fw.ip.dmsk);
 			ctx->flags &= ~NFT_XT_CTX_BITWISE;
 		} else {
-			cs->fw.ip.dmsk.s_addr = 0xffffffff;
+			memset(&cs->fw.ip.dmsk, 0xff,
+			       min(ctx->payload.len, sizeof(struct in_addr)));
 		}
 
 		if (inv)
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 4008b7eab4f2a..c877ec6d10887 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -146,7 +146,8 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 			parse_mask_ipv6(ctx, &cs->fw6.ipv6.smsk);
 			ctx->flags &= ~NFT_XT_CTX_BITWISE;
 		} else {
-			memset(&cs->fw6.ipv6.smsk, 0xff, sizeof(struct in6_addr));
+			memset(&cs->fw6.ipv6.smsk, 0xff,
+			       min(ctx->payload.len, sizeof(struct in6_addr)));
 		}
 
 		if (inv)
@@ -159,7 +160,8 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 			parse_mask_ipv6(ctx, &cs->fw6.ipv6.dmsk);
 			ctx->flags &= ~NFT_XT_CTX_BITWISE;
 		} else {
-			memset(&cs->fw6.ipv6.dmsk, 0xff, sizeof(struct in6_addr));
+			memset(&cs->fw6.ipv6.dmsk, 0xff,
+			       min(ctx->payload.len, sizeof(struct in6_addr)));
 		}
 
 		if (inv)
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 7741d23befc5a..545e9c60fa015 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -166,16 +166,22 @@ void add_addr(struct nftnl_rule *r, int offset,
 	      void *data, void *mask, size_t len, uint32_t op)
 {
 	const unsigned char *m = mask;
+	bool bitwise = false;
 	int i;
 
-	add_payload(r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
-
 	for (i = 0; i < len; i++) {
-		if (m[i] != 0xff)
+		if (m[i] != 0xff) {
+			bitwise = m[i] != 0;
 			break;
+		}
 	}
 
-	if (i != len)
+	if (!bitwise)
+		len = i;
+
+	add_payload(r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
+
+	if (bitwise)
 		add_bitwise(r, mask, len);
 
 	add_cmp_ptr(r, op, data, len);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 4440fd17bfeac..a52463342b30a 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -247,4 +247,8 @@ void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p);
 
 void nft_check_xt_legacy(int family, bool is_ipt_save);
+
+#define min(x, y) ((x) < (y) ? (x) : (y))
+#define max(x, y) ((x) > (y) ? (x) : (y))
+
 #endif
-- 
2.28.0

