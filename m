Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1110CC38145
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Sep 2022 15:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiIHPNE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 11:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiIHPNB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 11:13:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E25F3BC5
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2022 08:12:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oWJD6-0005Zf-K8; Thu, 08 Sep 2022 17:12:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 2/3] nft: prefer native 'meta pkttype' instead of xt match
Date:   Thu,  8 Sep 2022 17:12:41 +0200
Message-Id: <20220908151242.26838-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908151242.26838-1-fw@strlen.de>
References: <20220908151242.26838-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index ee003511ab7f..f122075db2b2 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -41,6 +41,7 @@
 #include <linux/netfilter/xt_limit.h>
 #include <linux/netfilter/xt_NFLOG.h>
 #include <linux/netfilter/xt_mark.h>
+#include <linux/netfilter/xt_pkttype.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/gen.h>
@@ -1445,6 +1446,25 @@ static int add_nft_mark(struct nft_handle *h, struct nftnl_rule *r,
 	return 0;
 }
 
+static int add_nft_pkttype(struct nft_handle *h, struct nftnl_rule *r,
+			   struct xt_entry_match *m)
+{
+	struct xt_pkttype_info *pkti = (void *)m->data;
+	uint8_t reg;
+	int op;
+
+	add_meta(h, r, NFT_META_PKTTYPE, &reg);
+
+	if (pkti->invert)
+		op = NFT_CMP_NEQ;
+	else
+		op = NFT_CMP_EQ;
+
+	add_cmp_u8(r, pkti->pkttype, op, reg);
+
+	return 0;
+}
+
 int add_match(struct nft_handle *h,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
@@ -1461,6 +1481,8 @@ int add_match(struct nft_handle *h,
 		return add_nft_tcp(h, r, m);
 	else if (!strcmp(m->u.user.name, "mark"))
 		return add_nft_mark(h, r, m);
+	else if (!strcmp(m->u.user.name, "pkttype"))
+		return add_nft_pkttype(h, r, m);
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
-- 
2.35.1

