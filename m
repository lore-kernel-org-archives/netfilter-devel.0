Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C0BC10F29
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C294920658
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 13:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgCQNN6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:13:58 -0400
Received: from correo.us.es ([193.147.175.20]:51616 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgCQNN6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 09:13:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 789D7F23A4
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69712DA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5DDC9FC5E6; Tue, 17 Mar 2020 14:13:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A2CEDA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Mar 2020 14:13:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8594942EE399
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2020 14:13:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/3] netfilter: nf_tables: pass context to nft_set_destroy()
Date:   Tue, 17 Mar 2020 14:13:45 +0100
Message-Id: <20200317131346.30544-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200317131346.30544-1-pablo@netfilter.org>
References: <20200317131346.30544-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patch that adds support for stateful expressions in set definitions
require this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4f6245e7988e..df046cd97fa7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4126,7 +4126,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	return err;
 }
 
-static void nft_set_destroy(struct nft_set *set)
+static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (WARN_ON(set->use > 0))
 		return;
@@ -4271,7 +4271,7 @@ EXPORT_SYMBOL_GPL(nf_tables_deactivate_set);
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
-		nft_set_destroy(set);
+		nft_set_destroy(ctx, set);
 }
 EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
 
@@ -7020,7 +7020,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
-		nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_DELSETELEM:
 		nf_tables_set_elem_destroy(&trans->ctx,
@@ -7451,7 +7451,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
@@ -8177,7 +8177,7 @@ static void __nft_release_tables(struct net *net)
 		list_for_each_entry_safe(set, ns, &table->sets, list) {
 			list_del(&set->list);
 			table->use--;
-			nft_set_destroy(set);
+			nft_set_destroy(&ctx, set);
 		}
 		list_for_each_entry_safe(obj, ne, &table->objects, list) {
 			nft_obj_del(obj);
-- 
2.11.0

