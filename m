From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] netfilter: add nf_queue_entry forward declaration
Date: Tue,  2 Jan 2018 11:16:23 +0100
Message-ID: <20180102101644.200962-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The newly added callback pointers cause a warning for some configurations:

In file included from net/ipv6/af_inet6.c:45:0:
include/linux/netfilter_ipv6.h:38:51: error: 'struct nf_queue_entry' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]

Adding a forward declaration for the type avoids the warnings.

Fixes: 9faa679ee7ec ("netfilter: move reroute indirection to struct nf_ipv6_ops")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/netfilter_ipv4.h | 2 ++
 include/linux/netfilter_ipv6.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 0259bcde6d2e..b31dabfdb453 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -18,6 +18,8 @@ struct ip_rt_info {
 
 int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned addr_type);
 
+struct nf_queue_entry;
+
 #ifdef CONFIG_INET
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u_int8_t protocol);
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index e4cdcfdce0f9..288c597e75b3 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -18,6 +18,8 @@ struct ip6_rt_info {
 	u_int32_t mark;
 };
 
+struct nf_queue_entry;
+
 /*
  * Hook functions for ipv6 to allow xt_* modules to be built-in even
  * if IPv6 is a module.
-- 
2.9.0
