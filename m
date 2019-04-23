Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080B6C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD7720645
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfDWNWW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:22:22 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57310 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfDWNWW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:22:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hIvNK-0000pE-Mf; Tue, 23 Apr 2019 15:22:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 1/6] xtables: unify user chain add/flush for restore case
Date:   Tue, 23 Apr 2019 15:16:20 +0200
Message-Id: <20190423131625.23377-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190423131625.23377-1-fw@strlen.de>
References: <20190423131625.23377-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The idea here is to move the 'flush' decision into the core, rather than
have the decision in the frontend.

This will be required later when "generation id" is passed to kernel.
In this case, we might have to add the flush when re-trying the
transaction.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.h        |  7 +--
 iptables/nft.c               | 82 +++++++++++++++++-------------------
 iptables/nft.h               |  4 +-
 iptables/xtables-restore.c   | 38 ++++++-----------
 iptables/xtables-translate.c |  6 +--
 5 files changed, 59 insertions(+), 78 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 019c1f20e293..de889ead7b60 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -245,14 +245,11 @@ struct nft_xt_restore_cb {
 	void (*table_new)(struct nft_handle *h, const char *table);
 	struct nftnl_chain_list *(*chain_list)(struct nft_handle *h,
 					       const char *table);
-	int (*chain_user_flush)(struct nft_handle *h,
-				struct nftnl_chain_list *clist,
-				const char *table, const char *chain);
 	int (*chain_set)(struct nft_handle *h, const char *table,
 			 const char *chain, const char *policy,
 			 const struct xt_counters *counters);
-	int (*chain_user_add)(struct nft_handle *h, const char *chain,
-			      const char *table);
+	int (*chain_restore)(struct nft_handle *h, const char *chain,
+			     const char *table);
 
 	int (*table_flush)(struct nft_handle *h, const char *table);
 
diff --git a/iptables/nft.c b/iptables/nft.c
index a297d9856001..16d7b7951969 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1621,49 +1621,6 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 		nftnl_rule_free(r);
 }
 
-struct chain_user_flush_data {
-	struct nft_handle	*handle;
-	const char		*table;
-	const char		*chain;
-};
-
-static int __nft_chain_user_flush(struct nftnl_chain *c, void *data)
-{
-	const char *table_name = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
-	const char *chain_name = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
-	struct chain_user_flush_data *d = data;
-	struct nft_handle *h = d->handle;
-	const char *table = d->table;
-	const char *chain = d->chain;
-
-	if (strcmp(table, table_name) != 0)
-		return 0;
-
-	if (strcmp(chain, chain_name) != 0)
-		return 0;
-
-	if (!nftnl_chain_is_set(c, NFTNL_CHAIN_HOOKNUM))
-		__nft_rule_flush(h, table, chain, false);
-
-	return 0;
-}
-
-int nft_chain_user_flush(struct nft_handle *h, struct nftnl_chain_list *list,
-			 const char *table, const char *chain)
-{
-	struct chain_user_flush_data d = {
-		.handle = h,
-		.table	= table,
-		.chain  = chain,
-	};
-
-	nft_fn = nft_chain_user_flush;
-
-	nftnl_chain_list_foreach(list, __nft_chain_user_flush, &d);
-
-	return 1;
-}
-
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		   bool verbose)
 {
@@ -1750,6 +1707,45 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	return ret == 0 ? 1 : 0;
 }
 
+int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table)
+{
+	struct nftnl_chain_list *list;
+	struct nftnl_chain *c;
+	bool created = false;
+	int ret;
+
+	c = nft_chain_find(h, table, chain);
+	if (c) {
+		/* Apparently -n still flushes existing user defined
+		 * chains that are redefined.
+		 */
+		if (h->noflush)
+			__nft_rule_flush(h, table, chain, false);
+	} else {
+		c = nftnl_chain_alloc();
+		if (!c)
+			return -1;
+
+		nftnl_chain_set(c, NFTNL_CHAIN_TABLE, (char *)table);
+		nftnl_chain_set(c, NFTNL_CHAIN_NAME, (char *)chain);
+		created = true;
+	}
+
+	if (h->family == NFPROTO_BRIDGE)
+		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, NF_ACCEPT);
+
+	if (!created)
+		return 0;
+
+	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+
+	list = nft_chain_list_get(h, table);
+	if (list)
+		nftnl_chain_list_add(c, list);
+
+	return ret;
+}
+
 /* From linux/netlink.h */
 #ifndef NLM_F_NONREC
 #define NLM_F_NONREC	0x100	/* Do not delete recursively    */
diff --git a/iptables/nft.h b/iptables/nft.h
index 56dc20760885..d428287b46ff 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -45,6 +45,7 @@ struct nft_handle {
 	} table[NFT_TABLE_MAX];
 	bool			have_cache;
 	bool			restore;
+	bool			noflush;
 	int8_t			config_done;
 
 	/* meta data, for error reporting */
@@ -87,8 +88,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
-int nft_chain_user_flush(struct nft_handle *h, struct nftnl_chain_list *list,
-			 const char *chain, const char *table);
+int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_rename(struct nft_handle *h, const char *chain, const char *table, const char *newname);
 int nft_chain_zero_counters(struct nft_handle *h, const char *chain, const char *table, bool verbose);
 const struct builtin_chain *nft_chain_builtin_find(const struct builtin_table *t, const char *chain);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 6e6daffc9a1d..b12ab6a60b3a 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -19,7 +19,7 @@
 #include "nft-bridge.h"
 #include <libnftnl/chain.h>
 
-static int counters, verbose, noflush;
+static int counters, verbose;
 
 /* Keeping track of external matches and targets.  */
 static const struct option options[] = {
@@ -74,10 +74,9 @@ struct nft_xt_restore_cb restore_cb = {
 	.abort		= nft_abort,
 	.table_new	= nft_table_new,
 	.table_flush	= nft_table_flush,
-	.chain_user_flush = nft_chain_user_flush,
 	.do_command	= do_commandx,
 	.chain_set	= nft_chain_set,
-	.chain_user_add	= nft_chain_user_add,
+	.chain_restore  = nft_chain_restore,
 };
 
 static const struct xtc_ops xtc_ops = {
@@ -93,7 +92,6 @@ void xtables_restore_parse(struct nft_handle *h,
 	char buffer[10240];
 	int in_table = 0;
 	const struct xtc_ops *ops = &xtc_ops;
-	struct nftnl_chain_list *chain_list = NULL;
 
 	line = 0;
 
@@ -147,10 +145,12 @@ void xtables_restore_parse(struct nft_handle *h,
 			if (p->tablename && (strcmp(p->tablename, table) != 0))
 				continue;
 
-			if (cb->chain_list)
-				chain_list = cb->chain_list(h, table);
+			/* Fixme: Needed to init chain cache.
+			 * Should create explicit function to do this.
+			 */
+			nft_chain_list_get(h, table);
 
-			if (noflush == 0) {
+			if (h->noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
 				if (cb->table_flush)
@@ -214,19 +214,7 @@ void xtables_restore_parse(struct nft_handle *h,
 				}
 				DEBUGP("Setting policy of chain %s to %s\n",
 				       chain, policy);
-
-			} else if (noflush &&
-				   nftnl_chain_list_lookup_byname(chain_list, chain)) {
-				/* Apparently -n still flushes existing user
-				 * defined chains that are redefined. Otherwise,
-				 * leave them as is.
-				 */
-				if (cb->chain_user_flush)
-					cb->chain_user_flush(h, chain_list,
-							     curtable->name, chain);
-			} else if (cb->chain_user_add &&
-				   cb->chain_user_add(h, chain,
-						      curtable->name) < 0 &&
+			} else if (cb->chain_restore(h, chain, curtable->name) < 0 &&
 				   errno != EEXIST) {
 				xtables_error(PARAMETER_PROBLEM,
 					      "cannot create chain "
@@ -380,7 +368,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 					    IPTABLES_VERSION);
 				exit(0);
 			case 'n':
-				noflush = 1;
+				h.noflush = 1;
 				break;
 			case 'M':
 				xtables_modprobe_program = optarg;
@@ -480,10 +468,9 @@ struct nft_xt_restore_cb ebt_restore_cb = {
 	.commit		= nft_commit,
 	.table_new	= nft_table_new,
 	.table_flush	= ebt_table_flush,
-	.chain_user_flush = nft_chain_user_flush,
 	.do_command	= do_commandeb,
 	.chain_set	= nft_chain_set,
-	.chain_user_add	= nft_chain_user_add,
+	.chain_restore  = nft_chain_restore,
 };
 
 static const struct option ebt_restore_options[] = {
@@ -496,6 +483,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 	struct nft_xt_restore_parse p = {
 		.in = stdin,
 	};
+	bool noflush = false;
 	struct nft_handle h;
 	int c;
 
@@ -514,6 +502,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 	}
 
 	nft_init_eb(&h, "ebtables-restore");
+	h.noflush = noflush;
 	xtables_restore_parse(&h, &p, &ebt_restore_cb, argc, argv);
 	nft_fini(&h);
 
@@ -525,10 +514,9 @@ struct nft_xt_restore_cb arp_restore_cb = {
 	.commit		= nft_commit,
 	.table_new	= nft_table_new,
 	.table_flush	= nft_table_flush,
-	.chain_user_flush = nft_chain_user_flush,
 	.do_command	= do_commandarp,
 	.chain_set	= nft_chain_set,
-	.chain_user_add	= nft_chain_user_add,
+	.chain_restore  = nft_chain_restore,
 };
 
 int xtables_arp_restore_main(int argc, char *argv[])
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index e1d2a7d6cce8..eb35890afa78 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -329,8 +329,8 @@ static const struct option options[] = {
 	{ NULL },
 };
 
-static int xlate_chain_user_add(struct nft_handle *h, const char *chain,
-				const char *table)
+static int xlate_chain_user_restore(struct nft_handle *h, const char *chain,
+				    const char *table)
 {
 	printf("add chain %s %s %s\n", family2str[h->family], table, chain);
 	return 0;
@@ -416,7 +416,7 @@ static int dummy_compat_rev(const char *name, uint8_t rev, int opt)
 static struct nft_xt_restore_cb cb_xlate = {
 	.table_new	= xlate_table_new,
 	.chain_set	= xlate_chain_set,
-	.chain_user_add	= xlate_chain_user_add,
+	.chain_restore	= xlate_chain_user_restore,
 	.do_command	= do_command_xlate,
 	.commit		= commit,
 	.abort		= commit,
-- 
2.21.0

