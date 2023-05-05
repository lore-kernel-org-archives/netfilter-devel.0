Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC2DC77B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbjEEPcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjEEPcE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:04 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D2F410F9
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 05/12] netfilter: nf_tables: check if register contains valid data before access
Date:   Fri,  5 May 2023 17:31:23 +0200
Message-Id: <20230505153130.2385-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a valid field to struct nft_regs which is initially zero, meaning
that the registers contain uninitialized data.

Expressions that call nft_reg_store*() to store data in destination
registers also call nft_reg_valid() to update register state.

Expressions that read from source register call nft_reg_is_valid() to
check if the registers contain valid data, otherwise expression hits
NFT_BREAK.

Set valid bitmask to zero, so all register are in invalid state. Since
expressions now use nft_reg_is_valid() to check if source register
contains valid data, no operations on the uninitialized data in the
stack is possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 46 +++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_core.c    |  3 +-
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ea258bfc6506..b1f0aa6c02d6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -117,6 +117,7 @@ struct nft_data {
  *	The first four data registers alias to the verdict register.
  */
 struct nft_regs {
+	u32				valid;
 	union {
 		u32			data[NFT_REG32_NUM];
 		struct nft_verdict	verdict;
@@ -134,6 +135,23 @@ struct nft_regs_track {
 	const struct nft_expr			*last;
 };
 
+static inline u32 nft_reg_valid_bitmask(u8 len)
+{
+	return (1 << DIV_ROUND_UP(len, 4)) - 1;
+}
+
+static inline void nft_reg_valid(struct nft_regs *regs, u8 dreg, u8 len)
+{
+	regs->valid |= nft_reg_valid_bitmask(len) << dreg;
+}
+
+static inline bool nft_reg_is_valid(const struct nft_regs *regs, u8 sreg, u8 len)
+{
+	u32 mask = nft_reg_valid_bitmask(len) << sreg;
+
+	return (regs->valid & mask) == mask;
+}
+
 /* Store/load an u8, u16 or u64 integer to/from the u32 data register.
  *
  * Note, when using concatenations, register allocation happens at 32-bit
@@ -143,31 +161,49 @@ struct nft_regs_track {
 
 static inline const u8 *nft_reg_load_u8(const struct nft_regs *regs, u32 sreg)
 {
+	if (!nft_reg_is_valid(regs, sreg, sizeof(u8)))
+		return NULL;
+
 	return (const u8 *)&regs->data[sreg];
 }
 
 static inline const u16 *nft_reg_load_u16(const struct nft_regs *regs, u32 sreg)
 {
+	if (!nft_reg_is_valid(regs, sreg, sizeof(u16)))
+		return NULL;
+
 	return (const u16 *)&regs->data[sreg];
 }
 
 static inline const u32 *nft_reg_load_u32(const struct nft_regs *regs, u32 sreg)
 {
+	if (!nft_reg_is_valid(regs, sreg, sizeof(u32)))
+		return NULL;
+
 	return &regs->data[sreg];
 }
 
 static inline const void *nft_reg_load(const struct nft_regs *regs, u32 sreg, u8 len)
 {
+	if (!nft_reg_is_valid(regs, sreg, len))
+		return NULL;
+
 	return (const void *)&regs->data[sreg];
 }
 
 static inline const __be16 *nft_reg_load_be16(const struct nft_regs *regs, u32 sreg)
 {
+	if (!nft_reg_is_valid(regs, sreg, sizeof(__be16)))
+		return NULL;
+
 	return (__force __be16 *)nft_reg_load_u16(regs, sreg);
 }
 
 static inline const __be32 *nft_reg_load_be32(const struct nft_regs *regs, u32 sreg)
 {
+	if (!nft_reg_is_valid(regs, sreg, sizeof(__be32)))
+		return NULL;
+
 	return (__force __be32 *)nft_reg_load_u32(regs, sreg);
 }
 
@@ -177,6 +213,7 @@ static inline void nft_reg_store_u8(struct nft_regs *regs, u32 dreg, u8 value)
 
 	*dest = 0;
 	*(u8 *)dest = value;
+	nft_reg_valid(regs, dreg, sizeof(u8));
 }
 
 static inline void nft_reg_store_u16(struct nft_regs *regs, u32 dreg, u16 value)
@@ -185,6 +222,7 @@ static inline void nft_reg_store_u16(struct nft_regs *regs, u32 dreg, u16 value)
 
 	*dest = 0;
 	*(u16 *)dest = value;
+	nft_reg_valid(regs, dreg, sizeof(u16));
 }
 
 static inline void nft_reg_store_be16(struct nft_regs *regs, u32 dreg, __be16 val)
@@ -197,6 +235,7 @@ static inline void nft_reg_store_u32(struct nft_regs *regs, u32 dreg, u32 value)
 	u32 *dest = &regs->data[dreg];
 
 	*dest = value;
+	nft_reg_valid(regs, dreg, sizeof(u32));
 }
 
 static inline void nft_reg_store_be32(struct nft_regs *regs, u32 dreg, __be32 val)
@@ -215,6 +254,8 @@ static inline int nft_reg_store_skb(struct nft_regs *regs, u32 dreg, int offset,
 	if (skb_copy_bits(skb, offset, dest, len) < 0)
 		return -1;
 
+	nft_reg_valid(regs, dreg, len);
+
 	return 0;
 }
 
@@ -223,6 +264,7 @@ static inline void nft_reg_store_u64(struct nft_regs *regs, u32 dreg, u64 val)
 	u32 *dest = &regs->data[dreg];
 
 	put_unaligned(val, (u64 *)dest);
+	nft_reg_valid(regs, dreg, sizeof(u64));
 }
 
 static inline void nft_reg_store_str(struct nft_regs *regs, u32 dreg, u8 len,
@@ -231,6 +273,7 @@ static inline void nft_reg_store_str(struct nft_regs *regs, u32 dreg, u8 len,
 	char *dest = (char *) &regs->data[dreg];
 
 	strncpy(dest, str, len);
+	nft_reg_valid(regs, dreg, len);
 }
 
 static inline void nft_reg_store(struct nft_regs *regs, u32 dreg, u8 len,
@@ -239,6 +282,7 @@ static inline void nft_reg_store(struct nft_regs *regs, u32 dreg, u8 len,
 	u32 *dest = &regs->data[dreg];
 
 	memcpy(dest, ptr, len);
+	nft_reg_valid(regs, dreg, len);
 }
 
 static inline void nft_reg_reset(struct nft_regs *regs, u32 dreg, u8 len)
@@ -246,6 +290,7 @@ static inline void nft_reg_reset(struct nft_regs *regs, u32 dreg, u8 len)
 	u32 *dest = &regs->data[dreg];
 
 	memset(dest, 0, len);
+	nft_reg_valid(regs, dreg, len);
 }
 
 static inline void nft_data_copy(struct nft_regs *regs,
@@ -258,6 +303,7 @@ static inline void nft_data_copy(struct nft_regs *regs,
 		dst[len / NFT_REG32_SIZE] = 0;
 
 	memcpy(dst, src, len);
+	nft_reg_valid(regs, dreg, len);
 }
 
 /**
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 812d580b61cf..2adfe443898a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -263,13 +263,14 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	const struct net *net = nft_net(pkt);
 	const struct nft_expr *expr, *last;
 	const struct nft_rule_dp *rule;
-	struct nft_regs regs = {};
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	bool genbit = READ_ONCE(net->nft.gencursor);
 	struct nft_rule_blob *blob;
 	struct nft_traceinfo info;
+	struct nft_regs regs;
 
+	regs.valid = 0;
 	info.trace = false;
 	if (static_branch_unlikely(&nft_trace_enabled))
 		nft_trace_init(&info, pkt, basechain);
-- 
2.30.2

