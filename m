From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/20]: nf_conntrack: add NetBIOS name service helper
	port
Date: Sat,  2 Dec 2006 15:50:00 +0100 (MET)
Message-ID: <20061202145304.1381.38308.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: add NetBIOS name service helper port

Add nf_conntrack port of the NetBIOS name service conntrack helper.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ce27c390f71686cd741496297293a29a494df3d7
tree a54cffd39866457922150a4c9b9ac49eda693229
parent 40f6096353cbb0a314c42355ad927c54a849d092
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:16 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:16 +0100

 net/netfilter/Kconfig                   |   19 +++++
 net/netfilter/Makefile                  |    1 
 net/netfilter/nf_conntrack_netbios_ns.c |  125 +++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index bd50897..d1a365d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -194,6 +194,25 @@ config NF_CONNTRACK_IRC
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_NETBIOS_NS
+	tristate "NetBIOS name service protocol support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	help
+	  NetBIOS name service requests are sent as broadcast messages from an
+	  unprivileged port and responded to with unicast messages to the
+	  same port. This make them hard to firewall properly because connection
+	  tracking doesn't deal with broadcasts. This helper tracks locally
+	  originating NetBIOS name service requests and the corresponding
+	  responses. It relies on correct IP address configuration, specifically
+	  netmask and broadcast address. When properly configured, the output
+	  of "ip address show" should look similar to this:
+
+	  $ ip -4 address show eth0
+	  4: eth0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 1000
+	      inet 172.16.2.252/24 brd 172.16.2.255 scope global eth0
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 343fd48..67144b2 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_NF_CONNTRACK_AMANDA) += nf_
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
 obj-$(CONFIG_NF_CONNTRACK_H323) += nf_conntrack_h323.o
 obj-$(CONFIG_NF_CONNTRACK_IRC) += nf_conntrack_irc.o
+obj-$(CONFIG_NF_CONNTRACK_NETBIOS_NS) += nf_conntrack_netbios_ns.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
new file mode 100644
index 0000000..4fad3ad
--- /dev/null
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -0,0 +1,125 @@
+/*
+ *      NetBIOS name service broadcast connection tracking helper
+ *
+ *      (c) 2005 Patrick McHardy <kaber@trash.net>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+/*
+ *      This helper tracks locally originating NetBIOS name service
+ *      requests by issuing permanent expectations (valid until
+ *      timing out) matching all reply connections from the
+ *      destination network. The only NetBIOS specific thing is
+ *      actually the port number.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/if_addr.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <net/route.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+
+#define NMBD_PORT	137
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip_conntrack_netbios_ns");
+
+static unsigned int timeout __read_mostly = 3;
+module_param(timeout, uint, 0400);
+MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
+
+static int help(struct sk_buff **pskb, unsigned int protoff,
+                struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	struct nf_conntrack_expect *exp;
+	struct iphdr *iph = (*pskb)->nh.iph;
+	struct rtable *rt = (struct rtable *)(*pskb)->dst;
+	struct in_device *in_dev;
+	__be32 mask = 0;
+
+	/* we're only interested in locally generated packets */
+	if ((*pskb)->sk == NULL)
+		goto out;
+	if (rt == NULL || !(rt->rt_flags & RTCF_BROADCAST))
+		goto out;
+	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
+		goto out;
+
+	rcu_read_lock();
+	in_dev = __in_dev_get_rcu(rt->u.dst.dev);
+	if (in_dev != NULL) {
+		for_primary_ifa(in_dev) {
+			if (ifa->ifa_broadcast == iph->daddr) {
+				mask = ifa->ifa_mask;
+				break;
+			}
+		} endfor_ifa(in_dev);
+	}
+	rcu_read_unlock();
+
+	if (mask == 0)
+		goto out;
+
+	exp = nf_conntrack_expect_alloc(ct);
+	if (exp == NULL)
+		goto out;
+
+	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+	exp->tuple.src.u.udp.port = htons(NMBD_PORT);
+
+	exp->mask.src.u3.ip       = mask;
+	exp->mask.src.u.udp.port  = htons(0xFFFF);
+	exp->mask.dst.u3.ip       = htonl(0xFFFFFFFF);
+	exp->mask.dst.u.udp.port  = htons(0xFFFF);
+	exp->mask.dst.protonum    = 0xFF;
+
+	exp->expectfn             = NULL;
+	exp->flags                = NF_CT_EXPECT_PERMANENT;
+
+	nf_conntrack_expect_related(exp);
+	nf_conntrack_expect_put(exp);
+
+	nf_ct_refresh(ct, *pskb, timeout * HZ);
+out:
+	return NF_ACCEPT;
+}
+
+static struct nf_conntrack_helper helper __read_mostly = {
+	.name			= "netbios-ns",
+	.tuple.src.l3num	= AF_INET,
+	.tuple.src.u.udp.port	= __constant_htons(NMBD_PORT),
+	.tuple.dst.protonum	= IPPROTO_UDP,
+	.mask.src.l3num		= 0xFFFF,
+	.mask.src.u.udp.port	= __constant_htons(0xFFFF),
+	.mask.dst.protonum	= 0xFF,
+	.max_expected		= 1,
+	.me			= THIS_MODULE,
+	.help			= help,
+};
+
+static int __init nf_conntrack_netbios_ns_init(void)
+{
+	helper.timeout = timeout;
+	return nf_conntrack_helper_register(&helper);
+}
+
+static void __exit nf_conntrack_netbios_ns_fini(void)
+{
+	nf_conntrack_helper_unregister(&helper);
+}
+
+module_init(nf_conntrack_netbios_ns_init);
+module_exit(nf_conntrack_netbios_ns_fini);
