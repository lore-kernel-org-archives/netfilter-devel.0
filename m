Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DEA37266E
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184284; cv=none; b=pD+kIj6HfI5ghqweP4O1GkNjcbJlwQPZ+WC0m+WPJTl4XVV7ufhytD27s1m+nBqD1ZYdaSxl+af5C1LdPvRbGuETSa5F/TIF6a7fs5HuHEDBRQdFPtSK1rw4QcsXvUR5q6Dqj95z4v3HNDLXiEhThy6q9tPQ8VE88266JnRatZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184284; c=relaxed/simple;
	bh=kL3c2cdZBgldDHGKLTi5Q+aWmzodyIXxTUzkOUgIm6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc5OW5Mf4t+HidO88MXMhZ6vWmB/AfLBUUGnvy9M7GTOVLE1FBm0P3EYTk3H2T3I9/O8LupeMf9+j/cEwCflCYGeFPE9Yr8EwtCCDF+WkgZYmWSawAG6j9bOu27/hb8rrChpIJT58gBw4XZA44+f5txwROH9a/3RtZlziphCokY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bvHAVDNV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bvHAVDNV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aOsEhwPqswINTp1jo3EkdD1Tt7SBqY2sYT0+XY/t9po=; b=bvHAVDNV6f4Tzd7b+sU/OmS0yT
	8BdURIKG/+XcaukHxZLZUpAVOVMzBOdKSu1n28iq7RWMGZXEpFJP9dsjr5kR4/5Geywmnk425vD+5
	e6nhLv4aI7/7yNaukb4DO8Dev9vFzjjThsltDQbShoVeCvroyOQZXanvOLMu/bfXM8k2VRwp1AtSM
	uaU0rsxFoOIYcJ0dCOkwSciu8VmYPSap0SGoP5qxMpnfF9rr/NzQfs/l06onxYF7/IVQWlHNaPsZj
	h6dRZ5TYGneRMcyoZDzoq3fUcUqRzzcU+5eRFBAXyZUfLqTz97n0kRSVgDAdVpO/Gg/QoQTOCEeCW
	g8l3CgKw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w06ET-000000004qd-1sjI;
	Wed, 11 Mar 2026 00:11:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/5] cache: Include chains, flowtables and objects in netlink debug output
Date: Wed, 11 Mar 2026 00:11:11 +0100
Message-ID: <20260310231115.25638-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310231115.25638-1-phil@nwl.cc>
References: <20260310231115.25638-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to test cache filter effectiveness, netlink debug output is
useful as it shows what is actually received from the kernel and maybe
discarded immediately by user space. Therefore add dump calls for these
rule set elements as well.

While at it, move the netlink_dump_rule() call to an earlier spot,
namely into the nft_mnl_talk() callback to match other netlink dump
calls.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c |  1 -
 src/mnl.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index bb005c10f9990..62eccef991933 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -698,7 +698,6 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 	    (h->chain.name && strcmp(chain, h->chain.name) != 0))
 		return 0;
 
-	netlink_dump_rule(nlr, ctx);
 	rule = netlink_delinearize_rule(ctx, nlr);
 	assert(rule);
 	list_add_tail(&rule->list, &ctx->list);
diff --git a/src/mnl.c b/src/mnl.c
index eb6cb12c6ae21..4893af8322ae6 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -653,9 +653,15 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
  * Rule
  */
 
+struct rule_cb_args {
+	struct netlink_ctx *ctx;
+	struct nftnl_rule_list *list;
+};
+
 static int rule_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nftnl_rule_list *nlr_list = data;
+	struct rule_cb_args *args = data;
+	struct nftnl_rule_list *nlr_list = args->list;
 	struct nftnl_rule *r;
 
 	if (check_genid(nlh) < 0)
@@ -668,6 +674,8 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_rule_nlmsg_parse(nlh, r) < 0)
 		goto err_free;
 
+	netlink_dump_rule(r, args->ctx);
+
 	nftnl_rule_list_add_tail(r, nlr_list);
 	return MNL_CB_OK;
 
@@ -685,6 +693,7 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_rule_list *nlr_list;
 	struct nftnl_rule *nlr = NULL;
+	struct rule_cb_args args;
 	struct nlmsghdr *nlh;
 	int msg_type, ret;
 
@@ -716,7 +725,9 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
 		nftnl_rule_free(nlr);
 	}
 
-	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
+	args.list = nlr_list;
+	args.ctx  = ctx;
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, rule_cb, &args);
 	if (ret < 0)
 		goto err;
 
@@ -1036,9 +1047,15 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+struct chain_cb_args {
+	struct netlink_ctx *ctx;
+	struct nftnl_chain_list *list;
+};
+
 static int chain_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nftnl_chain_list *nlc_list = data;
+	struct chain_cb_args *args = data;
+	struct nftnl_chain_list *nlc_list = args->list;
 	struct nftnl_chain *c;
 
 	if (check_genid(nlh) < 0)
@@ -1051,6 +1068,8 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_chain_nlmsg_parse(nlh, c) < 0)
 		goto err_free;
 
+	netlink_dump_chain(c, args->ctx);
+
 	nftnl_chain_list_add_tail(c, nlc_list);
 	return MNL_CB_OK;
 
@@ -1066,6 +1085,7 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_chain_list *nlc_list;
 	struct nftnl_chain *nlc = NULL;
+	struct chain_cb_args args;
 	struct nlmsghdr *nlh;
 	int ret;
 
@@ -1089,7 +1109,9 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
 		nftnl_chain_free(nlc);
 	}
 
-	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
+	args.list = nlc_list;
+	args.ctx  = ctx;
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, chain_cb, &args);
 	if (ret < 0 && errno != ENOENT)
 		goto err;
 
@@ -1797,9 +1819,15 @@ int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type)
 	return 0;
 }
 
+struct obj_cb_args {
+	struct netlink_ctx *ctx;
+	struct nftnl_obj_list *list;
+};
+
 static int obj_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nftnl_obj_list *nln_list = data;
+	struct obj_cb_args *args = data;
+	struct nftnl_obj_list *nln_list = args->list;
 	struct nftnl_obj *n;
 
 	if (check_genid(nlh) < 0)
@@ -1812,6 +1840,8 @@ static int obj_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_obj_nlmsg_parse(nlh, n) < 0)
 		goto err_free;
 
+	netlink_dump_obj(n, args->ctx);
+
 	nftnl_obj_list_add_tail(n, nln_list);
 	return MNL_CB_OK;
 
@@ -1829,6 +1859,7 @@ mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 	uint16_t nl_flags = dump ? NLM_F_DUMP : NLM_F_ACK;
 	struct nftnl_obj_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct obj_cb_args args;
 	struct nlmsghdr *nlh;
 	struct nftnl_obj *n;
 	int msg_type, ret;
@@ -1857,7 +1888,9 @@ mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 	if (nln_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, obj_cb, nln_list);
+	args.list = nln_list;
+	args.ctx  = ctx;
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, obj_cb, &args);
 	if (ret < 0)
 		goto err;
 
@@ -2192,9 +2225,15 @@ int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls,
 	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
 
+struct flowtable_cb_args {
+	struct netlink_ctx *ctx;
+	struct nftnl_flowtable_list *list;
+};
+
 static int flowtable_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nftnl_flowtable_list *nln_list = data;
+	struct flowtable_cb_args *args = data;
+	struct nftnl_flowtable_list *nln_list = args->list;
 	struct nftnl_flowtable *n;
 
 	if (check_genid(nlh) < 0)
@@ -2207,6 +2246,8 @@ static int flowtable_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_flowtable_nlmsg_parse(nlh, n) < 0)
 		goto err_free;
 
+	netlink_dump_flowtable(n, args->ctx);
+
 	nftnl_flowtable_list_add_tail(n, nln_list);
 	return MNL_CB_OK;
 
@@ -2221,6 +2262,7 @@ mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family,
 {
 	struct nftnl_flowtable_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct flowtable_cb_args args;
 	struct nftnl_flowtable *n;
 	int flags = NLM_F_DUMP;
 	struct nlmsghdr *nlh;
@@ -2245,7 +2287,9 @@ mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family,
 	if (nln_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, flowtable_cb, nln_list);
+	args.list = nln_list;
+	args.ctx  = ctx;
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, flowtable_cb, &args);
 	if (ret < 0 && errno != ENOENT)
 		goto err;
 
-- 
2.51.0

