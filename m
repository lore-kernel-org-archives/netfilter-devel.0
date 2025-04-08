Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531B62CCC0
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122138; cv=none; b=DlsRsCYCwafHxg7NQU3oPPkg9x3JlMsS5/38GJ5aYOMk6nriXfFavqMYY1pd7me0lNQo9uvUIC7W0Ks0G1P7F+EL1P72eQfK2d9WBS0nyeEny0LEGucBLNg8L/yitDIGfYwX3/W6nRhhN3PzKhi779qx0kAE+3GtR/yH2tRMTTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122138; c=relaxed/simple;
	bh=RmaVmagw8rgm55/zlJCtQ3C6XVHk4d13w3sKJEHe12Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRHTmFY+LonH+NwnkqahsCvpHmbmrSDLtZo9p9plSTsmypzhrxwonETDPxNnIuBO9Q1rFS1+colYKGdzVZwNw0lvZOFw/RMIoSTEB0On/b9ijPEKTUYA0NkI7vJdNuwM+QoVSMyRGt/DHiJ/VxBTYvjd7GIsYi/3nY4W8oaTPH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u29qB-0002xo-O9; Tue, 08 Apr 2025 16:22:15 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 2/4] debug: include kernel set information on cache fill
Date: Tue,  8 Apr 2025 16:21:30 +0200
Message-ID: <20250408142135.23000-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408142135.23000-1-fw@strlen.de>
References: <20250408142135.23000-1-fw@strlen.de>
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
index 64b1aaedb84c..22041bc994fb 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1385,9 +1385,15 @@ int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1400,6 +1406,8 @@ static int set_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_set_nlmsg_parse(nlh, s) < 0)
 		goto err_free;
 
+	netlink_dump_set(s, args->ctx);
+
 	nftnl_set_list_add_tail(s, nls_list);
 	return MNL_CB_OK;
 
@@ -1418,6 +1426,7 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 	struct nlmsghdr *nlh;
 	struct nftnl_set *s;
 	int ret;
+	struct set_cb_args args;
 
 	s = nftnl_set_alloc();
 	if (s == NULL)
@@ -1439,7 +1448,9 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 	if (nls_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_cb, nls_list);
+	args.list = nls_list;
+	args.ctx  = ctx;
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_cb, &args);
 	if (ret < 0 && errno != ENOENT)
 		goto err;
 
diff --git a/src/netlink.c b/src/netlink.c
index dfb7f4d17147..98ec3cdba996 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -847,10 +847,13 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
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
2.49.0

