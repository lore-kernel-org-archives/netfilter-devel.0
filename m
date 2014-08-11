From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/4] examples: fix nft-table-del by adding batching
 support
Date: Mon, 11 Aug 2014 13:31:53 +0200
Message-ID: <20140811113153.13420.9596.stgit@nfdev.cica.es>
References: <20140811113148.13420.26758.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:47421 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751884AbaHKLcB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:32:01 -0400
In-Reply-To: <20140811113148.13420.26758.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code example doesn't work, as the kernel API is only listening to messages
in batches.

This patch updates the example to add the needed batching support.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-table-del.c |   58 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index ed1140d..aa88979 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -16,13 +16,31 @@
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nfnetlink.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/table.h>
 
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
 	uint32_t portid, seq, family;
@@ -40,7 +58,6 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	seq = time(NULL);
 	if (strcmp(argv[1], "ip") == 0)
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
@@ -54,12 +71,25 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE, family,
-					NLM_F_ACK, seq);
+	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
+			  NFNL_MSG_BATCH_BEGIN, seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_DELTABLE, family,
+					NLM_F_ACK, seq++);
 	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, argv[2]);
 
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
+	mnl_nlmsg_batch_next(batch);
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
+			  seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -73,20 +103,24 @@ int main(int argc, char *argv[])
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
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nl), NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
 		exit(EXIT_FAILURE);
 	}
 	mnl_socket_close(nl);

