Return-Path: <SRS0=c8az=B7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD66C433E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Aug 2020 11:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AFFC20855
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Aug 2020 11:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgHULPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Aug 2020 07:15:02 -0400
Received: from correo.us.es ([193.147.175.20]:38848 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgHULO5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Aug 2020 07:14:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9636EBAC3
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 13:14:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B88BBDA789
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 13:14:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AE34ADA722; Fri, 21 Aug 2020 13:14:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C310DA78E
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 13:14:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Aug 2020 13:14:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6948E41E4801
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 13:14:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: add expression handler hashtable
Date:   Fri, 21 Aug 2020 13:14:37 +0200
Message-Id: <20200821111438.5362-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

netlink_parsers is actually small, but update this code to use a
hashtable instead since more expressions may come in the future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h           | 10 +++++++++
 include/netlink.h         |  3 +++
 include/rule.h            |  1 +
 src/libnftables.c         |  2 ++
 src/netlink_delinearize.c | 46 ++++++++++++++++++++++++++++++---------
 5 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 213a6eaf9104..b9db1a8f7650 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -35,4 +35,14 @@ enum cache_level_flags {
 	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
+static inline uint32_t djb_hash(const char *key)
+{
+	uint32_t i, hash = 5381;
+
+	for (i = 0; i < strlen(key); i++)
+		hash = ((hash << 5) + hash) + key[i];
+
+	return hash;
+}
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 1077096ea0b1..ad2247e9dd57 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -213,4 +213,7 @@ int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 
 enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype);
 
+void expr_handler_init(void);
+void expr_handler_exit(void);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/include/rule.h b/include/rule.h
index caca63d0f648..f2f82cc0ca4b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -7,6 +7,7 @@
 #include <netinet/in.h>
 #include <libnftnl/object.h>	/* For NFTNL_CTTIMEOUT_ARRAY_MAX. */
 #include <linux/netfilter/nf_tables.h>
+#include <string.h>
 
 /**
  * struct handle_spec - handle ID
diff --git a/src/libnftables.c b/src/libnftables.c
index 668e3fc43031..fce52ad4003b 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -88,10 +88,12 @@ static void nft_init(struct nft_ctx *ctx)
 	realm_table_rt_init(ctx);
 	devgroup_table_init(ctx);
 	ct_label_table_init(ctx);
+	expr_handler_init();
 }
 
 static void nft_exit(struct nft_ctx *ctx)
 {
+	expr_handler_exit();
 	ct_label_table_exit(ctx);
 	realm_table_rt_exit(ctx);
 	devgroup_table_exit(ctx);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9e3ed53d09f1..43d7ff821504 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -27,6 +27,7 @@
 #include <erec.h>
 #include <sys/socket.h>
 #include <libnftnl/udata.h>
+#include <cache.h>
 #include <xt.h>
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
@@ -1627,12 +1628,14 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
-static const struct {
+struct expr_handler {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nftnl_expr *nle);
-} netlink_parsers[] = {
+};
+
+static const struct expr_handler netlink_parsers[] = {
 	{ .name = "immediate",	.parse = netlink_parse_immediate },
 	{ .name = "cmp",	.parse = netlink_parse_cmp },
 	{ .name = "lookup",	.parse = netlink_parse_lookup },
@@ -1673,25 +1676,48 @@ static const struct {
 	{ .name = "synproxy",	.parse = netlink_parse_synproxy },
 };
 
+static const struct expr_handler **expr_handle_ht;
+
+#define NFT_EXPR_HSIZE	4096
+
+void expr_handler_init(void)
+{
+	unsigned int i;
+	uint32_t hash;
+
+	expr_handle_ht = calloc(NFT_EXPR_HSIZE, sizeof(expr_handle_ht));
+	if (!expr_handle_ht)
+		memory_allocation_error();
+
+	for (i = 0; i < array_size(netlink_parsers); i++) {
+		hash = djb_hash(netlink_parsers[i].name) % NFT_EXPR_HSIZE;
+		assert(expr_handle_ht[hash] == NULL);
+		expr_handle_ht[hash] = &netlink_parsers[i];
+	}
+}
+
+void expr_handler_exit(void)
+{
+	xfree(expr_handle_ht);
+}
+
 static int netlink_parse_expr(const struct nftnl_expr *nle,
 			      struct netlink_parse_ctx *ctx)
 {
 	const char *type = nftnl_expr_get_str(nle, NFTNL_EXPR_NAME);
 	struct location loc;
-	unsigned int i;
+	uint32_t hash;
 
 	memset(&loc, 0, sizeof(loc));
 	loc.indesc = &indesc_netlink;
 	loc.nle = nle;
 
-	for (i = 0; i < array_size(netlink_parsers); i++) {
-		if (strcmp(type, netlink_parsers[i].name))
-			continue;
-		netlink_parsers[i].parse(ctx, &loc, nle);
-		return 0;
-	}
+	hash = djb_hash(type) % NFT_EXPR_HSIZE;
+	if (expr_handle_ht[hash])
+		expr_handle_ht[hash]->parse(ctx, &loc, nle);
+	else
+		netlink_error(ctx, &loc, "unknown expression type '%s'", type);
 
-	netlink_error(ctx, &loc, "unknown expression type '%s'", type);
 	return 0;
 }
 
-- 
2.20.1

