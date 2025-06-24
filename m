Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB228BA82;
	Tue, 24 Jun 2025 11:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750763578; cv=none; b=RE807flDNjB/k7hvb4ZIRadRNfpZfKLVjneuBfaABrs6djjRzV0gex6PSxXXLZnSN/XXE0+gfi1p4o/8FV3qevWCCfeFHM5V779VmA+HhjQNyaabs7LSO3oP8nRDDTLvsETsCjcM/SbaMbLEtYRtAfLXi9ICoS5z6rIyBKEWuTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750763578; c=relaxed/simple;
	bh=NLOceXgEehwlSCG8uHC0Rov0STX+fJgURz/oW/KmDJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sLobSe/oaREw0qBkIQob7XJ0WYmcA8zQEzvJUf6y84T87u3861ytsQhTVtt/XPF8rqnMPpm2KqeS1k48FOFCphPiSAjomzZj6kN/OkC54+RjXvcKGLqm7XSpgvejWw7DIO2iPlR9ePW8I8hq1jY0n77za6yxhc/1Btesx+CXp4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=DaVOITAe; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="DaVOITAe"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.22])
	by mail.ispras.ru (Postfix) with ESMTPSA id 3EA35552F54A;
	Tue, 24 Jun 2025 11:12:46 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 3EA35552F54A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1750763566;
	bh=p3GEJfSnRmCnWSjlWMr2fWp6ucvUqxeu9MWl9UlNFvQ=;
	h=From:To:Cc:Subject:Date:From;
	b=DaVOITAeXWJh3EJwKDOOnjQmnWgZNMOioFCKoWMipAUy/NLS3XnWTe3zQxSl4VKJ3
	 ErBy5HcLSN1Db7Ld/2USaR+Pnvc20vMVxMWpG1RdQG3E6po15oAgG8sBi7Cr4vkVGz
	 PbwyZOala4KODv/1RlYr0IugHhkAf57yXGhWS2d4=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH nf] netfilter: nf_tables: adjust lockdep assertions handling
Date: Tue, 24 Jun 2025 14:12:15 +0300
Message-ID: <20250624111216.107844-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's needed to check the return value of lockdep_commit_lock_is_held(),
otherwise there's no point in this assertion as it doesn't print any
debug information on itself.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24c71ecb2179..44b909755c86 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4039,7 +4039,7 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 /* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
@@ -5859,7 +5859,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
-- 
2.49.0

