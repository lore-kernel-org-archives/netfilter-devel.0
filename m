Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D16BC4167B
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 16:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358445AbiAYQ6i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356271AbiAYQz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 11:55:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C262CC061781
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 08:53:24 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nCP4N-0001df-9O; Tue, 25 Jan 2022 17:53:23 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 4/7] nft: prefer native expressions instead of udp match
Date:   Tue, 25 Jan 2022 17:52:58 +0100
Message-Id: <20220125165301.5960-5-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125165301.5960-1-fw@strlen.de>
References: <20220125165301.5960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of using nft_compat+xtables udp match, prefer to
emit payload+cmp or payload+range expression.

Delinearization support was added in previous patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index f7f5950625d0..9f181de53678 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1226,6 +1226,126 @@ static int add_nft_among(struct nft_handle *h,
 	return 0;
 }
 
+static int expr_gen_range_cmp16(struct nftnl_rule *r,
+				uint16_t lo,
+				uint16_t hi,
+				bool invert)
+{
+	struct nftnl_expr *e;
+
+	if (lo == hi) {
+		add_cmp_u16(r, htons(lo), invert ? NFT_CMP_NEQ : NFT_CMP_EQ);
+		return 0;
+	}
+
+	if (lo == 0 && hi < 0xffff) {
+		add_cmp_u16(r, htons(hi) , invert ? NFT_CMP_GT : NFT_CMP_LTE);
+		return 0;
+	}
+
+	e = nftnl_expr_alloc("range");
+	if (!e)
+		return -ENOMEM;
+
+	nftnl_expr_set_u32(e, NFTNL_EXPR_RANGE_SREG, NFT_REG_1);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_RANGE_OP, invert ? NFT_RANGE_NEQ : NFT_RANGE_EQ);
+
+	lo = htons(lo);
+	nftnl_expr_set(e, NFTNL_EXPR_RANGE_FROM_DATA, &lo, sizeof(lo));
+	hi = htons(hi);
+	nftnl_expr_set(e, NFTNL_EXPR_RANGE_TO_DATA, &hi, sizeof(hi));
+
+	nftnl_rule_add_expr(r, e);
+	return 0;
+}
+
+static int add_nft_tcpudp(struct nftnl_rule *r,
+			  uint16_t src[2],
+			  bool invert_src,
+			  uint16_t dst[2],
+			  bool invert_dst)
+{
+	struct nftnl_expr *expr;
+	uint8_t op = NFT_CMP_EQ;
+	int ret;
+
+	if (src[0] && src[0] == src[1] &&
+	    dst[0] && dst[0] == dst[1] &&
+	    invert_src == invert_dst) {
+		uint32_t combined = dst[0] | (src[0] << 16);
+
+		if (invert_src)
+			op = NFT_CMP_NEQ;
+
+		expr = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER, 0, 4,
+				   NFT_REG_1);
+		if (!expr)
+			return -ENOMEM;
+
+		nftnl_rule_add_expr(r, expr);
+		add_cmp_u32(r, htonl(combined), op);
+		return 0;
+	}
+
+	if (src[0] || src[1] < 0xffff) {
+		expr = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER,
+				   0, 2, NFT_REG_1);
+		if (!expr)
+			return -ENOMEM;
+
+		nftnl_rule_add_expr(r, expr);
+		ret = expr_gen_range_cmp16(r, src[0], src[1], invert_src);
+		if (ret)
+			return ret;
+	}
+
+	if (dst[0] || dst[1] < 0xffff) {
+		expr = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER,
+				   2, 2, NFT_REG_1);
+		if (!expr)
+			return -ENOMEM;
+
+		nftnl_rule_add_expr(r, expr);
+		ret = expr_gen_range_cmp16(r, dst[0], dst[1], invert_dst);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* without this, "iptables -A INPUT -m udp" is
+ * turned into "iptables -A INPUT", which isn't
+ * compatible with iptables-legacy behaviour.
+ */
+static bool udp_all_zero(const struct xt_udp *u)
+{
+	static const struct xt_udp zero = {
+		.spts[1] = 0xffff,
+		.dpts[1] = 0xffff,
+	};
+
+	return memcmp(u, &zero, sizeof(*u)) == 0;
+}
+
+static int add_nft_udp(struct nftnl_rule *r, struct xt_entry_match *m)
+{
+	struct xt_udp *udp = (void *)m->data;
+
+	if (udp->invflags > XT_UDP_INV_MASK ||
+	    udp_all_zero(udp)) {
+		struct nftnl_expr *expr = nftnl_expr_alloc("match");
+		int ret;
+
+		ret = __add_match(expr, m);
+		nftnl_rule_add_expr(r, expr);
+		return ret;
+	}
+
+	return add_nft_tcpudp(r, udp->spts, udp->invflags & XT_UDP_INV_SRCPT,
+			      udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
+}
+
 int add_match(struct nft_handle *h,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
@@ -1236,6 +1356,8 @@ int add_match(struct nft_handle *h,
 		return add_nft_limit(r, m);
 	else if (!strcmp(m->u.user.name, "among"))
 		return add_nft_among(h, r, m);
+	else if (!strcmp(m->u.user.name, "udp"))
+		return add_nft_udp(r, m);
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
-- 
2.34.1

