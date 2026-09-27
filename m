Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BCB3EBF0F;
	Sun, 27 Sep 2026 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546920; cv=none; b=eHcjaiNrH65iZDZHA21pF2O6JzBck0Q8AqSo0iOOEbOnwPgrGVcXamFoDS6ti/nJEBjjLGX+TKnaEFyiXy0bxttO50eA3e/SwEsa6vdcSSxdjL7hjt4jCLivY1VG9yOCQZDz4I5xQhqts5YnERuCRmHgfWPpskUHXhh704nun9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546920; c=relaxed/simple;
	bh=mOqnsWOyy4GVp/T9+O1BWn9qFMORh6me5DUr5ah0U44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgQkOdMvNvIoPXgEyhjv5FxX4uZJJPvos0Uwk0RwproRBSXwxdWoJ8Ger/IQi/ZJg0LYmvuxmxOcrpQ6LPJAY90QIj+zc2aUSqIw4Wn2KuwgwH5oOFhsH5z03R3rWJgKAye3Pvqa37ltQJYY+0KbaFLl6t5bRSXP7CzovmTYrr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SfCsG4hu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SfCsG4hu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546913;
	bh=F4BItNNQi20kAfu5uNzupYA34Wz6WKneYKeosBW1VgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfCsG4huqoz4QhxX+Ic85Pmu/48Q17EZXCy0YNfwKzUEp8dep0sBPv0XAlo+vIRNt
	 DfHWBfIy6XkbDSYfx96y+gYKOYAnGGoDPYVd/LYZDgVd3HAl6kcdG3tmE2e1e3OSAw
	 JMWuWkIXceEp9noBZJZp/tNs2je6f2/MzNMU49f/xTT5xOzAx3Iro9XuffrI1722/6
	 S63tiz0qLHUsp1VYP0cdbw6FWEpDL9CNFBMwG3W67c4oxdGRQjIfvz4I9OORvddI2S
	 qSRJWHDS9RnqvsOc53eUvhI3IbisHny+aD6Uhd/X8T0v/L6Bv8+yjLcbK4uVJLzFYq
	 il3FSzCARp+hg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 929F1603DD;
	Mon, 28 Sep 2026 00:08:32 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 09/11] netfilter: bpf: reject invalid NAT manipulation types
Date: Mon, 28 Sep 2026 00:08:14 +0200
Message-ID: <20260927220816.268206-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

As bpf_ct_set_nat_info() is not validating the NAT manipulation type a
wrong value can be passed directly to nf_nat_setup_info(). This triggers
the WARN_ON() at nf_nat_setup_info() and if panic_on_warn isn't set,
then IPS_SRC_NAT_DONE is set without adding nat_bysource and conntrack
cleanup tries to unlink an uninitialized hlist node.

Fix this by checking that NAT manipulation type is correct before
calling nf_nat_setup_info(). In addition, if the WARN_ON is hit, return
NF_DROP instead of continuing with the processing to avoid similar
situations in the future.

Reported-by: VEGA <vega@nebusec.ai>
Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_bpf.c  | 3 +++
 net/netfilter/nf_nat_core.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
index f9dd85ccea01..7572b58c448b 100644
--- a/net/netfilter/nf_nat_bpf.c
+++ b/net/netfilter/nf_nat_bpf.c
@@ -39,6 +39,9 @@ __bpf_kfunc int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
 	if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
 		return -EINVAL;
 
+	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
+		return -EINVAL;
+
 	memset(&range, 0, sizeof(struct nf_nat_range2));
 	range.flags = NF_NAT_RANGE_MAP_IPS;
 	range.min_addr = *addr;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index a4858c2b2d65..cc8e1e81006d 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -767,8 +767,9 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		return NF_ACCEPT;
 
-	WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
-		maniptype != NF_NAT_MANIP_DST);
+	if (WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
+		    maniptype != NF_NAT_MANIP_DST))
+		return NF_DROP;
 
 	if (WARN_ON(nf_nat_initialized(ct, maniptype)))
 		return NF_DROP;
-- 
2.47.3

