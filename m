Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE4F19DFA2
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732101997; cv=none; b=OMvPNnym0g03bTsRACP2EQxksDSAcTaRYlyoqawip+U0dVEouJ4hygtzuNM46pZv1SPO4QwNtMKow2ZzmzINNpyKIzd5KcEu2XnHsalbadnCsWNXnH5NZIH874RURqCSal4mqHbYxth9YkBogBsESq5NrxRnOlgbyHhnwWha0Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732101997; c=relaxed/simple;
	bh=L9Or3Y3PjqYNqxMZlGm6p/nYsm89BXPYb9sFk8WU/i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCds9qVdgQrxSW4TaJwPeyvPuu+CND3chaeDAeckNzJ0AqJaL0l78389PMadKbvWaFLoX5s1nnO1Pessq+q28D3ZGfvho16a53vJC4RtBYprIYARVEezPfrMUijmS/oDgmFOKEC928K+MXkw7l4mC3NDm71RAbMWfYoJediBCJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tDiqv-0004co-SK; Wed, 20 Nov 2024 12:26:33 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] debug: include kernel set information on cache fill
Date: Wed, 20 Nov 2024 11:02:16 +0100
Message-ID: <20241120100221.11001-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241120100221.11001-1-fw@strlen.de>
References: <20241120100221.11001-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Honor --debug=netlink flag also when doing initial set dump
from the kernel.

With recent libnftnl update this will include the chosen
set backend name that is used by the kernel.

Because set names are scoped by table and protocol family,
also include the family protocol number.

Dumping this information breaks tests/py as the recorded
debug output no longer matches, this is fixed in previous
change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c     | 15 +++++++++++++--
 src/netlink.c |  3 +++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 828006c4d6bf..24a7487a5b5b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1386,9 +1386,15 @@ int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+struct set_cb_args {
+	struct netlink_ctx *ctx;
+	struct nftnl_set_list *list;
+};
+
 static int set_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nftnl_set_list *nls_list = data;
+	struct set_cb_args *args = data;
+	struct nftnl_set_list *nls_list = args->list;
 	struct nftnl_set *s;
 
 	if (check_genid(nlh) < 0)
@@ -1401,6 +1407,8 @@ static int set_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_set_nlmsg_parse(nlh, s) < 0)
 		goto err_free;
 
+	netlink_dump_set(s, args->ctx);
+
 	nftnl_set_list_add_tail(s, nls_list);
 	return MNL_CB_OK;
 
@@ -1419,6 +1427,7 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 	struct nlmsghdr *nlh;
 	struct nftnl_set *s;
 	int ret;
+	struct set_cb_args args;
 
 	s = nftnl_set_alloc();
 	if (s == NULL)
@@ -1440,7 +1449,9 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 	if (nls_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_cb, nls_list);
+	args.list = nls_list;
+	args.ctx  = ctx;
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_cb, &args);
 	if (ret < 0 && errno != ENOENT)
 		goto err;
 
diff --git a/src/netlink.c b/src/netlink.c
index 36140fb63d6f..f3a5fa2e4309 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -832,10 +832,13 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 void netlink_dump_set(const struct nftnl_set *nls, struct netlink_ctx *ctx)
 {
 	FILE *fp = ctx->nft->output.output_fp;
+	uint32_t family;
 
 	if (!(ctx->nft->debug_mask & NFT_DEBUG_NETLINK) || !fp)
 		return;
 
+	family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
+	fprintf(fp, "family %d ", family);
 	nftnl_set_fprintf(fp, nls, 0, 0);
 	fprintf(fp, "\n");
 }
-- 
2.47.0

