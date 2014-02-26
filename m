From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] example: nft-rule-add: simplify example
Date: Wed, 26 Feb 2014 02:51:58 +0100
Message-ID: <1393379519-16189-7-git-send-email-pablo@netfilter.org>
References: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40471 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaBZBwN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:52:13 -0500
In-Reply-To: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nft_mnl_batch_talk() is overly complicated for a simple example
that just adds one single rule. Simplify this to prepare the merge
of nft-rule-insert, which looks very similar.
---
 examples/nft-rule-add.c |   86 ++++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 57 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index dbe93f5..21b3bf8 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -111,68 +111,20 @@ static struct nft_rule *setup_rule(uint8_t family, const char *table,
 	return r;
 }
 
-static int seq;
-
-static void nft_mnl_batch_put(struct mnl_nlmsg_batch *batch, int type)
+static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfg;
 
-	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = type;
 	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq++;
+	nlh->nlmsg_seq = seq;
 
 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
 	nfg->nfgen_family = AF_INET;
 	nfg->version = NFNETLINK_V0;
 	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-
-	mnl_nlmsg_batch_next(batch);
-}
-
-static int nft_mnl_batch_talk(struct mnl_socket *nl, struct mnl_nlmsg_batch *b)
-{
-	int ret, fd = mnl_socket_get_fd(nl);
-	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
-	fd_set readfds;
-	struct timeval tv = {
-		.tv_sec		= 0,
-		.tv_usec	= 0
-	};
-
-	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(b),
-				mnl_nlmsg_batch_size(b));
-	if (ret == -1)
-		goto err;
-
-	FD_ZERO(&readfds);
-	FD_SET(fd, &readfds);
-
-	/* receive and digest all the acknowledgments from the kernel. */
-	ret = select(fd+1, &readfds, NULL, NULL, &tv);
-	if (ret == -1)
-		goto err;
-
-	while (ret > 0 && FD_ISSET(fd, &readfds)) {
-		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1)
-			goto err;
-
-		ret = mnl_cb_run(rcv_buf, ret, 0, mnl_socket_get_portid(nl),
-				 NULL, NULL);
-		if (ret < 0)
-			goto err;
-
-		ret = select(fd+1, &readfds, NULL, NULL, &tv);
-		if (ret == -1)
-			goto err;
-
-		FD_ZERO(&readfds);
-		FD_SET(fd, &readfds);
-	}
-err:
-	return ret;
 }
 
 int main(int argc, char *argv[])
@@ -182,7 +134,9 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	struct mnl_nlmsg_batch *batch;
 	uint8_t family;
-	char buf[4096];
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
@@ -213,26 +167,44 @@ int main(int argc, char *argv[])
 
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	nft_mnl_batch_put(batch, NFNL_MSG_BATCH_BEGIN);
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
+			  NFNL_MSG_BATCH_BEGIN, seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY),
-			NLM_F_APPEND|NLM_F_CREATE, seq);
+			NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
 
 	nft_rule_nlmsg_build_payload(nlh, r);
 	nft_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 
-	nft_mnl_batch_put(batch, NFNL_MSG_BATCH_END);
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
+			 seq++);
+	mnl_nlmsg_batch_next(batch);
 
-	if (nft_mnl_batch_talk(nl, batch) < 0) {
-		perror("Netlink problem");
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	if (ret == -1) {
+		perror("mnl_socket_sendto");
 		exit(EXIT_FAILURE);
 	}
 
 	mnl_nlmsg_batch_stop(batch);
 
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nl), NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
 	mnl_socket_close(nl);
 
 	return EXIT_SUCCESS;
-- 
1.7.10.4

