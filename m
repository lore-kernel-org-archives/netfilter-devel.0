From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH/RFC] Add arptables mangle module
Date: Wed, 25 Jun 2003 20:56:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306252056.31153.bdschuym@pandora.be>
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

The patch below adds the arptables 'mangle' module, which allows changing the source/dst
hardware/protocol address.
I've added protocol length checking, since this is useful for bridged arp packets. It's useless
for non-bridged packets though.
I'm away for two weeks starting this Saturday, so if any alterations have to be made, it'll
have to wait until then.

cheers,
Bart

--- linux-2.5.73/net/ipv4/netfilter/arp_tables.c.old	2003-06-25 20:36:24.000000000 +0200
+++ linux-2.5.73/net/ipv4/netfilter/arp_tables.c	2003-06-25 20:37:37.000000000 +0200
@@ -136,6 +136,15 @@ static inline int arp_packet_match(const
 		dprintf("ARP hardware address length mismatch.\n");
 		dprintf("ar_hln: %02x info->arhln: %02x info->arhln_mask: %02x\n",
 			arphdr->ar_hln, arpinfo->arhln, arpinfo->arhln_mask);
+		return 0;
+	}
+
+	if (FWINV((arphdr->ar_pln & arpinfo->arpln_mask) != arpinfo->arpln,
+		  ARPT_INV_ARPPLN)) {
+		dprintf("ARP protocol address length mismatch.\n");
+		dprintf("ar_pln: %02x info->arpln: %02x info->arhpn_mask: %02x\n",
+			arphdr->ar_pln, arpinfo->arpln, arpinfo->arpln_mask);
+		return 0;
 	}
 
 	src_devaddr = arpptr;
--- linux-2.5.73/include/linux/netfilter_arp/arp_tables.h.old	2003-06-25 20:36:49.000000000 +0200
+++ linux-2.5.73/include/linux/netfilter_arp/arp_tables.h	2003-06-25 20:37:37.000000000 +0200
@@ -38,6 +38,7 @@ struct arpt_arp {
 
 	/* Device hw address length, src+target device addresses */
 	u_int8_t arhln, arhln_mask;
+	u_int8_t arpln, arpln_mask;
 	struct arpt_devaddr_info src_devaddr;
 	struct arpt_devaddr_info tgt_devaddr;
 
@@ -48,10 +49,6 @@ struct arpt_arp {
 	u_int16_t arhrd, arhrd_mask;
 	u_int16_t arpro, arpro_mask;
 
-	/* The protocol address length is only accepted if it is 4
-	 * so there is no use in offering a way to do filtering on it.
-	 */
-
 	char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
 	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
 
@@ -111,7 +108,8 @@ struct arpt_counters
 #define ARPT_INV_ARPHRD		0x0080	/* Invert the sense of ARP HRD. */
 #define ARPT_INV_ARPPRO		0x0100	/* Invert the sense of ARP PRO. */
 #define ARPT_INV_ARPHLN		0x0200	/* Invert the sense of ARP HLN. */
-#define ARPT_INV_MASK		0x03FF	/* All possible flag bits mask. */
+#define ARPT_INV_ARPPLN		0x0400	/* Invert the sense of ARP HLN. */
+#define ARPT_INV_MASK		0x07FF	/* All possible flag bits mask. */
 
 /* This structure defines each of the firewall rules.  Consists of 3
    parts which are 1) general ARP header stuff 2) match specific
--- linux-2.5.73/net/ipv4/netfilter/Makefile.old	2003-06-25 20:37:06.000000000 +0200
+++ linux-2.5.73/net/ipv4/netfilter/Makefile	2003-06-25 20:37:37.000000000 +0200
@@ -79,6 +79,7 @@ obj-$(CONFIG_IP_NF_TARGET_TCPMSS) += ipt
 
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
+obj-$(CONFIG_IP_NF_ARP_MANGLE) += arpt_mangle.o

 # just filtering instance of ARP tables for now
 obj-$(CONFIG_IP_NF_ARPFILTER) += arptable_filter.o
--- linux-2.5.73/net/ipv4/netfilter/Kconfig.old	2003-06-25 20:37:24.000000000 +0200
+++ linux-2.5.73/net/ipv4/netfilter/Kconfig	2003-06-25 20:37:37.000000000 +0200
@@ -540,6 +540,13 @@ config IP_NF_ARPFILTER
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
+++ linux-2.5.73/net/ipv4/netfilter/arpt_mangle.c	2003-06-25 20:37:37.000000000 +0200
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
