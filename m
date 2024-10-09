Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DBB1922E9
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474509; cv=none; b=LQWF4EUCRzaFZqn2uf11WGmc/nCOwBGA5nFvJUNCzNPdxgvTKLnFq1OJSF+bfiajuS89zAfsqx5shRasmBM4+NGLynNg9WLFiD0DxuupYS2jJyKNcr/OyOhRe5HqZh1E14EuI3+d8ZeoADYPBfXHSxvtwjhYw4KH+ie4n95hdMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474509; c=relaxed/simple;
	bh=YolBThyQ+FSYKLdz0vNa22LmtTpDy9SNzRLsRekIQ9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeXcQc1yJKp/cjEnJuGPOa5Zocep91JFqAkJt54nlzVH87WrMmv0KNsl+ozsx5ZIq470nruaEtB86aANynRv4yZZVV41nBOYnSK7/ioAPVqEHAr3HL08tZW2MUWCwIhWw3o9Vm96+mYON5sVey74Y6NjcNM/8c8C5oMKBhz3rAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DazYMXsG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DazYMXsG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f+2CLcBgc8kGxgXJL7x3TCFdZpufe9+gE/yGPCtqD3I=; b=DazYMXsGtv45dQ6e1ihkEpuGFC
	eAK8JBdXGsUcsgIyLHa6QzRjhDqqOgTQaxAJ8k1p5UoZELxo3WJvqH89wiCD3/1bqjlsc6NJHLeGJ
	GJLueKUT/SsOCgObh/TZEaMBxEGQChEswD8FmijBa5TiLFtzzNrHmu+vrDhC9cL496LQmkQXoK1LH
	RvQdnkHCMZ7WvnDddk5A6qMOxvHxdKDTOrI/idkl//8xGWRxZ8DYE3cm18F4G7W+AL24dVd+Ds6+B
	Q7j3tGvM5OI5bDk1xFTf9FZlPiW9AflJWx6gSI4Ks19hCPDCIEMDA9IKH1RQ5OGKyht7UClVrdNIE
	joG9TcTQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB3-000000008Hb-3VMr;
	Wed, 09 Oct 2024 13:48:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 3/8] nft: __add_{match,target}() can't fail
Date: Wed,  9 Oct 2024 13:48:14 +0200
Message-ID: <20241009114819.15379-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009114819.15379-1-phil@nwl.cc>
References: <20241009114819.15379-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These functions either call xtables_error() which terminates the process
or succeed - make them return void. While at it, export them as rule
parsing code will call them in future. Also make input parameter const,
they're not supposed to alter extension data.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 28 ++++++++++------------------
 iptables/nft.h |  2 ++
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2ed21bb14c253..e629f995b7709 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1034,7 +1034,7 @@ int nft_chain_set(struct nft_handle *h, const char *table,
 	return 1;
 }
 
-static int __add_match(struct nftnl_expr *e, struct xt_entry_match *m)
+void __add_match(struct nftnl_expr *e, const struct xt_entry_match *m)
 {
 	void *info;
 
@@ -1044,8 +1044,6 @@ static int __add_match(struct nftnl_expr *e, struct xt_entry_match *m)
 	info = xtables_calloc(1, m->u.match_size);
 	memcpy(info, m->data, m->u.match_size - sizeof(*m));
 	nftnl_expr_set(e, NFTNL_EXPR_MT_INFO, info, m->u.match_size - sizeof(*m));
-
-	return 0;
 }
 
 static int add_nft_limit(struct nftnl_rule *r, struct xt_entry_match *m)
@@ -1378,11 +1376,10 @@ static int add_nft_udp(struct nft_handle *h, struct nftnl_rule *r,
 	if (udp->invflags > XT_UDP_INV_MASK ||
 	    udp_all_zero(udp)) {
 		struct nftnl_expr *expr = nftnl_expr_alloc("match");
-		int ret;
 
-		ret = __add_match(expr, m);
+		__add_match(expr, m);
 		nftnl_rule_add_expr(r, expr);
-		return ret;
+		return 0;
 	}
 
 	if (nftnl_rule_get_u32(r, NFTNL_RULE_COMPAT_PROTO) != IPPROTO_UDP)
@@ -1431,11 +1428,10 @@ static int add_nft_tcp(struct nft_handle *h, struct nftnl_rule *r,
 	if (tcp->invflags & ~supported || tcp->option ||
 	    tcp_all_zero(tcp)) {
 		struct nftnl_expr *expr = nftnl_expr_alloc("match");
-		int ret;
 
-		ret = __add_match(expr, m);
+		__add_match(expr, m);
 		nftnl_rule_add_expr(r, expr);
-		return ret;
+		return 0;
 	}
 
 	if (nftnl_rule_get_u32(r, NFTNL_RULE_COMPAT_PROTO) != IPPROTO_TCP)
@@ -1478,7 +1474,6 @@ int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
 	struct nftnl_expr *expr;
-	int ret;
 
 	switch (ctx->command) {
 	case NFT_COMPAT_RULE_APPEND:
@@ -1503,13 +1498,13 @@ int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (expr == NULL)
 		return -ENOMEM;
 
-	ret = __add_match(expr, m);
+	__add_match(expr, m);
 	nftnl_rule_add_expr(r, expr);
 
-	return ret;
+	return 0;
 }
 
-static int __add_target(struct nftnl_expr *e, struct xt_entry_target *t)
+void __add_target(struct nftnl_expr *e, const struct xt_entry_target *t)
 {
 	void *info;
 
@@ -1520,8 +1515,6 @@ static int __add_target(struct nftnl_expr *e, struct xt_entry_target *t)
 	info = xtables_calloc(1, t->u.target_size);
 	memcpy(info, t->data, t->u.target_size - sizeof(*t));
 	nftnl_expr_set(e, NFTNL_EXPR_TG_INFO, info, t->u.target_size - sizeof(*t));
-
-	return 0;
 }
 
 static int add_meta_nftrace(struct nftnl_rule *r)
@@ -1549,7 +1542,6 @@ static int add_meta_nftrace(struct nftnl_rule *r)
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t)
 {
 	struct nftnl_expr *expr;
-	int ret;
 
 	if (strcmp(t->u.user.name, "TRACE") == 0)
 		return add_meta_nftrace(r);
@@ -1558,10 +1550,10 @@ int add_target(struct nftnl_rule *r, struct xt_entry_target *t)
 	if (expr == NULL)
 		return -ENOMEM;
 
-	ret = __add_target(expr, t);
+	__add_target(expr, t);
 	nftnl_rule_add_expr(r, expr);
 
-	return ret;
+	return 0;
 }
 
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict)
diff --git a/iptables/nft.h b/iptables/nft.h
index 09b4341f92f8e..49653ecea7330 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -192,8 +192,10 @@ bool nft_rule_is_policy_rule(struct nftnl_rule *r);
  */
 int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes);
 int add_verdict(struct nftnl_rule *r, int verdict);
+void __add_match(struct nftnl_expr *e, const struct xt_entry_match *m);
 int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	      struct nftnl_rule *r, struct xt_entry_match *m);
+void __add_target(struct nftnl_expr *e, const struct xt_entry_target *t);
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
-- 
2.43.0

