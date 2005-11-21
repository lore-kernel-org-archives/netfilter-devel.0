From: Roberto Nibali <ratz@tac.ch>
Subject: [PATCH 2.4] raw table and NOTRACK support
Date: Mon, 21 Nov 2005 11:26:11 +0100
Message-ID: <4381A0C3.7020406@tac.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070405060905070404080001"
Cc: Willy Tarreau <willy@w.ods.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------070405060905070404080001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

This is a re-diffed patch to have raw table and NOTRACK support in 2.4.x
kernel. I've kept the IPv6 part in this patch although it's untested and
most probably it's never been used by anyone before.

Caveats: Currently we get an oops on SMP iif:

 o NOTRACK rule loaded, active and used (refcnt>0)
 o SMP kernel
 o connection tracking is enabled
 o a normal rule hitting the conntrack table during lookup
 o iptables -X; iptables -F, rmmod <all netfilter related modules>

Earlier attempts to address this issue with Pablo Neira have resulted in
a misplaced nf_reset(skb) patch, which I have removed again, because it
broke masquerading (IIRC). I will enable KDB and report back once I get
time some decent stack trace.

On normal reconfiguration all works perfectly, but to be safe we need to
flush the conntrack table or already established connection without a
filter rule would continue to be passed through the firewall. This will
go into production on our packet filters, however with the note to our
support team, that reconfiguration including connection tracking table
flushing is forbidden under death penalty :).

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------

--------------070405060905070404080001
Content-Type: text/plain;
 name="linux-2.4.32-raw-table-NOTRACK-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="linux-2.4.32-raw-table-NOTRACK-2.diff"

diff -Nur linux-2.4.31-orig/Documentation/Configure.help linux-2.4.31-pab2/Documentation/Configure.help
--- linux-2.4.31-orig/Documentation/Configure.help	2005-04-04 03:42:19 +0200
+++ linux-2.4.31-pab2/Documentation/Configure.help	2005-06-29 14:33:32 +0200
@@ -3016,6 +3016,34 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
 
+raw table support (required for NOTRACK/TRACE)
+CONFIG_IP_NF_RAW
+  This option adds a `raw' table to iptables. This table is the very
+  first in the netfilter framework and hooks in at the PREROUTING
+  and OUTPUT chains.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+NOTRACK target support
+CONFIG_IP_NF_TARGET_NOTRACK
+  The NOTRACK target allows a select rule to specify
+  which packets *not* to enter the conntrack/NAT
+  subsystem with all the consequences (no ICMP error tracking,
+  no protocol helpers for the selected packets).
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+raw table support (required for TRACE)
+CONFIG_IP6_NF_RAW
+  This option adds a `raw' table to ip6tables. This table is the very
+  first in the netfilter framework and hooks in at the PREROUTING
+  and OUTPUT chains.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 Packet filtering
 CONFIG_IP_NF_FILTER
   Packet filtering defines a table `filter', which has a series of
diff -Nur linux-2.4.31-orig/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.31-pab2/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.31-orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-06-29 14:32:41 +0200
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4/ip_conntrack.h	2005-06-29 14:33:32 +0200
@@ -254,6 +254,9 @@
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
 
+/* Fake conntrack entry for untracked connections */
+extern struct ip_conntrack ip_conntrack_untracked;
+
 /* Returns new sk_buff, or NULL */
 struct sk_buff *
 ip_ct_gather_frags(struct sk_buff *skb, u_int32_t user);
diff -Nur linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_conntrack.h linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_conntrack.h
--- linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_conntrack.h	2002-11-29 00:53:15 +0100
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_conntrack.h	2005-06-29 14:33:32 +0200
@@ -10,6 +10,7 @@
 
 #define IPT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
 #define IPT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
+#define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
 
 /* flags, invflags: */
 #define IPT_CONNTRACK_STATE	0x01
diff -Nur linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_state.h linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_state.h
--- linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_state.h	2000-04-14 18:37:20 +0200
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_state.h	2005-06-29 14:33:32 +0200
@@ -3,6 +3,7 @@
 
 #define IPT_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
 #define IPT_STATE_INVALID (1 << 0)
+#define IPT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
 
 struct ipt_state_info
 {
diff -Nur linux-2.4.31-orig/include/linux/netfilter_ipv4.h linux-2.4.31-pab2/include/linux/netfilter_ipv4.h
--- linux-2.4.31-orig/include/linux/netfilter_ipv4.h	2002-02-25 20:38:13 +0100
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4.h	2005-06-29 14:33:32 +0200
@@ -51,6 +51,8 @@
 
 enum nf_ip_hook_priorities {
 	NF_IP_PRI_FIRST = INT_MIN,
+	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
+	NF_IP_PRI_RAW = -300,
 	NF_IP_PRI_CONNTRACK = -200,
 	NF_IP_PRI_MANGLE = -150,
 	NF_IP_PRI_NAT_DST = -100,
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/Config.in linux-2.4.31-pab2/net/ipv4/netfilter/Config.in
--- linux-2.4.31-orig/net/ipv4/netfilter/Config.in	2005-01-19 15:10:13 +0100
+++ linux-2.4.31-pab2/net/ipv4/netfilter/Config.in	2005-06-29 14:33:32 +0200
@@ -107,6 +107,15 @@
   dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
   dep_tristate '  ULOG target support' CONFIG_IP_NF_TARGET_ULOG $CONFIG_IP_NF_IPTABLES
   dep_tristate '  TCPMSS target support' CONFIG_IP_NF_TARGET_TCPMSS $CONFIG_IP_NF_IPTABLES
+  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
+    tristate '  raw table support (required for NOTRACK/TRACE)' CONFIG_IP_NF_RAW $CONFIG_IP_NF_IPTABLES
+  fi
+  if [ "$CONFIG_IP_NF_RAW" != "n" ]; then
+    if [ "$CONFIG_IP_NF_CONNTRACK" != "n" ]; then
+      dep_tristate '    NOTRACK target support' CONFIG_IP_NF_TARGET_NOTRACK $CONFIG_IP_NF_RAW
+    fi
+  # Marker for TRACE target
+  fi
 fi
 
 tristate 'ARP tables support' CONFIG_IP_NF_ARPTABLES
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/Makefile linux-2.4.31-pab2/net/ipv4/netfilter/Makefile
--- linux-2.4.31-orig/net/ipv4/netfilter/Makefile	2005-06-29 14:32:41 +0200
+++ linux-2.4.31-pab2/net/ipv4/netfilter/Makefile	2005-06-29 14:33:32 +0200
@@ -65,6 +65,7 @@
 obj-$(CONFIG_IP_NF_FILTER) += iptable_filter.o
 obj-$(CONFIG_IP_NF_MANGLE) += iptable_mangle.o
 obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
+obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HELPER) += ipt_helper.o
@@ -90,6 +91,7 @@
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) += ipt_conntrack.o
 obj-$(CONFIG_IP_NF_MATCH_UNCLEAN) += ipt_unclean.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) += ipt_tcpmss.o
+obj-$(CONFIG_IP_NF_TARGET_NOTRACK) += ipt_NOTRACK.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-29 14:32:41 +0200
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-29 14:33:32 +0200
@@ -65,6 +65,7 @@
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
 static LIST_HEAD(unconfirmed);
+struct ip_conntrack ip_conntrack_untracked;
 
 extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
 
@@ -823,6 +824,19 @@
 	int set_reply;
 	int ret;
 
+	/* Previously seen (loopback or untracked)?  Ignore. */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+
+	/* Never happen */
+	if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
+		if (net_ratelimit()) {
+		printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=%u)\n",
+		       (*pskb)->nh.iph->protocol, hooknum);
+		}
+		return NF_DROP;
+	}
+
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |= NFC_UNKNOWN;
 
@@ -841,21 +855,6 @@
 	}
 #endif
 
-	/* Previously seen (loopback)?  Ignore.  Do this before
-           fragment check. */
-	if ((*pskb)->nfct)
-		return NF_ACCEPT;
-
-	/* Gather fragments. */
-	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
-		*pskb = ip_ct_gather_frags(*pskb,
-		                           hooknum == NF_IP_PRE_ROUTING ?
-		                           IP_DEFRAG_CONNTRACK_IN :
-		                           IP_DEFRAG_CONNTRACK_OUT);
-		if (!*pskb)
-			return NF_STOLEN;
-	}
-
 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
 
 	/* It may be an icmp error... */
@@ -1393,6 +1392,8 @@
 		schedule();
 		goto i_see_dead_people;
 	}
+	while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
+		schedule();
 
 	kmem_cache_destroy(ip_conntrack_cachep);
 	vfree(ip_conntrack_hash);
@@ -1460,6 +1461,18 @@
 
 	/* For use by ipt_REJECT */
 	ip_ct_attach = ip_conntrack_attach;
+
+	/* Set up fake conntrack:
+	 	- never to be deleted, not in any hashes */
+	atomic_set(&ip_conntrack_untracked.ct_general.use, 1);
+	/*	- and let it look as if it's a confirmed connection */
+	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
+	/*	- and prepare the ctinfo field for REJECT/NAT. */
+	ip_conntrack_untracked.infos[IP_CT_NEW].master =
+	ip_conntrack_untracked.infos[IP_CT_RELATED].master =
+	ip_conntrack_untracked.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master =
+		&ip_conntrack_untracked.ct_general;
+
 	return ret;
 
 err_free_hash:
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-29 14:32:42 +0200
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-29 14:33:32 +0200
@@ -189,6 +189,29 @@
 	return ip_conntrack_confirm(*pskb);
 }
 
+static unsigned int ip_conntrack_defrag(unsigned int hooknum,
+					struct sk_buff **pskb,
+					const struct net_device *in,
+					const struct net_device *out,
+					int (*okfn)(struct sk_buff *))
+{
+	/* Previously seen (loopback)?  Ignore.  Do this before
+	 * fragment check. */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+
+        /* Gather fragments. */
+        if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
+                *pskb = ip_ct_gather_frags(*pskb,
+                                           hooknum == NF_IP_PRE_ROUTING ?
+                                           IP_DEFRAG_CONNTRACK_IN :
+                                           IP_DEFRAG_CONNTRACK_OUT);
+                if (!*pskb)
+                        return NF_STOLEN;
+        }
+	return NF_ACCEPT;
+}
+
 static unsigned int ip_refrag(unsigned int hooknum,
 			      struct sk_buff **pskb,
 			      const struct net_device *in,
@@ -230,9 +253,15 @@
 
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
+static struct nf_hook_ops ip_conntrack_defrag_ops
+= { { NULL, NULL }, ip_conntrack_defrag, PF_INET, NF_IP_PRE_ROUTING,
+	NF_IP_PRI_CONNTRACK_DEFRAG };
 static struct nf_hook_ops ip_conntrack_in_ops
 = { { NULL, NULL }, ip_conntrack_in, PF_INET, NF_IP_PRE_ROUTING,
 	NF_IP_PRI_CONNTRACK };
+static struct nf_hook_ops ip_conntrack_defrag_local_out_ops
+= { { NULL, NULL }, ip_conntrack_defrag, PF_INET, NF_IP_LOCAL_OUT,
+	NF_IP_PRI_CONNTRACK_DEFRAG };
 static struct nf_hook_ops ip_conntrack_local_out_ops
 = { { NULL, NULL }, ip_conntrack_local, PF_INET, NF_IP_LOCAL_OUT,
 	NF_IP_PRI_CONNTRACK };
@@ -373,10 +402,21 @@
 	if (!proc) goto cleanup_init;
 	proc->owner = THIS_MODULE;
 
+	ret = nf_register_hook(&ip_conntrack_defrag_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register pre-routing defrag hook.\n");
+		goto cleanup_proc;
+	}
+	ret = nf_register_hook(&ip_conntrack_defrag_local_out_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register local_out defrag hook.\n");
+		goto cleanup_defragops;
+	}
+
 	ret = nf_register_hook(&ip_conntrack_in_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register pre-routing hook.\n");
-		goto cleanup_proc;
+		goto cleanup_defraglocalops;
 	}
 	ret = nf_register_hook(&ip_conntrack_local_out_ops);
 	if (ret < 0) {
@@ -414,6 +454,10 @@
 	nf_unregister_hook(&ip_conntrack_local_out_ops);
  cleanup_inops:
 	nf_unregister_hook(&ip_conntrack_in_ops);
+ cleanup_defraglocalops:
+	nf_unregister_hook(&ip_conntrack_defrag_local_out_ops);
+ cleanup_defragops:
+	nf_unregister_hook(&ip_conntrack_defrag_ops);
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:
@@ -503,5 +547,6 @@
 EXPORT_SYMBOL(ip_conntrack_expect_list);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
+EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/ip_nat_core.c linux-2.4.31-pab2/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ip_nat_core.c	2005-04-04 03:42:20 +0200
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ip_nat_core.c	2005-06-29 14:33:32 +0200
@@ -1024,6 +1024,10 @@
 	IP_NF_ASSERT(ip_conntrack_destroyed == NULL);
 	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
 
+	/* Initialize fake conntrack so that NAT will skip it */
+	ip_conntrack_untracked.nat.info.initialized |=
+		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
+
 	return 0;
 }
 
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/ipt_NOTRACK.c linux-2.4.31-pab2/net/ipv4/netfilter/ipt_NOTRACK.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ipt_NOTRACK.c	1970-01-01 01:00:00 +0100
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ipt_NOTRACK.c	2005-06-29 14:33:32 +0200
@@ -0,0 +1,75 @@
+/* This is a module which is used for setting up fake conntracks
+ * on packets so that they are not seen by the conntrack/NAT code.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+
+static unsigned int
+target(struct sk_buff **pskb,
+       unsigned int hooknum,
+       const struct net_device *in,
+       const struct net_device *out,
+       const void *targinfo,
+       void *userinfo)
+{
+	/* Previously seen (loopback)? Ignore. */
+	if ((*pskb)->nfct != NULL)
+		return IPT_CONTINUE;
+
+	/* Attach fake conntrack entry. 
+	   If there is a real ct entry correspondig to this packet, 
+	   it'll hang aroun till timing out. We don't deal with it
+	   for performance reasons. JK */
+	(*pskb)->nfct = &ip_conntrack_untracked.infos[IP_CT_NEW];
+	nf_conntrack_get((*pskb)->nfct);
+
+	return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+	   const struct ipt_entry *e,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+	if (targinfosize != 0) {
+		printk(KERN_WARNING "NOTRACK: targinfosize %u != 0\n",
+		       targinfosize);
+		return 0;
+	}
+
+	if (strcmp(tablename, "raw") != 0) {
+		printk(KERN_WARNING "NOTRACK: can only be called from \"raw\" table, not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_target ipt_notrack_reg = { 
+	.name = "NOTRACK", 
+	.target = target, 
+	.checkentry = checkentry, 
+	.me = THIS_MODULE 
+};
+
+static int __init init(void)
+{
+	if (ipt_register_target(&ipt_notrack_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_notrack_reg);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/ipt_conntrack.c linux-2.4.31-pab2/net/ipv4/netfilter/ipt_conntrack.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ipt_conntrack.c	2004-02-18 14:36:32 +0100
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ipt_conntrack.c	2005-06-29 14:33:32 +0200
@@ -27,7 +27,9 @@
 
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
-	if (ct)
+	if (skb->nfct == &ip_conntrack_untracked.infos[IP_CT_NEW])
+		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
+	else if (ct)
 		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
 	else
 		statebit = IPT_CONNTRACK_STATE_INVALID;
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/ipt_state.c linux-2.4.31-pab2/net/ipv4/netfilter/ipt_state.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ipt_state.c	2004-02-18 14:36:32 +0100
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ipt_state.c	2005-06-29 14:33:32 +0200
@@ -21,7 +21,9 @@
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	if (!ip_conntrack_get((struct sk_buff *)skb, &ctinfo))
+	if (skb->nfct == &ip_conntrack_untracked.infos[IP_CT_NEW])
+		statebit = IPT_STATE_UNTRACKED;
+	else if (!ip_conntrack_get((struct sk_buff *)skb, &ctinfo))
 		statebit = IPT_STATE_INVALID;
 	else
 		statebit = IPT_STATE_BIT(ctinfo);
diff -Nur linux-2.4.31-orig/net/ipv4/netfilter/iptable_raw.c linux-2.4.31-pab2/net/ipv4/netfilter/iptable_raw.c
--- linux-2.4.31-orig/net/ipv4/netfilter/iptable_raw.c	1970-01-01 01:00:00 +0100
+++ linux-2.4.31-pab2/net/ipv4/netfilter/iptable_raw.c	2005-06-29 14:33:32 +0200
@@ -0,0 +1,149 @@
+/* 
+ * 'raw' table, which is the very first hooked in at PRE_ROUTING and LOCAL_OUT .
+ *
+ * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ */
+#include <linux/module.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#define RAW_VALID_HOOKS ((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT))
+
+/* Standard entry. */
+struct ipt_standard
+{
+	struct ipt_entry entry;
+	struct ipt_standard_target target;
+};
+
+struct ipt_error_target
+{
+	struct ipt_entry_target target;
+	char errorname[IPT_FUNCTION_MAXNAMELEN];
+};
+
+struct ipt_error
+{
+	struct ipt_entry entry;
+	struct ipt_error_target target;
+};
+
+static struct
+{
+	struct ipt_replace repl;
+	struct ipt_standard entries[2];
+	struct ipt_error term;
+} initial_table __initdata
+= { { "raw", RAW_VALID_HOOKS, 3,
+      sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
+      { [NF_IP_PRE_ROUTING] 0,
+	[NF_IP_LOCAL_OUT] sizeof(struct ipt_standard) },
+      { [NF_IP_PRE_ROUTING] 0,
+	[NF_IP_LOCAL_OUT] sizeof(struct ipt_standard) },
+      0, NULL, { } },
+    {
+	    /* PRE_ROUTING */
+	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+		0,
+		sizeof(struct ipt_entry),
+		sizeof(struct ipt_standard),
+		0, { 0, 0 }, { } },
+	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
+		-NF_ACCEPT - 1 } },
+	    /* LOCAL_OUT */
+	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+		0,
+		sizeof(struct ipt_entry),
+		sizeof(struct ipt_standard),
+		0, { 0, 0 }, { } },
+	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
+		-NF_ACCEPT - 1 } }
+    },
+    /* ERROR */
+    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+	0,
+	sizeof(struct ipt_entry),
+	sizeof(struct ipt_error),
+	0, { 0, 0 }, { } },
+      { { { { IPT_ALIGN(sizeof(struct ipt_error_target)), IPT_ERROR_TARGET } },
+	  { } },
+	"ERROR"
+      }
+    }
+};
+
+static struct ipt_table packet_raw = { 
+	.name = "raw", 
+	.table = &initial_table.repl,
+	.valid_hooks =  RAW_VALID_HOOKS, 
+	.lock = RW_LOCK_UNLOCKED, 
+	.me = THIS_MODULE
+};
+
+/* The work comes in here from netfilter.c. */
+static unsigned int
+ipt_hook(unsigned int hook,
+	 struct sk_buff **pskb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 int (*okfn)(struct sk_buff *))
+{
+	return ipt_do_table(pskb, hook, in, out, &packet_raw, NULL);
+}
+
+/* 'raw' is the very first table. */
+static struct nf_hook_ops ipt_ops[] = {
+	{
+	  .hook = ipt_hook, 
+	  .pf = PF_INET, 
+	  .hooknum = NF_IP_PRE_ROUTING, 
+	  .priority = NF_IP_PRI_RAW
+	},
+	{
+	  .hook = ipt_hook, 
+	  .pf = PF_INET, 
+	  .hooknum = NF_IP_LOCAL_OUT, 
+	  .priority = NF_IP_PRI_RAW
+	},
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	/* Register table */
+	ret = ipt_register_table(&packet_raw);
+	if (ret < 0)
+		return ret;
+
+	/* Register hooks */
+	ret = nf_register_hook(&ipt_ops[0]);
+	if (ret < 0)
+		goto cleanup_table;
+
+	ret = nf_register_hook(&ipt_ops[1]);
+	if (ret < 0)
+		goto cleanup_hook0;
+
+	return ret;
+
+ cleanup_hook0:
+	nf_unregister_hook(&ipt_ops[0]);
+ cleanup_table:
+	ipt_unregister_table(&packet_raw);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < sizeof(ipt_ops)/sizeof(struct nf_hook_ops); i++)
+		nf_unregister_hook(&ipt_ops[i]);
+
+	ipt_unregister_table(&packet_raw);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
diff -Nur linux-2.4.31-orig/net/ipv6/netfilter/Config.in linux-2.4.31-pab2/net/ipv6/netfilter/Config.in
--- linux-2.4.31-orig/net/ipv6/netfilter/Config.in	2003-06-13 16:51:39 +0200
+++ linux-2.4.31-pab2/net/ipv6/netfilter/Config.in	2005-06-29 14:33:32 +0200
@@ -75,4 +75,9 @@
   #dep_tristate '  LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_NF_IPTABLES
 fi
 
+  if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
+    tristate '  raw table support (required for TRACE)' CONFIG_IP6_NF_RAW $CONFIG_IP6_NF_IPTABLES
+  fi
+  # Marker for TRACE target
+
 endmenu
diff -Nur linux-2.4.31-orig/net/ipv6/netfilter/Makefile linux-2.4.31-pab2/net/ipv6/netfilter/Makefile
--- linux-2.4.31-orig/net/ipv6/netfilter/Makefile	2003-06-13 16:51:39 +0200
+++ linux-2.4.31-pab2/net/ipv6/netfilter/Makefile	2005-06-29 14:33:32 +0200
@@ -30,6 +30,7 @@
 obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
 
 include $(TOPDIR)/Rules.make
diff -Nur linux-2.4.31-orig/net/ipv6/netfilter/ip6table_raw.c linux-2.4.31-pab2/net/ipv6/netfilter/ip6table_raw.c
--- linux-2.4.31-orig/net/ipv6/netfilter/ip6table_raw.c	1970-01-01 01:00:00 +0100
+++ linux-2.4.31-pab2/net/ipv6/netfilter/ip6table_raw.c	2005-06-29 14:33:32 +0200
@@ -0,0 +1,154 @@
+/*
+ * IPv6 raw table, a port of the IPv4 raw table to IPv6
+ *
+ * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ */
+#include <linux/module.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+#define RAW_VALID_HOOKS ((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_OUT))
+
+#if 0
+#define DEBUGP(x, args...)	printk(KERN_DEBUG x, ## args)
+#else
+#define DEBUGP(x, args...)
+#endif
+
+/* Standard entry. */
+struct ip6t_standard
+{
+	struct ip6t_entry entry;
+	struct ip6t_standard_target target;
+};
+
+struct ip6t_error_target
+{
+	struct ip6t_entry_target target;
+	char errorname[IP6T_FUNCTION_MAXNAMELEN];
+};
+
+struct ip6t_error
+{
+	struct ip6t_entry entry;
+	struct ip6t_error_target target;
+};
+
+static struct
+{
+	struct ip6t_replace repl;
+	struct ip6t_standard entries[2];
+	struct ip6t_error term;
+} initial_table __initdata 
+= { { "raw", RAW_VALID_HOOKS, 3,
+      sizeof(struct ip6t_standard) * 2 + sizeof(struct ip6t_error),
+      { [NF_IP6_PRE_ROUTING] 	0,
+	[NF_IP6_LOCAL_OUT]	sizeof(struct ip6t_standard) },
+      { [NF_IP6_PRE_ROUTING] 	0,
+	[NF_IP6_LOCAL_OUT]	sizeof(struct ip6t_standard) },
+      0, NULL, { } },
+    {
+	    /* PRE_ROUTING */
+            { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+		0,
+		sizeof(struct ip6t_entry),
+		sizeof(struct ip6t_standard),
+		0, { 0, 0 }, { } },
+	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
+		-NF_ACCEPT - 1 } },
+	    /* LOCAL_OUT */
+            { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+		0,
+		sizeof(struct ip6t_entry),
+		sizeof(struct ip6t_standard),
+		0, { 0, 0 }, { } },
+	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
+		-NF_ACCEPT - 1 } },
+    },
+    /* ERROR */
+    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+	0,
+	sizeof(struct ip6t_entry),
+	sizeof(struct ip6t_error),
+	0, { 0, 0 }, { } },
+      { { { { IP6T_ALIGN(sizeof(struct ip6t_error_target)), IP6T_ERROR_TARGET } },
+	  { } },
+	"ERROR"
+      }
+    }
+};
+
+static struct ip6t_table packet_raw = { 
+	.name = "raw", 
+	.table = &initial_table.repl,
+	.valid_hooks = RAW_VALID_HOOKS, 
+	.lock = RW_LOCK_UNLOCKED, 
+	.me = THIS_MODULE
+};
+
+/* The work comes in here from netfilter.c. */
+static unsigned int
+ip6t_hook(unsigned int hook,
+	 struct sk_buff **pskb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 int (*okfn)(struct sk_buff *))
+{
+	return ip6t_do_table(pskb, hook, in, out, &packet_raw, NULL);
+}
+
+static struct nf_hook_ops ip6t_ops[] = { 
+	{
+	  .hook = ip6t_hook, 
+	  .pf = PF_INET6,
+	  .hooknum = NF_IP6_PRE_ROUTING,
+	  .priority = NF_IP6_PRI_FIRST
+	},
+	{
+	  .hook = ip6t_hook, 
+	  .pf = PF_INET6, 
+	  .hooknum = NF_IP6_LOCAL_OUT,
+	  .priority = NF_IP6_PRI_FIRST
+	},
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	/* Register table */
+	ret = ip6t_register_table(&packet_raw);
+	if (ret < 0)
+		return ret;
+
+	/* Register hooks */
+	ret = nf_register_hook(&ip6t_ops[0]);
+	if (ret < 0)
+		goto cleanup_table;
+
+	ret = nf_register_hook(&ip6t_ops[1]);
+	if (ret < 0)
+		goto cleanup_hook0;
+
+	return ret;
+
+ cleanup_hook0:
+	nf_unregister_hook(&ip6t_ops[0]);
+ cleanup_table:
+	ip6t_unregister_table(&packet_raw);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < sizeof(ip6t_ops)/sizeof(struct nf_hook_ops); i++)
+		nf_unregister_hook(&ip6t_ops[i]);
+
+	ip6t_unregister_table(&packet_raw);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");

--------------070405060905070404080001--
