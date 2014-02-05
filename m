From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC libnftnl PATCH 2/2] examples: use new mnlio API in nft-rule-add.c
Date: Wed, 05 Feb 2014 20:17:52 +0100
Message-ID: <20140205191752.9979.97410.stgit@nfdev.cica.es>
References: <20140205191711.9979.23980.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35407 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751634AbaBETRz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:17:55 -0500
In-Reply-To: <20140205191711.9979.23980.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update this example to use the new mnlio API.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-rule-add.c |   87 ++++-------------------------------------------
 1 file changed, 7 insertions(+), 80 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index dbe93f5..7ee73d1 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -28,6 +28,7 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
+#include <libnftnl/mnlio.h>
 
 static void add_payload(struct nft_rule *r, uint32_t base, uint32_t dreg,
 			uint32_t offset, uint32_t len)
@@ -111,78 +112,12 @@ static struct nft_rule *setup_rule(uint8_t family, const char *table,
 	return r;
 }
 
-static int seq;
-
-static void nft_mnl_batch_put(struct mnl_nlmsg_batch *batch, int type)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq++;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
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
-}
-
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	struct nft_rule *r;
-	struct nlmsghdr *nlh;
-	struct mnl_nlmsg_batch *batch;
+	struct mnl_nlmsg_batch *batch = nft_mnlio_batch_alloc();
 	uint8_t family;
-	char buf[4096];
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
@@ -211,28 +146,20 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
-
-	nft_mnl_batch_put(batch, NFNL_MSG_BATCH_BEGIN);
+	nft_mnlio_batch_begin(batch);
 
-	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-			NFT_MSG_NEWRULE,
-			nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY),
-			NLM_F_APPEND|NLM_F_CREATE, seq);
-
-	nft_rule_nlmsg_build_payload(nlh, r);
+	nft_mnlio_rule_add(r, NLM_F_APPEND, batch);
 	nft_rule_free(r);
-	mnl_nlmsg_batch_next(batch);
 
-	nft_mnl_batch_put(batch, NFNL_MSG_BATCH_END);
+	mnl_nlmsg_batch_next(batch);
+	nft_mnlio_batch_end(batch);
 
-	if (nft_mnl_batch_talk(nl, batch) < 0) {
+	if (nft_mnlio_batch_talk(nl, batch) < 0) {
 		perror("Netlink problem");
 		exit(EXIT_FAILURE);
 	}
 
 	mnl_nlmsg_batch_stop(batch);
-
 	mnl_socket_close(nl);
 
 	return EXIT_SUCCESS;

