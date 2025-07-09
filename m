Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487C42222D7
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080752; cv=none; b=AzOg9f0UVISpPR1qHVwd8uTOQx5Ut95cF0WXFJMU5HfF6IwRhE273dj5DZH5Dt00a3y9ybI3WqDzQYvW/GU8Q9mm/5Q0F93+18rnRtTG3s1nG8EhLnz/up4k54BVxwcK1PeMmoGkXNDwnVv3lU41SJrX4oUNnEiIDX4tZ1tW7w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080752; c=relaxed/simple;
	bh=BDuE83xRSoNCo9ufCCsTJPHCkArKxAzxESnrbmA9C1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8QZNmPQcjVsQva57l0KvNvXUEJguUTdalrZFyKA7/ShPsLEgy9QHyay5yqHdvPrffiRwGoifwyZKzrfHeHupBJFoSSlwpGMJ52uZHU07d1pfGulgHrgcNV25fM3ONAUTfr/RA7nbRYK/aYF6WTtOecx/ueoqF+OWgH7JQYpz4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CE2FE60BCB; Wed,  9 Jul 2025 19:05:49 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH nf-next v2 5/5] netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps
Date: Wed,  9 Jul 2025 19:05:16 +0200
Message-ID: <20250709170521.11778-6-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250709170521.11778-1-fw@strlen.de>
References: <20250709170521.11778-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scratchmap size depends on the number of elements in the set.
For huge sets, each scratch map can easily require very large
allocations, e.g. for 100k entries each scratch map will require
close to 64kbyte of memory.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 no changes.

 net/netfilter/nft_set_pipapo.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 528e9af3ad89..4eda3633c75e 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1152,7 +1152,7 @@ static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int c
 
 	mem = s;
 	mem -= s->align_off;
-	kfree(mem);
+	kvfree(mem);
 }
 
 /**
@@ -1173,10 +1173,9 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		void *scratch_aligned;
 		u32 align_off;
 #endif
-		scratch = kzalloc_node(struct_size(scratch, map,
-						   bsize_max * 2) +
-				       NFT_PIPAPO_ALIGN_HEADROOM,
-				       GFP_KERNEL_ACCOUNT, cpu_to_node(i));
+		scratch = kvzalloc_node(struct_size(scratch, map, bsize_max * 2) +
+					NFT_PIPAPO_ALIGN_HEADROOM,
+					GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
 			 * allocations: this means that some scratch maps have
-- 
2.49.0

