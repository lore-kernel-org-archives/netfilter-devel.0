Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2894339E171;
	Sun, 14 Jun 2026 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437576; cv=none; b=MRhwETaE3UhB4mWDz2OJBKE1W6phHXZ7kaQIIPtuc5W4rW+PlIFqTiDg30rzkDB99/3K/NTz7Fk2MPuhxUTQH3d42RQzmjGMj9MwnMZlKO843HtdjuTXyww8yV1hnnVCAa8MlICC4vzvH+mXtDAfQb+lCLvU1ZAkOHJe81a2/+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437576; c=relaxed/simple;
	bh=3bNNnOjV7oEHEsFJE+DXc2yOM7S08dw8+JC7MmDZq9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wg1AWsglWpJuhxKjWogahVxXdnzDcAQb4+tLCqLftDiUUJ4zCU2oIc1JlCcILbW/gHyKfoowypT2L2TjCE0Cx9HpuXHPgix4OLqRtDJHfQwxAV83toXmO/02Z00PXX5t06LpYXp3yjjBFxC5F6FzLMwmX81UzJ3VSJR/BUKTwLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HSeUeIaa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HSeUeIaa"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6660760195;
	Sun, 14 Jun 2026 13:46:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437571;
	bh=SgD+sFUxodvAPSVp/y6SCRD6SToLRFQX+69W6SQn0DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSeUeIaaarW1XqaJ2TN6TkBX4Wj/PeN2zcAG81OGikbEUoaIIiRf9H9g2JwVteWM3
	 Kci+QQVcYJVHGwwmeI1l1hhEUJFzSs/cc5J8UAUFn6NM9E/uxrsHTO4w548u6cfXlP
	 lqfClVnfY4SlTm0UKsxmZSWpLQ/9arYmUL1YX0THCW5CAkHaGPJb75jDZc3U97H/20
	 P8Ekb1dS4+eASJ1gWZ+2d0JY7g3GKT+7uIXpJ5XgZh0L4/NGbTygO8MhgIQR0+qhMz
	 yqikCHinaXbPR0GQGxyg7Hhxs12OShMB6WlS8JH4QqtTKkDjfMV5kVslnemc3vJglY
	 EIndkI4ZDDZIA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 02/11] netfilter: nf_tables: use DEBUG_NET_WARN_ON_ONCE in packet and control paths
Date: Sun, 14 Jun 2026 13:45:56 +0200
Message-ID: <20260614114605.474783-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260614114605.474783-1-pablo@netfilter.org>
References: <20260614114605.474783-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Replace raw warning macros with DEBUG_NET_WARN_ON_ONCE across the
nf_tables API, core engine, and expression evaluations. This prevents
unnecessary system panics when panic_on_warn=1 is enabled in production
systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++++++++++--------
 net/netfilter/nf_tables_core.c    |  8 ++++---
 net/netfilter/nf_tables_offload.c |  2 +-
 net/netfilter/nf_tables_trace.c   |  6 +++--
 net/netfilter/nft_ct.c            |  2 +-
 net/netfilter/nft_ct_fast.c       |  2 +-
 net/netfilter/nft_exthdr.c        |  2 +-
 net/netfilter/nft_fib.c           |  2 +-
 net/netfilter/nft_inner.c         |  2 +-
 net/netfilter/nft_lookup.c        |  2 +-
 net/netfilter/nft_masq.c          |  2 +-
 net/netfilter/nft_meta.c          | 10 ++++----
 net/netfilter/nft_payload.c       |  6 ++---
 net/netfilter/nft_redir.c         |  2 +-
 net/netfilter/nft_reject.c        |  8 +++++--
 net/netfilter/nft_rt.c            |  2 +-
 net/netfilter/nft_set_hash.c      |  2 +-
 net/netfilter/nft_set_pipapo.c    |  2 +-
 net/netfilter/nft_set_rbtree.c    |  6 +++--
 net/netfilter/nft_socket.c        |  8 ++++---
 net/netfilter/nft_tunnel.c        |  2 +-
 net/netfilter/nft_xfrm.c          |  6 ++---
 22 files changed, 76 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 87387adbca65..4884f7f7aaee 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3378,8 +3378,10 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
-	if (WARN_ON_ONCE(type->maxattr > NFT_EXPR_MAXATTR))
+	if (unlikely(type->maxattr > NFT_EXPR_MAXATTR)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOMEM;
+	}
 
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
@@ -3691,8 +3693,10 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src, gfp_t gfp)
 {
 	int err;
 
-	if (WARN_ON_ONCE(!src->ops->clone))
+	if (unlikely(!src->ops->clone)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	dst->ops = src->ops;
 	err = src->ops->clone(dst, src, gfp);
@@ -8327,8 +8331,10 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			return 0;
 
 		type = nft_obj_type_get(net, objtype, family);
-		if (WARN_ON_ONCE(IS_ERR(type)))
+		if (IS_ERR(type)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return PTR_ERR(type);
+		}
 
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
@@ -10306,19 +10312,25 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 		prule = (struct nft_rule_dp *)data;
 		data += offsetof(struct nft_rule_dp, data);
-		if (WARN_ON_ONCE(data > data_boundary))
+		if (unlikely(data > data_boundary)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return -ENOMEM;
+		}
 
 		size = 0;
 		nft_rule_for_each_expr(expr, last, rule) {
-			if (WARN_ON_ONCE(data + size + expr->ops->size > data_boundary))
+			if (unlikely(data + size + expr->ops->size > data_boundary)) {
+				DEBUG_NET_WARN_ON_ONCE(1);
 				return -ENOMEM;
+			}
 
 			memcpy(data + size, expr, expr->ops->size);
 			size += expr->ops->size;
 		}
-		if (WARN_ON_ONCE(size >= 1 << 12))
+		if (unlikely(size >= 1 << 12)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return -ENOMEM;
+		}
 
 		prule->handle = rule->handle;
 		prule->dlen = size;
@@ -10329,8 +10341,10 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 		chain->blob_next->size += (unsigned long)(data - (void *)prule);
 	}
 
-	if (WARN_ON_ONCE(data > data_boundary))
+	if (unlikely(data > data_boundary)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOMEM;
+	}
 
 	prule = (struct nft_rule_dp *)data;
 	nft_last_rule(chain, prule);
@@ -11636,8 +11650,10 @@ int nft_parse_register_load(const struct nft_ctx *ctx,
 	next_register = DIV_ROUND_UP(len, NFT_REG32_SIZE) + reg;
 
 	/* Can't happen: nft_validate_register_load() should have failed */
-	if (WARN_ON_ONCE(next_register > NFT_REG32_NUM))
+	if (unlikely(next_register > NFT_REG32_NUM)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	/* find first register that did not see an earlier store. */
 	invalid_reg = find_next_zero_bit(ctx->reg_inited, NFT_REG32_NUM, reg);
@@ -11884,8 +11900,10 @@ int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
 	struct nlattr *tb[NFTA_DATA_MAX + 1];
 	int err;
 
-	if (WARN_ON_ONCE(!desc->size))
+	if (unlikely(!desc->size)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	err = nla_parse_nested_deprecated(tb, NFTA_DATA_MAX, nla,
 					  nft_data_policy, NULL);
@@ -11950,7 +11968,7 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 		break;
 	default:
 		err = -EINVAL;
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 	}
 
 	nla_nest_end(skb, nest);
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 8ab186f86dd4..01a72f334dc6 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -314,8 +314,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
 	switch (regs.verdict.code) {
 	case NFT_JUMP:
-		if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
-			return NF_DROP;
+		if (unlikely(stackptr >= NFT_JUMP_STACK_SIZE)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
+			return NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, ELOOP);
+		}
 		jumpstack[stackptr].rule = nft_rule_next(rule);
 		stackptr++;
 		fallthrough;
@@ -326,7 +328,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	case NFT_RETURN:
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 	}
 
 	if (stackptr > 0) {
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9101b1703b52..8998a24651ff 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -361,7 +361,7 @@ static int nft_block_setup(struct nft_base_chain *basechain,
 		err = nft_flow_offload_unbind(bo, basechain);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
 
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index a88abae5a9de..d85b6a2fb43c 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -227,8 +227,10 @@ static const struct nft_chain *nft_trace_get_chain(const struct nft_rule_dp *rul
 
 	last = (const struct nft_rule_dp_last *)rule;
 
-	if (WARN_ON_ONCE(!last->chain))
+	if (unlikely(!last->chain)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return &info->basechain->chain;
+	}
 
 	return last->chain;
 }
@@ -354,7 +356,7 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	return;
 
  nla_put_failure:
-	WARN_ON_ONCE(1);
+	DEBUG_NET_WARN_ON_ONCE(1);
 	kfree_skb(skb);
 }
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9fe179d688da..25934c6f01fb 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1132,7 +1132,7 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 		to_assign = priv->helper6;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return;
 	}
 
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
index ecf7b3a404be..a44524c4fe63 100644
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -53,7 +53,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 		return;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 		break;
 	}
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index e6a07c0df207..8861b4d191d1 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -298,7 +298,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 						 old.v32, new.v32, false);
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			DEBUG_NET_WARN_ON_ONCE(1);
 			break;
 		}
 
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 327a5f33659c..1d0d815c8745 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -155,7 +155,7 @@ void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			strscpy_pad(reg, dev ? dev->name : "", IFNAMSIZ);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		*dreg = 0;
 		break;
 	}
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index d14ca157910b..97fb4eea2d66 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -308,7 +308,7 @@ static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		nft_meta_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	nft_inner_save_tun_ctx(pkt, &tun_ctx);
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 9fafe5afc490..ba512e94b402 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -50,7 +50,7 @@ __nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 	if (set->ops == &nft_set_rbtree_type.ops)
 		return nft_rbtree_lookup(net, set, key);
 
-	WARN_ON_ONCE(1);
+	DEBUG_NET_WARN_ON_ONCE(1);
 #endif
 	return set->ops->lookup(net, set, key);
 }
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 2b01128737a3..841efd981e20 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -123,7 +123,7 @@ static void nft_masq_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 5b25851381e5..9b5821c64442 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -116,12 +116,12 @@ nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
 			nft_reg_store8(dest, PACKET_MULTICAST);
 			break;
 		default:
-			WARN_ON_ONCE(1);
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return false;
 		}
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return false;
 	}
 
@@ -460,7 +460,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_meta_get_eval_sdifname(dest, pkt);
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	return;
@@ -506,7 +506,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 	}
 }
 EXPORT_SYMBOL_GPL(nft_meta_set_eval);
@@ -886,7 +886,7 @@ void nft_meta_inner_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, tun_ctx->l4proto);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	return;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 484a5490832e..ef2a80dfc68f 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -196,7 +196,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	offset += priv->offset;
@@ -603,7 +603,7 @@ void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		offset = tun_ctx->inner_thoff;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	offset += priv->offset;
@@ -866,7 +866,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 			goto err;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 58ae802db8f5..a98aa28180fb 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -126,7 +126,7 @@ static void nft_redir_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 196a92c7ea09..e3972e904cf0 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -102,8 +102,10 @@ static u8 icmp_code_v4[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmp_code(u8 code)
 {
-	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+	if (unlikely(code > NFT_REJECT_ICMPX_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return ICMP_NET_UNREACH;
+	}
 
 	return icmp_code_v4[code];
 }
@@ -120,8 +122,10 @@ static u8 icmp_code_v6[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmpv6_code(u8 code)
 {
-	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+	if (unlikely(code > NFT_REJECT_ICMPX_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return ICMPV6_NOROUTE;
+	}
 
 	return icmp_code_v6[code];
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index e23cd4759851..aeb0094eafd8 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -93,7 +93,7 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto err;
 	}
 	return;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index b0e571c8e3f3..eb4e382119d4 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -385,7 +385,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		break;
 	default:
 		iter->err = -EINVAL;
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 50d4a4f04309..706c78853f24 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2199,7 +2199,7 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		break;
 	default:
 		iter->err = -EINVAL;
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b4f0b5fdf1f2..018bbb6df4ce 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -654,8 +654,10 @@ static int nft_array_may_resize(const struct nft_set *set, bool flush)
 	}
 
 realloc_array:
-	if (WARN_ON_ONCE(nelems > new_max_intervals))
+	if (unlikely(nelems > new_max_intervals)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOMEM;
+	}
 
 	if (priv->array_next) {
 		if (max_intervals == new_max_intervals)
@@ -878,7 +880,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 		break;
 	default:
 		iter->err = -EINVAL;
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index a146a45d7531..52d892e04261 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -71,8 +71,10 @@ static noinline int nft_socket_cgroup_subtree_level(void)
 	if (level > 255)
 		return -ERANGE;
 
-	if (WARN_ON_ONCE(level < 0))
+	if (unlikely(level < 0)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	return level;
 }
@@ -97,7 +99,7 @@ static struct sock *nft_socket_do_lookup(const struct nft_pktinfo *pkt)
 		break;
 #endif
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 
@@ -152,7 +154,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		break;
 #endif
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 	}
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 68f7cfbbee06..0a018d4706a9 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -60,7 +60,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 	}
 }
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 65a75d88e5f0..8cec43064319 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -132,7 +132,7 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 	switch (priv->key) {
 	case NFT_XFRM_KEY_UNSPEC:
 	case __NFT_XFRM_KEY_MAX:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	case NFT_XFRM_KEY_DADDR_IP4:
 		*dest = (__force __u32)state->id.daddr.a4;
@@ -206,7 +206,7 @@ static void nft_xfrm_get_eval(const struct nft_expr *expr,
 		nft_xfrm_get_eval_out(priv, regs, pkt);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		regs->verdict.code = NFT_BREAK;
 		break;
 	}
@@ -252,7 +252,7 @@ static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *e
 			(1 << NF_INET_POST_ROUTING);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
 	}
 
-- 
2.47.3

