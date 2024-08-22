Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189DC1D27AA;
	Thu, 22 Aug 2024 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365193; cv=none; b=M6Ujyif0QQTrISstXSKA7fYkdOH1yk60pq7VcGvPlASv4Xuf3SJBIkHd6ZkUlJOD91d+WEWm6sPu2O05yhqPlff58ZWgiUg4L8HGAcms2ESkWEnofoPFWb1RViPPMP2WB8q8tMkkDikOkl5fd9zraAwLgFC4R+hIxjL5CnnZj50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365193; c=relaxed/simple;
	bh=NJqdkv0t15tyNMFDmmH5A4cFOc4rJ+O9QaPngpWY6T8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hxfSA90MV7YLLw5HUjR9p+mM1iKXhrNbX9Kul8C/Vqv4tHL4IQp1W+ijNBm5w0CCM96WZFk+IiNKqObo9+kPyJl2evJ1eCu+tSu/dddUlHvVLCiDAO7W7/VH0US/+9p2qvzbiPvVomkpUnQRdz4waaS7hlDjVL+tXyWifGQk91U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 8/9] netfilter: nf_tables: allow loads only when register is initialized
Date: Fri, 23 Aug 2024 00:19:38 +0200
Message-Id: <20240822221939.157858-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822221939.157858-1-pablo@netfilter.org>
References: <20240822221939.157858-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 573995e7a27e..1cc33d946d41 100644
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
index d05fc17bb9b7..904f2e25b4a4 100644
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
@@ -11041,8 +11043,8 @@ static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 int nft_parse_register_load(const struct nft_ctx *ctx,
 			    const struct nlattr *attr, u8 *sreg, u32 len)
 {
-	u32 reg;
-	int err;
+	int err, invalid_reg;
+	u32 reg, next_register;
 
 	err = nft_parse_register(attr, &reg);
 	if (err < 0)
@@ -11052,11 +11054,36 @@ int nft_parse_register_load(const struct nft_ctx *ctx,
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
@@ -11078,7 +11105,7 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				return err;
 		}
 
-		return 0;
+		break;
 	default:
 		if (type != NFT_DATA_VALUE)
 			return -EINVAL;
@@ -11091,8 +11118,11 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
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
2.30.2

