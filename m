From: Patrick McHardy <kaber@trash.net>
Subject: [RFC NETFILTER 2/2]: Add NetBIOS name service helper
Date: Sun, 04 Sep 2005 13:49:42 +0200
Message-ID: <431ADF56.2050000@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Add NetBIOS name service helper

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0d787bce27efe5d9bf8bf71cf331034ec80a24d1
tree 0fe083c63885cb14edab4891b842c38ee183095a
parent bd8f79e9d585ff9022850cadc5a1e6b81b8bafda
author Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 06:11:39 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 06:11:39 +0200

 net/ipv4/netfilter/Kconfig                   |   19 ++++
 net/ipv4/netfilter/Makefile                  |    1 
 net/ipv4/netfilter/ip_conntrack_netbios_ns.c |  131 ++++++++++++++++++++++++++
 3 files changed, 151 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -85,6 +85,25 @@ config IP_NF_IRC
 
 	  To compile it as a module, choose M here.  If unsure, say Y.
 
+config IP_NF_NETBIOS_NS
+	tristate "NetBIOS name service protocol support (EXPERIMENTAL)"
+	depends on IP_NF_CONNTRACK && EXPERIMENTAL
+	help
+	  NetBIOS name service requests are sent as broadcast message from an
+	  unpriviledged port and responded to with unicast messages to the
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
 config IP_NF_TFTP
 	tristate "TFTP protocol support"
 	depends on IP_NF_CONNTRACK
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_IP_NF_AMANDA) += ip_conntra
 obj-$(CONFIG_IP_NF_TFTP) += ip_conntrack_tftp.o
 obj-$(CONFIG_IP_NF_FTP) += ip_conntrack_ftp.o
 obj-$(CONFIG_IP_NF_IRC) += ip_conntrack_irc.o
+obj-$(CONFIG_IP_NF_NETBIOS_NS) += ip_conntrack_netbios_ns.o
 
 # NAT helpers 
 obj-$(CONFIG_IP_NF_NAT_AMANDA) += ip_nat_amanda.o
diff --git a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
new file mode 100644
--- /dev/null
+++ b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
@@ -0,0 +1,131 @@
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
+ *      requests by issueing permanent expectations (valid until
+ *      timeing out) matching all reply connections from the
+ *      destination network. The only NetBIOS specific thing is
+ *      actually the port number.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <net/route.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
+MODULE_LICENSE("GPL");
+
+static unsigned int timeout = 3;
+module_param(timeout, int, 0600);
+MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
+
+static int help(struct sk_buff **pskb,
+                struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
+{
+	struct ip_conntrack_expect *exp;
+	struct iphdr *iph = (*pskb)->nh.iph;
+	struct udphdr _uh, *uh;
+	struct rtable *rt = (struct rtable *)(*pskb)->dst;
+	struct in_device *in_dev;
+	u_int32_t mask = 0;
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
+	in_dev = __in_dev_get(rt->u.dst.dev);
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
+	uh = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_uh), &_uh);
+	BUG_ON(uh == NULL);
+
+	exp = ip_conntrack_expect_alloc(ct);
+	if (exp == NULL)
+		goto out;
+	memset(&exp->tuple, 0, sizeof(exp->tuple));
+	exp->tuple.src.ip         = iph->daddr & mask;
+	exp->tuple.dst.ip         = iph->saddr;
+	exp->tuple.dst.u.udp.port = uh->source;
+	exp->tuple.dst.protonum   = IPPROTO_UDP;
+
+	memset(&exp->mask, 0, sizeof(exp->mask));
+	exp->mask.src.ip          = mask;
+	exp->mask.dst.ip          = 0xFFFFFFFF;
+	exp->mask.dst.u.udp.port  = 0xFFFF;
+	exp->mask.dst.protonum    = 0xFF;
+
+	exp->expectfn             = NULL;
+	exp->flags                = IP_CT_EXPECT_PERMANENT;
+
+	ip_conntrack_expect_related(exp);
+	ip_conntrack_expect_put(exp);
+
+	ip_ct_refresh_acct(ct, ctinfo, NULL, timeout * HZ);
+out:
+	return NF_ACCEPT;
+}
+
+static struct ip_conntrack_helper helper = {
+	.name			= "netbios-ns",
+	.tuple = {
+		.src.u.udp.port	= __constant_htons(137),
+		.dst.protonum	= IPPROTO_UDP,
+	},
+	.mask = {
+		.src.u.udp.port	= 0xFFFF,
+		.dst.protonum	= 0xFF,
+	},
+	.max_expected		= 1,
+	.me			= THIS_MODULE,
+	.help			= help,
+};
+
+static int __init init(void)
+{
+	helper.timeout = timeout;
+	return ip_conntrack_helper_register(&helper);
+}
+
+static void __exit fini(void)
+{
+	ip_conntrack_helper_unregister(&helper);
+}
+
+module_init(init);
+module_exit(fini);
