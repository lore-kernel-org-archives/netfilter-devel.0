Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E80C31771B
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 09:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755510882; cv=none; b=f2ColudePncbI2Ahx4AuBpOx4idj7q++ZSsfy0dAqy7Zb3T3QJqqf+cJsiXkfx2/GVScKYB/uJS14KftMdI6A+8QIphJKpXAwxtf8tHChWMmubBEWNAGo3TlRf4L/CvdrcYEse9F2r3/EccY4lP2y0+89Taacr2Dc7wlIMuB0CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755510882; c=relaxed/simple;
	bh=PymNCbTLJ1uZF9Zm58lY+YkDN5whFWbozJGQi/ADiXI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Z4bEr27OJxgrL+J1Rxc9F/huQDbAfAwKCh4pJTlWyWZ+C9U8s4ex4YwmIlgblCD9Vicc5jY5sUYS6Nczy2dd4fQ/yNxWpvZcz7+KsJ5c8UxzSKErf2i564pq34I2c9zFVbYvx9IuC5MpywkyMywQEZbXgG5jaE3qgcTwmi7+oLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cgdd1Dst; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=c+spNmxF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cgdd1Dst";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="c+spNmxF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0D1CD60263; Mon, 18 Aug 2025 11:54:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755510875;
	bh=ZhB2CVHeTTA6vHhGwLioLYqPCkcZHtIMifwfKkiz8/8=;
	h=From:To:Subject:Date:From;
	b=cgdd1Dst9HMvNTsqLvTZDMWb/jTlV+D1va2RMDe25jChzrt74Rutr2EWgrDa7c4Md
	 lDE0/7jJpfuXmjAZGOchMiN0BHyo9L8Qem/bKmfTX6potC/hSLfwJgrUXwtU/VlkK7
	 HpPbDH4B/M5BeElaoiLemFt+pa9VNpd5q+YLqWt+QIv7HeH6WJCmMxvsWKJh4CFRu/
	 qRoB0h6v3eWbizrK4G66aRwon4J1YO+65AVBQ5vPz8iFA5fCPQDH9o6dOaZBCi/JgN
	 DnpHJ4gn1JaTwHNLfUNNsOx7wlwxUMO2dOzPD0l6ORBIaQiAXhzVNVeUwlcM7AEJXv
	 PvEKgLJJNamGg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7A21F60255
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 11:54:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755510874;
	bh=ZhB2CVHeTTA6vHhGwLioLYqPCkcZHtIMifwfKkiz8/8=;
	h=From:To:Subject:Date:From;
	b=c+spNmxFAiiL7UZ6sMinN2LMMy0PuoPPprwMFztUsKXzEMsXNh4XTdlcOx9r4PMdw
	 lM/VRvtE/qS0eXLFVv1RvmDRA5/l7KSymqtl/e6WzNSFyYyNhYW/rCQs89ut99NbV6
	 7juYPL9hdpssTk2TjFT9t2kNvDlQC0Yflr2X+jJeJ0F8pWBM9KazW+sc7wCu2iriSU
	 jdTr5uuUwWEuqUzHukv3NP0saX3qfb19tykedRKyqZgffPbso4fAvfWOOFOG4BW3P1
	 D9eX7K+ZrWwOmq51/EFjmvakFgIO7RsW40e6tDLEszgUV9SqEogbHXepWkBoyznbJI
	 lDf7RDA5pTDIw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] src: ensure chain policy evaluation when specified
Date: Mon, 18 Aug 2025 11:54:31 +0200
Message-Id: <20250818095431.3189-1-pablo@netfilter.org>
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

Toggling this flag requires needs three adjustments to work though:

1) chain_evaluate() needs skip evaluation of hook name and priority if
   not specified to allow for updating the default chain policy, e.g.

	chain ip x y { policy accept; }

2) update netlink bytecode generation for chain to skip NFTA_CHAIN_HOOK
   so update path is exercised in the kernel.

3) error reporting needs to check if basechain priority and type is
   set on, otherwise skip further hints.

Fixes: acdfae9c3126 ("src: allow to specify the default policy for base chains")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: adjust error reporting path too.

 src/cmd.c                                     |  3 +++
 src/evaluate.c                                | 27 ++++++++++---------
 src/mnl.c                                     |  8 ++++--
 src/parser_bison.y                            |  1 +
 .../bogons/nft-f/basechain_bad_policy         |  2 ++
 .../bogons/nft-f/unexisting_chain_set_policy  |  5 ++++
 6 files changed, 32 insertions(+), 14 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/basechain_bad_policy
 create mode 100644 tests/shell/testcases/bogons/nft-f/unexisting_chain_set_policy

diff --git a/src/cmd.c b/src/cmd.c
index ff634af2ac24..9d5544f03c32 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -282,6 +282,9 @@ static int nft_cmd_chain_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		if (!(chain->flags & CHAIN_F_BASECHAIN))
 			break;
 
+		if (!chain->priority.expr || !chain->type.str)
+			break;
+
 		mpz_export_data(&priority, chain->priority.expr->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		if (priority <= -200 && !strcmp(chain->type.str, "nat"))
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
diff --git a/tests/shell/testcases/bogons/nft-f/unexisting_chain_set_policy b/tests/shell/testcases/bogons/nft-f/unexisting_chain_set_policy
new file mode 100644
index 000000000000..088955996490
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/unexisting_chain_set_policy
@@ -0,0 +1,5 @@
+table ip x {
+        chain y {
+                policy drop;
+        }
+}
-- 
2.30.2

