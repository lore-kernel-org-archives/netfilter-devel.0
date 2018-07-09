From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6] netfilter: x_tables: set module owner for icmp(6) matches
Date: Mon,  9 Jul 2018 19:18:59 +0200
Message-ID: <20180709171904.2460-2-pablo@netfilter.org>
References: <20180709171904.2460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180709171904.2460-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nft_compat relies on xt_request_find_match to increment
refcount of the module that provides the match/target.

The (builtin) icmp matches did't set the module owner so it
was possible to rmmod ip(6)tables while icmp extensions were still in use.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ip_tables.c  | 1 +
 net/ipv6/netfilter/ip6_tables.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index ca0dad90803a..e77872c93c20 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1898,6 +1898,7 @@ static struct xt_match ipt_builtin_mt[] __read_mostly = {
 		.checkentry = icmp_checkentry,
 		.proto      = IPPROTO_ICMP,
 		.family     = NFPROTO_IPV4,
+		.me	    = THIS_MODULE,
 	},
 };
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7eab959734bc..daf2e9e9193d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1909,6 +1909,7 @@ static struct xt_match ip6t_builtin_mt[] __read_mostly = {
 		.checkentry = icmp6_checkentry,
 		.proto      = IPPROTO_ICMPV6,
 		.family     = NFPROTO_IPV6,
+		.me	    = THIS_MODULE,
 	},
 };
 
-- 
2.11.0
