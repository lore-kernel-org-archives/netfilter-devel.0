From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/4] examples/nf-queue: handle recv error, use larger buffer
Date: Fri, 26 Apr 2013 10:33:29 +0200
Message-ID: <1366965211-23412-3-git-send-email-fw@strlen.de>
References: <1366965211-23412-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48574 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932477Ab3DZIb0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:31:26 -0400
In-Reply-To: <1366965211-23412-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We ask for 0xffff copy size, so we need a buffer that can
hold 0xffff, plus a few more bytes to allow for netlink attributes.

Also, turn off ENOBUFS.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 examples/nf-queue.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 7adac21..6641a24 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -1,3 +1,4 @@
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -82,7 +83,9 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 
 int main(int argc, char *argv[])
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	char *buf;
+	/* largest possible packet payload, plus netlink data overhead: */
+	size_t sizeof_buf = 0xffff + (MNL_SOCKET_BUFFER_SIZE/2);
 	struct nlmsghdr *nlh;
 	int ret;
 	unsigned int portid, queue_num;
@@ -105,6 +108,12 @@ int main(int argc, char *argv[])
 	}
 	portid = mnl_socket_get_portid(nl);
 
+	buf = malloc(sizeof_buf);
+	if (!buf) {
+		perror("allocate receive buffer");
+		exit(EXIT_FAILURE);
+	}
+
 	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
 	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_UNBIND);
 
@@ -137,23 +146,25 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	if (ret == -1) {
-		perror("mnl_socket_recvfrom");
-		exit(EXIT_FAILURE);
-	}
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
-		if (ret < 0){
-			perror("mnl_cb_run");
-			exit(EXIT_FAILURE);
-		}
+	/* ENOBUFS is signalled to userspace when packets were lost
+	 * on kernel side.  In most cases, userspace isn't interested
+	 * in this information, so turn it off.
+	 */
+	ret = 1;
+	mnl_socket_setsockopt(nl, NETLINK_NO_ENOBUFS, &ret, sizeof(int));
 
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	for (;;) {
+		ret = mnl_socket_recvfrom(nl, buf, sizeof_buf);
 		if (ret == -1) {
 			perror("mnl_socket_recvfrom");
 			exit(EXIT_FAILURE);
 		}
+
+		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
+		if (ret < 0){
+			perror("mnl_cb_run");
+			exit(EXIT_FAILURE);
+		}
 	}
 
 	mnl_socket_close(nl);
-- 
1.7.8.6

