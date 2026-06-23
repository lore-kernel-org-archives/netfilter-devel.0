Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F179938AC97
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235300; cv=none; b=MmR53ECbELprCiI4NWtIq4fRqlUOGZG+IVzJlBnMK6TeaTKGxM4nG8ZTCHi6UfgymP743vrysWRKEDwKnodcF/0qVR7abJcApayz//X7P3fQcKLWyQw0NXTDJfEZrXtk/IxYgMpuggJJvpUrSCVy+v9VgXCOO+twfEK5iwtpH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235300; c=relaxed/simple;
	bh=Lc7HbB6oZX0jbqA1H3NUxCsyaqzeCVmZ1Qhzc/vTFzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2LrniPVRWsAn7YoDoRWV7tuJp9Y4M/tTbPNjtOC7AsduIMax3VrRfAHZoi2bIOa4engdyrAE/p6DPj2idJSJAUkkxwhc9Cjy+28mQGXvscv5hVcd7tIHnTlb24DJd9a9/99K9IrkJVtbLLfL7f949TVzLZD0WhnI2IgRJ+rPGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aB1VTxVu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aB1VTxVu"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2346260580;
	Tue, 23 Jun 2026 19:21:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782235297;
	bh=IX6nofIQQVgLyx3VqlhyGcYbNa43/pK/FWe7R2qn13o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aB1VTxVuUGnJJKuDrj9qdufUxUdSJNceWDcxVQUi+F2WpfntSVY4rNe5UfYV02X2h
	 3TjHj98YPRgTLJf6v0VDjl8Yn5ugypokKwV8NtDIvizmJJh9ax+f0jkE4Q8SVb5mkr
	 sttAxFw0CF1vRaOoHq25W+i512bmyq+U/mFvjoaYuMnqiazQJcKs1heXVbCZwhQh0v
	 mcx1LO/ErjixvI+udoVtnLczdyvpMo6HYyzuYwDMPST/vCfrp+GHqp6Zicz2aetkH4
	 svNybmIG58aNLOkrrhP+os4touELRaODZCxTPHjsALIOLhu8LxSTnUTMHuw3Z1lHT2
	 70e/em/0PNgIg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft,v2 5/5] libnftables: support for several reset commands
Date: Tue, 23 Jun 2026 19:21:28 +0200
Message-ID: <20260623172128.401234-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623172128.401234-1-pablo@netfilter.org>
References: <20260623172128.401234-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cache logic woes with either more than one single reset command,
e.g. reset table x; reset table y;

One possibility is to handle this from the cache logic itself through
the existing netlink dump filter infrastructure, but it looks fragile
because this needs to combine the different dump filtering requirements.

The reset command is not integrated into the 2-phase commit protocol in
nf_tables, instead it uses the netlink dump path to fetch (and reset)
data from the kernel, this needs to be handled in a different way.

This patch updates the parser to create one cmd_batch shim object that
stores the usual add/delete cmd object in a batch. The exception is the
CMD_RESET command, which have a single cmd_batch object with a single
command. The new approach consists of iterating over the list of
cmd_batch shims to handle the list of commands sequentially. This new
shim object is released when running the command list.

The new batch structure is a list of lists:

         .-----------.
         | cmd_batch |-> reset cmd
         `-----------'
               |
         .-----------.
         | cmd_batch |-> reset cmd
         `-----------'
               |
               .
               |
         .-----------.
         | cmd_batch |-> reset cmd
         `-----------'

or, what happens more often:

         .-----------.
         | cmd_batch |-> add cmd -> add cmd -> ... -> add cmd
         `-----------'

This patch updates the core function to process each batch in the
command list. Every reset command in a batch is run as a singleton
command through nft_run_cmds() to fetch a cache that suits the needs of
this command.

The previous patch:

  ("src: bail out if reset commands are mixed with other commands")

ensures that reset commands are only mixed with list and get commands by
now, for simplicity.

Fixes: dbff26bfba83 ("cache: consolidate reset command")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cmd.h     |  7 +++++++
 src/cmd.c         | 26 +++++++++++++++++++++++---
 src/libnftables.c | 39 +++++++++++++++++++++++++++++++++------
 3 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/include/cmd.h b/include/cmd.h
index a457364aeeeb..4e1248ced739 100644
--- a/include/cmd.h
+++ b/include/cmd.h
@@ -1,6 +1,8 @@
 #ifndef _NFT_CMD_H_
 #define _NFT_CMD_H_
 
+#include <list.h>
+
 void cmd_add_loc(struct cmd *cmd, const struct nlmsghdr *nlh, const struct location *loc);
 struct mnl_err;
 void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
@@ -11,6 +13,11 @@ bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 
 void nft_cmd_expand(struct cmd *cmd);
 
+struct cmd_batch {
+	struct list_head	list;
+	struct list_head        sublist;
+};
+
 int cmd_batch_add(struct cmd *cmd, struct list_head *cmds);
 
 #endif
diff --git a/src/cmd.c b/src/cmd.c
index 7ee2176191b1..407217bfaae6 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -384,6 +384,7 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 			    struct handle *handle, struct expr *init)
 {
+	struct cmd_batch *cmd_batch;
 	struct cmd *last_cmd;
 
 	if (list_empty(cmds))
@@ -392,7 +393,9 @@ bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 	if (init->etype == EXPR_VARIABLE)
 		return false;
 
-	last_cmd = list_last_entry(cmds, struct cmd, list);
+	cmd_batch = list_last_entry(cmds, struct cmd_batch, list);
+
+	last_cmd = list_last_entry(&cmd_batch->sublist, struct cmd, list);
 	if (last_cmd->op != op ||
 	    last_cmd->obj != CMD_OBJ_ELEMENTS ||
 	    last_cmd->expr->etype == EXPR_VARIABLE ||
@@ -512,17 +515,34 @@ static bool cmd_valid_mix(const struct cmd *cmd, const struct cmd *last_cmd)
 	return true;
 }
 
+static void __cmd_batch_add(struct cmd *cmd, struct list_head *cmds)
+{
+	struct cmd_batch *cmd_batch;
+
+	cmd_batch = xmalloc(sizeof(struct cmd_batch));
+	init_list_head(&cmd_batch->sublist);
+	list_add_tail(&cmd->list, &cmd_batch->sublist);
+	list_add_tail(&cmd_batch->list, cmds);
+}
+
 int cmd_batch_add(struct cmd *cmd, struct list_head *cmds)
 {
+	struct cmd_batch *cmd_batch = NULL;
 	struct cmd *last_cmd;
 	int ret = 0;
 
 	if (!list_empty(cmds)) {
-		last_cmd = list_last_entry(cmds, struct cmd, list);
+		cmd_batch = list_last_entry(cmds, struct cmd_batch, list)
+;
+		last_cmd = list_last_entry(&cmd_batch->sublist, struct cmd, list);
 		if (!cmd_valid_mix(cmd, last_cmd))
 			ret = -1;
 	}
-	list_add_tail(&cmd->list, cmds);
+
+	if (!cmd_batch || cmd->op == CMD_RESET)
+		__cmd_batch_add(cmd, cmds);
+	else
+		list_add_tail(&cmd->list, &cmd_batch->sublist);
 
 	return ret;
 }
diff --git a/src/libnftables.c b/src/libnftables.c
index 6e29bb019fb7..61695cba0354 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -667,10 +667,25 @@ static void nft_finish_cmds(struct nft_ctx *nft, struct list_head *msgs,
 		nft_cache_release(&nft->cache);
 }
 
+static void cmds_batch_next(struct list_head *cmds,
+			    struct list_head *cmds_sublist)
+{
+	struct cmd_batch *cmd_batch;
+
+	if (list_empty(cmds))
+		return;
+
+	cmd_batch = list_first_entry(cmds, struct cmd_batch, list);
+	list_splice_init(&cmd_batch->sublist, cmds_sublist);
+	list_del(&cmd_batch->list);
+	free(cmd_batch);
+}
 
 EXPORT_SYMBOL(nft_run_cmd_from_buffer);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 {
+	LIST_HEAD(cmds_sublist);
+	LIST_HEAD(cmds_done);
 	int rc = -EINVAL;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
@@ -685,9 +700,14 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
 					    &indesc_cmdline);
 
-	rc = nft_run_cmds(nft, &msgs, &cmds, rc);
+	cmds_batch_next(&cmds, &cmds_sublist);
+	while (!list_empty(&cmds_sublist)) {
+		rc = nft_run_cmds(nft, &msgs, &cmds_sublist, rc);
+		list_splice_tail_init(&cmds_sublist, &cmds_done);
+		cmds_batch_next(&cmds, &cmds_sublist);
+	}
 
-	nft_finish_cmds(nft, &msgs, &cmds, rc);
+	nft_finish_cmds(nft, &msgs, &cmds_done, rc);
 
 	free(nlbuf);
 	iface_cache_release();
@@ -769,6 +789,8 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct error_record *erec;
+	LIST_HEAD(cmds_sublist);
+	LIST_HEAD(cmds_done);
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
 	int rc;
@@ -790,12 +812,17 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_filename(nft, filename, &msgs, &cmds);
 
-	if (nft->optimize_flags)
-		nft_optimize(nft, &cmds);
+	cmds_batch_next(&cmds, &cmds_sublist);
+	while (!list_empty(&cmds_sublist)) {
+		if (nft->optimize_flags)
+			nft_optimize(nft, &cmds_sublist);
 
-	rc = nft_run_cmds(nft, &msgs, &cmds, rc);
+		rc = nft_run_cmds(nft, &msgs, &cmds_sublist, rc);
+		list_splice_tail_init(&cmds_sublist, &cmds_done);
+		cmds_batch_next(&cmds, &cmds_sublist);
+	}
 
-	nft_finish_cmds(nft, &msgs, &cmds, rc);
+	nft_finish_cmds(nft, &msgs, &cmds_done, rc);
 
 	iface_cache_release();
 	if (nft->scanner) {
-- 
2.47.3

