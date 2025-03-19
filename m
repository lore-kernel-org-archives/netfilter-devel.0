Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DBE7462;
	Wed, 19 Mar 2025 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742392978; cv=none; b=u0SSakZK1vmj5cOVkjkwPElrynlCF3/EuLPnBuqos4u8dHww6F6SfwkbqabG+hD7us3oUG+MJXZrNOzb8KutD/c6tQmVgkHDeKMWLf/Wv86SsrPXSNAsWo8kA54WG6Vg6WrhLyYMNT3rP+Z7iFYj+nXIwvxT9cs9r6z3jTpg8XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742392978; c=relaxed/simple;
	bh=MwSIdKjmT0ZmSVMPxzWZ2wjwyXNpSondm43EnkEgpLc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dN21zR9oRlBUJw7Djgrslq0wstmcztaknJ4DIR6xpYXiP3LRs6nVeIy9TOC6EZswBTfnXkDPuKGbdAp+r0BL7SECvbkNYiI8pc4m9xO/JMUyCVrTglj7qABuf2ae1Qq6FAkvBpBxE+K1DmU/L/aLY4ld4m4LzcCBa8Wii92UMi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ZuC25bCw; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ZuC25bCw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1742392956;
	bh=WpjoJ6z81oFZs/qbLdWvq8m6Ct7lQ6FGHAPq+b8uS88=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ZuC25bCw4vfJn0RpbGvCuKd2L9lj4orjOBjSTGg1VaVQ/1vtKGGLlUUP1LZ49lClL
	 hKJ546JvXl0eBRsNLI6BlnM0srFIaYMNQo52htwCuOEuDrQj+c9ZhI9VuCH9h7xd0j
	 aHTWkwWM3n6O9gZssjloSbW6WI9jMQL44NmtdMLc=
X-QQ-mid: bizesmtpip3t1742392912tvp36sv
X-QQ-Originating-IP: VNUJIvmM/shlmSu8T7R5ko/Sox+Q6GyZBmxWnB0hTA8=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 19 Mar 2025 22:01:49 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17825369448861157517
From: WangYuli <wangyuli@uniontech.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	eric.dumazet@gmail.com,
	fw@strlen.de,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	WangYuli <wangyuli@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH net v2] netfilter: nf_tables: Only use nf_skip_indirect_calls() when MITIGATION_RETPOLINE
Date: Wed, 19 Mar 2025 22:01:47 +0800
Message-ID: <568612395203CC2F+20250319140147.1862336-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: OVMqbsUyNYbuFsww4jmsiUwCuK3k/HTqJ2t8PHGTehFyD8qH2pQghHnL
	BmH3I8lxuSjkkR8eXPXlGDoNjG0V8132HLnUp7IvN1YGN8AtKeE40JE1nRBP0DL9n6inlEI
	UFiPaPp5+73jLTgXpESYqc0VUtG1JAQk/ZSEaSP/4YcpS9pH3bntMdiQws5zJRy/10Pcal2
	eA2OsuTlNZ+vUwmQbIOa7ozRVDDARV/eECFNwuGJrw9JtR7j0FbrEaJ5294bwTNNhiZBbbL
	4CR0bAGBwEroQUCvh+NGIeV4eptwNyjAlCU403M7AwqHXuKaHKLMp+jgyLHKfSL18TBSzpy
	vxJn6gmTAeBgxX/5cqwMeOxvlqbDMw1dJlk2sMzB6hFv6QRpozuddrOqYlvGIZjbT0HJ/N6
	ujrI/kusuQQET4nwy0B79/B/cqaB1kdwRKdBpXO7lbVUODaeJsPMMRvI5bRAFnoo+rDovX/
	nqBiKM9i/txGSEaTYhJeX6GyxgrJAylxpjIIMcKIy9mwBfrudG9sUu41CR3akzUffa0uy5t
	bRCoZQ2LbdBNizl+pAbUps3Ko82DwIB7lgDzd7qrTmmNXXrUVESh3kybtTT4LgFVO2aXBGz
	BbupiOndIWVD4z8QbtW/6MXFjZurD154zMuScFmdagichrpRG3NBanbHL805WDJF3dwK5pm
	zkxx9ED6rZkr8Hvb+Eg9lEQJFcLdYDP3G7ncz9PX96rGk3pH+jCdO2WPcfZadUtK5GhHVFq
	ywhhVFCapu7DrEiqLDdfcsneizYJvuDZ8fe3ZhQlp/d8kYiOUwhP55X+YcvT+08nTEaRvWk
	DM8YtvbyBBz/CzJV5Epw7vNWHMZmSDtdPoNrS797ajLhkdRHiYW8kFNfQ99kCZjYOdAblf4
	Nxa3Ol+1cb9hJtnVLVPefl7pwbsM64R0L05ywNWXWDwvGSVwdctI7BNDpaHMRpB7lAe6ZsA
	5ZzDcOnUid06vVs3Kj5o4QzfDlPLE06AXq5opcm52Yp1WFkhKbMuDFo8EYe74KplD7yw2XE
	MQVYWiug==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

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
---
Changelog:
 *v1->v2: Avoid the extra CONFIG_MITIGATION_RETPOLINE.
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
2.49.0

