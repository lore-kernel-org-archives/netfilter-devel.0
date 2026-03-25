Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99CB37C91E;
	Wed, 25 Mar 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477597; cv=none; b=UJ1suHzqZT1aPZHV/dtJg/PzJ6iVhRWUdgDobF5wD0NPRLwF7IMTJPIl3QCEtPF9Jrcuc57st+TUi5jpLx9aRIrrIQj1R4JZjQ1aZa1jBcmtta7JKmfGuH8MGWhsOkQojJGMAMgsfwSG5GOEM/RaczhvY4zfiFk/0/N9JyFik98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477597; c=relaxed/simple;
	bh=kg1OayMZV+GDtLjuLidMVS9iNPpBQZ69aqy5dc4Q6WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHRJweIVJKLwnyJ6cY5sGBX/hB6YphHOi+Ps1bbK//Y9hrmN2YYzF9bgHRoqFXSTqFGtXxQqpdz0nD9Ujet//w9SUS4yrpWlJix+wwD4aqjv3zGt7H7iGvnqroLsIEUizKRTNQWB92VTwebbKB6R1wsl4YC3PFZfJd2TPmOKukA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WQv4vnTU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WQv4vnTU"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DDD5360181;
	Wed, 25 Mar 2026 23:26:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477590;
	bh=cVccOpvjmCnsd1Ql2RpElCCheT0DBWh3gcduTvNEq8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQv4vnTUbJuvQUOtZlIufGw3Q/qPfyAVTOdsVPSA64F/RxrccvazDQ/pHvHDXuwaz
	 xcxmnONjf7xJnvBi6X2F6/dOjhJuBbnhMTTrKr+hTbyLJ4pQ/OMeaHyec6JSzq2K2c
	 tu4426j2NOpZ7Pz34+jTCDObb7scKG3T03sIGfD60xuIZ2z2wC94mIs+ZBrhvZ2+Xh
	 528G7m2rwcb+qfDOh2xEgf/GVK7wzDR/MtqgIMcq9YEtW5jT5l4gHnQ1ZZfpz18u/P
	 acppAmKkBpSNw0sOvtrQpzC6jlIGMJ0aybV4pC/uvbmc11M2Uw6gPOlfQRx1B4jlxW
	 HKRiJu3Ez7jUg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/14] netfilter: x_tables: reject unsupported families in xt_check_match/xt_check_target
Date: Wed, 25 Mar 2026 23:26:06 +0100
Message-ID: <20260325222615.637793-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

xt_match and xt_target structs registered with NFPROTO_UNSPEC can be
loaded by any protocol family through nft_compat. When such a
match/target sets .hooks to restrict which hooks it may run on, the
bitmask uses NF_INET_* constants. This is only correct for families
whose hook layout matches NF_INET_*: IPv4, IPv6, INET, and bridge
all share the same five hooks (PRE_ROUTING ... POST_ROUTING).

ARP only has three hooks (IN=0, OUT=1, FORWARD=2) with different
semantics. Because NF_ARP_OUT == 1 == NF_INET_LOCAL_IN, the .hooks
validation silently passes for the wrong reasons, allowing matches to
run on ARP chains where the hook assumptions (e.g. state->in being
set on input hooks) do not hold. This leads to NULL pointer
dereferences; xt_devgroup is one concrete example:

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000044: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000220-0x0000000000000227]
 RIP: 0010:devgroup_mt+0xff/0x350
 Call Trace:
  <TASK>
  nft_match_eval (net/netfilter/nft_compat.c:407)
  nft_do_chain (net/netfilter/nf_tables_core.c:285)
  nft_do_chain_arp (net/netfilter/nft_chain_filter.c:61)
  nf_hook_slow (net/netfilter/core.c:623)
  arp_xmit (net/ipv4/arp.c:666)
  </TASK>
 Kernel panic - not syncing: Fatal exception in interrupt

Add a helper xt_family_has_inet_hooks() and call it from both
xt_check_match() and xt_check_target(): when a UNSPEC match/target
declares .hooks, reject families whose hook numbering differs from
the NF_INET_* scheme.

Also add .hooks to xt_devgroup so the framework-level check covers it;
previously it relied on manual hook validation in checkentry using
NF_INET_* constants, which suffers from the same collision.

Fixes: 9291747f118d ("netfilter: xtables: add device group match")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c    | 36 ++++++++++++++++++++++++++++++++++++
 net/netfilter/xt_devgroup.c |  5 +++++
 2 files changed, 41 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e594b3b7ad82..a600592d0bff 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -477,6 +477,28 @@ int xt_check_proc_name(const char *name, unsigned int size)
 }
 EXPORT_SYMBOL(xt_check_proc_name);
 
+/*
+ * Families whose hook numbering follows the NF_INET_* scheme.
+ * ARP hooks (IN=0, OUT=1, FORWARD=2) use different semantics and
+ * collide numerically with NF_INET_* values, so UNSPEC matches/targets
+ * that declare .hooks must not run on ARP (or any other family whose
+ * hooks do not follow the INET layout).
+ */
+static bool xt_family_has_inet_hooks(u_int8_t family)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_BRIDGE:
+		return true;
+	case NFPROTO_INET:
+		/* nftables only */
+		return false;
+	default:
+		return false;
+	}
+}
+
 int xt_check_match(struct xt_mtchk_param *par,
 		   unsigned int size, u16 proto, bool inv_proto)
 {
@@ -501,6 +523,13 @@ int xt_check_match(struct xt_mtchk_param *par,
 				    par->match->table, par->table);
 		return -EINVAL;
 	}
+	if (par->match->family == NFPROTO_UNSPEC &&
+	    par->match->hooks &&
+	    !xt_family_has_inet_hooks(par->family)) {
+		pr_info_ratelimited("%s_tables: %s match: not valid for this family\n",
+				    xt_prefix[par->family], par->match->name);
+		return -EINVAL;
+	}
 	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
 		char used[64], allow[64];
 
@@ -1016,6 +1045,13 @@ int xt_check_target(struct xt_tgchk_param *par,
 				    par->target->table, par->table);
 		return -EINVAL;
 	}
+	if (par->target->family == NFPROTO_UNSPEC &&
+	    par->target->hooks &&
+	    !xt_family_has_inet_hooks(par->family)) {
+		pr_info_ratelimited("%s_tables: %s target: not valid for this family\n",
+				    xt_prefix[par->family], par->target->name);
+		return -EINVAL;
+	}
 	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
 		char used[64], allow[64];
 
diff --git a/net/netfilter/xt_devgroup.c b/net/netfilter/xt_devgroup.c
index 9520dd00070b..8246bcfd2094 100644
--- a/net/netfilter/xt_devgroup.c
+++ b/net/netfilter/xt_devgroup.c
@@ -62,6 +62,11 @@ static struct xt_match devgroup_mt_reg __read_mostly = {
 	.checkentry	= devgroup_mt_checkentry,
 	.matchsize	= sizeof(struct xt_devgroup_info),
 	.family		= NFPROTO_UNSPEC,
+	.hooks		= (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_POST_ROUTING),
 	.me		= THIS_MODULE
 };
 
-- 
2.47.3

