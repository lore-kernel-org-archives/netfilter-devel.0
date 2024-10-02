Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EDE1D049B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884952; cv=none; b=Mt41bEiTkgPw9N5kqtcaP66N3mP9WUvngeLvxy49iOWgc8Z56ARGX5Kq1ISOpxyoTqt8OzDY46+J7SnwHYyjsrbvIg+ufYk4A45t5kwVUi+sLTH/j8tqsJU+hmWGRriEn/pNUnPNyduT/X9ObVHv66IWvSOtVacTwiA06fJAZ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884952; c=relaxed/simple;
	bh=0w7RzbBLCpQYzb9dZnHXpnH6XSZmMRGiwha77PZ2b3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFXkoXKbDomTykmr6JVo2RYon65DoOTNGyGyJDITG8s31b7vERu6E+kP4JHZ2PxRgdg5ysArhAF6IOKrWviadPF0qVy+0DX4WhrGN8dOHkPj78/VWCws7THLpf/Mc2vLpUJ4MHIMjtcUNoOqN/i1x0nSpCCEDhJWh3duOfA6lkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sw1o4-0003ZM-Tp; Wed, 02 Oct 2024 18:02:28 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: nf_tables: use skb_drop_reason
Date: Wed,  2 Oct 2024 17:55:42 +0200
Message-ID: <20241002155550.15016-5-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241002155550.15016-1-fw@strlen.de>
References: <20241002155550.15016-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

same as previous patch: extend nftables nat and masquerade functions to
indicate more precise drop locations.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h                 |  5 ++++-
 net/bridge/netfilter/nft_reject_bridge.c  |  2 +-
 net/ipv4/netfilter/nft_reject_ipv4.c      |  2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |  5 ++++-
 net/netfilter/nf_nat_proto.c              | 18 +++++++++---------
 net/netfilter/nf_nat_redirect.c           |  4 ++--
 net/netfilter/nf_synproxy_core.c          | 16 ++++++++--------
 net/netfilter/nft_chain_filter.c          |  4 ++--
 net/netfilter/nft_compat.c                |  8 ++++----
 net/netfilter/nft_connlimit.c             |  4 ++--
 net/netfilter/nft_ct.c                    | 14 ++++++++------
 net/netfilter/nft_exthdr.c                |  2 +-
 net/netfilter/nft_fib_inet.c              |  2 +-
 net/netfilter/nft_fwd_netdev.c            |  4 ++--
 net/netfilter/nft_reject_inet.c           |  2 +-
 net/netfilter/nft_reject_netdev.c         |  2 +-
 net/netfilter/nft_synproxy.c              | 10 +++++-----
 17 files changed, 56 insertions(+), 48 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2683b2b77612..5b350de9b4c7 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -25,7 +25,10 @@ static inline int NF_DROP_GETERR(int verdict)
 static __always_inline int
 NF_DROP_REASON(struct sk_buff *skb, enum skb_drop_reason reason, u32 err)
 {
-	BUILD_BUG_ON(err > 0xffff);
+	if (__builtin_constant_p(err))
+		BUILD_BUG_ON(err > 0xffff);
+	else if (WARN_ON_ONCE(err > 0xffff))
+		err = 0;
 
 	kfree_skb_reason(skb, reason);
 
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 1cb5c16e97b7..09da1f4459c9 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -166,7 +166,7 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 		break;
 	}
 out:
-	regs->verdict.code = NF_DROP;
+	regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static int nft_reject_bridge_validate(const struct nft_ctx *ctx,
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 6cb213bb7256..76d1f89b594a 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -34,7 +34,7 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	regs->verdict.code = NF_DROP;
+	regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static struct nft_expr_type nft_reject_ipv4_type;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index be7817fbc024..41f2a7906a5a 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -70,7 +70,10 @@ static unsigned int ipv6_defrag(void *priv,
 	if (err == -EINPROGRESS)
 		return NF_STOLEN;
 
-	return err == 0 ? NF_ACCEPT : NF_DROP;
+	if (err == 0)
+		return NF_ACCEPT;
+
+	return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 }
 
 static const struct nf_hook_ops ipv6_defrag_ops[] = {
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index dc450cc81222..7458c8b59ed2 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -439,7 +439,7 @@ unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
 		break;
 	}
 
-	return NF_DROP;
+	return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static void nf_nat_ipv4_csum_update(struct sk_buff *skb,
@@ -636,7 +636,7 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 		if (ip_hdr(skb)->protocol == IPPROTO_ICMP) {
 			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
 							   state->hook))
-				return NF_DROP;
+				return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 			else
 				return NF_ACCEPT;
 		}
@@ -781,7 +781,7 @@ nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 		     ct->tuplehash[!dir].tuple.dst.u.all)) {
 			err = nf_xfrm_me_harder(state->net, skb, AF_INET);
 			if (err < 0)
-				ret = NF_DROP_ERR(err);
+				ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 		}
 	}
 #endif
@@ -809,7 +809,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 		    ct->tuplehash[!dir].tuple.src.u3.ip) {
 			err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);
 			if (err < 0)
-				ret = NF_DROP_ERR(err);
+				ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 		}
 #ifdef CONFIG_XFRM
 		else if (!(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
@@ -818,7 +818,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 			 ct->tuplehash[!dir].tuple.src.u.all) {
 			err = nf_xfrm_me_harder(state->net, skb, AF_INET);
 			if (err < 0)
-				ret = NF_DROP_ERR(err);
+				ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 		}
 #endif
 	}
@@ -965,7 +965,7 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 			if (!nf_nat_icmpv6_reply_translation(skb, ct, ctinfo,
 							     state->hook,
 							     hdrlen))
-				return NF_DROP;
+				return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 			else
 				return NF_ACCEPT;
 		}
@@ -1040,7 +1040,7 @@ nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
 		     ct->tuplehash[!dir].tuple.dst.u.all)) {
 			err = nf_xfrm_me_harder(state->net, skb, AF_INET6);
 			if (err < 0)
-				ret = NF_DROP_ERR(err);
+				ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 		}
 	}
 #endif
@@ -1069,7 +1069,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 				      &ct->tuplehash[!dir].tuple.src.u3)) {
 			err = nf_ip6_route_me_harder(state->net, state->sk, skb);
 			if (err < 0)
-				ret = NF_DROP_ERR(err);
+				ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 		}
 #ifdef CONFIG_XFRM
 		else if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
@@ -1078,7 +1078,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 			 ct->tuplehash[!dir].tuple.src.u.all) {
 			err = nf_xfrm_me_harder(state->net, skb, AF_INET6);
 			if (err < 0)
-				ret = NF_DROP_ERR(err);
+				ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 		}
 #endif
 	}
diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 5b37487d9d11..5adb648538f0 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -71,7 +71,7 @@ nf_nat_redirect_ipv4(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		}
 
 		if (!newdst.ip)
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 	}
 
 	return nf_nat_redirect(skb, range, &newdst);
@@ -130,7 +130,7 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		}
 
 		if (!addr)
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 	}
 
 	return nf_nat_redirect(skb, range, &newdst);
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 5b140c12b7df..08a650fc6ee7 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -664,7 +664,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 	thoff = ip_hdrlen(skb);
 	th = skb_header_pointer(skb, thoff, sizeof(_th), &_th);
 	if (!th)
-		return NF_DROP;
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 	state = &ct->proto.tcp;
 	switch (state->state) {
@@ -689,7 +689,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		fallthrough;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 		if (!th->syn && th->ack &&
 		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
@@ -703,7 +703,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 				consume_skb(skb);
 				return NF_STOLEN;
 			} else {
-				return NF_DROP;
+				return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 			}
 		}
 
@@ -718,7 +718,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 			break;
 
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 		if (opts.options & NF_SYNPROXY_OPT_TIMESTAMP) {
 			synproxy->tsoff = opts.tsval - synproxy->its;
@@ -1087,7 +1087,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 
 	th = skb_header_pointer(skb, thoff, sizeof(_th), &_th);
 	if (!th)
-		return NF_DROP;
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 	state = &ct->proto.tcp;
 	switch (state->state) {
@@ -1112,7 +1112,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		fallthrough;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 		if (!th->syn && th->ack &&
 		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
@@ -1126,7 +1126,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 				consume_skb(skb);
 				return NF_STOLEN;
 			} else {
-				return NF_DROP;
+				return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 			}
 		}
 
@@ -1141,7 +1141,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 			break;
 
 		if (!synproxy_parse_options(skb, thoff, th, &opts))
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 		if (opts.options & NF_SYNPROXY_OPT_TIMESTAMP) {
 			synproxy->tsoff = opts.tsval - synproxy->its;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 7010541fcca6..b0a90b49ada9 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -175,7 +175,7 @@ static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
 		nft_set_pktinfo(&pkt, skb, &ingress_state);
 
 		if (nft_set_pktinfo_ipv4_ingress(&pkt) < 0)
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		break;
 	case htons(ETH_P_IPV6):
 		ingress_state.pf = NFPROTO_IPV6;
@@ -183,7 +183,7 @@ static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
 		nft_set_pktinfo(&pkt, skb, &ingress_state);
 
 		if (nft_set_pktinfo_ipv6_ingress(&pkt) < 0)
-			return NF_DROP;
+			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		break;
 	default:
 		return NF_ACCEPT;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 52cdfee17f73..0ee10c7f7a4f 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -85,7 +85,7 @@ static void nft_target_eval_xt(const struct nft_expr *expr,
 	ret = target->target(skb, &xt);
 
 	if (xt.hotdrop)
-		ret = NF_DROP;
+		ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 	switch (ret) {
 	case XT_CONTINUE:
@@ -112,14 +112,14 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 	ret = target->target(skb, &xt);
 
 	if (xt.hotdrop)
-		ret = NF_DROP;
+		ret = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 
 	switch (ret) {
 	case EBT_ACCEPT:
 		regs->verdict.code = NF_ACCEPT;
 		break;
 	case EBT_DROP:
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		break;
 	case EBT_CONTINUE:
 		regs->verdict.code = NFT_CONTINUE;
@@ -403,7 +403,7 @@ static void __nft_match_eval(const struct nft_expr *expr,
 	ret = match->match(skb, &xt);
 
 	if (xt.hotdrop) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		return;
 	}
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 92b984fa8175..3cfa9295001a 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -39,12 +39,12 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		zone = nf_ct_zone(ct);
 	} else if (!nf_ct_get_tuplepr(pkt->skb, skb_network_offset(pkt->skb),
 				      nft_pf(pkt), nft_net(pkt), &tuple)) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		return;
 	}
 
 	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		return;
 	}
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 67a41cd2baaf..d705077ccaaa 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -259,7 +259,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 		 */
 		ct = nf_ct_tmpl_alloc(nft_net(pkt), &zone, GFP_ATOMIC);
 		if (!ct) {
-			regs->verdict.code = NF_DROP;
+			regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NOMEM, ENOMEM);
 			return;
 		}
 		__set_bit(IPS_CONFIRMED_BIT, &ct->status);
@@ -917,7 +917,7 @@ static void nft_ct_timeout_obj_eval(struct nft_object *obj,
 	if (!timeout) {
 		timeout = nf_ct_timeout_ext_add(ct, priv->timeout, GFP_ATOMIC);
 		if (!timeout) {
-			regs->verdict.code = NF_DROP;
+			regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NOMEM, ENOMEM);
 			return;
 		}
 	}
@@ -1316,6 +1316,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	enum ip_conntrack_dir dir;
 	u16 l3num = priv->l3num;
 	struct nf_conn *ct;
+	int err;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
 	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
@@ -1328,7 +1329,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	if (!help)
 		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 	if (!help) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NOMEM, ENOMEM);
 		return;
 	}
 
@@ -1341,7 +1342,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 
 	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NOMEM, ENOMEM);
 		return;
 	}
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
@@ -1350,8 +1351,9 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          priv->l4proto, NULL, &priv->dport);
 	exp->timeout.expires = jiffies + priv->timeout * HZ;
 
-	if (nf_ct_expect_related(exp, 0) != 0)
-		regs->verdict.code = NF_DROP;
+	err = nf_ct_expect_related(exp, 0);
+	if (err != 0)
+		regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, -err);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 6bfd33516241..9e7fedcb2c16 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -365,7 +365,7 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
 	return;
 drop:
 	/* can't remove, no choice but to drop */
-	regs->verdict.code = NF_DROP;
+	regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index 666a3741d20b..a15f40729201 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -38,7 +38,7 @@ static void nft_fib_inet_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	regs->verdict.code = NF_DROP;
+	regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static struct nft_expr_type nft_fib_inet_type;
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 152a9fb4d23a..ecf48b5e8de1 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -112,7 +112,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			goto out;
 		}
 		if (skb_try_make_writable(skb, sizeof(*iph))) {
-			verdict = NF_DROP;
+			verdict = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 			goto out;
 		}
 		iph = ip_hdr(skb);
@@ -128,7 +128,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			goto out;
 		}
 		if (skb_try_make_writable(skb, sizeof(*ip6h))) {
-			verdict = NF_DROP;
+			verdict = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 			goto out;
 		}
 		ip6h = ipv6_hdr(skb);
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 49020e67304a..6ba969e94afa 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -57,7 +57,7 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	regs->verdict.code = NF_DROP;
+	regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static int nft_reject_inet_validate(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
index 2558ce1505d9..ba39bf9274b1 100644
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -141,7 +141,7 @@ static void nft_reject_netdev_eval(const struct nft_expr *expr,
 		break;
 	}
 out:
-	regs->verdict.code = NF_DROP;
+	regs->verdict.code = NF_DROP_REASON(pkt->skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static int nft_reject_netdev_validate(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 5d3e51825985..fe96f6fc4d3c 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -66,7 +66,7 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 			consume_skb(skb);
 			regs->verdict.code = NF_STOLEN;
 		} else {
-			regs->verdict.code = NF_DROP;
+			regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		}
 	}
 }
@@ -97,7 +97,7 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 			consume_skb(skb);
 			regs->verdict.code = NF_STOLEN;
 		} else {
-			regs->verdict.code = NF_DROP;
+			regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		}
 	}
 }
@@ -119,7 +119,7 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 	}
 
 	if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		return;
 	}
 
@@ -127,12 +127,12 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 				 sizeof(struct tcphdr),
 				 &_tcph);
 	if (!tcp) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		return;
 	}
 
 	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
-		regs->verdict.code = NF_DROP;
+		regs->verdict.code = NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 		return;
 	}
 
-- 
2.45.2

