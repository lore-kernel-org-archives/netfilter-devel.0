From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/15] netfilter: x_tables: add module alias for icmp matches
Date: Mon, 14 May 2018 00:36:51 +0200
Message-ID: <20180513223656.10077-11-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The icmp matches are implemented in ip_tables and ip6_tables,
respectively, so for normal iptables they are always available:
those modules are loaded once iptables calls getsockopt() to fetch
available module revisions.

In iptables-over-nftables case probing occurs via nfnetlink, so
these modules might not be loaded.  Add aliases so modprobe can load
these when icmp/icmp6 is requested.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ip_tables.c  | 1 +
 net/ipv6/netfilter/ip6_tables.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 44b308d93ec2..e85f35b89c49 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -34,6 +34,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("IPv4 packet filter");
+MODULE_ALIAS("ipt_icmp");
 
 void *ipt_alloc_initial_table(const struct xt_table *info)
 {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 65c9e1a58305..97f79dc943d7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -38,6 +38,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("IPv6 packet filter");
+MODULE_ALIAS("ip6t_icmp6");
 
 void *ip6t_alloc_initial_table(const struct xt_table *info)
 {
-- 
2.11.0
