From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] examples: nft-set-del: fix set deletion
Date: Wed, 14 Feb 2018 20:04:46 +0100
Message-ID: <20180214190446.31163-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162347AbeBNTEw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:04:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 50B56DA848
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:04:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FC6DDA7E0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:04:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 473C8DA7E0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:04:49 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 10D1F4265A2F
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:04:48 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-set-del.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/examples/nft-set-del.c b/examples/nft-set-del.c
index 5e1fad30d341..8c216df861d7 100644
--- a/examples/nft-set-del.c
+++ b/examples/nft-set-del.c
@@ -25,6 +25,7 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
 	uint32_t portid, seq, family;
 	struct nftnl_set *t = NULL;
 	int ret;
@@ -54,13 +55,23 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_DELSET, family,
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_DELSET, family,
 					NLM_F_ACK, seq);
 	nftnl_set_set(t, NFTNL_SET_TABLE, argv[2]);
 	nftnl_set_set(t, NFTNL_SET_NAME, argv[3]);
 
 	nftnl_set_nlmsg_build_payload(nlh, t);
 	nftnl_set_free(t);
+	mnl_nlmsg_batch_next(batch);
+
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -74,20 +85,24 @@ int main(int argc, char *argv[])
 	}
 	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	if (ret < 0) {
 		perror("mnl_socket_send");
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
+	while (ret < 0) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
 	}
-	if (ret == -1) {
-		perror("error");
+
+	ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
+	if (ret < 0) {
+		perror("mnl_cb_run");
 		exit(EXIT_FAILURE);
 	}
 	mnl_socket_close(nl);
-- 
2.11.0

