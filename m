From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] mnl: introduce NFT_NLMSG_MAXSIZE
Date: Wed, 23 Jul 2014 23:49:52 +0200
Message-ID: <1406152193-11497-2-git-send-email-pablo@netfilter.org>
References: <1406152193-11497-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49772 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbaGWVtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:49:49 -0400
In-Reply-To: <1406152193-11497-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The NFT_NLMSG_MAXSIZE constant defines the maximum nf_tables netlink
message. Currently, the largest is the set element message, which
contains the NFTA_SET_ELEM_LIST_ELEMENTS attribute. This attribute is
a nest that describe the set elements. Given that the netlink attribute
length (nla_len) is 16 bits, the largest message is a bit larger than
64 KBytes. Thus, the proposed value of NFT_NLMSG_MAXSIZE is set to
(1 << 16) + getpagesize().

This new constant is used to calculate the length of:

1) the batch page length, when the batching mode is used.

2) the buffer that stores the netlink message in the send (when no
   batching is used) and receive paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 42b11f5..667aa3a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -33,11 +33,19 @@ uint32_t mnl_seqnum_alloc(void)
 	return seq++;
 }
 
+/* The largest nf_tables netlink message is the set element message, which
+ * contains the NFTA_SET_ELEM_LIST_ELEMENTS attribute. This attribute is
+ * a nest that describes the set elements. Given that the netlink attribute
+ * length (nla_len) is 16 bits, the largest message is a bit larger than
+ * 64 KBytes.
+ */
+#define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
+
 static int
 nft_mnl_recv(struct mnl_socket *nf_sock, uint32_t seqnum, uint32_t portid,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	char buf[NFT_NLMSG_MAXSIZE];
 	int ret;
 
 	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
@@ -86,8 +94,8 @@ static struct mnl_nlmsg_batch *mnl_batch_alloc(void)
 {
 	static char *buf;
 
-	/* libmnl needs higher buffer to handle batch overflows */
-	buf = xmalloc(BATCH_PAGE_SIZE + getpagesize());
+	/* libmnl needs higher buffer to handle batch overflows. */
+	buf = xmalloc(BATCH_PAGE_SIZE + NFT_NLMSG_MAXSIZE);
 	return mnl_nlmsg_batch_start(buf, BATCH_PAGE_SIZE);
 }
 
@@ -818,7 +826,7 @@ int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			unsigned int flags)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	char buf[NFT_NLMSG_MAXSIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
@@ -832,7 +840,7 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			   unsigned int flags)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	char buf[NFT_NLMSG_MAXSIZE];
 	struct nlmsghdr *nlh;
 
 	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_DELSETELEM,
-- 
1.7.10.4

