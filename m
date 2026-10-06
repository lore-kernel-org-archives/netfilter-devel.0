Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDED14ACC88
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 23:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791328570; cv=none; b=tS/PxQ5riPhkFUVT16DXs0foXhwvNWxHgEZHIbogZXCgNPTJi95Nhmc9k/kcWbFcw9NgDd50/WpvehlSZkS+FfRIWgzgtde3SqMTdj4cdOPwYDqzyuG0ZqBV4JFhcmaRwXsMTRHrE5GWhGftKFWPZR4FteawH/eJafWtqtQDdqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791328570; c=relaxed/simple;
	bh=ECtkpvuVwfVD49XdTwnfRvFzzi038lI0RYT99Zllbt4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I3YOEYZdTwdxcGzmDd496xPDZEnwPiLH6uFk2fN6nQBBKxzQ97Bax+rB/m21mOVy9dSJeA6KdCGQU0qNYKYD+jghMVUErc6OpeLLwufklF7g7vxJ16lkOI1sK3bXtSQa3FL5g9HZCaNVASoA+s8fBGConuMAixT0Ob9sCqYvExs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3CC596059E; Wed, 07 Oct 2026 01:16:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nft_compat: restrict raw table targets/matches
Date: Wed,  7 Oct 2026 01:15:49 +0200
Message-ID: <20261006231549.5901-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xt targets and matches declaring .table = "raw" (CT, NOTRACK) rely on
only ever running in the legacy raw table's prerouting/output chains,
ahead of conntrack. nft_compat_chain_validate_dependency() already
enforces this kind of correspondence for "nat" by requiring the chain
type to actually be NAT, but did nothing for "raw": a rule wrapping
the CT target could be loaded into any hook and any priority via
nft_compat, including after the real conntrack hook has already run.

The CT target attaches a conntrack template to the skb when none is
set yet.

Require that a "raw" table dependency actually matches what xtables
enforces via the implict/builtin table dependency.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_compat.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 63864b928259..88ddaf47f587 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_tables_compat.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
@@ -45,6 +46,20 @@ static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 			type = NFT_CHAIN_T_NAT;
 		if (basechain->type->type != type)
 			return -EINVAL;
+	} else if (strcmp(tablename, "raw") == 0) {
+		/* iptables-nft emulates the legacy raw table, which only
+		 * ever has prerouting/output chains at this exact priority.
+		 */
+		if (ctx->family != NFPROTO_IPV4 &&
+		    ctx->family != NFPROTO_IPV6)
+			return -EINVAL;
+
+		if (basechain->ops.hooknum != NF_INET_PRE_ROUTING &&
+		    basechain->ops.hooknum != NF_INET_LOCAL_OUT)
+			return -EINVAL;
+
+		if (basechain->ops.priority != NF_IP_PRI_RAW)
+			return -EINVAL;
 	}
 
 	return 0;
-- 
2.55.0

