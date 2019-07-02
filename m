Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31934C5B57D
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 01:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2A9A2064A
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 01:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGCBSn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 21:18:43 -0400
Received: from mail.us.es ([193.147.175.20]:51534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbfGCBSn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 21:18:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7182380770
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 00:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 612D4DA801
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 00:52:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5058A11510C; Wed,  3 Jul 2019 00:52:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22DA6115103
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 00:52:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 00:52:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 065254265A2F
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 00:52:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] mnl: remove unnecessary NLM_F_ACK flags
Date:   Wed,  3 Jul 2019 00:52:08 +0200
Message-Id: <20190702225208.28347-1-pablo@netfilter.org>
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
v2: mnl_nft_obj_dump() needs NLM_F_ACK when dump == false.

 src/mnl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 6ebad28bfc7d..c145cc5c9228 100644
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
@@ -1081,7 +1081,7 @@ mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 		 const char *table, const char *name,  uint32_t type, bool dump,
 		 bool reset)
 {
-	uint16_t nl_flags = dump ? NLM_F_DUMP : 0;
+	uint16_t nl_flags = dump ? NLM_F_DUMP : NLM_F_ACK;
 	struct nftnl_obj_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
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

