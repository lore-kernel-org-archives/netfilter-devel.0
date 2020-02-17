Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3483DC34022
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 22:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40CF20718
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 22:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgBQWhe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 17:37:34 -0500
Received: from correo.us.es ([193.147.175.20]:49992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgBQWhe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 17:37:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A20620A523
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2020 23:37:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88A6BDA788
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2020 23:37:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DBE9DA736; Mon, 17 Feb 2020 23:37:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20209DA788
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2020 23:37:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Feb 2020 23:37:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0C8A042EF4E0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2020 23:37:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: initial extended netlink error reporting
Date:   Mon, 17 Feb 2020 23:37:24 +0100
Message-Id: <20200217223724.326013-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch correlates the in-kernel extended netlink error offset and
the location information.

Assuming 'foo' table does not exists, then error reporting shows:

 # nft delete table foo
 Error: Could not process rule: No such file or directory
 delete table foo
              ^^^

Similarly, if table uniquely identified by handle '1234' does not exist,
then error reporting shows:

 # nft delete table handle 1234
 Error: Could not process rule: No such file or directory
 delete table handle 1234
                     ^^^^

 Assuming 'bar' chain does not exists in the kernel, while 'foo' does:

 # nft delete chain foo bar
 Error: Could not process rule: No such file or directory
 delete chain foo bar
                  ^^^

This is based on ("src: basic support for extended netlink errors") from
Florian Westphal, posted in 2018, with no netlink offset correlation
support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h     |  11 ++--
 include/netlink.h |  20 ++++++
 include/rule.h    |   9 +++
 src/libnftables.c |  23 ++++++-
 src/mnl.c         | 180 +++++++++++++++++++++++++++++++++++++++++-------------
 src/monitor.c     |   3 +-
 src/rule.c        |   8 +++
 7 files changed, 202 insertions(+), 52 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index eeba7379706f..2df67c2e9718 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -16,6 +16,7 @@ struct mnl_err {
 	struct list_head	head;
 	int			err;
 	uint32_t		seqnum;
+	uint32_t		offset;
 };
 
 void mnl_err_list_free(struct mnl_err *err);
@@ -38,7 +39,7 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx,
 
 int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		      unsigned int flags);
-int mnl_nft_chain_del(struct netlink_ctx *ctx, const struct cmd *cmd);
+int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd);
 int mnl_nft_chain_rename(struct netlink_ctx *ctx, const struct cmd *cmd,
 			 const struct chain *chain);
 
@@ -47,14 +48,14 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
 
 int mnl_nft_table_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		      unsigned int flags);
-int mnl_nft_table_del(struct netlink_ctx *ctx, const struct cmd *cmd);
+int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
 					    int family);
 
 int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		    unsigned int flags);
-int mnl_nft_set_del(struct netlink_ctx *ctx, const struct cmd *cmd);
+int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_set_list *mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 					const char *table);
@@ -73,14 +74,14 @@ struct nftnl_obj_list *mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 					bool dump, bool reset);
 int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		    unsigned int flags);
-int mnl_nft_obj_del(struct netlink_ctx *ctx, const struct cmd *cmd, int type);
+int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type);
 
 struct nftnl_flowtable_list *
 mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table);
 
 int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 			  unsigned int flags);
-int mnl_nft_flowtable_del(struct netlink_ctx *ctx, const struct cmd *cmd);
+int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
 int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 			   struct output_ctx *octx,
diff --git a/include/netlink.h b/include/netlink.h
index d02533ec4430..c2eb89498d72 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -16,6 +16,22 @@
 
 #define MAX_REGS	(1 + NFT_REG32_15 - NFT_REG32_00)
 
+#ifndef NETLINK_EXT_ACK
+#define NETLINK_EXT_ACK                 11
+
+enum nlmsgerr_attrs {
+	NLMSGERR_ATTR_UNUSED,
+	NLMSGERR_ATTR_MSG,
+	NLMSGERR_ATTR_OFFS,
+	NLMSGERR_ATTR_COOKIE,
+
+	__NLMSGERR_ATTR_MAX,
+	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
+};
+#define NLM_F_CAPPED	0x100	/* request was capped */
+#define NLM_F_ACK_TLVS	0x200	/* extended ACK TVLs were included */
+#endif
+
 struct netlink_parse_ctx {
 	struct list_head	*msgs;
 	struct table		*table;
@@ -176,6 +192,10 @@ struct netlink_mon_handler {
 
 extern int netlink_monitor(struct netlink_mon_handler *monhandler,
 			    struct mnl_socket *nf_sock);
+struct netlink_cb_data {
+	struct netlink_ctx	*nl_ctx;
+	struct list_head	*err_list;
+};
 int netlink_echo_callback(const struct nlmsghdr *nlh, void *data);
 
 struct ruleset_parse {
diff --git a/include/rule.h b/include/rule.h
index c232221e541b..ced63f3ea1b8 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -635,6 +635,8 @@ struct monitor {
 struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event);
 void monitor_free(struct monitor *m);
 
+#define NFT_NLATTR_LOC_MAX 8
+
 /**
  * struct cmd - command statement
  *
@@ -666,6 +668,11 @@ struct cmd {
 		struct markup	*markup;
 		struct obj	*object;
 	};
+	struct {
+		uint16_t	offset;
+		struct location	*location;
+	} attr[NFT_NLATTR_LOC_MAX];
+	int			num_attrs;
 	const void		*arg;
 };
 
@@ -678,6 +685,8 @@ extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct location *loc, struct obj *obj);
 extern void cmd_free(struct cmd *cmd);
 
+void cmd_add_loc(struct cmd *cmd, uint16_t offset, struct location *loc);
+
 #include <payload.h>
 #include <expression.h>
 
diff --git a/src/libnftables.c b/src/libnftables.c
index cd2fcf2fd522..eaa4736c397d 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -17,6 +17,25 @@
 #include <stdlib.h>
 #include <string.h>
 
+static void nft_error(struct netlink_ctx *ctx, struct cmd *cmd,
+		      struct mnl_err *err)
+{
+	struct location *loc = NULL;
+	int i;
+
+	for (i = 0; i < cmd->num_attrs; i++) {
+		if (!cmd->attr[i].offset)
+			break;
+		if (cmd->attr[i].offset == err->offset)
+			loc = cmd->attr[i].location;
+	}
+	if (!loc)
+		loc = &cmd->location;
+
+	netlink_io_error(ctx, loc, "Could not process rule: %s",
+			 strerror(err->err));
+}
+
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs,
 		       struct mnl_socket *nf_sock)
@@ -68,9 +87,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		list_for_each_entry(cmd, cmds, list) {
 			if (err->seqnum == cmd->seqnum ||
 			    err->seqnum == batch_seqnum) {
-				netlink_io_error(&ctx, &cmd->location,
-						 "Could not process rule: %s",
-						 strerror(err->err));
+				nft_error(&ctx, cmd, err);
 				errno = err->err;
 				if (err->seqnum == cmd->seqnum) {
 					mnl_err_list_free(err);
diff --git a/src/mnl.c b/src/mnl.c
index 340380ba6fef..d3518688b53b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -37,6 +37,7 @@
 struct mnl_socket *nft_mnl_socket_open(void)
 {
 	struct mnl_socket *nf_sock;
+	int one = 1;
 
 	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
 	if (!nf_sock)
@@ -45,6 +46,8 @@ struct mnl_socket *nft_mnl_socket_open(void)
 	if (fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK))
 		netlink_init_error();
 
+	mnl_socket_setsockopt(nf_sock, NETLINK_EXT_ACK, &one, sizeof(one));
+
 	return nf_sock;
 }
 
@@ -204,11 +207,13 @@ void mnl_batch_reset(struct nftnl_batch *batch)
 }
 
 static void mnl_err_list_node_add(struct list_head *err_list, int error,
-				  int seqnum)
+				  int seqnum, uint32_t offset,
+				  const char *errmsg)
 {
 	struct mnl_err *err = xmalloc(sizeof(struct mnl_err));
 
 	err->seqnum = seqnum;
+	err->offset = offset;
 	err->err = error;
 	list_add_tail(&err->head, err_list);
 }
@@ -305,6 +310,61 @@ static ssize_t mnl_nft_socket_sendmsg(struct netlink_ctx *ctx,
 	return sendmsg(mnl_socket_get_fd(ctx->nft->nf_sock), msg, 0);
 }
 
+static int err_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	uint16_t type;
+
+	if (mnl_attr_type_valid(attr, NLMSGERR_ATTR_MAX) < 0)
+		return MNL_CB_ERROR;
+
+	type = mnl_attr_get_type(attr);
+	switch (type) {
+	case NLMSGERR_ATTR_OFFS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			return MNL_CB_ERROR;
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int mnl_batch_extack_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct netlink_cb_data *cb_data = data;
+	struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
+	const struct nlmsgerr *err = mnl_nlmsg_get_payload(nlh);
+	unsigned int hlen = sizeof(*err);
+	const char *msg = NULL;
+	uint32_t off = 0;
+	int errval;
+
+	if (nlh->nlmsg_len < mnl_nlmsg_size(sizeof(struct nlmsgerr)))
+		return MNL_CB_ERROR;
+
+	if (err->error < 0)
+		errval = -err->error;
+	else
+		errval = err->error;
+
+	if (errval == 0)
+		return MNL_CB_STOP;
+
+	if (!(nlh->nlmsg_flags & NLM_F_CAPPED))
+		hlen += mnl_nlmsg_get_payload_len(&err->msg);
+
+	if (mnl_attr_parse(nlh, hlen, err_attr_cb, tb) != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	if (tb[NLMSGERR_ATTR_OFFS])
+		off = mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]);
+
+	mnl_err_list_node_add(cb_data->err_list, errval,
+			      nlh->nlmsg_seq, off, msg);
+	return MNL_CB_ERROR;
+}
+
 #define NFT_MNL_ECHO_RCVBUFF_DEFAULT	(MNL_SOCKET_BUFFER_SIZE * 1024)
 
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
@@ -326,6 +386,13 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	unsigned int rcvbufsiz;
 	size_t batch_size;
 	fd_set readfds;
+	static mnl_cb_t cb_ctl_array[NLMSG_MIN_TYPE] = {
+	        [NLMSG_ERROR] = mnl_batch_extack_cb,
+	};
+	struct netlink_cb_data cb_data = {
+		.err_list = err_list,
+		.nl_ctx = ctx,
+	};
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
 
@@ -361,13 +428,10 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		if (ret == -1)
 			return -1;
 
-		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
 		/* Continue on error, make sure we get all acknowledgments */
-		if (ret == -1) {
-			struct nlmsghdr *nlh = (struct nlmsghdr *)rcv_buf;
-
-			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
-		}
+		ret = mnl_cb_run2(rcv_buf, ret, 0, portid,
+				  netlink_echo_callback, &cb_data,
+				  cb_ctl_array, MNL_ARRAY_SIZE(cb_ctl_array));
 	}
 	return 0;
 }
@@ -624,7 +688,7 @@ int mnl_nft_chain_rename(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return 0;
 }
 
-int mnl_nft_chain_del(struct netlink_ctx *ctx, const struct cmd *cmd)
+int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nftnl_chain *nlc;
 	struct nlmsghdr *nlh;
@@ -634,18 +698,23 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 		memory_allocation_error();
 
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, cmd->handle.family);
-	nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, cmd->handle.table.name);
-	if (cmd->handle.chain.name)
-		nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME,
-				    cmd->handle.chain.name);
-	else if (cmd->handle.handle.id)
-		nftnl_chain_set_u64(nlc, NFTNL_CHAIN_HANDLE,
-				    cmd->handle.handle.id);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELCHAIN,
 				    cmd->handle.family,
 				    0, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
+	if (cmd->handle.chain.name) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.chain.location);
+		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
+	} else if (cmd->handle.handle.id) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		mnl_attr_put_u64(nlh, NFTA_CHAIN_HANDLE,
+				 htobe64(cmd->handle.handle.id));
+	}
+
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 	nftnl_chain_free(nlc);
 
@@ -734,7 +803,7 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return 0;
 }
 
-int mnl_nft_table_del(struct netlink_ctx *ctx, const struct cmd *cmd)
+int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nftnl_table *nlt;
 	struct nlmsghdr *nlh;
@@ -744,17 +813,20 @@ int mnl_nft_table_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 		memory_allocation_error();
 
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
-	if (cmd->handle.table.name)
-		nftnl_table_set_str(nlt, NFTNL_TABLE_NAME,
-				    cmd->handle.table.name);
-	else if (cmd->handle.handle.id)
-		nftnl_table_set_u64(nlt, NFTNL_TABLE_HANDLE,
-				    cmd->handle.handle.id);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELTABLE,
 				    cmd->handle.family,
 				    0, ctx->seqnum);
+
+	if (cmd->handle.table.name) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+		mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, cmd->handle.table.name);
+	} else if (cmd->handle.handle.id) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		mnl_attr_put_u64(nlh, NFTA_TABLE_NAME,
+				 htobe64(cmd->handle.handle.id));
+	}
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 	nftnl_table_free(nlt);
 
@@ -930,7 +1002,7 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return 0;
 }
 
-int mnl_nft_set_del(struct netlink_ctx *ctx, const struct cmd *cmd)
+int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	const struct handle *h = &cmd->handle;
 	struct nftnl_set *nls;
@@ -941,16 +1013,23 @@ int mnl_nft_set_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 		memory_allocation_error();
 
 	nftnl_set_set_u32(nls, NFTNL_SET_FAMILY, h->family);
-	nftnl_set_set_str(nls, NFTNL_SET_TABLE, h->table.name);
-	if (h->set.name)
-		nftnl_set_set_str(nls, NFTNL_SET_NAME, h->set.name);
-	else if (h->handle.id)
-		nftnl_set_set_u64(nls, NFTNL_SET_HANDLE, h->handle.id);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELSET,
 				    h->family,
 				    0, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_SET_TABLE, cmd->handle.table.name);
+	if (h->set.name) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.set.location);
+		mnl_attr_put_strz(nlh, NFTA_SET_NAME, cmd->handle.set.name);
+	} else if (h->handle.id) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		mnl_attr_put_u64(nlh, NFTA_SET_HANDLE,
+				 htobe64(cmd->handle.handle.id));
+	}
+
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 	nftnl_set_free(nls);
 
@@ -1115,7 +1194,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return 0;
 }
 
-int mnl_nft_obj_del(struct netlink_ctx *ctx, const struct cmd *cmd, int type)
+int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type)
 {
 	struct nftnl_obj *nlo;
 	struct nlmsghdr *nlh;
@@ -1125,16 +1204,24 @@ int mnl_nft_obj_del(struct netlink_ctx *ctx, const struct cmd *cmd, int type)
 		memory_allocation_error();
 
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_FAMILY, cmd->handle.family);
-	nftnl_obj_set_str(nlo, NFTNL_OBJ_TABLE, cmd->handle.table.name);
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_TYPE, type);
-	if (cmd->handle.obj.name)
-		nftnl_obj_set_str(nlo, NFTNL_OBJ_NAME, cmd->handle.obj.name);
-	else if (cmd->handle.handle.id)
-		nftnl_obj_set_u64(nlo, NFTNL_OBJ_HANDLE, cmd->handle.handle.id);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELOBJ, cmd->handle.family,
 				    0, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_OBJ_TABLE, cmd->handle.table.name);
+
+	if (cmd->handle.obj.name) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.obj.location);
+		mnl_attr_put_strz(nlh, NFTA_OBJ_NAME, cmd->handle.obj.name);
+	} else if (cmd->handle.handle.id) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		mnl_attr_put_u64(nlh, NFTA_OBJ_HANDLE,
+				 htobe64(cmd->handle.handle.id));
+	}
+
 	nftnl_obj_nlmsg_build_payload(nlh, nlo);
 	nftnl_obj_free(nlo);
 
@@ -1493,7 +1580,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return 0;
 }
 
-int mnl_nft_flowtable_del(struct netlink_ctx *ctx, const struct cmd *cmd)
+int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nftnl_flowtable *flo;
 	struct nlmsghdr *nlh;
@@ -1504,18 +1591,25 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FAMILY,
 				cmd->handle.family);
-	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_TABLE,
-				cmd->handle.table.name);
-	if (cmd->handle.flowtable.name)
-		nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_NAME,
-					cmd->handle.flowtable.name);
-	else if (cmd->handle.handle.id)
-		nftnl_flowtable_set_u64(flo, NFTNL_FLOWTABLE_HANDLE,
-				        cmd->handle.handle.id);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELFLOWTABLE, cmd->handle.family,
 				    0, ctx->seqnum);
+
+	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
+	mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_TABLE, cmd->handle.table.name);
+
+	if (cmd->handle.flowtable.name) {
+		cmd_add_loc(cmd, nlh->nlmsg_len,
+			    &cmd->handle.flowtable.location);
+		mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_NAME,
+				  cmd->handle.flowtable.name);
+	} else if (cmd->handle.handle.id) {
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.handle.location);
+		mnl_attr_put_u64(nlh, NFTA_FLOWTABLE_HANDLE,
+				 htobe64(cmd->handle.handle.id));
+	}
+
 	nftnl_flowtable_nlmsg_build_payload(nlh, flo);
 	nftnl_flowtable_free(flo);
 
diff --git a/src/monitor.c b/src/monitor.c
index 142cc929664f..bb269c02950c 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -906,7 +906,8 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 
 int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 {
-	struct netlink_ctx *ctx = data;
+	struct netlink_cb_data *nl_cb_data = data;
+	struct netlink_ctx *ctx = nl_cb_data->nl_ctx;
 	struct netlink_mon_handler echo_monh = {
 		.format = NFTNL_OUTPUT_DEFAULT,
 		.ctx = ctx,
diff --git a/src/rule.c b/src/rule.c
index 337a66bbd5fa..9307dad54b6f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1377,6 +1377,14 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	return cmd;
 }
 
+void cmd_add_loc(struct cmd *cmd, uint16_t offset, struct location *loc)
+{
+	assert(cmd->num_attrs < NFT_NLATTR_LOC_MAX);
+	cmd->attr[cmd->num_attrs].offset = offset;
+	cmd->attr[cmd->num_attrs].location = loc;
+	cmd->num_attrs++;
+}
+
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
-- 
2.11.0

