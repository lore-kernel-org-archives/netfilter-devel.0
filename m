From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 6/6] examples: nft-table-del: add batching support
Date: Fri, 22 Aug 2014 11:39:56 +0200
Message-ID: <20140822093956.1524.59876.stgit@nfdev.cica.es>
References: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:45538 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbaHVJkF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:40:05 -0400
In-Reply-To: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add batching support so this code example works with current kernels.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-table-del.c |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index ae7db27..334d20b 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -55,9 +55,10 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq, family;
+	uint32_t portid, seq, table_seq, family;
 	struct nft_table *t;
-	int ret;
+	struct mnl_nlmsg_batch *batch;
+	int ret, batching;
 
 	if (argc != 3) {
 		fprintf(stderr, "%s <family> <name>\n", argv[0]);
@@ -68,14 +69,34 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
 
 	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	table_seq = seq;
 	family = nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE, family,
-					NLM_F_ACK, seq);
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_DELTABLE, family,
+					NLM_F_ACK, seq++);
 	nft_table_nlmsg_build_payload(nlh, t);
+	mnl_nlmsg_batch_next(batch);
 	nft_table_free(t);
 
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
 		perror("mnl_socket_open");
@@ -88,14 +109,17 @@ int main(int argc, char *argv[])
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

