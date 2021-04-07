Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E26C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Apr 2021 19:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3DF61177
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Apr 2021 19:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355683AbhDGToG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 15:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355674AbhDGToF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 15:44:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B43C06175F
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Apr 2021 12:43:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lUE5i-00028e-Cx; Wed, 07 Apr 2021 21:43:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: arp_tables: netfilter: bridge: add pre_exit hook for table unregister
Date:   Wed,  7 Apr 2021 21:43:40 +0200
Message-Id: <20210407194340.21594-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210407194340.21594-1-fw@strlen.de>
References: <20210407194340.21594-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same problem that also existed in iptables/ip(6)tables, when
arptable_filter is removed there is no longer a wait period before the
table/ruleset is free'd.

Unregister the hook in pre_exit, then remove the table in the exit
function.
This used to work correctly because the old nf_hook_unregister API
did unconditional synchronize_net.

The per-net hook unregister function uses call_rcu instead.

Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_arp/arp_tables.h |  5 +++--
 net/ipv4/netfilter/arp_tables.c          |  9 +++++++--
 net/ipv4/netfilter/arptable_filter.c     | 10 +++++++++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 7d3537c40ec9..26a13294318c 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -52,8 +52,9 @@ extern void *arpt_alloc_initial_table(const struct xt_table *);
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
-void arpt_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops);
+void arpt_unregister_table(struct net *net, struct xt_table *table);
+void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d1e04d2b5170..6c26533480dd 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1539,10 +1539,15 @@ int arpt_register_table(struct net *net,
 	return ret;
 }
 
-void arpt_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops)
+void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops)
 {
 	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+EXPORT_SYMBOL(arpt_unregister_table_pre_exit);
+
+void arpt_unregister_table(struct net *net, struct xt_table *table)
+{
 	__arpt_unregister_table(net, table);
 }
 
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index c216b9ad3bb2..6c300ba5634e 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -56,16 +56,24 @@ static int __net_init arptable_filter_table_init(struct net *net)
 	return err;
 }
 
+static void __net_exit arptable_filter_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.arptable_filter)
+		arpt_unregister_table_pre_exit(net, net->ipv4.arptable_filter,
+					       arpfilter_ops);
+}
+
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
 	if (!net->ipv4.arptable_filter)
 		return;
-	arpt_unregister_table(net, net->ipv4.arptable_filter, arpfilter_ops);
+	arpt_unregister_table(net, net->ipv4.arptable_filter);
 	net->ipv4.arptable_filter = NULL;
 }
 
 static struct pernet_operations arptable_filter_net_ops = {
 	.exit = arptable_filter_net_exit,
+	.pre_exit = arptable_filter_net_pre_exit,
 };
 
 static int __init arptable_filter_init(void)
-- 
2.26.3

