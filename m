From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/6] examples: nft-table-parse-add: add batching
 support
Date: Fri, 22 Aug 2014 11:39:35 +0200
Message-ID: <20140822093935.1524.41180.stgit@nfdev.cica.es>
References: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:45510 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbaHVJjo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:39:44 -0400
In-Reply-To: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add batching support to operate with recent kernels.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-table-parse-add.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/examples/nft-table-parse-add.c b/examples/nft-table-parse-add.c
index 0faedad..c21b6ba 100644
--- a/examples/nft-table-parse-add.c
+++ b/examples/nft-table-parse-add.c
@@ -73,10 +73,11 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
+	uint32_t portid, seq, table_seq;
 	struct nft_table *t = NULL;
-	int ret;
+	int ret, batching;
 	uint16_t family, format, outformat;
+	struct mnl_nlmsg_batch *batch;
 
 	if (argc < 3) {
 		printf("Usage: %s {xml|json} <file>\n", argv[0]);
@@ -101,14 +102,34 @@ int main(int argc, char *argv[])
 	nft_table_fprintf(stdout, t, outformat, 0);
 	fprintf(stdout, "\n");
 
-	family = nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
-
 	seq = time(NULL);
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
+
+	family = nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, family,
-					NLM_F_CREATE|NLM_F_ACK, seq);
+	table_seq = seq;
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_NEWTABLE, family,
+					NLM_F_CREATE|NLM_F_ACK, seq++);
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
+	mnl_nlmsg_batch_next(batch);
+
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -122,14 +143,17 @@ int main(int argc, char *argv[])
 	}
 	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+			      mnl_nlmsg_batch_size(batch)) < 0) {
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
 	}
 
+	mnl_nlmsg_batch_stop(batch);
+
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		ret = mnl_cb_run(buf, ret, table_seq, portid, NULL, NULL);
 		if (ret <= 0)
 			break;
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));

