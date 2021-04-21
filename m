Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3E0C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE31361434
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhDUHwL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 03:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237424AbhDUHwG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 03:52:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00752C06138B
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 00:51:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lZ7dw-0004sb-MR; Wed, 21 Apr 2021 09:51:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 06/12] netfilter: arptables: unregister the tables by name
Date:   Wed, 21 Apr 2021 09:51:04 +0200
Message-Id: <20210421075110.19334-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210421075110.19334-1-fw@strlen.de>
References: <20210421075110.19334-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

and again, this time for arptables.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_arp/arp_tables.h |  4 ++--
 net/ipv4/netfilter/arp_tables.c          | 14 ++++++++++----
 net/ipv4/netfilter/arptable_filter.c     |  8 ++------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 26a13294318c..9ec73dcc8fd6 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -52,8 +52,8 @@ extern void *arpt_alloc_initial_table(const struct xt_table *);
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
-void arpt_unregister_table(struct net *net, struct xt_table *table);
-void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+void arpt_unregister_table(struct net *net, const char *name);
+void arpt_unregister_table_pre_exit(struct net *net, const char *name,
 				    const struct nf_hook_ops *ops);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d6d45d820d79..8a16b0dc5271 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1541,16 +1541,22 @@ int arpt_register_table(struct net *net,
 	return ret;
 }
 
-void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+void arpt_unregister_table_pre_exit(struct net *net, const char *name,
 				    const struct nf_hook_ops *ops)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
+
+	if (table)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 }
 EXPORT_SYMBOL(arpt_unregister_table_pre_exit);
 
-void arpt_unregister_table(struct net *net, struct xt_table *table)
+void arpt_unregister_table(struct net *net, const char *name)
 {
-	__arpt_unregister_table(net, table);
+	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
+
+	if (table)
+		__arpt_unregister_table(net, table);
 }
 
 /* The built-in targets: standard (NULL) and error. */
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 6c300ba5634e..c121e13dc78c 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -58,16 +58,12 @@ static int __net_init arptable_filter_table_init(struct net *net)
 
 static void __net_exit arptable_filter_net_pre_exit(struct net *net)
 {
-	if (net->ipv4.arptable_filter)
-		arpt_unregister_table_pre_exit(net, net->ipv4.arptable_filter,
-					       arpfilter_ops);
+	arpt_unregister_table_pre_exit(net, "filter", arpfilter_ops);
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
-	if (!net->ipv4.arptable_filter)
-		return;
-	arpt_unregister_table(net, net->ipv4.arptable_filter);
+	arpt_unregister_table(net, "filter");
 	net->ipv4.arptable_filter = NULL;
 }
 
-- 
2.26.3

