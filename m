Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D4AC433E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 17:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CCA206E2
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 17:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgE2Ruj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 13:50:39 -0400
Received: from correo.us.es ([193.147.175.20]:58836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgE2Ruh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 13:50:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B91F8140F
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 19:50:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EC24DA716
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 19:50:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 841B8DA723; Fri, 29 May 2020 19:50:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 505C5DA713;
        Fri, 29 May 2020 19:50:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1C0FC42EE38E;
        Fri, 29 May 2020 19:50:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/9] netfilter: nf_tables: add nft_flowtable_hooks_destroy()
Date:   Fri, 29 May 2020 19:50:21 +0200
Message-Id: <20200529175026.30541-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529175026.30541-1-pablo@netfilter.org>
References: <20200529175026.30541-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a helper function destroy the flowtable hooks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1505552aaa74..f5d100787ccb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6339,6 +6339,16 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
+static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
+{
+	struct nft_hook *hook, *next;
+
+	list_for_each_entry_safe(hook, next, hook_list, list) {
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
+	}
+}
+
 static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct sk_buff *skb,
 				  const struct nlmsghdr *nlh,
@@ -6433,10 +6443,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
-		list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-			list_del_rcu(&hook->list);
-			kfree_rcu(hook, rcu);
-		}
+		nft_flowtable_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
 
-- 
2.20.1

