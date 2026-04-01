Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8143F8E1F;
	Wed,  1 Apr 2026 10:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039828; cv=none; b=DxZ3PHAZEw6X0b4BgWkKKyohCJ8LcjZim4mYrRjeAlcVJ1uDpeANXUbvEvX5zjy+kdReHgvTPVNmlAZEAcYs3mnl4Q+LJtfVa3gqLDpg5jrPV4Z35NFGw3+npT5xaMfhQDbY+xhoZ/LFiceHAgtAWZB5/XXqCu7McBcMtxbacGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039828; c=relaxed/simple;
	bh=CzPSJapt1DbwA+j0vgoQk9f9m0ONreQaBAqQO7KtdMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwxZkVToIEFkSR0APq9uhJDnh3+0JwNskAKawtQ2UAIW+XcXOBUw6wEfVgpn2xoGmQLvVEIQz9NLRRNwJjTwfDVSWNgrEwSbhdFDvxvkOED0bNzIQnBO3dUuUPasLhAqD+4+AR/277WE3aiSvSsWRt29IhGiycBLONkmAm+VBGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GLavjX85; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GLavjX85"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5DBE860275;
	Wed,  1 Apr 2026 12:37:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039823;
	bh=GJuux1UkH0MYTO5Mrxr7dQYCFODMTuquZ2nsGDGYy2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLavjX857fZp3WE4GM4L0/Gh9qPWBsecxbQMILd0peYwnMmTd79xMGxx5VUZVLsyC
	 rnC0sbnKZAWFGRro9pnonrTPy3vvOOhVZU/HmQHMr4UUAa4CKyZFl4Tzx7NhvPzpK2
	 jTvdDe3H9/yei55IweXo7ltpPcqJZxQ4vmxHhA3ajZ1QFpyphG5jISLrTkSLrpv5+L
	 c1WJZQ3+DFYrrKFyN0crSnCOZxIh6yBCmcsxyBO4dxI4JRpTT55rgxCgtoroFeXINs
	 sv3bui4hnA/vVZim106Dl7czZ0FTTMdgU0gMompS2C3vIJr9S9dFreerAWS5GD0uQf
	 Z8gNnQUeR5pGA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 09/10] netfilter: x_tables: restrict xt_check_match/xt_check_target extensions for NFPROTO_ARP
Date: Wed,  1 Apr 2026 12:36:45 +0200
Message-ID: <20260401103646.1015423-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Weiming Shi says:

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

Fix it by restricting arptables to NFPROTO_ARP extensions only.
Note that arptables-legacy only supports:

- arpt_CLASSIFY
- arpt_mangle
- arpt_MARK

that provide explicit NFPROTO_ARP match/target declarations.

Fixes: 9291747f118d ("netfilter: xtables: add device group match")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e594b3b7ad82..b39017c80548 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -501,6 +501,17 @@ int xt_check_match(struct xt_mtchk_param *par,
 				    par->match->table, par->table);
 		return -EINVAL;
 	}
+
+	/* NFPROTO_UNSPEC implies NF_INET_* hooks which do not overlap with
+	 * NF_ARP_IN,OUT,FORWARD, allow explicit extensions with NFPROTO_ARP
+	 * support.
+	 */
+	if (par->family == NFPROTO_ARP &&
+	    par->match->family != NFPROTO_ARP) {
+		pr_info_ratelimited("%s_tables: %s match: not valid for this family\n",
+				    xt_prefix[par->family], par->match->name);
+		return -EINVAL;
+	}
 	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
 		char used[64], allow[64];
 
@@ -1016,6 +1027,18 @@ int xt_check_target(struct xt_tgchk_param *par,
 				    par->target->table, par->table);
 		return -EINVAL;
 	}
+
+	/* NFPROTO_UNSPEC implies NF_INET_* hooks which do not overlap with
+	 * NF_ARP_IN,OUT,FORWARD, allow explicit extensions with NFPROTO_ARP
+	 * support.
+	 */
+	if (par->family == NFPROTO_ARP &&
+	    par->target->family != NFPROTO_ARP) {
+		pr_info_ratelimited("%s_tables: %s target: not valid for this family\n",
+				    xt_prefix[par->family], par->target->name);
+		return -EINVAL;
+	}
+
 	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
 		char used[64], allow[64];
 
-- 
2.47.3

