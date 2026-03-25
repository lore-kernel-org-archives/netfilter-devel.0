Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7804C3D8126;
	Wed, 25 Mar 2026 13:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444317; cv=none; b=aKzbUgagrrQtppYHgjkl3J25y9+RFQ+ec4VxKJEWjvSXN6WvnfWL64Ugo+el96XwgeUcAY0gru1wtrF1VbFIezxb1CF4gvln0op6Ev95EmEnVEkYbZMzhlFJ5but+VWu0ngYIPVR1gLAGZBMS2F9bjAFpUDLWDS4/Zlm9LRWNIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444317; c=relaxed/simple;
	bh=5QITqE8OG+JZWtv3BHu5U8D15SKXdtcnQrydzQ0OL54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0AREpfqpETM4+1kbL+Vbkh6akSa74RoQ+C7pnk0rwq7imZAGCpB9FxIT2Jm6kxbQ0sTDJGaJUgT7EhJGJtwRR+NYET8lc6ys+m8fPwzfYVeCU5r8k8pVnVyX7HYgB3kPvpZz0jyFVjfvjJ+dICZMv3VImwZV3tFdIvGNLIIyMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 203AC6080C; Wed, 25 Mar 2026 14:11:55 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 05/14] netfilter: x_tables: reject unsupported families in xt_check_match/xt_check_target
Date: Wed, 25 Mar 2026 14:10:59 +0100
Message-ID: <20260325131108.23045-6-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325131108.23045-1-fw@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
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
2.52.0

