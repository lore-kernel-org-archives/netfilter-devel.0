Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7571CFB2
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 12:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707222582; cv=none; b=ce+tbNy055d+H0U5OLc+Zw8sTukAjIpreHVNGzDm/pFTaHkMH8Yv4BpGT60Zgdvptmj0xb94iM4mb5YBdwLcWtmoRVEz3Yb94qvc+YKo5UziQrPhRpdRENmosXtDTGBS93CEw6CDVF94bre0WgRZJ6LLMCCdxSLRrMM8Hb724BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707222582; c=relaxed/simple;
	bh=thDciK4T6VfgyCvVdWP6EyygOdYA+TaXs84AxwhrSnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtyaE05JNGoEDuCCTIpv3xqRUnMH7Ipf+wVatDqVW97MrfUIDtnXnYawJf/7DHVviUWkYZNRJFik2L52F3CH9DX033JKmomhlrlMHl+hHOv/Or78UmJwMnPXOTF4zJDXX9LT5m7b3TRc7QTwOO6dB2tmLvXt6ZmxftXfjQDJw94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rXKa2-0002Aa-UO; Tue, 06 Feb 2024 13:29:38 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/3] netfilter: nft_set_pipapo: add helper to release pcpu scratch area
Date: Tue,  6 Feb 2024 13:23:07 +0100
Message-ID: <20240206122531.21972-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206122531.21972-1-fw@strlen.de>
References: <20240206122531.21972-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After next patch simple kfree() is not enough anymore, so add
a helper for it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index a8aa915f3f0b..3d308e31b048 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1108,6 +1108,19 @@ static void pipapo_map(struct nft_pipapo_match *m,
 		f->mt[map[i].to + j].e = e;
 }
 
+static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int cpu)
+{
+	struct nft_pipapo_scratch *s;
+	void *mem;
+
+	s = *per_cpu_ptr(m->scratch, cpu);
+	if (!s)
+		return;
+
+	mem = s;
+	kfree(mem);
+}
+
 /**
  * pipapo_realloc_scratch() - Reallocate scratch maps for partial match results
  * @clone:	Copy of matching data with pending insertions and deletions
@@ -1140,7 +1153,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 			return -ENOMEM;
 		}
 
-		kfree(*per_cpu_ptr(clone->scratch, i));
+		pipapo_free_scratch(clone, i);
 
 		*per_cpu_ptr(clone->scratch, i) = scratch;
 
@@ -1359,7 +1372,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	}
 out_scratch_realloc:
 	for_each_possible_cpu(i)
-		kfree(*per_cpu_ptr(new->scratch, i));
+		pipapo_free_scratch(new, i);
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(new->scratch_aligned);
 #endif
@@ -1642,7 +1655,7 @@ static void pipapo_free_match(struct nft_pipapo_match *m)
 	int i;
 
 	for_each_possible_cpu(i)
-		kfree(*per_cpu_ptr(m->scratch, i));
+		pipapo_free_scratch(m, i);
 
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(m->scratch_aligned);
@@ -2242,7 +2255,7 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 		free_percpu(m->scratch_aligned);
 #endif
 		for_each_possible_cpu(cpu)
-			kfree(*per_cpu_ptr(m->scratch, cpu));
+			pipapo_free_scratch(m, cpu);
 		free_percpu(m->scratch);
 		pipapo_free_fields(m);
 		kfree(m);
@@ -2259,7 +2272,7 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 		free_percpu(priv->clone->scratch_aligned);
 #endif
 		for_each_possible_cpu(cpu)
-			kfree(*per_cpu_ptr(priv->clone->scratch, cpu));
+			pipapo_free_scratch(priv->clone, cpu);
 		free_percpu(priv->clone->scratch);
 
 		pipapo_free_fields(priv->clone);
-- 
2.43.0

