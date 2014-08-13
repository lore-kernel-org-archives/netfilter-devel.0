From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3 libnftnl] examples: nft-chain-add: support new batching interface
Date: Wed, 13 Aug 2014 18:54:58 +0200
Message-ID: <1407948898-8495-3-git-send-email-pablo@netfilter.org>
References: <1407948898-8495-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55351 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbaHMQym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:54:42 -0400
In-Reply-To: <1407948898-8495-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Chains are included in the batch since 3.16. Add support for adding
the chains dependending on the available interface.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-chain-add.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index 4d32ddd..f7f640a 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -63,9 +63,11 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
+	uint32_t portid, seq, chain_seq;
 	int ret, family;
 	struct nft_chain *t;
+	struct mnl_nlmsg_batch *batch;
+	int batching;
 
 	if (argc != 4 && argc != 6) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain> "
@@ -91,11 +93,32 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
 	seq = time(NULL);
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
-					NLM_F_EXCL|NLM_F_ACK, seq);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	chain_seq = seq;
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_NEWCHAIN, family,
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
@@ -109,14 +132,15 @@ int main(int argc, char *argv[])
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
-- 
1.7.10.4

