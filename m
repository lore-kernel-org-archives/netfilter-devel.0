Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551F11F5840
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785779; cv=none; b=Ef2edKOk8KkohX+0XLiTGbj0VV3cjZLADdQHtmW8MTWr0UOYiI9YHwkCOAd5D5hHQnJ3+xDYPVinJLpSwPH8k79OZxBuQqgL1ZkXpKAkfooVSmbQy8ITSR2SV4bbdG+1/rbxdTK3W9ttkoqrEfd1gRuiscbJdLtEJWHKS6mrLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785779; c=relaxed/simple;
	bh=t7Vth1dzZ7tLG9orX6a+pmfU+fUqSI1YX15f5889gv0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RIXT01fX5LJY7N/jjzhiXtH6F1SGYb0JpLESmlTFh6qtSoOfQuH02y90M3GVz+FUtRxerncggIdx6QrVTKguOQgkK8xS47MVIARCf0dLKZTrbemXQu9d3vl57J13QKWh6KzvmcLPnGNBQxnuworUyg+xBIlV2BqYZqgycYt+aFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 4/4] src: fix extended netlink error reporting with large set elements
Date: Thu, 24 Oct 2024 18:02:50 +0200
Message-Id: <20241024160250.871045-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241024160250.871045-1-pablo@netfilter.org>
References: <20241024160250.871045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Large sets can expand into several netlink messages, use sequence number
and attribute offset to correlate the set element and the location.

When set element command expands into several netlink messages,
increment sequence number for each netlink message. Update struct cmd to
store the range of netlink messages that result from this command.

struct nlerr_loc remains in the same size in x86_64.

 # nft -f set-65535.nft
 set-65535.nft:65029:22-32: Error: Could not process rule: File exists
 create element x y { 1.1.254.253 }
                      ^^^^^^^^^^^

Fixes: f8aec603aa7e ("src: initial extended netlink error reporting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: rebase on top of new patch 3/4

 include/rule.h    |  4 +++-
 src/cmd.c         |  4 +++-
 src/libnftables.c | 12 ++++++++----
 src/mnl.c         |  9 +++++----
 src/parser_json.c |  4 ++--
 5 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 3fcfa445d103..48e148e6afdd 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -695,6 +695,7 @@ void monitor_free(struct monitor *m);
 #define NFT_NLATTR_LOC_MAX 32
 
 struct nlerr_loc {
+	uint32_t		seqnum;
 	uint32_t		offset;
 	const struct location	*location;
 };
@@ -717,7 +718,8 @@ struct cmd {
 	enum cmd_ops		op;
 	enum cmd_obj		obj;
 	struct handle		handle;
-	uint32_t		seqnum;
+	uint32_t		seqnum_from;
+	uint32_t		seqnum_to;
 	union {
 		void		*data;
 		struct expr	*expr;
diff --git a/src/cmd.c b/src/cmd.c
index 0c7a43edd73a..eb44b986a49a 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -24,6 +24,7 @@ void cmd_add_loc(struct cmd *cmd, const struct nlmsghdr *nlh, const struct locat
 		cmd->attr = xrealloc(cmd->attr, sizeof(struct nlerr_loc) * cmd->attr_array_len);
 	}
 
+	cmd->attr[cmd->num_attrs].seqnum = nlh->nlmsg_seq;
 	cmd->attr[cmd->num_attrs].offset = nlh->nlmsg_len;
 	cmd->attr[cmd->num_attrs].location = loc;
 	cmd->num_attrs++;
@@ -323,7 +324,8 @@ void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 	uint32_t i;
 
 	for (i = 0; i < cmd->num_attrs; i++) {
-		if (cmd->attr[i].offset == err->offset)
+		if (cmd->attr[i].seqnum == err->seqnum &&
+		    cmd->attr[i].offset == err->offset)
 			loc = cmd->attr[i].location;
 	}
 
diff --git a/src/libnftables.c b/src/libnftables.c
index 3550961d5d0e..1df22b3cb57d 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -39,7 +39,7 @@ static int nft_netlink(struct nft_ctx *nft,
 
 	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_inc(&seqnum));
 	list_for_each_entry(cmd, cmds, list) {
-		ctx.seqnum = cmd->seqnum = mnl_seqnum_inc(&seqnum);
+		ctx.seqnum = cmd->seqnum_from = mnl_seqnum_inc(&seqnum);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0) {
 			netlink_io_error(&ctx, &cmd->location,
@@ -47,6 +47,8 @@ static int nft_netlink(struct nft_ctx *nft,
 					 strerror(errno));
 			goto out;
 		}
+		seqnum = cmd->seqnum_to = ctx.seqnum;
+		mnl_seqnum_inc(&seqnum);
 		num_cmds++;
 	}
 	if (!nft->check)
@@ -80,12 +82,14 @@ static int nft_netlink(struct nft_ctx *nft,
 			cmd = list_first_entry(cmds, struct cmd, list);
 
 		list_for_each_entry_from(cmd, cmds, list) {
-			last_seqnum = cmd->seqnum;
-			if (err->seqnum == cmd->seqnum ||
+			last_seqnum = cmd->seqnum_to;
+			if ((err->seqnum >= cmd->seqnum_from &&
+			     err->seqnum <= cmd->seqnum_to) ||
 			    err->seqnum == batch_seqnum) {
 				nft_cmd_error(&ctx, cmd, err);
 				errno = err->err;
-				if (err->seqnum == cmd->seqnum) {
+				if (err->seqnum >= cmd->seqnum_from ||
+				    err->seqnum <= cmd->seqnum_to) {
 					mnl_err_list_free(err);
 					break;
 				}
diff --git a/src/mnl.c b/src/mnl.c
index 42d1b0d87ec1..12a6345cbed8 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1722,7 +1722,7 @@ static void netlink_dump_setelem_done(struct netlink_ctx *ctx)
 static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 				 struct nftnl_batch *batch,
 				 enum nf_tables_msg_types msg_type,
-				 unsigned int flags, uint32_t seqnum,
+				 unsigned int flags, uint32_t *seqnum,
 				 const struct expr *set,
 				 struct netlink_ctx *ctx)
 {
@@ -1741,7 +1741,7 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 next:
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), msg_type,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    flags, seqnum);
+				    flags, *seqnum);
 
 	if (nftnl_set_is_set(nls, NFTNL_SET_TABLE)) {
                 mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_TABLE,
@@ -1774,6 +1774,7 @@ next:
 		if (mnl_nft_attr_nest_overflow(nlh, nest1, nest2)) {
 			mnl_attr_nest_end(nlh, nest1);
 			mnl_nft_batch_continue(batch);
+			mnl_seqnum_inc(seqnum);
 			goto next;
 		}
 	}
@@ -1808,7 +1809,7 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	netlink_dump_set(nls, ctx);
 
 	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, NFT_MSG_NEWSETELEM,
-				    flags, ctx->seqnum, expr, ctx);
+				    flags, &ctx->seqnum, expr, ctx);
 	nftnl_set_free(nls);
 
 	return err;
@@ -1868,7 +1869,7 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
 		msg_type = NFT_MSG_DESTROYSETELEM;
 
 	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, msg_type, 0,
-				    ctx->seqnum, init, ctx);
+				    &ctx->seqnum, init, ctx);
 	nftnl_set_free(nls);
 
 	return err;
diff --git a/src/parser_json.c b/src/parser_json.c
index bbe3b1c59192..37ec34cb7796 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4269,13 +4269,13 @@ static json_t *seqnum_to_json(const uint32_t seqnum)
 		cur = json_cmd_assoc_list;
 		json_cmd_assoc_list = cur->next;
 
-		key = cur->cmd->seqnum % CMD_ASSOC_HSIZE;
+		key = cur->cmd->seqnum_from % CMD_ASSOC_HSIZE;
 		hlist_add_head(&cur->hnode, &json_cmd_assoc_hash[key]);
 	}
 
 	key = seqnum % CMD_ASSOC_HSIZE;
 	hlist_for_each_entry(cur, n, &json_cmd_assoc_hash[key], hnode) {
-		if (cur->cmd->seqnum == seqnum)
+		if (cur->cmd->seqnum_from == seqnum)
 			return cur->json;
 	}
 
-- 
2.30.2

