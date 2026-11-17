Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.252
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794905816;
	b=RHPvAjL1aSav2LOCDRNDEC06fBAEfzwHz3zUOXQN2Tej6blkd0EmqEGinXzX0zklr0yX
	 nTnocMG6q1laxuxDJRlIFwxEzUQAyA+QEC3oOIAnTgteSBAr8A7/xEIFj8UmoHreB49kg
	 +lXmFTn73aC/9dgfcH6sQwmtyuD1lg2fxa5x0o0GxX2KUrFguU39MZHXP3YFGUZzPGeiS
	 /lSsY+EMGu4o0TA/LkTCm0bSi2LI2Ha7qwUKa7MX8Eb+8TxWwR90qGLlwkoBv6FsrjzlA
	 C5ht2DxEHVwIXrwXRPwcikqqY0H0Ryfe1c6/ptHMIprwPQpotnIg9h1RPToCOzsYLng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905816;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=pcfBs8WoN7/q9bbgEnCRQbl/I6Zh/jFSmI3HMkPPCd4=;
	b=MMJ3nCqKxtfPn9cmgVZ2WBJo+bd0yxbMcrRp7IP0YpOxmUFNVYhs06+nGUxmL9ah6xEh
	 FJE+TjZ+FAUwVA26OFpTdXDr7JEexUvaO2CdNR6qHbFK/If51c7yO4s+lHLR1pS+pNQ06
	 kKLNfSmjWSeLqrIqJi2exlQikYVHAOg3jgOYPVZUu78rGHPCcRZsdB3gxJxC6dmNrift+
	 kT9PatTWLN2iNeWrrotV3jDAlJCa4EG8S9XbNH/i6279/A9cQpF1zNSJOWciEi6p+8pgk
	 Op5ZuAIxitv/U0ETvwZFdnr4GHoJHbfKP1hSOpe29OD8XXGEu36PTW8WUd2CfMO6NSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=qBh4UeCf;
	arc=none smtp.remote-ip=162.62.57.252
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785EB606A31C;
	Tue, 17 Nov 2026 08:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 785EB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=qBh4UeCf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794905810; bh=pcfBs8WoN7/q9bbgEnCRQbl/I6Zh/jFSmI3HMkPPCd4=;
	h=From:To:Cc:Subject:Date;
	b=qBh4UeCfRGNmULKLi37uyJzgUF3bgfyLf1wMavNxNH2u5/8H5SRfkr2xnP98rmTCG
	 4YFFuNjc9u2qyaxwx31FhUqk4XGIDH3goqd+zUrrLF0PckggVN2w244J4Z/eyShhfp
	 N+x73l3GjHhI8mfgNispCDi4L7BNWM+HpiAZE9iw=
Received: from localhost.localdomain ([182.239.117.117])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id E2EB2C0E; Tue, 17 Nov 2026 16:56:46 +0800
X-QQ-mid: xmsmtpt1794905806tpl1au0xj
Message-ID: <tencent_19A48DA487BBFCFD990AC5A8010C663EA007@qq.com>
X-QQ-XMAILINFO: OATpkVjS499u53pa9/MNGWk1BkZ8N4WdYcoDK7jSSNCrDUNyf7oMft53Db4Oh8
	 NeQx/igDUjDQh8/Co/2YijQ6ZNyysj/v/3Ei0TN/UWfx8qjkQB04/lbpE9lUxE2N77KcUDvBh+Qy
	 vTC5rUskIXkexnsqs5GVXKkEIqXcGNP2hBNEL/VwDnK4OWH6nFnJ+pMaPQR+g5LJGh/FGIcsBeX8
	 qW7ZNEuJbGmMT8saVvwOMWbqGr5wYYbWNeir9rr3yTp6RlfG02kFHH/bei8qwZX1/YObtJOZcDyU
	 Mr0MC3wDHc81H5Ei736OdAV8pagEcTvKVIx3x4z+rJCgBOeJowWwOkM8i29tk4aiEUfRBsFwCvl7
	 F5eUFVCWQte3Jt+A1ip1u7K19Oe9FP0NvfazUVznOixwDff1dsfeyv5CQ9I4IYv2uNTH7xVq6Q61
	 ULAMCG3zDpHaXTKx9GHoYkRYJqpqpLm62CcieQxMVTeY0eQxEEewaNuUf+gm/V0nGlipYKAY7+PH
	 LT+EOpzN8OR08hcEzzM8jWhNvTc6odgrEY3gl8duIXX52abfSJTEntHF4ScDbCYlWY1OoabWfYvA
	 5jIJkNUfixzIw707aj3BrCxvTP+fak4CtWkwWNjkEtsYaLZrUgBjx67VEjoMjj/J8dJXpRn+O83U
	 XRhIC5ONdivL265VnHdV9PdooEdx7vrxjcE2ZArnHjNBbcanStsqxctlqqYqCuQkeCgxC6ABVplS
	 PyOyF3XAUD26SSAODQtFhAos79FEUvxvdTuc9z10VQjQM19pE2YLh6LpWDvu+GT7xtnrmB9+DTg4
	 CUt6nHwpknWUL5t562R/zp/o0em2m9gO5mTixfjiA5VDdLrXtWFFlNT8tkwyEhrfWFyJKWn1AJmD
	 g5QOW7HEKkPC9iabg47tpBYU4jCGtrETwjegxZ11Ftluk9WD5lBCfHS3d251AXKp6CHRhGuwGe1r
	 95GgFrDwj943i9eUk6xrK9hg6XMpwyaEyokI/Ioci89U5rwxEjcM1xxyAfvgmurT/r9IxnDfOV7p
	 fOKjf9Oh/QPA7OL8YIGR1VyBWUuopXCE2fKZ0LkXNfTS1To40/4b7TY052FxoIHpxo0Iz7XQ==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH net] netfilter: nf_tables: don't unregister hooks that were never registered
Date: Tue, 17 Nov 2026 16:54:27 +0800
X-OQ-MSGID: <20261117085615.1701-1-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A basechain created while its table is dormant is accepted without
registering its hook. Re-owning a PERSIST orphan table with DORMANT set
then makes nf_tables_table_disable() clear DORMANT before
nft_table_disable() walks the chains, so __nf_tables_unregister_hook()
no longer sees the dormant state and calls nf_unregister_net_hook() for a
hook that was never registered. This triggers WARN_ONCE("hook not found")
in __nf_unregister_net_hook().

Track whether a basechain's hook was actually registered and skip the
unregister for chains whose hook was never registered. This preserves the
existing "add a basechain to a dormant table" API.

Signed-off-by: Ma Xinmeng <1564938642@qq.com>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d5974823..fcd24502b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1243,6 +1243,7 @@ struct nft_base_chain {
 	const struct nft_chain_type	*type;
 	u8				policy;
 	u8				flags;
+	bool				registered;
 	struct nft_stats __percpu	*stats;
 	struct nft_chain		chain;
 	struct flow_block		flow_block;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8b94b5e7d..25b4075c9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -428,21 +428,30 @@ static int nf_tables_register_hook(struct net *net,
 {
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
+	int err;
 
 	if (table->flags & NFT_TABLE_F_DORMANT ||
 	    !nft_is_base_chain(chain))
 		return 0;
 
 	basechain = nft_base_chain(chain);
+	if (basechain->registered)
+		return 0;
+
 	ops = &basechain->ops;
 
 	if (basechain->type->ops_register)
-		return basechain->type->ops_register(net, ops);
+		err = basechain->type->ops_register(net, ops);
+	else if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
+		err = nft_netdev_register_hooks(net, &basechain->hook_list);
+	else
+		err = nf_register_net_hook(net, &basechain->ops);
 
-	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
-		return nft_netdev_register_hooks(net, &basechain->hook_list);
+	if (err < 0)
+		return err;
 
-	return nf_register_net_hook(net, &basechain->ops);
+	basechain->registered = true;
+	return 0;
 }
 
 static void __nf_tables_unregister_hook(struct net *net,
@@ -456,22 +465,30 @@ static void __nf_tables_unregister_hook(struct net *net,
 	if (!nft_is_base_chain(chain))
 		return;
 	basechain = nft_base_chain(chain);
+	if (!basechain->registered)
+		return;
+
 	ops = &basechain->ops;
 
 	/* must also be called for dormant tables */
 	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 		nft_netdev_unregister_hooks(net, table, &basechain->hook_list,
 					    release_netdev);
+		basechain->registered = false;
 		return;
 	}
 
 	if (table->flags & NFT_TABLE_F_DORMANT)
 		return;
 
-	if (basechain->type->ops_unregister)
-		return basechain->type->ops_unregister(net, ops);
+	if (basechain->type->ops_unregister) {
+		basechain->type->ops_unregister(net, ops);
+		basechain->registered = false;
+		return;
+	}
 
 	nf_unregister_net_hook(net, &basechain->ops);
+	basechain->registered = false;
 }
 
 static void nf_tables_unregister_hook(struct net *net,
-- 
2.56.0.windows.4.niugit

