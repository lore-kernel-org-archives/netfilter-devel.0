From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] examples: nft-chain-del: support new batching
 interface
Date: Mon, 18 Aug 2014 11:19:52 +0200
Message-ID: <20140818091952.11948.77035.stgit@nfdev.cica.es>
References: <20140818091947.11948.79838.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50475 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750975AbaHRJUA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:20:00 -0400
In-Reply-To: <20140818091947.11948.79838.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Chains are included in the batch since 3.16. Add support to delete
chains dependending on the available interface.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-chain-del.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index 833bce0..2a52a01 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -39,11 +39,12 @@ static struct nft_chain *chain_del_parse(int argc, char *argv[])
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
+	struct mnl_nlmsg_batch *batch;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_chain *t = NULL;
-	int ret, family;
+	uint32_t portid, seq, chain_seq;
+	struct nft_chain *t;
+	int ret, family, batching;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n",
@@ -68,11 +69,32 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
 	seq = time(NULL);
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN, family,
-					NLM_F_ACK, seq);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	chain_seq = seq;
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_DELCHAIN, family,
+					NLM_F_ACK, seq++);
 	nft_chain_nlmsg_build_payload(nlh, t);
 	nft_chain_free(t);
+	mnl_nlmsg_batch_next(batch);
+
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -86,14 +108,15 @@ int main(int argc, char *argv[])
 	}
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

