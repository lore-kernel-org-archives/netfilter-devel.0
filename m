From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] examples: nft-set-parse-add: give batching
 support
Date: Fri, 26 Sep 2014 20:34:48 +0200
Message-ID: <20140926183448.3333.64808.stgit@nfdev.cica.es>
References: <20140926183442.3333.62136.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45198 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754089AbaIZSex (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:34:53 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 08EC151EF62
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 18:34:51 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rlqkZlyCF1Dp for <netfilter-devel@vger.kernel.org>;
	Fri, 26 Sep 2014 20:34:46 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 02A9351EF69
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 20:34:45 +0200 (CEST)
In-Reply-To: <20140926183442.3333.62136.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Batching is needed in current kernels.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-set-parse-add.c |   43 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/examples/nft-set-parse-add.c b/examples/nft-set-parse-add.c
index b74ad7f..f21385f 100644
--- a/examples/nft-set-parse-add.c
+++ b/examples/nft-set-parse-add.c
@@ -23,6 +23,7 @@
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nfnetlink.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/set.h>
@@ -66,6 +67,8 @@ static struct nft_set *set_parse_file(const char *file, uint16_t format)
 	}
 
 	nft_parse_err_free(err);
+
+	nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, 1);
 	return s;
 
 }
@@ -75,10 +78,11 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
+	uint32_t portid, seq, set_seq;
 	struct nft_set *s;
-	int ret;
+	int ret, batching;
 	uint16_t family, format, outformat;
+	struct mnl_nlmsg_batch *batch;
 
 	if (argc < 2) {
 		printf("Usage: %s {xml|json} <file>\n", argv[0]);
@@ -103,14 +107,34 @@ int main(int argc, char *argv[])
 	nft_set_fprintf(stdout, s, outformat, 0);
 	fprintf(stdout, "\n");
 
-	family = nft_set_attr_get_u32(s, NFT_SET_ATTR_FAMILY);
-
 	seq = time(NULL);
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, family,
-					NLM_F_CREATE|NLM_F_ACK, seq);
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
+	family = nft_set_attr_get_u32(s, NFT_SET_ATTR_FAMILY);
+
+	set_seq = seq;
+	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				      NFT_MSG_NEWSET, family,
+				      NLM_F_CREATE|NLM_F_ACK, seq++);
 	nft_set_nlmsg_build_payload(nlh, s);
 	nft_set_free(s);
+	mnl_nlmsg_batch_next(batch);
+
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -124,14 +148,17 @@ int main(int argc, char *argv[])
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
+		ret = mnl_cb_run(buf, ret, set_seq, portid, NULL, NULL);
 		if (ret <= 0)
 			break;
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));

