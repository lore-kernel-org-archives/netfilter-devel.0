From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2] netfilter: meta: add PRANDOM support
Date: Tue, 16 Feb 2016 17:24:08 +0100
Message-ID: <1455639848-2454-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>,
	Daniel Borkmann <daniel@iogearbox.net>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40094 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbcBPQXu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 11:23:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Can be used to randomly match packets e.g. for statistic traffic sampling.

See commit 3ad0040573b0c00f8848
("bpf: split state from prandom_u32() and consolidate {c, e}BPF prngs")
for more info why this doesn't use prandom_u32 directly.

Unlike bpf nft_meta can be built as a module, so add an EXPORT_SYMBOL
for prandom_seed_full_state too.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change in v2: use prandom_init_once helper instead of
 open-coding w. static variable

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 lib/random32.c                           |  1 +
 net/netfilter/nft_meta.c                 | 11 +++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index be41ffc..b19be0a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -681,6 +681,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFGROUP: packet input interface group
  * @NFT_META_OIFGROUP: packet output interface group
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
+ * @NFT_META_PRANDOM: a 32bit pseudo-random number
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -707,6 +708,7 @@ enum nft_meta_keys {
 	NFT_META_IIFGROUP,
 	NFT_META_OIFGROUP,
 	NFT_META_CGROUP,
+	NFT_META_PRANDOM,
 };
 
 /**
diff --git a/lib/random32.c b/lib/random32.c
index 1211191..510d1ce 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -255,6 +255,7 @@ void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state)
 		prandom_warmup(state);
 	}
 }
+EXPORT_SYMBOL(prandom_seed_full_state);
 
 /*
  *	Generate better values after random number generator
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fe885bf..16c50b0 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -28,6 +28,8 @@
 
 #include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
 
+static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -181,6 +183,11 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = sock_cgroup_classid(&sk->sk_cgrp_data);
 		break;
 #endif
+	case NFT_META_PRANDOM: {
+		struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
+		*dest = prandom_u32_state(state);
+		break;
+	}
 	default:
 		WARN_ON(1);
 		goto err;
@@ -277,6 +284,10 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_OIFNAME:
 		len = IFNAMSIZ;
 		break;
+	case NFT_META_PRANDOM:
+		prandom_init_once(&nft_prandom_state);
+		len = sizeof(u32);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.4.10

