From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 01/18] mnl: fix error handling in mnl_batch_talk
Date: Sat, 19 Aug 2017 17:24:03 +0200
Message-ID: <20170819152420.22563-2-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33578 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751153AbdHSPYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:24:32 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If one of the command is failing we should return an error.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/mnl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index b0f5191..661ecbc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -245,6 +245,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
 
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 {
+	int rc = 0;
 	struct mnl_socket *nl = ctx->nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
@@ -275,8 +276,10 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 
 		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
 		/* Continue on error, make sure we get all acknowledgments */
-		if (ret == -1)
+		if (ret == -1) {
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
+			rc = -1;
+		}
 
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
 		if (ret == -1)
@@ -285,7 +288,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		FD_ZERO(&readfds);
 		FD_SET(fd, &readfds);
 	}
-	return ret;
+	return rc;
 }
 
 int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, struct nftnl_batch *batch,
-- 
2.14.1

