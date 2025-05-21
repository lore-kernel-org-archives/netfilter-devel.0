Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75D526C387
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833179; cv=none; b=f7+UlZ0G4UFOIFTXBi4/aBixz6YpaXG84Y/YElRD+ph9s7gxah8Sc/czNTCwqvc6xe/VQGGL8bILXVzVWYp/ohg97xWn/uhd5umPogRQ2iEGdoZtKesr0qDMdT2gdM6XGeWZOFdwUc2JuMcurrFX9vgcpRY/BvSXCKo7ssbrWbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833179; c=relaxed/simple;
	bh=raz/s2S+CIkUECLNzL8RWleQxsJw+AlHEqrs5QuOSJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXnzY9kA1P500RdmyN2RHi6hCnkV6vwezwd34upozI1MaAGDsVheNNmIll4PWnGJYvsMH1yOz3k5PGp8z232i72XDfBIKEkHdAKp7rtNKn8Rx+8y+2sxfxjkLGp+0fUCn31ewvieSogwjl6gabYmAnmbwKF1x6ETbYWZqpiW9es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h4ObZWn0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h4ObZWn0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KLlL47uLbVdg6bDjPLEmafJxrCwya3p8Q0rEDutLJR8=; b=h4ObZWn0KYB5IXq/D8liX1SQHk
	lIScNj9LK/V1c+iJHc9Gyy6Re52qotYZ1przgKDpFzX4Wvopr/XRTwMcujKaTk1Gm1FGDBi0Q1AT/
	8Ru2o23UWt0UIDJj7sGt9Tw3MrGYRStyxFzAS6PyPt1mpdFsYze3h1XZHHDP1JxUgIrVOymsjP2R2
	VcA4ctmuXTzZA4RoEEFNqNbS4baW8qEkKXp2xKKGjgMLa03B6CEfjWGE+9BwJCwkt204TYtB0kUDj
	71MZA7NcIRs54sOfxKoxWrC5jJBP7ncN81Rm2R7NMkFWcwLoxmVLk1EghRGnGKe/fwiO63CoCy5uT
	hqynDxxw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHjFX-0000000083Q-1pGN;
	Wed, 21 May 2025 15:12:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/4] netlink: Pass netlink_ctx to netlink_delinearize_setelem()
Date: Wed, 21 May 2025 15:12:40 +0200
Message-ID: <20250521131242.2330-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521131242.2330-1-phil@nwl.cc>
References: <20250521131242.2330-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare for calling netlink_io_error() which needs the context pointer.
Trade this in for the cache pointer since no caller uses a special one.
No functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/netlink.h |  6 +++---
 src/monitor.c     |  7 +++----
 src/netlink.c     | 11 ++++++-----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index e9667a24b0d11..c7da6f9e3bcbb 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -172,9 +172,9 @@ extern int netlink_list_setelems(struct netlink_ctx *ctx,
 extern int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc, struct set *cache_set,
 			       struct set *set, struct expr *init, bool reset);
-extern int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
-				       struct set *set,
-				       struct nft_cache *cache);
+extern int netlink_delinearize_setelem(struct netlink_ctx *ctx,
+				       struct nftnl_set_elem *nlse,
+				       struct set *set);
 
 extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h);
 extern struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
diff --git a/src/monitor.c b/src/monitor.c
index 0db40895babf9..7556dfd350e4e 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -472,8 +472,8 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 			nftnl_set_elems_iter_destroy(nlsei);
 			goto out;
 		}
-		if (netlink_delinearize_setelem(nlse, dummyset,
-						&monh->ctx->nft->cache) < 0) {
+		if (netlink_delinearize_setelem(monh->ctx,
+						nlse, dummyset) < 0) {
 			set_free(dummyset);
 			nftnl_set_elems_iter_destroy(nlsei);
 			goto out;
@@ -829,8 +829,7 @@ static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
 
 	nlse = nftnl_set_elems_iter_next(nlsei);
 	while (nlse != NULL) {
-		if (netlink_delinearize_setelem(nlse, set,
-						&monh->ctx->nft->cache) < 0) {
+		if (netlink_delinearize_setelem(monh->ctx, nlse, set) < 0) {
 			fprintf(stderr,
 				"W: Unable to cache set_elem. "
 				"Delinearize failed.\n");
diff --git a/src/netlink.c b/src/netlink.c
index fe02120def035..1222919458bae 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1435,12 +1435,13 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 	}
 }
 
-int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
-				struct set *set, struct nft_cache *cache)
+int netlink_delinearize_setelem(struct netlink_ctx *ctx,
+				struct nftnl_set_elem *nlse,
+				struct set *set)
 {
 	struct setelem_parse_ctx setelem_parse_ctx = {
 		.set	= set,
-		.cache	= cache,
+		.cache	= &ctx->nft->cache,
 	};
 	struct nft_data_delinearize nld;
 	struct expr *expr, *key, *data;
@@ -1498,7 +1499,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		struct stmt *stmt;
 
 		nle = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_EXPR, NULL);
-		stmt = netlink_parse_set_expr(set, cache, nle);
+		stmt = netlink_parse_set_expr(set, &ctx->nft->cache, nle);
 		list_add_tail(&stmt->list, &setelem_parse_ctx.stmt_list);
 	} else if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPRESSIONS)) {
 		nftnl_set_elem_expr_foreach(nlse, set_elem_parse_expressions,
@@ -1575,7 +1576,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 static int list_setelem_cb(struct nftnl_set_elem *nlse, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
-	return netlink_delinearize_setelem(nlse, ctx->set, &ctx->nft->cache);
+	return netlink_delinearize_setelem(ctx, nlse, ctx->set);
 }
 
 static int list_setelem_debug_cb(struct nftnl_set_elem *nlse, void *arg)
-- 
2.49.0

