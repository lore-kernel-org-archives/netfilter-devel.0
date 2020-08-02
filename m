Return-Path: <SRS0=Ke5S=BM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285EBC433E1
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136DB2076A
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgHBBaM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Aug 2020 21:30:12 -0400
Received: from correo.us.es ([193.147.175.20]:39358 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgHBBaM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Aug 2020 21:30:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 683A0E34CE
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59A3EDA73F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4D1C1DA78A; Sun,  2 Aug 2020 03:30:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C571DA789
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 02 Aug 2020 03:30:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 196EA4265A2F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: report EEXIST on overlaps
Date:   Sun,  2 Aug 2020 03:30:02 +0200
Message-Id: <20200802013002.14916-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200802013002.14916-1-pablo@netfilter.org>
References: <20200802013002.14916-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace EBUSY by EEXIST in the following cases:

- If the user adds a chain with a different configuration such as different
  type, hook and priority.

- If the user adds a non-base chain that clashes with an existing basechain.

- If the user adds a { key : value } mapping element and the key exists
  but the value differs.

- If the device already belongs to an existing flowtable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fac552b0179f..6571789989bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2097,7 +2097,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 	if (nla[NFTA_CHAIN_HOOK]) {
 		if (!nft_is_base_chain(chain))
-			return -EBUSY;
+			return -EEXIST;
 
 		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
 					   false);
@@ -2107,21 +2107,21 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		basechain = nft_base_chain(chain);
 		if (basechain->type != hook.type) {
 			nft_chain_release_hook(&hook);
-			return -EBUSY;
+			return -EEXIST;
 		}
 
 		if (ctx->family == NFPROTO_NETDEV) {
 			if (!nft_hook_list_equal(&basechain->hook_list,
 						 &hook.list)) {
 				nft_chain_release_hook(&hook);
-				return -EBUSY;
+				return -EEXIST;
 			}
 		} else {
 			ops = &basechain->ops;
 			if (ops->hooknum != hook.num ||
 			    ops->priority != hook.priority) {
 				nft_chain_release_hook(&hook);
-				return -EBUSY;
+				return -EEXIST;
 			}
 		}
 		nft_chain_release_hook(&hook);
@@ -5262,10 +5262,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
 			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
 			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
-			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF)) {
-				err = -EBUSY;
+			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF))
 				goto err_element_clash;
-			}
 			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
 			     memcmp(nft_set_ext_data(ext),
@@ -5273,7 +5271,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
 			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
-				err = -EBUSY;
+				goto err_element_clash;
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
 		} else if (err == -ENOTEMPTY) {
@@ -6423,7 +6421,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
 				    hook->ops.pf == hook2->ops.pf) {
-					err = -EBUSY;
+					err = -EEXIST;
 					goto err_unregister_net_hooks;
 				}
 			}
-- 
2.20.1

