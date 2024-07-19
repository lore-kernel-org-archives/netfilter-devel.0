Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B057685656
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2024 11:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721388704; cv=none; b=l/9YSm47kZB315QKSIEYSVHXWjPJFOGSgwcigZEH69r8ish1Yu/ikAxRTw3irde+2FFq3VdKjpErxts8LJ+itWjsjoEiJIKzv7pYUm93T28querbUMYxTW1OfbWiJicvZxsF3eyYr4x0WDVLWd+rF3qX1YLxc1cnYxktwARJHCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721388704; c=relaxed/simple;
	bh=VfZqSV3hKBLM8lhfTvXf2+zFoP8/aoPy1+1NBJuPpHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NX5WBIUGFXJO2FyaL3wcLKbSmuTmVo1QStC9Q49jmc+bhSMmu3VKwOGfWhkQFRqACwGb4iFB2PZDT28bct9ihQf/HDXvfAPP9KcU40oWBp3nBcwcS5VdKVoB0F5mBJMbl9Hc15TrPnGfxFYlR3Ye2w0x29/edSquGSoUE1RbvLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sUlpn-0001XC-ED; Fri, 19 Jul 2024 13:31:35 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH nf] netfilter: nft_set_pipapo_avx2: disable softinterrupts
Date: Fri, 19 Jul 2024 13:19:26 +0200
Message-ID: <20240719111930.3050-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to disable softinterrupts, else we get following problem:

1. pipapo_avx2 called from process context; fpu usable
2. preempt_disable() called, pcpu scratchmap in use
3. softirq handles rx or tx, we re-enter pipapo_avx2
4. fpu busy, fallback to generic non-avx version
5. fallback reuses scratch map and index, which are in use
   by the preempted process

Handle this same way as generic version by first disabling
softinterrupts while the scratchmap is in use.

Fixes: f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version")
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 8910a5ac7ed1..b8d3c3213efe 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1139,8 +1139,14 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	bool map_index;
 	int i, ret = 0;
 
-	if (unlikely(!irq_fpu_usable()))
-		return nft_pipapo_lookup(net, set, key, ext);
+	local_bh_disable();
+
+	if (unlikely(!irq_fpu_usable())) {
+		bool fallback_res = nft_pipapo_lookup(net, set, key, ext);
+
+		local_bh_enable();
+		return fallback_res;
+	}
 
 	m = rcu_dereference(priv->match);
 
@@ -1155,6 +1161,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	scratch = *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch)) {
 		kernel_fpu_end();
+		local_bh_enable();
 		return false;
 	}
 
@@ -1235,6 +1242,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	if (i % 2)
 		scratch->map_index = !map_index;
 	kernel_fpu_end();
+	local_bh_enable();
 
 	return ret >= 0;
 }
-- 
2.44.2

