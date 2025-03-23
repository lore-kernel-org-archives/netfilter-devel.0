Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F220485D;
	Sun, 23 Mar 2025 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724582; cv=none; b=tZx6ZF8bhjJICkCr685WUGcXzqPMGdBDLMpAFe2+M4yt6JJOVPv0187GCr/SULIQECHIDmvAttNAZnzL/Nfom41k9hbYwds7hxzUVzyYlwaEBWxR0MynsuhjnJm2vRk5i79crkFkulRZ3KwOXAUXMsYXE8pQ6wRWGmJ6cFeuSxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724582; c=relaxed/simple;
	bh=QhuhP3Q5194hpVotIuU3j+gcmWT7kJrKKYmSWaF/yXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=konO/hSpdr5chbFm8/DSLTUlG7Gjw/tqBe+NuDJ+jVPqjgs3L5fA4yhewxezFYh6kUyZxbeA9zqR+h9fbcuk+y8Ko/gtm/giCMZuZ39xVvNTdwXCUM1oo/73Tn6NWoA7yXLK5XiAUGecdaIqulXuvLooamNDdvmqMeybKtBQvME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dHXUFEiV; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NiKAqkwz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dHXUFEiV";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NiKAqkwz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E12C960375; Sun, 23 Mar 2025 11:09:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724579;
	bh=VFibVsSDp6IqETRP8ko5IpEqx5FRNNS1CgZpXEmKwaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHXUFEiV4nn/7q7V5pJGUh1ykzOFblMIO9dHoBH3WwGwV8krSXrcS3e9GXXSiwK90
	 G6b0meBGrGAFp23cDRNanFaW9o2C96yPFLYxhEBfq7hkpf22A7PLk8rXlbTZftqYb5
	 aWkAcyaJXGOP3kNv/Wzq3Dm9CkYzYjJ9/jmP65GxvGlV9k56K9BstOTkZw3D/fE1cO
	 CPIRaCwqXfI2CUGDq8JEU1kwLhwUTmN8JjCQRIhoA9eqKltvIwoRflBCLgzXwSUkA4
	 GtiZ53QZ3kmh198XJiqmUXE4AXs/UEQbx/NGIBuyIxaYL+ZdvwFZxTNR9VdQaIKSo3
	 XBE1/vBquDTDQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 67CA760386;
	Sun, 23 Mar 2025 11:09:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724571;
	bh=VFibVsSDp6IqETRP8ko5IpEqx5FRNNS1CgZpXEmKwaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiKAqkwzhnQ4Z4GNFNh58EFQYzpLB+NSjDE8FOxiNq3pVeVv0+69xLWXICUXcWTIw
	 JAxZtu7PRiWeDQmv/RGDec/a7VeNFTJmpe0qj7Bvko3QO9onNT2Wfix3KFMRZsf9j+
	 Tt+CGFbLLe54Dod13zppBldMMcS3b0tq6j23Kga1ffMADibCHBz48plWM7tsMGkCWD
	 DRblfLCjcyN+91yEkvAbqjJzYs9GixBuqfxhNZQW34WH71Q6H2KqTfGznDoFkGfIN1
	 1E6qLLzK7eQuuR+8f6phmWHvBtKK0QzqRrp+2OKhDdmOYo4SfsA64rtq793CQ2xgsK
	 3mfY/LGGRAzvg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 7/7] netfilter: nf_tables: Only use nf_skip_indirect_calls() when MITIGATION_RETPOLINE
Date: Sun, 23 Mar 2025 11:09:22 +0100
Message-Id: <20250323100922.59983-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250323100922.59983-1-pablo@netfilter.org>
References: <20250323100922.59983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WangYuli <wangyuli@uniontech.com>

1. MITIGATION_RETPOLINE is x86-only (defined in arch/x86/Kconfig),
so no need to AND with CONFIG_X86 when checking if enabled.

2. Remove unused declaration of nf_skip_indirect_calls() when
MITIGATION_RETPOLINE is disabled to avoid warnings.

3. Declare nf_skip_indirect_calls() and nf_skip_indirect_calls_enable()
as inline when MITIGATION_RETPOLINE is enabled, as they are called
only once and have simple logic.

Fix follow error with clang-21 when W=1e:
  net/netfilter/nf_tables_core.c:39:20: error: unused function 'nf_skip_indirect_calls' [-Werror,-Wunused-function]
     39 | static inline bool nf_skip_indirect_calls(void) { return false; }
        |                    ^~~~~~~~~~~~~~~~~~~~~~
  1 error generated.
  make[4]: *** [scripts/Makefile.build:207: net/netfilter/nf_tables_core.o] Error 1
  make[3]: *** [scripts/Makefile.build:465: net/netfilter] Error 2
  make[3]: *** Waiting for unfinished jobs....

Fixes: d8d760627855 ("netfilter: nf_tables: add static key to skip retpoline workarounds")
Co-developed-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 75598520b0fa..6557a4018c09 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -21,25 +21,22 @@
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nft_meta.h>
 
-#if defined(CONFIG_MITIGATION_RETPOLINE) && defined(CONFIG_X86)
-
+#ifdef CONFIG_MITIGATION_RETPOLINE
 static struct static_key_false nf_tables_skip_direct_calls;
 
-static bool nf_skip_indirect_calls(void)
+static inline bool nf_skip_indirect_calls(void)
 {
 	return static_branch_likely(&nf_tables_skip_direct_calls);
 }
 
-static void __init nf_skip_indirect_calls_enable(void)
+static inline void __init nf_skip_indirect_calls_enable(void)
 {
 	if (!cpu_feature_enabled(X86_FEATURE_RETPOLINE))
 		static_branch_enable(&nf_tables_skip_direct_calls);
 }
 #else
-static inline bool nf_skip_indirect_calls(void) { return false; }
-
 static inline void nf_skip_indirect_calls_enable(void) { }
-#endif
+#endif /* CONFIG_MITIGATION_RETPOLINE */
 
 static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 					const struct nft_verdict *verdict,
-- 
2.30.2

