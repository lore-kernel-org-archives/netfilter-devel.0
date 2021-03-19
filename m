Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862A5C43333
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 01:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574F564DF2
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 01:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhCSBGh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhCSBGU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 21:06:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC3CFC06175F;
        Thu, 18 Mar 2021 18:06:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 14FC762C18;
        Fri, 19 Mar 2021 02:06:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/9] Revert "netfilter: x_tables: Update remaining dereference to RCU"
Date:   Fri, 19 Mar 2021 02:06:00 +0100
Message-Id: <20210319010608.9758-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210319010608.9758-1-pablo@netfilter.org>
References: <20210319010608.9758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

This reverts commit 443d6e86f821a165fae3fc3fc13086d27ac140b1.

This (and the following) patch basically re-implemented the RCU
mechanisms of patch 784544739a25. That patch was replaced because of the
performance problems that it created when replacing tables. Now, we have
the same issue: the call to synchronize_rcu() makes replacing tables
slower by as much as an order of magnitude.

Revert these patches and fix the issue in a different way.

Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c576a63d09db..563b62b76a5f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1379,7 +1379,7 @@ static int compat_get_entries(struct net *net,
 	xt_compat_lock(NFPROTO_ARP);
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 
 		ret = compat_table_info(private, &info);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e8f6f9d86237..6e2851f8d3a3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1589,7 +1589,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0d453fa9e327..c4f532f4d311 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1598,7 +1598,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = xt_table_get_private_protected(t);
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)
-- 
2.20.1

