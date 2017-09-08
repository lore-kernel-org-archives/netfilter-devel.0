From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: do not set NLM_F_CREATE in deletion requests
Date: Fri,  8 Sep 2017 15:09:08 +0200
Message-ID: <1504876148-28786-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755392AbdIHNJQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2017 09:09:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3578953AA2A
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2017 15:08:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27ECAB5028
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2017 15:08:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2389FB5028
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2017 15:08:43 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EA2EE42EFA9C
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2017 15:08:42 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This flag is not legal there, it only makes sense for addition requests.
This patch has no impact at all in any of the nf_tables kernel versions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 69e24071b8f1..e2174925c121 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -947,10 +947,13 @@ static int mnl_nft_setelem_batch(struct nftnl_set *nls,
 	if (iter == NULL)
 		memory_allocation_error();
 
+	if (cmd == NFT_MSG_NEWSETELEM)
+		flags |= NLM_F_CREATE;
+
 	while (nftnl_set_elems_iter_cur(iter)) {
 		nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), cmd,
 					    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-					    NLM_F_CREATE | flags, seqnum);
+					    flags, seqnum);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
 		mnl_nft_batch_continue(batch);
 		if (ret <= 0)
@@ -977,7 +980,7 @@ int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, struct nftnl_batch *batch
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch),
 				    NFT_MSG_DELSETELEM,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_CREATE | flags, seqnum);
+				    flags, seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
 	mnl_nft_batch_continue(batch);
 
-- 
2.1.4

