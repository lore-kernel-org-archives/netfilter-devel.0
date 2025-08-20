Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9313032038B;
	Wed, 20 Aug 2025 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701292; cv=none; b=hTrFDTSdBF8lhKDGA7gkobTJKciI1+GVlQ5U++gprdxiIgaZV3MeMX3yxW133GQZjhJ3Qin/+T8PVAiOokN4NEPYZ14n6cSsFEfyHupXV4thEP3q0LUu8odcG6H5oV8G+lM+cEQYnvCM1fx3K0zlnOOuw6/Uim2Dv4ydAkGsb+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701292; c=relaxed/simple;
	bh=YiuIDOwjE3BwdsCu4j/KS7wWOUl+0ozv1nVq4n8Mw2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgHisXb2iyY2CVVsaSMxmfaWVW8Jj9xABpyzxJsaf6N8ymL4zwaYujxptG3aKhUerwEex56xvZX+ag0rtpfncm2cECJ12sBzCUjxF8uhEA3cdywy5gR0uZ66u5Tt8vlWFaOpeJwatR5n7Ba4V2leChnnM8GmgVQ0sYbGEop/d6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DEDBA603CA; Wed, 20 Aug 2025 16:48:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 6/6] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
Date: Wed, 20 Aug 2025 16:47:38 +0200
Message-ID: <20250820144738.24250-7-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250820144738.24250-1-fw@strlen.de>
References: <20250820144738.24250-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

nft_pipapo_scratch is a per-CPU variable and relies on disabled BH for
its locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Add a local_lock_t to the data structure and use local_lock_nested_bh() for
locking. This change adds only lockdep coverage and does not alter the
functional behaviour for !PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 5 +++++
 net/netfilter/nft_set_pipapo.h      | 2 ++
 net/netfilter/nft_set_pipapo_avx2.c | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 96b7539f5506..b385cfcf886f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -429,6 +429,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 	scratch = *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch))
 		goto out;
+	__local_lock_nested_bh(&scratch->bh_lock);
 
 	map_index = scratch->map_index;
 
@@ -465,6 +466,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 				  last);
 		if (b < 0) {
 			scratch->map_index = map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
 
 			return NULL;
@@ -484,6 +486,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 			 * *next* bitmap (not initial) for the next packet.
 			 */
 			scratch->map_index = map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
 			return e;
 		}
@@ -498,6 +501,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 		data += NFT_PIPAPO_GROUPS_PADDING(f);
 	}
 
+	__local_unlock_nested_bh(&scratch->bh_lock);
 out:
 	local_bh_enable();
 	return NULL;
@@ -1215,6 +1219,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		}
 
 		pipapo_free_scratch(clone, i);
+		local_lock_init(&scratch->bh_lock);
 		*per_cpu_ptr(clone->scratch, i) = scratch;
 	}
 
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index e10cdbaa65d8..eaab422aa56a 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -124,10 +124,12 @@ struct nft_pipapo_field {
 
 /**
  * struct nft_pipapo_scratch - percpu data used for lookup and matching
+ * @bh_lock:    PREEMPT_RT local spinlock
  * @map_index:	Current working bitmap index, toggled between field matches
  * @__map:	store partial matching results during lookup
  */
 struct nft_pipapo_scratch {
+	local_lock_t bh_lock;
 	u8 map_index;
 	unsigned long __map[];
 };
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index f0d8c796d731..29326f3fcaf3 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1163,6 +1163,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 	if (unlikely(!scratch))
 		return NULL;
 
+	__local_lock_nested_bh(&scratch->bh_lock);
 	map_index = scratch->map_index;
 	map = NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
 	res  = map + (map_index ? m->bsize_max : 0);
@@ -1228,6 +1229,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 		if (ret < 0) {
 			scratch->map_index = map_index;
 			kernel_fpu_end();
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			return NULL;
 		}
 
@@ -1241,6 +1243,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 
 			scratch->map_index = map_index;
 			kernel_fpu_end();
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			return e;
 		}
 
@@ -1250,6 +1253,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
 	}
 
 	kernel_fpu_end();
+	__local_unlock_nested_bh(&scratch->bh_lock);
 	return NULL;
 }
 
-- 
2.49.1

