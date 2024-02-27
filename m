Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AFD4E1CF
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Feb 2024 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060526; cv=none; b=uhsK2Z1fiTS9Pdf0/fYFBfUV/7wweFnXwEFxPqKLoDO3jUq5ZXQ9GdKEiA15MqibR6htFhtt4oYk4k44nSSfNwuAWFRxrGKUIiCmHiRS/1pDNaGoS9UWbwyp8BBJsT9bcuZNjSeZge36+2UHlwyuTHBhpunOA9tt1EXaj3U2s5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060526; c=relaxed/simple;
	bh=sdXwrCz7CLBGP7Q0zkjCk8NcmBHQXR6WP1GQ1s0sp80=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IK5YITFOK8GChptcrt2BPeH4UMjoZLd2RBrC0Pb73cCx91yAxD2O37HMW3H/z97AucgPOr90WirMtRgjLtWmTfYSvLCJ65UERIjuEHstANZ9+A3zBTyLVKSDWvxFvcaOYIMJYip2fekMg+sV3CMa5oXaZUyyY9l3rzQUWAyyhYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hOcNoSwg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hOcNoSwg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WRSXOiKmyowBLAwTxYfOy6P9fTIW/2SOCvtFTcaf5M0=; b=hOcNoSwgeO5Ku1a2HswPtzR0R7
	xEQV53xJ8TDLFwk5WZuz9TEARbJe3MmgJVCdIP48l2QMT900Hi9sS9ogGV/YamTXzKX1ug6DM/GEm
	zUjY/Q1efK/U11yl4T/4RWFlqAP/5KDtnUFavRHq28j46ZdapJPSAtEPUlHUs7KutN9ZVCtKOJ27x
	EcTNy14o3UfZ8rXr3KLZbjjFlO5M3s7Ak5czASIm5P4m9oOKPCswndfKhW3pnhJop9ABqoksFd80u
	mi4eSzW5/iEuBNhyEMOia5+AilHS28JQvVO3nCzJBcAv2vl2o9932QIBiJNbNzxdbQlGRYdYvGOmn
	92ZiiGhg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rf2Nx-000000005Ph-0biF
	for netfilter-devel@vger.kernel.org;
	Tue, 27 Feb 2024 19:41:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix for broken recover_rule_compat()
Date: Tue, 27 Feb 2024 19:40:57 +0100
Message-ID: <20240227184057.6017-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When IPv4 rule generator was changed to emit payload instead of
meta expressions for l4proto matches, the code reinserting
NFTNL_RULE_COMPAT_* attributes into rules being reused for counter
zeroing was broken by accident.

Make rule compat recovery aware of the alternative match, basically
reinstating the effect of commit 7a373f6683afb ("nft: Fix -Z for rules
with NFTA_RULE_COMPAT") but add a test case this time to make sure
things stay intact.

Fixes: 69278f9602b43 ("nft: use payload matching for layer 4 protocol")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                | 27 ++++++++++++++++---
 .../nft-only/0011-zero-needs-compat_0         | 12 +++++++++
 2 files changed, 35 insertions(+), 4 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0011-zero-needs-compat_0

diff --git a/iptables/nft.c b/iptables/nft.c
index dae6698d3234a..ee63c3dc42ed4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3750,6 +3750,27 @@ const char *nft_strerror(int err)
 	return strerror(err);
 }
 
+static int l4proto_expr_get_dreg(struct nftnl_expr *e, uint32_t *dregp)
+{
+	const char *name = nftnl_expr_get_str(e, NFTNL_EXPR_NAME);
+	uint32_t poff = offsetof(struct iphdr, protocol);
+	uint32_t pbase = NFT_PAYLOAD_NETWORK_HEADER;
+
+	if (!strcmp(name, "payload") &&
+	    nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_BASE) == pbase &&
+	    nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET) == poff &&
+	    nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_LEN) == sizeof(uint8_t)) {
+		*dregp = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_DREG);
+		return 0;
+	}
+	if (!strcmp(name, "meta") &&
+	    nftnl_expr_get_u32(e, NFTNL_EXPR_META_KEY) == NFT_META_L4PROTO) {
+		*dregp = nftnl_expr_get_u32(e, NFTNL_EXPR_META_DREG);
+		return 0;
+	}
+	return -1;
+}
+
 static int recover_rule_compat(struct nftnl_rule *r)
 {
 	struct nftnl_expr_iter *iter;
@@ -3766,12 +3787,10 @@ static int recover_rule_compat(struct nftnl_rule *r)
 	if (!e)
 		goto out;
 
-	if (strcmp("meta", nftnl_expr_get_str(e, NFTNL_EXPR_NAME)) ||
-	    nftnl_expr_get_u32(e, NFTNL_EXPR_META_KEY) != NFT_META_L4PROTO)
+	/* may be 'ip protocol' or 'meta l4proto' with identical RHS */
+	if (l4proto_expr_get_dreg(e, &reg) < 0)
 		goto next_expr;
 
-	reg = nftnl_expr_get_u32(e, NFTNL_EXPR_META_DREG);
-
 	e = nftnl_expr_iter_next(iter);
 	if (!e)
 		goto out;
diff --git a/iptables/tests/shell/testcases/nft-only/0011-zero-needs-compat_0 b/iptables/tests/shell/testcases/nft-only/0011-zero-needs-compat_0
new file mode 100755
index 0000000000000..e276a953234cf
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0011-zero-needs-compat_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+
+set -e
+
+rule="-p tcp -m tcp --dport 27374 -c 23 42 -j TPROXY --on-port 50080"
+for cmd in iptables ip6tables; do
+	$XT_MULTI $cmd -t mangle -A PREROUTING $rule
+	$XT_MULTI $cmd -t mangle -Z
+	$XT_MULTI $cmd -t mangle -v -S | grep -q -- "${rule/23 42/0 0}"
+done
-- 
2.43.0

