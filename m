Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0DE2EDD53;
	Mon,  1 Sep 2025 08:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714156; cv=none; b=ZRxWx6KHmzQL02kkhVZvIdw75md/c7HGVMr665gs9CABTfdwSpaItPfgD6xhvAE8JZ1+Mxbr/eJmoRTWWJ8UwQxC0Kp+NV0+NaVkQUZ8fZ4TTpzrM92OI5Cmvwjo97r0/0BWloAbIA38D1/0QGBBYegi2dDYfj4grV0TmVlcPA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714156; c=relaxed/simple;
	bh=C5FJACMj8Tl46ZtgGXrVraHENJmLhdCgWGnpMB4l3ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDEeB5w4IklrCi9eF8E+YvZ9rc13K9ekL63rVbWWkb+ZmR8lByugV1EJvVoisL+lw76s6vbUMjkgAFQxln4cmsJqosrA+/PYzPfp9Rq6eqVYvfmAGbiwvbTeWsa1r7FtCBH6Q4brp7S/fSOQoWRvML0sEjSLEN8uOfiULTVhJ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A8C5460742; Mon,  1 Sep 2025 10:09:13 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 6/8] netfilter: nft_set_pipapo: remove redundant test for avx feature bit
Date: Mon,  1 Sep 2025 10:08:40 +0200
Message-ID: <20250901080843.1468-7-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250901080843.1468-1-fw@strlen.de>
References: <20250901080843.1468-1-fw@strlen.de>
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
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 3 +--
 net/netfilter/nft_set_pipapo_avx2.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index b385cfcf886f..4b64c3bd8e70 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -530,8 +530,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 	local_bh_disable();
 
 #if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
-	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&
-	    irq_fpu_usable()) {
+	if (boot_cpu_has(X86_FEATURE_AVX2) && irq_fpu_usable()) {
 		e = pipapo_get_avx2(m, data, genmask, tstamp);
 		local_bh_enable();
 		return e;
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

