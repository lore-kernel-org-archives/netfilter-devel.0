Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E1C242D6E
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751395998; cv=none; b=Yaiw3dOLQlHV03DIzMcOF78t08kwGDgXsnyzRClf00tdseo4r+pxMoFF+sJ5eps+hgcLCQ759eaVUGEK7giUQGBgN9tN02GeBR831FuSLTprv/UCFv/bjKuj/FXTYO64/4EkK/eO+OLiKMpIubJZj7maV87xHRSxEL20CtEmgCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751395998; c=relaxed/simple;
	bh=1ljR/Fj4ocQVJ1qpwZIXxcy78eVXkq9ZOVjKtHTsLSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVS9moHsf0cat+9JwDB3aHTgQAJ5QdYpjOPFFt3aVHKOz/mf3WQy7jny40vRFth/2WmjI18YWjm12elrLXBZgib06YOHlv7baWxHuwQWNCCVf2KO/GeCUZp3Rax56NvB+yY+jvWVqe1Qyl1Zxg4SL1cjcXpXzvRdaPi783ZGP20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1B90C618A3; Tue,  1 Jul 2025 20:53:15 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/5] netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps
Date: Tue,  1 Jul 2025 20:52:42 +0200
Message-ID: <20250701185245.31370-6-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250701185245.31370-1-fw@strlen.de>
References: <20250701185245.31370-1-fw@strlen.de>
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
---
 net/netfilter/nft_set_pipapo.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index ebd142d8d4d4..a194e072e057 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1153,7 +1153,7 @@ static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int c
 
 	mem = s;
 	mem -= s->align_off;
-	kfree(mem);
+	kvfree(mem);
 }
 
 /**
@@ -1174,10 +1174,9 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
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

