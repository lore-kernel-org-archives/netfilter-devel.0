From: Patrick McHardy <kaber@trash.net>
Subject: [IPV4 07/49]: Add inet_dev_addr_type()
Date: Tue,  4 Dec 2007 13:02:05 +0100 (MET)
Message-ID: <20071204120205.2442.63458.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62118 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXLDMCG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:06 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[IPV4]: Add inet_dev_addr_type()

Address type search can be limited to an interface by
inet_dev_addr_type function.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f7856f723b508049e599b8126cd17246bdaed633
tree 8231eecded93da7cc99ddbbbf2e87953d2242224
parent 120d4e83e930079caf86168dea4ee6f3eab1fe88
author Laszlo Attila Toth <panther@balabit.hu> Tue, 04 Dec 2007 10:46:59 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:46:59 +0100

 include/net/route.h     |    1 +
 net/ipv4/fib_frontend.c |   21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index f7ce625..723b519 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -119,6 +119,7 @@ extern unsigned short	ip_rt_frag_needed(struct iphdr *iph, unsigned short new_mt
 extern void		ip_rt_send_redirect(struct sk_buff *skb);
 
 extern unsigned		inet_addr_type(__be32 addr);
+extern unsigned		inet_dev_addr_type(const struct net_device *dev, __be32 addr);
 extern void		ip_rt_multicast_event(struct in_device *);
 extern int		ip_rt_ioctl(unsigned int cmd, void __user *arg);
 extern void		ip_rt_get_source(u8 *src, struct rtable *rt);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index c211887..7962830 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -155,7 +155,12 @@ out:
 	return dev;
 }
 
-unsigned inet_addr_type(__be32 addr)
+/*
+ * Find address type as if only "dev" was present in the system. If
+ * on_dev is NULL then all interfaces are taken into consideration.
+ */
+static inline unsigned __inet_dev_addr_type(const struct net_device *dev,
+					    __be32 addr)
 {
 	struct flowi		fl = { .nl_u = { .ip4_u = { .daddr = addr } } };
 	struct fib_result	res;
@@ -175,13 +180,24 @@ unsigned inet_addr_type(__be32 addr)
 	if (local_table) {
 		ret = RTN_UNICAST;
 		if (!local_table->tb_lookup(local_table, &fl, &res)) {
-			ret = res.type;
+			if (!dev || dev == res.fi->fib_dev)
+				ret = res.type;
 			fib_res_put(&res);
 		}
 	}
 	return ret;
 }
 
+unsigned int inet_addr_type(__be32 addr)
+{
+	return __inet_dev_addr_type(NULL, addr);
+}
+
+unsigned int inet_dev_addr_type(const struct net_device *dev, __be32 addr)
+{
+       return __inet_dev_addr_type(dev, addr);
+}
+
 /* Given (packet source, input interface) and optional (dst, oif, tos):
    - (main) check, that source is valid i.e. not broadcast or our local
      address.
@@ -937,4 +953,5 @@ void __init ip_fib_init(void)
 }
 
 EXPORT_SYMBOL(inet_addr_type);
+EXPORT_SYMBOL(inet_dev_addr_type);
 EXPORT_SYMBOL(ip_dev_find);
