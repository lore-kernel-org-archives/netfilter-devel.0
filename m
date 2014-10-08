From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH xtables-compat 2/4] iptables-compat: nft: fix error reporting
Date: Wed,  8 Oct 2014 22:17:49 +0200
Message-ID: <1412799471-7721-2-git-send-email-pablo@netfilter.org>
References: <1412799471-7721-1-git-send-email-pablo@netfilter.org>
Cc: giuseppelng@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48382 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaJHUQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:16:33 -0400
In-Reply-To: <1412799471-7721-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes

 # iptables-compat -X test4345
 iptables: No chain/target/match by that name.

 # iptables-compat -N test4345
 # iptables-compat -N test4345
 iptables: File exists.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index ad4e5f9..6686a9b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -187,17 +187,6 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 	return ret;
 }
 
-static int cb_err(const struct nlmsghdr *nlh, void *data)
-{
-	/* We can provide better error reporting than iptables-restore */
-	errno = EINVAL;
-	return MNL_CB_ERROR;
-}
-
-static mnl_cb_t cb_ctl_array[NLMSG_MIN_TYPE] = {
-	[NLMSG_ERROR] = cb_err,
-};
-
 static int mnl_nft_batch_talk(struct nft_handle *h)
 {
 	int ret, fd = mnl_socket_get_fd(h->nl);
@@ -226,11 +215,11 @@ static int mnl_nft_batch_talk(struct nft_handle *h)
 		if (ret == -1)
 			return -1;
 
-		ret = mnl_cb_run2(rcv_buf, ret, 0, h->portid,
-				  NULL, NULL, cb_ctl_array,
-				  MNL_ARRAY_SIZE(cb_ctl_array));
-		/* Continue on error, make sure we get all acknoledgments */
-		if (ret == -1)
+		ret = mnl_cb_run(rcv_buf, ret, 0, h->portid, NULL, NULL);
+		/* Annotate first error and continue, make sure we get all
+		 * acknoledgments.
+		 */
+		if (!err && ret == -1)
 			err = errno;
 
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
@@ -240,6 +229,7 @@ static int mnl_nft_batch_talk(struct nft_handle *h)
 		FD_ZERO(&readfds);
 		FD_SET(fd, &readfds);
 	}
+	errno = err;
 	return err ? -1 : 0;
 }
 
-- 
1.7.10.4

