Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20088BE7;
	Wed, 19 Mar 2025 03:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742355418; cv=none; b=NKS+mEoixZirJiCG+o00+hESAdaO4iUXhiM5dFt/rFBSrag5uY7/Rw5bPAkthb4FKXERZMZCTRwDrwMkSIuHXkLrzrhHEcw3zOJSuhTRN1wCat0W8Pgl5xt45bQw3E9dy5CH86O+dO36n8R3CrxSrABWWxp6ipyonnG1gC13IP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742355418; c=relaxed/simple;
	bh=pp1RgEz7+tlhRwSDDrL3qiowlEkFNLLCkbpWMHxeC2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MmcA7+9ZpIdSI0Dy7J0WofAblYgbcJfC7EfpCWvkSmke3G0zZVClW6MBdzplXFzvbrxC6RI3J/P1oqKebT2ht3Ce+qxT5/w6EXqM1Q8/mwpNztb6CHWFopyhuyTm/BgafVZI9vOxwLyz0m7GnOKUh5QP51lg5oGYN7v/DcCYCgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=j/L84cUU; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="j/L84cUU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1742355399;
	bh=fmRqY+JDZY5i3/fjqLE27xJ4JDCC12QtNnBz4AnHDpg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=j/L84cUUyWGc6D3zBDR+vOXtzEPEKXN959iy1w3io6P1/snUD4F29ZYbELrU7cHLA
	 vIXKtSpU3L3KFH05zVvNSTkl323iIbVh9z+4dCt+dvw2rQyMWyWCns+PiyiOxBASjN
	 xDXdlZthTMg0obwKc37hlpaE+sr3FrdNUbHLta5w=
X-QQ-mid: bizesmtpip4t1742355351tcmig4x
X-QQ-Originating-IP: X9j/ZIBSIzwYhFiwIBBO/UOkuXEkV9sWk1tNamg6tvE=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 19 Mar 2025 11:35:49 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17725562205952502162
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
Subject: [PATCH net] netfilter: nf_tables: Only use nf_skip_indirect_calls() when MITIGATION_RETPOLINE
Date: Wed, 19 Mar 2025 11:34:44 +0800
Message-ID: <91A1F82B6B7D6AC2+20250319033444.1135201-1-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: Mv+tyGIfil93X88bSXqjV4CVQrPFfvyx0qbbQdKtpXRIfY6Mc/IfpdeE
	xrBf9XJ9A7vpNiYNBPIwHie4Y9HsukmxIf6uADEVC0xkmnGZbhvbpofBs1KVyeeQfUpn1Q2
	/g3qhTKmNvhT1xQT/TK9rNsGr1Uv4NndOqMvsELK4TblVux2MJSQpYmEuPN6hIfJNKfcpg6
	cXOl0zNoFJ3sYUCm3oz9AdhvSMHFephIrBiZQyL9a0rFGvpvswzAWDOi0RCmct1kxcWUAKN
	cff21e/lM72Jyf9dvIE5yr+J2jgQpofiNWNQMiGjYUvfPuDYm4SBxJgW5dJhWrFy61pKbdi
	2A5nGf0VT4mg5+cBWs4ejzV/UayON3RSIYA4LehV8QtFQf+fCAr2WL41DsPOZcY/0Cyr9SN
	HYwCiI8US9nAjzLsHLYz872L+k532fZna7enOISjQ8Jf/S1TEzcpcQAETyPMHT7tFO4yV9P
	inlojxhCjmIEy7/QF2g+CNury5CzX1DlxtwJTA70AEFEtri1Q92adtH3GoOcqS0RSE77Feh
	nH2eJlCXEz7XL9H52/BL79XYTDdJ4SF1xqtrvPQ4nb7Xyyn+Ud+KqGRh5ooDv41cNz1yzWS
	2uI+xq9yV2QlGLfK9tHAuEv+ROPx2GkmzVeCQoJLTm5J4e0klHVv5DEyFkm+wmPuhTefsZl
	hctMqg/0CC52kkv29bUyhmcZZzaYxvw9Oy4SFZJrCU6J8V2L+IpwGmG51ODZDyjf7WLoFX0
	XFbqu6VyNKPIvLfWVYdTx7ZiPNqCvoGbonTpZGiWZaenPRaBzJVnA5OdxHuUwK04/ztx3dJ
	RcooLxSBBTxTvuC8SSPQ/+AgHADuvHTAA+BLofzs1gFmxU7yGB0N67ely/Ex27iLNwznYSU
	GINhZUN+lfrMhq6V7AmfzB4T/RTpHok20apgXPeaKnazvYOmSnYaVrRvvG1VfJtQ5iOSXxL
	t2BT7tH/y8vgcd+sCPZFaEyl3Wr4GbHCBTAkTSbxb+XVKKO/KIFvgzJ501Vv4Gmk8cWU=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

1. MITIGATION_RETPOLINE is x86-only (defined in arch/x86/Kconfig),
so no need to AND with CONFIG_X86 when checking if enabled.

2. Remove unused declaration of nf_skip_indirect_calls() when
MITIGATION_RETPOLINE is disabled to avoid warnings.

3. Declare nf_skip_indirect_calls() and nf_skip_indirect_calls_enable()
as inline when MITIGATION_RETPOLINE is enabled, as they are called
only once and have simple logic.

4. Following that, there's no need to define an empty
nf_skip_indirect_calls_enable function. Just simply add the same macro
condition around its sole call site.

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
 net/netfilter/nf_tables_core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 75598520b0fa..48b8d2406d4e 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -21,25 +21,20 @@
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
-#else
-static inline bool nf_skip_indirect_calls(void) { return false; }
-
-static inline void nf_skip_indirect_calls_enable(void) { }
-#endif
+#endif /* CONFIG_MITIGATION_RETPOLINE */
 
 static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 					const struct nft_verdict *verdict,
@@ -393,7 +388,9 @@ int __init nf_tables_core_module_init(void)
 			goto err;
 	}
 
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	nf_skip_indirect_calls_enable();
+#endif /* CONFIG_MITIGATION_RETPOLINE */
 
 	return 0;
 
-- 
2.49.0

