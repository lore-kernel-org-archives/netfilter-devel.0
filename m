Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37580149E17
	for <netfilter-devel@vger.kernel.org>; Sun, 17 Aug 2025 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755467244; cv=none; b=h5SAuP9iZ7jJUEdsW3XJyGNSB3IJzgrf+my9KGoSxDCpETTHoT0D7rCLewBNat45XTT+Xxv1NPC59IC/R5y7mJDaisSjn5lThYKfsU4CBjGPxzI2h9ISlYGMmMjj3z2FZPVfJ+dL1xfsqlC3ZCrWGhcv0AQCc1ASvFa2Ygbijbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755467244; c=relaxed/simple;
	bh=em/Dd/YnunKIjIvjp8Q9ZInAwOzqUeH8SD8BwktznMo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Wfx2sisOU/qU5EDAy0Yp0I+iMjh0kjBJYRH6r1bqF/AupQ84opcjYfx2Zjn/u0G5FS9VtCQKxK52E1fc+Di/kujpICXIidoeXOoYjOFpW/eIbT1ncBEye13QRgz7ynoTt9mu9cQYp3KaRMy6Um7/Y345/XiEjVgBqukeUG7kIPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RQW2hxL8; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RQW2hxL8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RQW2hxL8";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RQW2hxL8"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 83073602AD; Sun, 17 Aug 2025 23:47:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755467232;
	bh=thhcDcj8WkiG+D34/YlHAYn32VUbrGvNR8+0BUJDU6k=;
	h=From:To:Subject:Date:From;
	b=RQW2hxL8bzLgH/Xq+fN2bUKpxG5379xPQlCRum4cK4nZMwcG9UjeQpRkxYI5oFaIS
	 waqQXifOCWBKWcYxkuilHHlJ+fjbE4ZqOY/rcvvgOm/tonab0ZtOCgcFTKtKEqj7Tp
	 yC5U43iIkVitATkrqquW945JHYl13h9dZJVm+BlsJa1F03W0eZcsksaIvX+bh5lbRX
	 mIhQnHIHXtZoQe++5FKFijmCWItGT8DeybKWKudAH6BSvDSYVgjBJ6xn4hdlriKwd3
	 uTfms46DB1kLmC99ZFH1pZHPaQ68TbXvGbUP1c/fRqGRtDPa03qlLs/0lbywuq5xlY
	 wRU9YwWZYh2Lw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 02A39602A8
	for <netfilter-devel@vger.kernel.org>; Sun, 17 Aug 2025 23:47:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755467232;
	bh=thhcDcj8WkiG+D34/YlHAYn32VUbrGvNR8+0BUJDU6k=;
	h=From:To:Subject:Date:From;
	b=RQW2hxL8bzLgH/Xq+fN2bUKpxG5379xPQlCRum4cK4nZMwcG9UjeQpRkxYI5oFaIS
	 waqQXifOCWBKWcYxkuilHHlJ+fjbE4ZqOY/rcvvgOm/tonab0ZtOCgcFTKtKEqj7Tp
	 yC5U43iIkVitATkrqquW945JHYl13h9dZJVm+BlsJa1F03W0eZcsksaIvX+bh5lbRX
	 mIhQnHIHXtZoQe++5FKFijmCWItGT8DeybKWKudAH6BSvDSYVgjBJ6xn4hdlriKwd3
	 uTfms46DB1kLmC99ZFH1pZHPaQ68TbXvGbUP1c/fRqGRtDPa03qlLs/0lbywuq5xlY
	 wRU9YwWZYh2Lw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: ensure chain policy evaluation when specified
Date: Sun, 17 Aug 2025 23:47:06 +0200
Message-Id: <20250817214706.314771-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set on CHAIN_F_BASECHAIN when policy is specified in chain, otherwise
chain priority is not evaluated.

Toggling this flag requires needs two adjustments to work though:

1) chain_evaluate() needs skip evaluation of hook name and priority if
   not specified to allow for updating the default chain policy, e.g.

	chain ip x y { policy accept; }

2) update netlink bytecode generation for chain to skip NFTA_CHAIN_HOOK
   so update path is exercised in the kernel.

Fixes: acdfae9c3126 ("src: allow to specify the default policy for base chains")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                | 27 ++++++++++---------
 src/mnl.c                                     |  8 ++++--
 src/parser_bison.y                            |  1 +
 .../bogons/nft-f/basechain_bad_policy         |  2 ++
 4 files changed, 24 insertions(+), 14 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/basechain_bad_policy

diff --git a/src/evaluate.c b/src/evaluate.c
index 8f037601c45f..7b524b418eb7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5772,18 +5772,21 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	}
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		chain->hook.num = str2hooknum(chain->handle.family,
-					      chain->hook.name);
-		if (chain->hook.num == NF_INET_NUMHOOKS)
-			return __stmt_binary_error(ctx, &chain->hook.loc, NULL,
-						   "The %s family does not support this hook",
-						   family2str(chain->handle.family));
-
-		if (!evaluate_priority(ctx, &chain->priority,
-				       chain->handle.family, chain->hook.num))
-			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
-						   "invalid priority expression %s in this context.",
-						   expr_name(chain->priority.expr));
+		if (chain->hook.name) {
+			chain->hook.num = str2hooknum(chain->handle.family,
+						      chain->hook.name);
+			if (chain->hook.num == NF_INET_NUMHOOKS)
+				return __stmt_binary_error(ctx, &chain->hook.loc, NULL,
+							   "The %s family does not support this hook",
+							   family2str(chain->handle.family));
+		}
+		if (chain->priority.expr) {
+			if (!evaluate_priority(ctx, &chain->priority,
+					       chain->handle.family, chain->hook.num))
+				return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
+							   "invalid priority expression %s in this context.",
+							   expr_name(chain->priority.expr));
+		}
 		if (chain->policy) {
 			expr_set_context(&ctx->ectx, &policy_type,
 					 NFT_NAME_MAXLEN * BITS_PER_BYTE);
diff --git a/src/mnl.c b/src/mnl.c
index 43229f2498e5..ceb43b06690c 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -897,7 +897,9 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, cmd->chain->type.str);
 		}
 
-		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
+		if (cmd->chain->type.str ||
+		    (cmd->chain && cmd->chain->dev_expr))
+			nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
 
 		if (cmd->chain->type.str) {
 			mnl_attr_put_u32(nlh, NFTA_HOOK_HOOKNUM, htonl(cmd->chain->hook.num));
@@ -909,7 +911,9 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		if (cmd->chain && cmd->chain->dev_expr)
 			mnl_nft_chain_devs_build(nlh, cmd);
 
-		mnl_attr_nest_end(nlh, nest);
+		if (cmd->chain->type.str ||
+		    (cmd->chain && cmd->chain->dev_expr))
+			mnl_attr_nest_end(nlh, nest);
 	}
 
 	nftnl_chain_free(nlc);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0b1ea699c610..1e4b3f8a50c5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2834,6 +2834,7 @@ policy_spec		:	POLICY		policy_expr	close_scope_policy
 				}
 				$<chain>0->policy		= $2;
 				$<chain>0->policy->location	= @$;
+				$<chain>0->flags		|= CHAIN_F_BASECHAIN;
 			}
 			;
 
diff --git a/tests/shell/testcases/bogons/nft-f/basechain_bad_policy b/tests/shell/testcases/bogons/nft-f/basechain_bad_policy
new file mode 100644
index 000000000000..998e423cb7b4
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/basechain_bad_policy
@@ -0,0 +1,2 @@
+define MY_POLICY = deny
+table T { chain C { policy $MY_POLICY; };};
-- 
2.30.2

