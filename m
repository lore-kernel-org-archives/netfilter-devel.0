From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] examples: nft-chain-parse-add: add batching
 support
Date: Mon, 18 Aug 2014 21:06:20 +0200
Message-ID: <20140818190620.15504.31166.stgit@nfdev.cica.es>
References: <20140818190614.15504.2107.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43133 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbaHRTG2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:06:28 -0400
In-Reply-To: <20140818190614.15504.2107.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add batching support to operate with current kernels.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-chain-parse-add.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/examples/nft-chain-parse-add.c b/examples/nft-chain-parse-add.c
index 01696ad..c4e4b88 100644
--- a/examples/nft-chain-parse-add.c
+++ b/examples/nft-chain-parse-add.c
@@ -74,10 +74,11 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
+	uint32_t portid, seq, chain_seq;
 	struct nft_chain *c;
 	uint16_t family, format, outformat;
-	int ret;
+	int ret, batching;
+	struct mnl_nlmsg_batch *batch;
 
 	if (argc < 3) {
 		printf("Usage: %s {xml|json} <file>\n", argv[0]);
@@ -106,11 +107,31 @@ int main(int argc, char *argv[])
 	family = nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
 
 	seq = time(NULL);
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
-					NLM_F_CREATE|NLM_F_ACK, seq);
-	nft_chain_nlmsg_build_payload(nlh, c);
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
+	chain_seq = seq;
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_NEWCHAIN, family,
+					NLM_F_ACK, seq++);
+	nft_chain_nlmsg_build_payload(nlh, c);
 	nft_chain_free(c);
+	mnl_nlmsg_batch_next(batch);
+
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -125,18 +146,18 @@ int main(int argc, char *argv[])
 
 	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+			      mnl_nlmsg_batch_size(batch)) < 0) {
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
 	}
 
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		ret = mnl_cb_run(buf, ret, chain_seq, portid, NULL, NULL);
 		if (ret <= 0)
 			break;
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-
 	}
 	if (ret == -1) {
 		perror("error");

