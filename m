From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-compat 2/2] iptables-compat: fix use after free in the batch send path
Date: Tue, 30 Sep 2014 19:35:46 +0200
Message-ID: <1412098546-8952-2-git-send-email-pablo@netfilter.org>
References: <1412098546-8952-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53306 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaI3Ren (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:34:43 -0400
In-Reply-To: <1412098546-8952-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Release the batch pages once they have been sent via sendmsg().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 8c91e99..a4cea22 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -142,6 +142,18 @@ static void mnl_nft_set_sndbuffer(const struct mnl_socket *nl)
 	nlbuffsiz = newbuffsiz;
 }
 
+static void mnl_nft_batch_reset(void)
+{
+	struct batch_page *batch_page, *next;
+
+	list_for_each_entry_safe(batch_page, next, &batch_page_list, head) {
+		list_del(&batch_page->head);
+		free(batch_page->batch);
+		free(batch_page);
+		batch_num_pages--;
+	}
+}
+
 static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 {
 	static const struct sockaddr_nl snl = {
@@ -154,12 +166,12 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 		.msg_iov	= iov,
 		.msg_iovlen	= batch_num_pages,
 	};
-	struct batch_page *batch_page, *next;
-	int i = 0;
+	struct batch_page *batch_page;
+	int i = 0, ret;
 
 	mnl_nft_set_sndbuffer(nl);
 
-	list_for_each_entry_safe(batch_page, next, &batch_page_list, head) {
+	list_for_each_entry(batch_page, &batch_page_list, head) {
 		iov[i].iov_base = mnl_nlmsg_batch_head(batch_page->batch);
 		iov[i].iov_len = mnl_nlmsg_batch_size(batch_page->batch);
 		i++;
@@ -169,13 +181,12 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 				  mnl_nlmsg_batch_size(batch_page->batch),
 				  sizeof(struct nfgenmsg));
 #endif
-		list_del(&batch_page->head);
-		free(batch_page->batch);
-		free(batch_page);
-		batch_num_pages--;
 	}
 
-	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+	ret = sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+	mnl_nft_batch_reset();
+
+	return ret;
 }
 
 static int cb_err(const struct nlmsghdr *nlh, void *data)
-- 
1.7.10.4

