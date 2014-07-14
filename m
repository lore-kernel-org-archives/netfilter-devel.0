From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] examples: nft-set-add: use batch infraestructure
Date: Mon, 14 Jul 2014 10:41:39 +0200
Message-ID: <20140714084139.4457.50759.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55505 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753855AbaGNIls (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:41:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It uses the existing nfnl batching approach using the generic mnl
netlink message batching infrastructure.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-set-add.c |  128 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 84 insertions(+), 44 deletions(-)

diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index 4e54c39..530aa0a 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -12,36 +12,75 @@
 #include <stdlib.h>
 #include <time.h>
 #include <string.h>
+#include <stddef.h>	/* for offsetof */
 #include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/tcp.h>
+#include <arpa/inet.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <errno.h>
 
 #include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <libmnl/libmnl.h>
-#include <libnftnl/table.h>
 #include <libnftnl/set.h>
 
+static struct nft_set *setup_set(uint8_t family, const char *table,
+				 const char *name)
+{
+	struct nft_set *s = NULL;
+
+	s = nft_set_alloc();
+	if (s == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_set_attr_set_str(s, NFT_SET_ATTR_TABLE, table);
+	nft_set_attr_set_str(s, NFT_SET_ATTR_NAME, name);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_FAMILY, family);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_KEY_LEN, 2);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, 1);
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_FLAGS, NFT_SET_CONSTANT);
+
+	return s;
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
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nft_set *s;
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq, family;
-	struct nft_set *t = NULL;
+	struct mnl_nlmsg_batch *batch;
+	uint8_t family;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint32_t seq = time(NULL);
 	int ret;
 
 	if (argc != 4) {
-		fprintf(stderr, "%s <family> <table> <set>\n", argv[0]);
+		fprintf(stderr, "Usage: %s <family> <table> <setname>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
-	t = nft_set_alloc();
-	if (t == NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
-
-	seq = time(NULL);
 	if (strcmp(argv[1], "ip") == 0)
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
@@ -55,28 +94,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nft_set_attr_set(t, NFT_SET_ATTR_TABLE, argv[2]);
-	nft_set_attr_set(t, NFT_SET_ATTR_NAME, argv[3]);
-	/* destroy set when the rule is destroyed, elements canno change */
-	nft_set_attr_set_u32(t, NFT_SET_ATTR_FLAGS, NFT_SET_ANONYMOUS |
-						    NFT_SET_CONSTANT);
-	/* This key is only used by user-space to interpret key type */
-	nft_set_attr_set_u32(t, NFT_SET_ATTR_KEY_TYPE, 0);
-	/* key is 4 bytes long */
-	nft_set_attr_set_u32(t, NFT_SET_ATTR_KEY_LEN, 4);
-	/*
-	 * data type and data length only useful for mapping (1:1):
-	 * matching -> action.
-	 *
-	 * This data is only used by user-space to interpret data type.
-	 */
-	// nft_set_attr_set_u32(t, NFT_SET_ATTR_DATA_TYPE, NFT_DATA_VERDICT);
-	// nft_set_attr_set_u32(t, NFT_SET_ATTR_DATA_LEN, 4);
-
-	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, family,
-				      NLM_F_CREATE|NLM_F_EXCL|NLM_F_ACK, seq);
-	nft_set_nlmsg_build_payload(nlh, t);
-	nft_set_free(t);
+	s = setup_set(family, argv[2], argv[3]);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -88,24 +106,46 @@ int main(int argc, char *argv[])
 		perror("mnl_socket_bind");
 		exit(EXIT_FAILURE);
 	}
-	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
+			  NFNL_MSG_BATCH_BEGIN, seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				      NFT_MSG_NEWSET, family,
+				      NLM_F_CREATE|NLM_F_ACK, seq++);
+
+	nft_set_nlmsg_build_payload(nlh, s);
+	nft_set_free(s);
+	mnl_nlmsg_batch_next(batch);
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
+			 seq++);
+	mnl_nlmsg_batch_next(batch);
+
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
+	ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(nl), NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
+		exit(EXIT_FAILURE);
+	}
+
 	mnl_socket_close(nl);
 
 	return EXIT_SUCCESS;

