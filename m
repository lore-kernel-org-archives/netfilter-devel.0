Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C644C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC3E820671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgETSRD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:17:03 -0400
Received: from correo.us.es ([193.147.175.20]:43506 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgETSRD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:17:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F7C4EBAC3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:17:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00EBCDA709
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:17:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EAB80DA707; Wed, 20 May 2020 20:17:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC6B5DA70F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 20:16:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D953842EF42C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:16:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/7] netfilter: nf_tables: pass hook list to flowtable event notifier
Date:   Wed, 20 May 2020 20:16:49 +0200
Message-Id: <20200520181652.30285-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200520181652.30285-1-pablo@netfilter.org>
References: <20200520181652.30285-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update the flowtable netlink notifier to take the list of hooks as input.
This allows to reuse this function in incremental flowtable hook updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f5d100787ccb..4db70e68d7f4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6523,7 +6523,8 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 					 u32 portid, u32 seq, int event,
 					 u32 flags, int family,
-					 struct nft_flowtable *flowtable)
+					 struct nft_flowtable *flowtable,
+					 struct list_head *hook_list)
 {
 	struct nlattr *nest, *nest_devs;
 	struct nfgenmsg *nfmsg;
@@ -6559,7 +6560,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	if (!nest_devs)
 		goto nla_put_failure;
 
-	list_for_each_entry_rcu(hook, &flowtable->hook_list, list) {
+	list_for_each_entry_rcu(hook, hook_list, list) {
 		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
 			goto nla_put_failure;
 	}
@@ -6612,7 +6613,9 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 							  cb->nlh->nlmsg_seq,
 							  NFT_MSG_NEWFLOWTABLE,
 							  NLM_F_MULTI | NLM_F_APPEND,
-							  table->family, flowtable) < 0)
+							  table->family,
+							  flowtable,
+							  &flowtable->hook_list) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -6709,7 +6712,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 	err = nf_tables_fill_flowtable_info(skb2, net, NETLINK_CB(skb).portid,
 					    nlh->nlmsg_seq,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
-					    flowtable);
+					    flowtable, &flowtable->hook_list);
 	if (err < 0)
 		goto err;
 
@@ -6721,6 +6724,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 
 static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 				       struct nft_flowtable *flowtable,
+				       struct list_head *hook_list,
 				       int event)
 {
 	struct sk_buff *skb;
@@ -6736,7 +6740,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 
 	err = nf_tables_fill_flowtable_info(skb, ctx->net, ctx->portid,
 					    ctx->seq, event, 0,
-					    ctx->family, flowtable);
+					    ctx->family, flowtable, hook_list);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -7494,6 +7498,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_clear(net, nft_trans_flowtable(trans));
 			nf_tables_flowtable_notify(&trans->ctx,
 						   nft_trans_flowtable(trans),
+						   &nft_trans_flowtable(trans)->hook_list,
 						   NFT_MSG_NEWFLOWTABLE);
 			nft_trans_destroy(trans);
 			break;
@@ -7501,6 +7506,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			list_del_rcu(&nft_trans_flowtable(trans)->list);
 			nf_tables_flowtable_notify(&trans->ctx,
 						   nft_trans_flowtable(trans),
+						   &nft_trans_flowtable(trans)->hook_list,
 						   NFT_MSG_DELFLOWTABLE);
 			nft_unregister_flowtable_net_hooks(net,
 					&nft_trans_flowtable(trans)->hook_list);
-- 
2.20.1

