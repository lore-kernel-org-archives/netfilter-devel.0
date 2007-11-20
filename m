From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCHv5 1/2] Find address type on a specific or on any interface
Date: Tue, 20 Nov 2007 09:00:42 +0100
Message-ID: <11955456451525-git-send-email-panther@balabit.hu>
References: <11955456442652-git-send-email-panther@balabit.hu>
Cc: netfilter-devel@vger.kernel.org,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:52290 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbXKTIAu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:00:50 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 2B890C158B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Nov 2007 09:00:49 +0100 (CET)
In-Reply-To: <11955456442652-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Address type search can be limited to an interface by
inet_dev_addr_type function.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 include/net/route.h     |    1 +
 net/ipv4/fib_frontend.c |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index f7ce625..d155c29 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -119,6 +119,7 @@ extern unsigned short	ip_rt_frag_needed(struct iphdr *iph, unsigned short new_mt
 extern void		ip_rt_send_redirect(struct sk_buff *skb);
 
 extern unsigned		inet_addr_type(__be32 addr);
+extern unsigned		inet_dev_addr_type(__be32 addr, const struct net_device *dev);
 extern void		ip_rt_multicast_event(struct in_device *);
 extern int		ip_rt_ioctl(unsigned int cmd, void __user *arg);
 extern void		ip_rt_get_source(u8 *src, struct rtable *rt);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 732d8f0..f116f61 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -155,7 +155,11 @@ out:
 	return dev;
 }
 
-unsigned inet_addr_type(__be32 addr)
+/*
+ * Find address type as if only "dev" was present in the system. If
+ * on_dev is NULL then all interfaces are taken into consideration.
+ */
+static inline unsigned __inet_dev_addr_type(__be32 addr, const struct net_device *dev)
 {
 	struct flowi		fl = { .nl_u = { .ip4_u = { .daddr = addr } } };
 	struct fib_result	res;
@@ -175,13 +179,24 @@ unsigned inet_addr_type(__be32 addr)
 	if (local_table) {
 		ret = RTN_UNICAST;
 		if (!local_table->tb_lookup(local_table, &fl, &res)) {
-			ret = res.type;
+			if ((!dev || dev == res.fi->fib_dev))
+				ret = res.type;
 			fib_res_put(&res);
 		}
 	}
 	return ret;
 }
 
+unsigned inet_addr_type(__be32 addr)
+{
+	return __inet_dev_addr_type(addr, NULL);
+}
+
+unsigned inet_dev_addr_type(__be32 addr, const struct net_device *dev)
+{
+       return __inet_dev_addr_type(addr, dev);
+}
+
 /* Given (packet source, input interface) and optional (dst, oif, tos):
    - (main) check, that source is valid i.e. not broadcast or our local
      address.
@@ -925,4 +940,5 @@ void __init ip_fib_init(void)
 }
 
 EXPORT_SYMBOL(inet_addr_type);
+EXPORT_SYMBOL(inet_dev_addr_type);
 EXPORT_SYMBOL(ip_dev_find);
-- 
1.5.2.5

