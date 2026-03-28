Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712DD19E819
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Mar 2026 19:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774726961; cv=none; b=QViiu2vNyzcr8OFmoO1ajag00HvLSuwjcAInVplwbkRDcrOnBspojoLGgyq0OivWAcZ52secJ2OA6IYXaQhmZcwbwr2qUYdA1U8c/W6UOpZENSU0F61kDOkEFdPRnX/Y2LFpzHt62+poxxGv5X5Cl88PRyVaJ4UWt6ZkK7IoPoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774726961; c=relaxed/simple;
	bh=1E46YMFg5WdwyBtnUcD64Jxn+9o/a2Btq3yxRvC5RCA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rjVOS0FhrOilhZW+Okz14jGvtztUQUjxc40RSLYganCtEwNziLnY6wz8RCy5LudwSZ752umSyDvP8JLY/EhpGqijHvtwL7uwIvY4OFoR2AyOBZnt+L/WCGu+AZ0DyTNWRbg68UmURBS/gqDVwKwgq6DufN2U3hWhLPuYGpZ9VuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2A89760508; Sat, 28 Mar 2026 20:42:32 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_compat: tighten the nft_compat interface
Date: Sat, 28 Mar 2026 20:42:17 +0100
Message-ID: <20260328194222.4752-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_compat is used by xtables-over-nftables:
 - arptables-nft
 - ebtables-nft
 - iptables-nft
 - ip6tables-nft

x_tables doesn't support NFPROTO_NETDEV and NFPROTO_INET.
Reject unsupported families. As-is, this allows use of xtables
NFPROTO_UNSPEC extensions that are crashing the kernel when used
with e.g. NFPROTO_NETDEV.

NFPROTO_INET *might* be safe (since its a superset of
NFPROTO_IPV4/IPV6), but it is not used by the existing compat
layer.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This is in addition to
 "netfilter: x_tables: reject unsupported families in xt_check_match/xt_check_target".

 net/netfilter/nft_compat.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 27cc983a7cdf..bafc0bf450e6 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -786,6 +786,20 @@ static bool nft_match_reduce(struct nft_regs_track *track,
 	return strcmp(match->name, "comment") == 0;
 }
 
+static bool is_valid_compat_family(u32 family)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_ARP:
+	case NFPROTO_BRIDGE:
+	case NFPROTO_IPV6:
+		return true;
+	}
+
+	/* others are nftables only */
+	return false;
+}
+
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -806,6 +820,9 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	rev = ntohl(nla_get_be32(tb[NFTA_MATCH_REV]));
 	family = ctx->family;
 
+	if (!is_valid_compat_family(family))
+		return ERR_PTR(-EAFNOSUPPORT);
+
 	match = xt_request_find_match(family, mt_name, rev);
 	if (IS_ERR(match))
 		return ERR_PTR(-ENOENT);
@@ -886,6 +903,9 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	rev = ntohl(nla_get_be32(tb[NFTA_TARGET_REV]));
 	family = ctx->family;
 
+	if (!is_valid_compat_family(family))
+		return ERR_PTR(-EAFNOSUPPORT);
+
 	if (strcmp(tg_name, XT_ERROR_TARGET) == 0 ||
 	    strcmp(tg_name, XT_STANDARD_TARGET) == 0 ||
 	    strcmp(tg_name, "standard") == 0)
-- 
2.53.0

