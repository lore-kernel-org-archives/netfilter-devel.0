From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] src: netlink: Remove variable nf_mon_sock.
Date: Wed, 19 Jul 2017 18:04:07 +0530
Message-ID: <596f51c4.c744620a.84997.9346@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33909 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753249AbdGSMeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 08:34:14 -0400
Received: by mail-pf0-f196.google.com with SMTP id o88so6254137pfk.1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 05:34:14 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove variable nf_mon_sock of type structure mnl_socket to avoid
duplicity. Instead variable nf_sock of the same type is passed as
argument to netlink_monitor(). Also remove netlink_open_mon_sock()
function definition, which is no longer required.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/netlink.h |  3 ++-
 src/mnl.c         | 34 +++++++++++++++++++++++++---------
 src/netlink.c     | 33 ++++++++++++++++-----------------
 src/rule.c        |  2 +-
 4 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 5b43c5c..7865186 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -218,7 +218,8 @@ struct netlink_mon_handler {
 	bool			cache_needed;
 };
 
-extern int netlink_monitor(struct netlink_mon_handler *monhandler);
+extern int netlink_monitor(struct netlink_mon_handler *monhandler,
+			    struct mnl_socket *nf_sock);
 bool netlink_batch_supported(struct mnl_socket *nf_sock);
 
 #endif /* NFTABLES_NETLINK_H */
diff --git a/src/mnl.c b/src/mnl.c
index cf060a4..b7a96dd 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1116,28 +1116,44 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 	unsigned int bufsiz = NFTABLES_NLEVENT_BUFSIZ;
 	char buf[NFT_NLMSG_MAXSIZE];
 	int ret;
+	struct timeval tv = {
+		.tv_sec = 0,
+		.tv_usec = 0
+	};
 
 	ret = setsockopt(mnl_socket_get_fd(nf_sock), SOL_SOCKET, SO_RCVBUFFORCE,
 			 &bufsiz, sizeof(socklen_t));
-        if (ret < 0) {
+	if (ret < 0) {
 		/* If this doesn't work, try to reach the system wide maximum
 		 * (or whatever the user requested).
 		 */
-                ret = setsockopt(mnl_socket_get_fd(nf_sock), SOL_SOCKET,
+		ret = setsockopt(mnl_socket_get_fd(nf_sock), SOL_SOCKET,
 				 SO_RCVBUF, &bufsiz, sizeof(socklen_t));
 		printf("# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
 		       NFTABLES_NLEVENT_BUFSIZ, bufsiz);
 	}
 
 	while (1) {
-		ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
-		if (ret < 0) {
-			if (errno == ENOBUFS) {
-				printf("# ERROR: We lost some netlink events!\n");
-				continue;
+		int fd = mnl_socket_get_fd(nf_sock);
+		fd_set readfds;
+
+		FD_ZERO(&readfds);
+		FD_SET(fd, &readfds);
+
+		ret = select(fd+1, &readfds, NULL, NULL, &tv);
+		if (ret < 0)
+			return -1;
+
+		if (FD_ISSET(fd, &readfds)) {
+			ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+			if (ret < 0) {
+				if (errno == ENOBUFS) {
+					printf("# ERROR: We lost some netlink events!\n");
+					continue;
+				}
+				fprintf(stdout, "# ERROR: %s\n", strerror(errno));
+				break;
 			}
-			fprintf(stdout, "# ERROR: %s\n", strerror(errno));
-			break;
 		}
 
 #ifdef DEBUG
diff --git a/src/netlink.c b/src/netlink.c
index e3c90da..d5d3c73 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -39,8 +39,6 @@
 #include <erec.h>
 #include <iface.h>
 
-static struct mnl_socket *nf_mon_sock;
-
 const struct input_descriptor indesc_netlink = {
 	.name	= "netlink",
 	.type	= INDESC_NETLINK,
@@ -73,8 +71,6 @@ void netlink_close_sock(struct mnl_socket *nf_sock)
 {
 	if (nf_sock)
 		mnl_socket_close(nf_sock);
-	if (nf_mon_sock)
-		mnl_socket_close(nf_mon_sock);
 }
 
 void netlink_restart(struct mnl_socket *nf_sock)
@@ -88,11 +84,6 @@ void netlink_genid_get(struct mnl_socket *nf_sock)
 	mnl_genid_get(nf_sock);
 }
 
-static void netlink_open_mon_sock(void)
-{
-	nf_mon_sock = nfsock_open();
-}
-
 void __noreturn __netlink_abi_error(const char *file, int line,
 				    const char *reason)
 {
@@ -2961,18 +2952,26 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	return ret;
 }
 
-int netlink_monitor(struct netlink_mon_handler *monhandler)
+int netlink_monitor(struct netlink_mon_handler *monhandler,
+		     struct mnl_socket *nf_sock)
 {
-	netlink_open_mon_sock();
+	int group;
 
-	if (mnl_socket_bind(nf_mon_sock, (1 << (NFNLGRP_NFTABLES-1)) |
-					 (1 << (NFNLGRP_NFTRACE-1)),
-			    MNL_SOCKET_AUTOPID) < 0)
+	group = NFNLGRP_NFTABLES;
+	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
+				  sizeof(int)) < 0)
 		return netlink_io_error(monhandler->ctx, monhandler->loc,
-					"Could not bind to netlink socket %s",
-					strerror(errno));
+				"Could not bind to netlink socket %s",
+				strerror(errno));
+
+	group = NFNLGRP_NFTRACE;
+	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
+				  sizeof(int)) < 0)
+		return netlink_io_error(monhandler->ctx, monhandler->loc,
+				"Could not bind to netlink socket %s",
+				strerror(errno));
 
-	return mnl_nft_event_listener(nf_mon_sock, netlink_events_cb,
+	return mnl_nft_event_listener(nf_sock, netlink_events_cb,
 				      monhandler);
 }
 
diff --git a/src/rule.c b/src/rule.c
index 1d89feb..7f83980 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1659,7 +1659,7 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 	monhandler.ctx = ctx;
 	monhandler.loc = &cmd->location;
 
-	return netlink_monitor(&monhandler);
+	return netlink_monitor(&monhandler, ctx->nf_sock);
 }
 
 static int do_command_describe(struct netlink_ctx *ctx, struct cmd *cmd)
-- 
2.9.4

