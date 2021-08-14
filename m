Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4B3C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 17:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9CB760F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 17:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhHNRrT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Aug 2021 13:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbhHNRrT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Aug 2021 13:47:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66652C061764
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Aug 2021 10:46:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mExk7-0004Xo-L5; Sat, 14 Aug 2021 19:46:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptabes-nft] iptables-nft: allow removal of empty builtin chains
Date:   Sat, 14 Aug 2021 19:46:43 +0200
Message-Id: <20210814174643.130760-1-fw@strlen.de>
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
 Conservative change:
 iptables-nft -X will not remove empty builtin chains.
 OTOH, maybe it would be better to auto-remove those too, if empty.
 Comments?

 iptables/iptables.8.in | 10 ++++--
 iptables/nft-cmd.c     |  8 ++---
 iptables/nft-cmd.h     |  4 +--
 iptables/nft.c         | 69 +++++++++++++++++++++++++++---------------
 iptables/nft.h         |  4 +--
 iptables/xtables-arp.c |  4 +--
 iptables/xtables-eb.c  |  2 +-
 iptables/xtables.c     |  4 +--
 8 files changed, 64 insertions(+), 41 deletions(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 999cf339845f..cba88bb0923d 100644
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
@@ -220,11 +220,12 @@ Create a new user-defined chain by the given name.  There must be no
 target of that name already.
 .TP
 \fB\-X\fP, \fB\-\-delete\-chain\fP [\fIchain\fP]
-Delete the optional user-defined chain specified.  There must be no references
+Delete the chain specified.  There must be no references
 to the chain.  If there are, you must delete or replace the referring rules
 before the chain can be deleted.  The chain must be empty, i.e. not contain
 any rules.  If no argument is given, it will attempt to delete every
 non-builtin chain in the table.
+Note that empty builtin chains can only be deleted with \fBiptables-nft\fP.
 .TP
 \fB\-P\fP, \fB\-\-policy\fP \fIchain target\fP
 Set the policy for the built-in (non-user-defined) chain to the given target.
@@ -362,6 +363,9 @@ For appending, insertion, deletion and replacement, this causes
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
index 795dff860540..2288bf3509f8 100644
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
@@ -1845,21 +1845,23 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 #define NLM_F_NONREC	0x100	/* Do not delete recursively    */
 #endif
 
-struct chain_user_del_data {
+struct chain_del_data {
 	struct nft_handle	*handle;
+	struct nft_cache	*cache;
+	enum nft_table_type	type;
+	uint8_t			hooknum;
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
 
 	/* don't delete built-in chain */
-	if (nft_chain_builtin(c))
-		return d->builtin_err;
+	if (!d->cache && nft_chain_builtin(c))
+		return 1;
 
 	if (d->verbose)
 		fprintf(stdout, "Deleting chain `%s'\n",
@@ -1868,9 +1870,13 @@ static int __nft_chain_user_del(struct nft_chain *nc, void *data)
 
 	/* XXX This triggers a fast lookup from the kernel. */
 	nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
-	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c))
+	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_DEL, c))
 		return -1;
 
+	if (d->cache &&
+	    nc == d->cache->table[d->type].base_chains[d->hooknum])
+		d->cache->table[d->type].base_chains[d->hooknum] = NULL;
+
 	/* nftnl_chain is freed when deleting the batch object */
 	nc->nftnl = NULL;
 
@@ -1879,17 +1885,17 @@ static int __nft_chain_user_del(struct nft_chain *nc, void *data)
 	return 0;
 }
 
-int nft_chain_user_del(struct nft_handle *h, const char *chain,
+int nft_chain_del(struct nft_handle *h, const char *chain,
 		       const char *table, bool verbose)
 {
-	struct chain_user_del_data d = {
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
@@ -1897,8 +1903,22 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 			errno = ENOENT;
 			return 0;
 		}
-		d.builtin_err = -2;
-		ret = __nft_chain_user_del(c, &d);
+
+		if (nft_chain_builtin(c->nftnl)) {
+			const struct builtin_table *t;
+
+			t = nft_table_builtin_find(h, table);
+			if (!t) {
+				errno = EINVAL;
+				return 0;
+			}
+
+			d.type = t->type;
+			d.cache = h->cache;
+			d.hooknum = nftnl_chain_get_u32(c->nftnl, NFTNL_CHAIN_HOOKNUM);
+		}
+
+		ret = __nft_chain_del(c, &d);
 		if (ret == -2)
 			errno = EINVAL;
 		goto out;
@@ -1907,7 +1927,7 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain,
 	if (verbose)
 		nft_cache_sort_chains(h, table);
 
-	ret = nft_chain_foreach(h, table, __nft_chain_user_del, &d);
+	ret = nft_chain_foreach(h, table, __nft_chain_del, &d);
 out:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -2672,7 +2692,7 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 	case NFT_COMPAT_CHAIN_USER_ADD:
 	case NFT_COMPAT_CHAIN_ADD:
 		break;
-	case NFT_COMPAT_CHAIN_USER_DEL:
+	case NFT_COMPAT_CHAIN_DEL:
 	case NFT_COMPAT_CHAIN_USER_FLUSH:
 	case NFT_COMPAT_CHAIN_UPDATE:
 	case NFT_COMPAT_CHAIN_RENAME:
@@ -2757,7 +2777,7 @@ static void nft_refresh_transaction(struct nft_handle *h)
 		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
 		case NFT_COMPAT_CHAIN_ZERO:
-		case NFT_COMPAT_CHAIN_USER_DEL:
+		case NFT_COMPAT_CHAIN_DEL:
 		case NFT_COMPAT_CHAIN_USER_FLUSH:
 		case NFT_COMPAT_CHAIN_UPDATE:
 		case NFT_COMPAT_CHAIN_RENAME:
@@ -2823,7 +2843,7 @@ retry:
 						   NLM_F_EXCL, n->seq,
 						   n->chain);
 			break;
-		case NFT_COMPAT_CHAIN_USER_DEL:
+		case NFT_COMPAT_CHAIN_DEL:
 			nft_compat_chain_batch_add(h, NFT_MSG_DELCHAIN,
 						   NLM_F_NONREC, n->seq,
 						   n->chain);
@@ -3068,9 +3088,9 @@ static int nft_prepare(struct nft_handle *h)
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
@@ -3269,10 +3289,9 @@ const char *nft_strerror(int err)
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

