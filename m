Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CBD14A4D4
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 09:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724838037; cv=none; b=hbbwWI7/13NiR8H5M5w+vrrU/TVqYgHhHS36/904OCv0teADllh6YjN01febrqdZtEtoeBI58u5PldyZb7sAf57EgQwVLWpjF0S0BIQUsPTPmQDAQMS0U3+mqj6iqdge24b/wWoUnGYF6V+ab/5q903Cz0SjcOwhyZwR/NCNMwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724838037; c=relaxed/simple;
	bh=HiUfCXKj1w2cUUV+ISSe5obOVMnpDw89MwRcXZ+vVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hW3pP4Gpx29IYcuh5wsprUKJRD7YPvScf9LolN5i208BfX25nH7cVrS2NDzylKxaFJOBlfqwbYm5uvWxpYMvHhVCYnhMYSPKyPlqSmn3jyio3uZFlxbwQ9njPg46K6IkP+4pQNB239QUlKfseiLEewngEJWFx/kogIWbPQfLm8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sjFA7-00055b-Lq; Wed, 28 Aug 2024 11:40:23 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: drop unused 3rd argument from validate callback ops
Date: Wed, 28 Aug 2024 11:34:02 +0200
Message-ID: <20240828093409.2792-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
the validate() callback no longer needs the return pointer argument.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h        | 3 +--
 include/net/netfilter/nft_fib.h          | 4 +---
 include/net/netfilter/nft_meta.h         | 3 +--
 include/net/netfilter/nft_reject.h       | 3 +--
 net/bridge/netfilter/nft_meta_bridge.c   | 5 ++---
 net/bridge/netfilter/nft_reject_bridge.c | 3 +--
 net/netfilter/nf_tables_api.c            | 3 +--
 net/netfilter/nft_compat.c               | 6 ++----
 net/netfilter/nft_fib.c                  | 3 +--
 net/netfilter/nft_flow_offload.c         | 3 +--
 net/netfilter/nft_fwd_netdev.c           | 3 +--
 net/netfilter/nft_immediate.c            | 3 +--
 net/netfilter/nft_lookup.c               | 3 +--
 net/netfilter/nft_masq.c                 | 3 +--
 net/netfilter/nft_meta.c                 | 6 ++----
 net/netfilter/nft_nat.c                  | 3 +--
 net/netfilter/nft_osf.c                  | 3 +--
 net/netfilter/nft_queue.c                | 3 +--
 net/netfilter/nft_redir.c                | 3 +--
 net/netfilter/nft_reject.c               | 3 +--
 net/netfilter/nft_reject_inet.c          | 3 +--
 net/netfilter/nft_reject_netdev.c        | 3 +--
 net/netfilter/nft_rt.c                   | 3 +--
 net/netfilter/nft_socket.c               | 3 +--
 net/netfilter/nft_synproxy.c             | 3 +--
 net/netfilter/nft_tproxy.c               | 3 +--
 net/netfilter/nft_xfrm.c                 | 3 +--
 27 files changed, 30 insertions(+), 60 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1cc33d946d41..7cd60ea7cdee 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -961,8 +961,7 @@ struct nft_expr_ops {
 						const struct nft_expr *expr,
 						bool reset);
 	int				(*validate)(const struct nft_ctx *ctx,
-						    const struct nft_expr *expr,
-						    const struct nft_data **data);
+						    const struct nft_expr *expr);
 	bool				(*reduce)(struct nft_regs_track *track,
 						  const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 167640b843ef..38cae7113de4 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -21,9 +21,7 @@ nft_fib_is_loopback(const struct sk_buff *skb, const struct net_device *in)
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
-int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		     const struct nft_data **data);
-
+int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr);
 
 void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 			const struct nft_pktinfo *pkt);
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index ba1238f12a48..d602263590fe 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -41,8 +41,7 @@ void nft_meta_set_destroy(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data);
+			  const struct nft_expr *expr);
 
 bool nft_meta_get_reduce(struct nft_regs_track *track,
 			 const struct nft_expr *expr);
diff --git a/include/net/netfilter/nft_reject.h b/include/net/netfilter/nft_reject.h
index 6d9ba62efd75..19060212988a 100644
--- a/include/net/netfilter/nft_reject.h
+++ b/include/net/netfilter/nft_reject.h
@@ -15,8 +15,7 @@ struct nft_reject {
 extern const struct nla_policy nft_reject_policy[];
 
 int nft_reject_validate(const struct nft_ctx *ctx,
-			const struct nft_expr *expr,
-			const struct nft_data **data);
+			const struct nft_expr *expr);
 
 int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nft_expr *expr,
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 4d8e15927217..d12a221366d6 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -168,8 +168,7 @@ static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 }
 
 static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
-					const struct nft_expr *expr,
-					const struct nft_data **data)
+					const struct nft_expr *expr)
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
@@ -179,7 +178,7 @@ static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
 		hooks = 1 << NF_BR_PRE_ROUTING;
 		break;
 	default:
-		return nft_meta_set_validate(ctx, expr, data);
+		return nft_meta_set_validate(ctx, expr);
 	}
 
 	return nft_chain_validate_hooks(ctx->chain, hooks);
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 71b54fed7263..1cb5c16e97b7 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -170,8 +170,7 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 }
 
 static int nft_reject_bridge_validate(const struct nft_ctx *ctx,
-				      const struct nft_expr *expr,
-				      const struct nft_data **data)
+				      const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_BR_PRE_ROUTING) |
 						    (1 << NF_BR_LOCAL_IN));
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 904f2e25b4a4..b6547fe22bd8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3886,7 +3886,6 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
-	const struct nft_data *data;
 	struct nft_rule *rule;
 	int err;
 
@@ -3907,7 +3906,7 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 			/* This may call nft_chain_validate() recursively,
 			 * callers that do so must increment ctx->level.
 			 */
-			err = expr->ops->validate(ctx, expr, &data);
+			err = expr->ops->validate(ctx, expr);
 			if (err < 0)
 				return err;
 		}
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index d3d11dede545..52cdfee17f73 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -350,8 +350,7 @@ static int nft_target_dump(struct sk_buff *skb,
 }
 
 static int nft_target_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	struct xt_target *target = expr->ops->data;
 	unsigned int hook_mask = 0;
@@ -611,8 +610,7 @@ static int nft_match_large_dump(struct sk_buff *skb,
 }
 
 static int nft_match_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	struct xt_match *match = expr->ops->data;
 	unsigned int hook_mask = 0;
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index b58f62195ff3..96e02a83c045 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -26,8 +26,7 @@ const struct nla_policy nft_fib_policy[NFTA_FIB_MAX + 1] = {
 };
 EXPORT_SYMBOL(nft_fib_policy);
 
-int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		     const struct nft_data **data)
+int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	unsigned int hooks;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ab9576098701..9dcd1548df9d 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -380,8 +380,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 }
 
 static int nft_flow_offload_validate(const struct nft_ctx *ctx,
-				     const struct nft_expr *expr,
-				     const struct nft_data **data)
+				     const struct nft_expr *expr)
 {
 	unsigned int hook_mask = (1 << NF_INET_FORWARD);
 
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index c83a794025f9..152a9fb4d23a 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -204,8 +204,7 @@ static int nft_fwd_neigh_dump(struct sk_buff *skb,
 }
 
 static int nft_fwd_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS) |
 						    (1 << NF_NETDEV_EGRESS));
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index ac2422c215e5..02ee5fb69871 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -244,8 +244,7 @@ static int nft_immediate_dump(struct sk_buff *skb,
 }
 
 static int nft_immediate_validate(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr,
-				  const struct nft_data **d)
+				  const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 580e4b1deb9b..63ef832b8aa7 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -206,8 +206,7 @@ static int nft_lookup_dump(struct sk_buff *skb,
 }
 
 static int nft_lookup_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **d)
+			       const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	struct nft_set_iter iter;
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index cb43c72a8c2a..868bd4d73555 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -27,8 +27,7 @@ static const struct nla_policy nft_masq_policy[NFTA_MASQ_MAX + 1] = {
 };
 
 static int nft_masq_validate(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nft_data **data)
+			     const struct nft_expr *expr)
 {
 	int err;
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 0214ad1ced2f..8c8eb14d647b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -581,8 +581,7 @@ static int nft_meta_get_validate_xfrm(const struct nft_ctx *ctx)
 }
 
 static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+				 const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -600,8 +599,7 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 }
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data)
+			  const struct nft_expr *expr)
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 983dd937fe02..6e21f72c5b57 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -137,8 +137,7 @@ static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
 };
 
 static int nft_nat_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	struct nft_nat *priv = nft_expr_priv(expr);
 	int err;
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 7fec57ff736f..1c0b493ef0a9 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -108,8 +108,7 @@ static int nft_osf_dump(struct sk_buff *skb,
 }
 
 static int nft_osf_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	unsigned int hooks;
 
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 44e6817e6e29..344fe311878f 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -69,8 +69,7 @@ static void nft_queue_sreg_eval(const struct nft_expr *expr,
 }
 
 static int nft_queue_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	static const unsigned int supported_hooks = ((1 << NF_INET_PRE_ROUTING) |
 						     (1 << NF_INET_LOCAL_IN) |
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 6568cc264078..95eedad85c83 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -27,8 +27,7 @@ static const struct nla_policy nft_redir_policy[NFTA_REDIR_MAX + 1] = {
 };
 
 static int nft_redir_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	int err;
 
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index ed2e668474d6..196a92c7ea09 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -24,8 +24,7 @@ const struct nla_policy nft_reject_policy[NFTA_REJECT_MAX + 1] = {
 EXPORT_SYMBOL_GPL(nft_reject_policy);
 
 int nft_reject_validate(const struct nft_ctx *ctx,
-			const struct nft_expr *expr,
-			const struct nft_data **data)
+			const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 973fa31a9dd6..49020e67304a 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -61,8 +61,7 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 }
 
 static int nft_reject_inet_validate(const struct nft_ctx *ctx,
-				    const struct nft_expr *expr,
-				    const struct nft_data **data)
+				    const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
index 7865cd8b11bb..2558ce1505d9 100644
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -145,8 +145,7 @@ static void nft_reject_netdev_eval(const struct nft_expr *expr,
 }
 
 static int nft_reject_netdev_validate(const struct nft_ctx *ctx,
-				      const struct nft_expr *expr,
-				      const struct nft_data **data)
+				      const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 14d88394bcb7..dc50b9a5bd68 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -160,8 +160,7 @@ static int nft_rt_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			   const struct nft_data **data)
+static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	unsigned int hooks;
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index f30163e2ca62..947566dba1ea 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -239,8 +239,7 @@ static bool nft_socket_reduce(struct nft_regs_track *track,
 }
 
 static int nft_socket_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 1d737f89dfc1..5d3e51825985 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -248,8 +248,7 @@ static void nft_synproxy_eval(const struct nft_expr *expr,
 }
 
 static int nft_synproxy_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+				 const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 1b691393d8b1..50481280abd2 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -313,8 +313,7 @@ static int nft_tproxy_dump(struct sk_buff *skb,
 }
 
 static int nft_tproxy_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 1c866757db55..8a07b46cc8fb 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -229,8 +229,7 @@ static int nft_xfrm_get_dump(struct sk_buff *skb,
 	return 0;
 }
 
-static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			     const struct nft_data **data)
+static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 	unsigned int hooks;
-- 
2.44.2

