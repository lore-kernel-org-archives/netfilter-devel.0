Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9136FC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 17:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57EDC61026
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 17:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbhDZRMv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 13:12:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51518 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbhDZRL6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 13:11:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DBE2E64134;
        Mon, 26 Apr 2021 19:10:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 15/22] netfilter: remove all xt_table anchors from struct net
Date:   Mon, 26 Apr 2021 19:10:49 +0200
Message-Id: <20210426171056.345271-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No longer needed, table pointer arg is now passed via netfilter core.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/ipv4.h | 10 ----------
 include/net/netns/ipv6.h |  9 ---------
 2 files changed, 19 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 87e1612497ea..f6af8d96d3c6 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -76,16 +76,6 @@ struct netns_ipv4 {
 	struct inet_peer_base	*peers;
 	struct sock  * __percpu	*tcp_sk;
 	struct fqdir		*fqdir;
-#ifdef CONFIG_NETFILTER
-	struct xt_table		*iptable_filter;
-	struct xt_table		*iptable_mangle;
-	struct xt_table		*iptable_raw;
-	struct xt_table		*arptable_filter;
-#ifdef CONFIG_SECURITY
-	struct xt_table		*iptable_security;
-#endif
-	struct xt_table		*nat_table;
-#endif
 
 	u8 sysctl_icmp_echo_ignore_all;
 	u8 sysctl_icmp_echo_enable_probe;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 808f0f79ea9c..6153c8067009 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -63,15 +63,6 @@ struct netns_ipv6 {
 	struct ipv6_devconf	*devconf_dflt;
 	struct inet_peer_base	*peers;
 	struct fqdir		*fqdir;
-#ifdef CONFIG_NETFILTER
-	struct xt_table		*ip6table_filter;
-	struct xt_table		*ip6table_mangle;
-	struct xt_table		*ip6table_raw;
-#ifdef CONFIG_SECURITY
-	struct xt_table		*ip6table_security;
-#endif
-	struct xt_table		*ip6table_nat;
-#endif
 	struct fib6_info	*fib6_null_entry;
 	struct rt6_info		*ip6_null_entry;
 	struct rt6_statistics   *rt6_stats;
-- 
2.30.2

