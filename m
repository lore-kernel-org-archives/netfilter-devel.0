Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3CEC77B75
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 11:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjEELRW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 07:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjEELRP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 07:17:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFBF9ED3
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 04:17:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1putQz-0005RQ-5r; Fri, 05 May 2023 13:17:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: nf_tables: validate register loads never access unitialised registers
Date:   Fri,  5 May 2023 13:16:55 +0200
Message-Id: <20230505111656.32238-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230505111656.32238-1-fw@strlen.de>
References: <20230505111656.32238-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reject rules where a load occurs from a register that has not seen a
store early in the same rule.

commit 4c905f6740a3 ("netfilter: nf_tables: initialize registers in nft_do_chain()")
had to add a unconditional memset to the nftables register space to
avoid leaking stack information to userspace.

This memset shows up in benchmarks.  After this change, this commit
can be reverted again.

Note that this breaks userspace compatibility, because theoretically
you can do

    rule 1: reg2 := meta load iif, reg2  == 1 jump ...
    rule 2: reg2 == 2 jump ...   // read access with no store in this rule

... after this change this is rejected.

Neither nftables nor iptables-nft generate such rules, each rule is
always standalone.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 37 ++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 246c4a4620ae..8c6068569fcf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -220,6 +220,7 @@ struct nft_ctx {
 	u8				family;
 	u8				level;
 	bool				report;
+	DECLARE_BITMAP(reg_inited, NFT_REG32_COUNT);
 };
 
 enum nft_data_desc_flags {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4fd6bbb88cd2..cd9deeccda0f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -139,6 +139,8 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->report	= nlmsg_report(nlh);
 	ctx->flags	= nlh->nlmsg_flags;
 	ctx->seq	= nlh->nlmsg_seq;
+
+	memset(ctx->reg_inited, 0, sizeof(ctx->reg_inited));
 }
 
 static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
@@ -10039,7 +10041,7 @@ static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 int nft_parse_register_load(const struct nft_ctx *ctx,
 			    const struct nlattr *attr, u8 *sreg, u32 len)
 {
-	u32 reg;
+	u32 reg, bit;
 	int err;
 
 	err = nft_parse_register(attr, &reg);
@@ -10050,11 +10052,37 @@ int nft_parse_register_load(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	for (bit = reg; len > 0; bit++) {
+		if (!test_bit(bit, ctx->reg_inited))
+			return -ENODATA;
+		if (len <= NFT_REG32_SIZE)
+			break;
+		len -= NFT_REG32_SIZE;
+	}
+
 	*sreg = reg;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_parse_register_load);
 
+static void nft_saw_register_store(const struct nft_ctx *__ctx,
+				   int reg, unsigned int len)
+{
+	unsigned int last_reg = reg + (len - 1) / NFT_REG32_SIZE;
+	struct nft_ctx *ctx = (struct nft_ctx *)__ctx;
+	int bit;
+
+	if (WARN_ON_ONCE(len == 0 || reg < 0))
+		return;
+
+	for (bit = reg; bit <= last_reg; bit++) {
+		if (WARN_ON_ONCE(bit >= NFT_REG32_COUNT))
+			return;
+
+		set_bit(bit, ctx->reg_inited);
+	}
+}
+
 static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_registers reg,
 				       const struct nft_data *data,
@@ -10076,7 +10104,7 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				return err;
 		}
 
-		return 0;
+		break;
 	default:
 		if (reg < NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE)
 			return -EINVAL;
@@ -10088,8 +10116,11 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 
 		if (data != NULL && type != NFT_DATA_VALUE)
 			return -EINVAL;
-		return 0;
+		break;
 	}
+
+	nft_saw_register_store(ctx, reg, len);
+	return 0;
 }
 
 int nft_parse_register_store(const struct nft_ctx *ctx,
-- 
2.39.2

