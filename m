Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C534DC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 02:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7087164E6C
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 02:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhCDCtd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 21:49:33 -0500
Received: from correo.us.es ([193.147.175.20]:35920 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231527AbhCDCtF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 21:49:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 41507DA70F
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Mar 2021 03:48:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E177DA704
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Mar 2021 03:48:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 23299DA722; Thu,  4 Mar 2021 03:48:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9626EDA704
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Mar 2021 03:48:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Mar 2021 03:48:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7EC7E42DF560
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Mar 2021 03:48:21 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nftables: fix possible double hook unregistration with table owner
Date:   Thu,  4 Mar 2021 03:48:18 +0100
Message-Id: <20210304024818.30133-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip hook unregistration of owner tables from the netns exit path,
nft_rcv_nl_event() unregisters the table hooks before tearing down
the table content.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b07703e19108..495f320b1c93 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9024,12 +9024,17 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 		nf_tables_unregister_hook(net, table, chain);
 }
 
-static void __nft_release_hooks(struct net *net)
+static void __nft_release_hooks(struct net *net, u32 nlpid)
 {
 	struct nft_table *table;
 
-	list_for_each_entry(table, &net->nft.tables, list)
+	list_for_each_entry(table, &net->nft.tables, list) {
+		if (nft_table_has_owner(table) &&
+		    nlpid != table->nlpid)
+			continue;
+
 		__nft_release_hook(net, table);
+	}
 }
 
 static void __nft_release_table(struct net *net, struct nft_table *table)
@@ -9143,7 +9148,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_pre_exit_net(struct net *net)
 {
-	__nft_release_hooks(net);
+	__nft_release_hooks(net, 0);
 }
 
 static void __net_exit nf_tables_exit_net(struct net *net)
-- 
2.20.1

