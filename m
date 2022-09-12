Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FF7ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiILI7E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Sep 2022 04:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiILI7A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2022 04:59:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361D6192BB
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 01:58:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oXfHN-0001a5-PW; Mon, 12 Sep 2022 10:58:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 2/2] nft: prefer payload to ttl/hl module
Date:   Mon, 12 Sep 2022 10:58:46 +0200
Message-Id: <20220912085846.9116-3-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220912085846.9116-1-fw@strlen.de>
References: <20220912085846.9116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index a7f712b1d580..f31c1603eb9e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -43,6 +43,8 @@
 #include <linux/netfilter/xt_mark.h>
 #include <linux/netfilter/xt_pkttype.h>
 
+#include <linux/netfilter_ipv6/ip6t_hl.h>
+
 #include <libmnl/libmnl.h>
 #include <libnftnl/gen.h>
 #include <libnftnl/table.h>
@@ -1465,6 +1467,41 @@ static int add_nft_pkttype(struct nft_handle *h, struct nftnl_rule *r,
 	return 0;
 }
 
+static int add_nft_hl(struct nft_handle *h, struct nftnl_rule *r,
+		      struct xt_entry_match *m, uint8_t offset)
+{
+	struct ip6t_hl_info *info = (void *)m->data;
+	struct nftnl_expr *expr;
+	uint8_t reg;
+	uint8_t op;
+
+	switch (info->mode) {
+	case IP6T_HL_NE:
+		op = NFT_CMP_NEQ;
+		break;
+	case IP6T_HL_EQ:
+		op = NFT_CMP_EQ;
+		break;
+	case IP6T_HL_LT:
+		op = NFT_CMP_LT;
+		break;
+	case IP6T_HL_GT:
+		op = NFT_CMP_GT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	expr = gen_payload(h, NFT_PAYLOAD_NETWORK_HEADER, offset, 1, &reg);
+	if (!expr)
+		return -ENOMEM;
+
+	nftnl_rule_add_expr(r, expr);
+	add_cmp_u8(r, info->hop_limit, op, reg);
+
+	return 0;
+}
+
 int add_match(struct nft_handle *h,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
@@ -1483,6 +1520,12 @@ int add_match(struct nft_handle *h,
 		return add_nft_mark(h, r, m);
 	else if (!strcmp(m->u.user.name, "pkttype"))
 		return add_nft_pkttype(h, r, m);
+	else if (!strcmp(m->u.user.name, "hl"))
+		return add_nft_hl(h, r, m,
+				  offsetof(struct ip6_hdr, ip6_hlim));
+	else if (!strcmp(m->u.user.name, "ttl"))
+		return add_nft_hl(h, r, m,
+				  offsetof(struct iphdr, ttl));
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
-- 
2.37.3

