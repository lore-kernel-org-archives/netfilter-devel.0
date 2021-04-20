Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B200CC433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 12:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D10E613BF
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 12:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhDTM0L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 08:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhDTM0L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 08:26:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70070C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 05:25:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lYpRj-0008Et-39; Tue, 20 Apr 2021 14:25:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 06/12] netfilter: arptables: unregister the tables by name
Date:   Tue, 20 Apr 2021 14:25:01 +0200
Message-Id: <20210420122507.505-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210420122507.505-1-fw@strlen.de>
References: <20210420122507.505-1-fw@strlen.de>
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

