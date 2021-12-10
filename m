Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12BFC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Dec 2021 00:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhLJAcj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 19:32:39 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44422 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhLJAch (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 19:32:37 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AAC32605BA
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Dec 2021 01:26:39 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 08/11] netfilter: nf_tables: add register tracking infrastructure
Date:   Fri, 10 Dec 2021 01:28:51 +0100
Message-Id: <20211210002854.144328-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211210002854.144328-1-pablo@netfilter.org>
References: <20211210002854.144328-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds new infrastructure to skip redundant selector store
operations on the same register to achieve a performance boost from
the packet path.

This is particularly noticeable in pure linear rulesets but it also
helps in rulesets which are already heaving relying in maps to avoid
ruleset linear inspection.

The idea is to keep data of the most recurrent store operations on
register to reuse them with cmp and lookup expressions.

This infrastructure allows for dynamic ruleset updates since the ruleset
blob reduction happens from the kernel.

Userspace still needs to be updated to maximize register utilization to
cooperate to improve register data reuse / reduce number of store on
register operations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 12 ++++++++++++
 net/netfilter/nf_tables_api.c     | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5a046b01bdab..f894ff776151 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -120,6 +120,16 @@ struct nft_regs {
 	};
 };
 
+struct nft_regs_track {
+	struct {
+		const struct nft_expr		*selector;
+		const struct nft_expr		*bitwise;
+	} regs[20];
+
+	const struct nft_expr			*cur;
+	const struct nft_expr			*last;
+};
+
 /* Store/load an u8, u16 or u64 integer to/from the u32 data register.
  *
  * Note, when using concatenations, register allocation happens at 32-bit
@@ -884,6 +894,8 @@ struct nft_expr_ops {
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
+	bool				(*reduce)(struct nft_regs_track *track,
+						  const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
 					      const struct nft_expr *expr);
 	int				(*offload)(struct nft_offload_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8214537ba555..14cfc42f648b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8256,6 +8256,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 {
 	const struct nft_expr *expr, *last;
 	unsigned int alloc = 0, size = 0;
+	struct nft_regs_track track = {};
 	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
 	char *ptr;
@@ -8288,9 +8289,20 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 		prule = (struct nft_rule_dp *)ptr;
 		ptr += offsetof(struct nft_rule_dp, data);
 
+		size = 0;
+		track.last = last;
 		nft_rule_for_each_expr(expr, last, rule) {
+			track.cur = expr;
+
+			if (expr->ops->reduce &&
+			    expr->ops->reduce(&track, expr)) {
+				expr = track.cur;
+				continue;
+			}
+
 			memcpy(ptr, expr, expr->ops->size);
 			ptr += expr->ops->size;
+			size += expr->ops->size;
 		}
 		prule->handle = rule->handle;
 		prule->dlen = size;
-- 
2.30.2

