Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78992C43460
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 12:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 462B0611F2
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 12:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhDTM0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 08:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhDTM0H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 08:26:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9F0C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 05:25:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lYpRe-0008Em-Ur; Tue, 20 Apr 2021 14:25:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 05/12] netfilter: ip6tables: unregister the tables by name
Date:   Tue, 20 Apr 2021 14:25:00 +0200
Message-Id: <20210420122507.505-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210420122507.505-1-fw@strlen.de>
References: <20210420122507.505-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same as the previous patch, but for ip6tables.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_ipv6/ip6_tables.h |  4 ++--
 net/ipv6/netfilter/ip6_tables.c           | 14 ++++++++++----
 net/ipv6/netfilter/ip6table_filter.c      |  9 +++------
 net/ipv6/netfilter/ip6table_mangle.c      |  9 ++-------
 net/ipv6/netfilter/ip6table_nat.c         |  6 ++----
 net/ipv6/netfilter/ip6table_raw.c         |  9 +++------
 net/ipv6/netfilter/ip6table_security.c    |  8 ++------
 7 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index b88a27ce61b0..8c07426e18a8 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -27,9 +27,9 @@ extern void *ip6t_alloc_initial_table(const struct xt_table *);
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
-void ip6t_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+void ip6t_unregister_table_pre_exit(struct net *net, const char *name,
 				    const struct nf_hook_ops *ops);
-void ip6t_unregister_table_exit(struct net *net, struct xt_table *table);
+void ip6t_unregister_table_exit(struct net *net, const char *name);
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e605c28cfed5..11c80da12ee3 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1769,15 +1769,21 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 	return ret;
 }
 
-void ip6t_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+void ip6t_unregister_table_pre_exit(struct net *net, const char *name,
 				    const struct nf_hook_ops *ops)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	struct xt_table *table = xt_find_table(net, NFPROTO_IPV6, name);
+
+	if (table)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 }
 
-void ip6t_unregister_table_exit(struct net *net, struct xt_table *table)
+void ip6t_unregister_table_exit(struct net *net, const char *name)
 {
-	__ip6t_unregister_table(net, table);
+	struct xt_table *table = xt_find_table(net, NFPROTO_IPV6, name);
+
+	if (table)
+		__ip6t_unregister_table(net, table);
 }
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 88337b51ffbf..0c9f75e23ca0 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -75,16 +75,13 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 
 static void __net_exit ip6table_filter_net_pre_exit(struct net *net)
 {
-	if (net->ipv6.ip6table_filter)
-		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_filter,
-					       filter_ops);
+	ip6t_unregister_table_pre_exit(net, "filter",
+				       filter_ops);
 }
 
 static void __net_exit ip6table_filter_net_exit(struct net *net)
 {
-	if (!net->ipv6.ip6table_filter)
-		return;
-	ip6t_unregister_table_exit(net, net->ipv6.ip6table_filter);
+	ip6t_unregister_table_exit(net, "filter");
 	net->ipv6.ip6table_filter = NULL;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index cee74803d7a1..9a2266662508 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -95,17 +95,12 @@ static int __net_init ip6table_mangle_table_init(struct net *net)
 
 static void __net_exit ip6table_mangle_net_pre_exit(struct net *net)
 {
-	if (net->ipv6.ip6table_mangle)
-		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_mangle,
-					       mangle_ops);
+	ip6t_unregister_table_pre_exit(net, "mangle", mangle_ops);
 }
 
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
 {
-	if (!net->ipv6.ip6table_mangle)
-		return;
-
-	ip6t_unregister_table_exit(net, net->ipv6.ip6table_mangle);
+	ip6t_unregister_table_exit(net, "mangle");
 	net->ipv6.ip6table_mangle = NULL;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 4cef1b405074..7eb61e6b1e52 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -107,7 +107,7 @@ static int __net_init ip6table_nat_table_init(struct net *net)
 
 	ret = ip6t_nat_register_lookups(net);
 	if (ret < 0) {
-		ip6t_unregister_table_exit(net, net->ipv6.ip6table_nat);
+		ip6t_unregister_table_exit(net, "nat");
 		net->ipv6.ip6table_nat = NULL;
 	}
 	kfree(repl);
@@ -122,9 +122,7 @@ static void __net_exit ip6table_nat_net_pre_exit(struct net *net)
 
 static void __net_exit ip6table_nat_net_exit(struct net *net)
 {
-	if (!net->ipv6.ip6table_nat)
-		return;
-	ip6t_unregister_table_exit(net, net->ipv6.ip6table_nat);
+	ip6t_unregister_table_exit(net, "nat");
 	net->ipv6.ip6table_nat = NULL;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 8f9e742226f7..c9a4aada40ba 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -68,16 +68,13 @@ static int __net_init ip6table_raw_table_init(struct net *net)
 
 static void __net_exit ip6table_raw_net_pre_exit(struct net *net)
 {
-	if (net->ipv6.ip6table_raw)
-		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_raw,
-					       rawtable_ops);
+	ip6t_unregister_table_pre_exit(net, "raw",
+				       rawtable_ops);
 }
 
 static void __net_exit ip6table_raw_net_exit(struct net *net)
 {
-	if (!net->ipv6.ip6table_raw)
-		return;
-	ip6t_unregister_table_exit(net, net->ipv6.ip6table_raw);
+	ip6t_unregister_table_exit(net, "raw");
 	net->ipv6.ip6table_raw = NULL;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 5e8c48fed032..73067e08662f 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -63,16 +63,12 @@ static int __net_init ip6table_security_table_init(struct net *net)
 
 static void __net_exit ip6table_security_net_pre_exit(struct net *net)
 {
-	if (net->ipv6.ip6table_security)
-		ip6t_unregister_table_pre_exit(net, net->ipv6.ip6table_security,
-					       sectbl_ops);
+	ip6t_unregister_table_pre_exit(net, "security", sectbl_ops);
 }
 
 static void __net_exit ip6table_security_net_exit(struct net *net)
 {
-	if (!net->ipv6.ip6table_security)
-		return;
-	ip6t_unregister_table_exit(net, net->ipv6.ip6table_security);
+	ip6t_unregister_table_exit(net, "security");
 	net->ipv6.ip6table_security = NULL;
 }
 
-- 
2.26.3

