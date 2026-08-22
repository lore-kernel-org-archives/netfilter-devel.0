Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574543806AD;
	Sat, 22 Aug 2026 21:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787433009; cv=none; b=hDjcTKjDjXwLH4elIG7mqaWk3Xsr/XRDvmMHYF+lz7ym6dG52+mRTmL9mCR29FSzZBkSLpviTJRba46ZFtVJQO8IMqIrPqalzSm2/btlQ9kmEJeuV52wPkvp5hr7cufPrTPqOT3r8O3u9lSHbkoQs4MFHtohT3FFPyaqNPyNMvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787433009; c=relaxed/simple;
	bh=KgMG14rJzYNAPdkqdc/7hpNJMhpNCZOeJSw3p41Ibig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XVyxTpEB8IPQVRapRg6k9gDDUnI+9dcRmS/EJfbmciv3ifkIujkQnsdwrAM+S1VuBgyU5ZqIT1BoR6b3ljPRQRptkLlBAQMqkSnSkaiQKa4qz1lwnLdonIVV7QNjQdBl7M3mA8OOSKjXz8RcGWUTm7BHR0nLzYpaBjZppyJXLU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=IlVRaI0a; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="IlVRaI0a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=F9fPZhNohuA0JOQgrOmi2L2GIR7rpgyy1St6QvWxGlM=; b=IlVRaI0aObrKY+vOmNgCHiXM9v
	KcQx5d86IBU2ePAYMEShJg53/m2FJ67NzIf2KkSP6tpP9s8o7u0BJ4dTGRbaIwMUeqvvb62IHSB/8
	RiRLT9OQC4fyp1xO8BY86MkSnjjG5PkaleTfnPeTe4cHla511igXStB137gojWgIj/4/YeKHTj39/
	cqQQdKpWysIaIMHv5RctDz70f3q0T41DL2TA3HqKHQdrpGinJ89jPaNQIhgXdGGcDD0YGWpW/rfxG
	hVv7Kpi4piBByYZ+Kqf2pb6L4ZPMRTLExsRHneWYnjbcYx8oBCDdZge23/Kwbji/kzewoGQ73eEQZ
	91Oew7IA==;
Received: from [151.115.150.205] (port=39662 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxsyb-00000002OEp-2AlV;
	Sat, 22 Aug 2026 23:10:04 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] netfilter: bpf: disallow conntrack kfuncs for token programs
Date: Sat, 22 Aug 2026 21:09:46 +0000
Message-ID: <20260822210945.1003967-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

BPF tokens delegate BPF and network-admin capability checks to the token
owning user namespace. Conntrack kfuncs nevertheless accept a network
namespace ID relative to the program context without checking whether the
token has authority over the resolved namespace.

An XDP program attached to a veth in a child network namespace can use
the peer namespace ID for init_net. bpf_xdp_ct_alloc() then allocates an
entry in init_net, bpf_ct_insert_entry() publishes it, and the lookup and
mutation kfuncs can subsequently access that host state.

The verifier retains the token in prog->aux, but it cannot determine the
runtime namespace selected through bpf_ct_opts. Conservatively reject the
conntrack kfunc set for token-loaded programs. The kfunc interface is
explicitly unstable, and ordinary token-authorized XDP programs remain
available.

Fixes: caf8f28e036c ("bpf: Add BPF token support to BPF_PROG_LOAD command")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/netfilter/nf_conntrack_bpf.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index c2df7c9..4075ee1 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -532,9 +532,24 @@ BTF_ID_FLAGS(func, bpf_ct_set_status)
 BTF_ID_FLAGS(func, bpf_ct_change_status)
 BTF_KFUNCS_END(nf_ct_kfunc_set)
 
+static int nf_conntrack_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	/*
+	 * Conntrack kfuncs accept a netns ID relative to the program context.
+	 * The verifier cannot determine which user namespace owns that target.
+	 * Do not let a token delegate authority over arbitrary peer netns state.
+	 */
+	if (prog->aux->token &&
+	    btf_id_set8_contains(&nf_ct_kfunc_set, kfunc_id))
+		return -EACCES;
+
+	return 0;
+}
+
 static const struct btf_kfunc_id_set nf_conntrack_kfunc_set = {
 	.owner = THIS_MODULE,
 	.set   = &nf_ct_kfunc_set,
+	.filter = nf_conntrack_kfunc_filter,
 };
 
 int register_nf_conntrack_bpf(void)
-- 
2.47.3


