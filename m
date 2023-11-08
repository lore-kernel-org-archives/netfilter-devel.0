Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54881C4167D
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 15:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbjKHP6O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Nov 2023 10:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjKHP6N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2023 10:58:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DA209C;
        Wed,  8 Nov 2023 07:58:09 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
        kadlec@netfilter.org
Subject: [PATCH net 1/5] netfilter: add missing module descriptions
Date:   Wed,  8 Nov 2023 16:57:58 +0100
Message-Id: <20231108155802.84617-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231108155802.84617-1-pablo@netfilter.org>
References: <20231108155802.84617-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

W=1 builds warn on missing MODULE_DESCRIPTION, add them.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtable_broute.c      | 1 +
 net/bridge/netfilter/ebtable_filter.c      | 1 +
 net/bridge/netfilter/ebtable_nat.c         | 1 +
 net/bridge/netfilter/ebtables.c            | 1 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 1 +
 net/ipv4/netfilter/iptable_nat.c           | 1 +
 net/ipv4/netfilter/iptable_raw.c           | 1 +
 net/ipv4/netfilter/nf_defrag_ipv4.c        | 1 +
 net/ipv4/netfilter/nf_reject_ipv4.c        | 1 +
 net/ipv6/netfilter/ip6table_nat.c          | 1 +
 net/ipv6/netfilter/ip6table_raw.c          | 1 +
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c  | 1 +
 net/ipv6/netfilter/nf_reject_ipv6.c        | 1 +
 net/netfilter/nf_conntrack_broadcast.c     | 1 +
 net/netfilter/nf_conntrack_netlink.c       | 1 +
 net/netfilter/nf_conntrack_proto.c         | 1 +
 net/netfilter/nf_nat_core.c                | 1 +
 net/netfilter/nf_tables_api.c              | 1 +
 net/netfilter/nfnetlink_osf.c              | 1 +
 net/netfilter/nft_chain_nat.c              | 1 +
 net/netfilter/nft_fib.c                    | 1 +
 net/netfilter/nft_fwd_netdev.c             | 1 +
 22 files changed, 22 insertions(+)

diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 8f19253024b0..741360219552 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -135,3 +135,4 @@ static void __exit ebtable_broute_fini(void)
 module_init(ebtable_broute_init);
 module_exit(ebtable_broute_fini);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Force packets to be routed instead of bridged");
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 278f324e6752..dacd81b12e62 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -116,3 +116,4 @@ static void __exit ebtable_filter_fini(void)
 module_init(ebtable_filter_init);
 module_exit(ebtable_filter_fini);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ebtables legacy filter table");
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 9066f7f376d5..0f2a8c6118d4 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -116,3 +116,4 @@ static void __exit ebtable_nat_fini(void)
 module_init(ebtable_nat_init);
 module_exit(ebtable_nat_fini);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ebtables legacy stateless nat table");
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index aa23479b20b2..99d82676f780 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2595,3 +2595,4 @@ EXPORT_SYMBOL(ebt_do_table);
 module_init(ebtables_init);
 module_exit(ebtables_fini);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ebtables legacy core");
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 71056ee84773..b5c406a6e765 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -416,3 +416,4 @@ module_exit(nf_conntrack_l3proto_bridge_fini);
 
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_BRIDGE));
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Bridge IPv4 and IPv6 connection tracking");
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 56f6ecc43451..4d42d0756fd7 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -170,3 +170,4 @@ module_init(iptable_nat_init);
 module_exit(iptable_nat_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("iptables legacy nat table");
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index ca5e5b21587c..0e7f53964d0a 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -108,3 +108,4 @@ static void __exit iptable_raw_fini(void)
 module_init(iptable_raw_init);
 module_exit(iptable_raw_fini);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("iptables legacy raw table");
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 265b39bc435b..482e733c3375 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -186,3 +186,4 @@ module_init(nf_defrag_init);
 module_exit(nf_defrag_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv4 defragmentation support");
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index f33aeab9424f..f01b038fc1cd 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -336,3 +336,4 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 EXPORT_SYMBOL_GPL(nf_send_unreach);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv4 packet rejection core");
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index bf3cb3a13600..52cf104e3478 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -170,3 +170,4 @@ module_init(ip6table_nat_init);
 module_exit(ip6table_nat_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Ip6tables legacy nat table");
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 08861d5d1f4d..fc9f6754028f 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -106,3 +106,4 @@ static void __exit ip6table_raw_fini(void)
 module_init(ip6table_raw_init);
 module_exit(ip6table_raw_fini);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Ip6tables legacy raw table");
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index d59b296b4f51..be7817fbc024 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -182,3 +182,4 @@ module_init(nf_defrag_init);
 module_exit(nf_defrag_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6 defragmentation support");
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 58ccdb08c0fd..d45bc54b7ea5 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -413,3 +413,4 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 EXPORT_SYMBOL_GPL(nf_send_unreach6);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6 packet rejection core");
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 9fb9b8031298..cfa0fe0356de 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -82,3 +82,4 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_conntrack_broadcast_help);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Broadcast connection tracking helper");
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 334db22199c1..fb0ae15e96df 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -57,6 +57,7 @@
 #include "nf_internals.h"
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("List and change connection tracking table");
 
 struct ctnetlink_list_dump_ctx {
 	struct nf_conn *last;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index c928ff63b10e..f36727ed91e1 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -699,3 +699,4 @@ MODULE_ALIAS("ip_conntrack");
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv4 and IPv6 connection tracking");
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index c4e0516a8dfa..c3d7ecbc777c 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1263,6 +1263,7 @@ static void __exit nf_nat_cleanup(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Network address translation core");
 
 module_init(nf_nat_init);
 module_exit(nf_nat_cleanup);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3c1fd8283bf4..146b7447a969 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11386,4 +11386,5 @@ module_exit(nf_tables_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Framework for packet filtering and classification");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFTABLES);
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 50723ba08289..c0fc431991e8 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -447,4 +447,5 @@ module_init(nfnl_osf_init);
 module_exit(nfnl_osf_fini);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Passive OS fingerprint matching");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_OSF);
diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index 98e4946100c5..40e230d8b712 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -137,6 +137,7 @@ module_init(nft_chain_nat_init);
 module_exit(nft_chain_nat_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("nftables network address translation support");
 #ifdef CONFIG_NF_TABLES_IPV4
 MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
 #endif
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 04b51f285332..1bfe258018da 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -204,4 +204,5 @@ bool nft_fib_reduce(struct nft_regs_track *track,
 EXPORT_SYMBOL_GPL(nft_fib_reduce);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Query routing table from nftables");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a5268e6dd32f..358e742afad7 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -270,4 +270,5 @@ module_exit(nft_fwd_netdev_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("nftables netdev packet forwarding support");
 MODULE_ALIAS_NFT_AF_EXPR(5, "fwd");
-- 
2.30.2

