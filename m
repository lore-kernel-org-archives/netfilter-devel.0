From: Vijay Subramanian <subramanian.vijay@gmail.com>
Subject: [PATCH libnftnl] Fix nft-table-upd example
Date: Fri,  9 Oct 2015 14:24:18 -0700
Message-ID: <1444425858-24568-1-git-send-email-subramanian.vijay@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Vijay Subramanian <subramanian.vijay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33411 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbbJIVYi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 17:24:38 -0400
Received: by qkas79 with SMTP id s79so38192928qka.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Oct 2015 14:24:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

examples/nft-table-upd does not work currently since NFT_MSG_NEWTABLE
needs to use batching mode of netlink message delivery.

This patch adds batching to nft-table-upd example.

While here, also add support for netdev family.

Signed-off-by: Vijay Subramanian <subramanian.vijay@gmail.com>
---
 examples/nft-table-upd.c |   54 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index 686b5a7..bc6e02a 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -25,22 +25,36 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq, family, flags;
-	struct nftnl_table *t = NULL;
-	int ret;
+	uint32_t portid, seq, table_seq, family, flags;
+	struct nft_table *t = NULL;
+	struct mnl_nlmsg_batch *batch;
+	int ret, batching;
 
 	if (argc != 4) {
 		fprintf(stderr, "%s <family> <name> <state>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
-	t = nftnl_table_alloc();
+	t = nft_table_alloc();
 	if (t == NULL) {
 		perror("OOM");
 		exit(EXIT_FAILURE);
 	}
 
+	batching = nft_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
 	seq = time(NULL);
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	if (batching) {
+		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
+
 	if (strcmp(argv[1], "ip") == 0)
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
@@ -49,8 +63,11 @@ int main(int argc, char *argv[])
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
+	else if (strcmp(argv[1], "netdev") == 0)
+		family = NFPROTO_NETDEV;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr,
+			"Unknown family: ip, ip6, bridge, arp, netdev\n");
 		exit(EXIT_FAILURE);
 	}
 
@@ -63,13 +80,21 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_table_set(t, NFTNL_TABLE_NAME, argv[2]);
-	nftnl_table_set_u32(t, NFTNL_TABLE_FLAGS, flags);
+	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, argv[2]);
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
+
+	table_seq = seq;
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+					NFT_MSG_NEWTABLE, family,
+					NLM_F_ACK, seq++);
+	nft_table_nlmsg_build_payload(nlh, t);
+	nft_table_free(t);
+	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, family,
-					NLM_F_ACK, seq);
-	nftnl_table_nlmsg_build_payload(nlh, t);
-	nftnl_table_free(t);
+	if (batching) {
+		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -83,14 +108,17 @@ int main(int argc, char *argv[])
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
-- 
1.7.9.5

