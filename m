Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9EFC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5398320657
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfFQRSy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:18:54 -0400
Received: from mail.us.es ([193.147.175.20]:55852 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbfFQRSx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 13:18:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4228F3066B6
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:18:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33287DA711
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:18:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28D22DA70E; Mon, 17 Jun 2019 19:18:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B308DA706;
        Mon, 17 Jun 2019 19:18:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 19:18:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E1C0B4265A32;
        Mon, 17 Jun 2019 19:18:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft,v2 4/5] netlink: remove netlink_list_table()
Date:   Mon, 17 Jun 2019 19:18:41 +0200
Message-Id: <20190617171842.1227-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190617171842.1227-1-pablo@netfilter.org>
References: <20190617171842.1227-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove this wrapper, call netlink_list_rules() instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: move patch from 5/5 to 4/5.

 include/netlink.h | 2 +-
 src/netlink.c     | 7 +------
 src/rule.c        | 2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 0c08b1abbf6a..279723f33d31 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -104,6 +104,7 @@ extern struct expr *netlink_alloc_data(const struct location *loc,
 				       const struct nft_data_delinearize *nld,
 				       enum nft_registers dreg);
 
+extern int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h);
 extern void netlink_linearize_rule(struct netlink_ctx *ctx,
 				   struct nftnl_rule *nlr,
 				   const struct rule *rule);
@@ -115,7 +116,6 @@ extern struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					       const struct nftnl_chain *nlc);
 
 extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h);
-extern int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h);
 extern struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					       const struct nftnl_table *nlt);
 
diff --git a/src/netlink.c b/src/netlink.c
index a6d81b4f6424..24d8f03ae4be 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -333,7 +333,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *arg)
 	return 0;
 }
 
-static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h)
+int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h)
 {
 	struct nftnl_rule_list *rule_cache;
 
@@ -485,11 +485,6 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h)
 	return 0;
 }
 
-int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h)
-{
-	return netlink_list_rules(ctx, h);
-}
-
 enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype)
 {
 	switch (dtype->type) {
diff --git a/src/rule.c b/src/rule.c
index bcd1c0bf73e8..ed199889702f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -191,7 +191,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 		if (cmd != CMD_LIST)
 			continue;
 
-		ret = netlink_list_table(ctx, &table->handle);
+		ret = netlink_list_rules(ctx, &table->handle);
 		list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
 			chain = chain_lookup(table, &rule->handle);
 			list_move_tail(&rule->list, &chain->rules);
-- 
2.11.0

