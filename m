From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/4] mnl: Drop --echo support for non-batch calls
Date: Tue, 15 Aug 2017 01:43:02 +0200
Message-ID: <20170814234305.2829-2-phil@nwl.cc>
References: <20170814234305.2829-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52557 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbdHNXnY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 19:43:24 -0400
In-Reply-To: <20170814234305.2829-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Echo support in nft_mnl_talk() was broken: nft_mnl_talk_cb() passed
cbdata->data as second parameter to netlink_echo_callback() which
expected it to be of type struct netlink_ctx while in fact it was
whatever callers of nft_mnl_talk() passed as callback data (in most
cases a NULL pointer).

I didn't notice this because I didn't test for kernels without support
for transactions. This has been added to nftables in kernel version 3.16
back in 2014. Since then, user space which doesn't support it can't even
add a table anymore. So adding this new feature to the old code path is
really not feasible, therefore drop this broken attempt at supporting
it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 031b7f39da8f5..5017b81c96e7c 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -67,32 +67,11 @@ out:
 	return ret;
 }
 
-struct nft_mnl_talk_cb_data {
-	int (*cb)(const struct nlmsghdr *nlh, void *data);
-	void *data;
-};
-
-static int nft_mnl_talk_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nft_mnl_talk_cb_data *cbdata = data;
-	int rc;
-
-	if (cbdata->cb)
-		rc = cbdata->cb(nlh, cbdata->data);
-	if (rc)
-		return rc;
-	return netlink_echo_callback(nlh, cbdata->data);
-}
-
 static int
 nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	uint32_t portid = mnl_socket_get_portid(nf_sock);
-	struct nft_mnl_talk_cb_data tcb_data = {
-		.cb = cb,
-		.data = cb_data,
-	};
 
 #ifdef DEBUG
 	if (debug_level & DEBUG_MNL)
@@ -102,7 +81,7 @@ nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	if (mnl_socket_sendto(nf_sock, data, len) < 0)
 		return -1;
 
-	return nft_mnl_recv(nf_sock, seq, portid, &nft_mnl_talk_cb, &tcb_data);
+	return nft_mnl_recv(nf_sock, seq, portid, cb, cb_data);
 }
 
 /*
-- 
2.13.1

