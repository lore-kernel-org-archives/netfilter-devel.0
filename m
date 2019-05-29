Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DBDC28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 529E5205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfE2NOF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 09:14:05 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40274 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfE2NOF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 09:14:05 -0400
Received: from localhost ([::1]:53362 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVyP5-0006ws-Tn; Wed, 29 May 2019 15:14:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH 1/4] mnl: Maximize socket receive buffer by default
Date:   Wed, 29 May 2019 15:13:43 +0200
Message-Id: <20190529131346.23659-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529131346.23659-1-phil@nwl.cc>
References: <20190529131346.23659-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With --echo option, regular commands may receive large replies just like
'nft monitor' does. Avoid buffer overruns and message loss by maximizing
the global nf_sock's receive buffer size upon creating, not just when
calling mnl_nft_event_listener.

Error reporting is tricky in nft_mnl_socket_open(), also being warned
about failures during receive buffer increase adds little value to the
user. So just fail silently instead.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 9bb712adfa3b5..2c5a26a5e3465 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -33,6 +33,26 @@
 #include <utils.h>
 #include <nftables.h>
 
+#define NFTABLES_NLEVENT_BUFSIZ	(1 << 24)
+
+static void maximize_recv_buffer(struct mnl_socket *nf_sock)
+{
+	unsigned int bufsiz = NFTABLES_NLEVENT_BUFSIZ;
+	int fd = mnl_socket_get_fd(nf_sock);
+
+	/* Set netlink socket buffer size to 16 Mbytes to reduce chances of
+	 * message loss due to ENOBUFS.
+	 */
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE,
+		       &bufsiz, sizeof(socklen_t)) < 0) {
+		/* If this doesn't work, try to reach the system wide maximum
+		 * (or whatever the user requested).
+		 */
+		setsockopt(fd, SOL_SOCKET, SO_RCVBUF,
+			   &bufsiz, sizeof(socklen_t));
+	}
+}
+
 struct mnl_socket *nft_mnl_socket_open(void)
 {
 	struct mnl_socket *nf_sock;
@@ -44,6 +64,7 @@ struct mnl_socket *nft_mnl_socket_open(void)
 	if (fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK))
 		netlink_init_error();
 
+	maximize_recv_buffer(nf_sock);
 	return nf_sock;
 }
 
@@ -1379,37 +1400,17 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 /*
  * events
  */
-#define NFTABLES_NLEVENT_BUFSIZ	(1 << 24)
 
 int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 			   struct output_ctx *octx,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data)
 {
-	/* Set netlink socket buffer size to 16 Mbytes to reduce chances of
- 	 * message loss due to ENOBUFS.
-	 */
-	unsigned int bufsiz = NFTABLES_NLEVENT_BUFSIZ;
 	int fd = mnl_socket_get_fd(nf_sock);
 	char buf[NFT_NLMSG_MAXSIZE];
 	fd_set readfds;
 	int ret;
 
-	ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &bufsiz,
-			 sizeof(socklen_t));
-	if (ret < 0) {
-		/* If this doesn't work, try to reach the system wide maximum
-		 * (or whatever the user requested).
-		 */
-		ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &bufsiz,
-				 sizeof(socklen_t));
-		if (ret < 0)
-			nft_print(octx, "# Cannot increase netlink socket buffer size, expect message loss\n");
-		else
-			nft_print(octx, "# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
-				  NFTABLES_NLEVENT_BUFSIZ, bufsiz);
-	}
-
 	while (1) {
 		FD_ZERO(&readfds);
 		FD_SET(fd, &readfds);
-- 
2.21.0

