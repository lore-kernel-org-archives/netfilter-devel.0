Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB3018C939
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 10:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148088; cv=none; b=Q5WcpRiEssHNg5D3SfWOthdCv73iqU2xhxFCjdfe5J+KKKs8xqbFNmNLZIb5r+AqMc5DuXIm6XjnZpVfhMdKsKKis0bOad+xCyab8VPoysYnsIBqrZbOU+VHHjACjYFLx1G9OOdcVKzqI9zVn4F2NxNDCrtSAgkHS4s15WBQdvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148088; c=relaxed/simple;
	bh=0jwveIrEI0BVN7C43be/rB2DQ3SyIJn8N8c4/sHKmPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpT7QtvFBj3zDtn4jKLk+vx2YwaUvKq2WAzaYKO1GkxDP3K+GYqN6Nkx/ldtClCpd24h9gPD5xiV0NoLmU4i2vwX+Z/3I2RjMflLPV7moYlE5LhVad62/53gfSX2QchNJqCF01reG91SRsqhk3sQxJ24PX61UnnQ8tW/ynd/0tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sgLg5-0004KM-1Z; Tue, 20 Aug 2024 12:01:25 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: nf_tables: allow loads only when register is initialized
Date: Tue, 20 Aug 2024 11:56:13 +0200
Message-ID: <20240820095619.6273-3-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240820095619.6273-1-fw@strlen.de>
References: <20240820095619.6273-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject rules where a load occurs from a register that has not seen a store
early in the same rule.

commit 4c905f6740a3 ("netfilter: nf_tables: initialize registers in
nft_do_chain()")
had to add a unconditional memset to the nftables register space to avoid
leaking stack information to userspace.

This memset shows up in benchmarks.  After this change, this commit can
be reverted again.

Note that this breaks userspace compatibility, because theoretically
you can do

  rule 1: reg2 := meta load iif, reg2  == 1 jump ...
  rule 2: reg2 == 2 jump ...   // read access with no store in this rule

... after this change this is rejected.

Neither nftables nor iptables-nft generate such rules, each rule is
always standalone.

This resuts in a small increase of nft_ctx structure by sizeof(long).

To cope with hypothetical rulesets like the example above one could emit
on-demand "reg[x] = 0" store when generating the datapath blob in
nf_tables_commit_chain_prepare().

A patch that does this is linked to below.

For now, lets disable this.  In nf_tables, a rule is the smallest
unit that can be replaced from userspace, i.e. a hypothetical ruleset
that relies on earlier initialisations of registers can't be changed
at will as register usage would need to be coordinated.

Link: https://lore.kernel.org/netfilter-devel/20240627135330.17039-4-fw@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 821b46c0ef4d..b5c708a5f3b2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -221,6 +221,7 @@ struct nft_ctx {
 	u8				family;
 	u8				level;
 	bool				report;
+	DECLARE_BITMAP(reg_inited, NFT_REG32_NUM);
 };
 
 enum nft_data_desc_flags {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 254e8f77defe..5edcb1fea64a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -146,6 +146,8 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->report	= nlmsg_report(nlh);
 	ctx->flags	= nlh->nlmsg_flags;
 	ctx->seq	= nlh->nlmsg_seq;
+
+	bitmap_zero(ctx->reg_inited, NFT_REG32_NUM);
 }
 
 static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
@@ -11029,8 +11031,8 @@ static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 int nft_parse_register_load(const struct nft_ctx *ctx,
 			    const struct nlattr *attr, u8 *sreg, u32 len)
 {
-	u32 reg;
-	int err;
+	int err, invalid_reg;
+	u32 reg, next_register;
 
 	err = nft_parse_register(attr, &reg);
 	if (err < 0)
@@ -11040,11 +11042,36 @@ int nft_parse_register_load(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	next_register = DIV_ROUND_UP(len, NFT_REG32_SIZE) + reg;
+
+	/* Can't happen: nft_validate_register_load() should have failed */
+	if (WARN_ON_ONCE(next_register > NFT_REG32_NUM))
+		return -EINVAL;
+
+	/* find first register that did not see an earlier store. */
+	invalid_reg = find_next_zero_bit(ctx->reg_inited, NFT_REG32_NUM, reg);
+
+	/* invalid register within the range that we're loading from? */
+	if (invalid_reg < next_register)
+		return -ENODATA;
+
 	*sreg = reg;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_parse_register_load);
 
+static void nft_saw_register_store(const struct nft_ctx *__ctx,
+				   int reg, unsigned int len)
+{
+	unsigned int registers = DIV_ROUND_UP(len, NFT_REG32_SIZE);
+	struct nft_ctx *ctx = (struct nft_ctx *)__ctx;
+
+	if (WARN_ON_ONCE(len == 0 || reg < 0))
+		return;
+
+	bitmap_set(ctx->reg_inited, reg, registers);
+}
+
 static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_registers reg,
 				       const struct nft_data *data,
@@ -11066,7 +11093,7 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				return err;
 		}
 
-		return 0;
+		break;
 	default:
 		if (type != NFT_DATA_VALUE)
 			return -EINVAL;
@@ -11079,8 +11106,11 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 		    sizeof_field(struct nft_regs, data))
 			return -ERANGE;
 
-		return 0;
+		break;
 	}
+
+	nft_saw_register_store(ctx, reg, len);
+	return 0;
 }
 
 int nft_parse_register_store(const struct nft_ctx *ctx,
-- 
2.44.2

