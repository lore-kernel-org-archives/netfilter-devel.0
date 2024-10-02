Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1831D0DCE
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884948; cv=none; b=cCLKw/AasH7dfBLf4ScIJdMTkn8SqSMNxD4aOrdhOKA814ef+bdcw5HFasby0IFkkIJF59IHfHZl2QyRZBb9VSU0mOXYH+hYqAOCDbYzD24N8pN0jGUUgQ9oYqT4xglc9KFdYXKM1SI1BjYDqdwucqB4p/NgXIRb26vHZnnO7TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884948; c=relaxed/simple;
	bh=H7NEXnTqCTn9n36OPHXQbv/RUhKf8Cpo6kiWx2mIgQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBQFEunMFIQYFjsEKXkhEg9VrIEBEB8/FNcZ6MBWLrqEB8njtozcQVl8XmeBkjjLnGTixSKW48jfL8X6JECwo+1kq0Bx8kpFcT3V3oOyl9KVmz0Nho9wg+SmNpFBmxu9qnSPUvECJgfv9v4UGCAE90Q58Pvc5w7jZCQOf45n/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sw1o0-0003ZC-Rf; Wed, 02 Oct 2024 18:02:24 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] netfilter: nf_nat: use skb_drop_reason
Date: Wed,  2 Oct 2024 17:55:41 +0200
Message-ID: <20241002155550.15016-4-fw@strlen.de>
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
 net/netfilter/nf_nat_masquerade.c | 23 ++++++++++++++++-------
 net/netfilter/nft_nat.c           |  8 +++++++-
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 1a506b0c6511..06f5968dbc15 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -35,6 +35,7 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	struct nf_nat_range2 newrange;
 	const struct rtable *rt;
 	__be32 newsrc, nh;
+	int ret;
 
 	WARN_ON(hooknum != NF_INET_POST_ROUTING);
 
@@ -52,10 +53,8 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	rt = skb_rtable(skb);
 	nh = rt_nexthop(rt, ip_hdr(skb)->daddr);
 	newsrc = inet_select_addr(out, nh, RT_SCOPE_UNIVERSE);
-	if (!newsrc) {
-		pr_info("%s ate my IP address\n", out->name);
-		return NF_DROP;
-	}
+	if (!newsrc)
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EADDRNOTAVAIL);
 
 	nat = nf_ct_nat_ext_add(ct);
 	if (nat)
@@ -71,7 +70,12 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	newrange.max_proto   = range->max_proto;
 
 	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+	ret = nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+	if (ret == NF_DROP)
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP,
+				      EPERM);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
 
@@ -246,6 +250,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	struct in6_addr src;
 	struct nf_conn *ct;
 	struct nf_nat_range2 newrange;
+	int ret;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
@@ -253,7 +258,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 
 	if (nat_ipv6_dev_get_saddr(nf_ct_net(ct), out,
 				   &ipv6_hdr(skb)->daddr, 0, &src) < 0)
-		return NF_DROP;
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EADDRNOTAVAIL);
 
 	nat = nf_ct_nat_ext_add(ct);
 	if (nat)
@@ -265,7 +270,11 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	newrange.min_proto	= range->min_proto;
 	newrange.max_proto	= range->max_proto;
 
-	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+	ret = nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+	if (ret == NF_DROP)
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 6e21f72c5b57..bd2bda5c2b13 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -108,6 +108,7 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
 	struct nf_nat_range2 range;
+	int verdict;
 
 	memset(&range, 0, sizeof(range));
 
@@ -122,7 +123,12 @@ static void nft_nat_eval(const struct nft_expr *expr,
 
 	range.flags = priv->flags;
 
-	regs->verdict.code = nf_nat_setup_info(ct, &range, priv->type);
+	verdict = nf_nat_setup_info(ct, &range, priv->type);
+	if (verdict == NF_DROP)
+		verdict = NF_DROP_REASON(pkt->skb,
+					 SKB_DROP_REASON_NETFILTER_DROP,
+					 EPERM);
+	regs->verdict.code = verdict;
 }
 
 static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
-- 
2.45.2

