From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] Add arptables mangle module
Date: Thu, 26 Jun 2003 08:16:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306260816.49221.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Dave,

This time without the added pln.
Note that the only publicly available arptables userspace tool that I
know of is the one in my CVS, so there's no major risk of breaking
anything.
The module could also be useful in 2.4, I'll make a patch if you want it
in 2.4.

cheers,
Bart

--- linux-2.5.73/net/ipv4/netfilter/Makefile.old	2003-06-25 20:37:06.000000000 +0200
+++ linux-2.5.73/net/ipv4/netfilter/Makefile	2003-06-25 20:37:37.000000000 +0200
@@ -79,6 +79,7 @@

 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
+obj-$(CONFIG_IP_NF_ARP_MANGLE) += arpt_mangle.o

 # just filtering instance of ARP tables for now
 obj-$(CONFIG_IP_NF_ARPFILTER) += arptable_filter.o
--- linux-2.5.73/net/ipv4/netfilter/Kconfig.old	2003-06-25 20:37:24.000000000 +0200
+++ linux-2.5.73/net/ipv4/netfilter/Kconfig	2003-06-25 20:37:37.000000000 +0200
@@ -540,6 +540,13 @@
 	tristate "ARP packet filtering"
 	depends on IP_NF_ARPTABLES

+config IP_NF_ARP_MANGLE
+	tristate "ARP payload mangling"
+	depends on IP_NF_ARPTABLES
+	help
+	  Allows altering the ARP packet payload: source and destination
+	  hardware and network addresses.
+
 # Backwards compatibility modules: only if you don't build in the others.
 config IP_NF_COMPAT_IPCHAINS
 	tristate "ipchains (2.2-style) support"
--- /dev/null	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.5.73/net/ipv4/netfilter/arpt_mangle.c	2003-06-26 08:00:15.000000000 +0200
@@ -0,0 +1,101 @@
+/* module that allows mangling of the arp payload */
+#include <linux/module.h>
+#include <linux/netfilter_arp/arpt_mangle.h>
+#include <net/sock.h>
+
+static unsigned int
+target(struct sk_buff **pskb, unsigned int hooknum, const struct net_device *in,
+   const struct net_device *out, const void *targinfo, void *userinfo)
+{
+	const struct arpt_mangle *mangle = targinfo;
+	struct arphdr *arp;
+	unsigned char *arpptr;
+	int pln, hln;
+
+	if (skb_shared(*pskb) || skb_cloned(*pskb)) {
+		struct sk_buff *nskb;
+
+		nskb = skb_copy(*pskb, GFP_ATOMIC);
+		if (!nskb)
+			return NF_DROP;
+		if ((*pskb)->sk)
+			skb_set_owner_w(nskb, (*pskb)->sk);
+		kfree_skb(*pskb);
+		*pskb = nskb;
+	}
+
+	arp = (*pskb)->nh.arph;
+	arpptr = (*pskb)->nh.raw + sizeof(*arp);
+	pln = arp->ar_pln;
+	hln = arp->ar_hln;
+	/* We assume that pln and hln were checked in the match */
+	if (mangle->flags & ARPT_MANGLE_SDEV) {
+		if (ARPT_DEV_ADDR_LEN_MAX < hln ||
+		   (arpptr + hln > (**pskb).tail))
+			return NF_DROP;
+		memcpy(arpptr, mangle->src_devaddr, hln);
+	}
+	arpptr += hln;
+	if (mangle->flags & ARPT_MANGLE_SIP) {
+		if (ARPT_MANGLE_ADDR_LEN_MAX < pln ||
+		   (arpptr + pln > (**pskb).tail))
+			return NF_DROP;
+		memcpy(arpptr, &mangle->u_s.src_ip, pln);
+	}
+	arpptr += pln;
+	if (mangle->flags & ARPT_MANGLE_TDEV) {
+		if (ARPT_DEV_ADDR_LEN_MAX < hln ||
+		   (arpptr + hln > (**pskb).tail))
+			return NF_DROP;
+		memcpy(arpptr, mangle->tgt_devaddr, hln);
+	}
+	arpptr += hln;
+	if (mangle->flags & ARPT_MANGLE_TIP) {
+		if (ARPT_MANGLE_ADDR_LEN_MAX < pln ||
+		   (arpptr + pln > (**pskb).tail))
+			return NF_DROP;
+		memcpy(arpptr, &mangle->u_t.tgt_ip, pln);
+	}
+	return mangle->target;
+}
+
+static int
+checkentry(const char *tablename, const struct arpt_entry *e, void *targinfo,
+   unsigned int targinfosize, unsigned int hook_mask)
+{
+	const struct arpt_mangle *mangle = targinfo;
+
+	if (mangle->flags & ~ARPT_MANGLE_MASK ||
+	    !(mangle->flags & ARPT_MANGLE_MASK))
+		return 0;
+
+	if (mangle->target != NF_DROP && mangle->target != NF_ACCEPT &&
+	   mangle->target != ARPT_CONTINUE)
+		return 0;
+	return 1;
+}
+
+static struct arpt_target arpt_mangle_reg
+= {
+        .name		= "mangle",
+        .target		= target,
+        .checkentry	= checkentry,
+        .me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	if (arpt_register_target(&arpt_mangle_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	arpt_unregister_target(&arpt_mangle_reg);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
--- /dev/null	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.5.73/include/linux/netfilter_arp/arpt_mangle.h	2003-06-25 20:37:37.000000000 +0200
@@ -0,0 +1,26 @@
+#ifndef _ARPT_MANGLE_H
+#define _ARPT_MANGLE_H
+#include <linux/netfilter_arp/arp_tables.h>
+
+#define ARPT_MANGLE_ADDR_LEN_MAX sizeof(struct in_addr)
+struct arpt_mangle
+{
+	char src_devaddr[ARPT_DEV_ADDR_LEN_MAX];
+	char tgt_devaddr[ARPT_DEV_ADDR_LEN_MAX];
+	union {
+		struct in_addr src_ip;
+	} u_s;
+	union {
+		struct in_addr tgt_ip;
+	} u_t;
+	u_int8_t flags;
+	int target;
+};
+
+#define ARPT_MANGLE_SDEV 0x01
+#define ARPT_MANGLE_TDEV 0x02
+#define ARPT_MANGLE_SIP 0x04
+#define ARPT_MANGLE_TIP 0x08
+#define ARPT_MANGLE_MASK 0x0f
+
+#endif /* _ARPT_MANGLE_H */
