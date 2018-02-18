From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] nftables: basic support for extended netlink errors
Date: Sun, 18 Feb 2018 10:44:18 +0100
Message-ID: <20180218094418.23530-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56770 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751295AbeBRJpZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Feb 2018 04:45:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Recent kernels gained ability to emit error string back to userspace to
improve error reporting.

At this time, as nftables kernel side doesn't generate such error
messages, so this will always show 'unknown netlink error'.
This will hopefully improve with newer kernels.

src/nft add rule ip filter input set add ip protocol @protocols
Error: Could not process rule: Invalid argument (unknown netlink error)

the -EINVAL stems from attempt to modify set from packet path,
but kernel picked a set backend that lacks an ->update()
facilty.  Fixing this would obviously result in the command to succeed.
However, given similar future bugs, kernel might have told us something
like 'expression failed inititialisation' or 'set lacks update
callback', which is much more helpful for developers to pinpoint the
place where netlink processing failed on nftables kernel side.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v1:
  don't return error on 'nft flush ruleset' and the like.
  v1 used 'errno' instead of passing errmsg->error.

 include/mnl.h     |  2 ++
 include/netlink.h | 20 +++++++++++++
 src/libnftables.c |  4 +--
 src/mnl.c         | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 src/netlink.c     |  6 +++-
 5 files changed, 108 insertions(+), 10 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 4662cd04df9b..b8cee1fa1f51 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -15,6 +15,8 @@ struct mnl_err {
 	struct list_head	head;
 	int			err;
 	uint32_t		seqnum;
+	uint32_t		offset;
+	char			*kern_errmsg;
 };
 
 void mnl_err_list_free(struct mnl_err *err);
diff --git a/include/netlink.h b/include/netlink.h
index 66686e5a3313..b4c1a45099f6 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -13,6 +13,22 @@
 
 #include <rule.h>
 
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
@@ -223,6 +239,10 @@ extern int netlink_monitor(struct netlink_mon_handler *monhandler,
 			    struct mnl_socket *nf_sock);
 bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum);
 
+struct netlink_cb_data {
+	struct netlink_ctx	*nl_ctx;
+	struct list_head	*err_list;
+};
 int netlink_echo_callback(const struct nlmsghdr *nlh, void *data);
 
 struct ruleset_parse {
diff --git a/src/libnftables.c b/src/libnftables.c
index c86d89477e77..aa0eb899cdf1 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -61,8 +61,8 @@ static int nft_netlink(struct nft_ctx *nft,
 			if (err->seqnum == cmd->seqnum ||
 			    err->seqnum == batch_seqnum) {
 				netlink_io_error(&ctx, &cmd->location,
-						 "Could not process rule: %s",
-						 strerror(err->err));
+						 "Could not process rule: %s (%s)",
+						 strerror(err->err), err->kern_errmsg);
 				errno = err->err;
 				if (err->seqnum == cmd->seqnum) {
 					mnl_err_list_free(err);
diff --git a/src/mnl.c b/src/mnl.c
index 5587e1589cda..2bfd4059467e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -174,18 +174,24 @@ void mnl_batch_reset(struct nftnl_batch *batch)
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
+	if (!errmsg)
+		errmsg = "unknown netlink error";
+	err->kern_errmsg = xstrdup(errmsg);
 	list_add_tail(&err->head, err_list);
 }
 
 void mnl_err_list_free(struct mnl_err *err)
 {
 	list_del(&err->head);
+	xfree(err->kern_errmsg);
 	xfree(err);
 }
 
@@ -238,6 +244,67 @@ static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
 	return sendmsg(mnl_socket_get_fd(ctx->nf_sock), &msg, 0);
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
+	case NLMSGERR_ATTR_MSG:
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
+			return MNL_CB_ERROR;
+		break;
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
+	if (tb[NLMSGERR_ATTR_MSG])
+		msg = mnl_attr_get_str(tb[NLMSGERR_ATTR_MSG]);
+	if (tb[NLMSGERR_ATTR_OFFS])
+		off = mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]);
+
+	mnl_err_list_node_add(cb_data->err_list, errval,
+			      nlh->nlmsg_seq, off, msg);
+	return MNL_CB_ERROR;
+}
+
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 {
 	struct mnl_socket *nl = ctx->nf_sock;
@@ -249,6 +316,13 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		.tv_usec	= 0
 	};
 	int err = 0;
+	static mnl_cb_t cb_ctl_array[NLMSG_MIN_TYPE] = {
+	        [NLMSG_ERROR] = mnl_batch_extack_cb,
+	};
+	struct netlink_cb_data cb_data = {
+		.err_list = err_list,
+		.nl_ctx = ctx,
+	};
 
 	ret = mnl_nft_socket_sendmsg(ctx);
 	if (ret == -1)
@@ -263,18 +337,16 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		return -1;
 
 	while (ret > 0 && FD_ISSET(fd, &readfds)) {
-		struct nlmsghdr *nlh = (struct nlmsghdr *)rcv_buf;
-
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
 		if (ret == -1)
 			return -1;
 
-		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
+		ret = mnl_cb_run2(rcv_buf, ret, 0, portid,
+				  netlink_echo_callback, &cb_data,
+				  cb_ctl_array, MNL_ARRAY_SIZE(cb_ctl_array));
 		/* Continue on error, make sure we get all acknowledgments */
-		if (ret == -1) {
-			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
+		if (ret == -1)
 			err = -1;
-		}
 
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
 		if (ret == -1)
diff --git a/src/netlink.c b/src/netlink.c
index 233bfd2df764..f4f9c161c829 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -54,6 +54,7 @@ const struct location netlink_location = {
 struct mnl_socket *netlink_open_sock(void)
 {
 	struct mnl_socket *nf_sock;
+	int one = 1;
 
 	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
 	if (nf_sock == NULL)
@@ -61,6 +62,8 @@ struct mnl_socket *netlink_open_sock(void)
 
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
 
+	mnl_socket_setsockopt(nf_sock, NETLINK_EXT_ACK, &one, sizeof(one));
+
 	return nf_sock;
 }
 
@@ -3001,7 +3004,8 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 
 int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 {
-	struct netlink_ctx *ctx = data;
+	struct netlink_cb_data *cb_data = data;
+	struct netlink_ctx *ctx = cb_data->nl_ctx;
 	struct netlink_mon_handler echo_monh = {
 		.format = NFTNL_OUTPUT_DEFAULT,
 		.ctx = ctx,
-- 
2.16.1

