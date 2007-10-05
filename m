From: =?utf-8?q?T=C3=B3th=20L=C3=A1szl=C3=B3=20Attila?=
	<panther@balabit.hu>
Subject: [PATCH 1/2] Find address type on a specific or on any interface
Date: Fri, 5 Oct 2007 17:20:34 +0200
Message-ID: <8801194d4668d655049cc103f7037c309ec950ac.1191598313.git.panther@balabit.hu>
References: <addrtype-20071005-1725.1191598313.git.panther@balabit.hu>
To: undisclosed-recipients:;
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:60190 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763391AbXJEQDm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:03:42 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 4B73CC123D
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Oct 2007 18:03:41 +0200 (CEST)
In-Reply-To: <addrtype-20071005-1725.1191598313.git.panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Address type search can be limited to any interface by
inet_addr_type_on_dev function.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/net/route.h     |    1 +
 net/ipv4/fib_frontend.c |   21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index f7ce625..4a0e3bc 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -119,6 +119,7 @@ extern unsigned short	ip_rt_frag_needed(struct iphdr *iph, unsigned short new_mt
 extern void		ip_rt_send_redirect(struct sk_buff *skb);
 
 extern unsigned		inet_addr_type(__be32 addr);
+extern unsigned		inet_addr_type_on_dev(__be32 addr, const struct net_device *on_dev);
 extern void		ip_rt_multicast_event(struct in_device *);
 extern int		ip_rt_ioctl(unsigned int cmd, void __user *arg);
 extern void		ip_rt_get_source(u8 *src, struct rtable *rt);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index eff6bce..9d93a20 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -145,7 +145,11 @@ out:
 	return dev;
 }
 
-unsigned inet_addr_type(__be32 addr)
+/*
+ * Find address type as if only "on_dev" was present in the system. If
+ * on_dev is NULL then all interfaces are taken into consideration.
+ */
+static inline unsigned __inet_addr_type_on_dev(__be32 addr, const struct net_device *on_dev)
 {
 	struct flowi		fl = { .nl_u = { .ip4_u = { .daddr = addr } } };
 	struct fib_result	res;
@@ -164,13 +168,25 @@ unsigned inet_addr_type(__be32 addr)
 		ret = RTN_UNICAST;
 		if (!ip_fib_local_table->tb_lookup(ip_fib_local_table,
 						   &fl, &res)) {
-			ret = res.type;
+			if ((!on_dev || on_dev == res.fi->fib_dev)) {
+			        ret = res.type;
+			}
 			fib_res_put(&res);
 		}
 	}
 	return ret;
 }
 
+unsigned inet_addr_type(__be32 addr)
+{
+  return __inet_addr_type_on_dev(addr, NULL);
+}
+
+unsigned inet_addr_type_on_dev(__be32 addr, const struct net_device *on_dev)
+{
+  return __inet_addr_type_on_dev(addr, on_dev);
+}
+
 /* Given (packet source, input interface) and optional (dst, oif, tos):
    - (main) check, that source is valid i.e. not broadcast or our local
      address.
@@ -922,4 +938,5 @@ void __init ip_fib_init(void)
 }
 
 EXPORT_SYMBOL(inet_addr_type);
+EXPORT_SYMBOL(inet_addr_type_on_dev);
 EXPORT_SYMBOL(ip_dev_find);
-- 
1.5.2.5

