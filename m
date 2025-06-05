Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AEA2749E8
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Jun 2025 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141907; cv=none; b=ILCjUBvrHqTzvbe6eoIatDYAONHLi9RUMUb9WupnDvokN7Y6MikAEs6G5XpeYepezvst/Iih6Q+Np2z0+7uJj5TCZ7euZkZhgbolMZv4G1MlOa9gSFlnXa3bVg8rcfOXhcpOVsZ7O3me/CM+5ne7g+tFxx3kahMlCYzSSGIqzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141907; c=relaxed/simple;
	bh=52OeyDeZCYyI8SI0Sy3tS+UC208CuHaEd0sy+ell6uc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TlBCnkY1TvTNgakFh54uGKkQfjFvY5VFx5N1ex07GXOWwzPQCXFTWRq5vCCoQPIjQ7WTCtqJiFfxBBJU4QejuAEl1oRLBvcoD3wrvcXoJ/GT3FzFOAb7hexBw6OQUg1rSSyL4CN7h29wU+sWrHRCQhJlBgXaatvy5kQNUiw4VD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9C38F60A0A; Thu,  5 Jun 2025 18:45:02 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: move BASECHAIN flag toggle to netlink linearize code for device update
Date: Thu,  5 Jun 2025 18:44:54 +0200
Message-ID: <20250605164457.32614-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The included bogon will crash nft because print side assumes that
a BASECHAIN flag presence also means that priority expression is
available.

We can either make the print side conditional or move the BASECHAIN
setting to the last possible moment.

Fixes: a66b5ad9540d ("src: allow for updating devices on existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                      |  3 ---
 src/mnl.c                                           | 13 +++++++++----
 .../testcases/bogons/nft-f/null_ingress_type_crash  |  6 ++++++
 3 files changed, 15 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/null_ingress_type_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index 014ee721cc04..b9a140172b2b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6030,9 +6030,6 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	}
 
 	if (chain->dev_expr) {
-		if (!(chain->flags & CHAIN_F_BASECHAIN))
-			chain->flags |= CHAIN_F_BASECHAIN;
-
 		if (chain->handle.family == NFPROTO_NETDEV ||
 		    (chain->handle.family == NFPROTO_INET &&
 		     chain->hook.num == NF_INET_INGRESS)) {
diff --git a/src/mnl.c b/src/mnl.c
index 6565341fa6e3..9a885ee02739 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -821,6 +821,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags)
 {
 	struct nftnl_udata_buf *udbuf;
+	uint32_t chain_flags = 0;
 	struct nftnl_chain *nlc;
 	struct nlmsghdr *nlh;
 	int priority, policy;
@@ -846,6 +847,10 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 					     nftnl_udata_buf_len(udbuf));
 			nftnl_udata_buf_free(udbuf);
 		}
+
+		chain_flags = cmd->chain->flags;
+		if (cmd->chain->dev_expr)
+			chain_flags |= CHAIN_F_BASECHAIN;
 	}
 
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, cmd->handle.table.name);
@@ -866,7 +871,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
 	cmd_add_loc(cmd, nlh, &cmd->handle.chain.location);
 
-	if (!cmd->chain || !(cmd->chain->flags & CHAIN_F_BINDING)) {
+	if (!(chain_flags & CHAIN_F_BINDING)) {
 		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
 	} else {
 		if (cmd->handle.chain.name)
@@ -874,8 +879,8 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 					  cmd->handle.chain.name);
 
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_ID, htonl(cmd->handle.chain_id));
-		if (cmd->chain->flags)
-			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, cmd->chain->flags);
+		if (chain_flags)
+			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, chain_flags);
 	}
 
 	if (cmd->chain && cmd->chain->policy) {
@@ -889,7 +894,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	if (cmd->chain && cmd->chain->flags & CHAIN_F_BASECHAIN) {
+	if (chain_flags & CHAIN_F_BASECHAIN) {
 		struct nlattr *nest;
 
 		if (cmd->chain->type.str) {
diff --git a/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash b/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash
new file mode 100644
index 000000000000..2ed88af24c56
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash
@@ -0,0 +1,6 @@
+table netdev filter1 {
+	chain c {
+		devices = { lo }
+	}
+}
+list ruleset
-- 
2.49.0

