Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623FEC4320A
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 13:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 441C16024A
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 13:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhHQN6N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 09:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhHQN6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 09:58:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81A6C0613C1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Aug 2021 06:57:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mFzay-0005hx-Ag; Tue, 17 Aug 2021 15:57:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 iptables] iptables-nft: allow removal of empty builtin chains
Date:   Tue, 17 Aug 2021 15:57:31 +0200
Message-Id: <20210817135731.18443-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The only reason why this is prohibited is that you cannot do it
in iptables-legacy.

This removes the artifical limitation.

"iptables-nft -X" will leave the builtin chains alone;
Also, deletion is only permitted if the chain is empty.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 As per discussion.  -X removes all chains, provided all are empty.
 NB: DROP policy is also removed implicitly when a base chain is
 deleted.

 iptables/iptables.8.in | 13 ++++---
 iptables/nft-cmd.c     |  8 ++---
 iptables/nft-cmd.h     |  4 +--
 iptables/nft.c         | 78 +++++++++++++++++++++++++++---------------
 iptables/nft.h         |  4 +--
 iptables/xtables-arp.c |  4 +--
 iptables/xtables-eb.c  |  2 +-
 iptables/xtables.c     |  4 +--
 8 files changed, 72 insertions(+), 45 deletions(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 999cf339845f..759ec54fdeb7 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -25,10 +25,10 @@
 .SH NAME
 iptables/ip6tables \(em administration tool for IPv4/IPv6 packet filtering and NAT
 .SH SYNOPSIS
-\fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-C\fP|\fB\-D\fP}
+\fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-C\fP|\fB\-D\fP|\fB-V\fP}
 \fIchain\fP \fIrule-specification\fP
 .P
-\fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-C\fP|\fB\-D\fP}
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-C\fP|\fB\-D\fP|\fB-V\fP}
 \fIchain rule-specification\fP
 .PP
 \fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
@@ -220,11 +220,11 @@ Create a new user-defined chain by the given name.  There must be no
 target of that name already.
 .TP
 \fB\-X\fP, \fB\-\-delete\-chain\fP [\fIchain\fP]
-Delete the optional user-defined chain specified.  There must be no references
+Delete the chain specified.  There must be no references
 to the chain.  If there are, you must delete or replace the referring rules
 before the chain can be deleted.  The chain must be empty, i.e. not contain
-any rules.  If no argument is given, it will attempt to delete every
-non-builtin chain in the table.
+any rules.  If no argument is given, it will delete all empty chains in the
+table. Empty builtin chains can only be deleted with \fBiptables-nft\fP.
 .TP
 \fB\-P\fP, \fB\-\-policy\fP \fIchain target\fP
 Set the policy for the built-in (non-user-defined) chain to the given target.
@@ -362,6 +362,9 @@ For appending, insertion, deletion and replacement, this causes
 detailed information on the rule or rules to be printed. \fB\-v\fP may be
 specified multiple times to possibly emit more detailed debug statements.
 .TP
+\fB\-V\fP, \fB\-\-version\fP
+Show program version and the kernel API used.
+.TP
 \fB\-w\fP, \fB\-\-wait\fP [\fIseconds\fP]
 Wait for the xtables lock.
 To prevent multiple instances of the program from running concurrently,
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index a0c76a795e59..41677e9340cc 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -208,12 +208,12 @@ int nft_cmd_chain_user_add(struct nft_handle *h, const char *chain,
 	return 1;
 }
 
-int nft_cmd_chain_user_del(struct nft_handle *h, const char *chain,
-			   const char *table, bool verbose)
+int nft_cmd_chain_del(struct nft_handle *h, const char *chain,
+		      const char *table, bool verbose)
 {
 	struct nft_cmd *cmd;
 
-	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_USER_DEL, table, chain, NULL, -1,
+	cmd = nft_cmd_new(h, NFT_COMPAT_CHAIN_DEL, table, chain, NULL, -1,
 			  verbose);
 	if (!cmd)
 		return 0;
@@ -320,7 +320,7 @@ int nft_cmd_table_flush(struct nft_handle *h, const char *table, bool verbose)
 
 	if (verbose) {
 		return nft_cmd_rule_flush(h, NULL, table, verbose) &&
-		       nft_cmd_chain_user_del(h, NULL, table, verbose);
+		       nft_cmd_chain_del(h, NULL, table, verbose);
 	}
 
 	cmd = nft_cmd_new(h, NFT_COMPAT_TABLE_FLUSH, table, NULL, NULL, -1,
diff --git a/iptables/nft-cmd.h b/iptables/nft-cmd.h
index ecf7655a4a61..b5a99ef74ad9 100644
--- a/iptables/nft-cmd.h
+++ b/iptables/nft-cmd.h
@@ -49,8 +49,8 @@ int nft_cmd_zero_counters(struct nft_handle *h, const char *chain,
 			  const char *table, bool verbose);
 int nft_cmd_chain_user_add(struct nft_handle *h, const char *chain,
 			   const char *table);
-int nft_cmd_chain_user_del(struct nft_handle *h, const char *chain,
-			   const char *table, bool verbose);
+int nft_cmd_chain_del(struct nft_handle *h, const char *chain,
+		      const char *table, bool verbose);
 int nft_cmd_chain_zero_counters(struct nft_handle *h, const char *chain,
 				const char *table, bool verbose);
 int nft_cmd_rule_list(struct nft_handle *h, const char *chain,
diff --git a/iptables/nft.c b/iptables/nft.c
index 795dff860540..828ba5095b5c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -290,7 +290,7 @@ static int mnl_append_error(const struct nft_handle *h,
 		[NFT_COMPAT_TABLE_FLUSH] = "TABLE_FLUSH",
 		[NFT_COMPAT_CHAIN_ADD] = "CHAIN_ADD",
 		[NFT_COMPAT_CHAIN_USER_ADD] = "CHAIN_USER_ADD",
-		[NFT_COMPAT_CHAIN_USER_DEL] = "CHAIN_USER_DEL",
+		[NFT_COMPAT_CHAIN_DEL] = "CHAIN_DEL",
 		[NFT_COMPAT_CHAIN_USER_FLUSH] = "CHAIN_USER_FLUSH",
 		[NFT_COMPAT_CHAIN_UPDATE] = "CHAIN_UPDATE",
 		[NFT_COMPAT_CHAIN_RENAME] = "CHAIN_RENAME",
@@ -321,7 +321,7 @@ static int mnl_append_error(const struct nft_handle *h,
 	case NFT_COMPAT_CHAIN_ADD:
 	case NFT_COMPAT_CHAIN_ZERO:
 	case NFT_COMPAT_CHAIN_USER_ADD:
-	case NFT_COMPAT_CHAIN_USER_DEL:
+	case NFT_COMPAT_CHAIN_DEL:
 	case NFT_COMPAT_CHAIN_USER_FLUSH:
 	case NFT_COMPAT_CHAIN_UPDATE:
 	case NFT_COMPAT_CHAIN_RENAME:
@@ -1845,22 +1845,19 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 #define NLM_F_NONREC	0x100	/* Do not delete recursively    */
 #endif
 
-struct chain_user_del_data {
+struct chain_del_data {
 	struct nft_handle	*handle;
+	struct nft_cache	*cache;
+	enum nft_table_type	type;
 	bool			verbose;
-	int			builtin_err;
 };
 
-static int __nft_chain_user_del(struct nft_chain *nc, void *data)
+static int __nft_chain_del(struct nft_chain *nc, void *data)
 {
-	struct chain_user_del_data *d = data;
+	struct chain_del_data *d = data;
 	struct nftnl_chain *c = nc->nftnl;
 	struct nft_handle *h = d->handle;
 
-	/* don't delete built-in chain */
-	if (nft_chain_builtin(c))
-		return d->builtin_err;
-
 	if (d->verbose)
 		fprintf(stdout, "Deleting chain `%s'\n",
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
@@ -1868,9 +1865,16 @@ static int __nft_chain_user_del(struct nft_chain *nc, void *data)
 
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
-	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c))
+	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_DEL, c))
 		return -1;
 
+	if (nft_chain_builtin(c)) {
+		uint32_t num = nftnl_chain_get_u32(c, NFTNL_CHAIN_HOOKNUM);
+
+		if (nc == d->cache->table[d->type].base_chains[num])
+			d->cache->table[d->type].base_chains[num] = NULL;
+	}
+
 	/* nftnl_chain is freed when deleting the batch object */
 	nc->nftnl = NULL;
 
@@ -1879,17 +1883,18 @@ static int __nft_chain_user_del(struct nft_chain *nc, void *data)
 	return 0;
 }
 
-int nft_chain_user_del(struct nft_handle *h, const char *chain,
+int nft_chain_del(struct nft_handle *h, const char *chain,
 		       const char *table, bool verbose)
 {
-	struct chain_user_del_data d = {
+	const struct builtin_table *t;
+	struct chain_del_data d = {
 		.handle = h,
 		.verbose = verbose,
 	};
 	struct nft_chain *c;
 	int ret = 0;
 
-	nft_fn = nft_chain_user_del;
+	nft_fn = nft_chain_del;
 
 	if (chain) {
 		c = nft_chain_find(h, table, chain);
@@ -1897,17 +1902,37 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 			errno = ENOENT;
 			return 0;
 		}
-		d.builtin_err = -2;
-		ret = __nft_chain_user_del(c, &d);
+
+		if (nft_chain_builtin(c->nftnl)) {
+			t = nft_table_builtin_find(h, table);
+			if (!t) {
+				errno = EINVAL;
+				return 0;
+			}
+
+			d.type = t->type;
+			d.cache = h->cache;
+		}
+
+		ret = __nft_chain_del(c, &d);
 		if (ret == -2)
 			errno = EINVAL;
 		goto out;
 	}
 
+	t = nft_table_builtin_find(h, table);
+	if (!t) {
+		errno = EINVAL;
+		return 0;
+	}
+
+	d.type = t->type;
+	d.cache = h->cache;
+
 	if (verbose)
 		nft_cache_sort_chains(h, table);
 
-	ret = nft_chain_foreach(h, table, __nft_chain_user_del, &d);
+	ret = nft_chain_foreach(h, table, __nft_chain_del, &d);
 out:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -2672,7 +2697,7 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 	case NFT_COMPAT_CHAIN_USER_ADD:
 	case NFT_COMPAT_CHAIN_ADD:
 		break;
-	case NFT_COMPAT_CHAIN_USER_DEL:
+	case NFT_COMPAT_CHAIN_DEL:
 	case NFT_COMPAT_CHAIN_USER_FLUSH:
 	case NFT_COMPAT_CHAIN_UPDATE:
 	case NFT_COMPAT_CHAIN_RENAME:
@@ -2757,7 +2782,7 @@ static void nft_refresh_transaction(struct nft_handle *h)
 		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
 		case NFT_COMPAT_CHAIN_ZERO:
-		case NFT_COMPAT_CHAIN_USER_DEL:
+		case NFT_COMPAT_CHAIN_DEL:
 		case NFT_COMPAT_CHAIN_USER_FLUSH:
 		case NFT_COMPAT_CHAIN_UPDATE:
 		case NFT_COMPAT_CHAIN_RENAME:
@@ -2823,7 +2848,7 @@ retry:
 						   NLM_F_EXCL, n->seq,
 						   n->chain);
 			break;
-		case NFT_COMPAT_CHAIN_USER_DEL:
+		case NFT_COMPAT_CHAIN_DEL:
 			nft_compat_chain_batch_add(h, NFT_MSG_DELCHAIN,
 						   NLM_F_NONREC, n->seq,
 						   n->chain);
@@ -3068,9 +3093,9 @@ static int nft_prepare(struct nft_handle *h)
 		case NFT_COMPAT_CHAIN_USER_ADD:
 			ret = nft_chain_user_add(h, cmd->chain, cmd->table);
 			break;
-		case NFT_COMPAT_CHAIN_USER_DEL:
-			ret = nft_chain_user_del(h, cmd->chain, cmd->table,
-						 cmd->verbose);
+		case NFT_COMPAT_CHAIN_DEL:
+			ret = nft_chain_del(h, cmd->chain, cmd->table,
+					    cmd->verbose);
 			break;
 		case NFT_COMPAT_CHAIN_RESTORE:
 			ret = nft_chain_restore(h, cmd->chain, cmd->table);
@@ -3269,10 +3294,9 @@ const char *nft_strerror(int err)
 		const char *message;
 	} table[] =
 	  {
-	    { nft_chain_user_del, ENOTEMPTY, "Chain is not empty" },
-	    { nft_chain_user_del, EINVAL, "Can't delete built-in chain" },
-	    { nft_chain_user_del, EBUSY, "Directory not empty" },
-	    { nft_chain_user_del, EMLINK,
+	    { nft_chain_del, ENOTEMPTY, "Chain is not empty" },
+	    { nft_chain_del, EBUSY, "Directory not empty" },
+	    { nft_chain_del, EMLINK,
 	      "Can't delete chain with references left" },
 	    { nft_chain_user_add, EEXIST, "Chain already exists" },
 	    { nft_chain_user_rename, EEXIST, "File exists" },
diff --git a/iptables/nft.h b/iptables/nft.h
index 4ac7e0099d56..a7b652ff62a4 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -53,7 +53,7 @@ enum obj_update_type {
 	NFT_COMPAT_TABLE_FLUSH,
 	NFT_COMPAT_CHAIN_ADD,
 	NFT_COMPAT_CHAIN_USER_ADD,
-	NFT_COMPAT_CHAIN_USER_DEL,
+	NFT_COMPAT_CHAIN_DEL,
 	NFT_COMPAT_CHAIN_USER_FLUSH,
 	NFT_COMPAT_CHAIN_UPDATE,
 	NFT_COMPAT_CHAIN_RENAME,
@@ -147,7 +147,7 @@ struct nftnl_chain;
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
 int nft_chain_save(struct nft_chain *c, void *data);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
-int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
+int nft_chain_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
 int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_rename(struct nft_handle *h, const char *chain, const char *table, const char *newname);
 int nft_chain_zero_counters(struct nft_handle *h, const char *chain, const char *table, bool verbose);
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 4a351f0cab4a..9a079f06b948 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -893,8 +893,8 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 		ret = nft_cmd_chain_user_add(h, chain, *table);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = nft_cmd_chain_user_del(h, chain, *table,
-					 options & OPT_VERBOSE);
+		ret = nft_cmd_chain_del(h, chain, *table,
+					options & OPT_VERBOSE);
 		break;
 	case CMD_RENAME_CHAIN:
 		ret = nft_cmd_chain_user_rename(h, chain, *table, newname);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 6e35f58ee685..21c4477a6d4f 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -779,7 +779,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 					chain = argv[optind];
 					optind++;
 				}
-				ret = nft_cmd_chain_user_del(h, chain, *table, 0);
+				ret = nft_cmd_chain_del(h, chain, *table, 0);
 				break;
 			}
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index daa9b137b5fa..0a700e084740 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -998,8 +998,8 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		ret = nft_cmd_chain_user_add(h, p.chain, p.table);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = nft_cmd_chain_user_del(h, p.chain, p.table,
-					 cs.options & OPT_VERBOSE);
+		ret = nft_cmd_chain_del(h, p.chain, p.table,
+					cs.options & OPT_VERBOSE);
 		break;
 	case CMD_RENAME_CHAIN:
 		ret = nft_cmd_chain_user_rename(h, p.chain, p.table, p.newname);
-- 
2.31.1

