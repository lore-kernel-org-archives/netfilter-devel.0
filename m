From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/3] examples: fix nft-chain-add by adding batching
 support
Date: Mon, 11 Aug 2014 12:19:38 +0200
Message-ID: <20140811101938.10640.47989.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39173 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794AbaHKKTs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:19:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code example doesn't work, as the kernel API is only listening to messages
in batches.

This patch updates the example to add the needed batching support.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-chain-add.c |   59 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 12 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index 3edff86..ac55b4f 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -15,14 +15,32 @@
 #include <netinet/in.h>
 
 #include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/chain.h>
 
+static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_seq = seq;
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = NFNL_SUBSYS_NFTABLES;
+}
+
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
+	struct mnl_nlmsg_batch *batch;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq;
@@ -72,9 +90,17 @@ int main(int argc, char *argv[])
 		perror("OOM");
 		exit(EXIT_FAILURE);
 	}
+
 	seq = time(NULL);
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
-					NLM_F_EXCL|NLM_F_ACK, seq);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
+			  NFNL_MSG_BATCH_BEGIN, seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_NEWCHAIN, family,
+					NLM_F_ACK, seq++);
 	nft_chain_attr_set(t, NFT_CHAIN_ATTR_TABLE, argv[2]);
 	nft_chain_attr_set(t, NFT_CHAIN_ATTR_NAME, argv[3]);
 	if (argc == 6) {
@@ -83,6 +109,11 @@ int main(int argc, char *argv[])
 	}
 	nft_chain_nlmsg_build_payload(nlh, t);
 	nft_chain_free(t);
+	mnl_nlmsg_batch_next(batch);
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
+			  seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -96,23 +127,27 @@ int main(int argc, char *argv[])
 	}
 	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	if (ret == -1) {
+		perror("mnl_socket_sendto");
 		exit(EXIT_FAILURE);
 	}
 
+	mnl_nlmsg_batch_stop(batch);
+
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
-		if (ret <= 0)
-			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
 	if (ret == -1) {
-		perror("error");
+		perror("mnl_socket_recvfrom");
 		exit(EXIT_FAILURE);
 	}
-	mnl_socket_close(nl);
 
+	ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
 	return EXIT_SUCCESS;
 }

