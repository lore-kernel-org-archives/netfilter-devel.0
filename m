From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 3/4] examples: add batching support to
 nft-set-elem-add.c
Date: Mon, 11 Aug 2014 18:19:48 +0200
Message-ID: <20140811161947.17035.48582.stgit@nfdev.cica.es>
References: <20140811161937.17035.21877.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37292 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751709AbaHKQTz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:19:55 -0400
In-Reply-To: <20140811161937.17035.21877.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add batching support to nft-set-elem-add.c, which is what the kernel
understand.

While a it, factorice some code in a helper function, setup_set().

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-set-elem-add.c |  110 ++++++++++++++++++++++++++++++-------------
 1 file changed, 76 insertions(+), 34 deletions(-)

diff --git a/examples/nft-set-elem-add.c b/examples/nft-set-elem-add.c
index ffc025c..763ec1b 100644
--- a/examples/nft-set-elem-add.c
+++ b/examples/nft-set-elem-add.c
@@ -16,18 +16,63 @@
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nfnetlink.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/set.h>
 
+static void setup_set(struct nft_set *s, const char *table, const char *name)
+{
+	uint32_t data;
+	struct nft_set_elem *e;
+
+	nft_set_attr_set_str(s, NFT_SET_ATTR_TABLE, table);
+	nft_set_attr_set_str(s, NFT_SET_ATTR_NAME, name);
+
+	e = nft_set_elem_alloc();
+	if (e == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	data = 0x1;
+	nft_set_elem_attr_set(e, NFT_SET_ELEM_ATTR_KEY, &data, sizeof(data));
+	nft_set_elem_add(s, e);
+
+	e = nft_set_elem_alloc();
+	if (e == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+	data = 0x2;
+	nft_set_elem_attr_set(e, NFT_SET_ELEM_ATTR_KEY, &data, sizeof(data));
+	nft_set_elem_add(s, e);
+}
+
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
-	uint32_t portid, seq, family, data;
+	uint32_t portid, seq, family;
 	struct nft_set *s;
-	struct nft_set_elem *e;
 	int ret;
 
 	if (argc != 4) {
@@ -41,7 +86,6 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	seq = time(NULL);
 	if (strcmp(argv[1], "ip") == 0)
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
@@ -55,33 +99,26 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nft_set_attr_set(s, NFT_SET_ATTR_TABLE, argv[2]);
-	nft_set_attr_set(s, NFT_SET_ATTR_NAME, argv[3]);
+	setup_set(s, argv[2], argv[3]);
 
-	/* Add to dummy elements to set */
-	e = nft_set_elem_alloc();
-	if (e == NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
+	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	data = 0x1;
-	nft_set_elem_attr_set(e, NFT_SET_ELEM_ATTR_KEY, &data, sizeof(data));
-	nft_set_elem_add(s, e);
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
+			  NFNL_MSG_BATCH_BEGIN, seq++);
+	mnl_nlmsg_batch_next(batch);
 
-	e = nft_set_elem_alloc();
-	if (e == NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
-	data = 0x2;
-	nft_set_elem_attr_set(e, NFT_SET_ELEM_ATTR_KEY, &data, sizeof(data));
-	nft_set_elem_add(s, e);
-
-	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM, family,
-				      NLM_F_CREATE|NLM_F_EXCL|NLM_F_ACK, seq);
+	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				      NFT_MSG_NEWSETELEM, family,
+				      NLM_F_CREATE|NLM_F_EXCL|NLM_F_ACK,
+				      seq++);
 	nft_set_elems_nlmsg_build_payload(nlh, s);
 	nft_set_free(s);
+	mnl_nlmsg_batch_next(batch);
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
+			  seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -95,22 +132,27 @@ int main(int argc, char *argv[])
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
+
+	ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
 	mnl_socket_close(nl);
 
 	return EXIT_SUCCESS;

