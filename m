Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1D6374C2
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2024 10:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721213048; cv=none; b=udpo/V+0Kg0+rdZij5NkqtMznBPMoMUlichQyS4YcwAe6if1RO46FWLQrWedt9UfzNlf285tCaICez1cOVonrxLBlBcpYJ0VOYC/SawTDt+k1MaisPt51CM2NRsJCfG25TQYu/5DovvwM9qrKfbntX3hyJ3YPzHyC2FDENeltXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721213048; c=relaxed/simple;
	bh=rX0XsUfu+dR7f0mfS5LFm97LrPHFxV+bosv6aLSbPSA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hkqBVVCsZmntnubaOAcpqs9Pwn9I+BDtiPd11CgCfeKpN17Qb4TUMu/p/dsC54v2UBDRTaoBXUPObo6GWvboQB6az/S2aDVVQIgErQv0Qe9a7frYMkFHyQkzZy9IrnZtQbnocmdr627J8VKCM2/aIeJoL+TM5zsFdwF08R1jJbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fZhQAoAm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fZhQAoAm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sIzgwajgxdj8BPT7M5szedlLRZ+iTffQvh/sXlolrNc=; b=fZhQAoAmtQgnGDV+TS9+xR4ufy
	r3bom5a9ADDye1K+IH8V1mGYIifnlRuf7ab0QfqL1kIiOEkwmLPAU89N0z5d1IC5hREicVRo2fm5r
	hvXwD4MRoPofxC+0hScf7FvxMklSPF2YCglKigXB1Zf2uXXG3Dq5O+4iibkKFlbqqYKDdaD8ZvD+h
	rLj5yPtFyuNqlbRLzWxWYT8qJJq+hf3DovHh4EtHVOpFHIq8ebUupE1lcd1FNs/uU5JFqDgjDHxk0
	b3nJForJu4BUQfRJUj0g8iydjli/alZ5NrFTg/klC6pI4X6qljfwI5KbhQJm6ybqF1d1VuZnJ+6Li
	QnCK9TNw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sU28b-000000004oC-0lkx
	for netfilter-devel@vger.kernel.org;
	Wed, 17 Jul 2024 12:43:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix for zeroing non-existent builtin chains
Date: Wed, 17 Jul 2024 12:43:53 +0200
Message-ID: <20240717104353.8915-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trying to zero a specific rule in an entirely empty ruleset caused an
error:

| # nft flush ruleset
| # iptables-nft -Z INPUT
| iptables v1.8.10 (nf_tables):  CHAIN_ZERO failed (No such file or directory): chain INPUT

To fix this, start by faking any non-existing builtin chains so verbose
mode prints all the would-be-flushed chains. Later set 'skip' flag if
given chain is a fake one (indicated by missing HANDLE attribute).
Finally cover for concurrent ruleset updates by checking whether the
chain exists.

This bug seems to exist for a long time already, Fixes tag identified
via git-bisect. This patch won't apply to such old trees though, but
calling nft_xt_builtin_init() from nft_chain_zero_counters() should work
there.

Fixes: a6ce0c65d3a39 ("xtables: Optimize nft_chain_zero_counters()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                | 22 +++++++++++++++++--
 .../nft-only/0013-zero-non-existent_0         | 17 ++++++++++++++
 2 files changed, 37 insertions(+), 2 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0013-zero-non-existent_0

diff --git a/iptables/nft.c b/iptables/nft.c
index 83fb81439ccb1..a9d97d4cef8e0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3167,9 +3167,21 @@ static void nft_refresh_transaction(struct nft_handle *h)
 				break;
 			n->skip = !nft_may_delete_chain(n->chain);
 			break;
+		case NFT_COMPAT_CHAIN_ZERO:
+			tablename = nftnl_chain_get_str(n->chain, NFTNL_CHAIN_TABLE);
+			if (!tablename)
+				continue;
+
+			chainname = nftnl_chain_get_str(n->chain, NFTNL_CHAIN_NAME);
+			if (!chainname)
+				continue;
+
+			n->skip = nftnl_chain_is_set(n->chain,
+						     NFTNL_CHAIN_HOOKNUM) &&
+				  !nft_chain_find(h, tablename, chainname);
+			break;
 		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
-		case NFT_COMPAT_CHAIN_ZERO:
 		case NFT_COMPAT_CHAIN_USER_FLUSH:
 		case NFT_COMPAT_CHAIN_UPDATE:
 		case NFT_COMPAT_CHAIN_RENAME:
@@ -3817,6 +3829,7 @@ static int __nft_chain_zero_counters(struct nft_chain *nc, void *data)
 	struct nft_handle *h = d->handle;
 	struct nftnl_rule_iter *iter;
 	struct nftnl_rule *r;
+	struct obj_update *o;
 
 	if (d->verbose)
 		fprintf(stdout, "Zeroing chain `%s'\n",
@@ -3827,8 +3840,11 @@ static int __nft_chain_zero_counters(struct nft_chain *nc, void *data)
 		nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS, 0);
 		nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES, 0);
 		nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
-		if (!batch_chain_add(h, NFT_COMPAT_CHAIN_ZERO, c))
+		o = batch_chain_add(h, NFT_COMPAT_CHAIN_ZERO, c);
+		if (!o)
 			return -1;
+		/* may skip if it is a fake entry */
+		o->skip = !nftnl_chain_is_set(c, NFTNL_CHAIN_HANDLE);
 	}
 
 	iter = nftnl_rule_iter_create(c);
@@ -3892,6 +3908,8 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	struct nft_chain *c;
 	int ret = 0;
 
+	nft_xt_fake_builtin_chains(h, table, chain);
+
 	if (chain) {
 		c = nft_chain_find(h, table, chain);
 		if (!c) {
diff --git a/iptables/tests/shell/testcases/nft-only/0013-zero-non-existent_0 b/iptables/tests/shell/testcases/nft-only/0013-zero-non-existent_0
new file mode 100755
index 0000000000000..bbf1af760837d
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0013-zero-non-existent_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+nft --version >/dev/null 2>&1 || { echo "skip nft"; exit 0; }
+
+set -e
+
+nft flush ruleset
+$XT_MULTI iptables -Z INPUT
+
+EXP="Zeroing chain \`INPUT'"
+diff -u <(echo "$EXP") <($XT_MULTI iptables -v -Z INPUT)
+
+EXP="Zeroing chain \`INPUT'
+Zeroing chain \`FORWARD'
+Zeroing chain \`OUTPUT'"
+diff -u <(echo "$EXP") <($XT_MULTI iptables -v -Z)
-- 
2.43.0

