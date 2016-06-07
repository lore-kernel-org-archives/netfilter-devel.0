From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/2] examples: nft-table-upd: don't use deprecated aliases
Date: Tue,  7 Jun 2016 17:04:31 +0200
Message-ID: <1465311872-17878-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54350 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbcFGPEs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 11:04:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A62D592176E
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:04:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 969819EBAD
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:04:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 286B89EBAF
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:04:42 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Convert this example not to use the deprecated aliases anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is a leftover from previous conversion.

 examples/nft-table-upd.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index bc6e02a..9b960bb 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -26,7 +26,7 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, table_seq, family, flags;
-	struct nft_table *t = NULL;
+	struct nftnl_table *t = NULL;
 	struct mnl_nlmsg_batch *batch;
 	int ret, batching;
 
@@ -35,13 +35,13 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	t = nft_table_alloc();
+	t = nftnl_table_alloc();
 	if (t == NULL) {
 		perror("OOM");
 		exit(EXIT_FAILURE);
 	}
 
-	batching = nft_batch_is_supported();
+	batching = nftnl_batch_is_supported();
 	if (batching < 0) {
 		perror("cannot talk to nfnetlink");
 		exit(EXIT_FAILURE);
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
 	if (batching) {
-		nft_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 		mnl_nlmsg_batch_next(batch);
 	}
 
@@ -80,19 +80,19 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, argv[2]);
-	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, flags);
+	nftnl_table_set(t, NFTNL_TABLE_NAME, argv[2]);
+	nftnl_table_set_u32(t, NFTNL_TABLE_FLAGS, flags);
 
 	table_seq = seq;
-	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nftnl_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 					NFT_MSG_NEWTABLE, family,
 					NLM_F_ACK, seq++);
-	nft_table_nlmsg_build_payload(nlh, t);
-	nft_table_free(t);
+	nftnl_table_nlmsg_build_payload(nlh, t);
+	nftnl_table_free(t);
 	mnl_nlmsg_batch_next(batch);
 
 	if (batching) {
-		nft_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
 		mnl_nlmsg_batch_next(batch);
 	}
 
-- 
2.1.4

