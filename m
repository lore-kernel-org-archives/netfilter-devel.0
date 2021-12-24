Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B02C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 15:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353080AbhLXPoE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 10:44:04 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44504 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353090AbhLXPoD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 10:44:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 320AB63101
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 16:41:26 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 4/4] conntrack: pass sock to nfct_mnl_*() functions
Date:   Fri, 24 Dec 2021 16:43:51 +0100
Message-Id: <20211224154351.360124-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211224154351.360124-1-pablo@netfilter.org>
References: <20211224154351.360124-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>

In preparation for using multiple instances of mnl sockets
required for conntrack entries update and delete support.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 115 ++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 53 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index fe604ff2efd4..fe5574d205a6 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -71,7 +71,7 @@
 static struct nfct_mnl_socket {
 	struct mnl_socket	*mnl;
 	uint32_t		portid;
-} sock;
+} _sock;
 
 struct u32_mask {
 	uint32_t value;
@@ -1725,7 +1725,7 @@ event_sighandler(int s)
 
 	fprintf(stderr, "%s v%s (conntrack-tools): ", PROGNAME, VERSION);
 	fprintf(stderr, "%d flow events have been shown.\n", counter);
-	mnl_socket_close(sock.mnl);
+	mnl_socket_close(_sock.mnl);
 	exit(0);
 }
 
@@ -2399,18 +2399,19 @@ out_err:
 	return ret;
 }
 
-static int nfct_mnl_socket_open(unsigned int events)
+static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
+		      unsigned int events)
 {
-	sock.mnl = mnl_socket_open(NETLINK_NETFILTER);
-	if (sock.mnl == NULL) {
+	socket->mnl = mnl_socket_open(NETLINK_NETFILTER);
+	if (socket->mnl == NULL) {
 		perror("mnl_socket_open");
 		return -1;
 	}
-	if (mnl_socket_bind(sock.mnl, events, MNL_SOCKET_AUTOPID) < 0) {
+	if (mnl_socket_bind(socket->mnl, events, MNL_SOCKET_AUTOPID) < 0) {
 		perror("mnl_socket_bind");
 		return -1;
 	}
-	sock.portid = mnl_socket_get_portid(sock.mnl);
+	socket->portid = mnl_socket_get_portid(socket->mnl);
 
 	return 0;
 }
@@ -2435,36 +2436,38 @@ nfct_mnl_nlmsghdr_put(char *buf, uint16_t subsys, uint16_t type,
 	return nlh;
 }
 
-static void nfct_mnl_socket_close(void)
+static void nfct_mnl_socket_close(const struct nfct_mnl_socket *sock)
 {
-	mnl_socket_close(sock.mnl);
+	mnl_socket_close(sock->mnl);
 }
 
-static int nfct_mnl_recv(const struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
+static int nfct_mnl_recv(struct nfct_mnl_socket *sock,
+			 const struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int res;
 
-	res = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
+	res = mnl_socket_sendto(sock->mnl, nlh, nlh->nlmsg_len);
 	if (res < 0)
 		return res;
 
-	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+	res = mnl_socket_recvfrom(sock->mnl, buf, sizeof(buf));
 	while (res > 0) {
-		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid,
+		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock->portid,
 				 cb, data);
 		if (res <= MNL_CB_STOP)
 			break;
 
-		res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+		res = mnl_socket_recvfrom(sock->mnl, buf, sizeof(buf));
 	}
 
 	return res;
 }
 
 static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
-	      struct ct_cmd *cmd, const struct nfct_filter_dump *filter_dump)
+nfct_mnl_dump(struct nfct_mnl_socket *sock, uint16_t subsys, uint16_t type,
+	      mnl_cb_t cb, struct ct_cmd *cmd,
+	      const struct nfct_filter_dump *filter_dump)
 {
 	uint8_t family = cmd ? cmd->family : AF_UNSPEC;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -2475,38 +2478,41 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
 	if (filter_dump)
 		nfct_nlmsg_build_filter(nlh, filter_dump);
 
-	return nfct_mnl_recv(nlh, cb, cmd);
+	return nfct_mnl_recv(sock, nlh, cb, cmd);
 }
 
-static int nfct_mnl_talk(const struct nlmsghdr *nlh, mnl_cb_t cb)
+static int nfct_mnl_talk(struct nfct_mnl_socket *sock,
+			 const struct nlmsghdr *nlh, mnl_cb_t cb)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int ret;
 
-	ret = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
+	ret = mnl_socket_sendto(sock->mnl, nlh, nlh->nlmsg_len);
 	if (ret < 0)
 		return ret;
 
-	ret = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+	ret = mnl_socket_recvfrom(sock->mnl, buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 
-	return mnl_cb_run(buf, ret, nlh->nlmsg_seq, sock.portid, cb, NULL);
+	return mnl_cb_run(buf, ret, nlh->nlmsg_seq, sock->portid, cb, NULL);
 }
 
 static int
-nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+nfct_mnl_get(struct nfct_mnl_socket *sock, uint16_t subsys, uint16_t type,
+	     mnl_cb_t cb, uint8_t family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, 0, family);
 
-	return nfct_mnl_talk(nlh, cb);
+	return nfct_mnl_talk(sock, nlh, cb);
 }
 
 static int
-nfct_mnl_create(uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
+nfct_mnl_create(struct nfct_mnl_socket *sock, uint16_t subsys, uint16_t type,
+		const struct nf_conntrack *ct)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -2520,7 +2526,7 @@ nfct_mnl_create(uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
 	if (err < 0)
 		return err;
 
-	return nfct_mnl_talk(nlh, NULL, NULL);
+	return nfct_mnl_talk(sock, nlh, NULL);
 }
 
 #define UNKNOWN_STATS_NUM 4
@@ -3246,25 +3252,26 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 {
+	struct nfct_mnl_socket *sock = &_sock;
 	struct nfct_filter_dump *filter_dump;
 	int res = 0;
 
 	switch(cmd->command) {
 	case CT_LIST:
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		if (cmd->type == CT_TABLE_DYING) {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close();
+			nfct_mnl_socket_close(sock);
 			break;
 		} else if (cmd->type == CT_TABLE_UNCONFIRMED) {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close();
+			nfct_mnl_socket_close(sock);
 			break;
 		}
 
@@ -3293,11 +3300,11 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 						  &cmd->tmpl.filter_status_kernel);
 		}
 		if (cmd->options & CT_OPT_ZERO) {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_CTRZERO,
 					    mnl_nfct_dump_cb, cmd, filter_dump);
 		} else {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET,
 					    mnl_nfct_dump_cb, cmd, filter_dump);
 		}
@@ -3309,7 +3316,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			fflush(stdout);
 		}
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_LIST:
@@ -3340,16 +3347,16 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
-		res = nfct_mnl_socket_open(0);
+		res = nfct_mnl_socket_open(sock, 0);
 		if (res < 0)
 			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
-		res = nfct_mnl_create(NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_NEW,
-				      cmd->tmpl.ct);
+		res = nfct_mnl_create(sock, NFNL_SUBSYS_CTNETLINK,
+				      IPCTNL_MSG_CT_NEW, cmd->tmpl.ct);
 		if (res >= 0)
 			counter++;
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_CREATE:
@@ -3476,9 +3483,10 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
 
-			res = nfct_mnl_socket_open(nl_events);
+			res = nfct_mnl_socket_open(sock, nl_events);
 		} else {
-			res = nfct_mnl_socket_open(NF_NETLINK_CONNTRACK_NEW |
+			res = nfct_mnl_socket_open(sock,
+						   NF_NETLINK_CONNTRACK_NEW |
 						   NF_NETLINK_CONNTRACK_UPDATE |
 						   NF_NETLINK_CONNTRACK_DESTROY);
 		}
@@ -3491,17 +3499,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 			socklen_t socklen = sizeof(socketbuffersize);
 
-			res = setsockopt(mnl_socket_get_fd(sock.mnl),
+			res = setsockopt(mnl_socket_get_fd(sock->mnl),
 					 SOL_SOCKET, SO_RCVBUFFORCE,
 					 &socketbuffersize,
 					 sizeof(socketbuffersize));
 			if (res < 0) {
-				setsockopt(mnl_socket_get_fd(sock.mnl),
+				setsockopt(mnl_socket_get_fd(sock->mnl),
 					   SOL_SOCKET, SO_RCVBUF,
 					   &socketbuffersize,
 					   sizeof(socketbuffersize));
 			}
-			getsockopt(mnl_socket_get_fd(sock.mnl), SOL_SOCKET,
+			getsockopt(mnl_socket_get_fd(sock->mnl), SOL_SOCKET,
 				   SO_RCVBUF, &socketbuffersize, &socklen);
 			fprintf(stderr, "NOTICE: Netlink socket buffer size "
 					"has been set to %zu bytes.\n",
@@ -3516,7 +3524,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		while (1) {
 			char buf[MNL_SOCKET_BUFFER_SIZE];
 
-			res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+			res = mnl_socket_recvfrom(sock->mnl, buf, sizeof(buf));
 			if (res < 0) {
 				if (errno == ENOBUFS) {
 					fprintf(stderr,
@@ -3535,7 +3543,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			}
 			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
 		}
-		mnl_socket_close(sock.mnl);
+		mnl_socket_close(sock->mnl);
 		break;
 
 	case EXP_EVENT:
@@ -3569,14 +3577,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(sock, 0) < 0)
 			goto try_proc_count;
 
-		res = nfct_mnl_get(NFNL_SUBSYS_CTNETLINK,
+		res = nfct_mnl_get(sock,
+				   NFNL_SUBSYS_CTNETLINK,
 				   IPCTNL_MSG_CT_GET_STATS,
 				   nfct_global_stats_cb, AF_UNSPEC);
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(sock);
 
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
@@ -3614,14 +3623,14 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(sock, 0) < 0)
 			goto try_proc;
 
-		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+		res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
 				    nfct_stats_cb, NULL, NULL);
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(sock);
 
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
@@ -3633,14 +3642,14 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(sock, 0) < 0)
 			goto try_proc;
 
-		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK_EXP,
+		res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
 				    nfexp_stats_cb, NULL, NULL);
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(sock);
 
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
-- 
2.30.2

