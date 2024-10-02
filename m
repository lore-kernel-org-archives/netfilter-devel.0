Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696B82629C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897940; cv=none; b=EgyO4ActmLsqgDlamPV4FOnrRGml1TpA1f8K8GorypPAIzywEVLoNFs5Sh2TmBqfVmpE6dzDy1y7H1xZiMpgsCZHzeJg2JZ3V1vxEahhxQdxX5m2boFym28EOVwBN1x4MhkFJDKRjgyTWNKKruQP3F2FSs6k5Dd5lVzARBrLd20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897940; c=relaxed/simple;
	bh=bDN6NM9WjaJLg30aAx9vrYHnOlQIaOxKt0yYgRuvoxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/WriM5MGDrX1JluRGkrlvMrTHDgQZyBU7ev/5paFRRYKPtxb8xHfWw71pQUjNEkP8YpCkyRXHeqFJXUjObgWLu3QQpsvk4IEEUe1hwrsobf184mRwQbiMmX7+uNP/KPVS8shRZtpk78cVM6nPXPYpD5K8cfharedbuAAj7qfi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IsASnZ5I; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IsASnZ5I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rqdJ+5AjaRgRQCiv2ht7uxoNDmXaEAo3De9wmIz0OsI=; b=IsASnZ5Ix7zbjtQ+A7k0bPwvGY
	cRTQYCvFNz9eNn9ygY6WDEphXpo923L02RlX+UAZXasg9iLKUlG+gKnWBCgpEyhhjesMtgLjopQYc
	GDDvwhVvRr+HSJp8kujIw8lMWbgs8ocYcNZzRnQVEoAeJ1twgKBNzH+RVAuW+HeT2G8dqgCtPFuR4
	aquRyDUub/VTOPR64n2P64d5udFm/b0d4LdTwDP4iHwSifLfxHtG1nYASIP/kvwd+onLG2EPFabU6
	hatbApOGU8UEARRynf6nUAHwiIDjews+R0iDCynSuDdBzvI1t95p0Phv4xudcMF3n+QtvxGw0JEGw
	NKrpVCfg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5BY-0000000030N-3Blk;
	Wed, 02 Oct 2024 21:38:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/9] monitor: Recognize flowtable add/del events
Date: Wed,  2 Oct 2024 21:38:47 +0200
Message-ID: <20241002193853.13818-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These were entirely ignored before, add the necessary code analogous to
e.g. objects.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/json.h                             | 10 ++++
 include/netlink.h                          |  1 +
 include/rule.h                             |  1 +
 src/json.c                                 |  6 +++
 src/monitor.c                              | 61 ++++++++++++++++++++++
 src/parser_json.c                          |  6 +++
 src/rule.c                                 | 15 ++++++
 tests/monitor/testcases/flowtable-simple.t | 10 ++++
 8 files changed, 110 insertions(+)
 create mode 100644 tests/monitor/testcases/flowtable-simple.t

diff --git a/include/json.h b/include/json.h
index 39be8928e8ee0..0670b8714519b 100644
--- a/include/json.h
+++ b/include/json.h
@@ -11,6 +11,7 @@ struct nlmsghdr;
 struct rule;
 struct set;
 struct obj;
+struct flowtable;
 struct stmt;
 struct symbol_table;
 struct table;
@@ -113,6 +114,8 @@ void monitor_print_element_json(struct netlink_mon_handler *monh,
 				const char *cmd, struct set *s);
 void monitor_print_obj_json(struct netlink_mon_handler *monh,
 			    const char *cmd, struct obj *o);
+void monitor_print_flowtable_json(struct netlink_mon_handler *monh,
+				  const char *cmd, struct flowtable *ft);
 void monitor_print_rule_json(struct netlink_mon_handler *monh,
 			     const char *cmd, struct rule *r);
 
@@ -254,6 +257,13 @@ static inline void monitor_print_obj_json(struct netlink_mon_handler *monh,
 	/* empty */
 }
 
+static inline void
+monitor_print_flowtable_json(struct netlink_mon_handler *monh,
+			     const char *cmd, struct flowtable *ft)
+{
+	/* empty */
+}
+
 static inline void monitor_print_rule_json(struct netlink_mon_handler *monh,
 					   const char *cmd, struct rule *r)
 {
diff --git a/include/netlink.h b/include/netlink.h
index cf7ba3693885a..e9667a24b0d11 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -97,6 +97,7 @@ extern struct nftnl_table *netlink_table_alloc(const struct nlmsghdr *nlh);
 extern struct nftnl_chain *netlink_chain_alloc(const struct nlmsghdr *nlh);
 extern struct nftnl_set *netlink_set_alloc(const struct nlmsghdr *nlh);
 extern struct nftnl_obj *netlink_obj_alloc(const struct nlmsghdr *nlh);
+extern struct nftnl_flowtable *netlink_flowtable_alloc(const struct nlmsghdr *nlh);
 extern struct nftnl_rule *netlink_rule_alloc(const struct nlmsghdr *nlh);
 
 struct nft_data_linearize {
diff --git a/include/rule.h b/include/rule.h
index 5b3e12b5d7dcf..75166b48446f5 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -551,6 +551,7 @@ extern struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 						const struct table **table);
 
 void flowtable_print(const struct flowtable *n, struct output_ctx *octx);
+void flowtable_print_plain(const struct flowtable *ft, struct output_ctx *octx);
 
 /**
  * enum cmd_ops - command operations
diff --git a/src/json.c b/src/json.c
index 1f609bf2b03e9..64a6888f9e0ac 100644
--- a/src/json.c
+++ b/src/json.c
@@ -2108,6 +2108,12 @@ void monitor_print_obj_json(struct netlink_mon_handler *monh,
 	monitor_print_json(monh, cmd, obj_print_json(o));
 }
 
+void monitor_print_flowtable_json(struct netlink_mon_handler *monh,
+				  const char *cmd, struct flowtable *ft)
+{
+	monitor_print_json(monh, cmd, flowtable_print_json(ft));
+}
+
 void monitor_print_rule_json(struct netlink_mon_handler *monh,
 			     const char *cmd, struct rule *r)
 {
diff --git a/src/monitor.c b/src/monitor.c
index 2fc16d6776a28..a787db8cbf5a3 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -127,6 +127,19 @@ struct nftnl_obj *netlink_obj_alloc(const struct nlmsghdr *nlh)
 	return nlo;
 }
 
+struct nftnl_flowtable *netlink_flowtable_alloc(const struct nlmsghdr *nlh)
+{
+	struct nftnl_flowtable *nlf;
+
+	nlf = nftnl_flowtable_alloc();
+	if (nlf == NULL)
+		memory_allocation_error();
+	if (nftnl_flowtable_nlmsg_parse(nlh, nlf) < 0)
+		netlink_abi_error();
+
+	return nlf;
+}
+
 static uint32_t netlink_msg2nftnl_of(uint32_t type, uint16_t flags)
 {
 	switch (type) {
@@ -542,6 +555,50 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 	return MNL_CB_OK;
 }
 
+static int netlink_events_flowtable_cb(const struct nlmsghdr *nlh, int type,
+				       struct netlink_mon_handler *monh)
+{
+	const char *family, *cmd;
+	struct nftnl_flowtable *nlf;
+	struct flowtable *ft;
+
+	nlf = netlink_flowtable_alloc(nlh);
+
+	ft = netlink_delinearize_flowtable(monh->ctx, nlf);
+	if (!ft) {
+		nftnl_flowtable_free(nlf);
+		return MNL_CB_ERROR;
+	}
+	family = family2str(ft->handle.family);
+	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
+
+	switch (monh->format) {
+	case NFTNL_OUTPUT_DEFAULT:
+		nft_mon_print(monh, "%s ", cmd);
+
+		switch (type) {
+		case NFT_MSG_NEWFLOWTABLE:
+			flowtable_print_plain(ft, &monh->ctx->nft->output);
+			break;
+		case NFT_MSG_DELFLOWTABLE:
+			nft_mon_print(monh, "flowtable %s %s %s", family,
+				      ft->handle.table.name,
+				      ft->handle.flowtable.name);
+			break;
+		}
+		nft_mon_print(monh, "\n");
+		break;
+	case NFTNL_OUTPUT_JSON:
+		monitor_print_flowtable_json(monh, cmd, ft);
+		if (!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
+		break;
+	}
+	flowtable_free(ft);
+	nftnl_flowtable_free(nlf);
+	return MNL_CB_OK;
+}
+
 static void rule_map_decompose_cb(struct set *s, void *data)
 {
 	if (!set_is_anonymous(s->flags))
@@ -962,6 +1019,10 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELOBJ:
 		ret = netlink_events_obj_cb(nlh, type, monh);
 		break;
+	case NFT_MSG_NEWFLOWTABLE:
+	case NFT_MSG_DELFLOWTABLE:
+		ret = netlink_events_flowtable_cb(nlh, type, monh);
+		break;
 	case NFT_MSG_NEWGEN:
 		ret = netlink_events_newgen_cb(nlh, type, monh);
 		break;
diff --git a/src/parser_json.c b/src/parser_json.c
index f8200db1fe114..bcc216e12e51c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4421,6 +4421,7 @@ static int json_echo_error(struct netlink_mon_handler *monh,
 
 static uint64_t handle_from_nlmsg(const struct nlmsghdr *nlh)
 {
+	struct nftnl_flowtable *nlf;
 	struct nftnl_table *nlt;
 	struct nftnl_chain *nlc;
 	struct nftnl_rule *nlr;
@@ -4457,6 +4458,11 @@ static uint64_t handle_from_nlmsg(const struct nlmsghdr *nlh)
 		handle = nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
 		nftnl_obj_free(nlo);
 		break;
+	case NFT_MSG_NEWFLOWTABLE:
+		nlf = netlink_flowtable_alloc(nlh);
+		handle = nftnl_flowtable_get_u64(nlf, NFTNL_FLOWTABLE_HANDLE);
+		nftnl_flowtable_free(nlf);
+		break;
 	}
 	return handle;
 }
diff --git a/src/rule.c b/src/rule.c
index 9bc160ec0d888..dc6b9d89fc967 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2155,6 +2155,21 @@ void flowtable_print(const struct flowtable *s, struct output_ctx *octx)
 	do_flowtable_print(s, &opts, octx);
 }
 
+void flowtable_print_plain(const struct flowtable *ft, struct output_ctx *octx)
+{
+	struct print_fmt_options opts = {
+		.tab		= "",
+		.nl		= " ",
+		.table		= ft->handle.table.name,
+		.family		= family2str(ft->handle.family),
+		.stmt_separator = "; ",
+	};
+
+	flowtable_print_declaration(ft, &opts, octx);
+	nft_print(octx, "}");
+}
+
+
 struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 					 const struct nft_cache *cache,
 					 const struct table **t)
diff --git a/tests/monitor/testcases/flowtable-simple.t b/tests/monitor/testcases/flowtable-simple.t
new file mode 100644
index 0000000000000..df8eccbd91e0a
--- /dev/null
+++ b/tests/monitor/testcases/flowtable-simple.t
@@ -0,0 +1,10 @@
+# setup first
+I add table ip t
+I add flowtable ip t ft { hook ingress priority 0; devices = { lo }; }
+O -
+J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
+J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "lo"}}}
+
+I delete flowtable ip t ft
+O -
+J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "lo"}}}
-- 
2.43.0

