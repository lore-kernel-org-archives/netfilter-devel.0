Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21086C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jan 2022 20:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbiA1UhP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 15:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiA1UhO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 15:37:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72004C061714
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jan 2022 12:37:14 -0800 (PST)
Received: from localhost ([::1]:59156 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nDXzc-00012D-QF; Fri, 28 Jan 2022 21:37:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] nft: Use verbose flag to toggle debug output
Date:   Fri, 28 Jan 2022 21:36:59 +0100
Message-Id: <20220128203700.27071-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Copy legacy iptables' behaviour, printing debug output if verbose flag
is given more than once.

Since nft debug output applies to netlink messages which are not created
until nft_action() phase, carrying verbose value is non-trivial -
introduce a field in struct nft_handle for that.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h |  1 -
 iptables/nft.c        | 38 ++++++++++++++++++++------------------
 iptables/nft.h        |  1 +
 iptables/xtables.c    |  1 +
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c3241f4b8c726..d4222ae05adc3 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -13,7 +13,6 @@
 #include "xshared.h"
 
 #ifdef DEBUG
-#define NLDEBUG
 #define DEBUG_DEL
 #endif
 
diff --git a/iptables/nft.c b/iptables/nft.c
index b5de687c5c4cd..ae41384fe8180 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -926,15 +926,16 @@ void nft_fini(struct nft_handle *h)
 	mnl_socket_close(h->nl);
 }
 
-static void nft_chain_print_debug(struct nftnl_chain *c, struct nlmsghdr *nlh)
+static void nft_chain_print_debug(struct nft_handle *h,
+				  struct nftnl_chain *c, struct nlmsghdr *nlh)
 {
-#ifdef NLDEBUG
-	char tmp[1024];
-
-	nftnl_chain_snprintf(tmp, sizeof(tmp), c, 0, 0);
-	printf("DEBUG: chain: %s\n", tmp);
-	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
-#endif
+	if (h->verbose > 1) {
+		nftnl_chain_fprintf(stdout, c, 0, 0);
+		fprintf(stdout, "\n");
+	}
+	if (h->verbose > 2)
+		mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len,
+				  sizeof(struct nfgenmsg));
 }
 
 static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
@@ -1386,15 +1387,16 @@ int add_log(struct nftnl_rule *r, struct iptables_command_state *cs)
 	return 0;
 }
 
-static void nft_rule_print_debug(struct nftnl_rule *r, struct nlmsghdr *nlh)
+static void nft_rule_print_debug(struct nft_handle *h,
+				 struct nftnl_rule *r, struct nlmsghdr *nlh)
 {
-#ifdef NLDEBUG
-	char tmp[1024];
-
-	nftnl_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
-	printf("DEBUG: rule: %s\n", tmp);
-	mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len, sizeof(struct nfgenmsg));
-#endif
+	if (h->verbose > 1) {
+		nftnl_rule_fprintf(stdout, r, 0, 0);
+		fprintf(stdout, "\n");
+	}
+	if (h->verbose > 2)
+		mnl_nlmsg_fprintf(stdout, nlh, nlh->nlmsg_len,
+				  sizeof(struct nfgenmsg));
 }
 
 int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes)
@@ -2698,7 +2700,7 @@ static void nft_compat_chain_batch_add(struct nft_handle *h, uint16_t type,
 	nlh = nftnl_chain_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
 					type, h->family, flags, seq);
 	nftnl_chain_nlmsg_build_payload(nlh, chain);
-	nft_chain_print_debug(chain, nlh);
+	nft_chain_print_debug(h, chain, nlh);
 }
 
 static void nft_compat_rule_batch_add(struct nft_handle *h, uint16_t type,
@@ -2710,7 +2712,7 @@ static void nft_compat_rule_batch_add(struct nft_handle *h, uint16_t type,
 	nlh = nftnl_rule_nlmsg_build_hdr(nftnl_batch_buffer(h->batch),
 				       type, h->family, flags, seq);
 	nftnl_rule_nlmsg_build_payload(nlh, rule);
-	nft_rule_print_debug(rule, nlh);
+	nft_rule_print_debug(h, rule, nlh);
 }
 
 static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
diff --git a/iptables/nft.h b/iptables/nft.h
index 4c78f761e1c4b..fd116c2e3e198 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -109,6 +109,7 @@ struct nft_handle {
 	int8_t			config_done;
 	struct list_head	cmd_list;
 	bool			cache_init;
+	int			verbose;
 
 	/* meta data, for error reporting */
 	struct {
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 051d5c7b7f98b..c44b39acdcd97 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -163,6 +163,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		h->ops->init_cs(&cs);
 
 	do_parse(argc, argv, &p, &cs, &args);
+	h->verbose = p.verbose;
 
 	if (!nft_table_builtin_find(h, p.table))
 		xtables_error(VERSION_PROBLEM,
-- 
2.34.1

