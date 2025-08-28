Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581B2EACEF
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 23:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425020; cv=none; b=KtLSKg0EhvmPhqlojLVDZIaX4i1hKdO7zwAz2R3+iZkeKLnSVsKBoTKRq5rm0cHs1HvsylBa+kv9HaHMmTFiwkIkPKEo3Rw8JCrd+25cDQcokIguDjUyNK8rs1Al015Hm5ITdsRE2V0dZerznUJAHGW+HUaLxYaH3TKWoFTFqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425020; c=relaxed/simple;
	bh=gvCWCn/r7BTKekiL7O9n4UbjmFd4dl8QdR0mcHHdvGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QjLE1UNcB9U6vetRPgeSRmYOP3vGDXgZfEfCJU+Sl5GZJi4cy8n/6tRfGvE9CKCUjMX2KlOiYOZktqkUpVdazG7uAhKMG58xEAWDlR0vMHbmusL2YtDCpTxdjFH3RTBnTuXzHkG/TXL6OUUiK5hZoyCioZMhQHu0S39McMZPc0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8108760555; Fri, 29 Aug 2025 01:50:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH nf-next] netfilter: nft_set_pipapo: remove redundant test for avx feature bit
Date: Fri, 29 Aug 2025 01:50:05 +0200
Message-ID: <20250828235008.23351-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sebastian points out that avx2 depends on avx, see check_cpufeature_deps()
in arch/x86/kernel/cpu/cpuid-deps.c:
avx2 feature bit will be cleared when avx isn't available.

No functional change intended.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 2 +-
 net/netfilter/nft_set_pipapo_avx2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index b385cfcf886f..415be47e0407 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -530,7 +530,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 	local_bh_disable();
 
 #if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
-	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&
+	if (boot_cpu_has(X86_FEATURE_AVX2) &&
 	    irq_fpu_usable()) {
 		e = pipapo_get_avx2(m, data, genmask, tstamp);
 		local_bh_enable();
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 29326f3fcaf3..7559306d0aed 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1099,7 +1099,7 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 	    desc->field_count < NFT_PIPAPO_MIN_FIELDS)
 		return false;
 
-	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_AVX))
+	if (!boot_cpu_has(X86_FEATURE_AVX2))
 		return false;
 
 	est->size = pipapo_estimate_size(desc);
-- 
2.49.1

