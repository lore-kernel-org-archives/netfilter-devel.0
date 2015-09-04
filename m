From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] mnl: rework netlink socket event receive path
Date: Fri,  4 Sep 2015 18:53:04 +0200
Message-ID: <1441385584-7836-2-git-send-email-pablo@netfilter.org>
References: <1441385584-7836-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33913 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760293AbbIDQqk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Sep 2015 12:46:40 -0400
In-Reply-To: <1441385584-7836-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch reworks two aspects of the netlink socket event receive path:

1) In case of ENOBUFS, stay in the loop to keep receiving messages. The tool
   displays a message so the user knows that we got lost event messages.

2) Rise the default size of the receive socket buffer up to 16 MBytes to reduce
   chances of hitting ENOBUFS. Asumming that the netlink event message size is
   ~150 bytes, we can bear with ~111848 rules without message loss.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 76a9714..4795706 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -23,6 +23,7 @@
 
 #include <mnl.h>
 #include <string.h>
+#include <sys/socket.h>
 #include <arpa/inet.h>
 #include <errno.h>
 #include <utils.h>
@@ -966,11 +967,46 @@ err:
 /*
  * events
  */
+#define NFTABLES_NLEVENT_BUFSIZ	(1 << 24)
+
 int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data)
 {
-	return nft_mnl_recv(nf_sock, 0, 0, cb, cb_data);
+	/* Set netlink socket buffer size to 16 Mbytes to reduce chances of
+ 	 * message loss due to ENOBUFS.
+	 */
+	unsigned int bufsiz = NFTABLES_NLEVENT_BUFSIZ;
+	char buf[NFT_NLMSG_MAXSIZE];
+	int ret;
+
+	ret = setsockopt(mnl_socket_get_fd(nf_sock), SOL_SOCKET, SO_RCVBUFFORCE,
+			 &bufsiz, sizeof(socklen_t));
+        if (ret < 0) {
+		/* If this doesn't work, try to reach the system wide maximum
+		 * (or whatever the user requested).
+		 */
+                ret = setsockopt(mnl_socket_get_fd(nf_sock), SOL_SOCKET,
+				 SO_RCVBUF, &bufsiz, sizeof(socklen_t));
+		printf("# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
+		       NFTABLES_NLEVENT_BUFSIZ, bufsiz);
+	}
+
+	while (1) {
+		ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+		if (ret < 0) {
+			if (errno == ENOBUFS) {
+				printf("# ERROR: We lost some netlink events!\n");
+				continue;
+			}
+			fprintf(stdout, "# ERROR: %s\n", strerror(errno));
+			break;
+		}
+		ret = mnl_cb_run(buf, ret, 0, 0, cb, cb_data);
+		if (ret <= 0)
+			break;
+	}
+	return ret;
 }
 
 static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
-- 
1.7.10.4

