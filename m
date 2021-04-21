Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD2FC43470
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8136D6142C
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhDUHwM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 03:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbhDUHwI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 03:52:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357A3C06138D
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 00:51:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lZ7dx-0004si-Rg; Wed, 21 Apr 2021 09:51:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 07/12] netfilter: x_tables: remove paranoia tests
Date:   Wed, 21 Apr 2021 09:51:05 +0200
Message-Id: <20210421075110.19334-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210421075110.19334-1-fw@strlen.de>
References: <20210421075110.19334-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need for these.
There is only one caller, the xtables core, when the table is registered
for the first time with a particular network namespace.

After ->table_init() call, the table is linked into the tables[af] list,
so next call to that function will skip the ->table_init().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arptable_filter.c   | 3 ---
 net/ipv4/netfilter/iptable_filter.c    | 3 ---
 net/ipv4/netfilter/iptable_mangle.c    | 3 ---
 net/ipv4/netfilter/iptable_nat.c       | 3 ---
 net/ipv4/netfilter/iptable_raw.c       | 3 ---
 net/ipv4/netfilter/iptable_security.c  | 3 ---
 net/ipv6/netfilter/ip6table_filter.c   | 3 ---
 net/ipv6/netfilter/ip6table_mangle.c   | 3 ---
 net/ipv6/netfilter/ip6table_nat.c      | 3 ---
 net/ipv6/netfilter/ip6table_raw.c      | 3 ---
 net/ipv6/netfilter/ip6table_security.c | 3 ---
 11 files changed, 33 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index c121e13dc78c..924f096a6d89 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -44,9 +44,6 @@ static int __net_init arptable_filter_table_init(struct net *net)
 	struct arpt_replace *repl;
 	int err;
 
-	if (net->ipv4.arptable_filter)
-		return 0;
-
 	repl = arpt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index a39998c7977f..84573fa78d1e 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -48,9 +48,6 @@ static int __net_init iptable_filter_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int err;
 
-	if (net->ipv4.iptable_filter)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 7d1713e22553..98e9e9053d85 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -88,9 +88,6 @@ static int __net_init iptable_mangle_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int ret;
 
-	if (net->ipv4.iptable_mangle)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 16bf3009642e..f4afd28ccc06 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -90,9 +90,6 @@ static int __net_init iptable_nat_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int ret;
 
-	if (net->ipv4.nat_table)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&nf_nat_ipv4_table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index a1f556464b93..18776f5a4055 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -55,9 +55,6 @@ static int __net_init iptable_raw_table_init(struct net *net)
 	if (raw_before_defrag)
 		table = &packet_raw_before_defrag;
 
-	if (net->ipv4.iptable_raw)
-		return 0;
-
 	repl = ipt_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 33eded4f9080..3df92fb394c5 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -50,9 +50,6 @@ static int __net_init iptable_security_table_init(struct net *net)
 	struct ipt_replace *repl;
 	int ret;
 
-	if (net->ipv4.iptable_security)
-		return 0;
-
 	repl = ipt_alloc_initial_table(&security_table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 0c9f75e23ca0..2bcafa3e2d35 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -49,9 +49,6 @@ static int __net_init ip6table_filter_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int err;
 
-	if (net->ipv6.ip6table_filter)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 9a2266662508..14e22022bf41 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -81,9 +81,6 @@ static int __net_init ip6table_mangle_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int ret;
 
-	if (net->ipv6.ip6table_mangle)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&packet_mangler);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 7eb61e6b1e52..c7f98755191b 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -92,9 +92,6 @@ static int __net_init ip6table_nat_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int ret;
 
-	if (net->ipv6.ip6table_nat)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&nf_nat_ipv6_table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index c9a4aada40ba..ae3df59f0350 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -54,9 +54,6 @@ static int __net_init ip6table_raw_table_init(struct net *net)
 	if (raw_before_defrag)
 		table = &packet_raw_before_defrag;
 
-	if (net->ipv6.ip6table_raw)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 73067e08662f..83ca632cbf88 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -49,9 +49,6 @@ static int __net_init ip6table_security_table_init(struct net *net)
 	struct ip6t_replace *repl;
 	int ret;
 
-	if (net->ipv6.ip6table_security)
-		return 0;
-
 	repl = ip6t_alloc_initial_table(&security_table);
 	if (repl == NULL)
 		return -ENOMEM;
-- 
2.26.3

