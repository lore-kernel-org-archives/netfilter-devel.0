Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B79C06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 17:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5BAC20B1F
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 17:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfGBRDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 13:03:51 -0400
Received: from mail.us.es ([193.147.175.20]:45038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfGBRDv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 13:03:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0B0C114563
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 19:03:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1D20CE158
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 19:03:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CFF7CDA7B6; Tue,  2 Jul 2019 19:03:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75DEB202D2
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 19:03:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 02 Jul 2019 19:03:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 479CB4265A31
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 19:03:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: remove unnecessary NLM_F_ACK flags
Date:   Tue,  2 Jul 2019 19:03:40 +0200
Message-Id: <20190702170340.21325-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On error, the kernel already sends to userspace an acknowledgement for
the table and chain deletion case.

In case of NLM_F_DUMP, the NLM_F_ACK is not required as the kernel
always sends a NLMSG_DONE at the end of the dumping, even if the list of
objects is empty.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 6ebad28bfc7d..445fb8ab57d9 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -608,7 +608,7 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELCHAIN,
 				    cmd->handle.family,
-				    NLM_F_ACK, ctx->seqnum);
+				    0, ctx->seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 	nftnl_chain_free(nlc);
 
@@ -716,7 +716,7 @@ int mnl_nft_table_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELTABLE,
 				    cmd->handle.family,
-				    NLM_F_ACK, ctx->seqnum);
+				    0, ctx->seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 	nftnl_table_free(nlt);
 
@@ -927,7 +927,7 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family, const char *table)
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
-				    NLM_F_DUMP | NLM_F_ACK, ctx->seqnum);
+				    NLM_F_DUMP, ctx->seqnum);
 	if (table != NULL)
 		nftnl_set_set(s, NFTNL_SET_TABLE, table);
 	nftnl_set_nlmsg_build_payload(nlh, s);
@@ -1098,7 +1098,7 @@ mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, msg_type, family,
-				    nl_flags | NLM_F_ACK, ctx->seqnum);
+				    nl_flags, ctx->seqnum);
 	if (table != NULL)
 		nftnl_obj_set_str(n, NFTNL_OBJ_TABLE, table);
 	if (name != NULL)
@@ -1288,7 +1288,7 @@ int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls)
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_DUMP | NLM_F_ACK, ctx->seqnum);
+				    NLM_F_DUMP, ctx->seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
 
 	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_elem_cb, nls);
@@ -1331,7 +1331,7 @@ mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table)
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
-				    NLM_F_DUMP | NLM_F_ACK, ctx->seqnum);
+				    NLM_F_DUMP, ctx->seqnum);
 	if (table != NULL)
 		nftnl_flowtable_set_str(n, NFTNL_FLOWTABLE_TABLE, table);
 	nftnl_flowtable_nlmsg_build_payload(nlh, n);
-- 
2.11.0

