Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49D9321454
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477525; cv=none; b=mFHZzQBkQ1XCTwiH6rZ0uYrKHYgXoyfHruJAMAS376zLD3M2aS09PSpZ9Nzg58hD3fhrYebqCCnonX109mH4kGmI6/xHIXLSW8E/FXoH5v+XddE0LCHw8dilUkQf36COE4XK6unfktmbEf4G9qyGMgdfhFQ+HkFmu1sZ5TJiSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477525; c=relaxed/simple;
	bh=Gp5pHEV/WhYAztBPGg3h3GsA8U7BPqoOLra8SkcbVGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VItDXykY1XYr2O7g9Uu05Ljje6OTLj0EbZXfC2sdlTmnUHuncztQBq82nM1GJt8wCKl7sy0/0E3KX3NOfIjlBLW17+FrimJRS4r7YRoHP2PsFIgHSC9JukWjDD5O2bmNa1grMotnitPCPBfLHkNWE1i8DM3Jkd/qvg8iep9RDZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=d0IM0EMq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="d0IM0EMq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9I/8DMv0OsGwmuVTFyBEciSy6rbvY6VMofAoxtP5wVQ=; b=d0IM0EMqoOpOUWSnO90+d0VDNP
	xOo1nVEkwObwPq2iuMcAGDObMN1d/gZa3mbL5/Dz11iMB3i5H7nhBHSzoeqzPcHlvwPup7aD6Sr+A
	UD9/pF51HVepJf3vKocf+m92uuOQ1mRXtFzYMScuGJELyACCpwELLwsW204bzSFg+p7B4jgmQdLje
	ceX38VjkKYsD9OhpiOY0oGG6gjRvQCoUkbfa97Ddt1HblW9WvgJj6O/vKQfv59Ds/q/r6Lgw+uK/c
	UcrKzJ7EgZ9/9kiVyRTP5pLvpzTE67mWp6Iw5e4jfXsoNVPsXHZAlVld0yLyhhq9Lt//rOsns5J3M
	SzZWIq+A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us02b-0000000073E-3sNS;
	Fri, 29 Aug 2025 16:25:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/5] mnl: Allow for updating devices on existing inet ingress hook chains
Date: Fri, 29 Aug 2025 16:25:11 +0200
Message-ID: <20250829142513.4608-4-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829142513.4608-1-phil@nwl.cc>
References: <20250829142513.4608-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complete commit a66b5ad9540dd ("src: allow for updating devices on
existing netdev chain") in supporting inet family ingress hook chains as
well. The kernel does already but nft has to add a proper hooknum
attribute to pass the checks.

The hook.num field has to be initialized from hook.name using
str2hooknum(), which is part of chain evaluation. Calling
chain_evaluate() just for that purpose is a bit over the top, but the
hook name lookup may fail and performing chain evaluation for delete
command as well fits more into the code layout than duplicating parts of
it in mnl_nft_chain_del() or elsewhere. Just avoid the
chain_cache_find() call as its assert() triggers when deleting by
handle and also don't add to be deleted chains to cache.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 6 ++++--
 src/mnl.c      | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b7e4f71fdfbc9..db4ac18f1dc9f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5758,7 +5758,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		return table_not_found(ctx);
 
 	if (chain == NULL) {
-		if (!chain_cache_find(table, ctx->cmd->handle.chain.name)) {
+		if (ctx->cmd->op != CMD_DELETE &&
+		    ctx->cmd->op != CMD_DESTROY &&
+		    !chain_cache_find(table, ctx->cmd->handle.chain.name)) {
 			chain = chain_alloc();
 			handle_merge(&chain->handle, &ctx->cmd->handle);
 			chain_cache_add(chain, table);
@@ -6070,7 +6072,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_OBJ_CHAIN:
 		chain_del_cache(ctx, cmd);
-		return 0;
+		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
 		table_del_cache(ctx, cmd);
 		return 0;
diff --git a/src/mnl.c b/src/mnl.c
index 984dcac27b1cf..d1402c0fcb9f4 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -994,6 +994,8 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 		struct nlattr *nest;
 
 		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
+		mnl_attr_put_u32(nlh, NFTA_HOOK_HOOKNUM,
+				 htonl(cmd->chain->hook.num));
 		mnl_nft_chain_devs_build(nlh, cmd);
 		mnl_attr_nest_end(nlh, nest);
 	}
-- 
2.51.0

