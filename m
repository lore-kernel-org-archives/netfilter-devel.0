Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD46C678D5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 09:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjBVJVy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 04:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjBVJVs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 04:21:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 115E437F17;
        Wed, 22 Feb 2023 01:21:48 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 8/8] netfilter: x_tables: fix percpu counter block leak on error path when creating new netns
Date:   Wed, 22 Feb 2023 10:21:37 +0100
Message-Id: <20230222092137.88637-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222092137.88637-1-pablo@netfilter.org>
References: <20230222092137.88637-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Here is the stack where we allocate percpu counter block:

  +-< __alloc_percpu
    +-< xt_percpu_counter_alloc
      +-< find_check_entry # {arp,ip,ip6}_tables.c
        +-< translate_table

And it can be leaked on this code path:

  +-> ip6t_register_table
    +-> translate_table # allocates percpu counter block
    +-> xt_register_table # fails

there is no freeing of the counter block on xt_register_table fail.
Note: xt_percpu_counter_free should be called to free it like we do in
do_replace through cleanup_entry helper (or in __ip6t_unregister_table).

Probability of hitting this error path is low AFAICS (xt_register_table
can only return ENOMEM here, as it is not replacing anything, as we are
creating new netns, and it is hard to imagine that all previous
allocations succeeded and after that one in xt_register_table failed).
But it's worth fixing even the rare leak.

Fixes: 71ae0dff02d7 ("netfilter: xtables: use percpu rule counters")
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 4 ++++
 net/ipv4/netfilter/ip_tables.c  | 4 ++++
 net/ipv6/netfilter/ip6_tables.c | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ffc0cab7cf18..2407066b0fec 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1525,6 +1525,10 @@ int arpt_register_table(struct net *net,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct arpt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index aae5fd51dfd7..da5998011ab9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1741,6 +1741,10 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ipt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ac902f7bca47..0ce0ed17c758 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1750,6 +1750,10 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ip6t_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
-- 
2.30.2

