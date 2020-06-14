Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4620C433E2
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE632071A
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgFNVxP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 17:53:15 -0400
Received: from correo.us.es ([193.147.175.20]:59952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgFNVxO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 17:53:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E6081B5701
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jun 2020 23:53:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D54F7DA789
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jun 2020 23:53:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4A35DA73D; Sun, 14 Jun 2020 23:53:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A966ADA78D;
        Sun, 14 Jun 2020 23:53:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 14 Jun 2020 23:53:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 78535426CCBB;
        Sun, 14 Jun 2020 23:53:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/4] netfilter: nf_tables: hook list memleak in flowtable deletion
Date:   Sun, 14 Jun 2020 23:53:01 +0200
Message-Id: <20200614215301.9101-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200614215301.9101-1-pablo@netfilter.org>
References: <20200614215301.9101-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After looking up for the flowtable hooks that need to be removed,
release the hook objects in the deletion list. The error path needs to
released these hook objects too.

Fixes: abadb2f865d7 ("netfilter: nf_tables: delete devices from flowtable")
Reported-by: syzbot+eb9d5924c51d6d59e094@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 073aa1051d43..7647ecfa0d40 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6550,12 +6550,22 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook)
+{
+	struct nft_hook *this, *next;
+
+	list_for_each_entry_safe(this, next, &flowtable_hook->list, list) {
+		list_del(&this->list);
+		kfree(this);
+	}
+}
+
 static int nft_delflowtable_hook(struct nft_ctx *ctx,
 				 struct nft_flowtable *flowtable)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
-	struct nft_hook *this, *next, *hook;
+	struct nft_hook *this, *hook;
 	struct nft_trans *trans;
 	int err;
 
@@ -6564,33 +6574,40 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	list_for_each_entry_safe(this, next, &flowtable_hook.list, list) {
+	list_for_each_entry(this, &flowtable_hook.list, list) {
 		hook = nft_hook_list_find(&flowtable->hook_list, this);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
 		hook->inactive = true;
-		list_del(&this->list);
-		kfree(this);
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
 				sizeof(struct nft_trans_flowtable));
-	if (!trans)
-		return -ENOMEM;
+	if (!trans) {
+		err = -ENOMEM;
+		goto err_flowtable_del_hook;
+	}
 
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	nft_flowtable_hook_release(&flowtable_hook);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	return 0;
 
 err_flowtable_del_hook:
-	list_for_each_entry(hook, &flowtable_hook.list, list)
+	list_for_each_entry(this, &flowtable_hook.list, list) {
+		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		if (!hook)
+			break;
+
 		hook->inactive = false;
+	}
+	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
 }
-- 
2.20.1

