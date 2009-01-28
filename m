From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: arptables: add mcmangle target
Date: Wed, 28 Jan 2009 15:58:04 +0100
Message-ID: <20090128145801.7501.44459.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53799 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751282AbZA1O6N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:58:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the mcmangle target for arptables which allows
altering the source hardware address in ARP with a multicast
hardware address. This target can be used to make a switch flood
packets to the ports that use the same MAC multicast address. This
is useful to deploy load-sharing clusters in environments in which
the switch does not provide a way to flood packets to several
ports.

Since all the nodes receives the same packets, each decides if
it handles the packet based on hashing approach (See the `cluster'
iptables match that comes with this patchset).

Theoretically, the use of the reserved VRRP hardware address should
be fine for this, however, switches generally treat this hardware
address space as normal unicast hardware address. Thus, in practise,
it is not possible to have two nodes with the same VRRP hardware
address.

Please, note that this target violates RFC 1812 (section 3.3.2) since
an ethernet device must not use a multicast link address.

An example of the use of this target:

arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6 \
	--mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
arptables -I INPUT -i eth0 --h-length 6 --destination-mac \
	01:00:5e:00:01:01 -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27

Where 00:zz:yy:xx:5a:27 is the original hardware address of this
node. Note that the mcmangle target registers an entry in the multicast
list that is required to get this working:

$ cat /proc/net/dev_mcast | grep eth0 | head -1
2    eth0            1     0     01005e000101

You need the PKTTYPE iptables target (included in this patchset) to
set skb->type to PACKET_HOST. Otherwise, you would be only able to
ICMP ping nodes in the network ;).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter_arp/arpt_mcmangle.h |   14 ++++
 net/ipv4/netfilter/Kconfig                  |   12 +++
 net/ipv4/netfilter/Makefile                 |    1 
 net/ipv4/netfilter/arpt_mcmangle.c          |   98 +++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter_arp/arpt_mcmangle.h
 create mode 100644 net/ipv4/netfilter/arpt_mcmangle.c

diff --git a/include/linux/netfilter_arp/arpt_mcmangle.h b/include/linux/netfilter_arp/arpt_mcmangle.h
new file mode 100644
index 0000000..d14a1ab
--- /dev/null
+++ b/include/linux/netfilter_arp/arpt_mcmangle.h
@@ -0,0 +1,14 @@
+#ifndef _ARPT_MCMANGLE_H
+#define _ARPT_MCMANGLE_H
+#include <linux/netfilter_arp/arp_tables.h>
+
+struct net_device;
+
+struct arpt_mcmangle
+{
+	char ifname[IFNAMSIZ];
+	char mc_devaddr[ETH_ALEN];
+	struct net_device  __attribute__((aligned(8))) *dev;
+};
+
+#endif /* _ARPT_MANGLE_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 3816e1d..50f38b2 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -392,6 +392,18 @@ config IP_NF_ARP_MANGLE
 	  Allows altering the ARP packet payload: source and destination
 	  hardware and network addresses.
 
+config IP_NF_ARP_MCMANGLE
+	tristate "ARP multicast address mangling"
+	help
+	  Allows altering the source unicast hardware address in ARP messages
+	  with a multicast hardware address. This target is useful to make a
+	  switch flood to all ports whose ethernet device have a multicast
+	  hardware address. Please, see that this target violates RFC 1812
+	  (section 3.3.2) since an ethernet device must not use a multicast
+	  link address.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 endif # IP_NF_ARPTABLES
 
 endmenu
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 5f9b650..5c4cc3e 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
 obj-$(CONFIG_IP_NF_ARP_MANGLE) += arpt_mangle.o
+obj-$(CONFIG_IP_NF_ARP_MCMANGLE) += arpt_mcmangle.o
 
 # just filtering instance of ARP tables for now
 obj-$(CONFIG_IP_NF_ARPFILTER) += arptable_filter.o
diff --git a/net/ipv4/netfilter/arpt_mcmangle.c b/net/ipv4/netfilter/arpt_mcmangle.c
new file mode 100644
index 0000000..c82367a
--- /dev/null
+++ b/net/ipv4/netfilter/arpt_mcmangle.c
@@ -0,0 +1,98 @@
+/*
+ * (C) 2008-2009 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_arp.h>
+#include <linux/netfilter_arp/arpt_mcmangle.h>
+
+static unsigned int
+arpt_mcmangle_tg(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct arpt_mcmangle *mangle = par->targinfo;
+	const struct arphdr *arp;
+	unsigned char *arpptr;
+	int hln;
+
+	if (!skb_make_writable(skb, skb->len))
+		return NF_DROP;
+
+	arp = arp_hdr(skb);
+	arpptr = skb_network_header(skb) + sizeof(*arp);
+	hln = arp->ar_hln;
+
+	/* We assume that pln and hln were checked in the match */
+	if (ARPT_DEV_ADDR_LEN_MAX < hln ||
+	    (arpptr + hln > skb_tail_pointer(skb))) {
+	    	return NF_DROP;
+	}
+	memcpy(arpptr, mangle->mc_devaddr, hln);
+
+	return NF_ACCEPT;
+}
+
+static bool
+arpt_mcmangle_checkentry(const struct xt_tgchk_param *par)
+{
+	struct arpt_mcmangle *mangle = par->targinfo;
+	struct net_device *dev;
+
+	if (!(mangle->mc_devaddr[0] & 0x01)) {
+		printk(KERN_WARNING "arpt_mcmangle: wrong multicast address\n");
+		return false;
+	}
+	dev = dev_get_by_name(&init_net, mangle->ifname);
+	if (dev == NULL) {
+		printk(KERN_WARNING "arpt_mcmangle: wrong `%s' interface\n",
+			mangle->ifname);
+		return false;
+	}
+	mangle->dev = dev;
+	if (dev_mc_add(dev, mangle->mc_devaddr, ETH_ALEN, 0) < 0) {
+		printk(KERN_ERR "arpt_mcmangle: cannot set multicast "
+				"address\n");
+		return false;
+	}
+	return true;
+}
+
+static void
+arpt_mcmangle_destroy(const struct xt_tgdtor_param *par)
+{
+	struct arpt_mcmangle *mangle = par->targinfo;
+	dev_mc_delete(mangle->dev, mangle->mc_devaddr, ETH_ALEN, 0);
+	dev_put(mangle->dev);
+}
+
+static struct xt_target arpt_mcmangle_reg __read_mostly = {
+	.name		= "mcmangle",
+	.family		= NFPROTO_ARP,
+	.target		= arpt_mcmangle_tg,
+	.checkentry	= arpt_mcmangle_checkentry,
+	.destroy	= arpt_mcmangle_destroy,
+	.targetsize	= sizeof(struct arpt_mcmangle),
+	.hooks		= (1 << NF_ARP_OUT),
+	.me		= THIS_MODULE,
+};
+
+static int __init arpt_mcmangle_init(void)
+{
+	return xt_register_target(&arpt_mcmangle_reg);
+}
+
+static void __exit arpt_mcmangle_fini(void)
+{
+	xt_unregister_target(&arpt_mcmangle_reg);
+}
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("arptables: arp multicast mangle target");
+module_init(arpt_mcmangle_init);
+module_exit(arpt_mcmangle_fini);

