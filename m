Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF434C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 13:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiFWNFw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 09:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiFWNFw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 09:05:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85B041302
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 06:05:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o4MWr-0005Zt-Ba; Thu, 23 Jun 2022 15:05:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/6] netfilter: nf_tables: move nft_cmp_fast_mask to where its used
Date:   Thu, 23 Jun 2022 15:05:14 +0200
Message-Id: <20220623130514.13775-7-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220623130514.13775-1-fw@strlen.de>
References: <20220623130514.13775-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... and cast result to u32 so sparse won't complain anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h | 10 ----------
 net/netfilter/nft_cmp.c                | 12 ++++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 0ea7c55cea4d..1223af68cd9a 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -56,16 +56,6 @@ struct nft_immediate_expr {
 	u8			dlen;
 };
 
-/* Calculate the mask for the nft_cmp_fast expression. On big endian the
- * mask needs to include the *upper* bytes when interpreting that data as
- * something smaller than the full u32, therefore a cpu_to_le32 is done.
- */
-static inline u32 nft_cmp_fast_mask(unsigned int len)
-{
-	return cpu_to_le32(~0U >> (sizeof_field(struct nft_cmp_fast_expr,
-						data) * BITS_PER_BYTE - len));
-}
-
 extern const struct nft_expr_ops nft_cmp_fast_ops;
 extern const struct nft_expr_ops nft_cmp16_fast_ops;
 
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index bec22584395f..777f09e4dc60 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -197,6 +197,18 @@ static const struct nft_expr_ops nft_cmp_ops = {
 	.offload	= nft_cmp_offload,
 };
 
+/* Calculate the mask for the nft_cmp_fast expression. On big endian the
+ * mask needs to include the *upper* bytes when interpreting that data as
+ * something smaller than the full u32, therefore a cpu_to_le32 is done.
+ */
+static u32 nft_cmp_fast_mask(unsigned int len)
+{
+	__le32 mask = cpu_to_le32(~0U >> (sizeof_field(struct nft_cmp_fast_expr,
+					  data) * BITS_PER_BYTE - len));
+
+	return (__force u32)mask;
+}
+
 static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 			     const struct nft_expr *expr,
 			     const struct nlattr * const tb[])
-- 
2.35.1

