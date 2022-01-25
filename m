Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B2FC4167D
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 16:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356264AbiAYQ6j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiAYQ4l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 11:56:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7A4C061788
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 08:53:37 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nCP4Z-0001eA-PT; Tue, 25 Jan 2022 17:53:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 7/7] nft: add support for native tcp flag matching
Date:   Tue, 25 Jan 2022 17:53:01 +0100
Message-Id: <20220125165301.5960-8-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125165301.5960-1-fw@strlen.de>
References: <20220125165301.5960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

prefer payload + bitwise + cmp to nft_compat match.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4b5c4332c7c1..3e4345499794 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1346,6 +1346,26 @@ static int add_nft_udp(struct nftnl_rule *r, struct xt_entry_match *m)
 			      udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
 }
 
+static int add_nft_tcpflags(struct nftnl_rule *r,
+			    uint8_t cmp, uint8_t mask,
+			    bool invert)
+{
+	struct nftnl_expr *e;
+
+	e = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER,
+			13, 1, NFT_REG_1);
+
+	if (!e)
+		return -ENOMEM;
+
+	nftnl_rule_add_expr(r, e);
+
+	add_bitwise(r, &mask, 1);
+	add_cmp_u8(r, cmp, invert ? NFT_CMP_NEQ : NFT_CMP_EQ);
+
+	return 0;
+}
+
 static bool tcp_all_zero(const struct xt_tcp *t)
 {
 	static const struct xt_tcp zero = {
@@ -1358,11 +1378,10 @@ static bool tcp_all_zero(const struct xt_tcp *t)
 
 static int add_nft_tcp(struct nftnl_rule *r, struct xt_entry_match *m)
 {
-	static const uint8_t supported = XT_TCP_INV_SRCPT | XT_TCP_INV_DSTPT;
+	static const uint8_t supported = XT_TCP_INV_SRCPT | XT_TCP_INV_DSTPT | XT_TCP_INV_FLAGS;
 	struct xt_tcp *tcp = (void *)m->data;
 
 	if (tcp->invflags & ~supported || tcp->option ||
-	    tcp->flg_mask || tcp->flg_cmp ||
 	    tcp_all_zero(tcp)) {
 		struct nftnl_expr *expr = nftnl_expr_alloc("match");
 		int ret;
@@ -1372,6 +1391,14 @@ static int add_nft_tcp(struct nftnl_rule *r, struct xt_entry_match *m)
 		return ret;
 	}
 
+	if (tcp->flg_mask) {
+		int ret = add_nft_tcpflags(r, tcp->flg_cmp, tcp->flg_mask,
+					   tcp->invflags & XT_TCP_INV_FLAGS);
+
+		if (ret < 0)
+			return ret;
+	}
+
 	return add_nft_tcpudp(r, tcp->spts, tcp->invflags & XT_TCP_INV_SRCPT,
 			      tcp->dpts, tcp->invflags & XT_TCP_INV_DSTPT);
 }
-- 
2.34.1

