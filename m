From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] 'raw' table
Date: Mon, 29 Mar 2004 13:05:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329110515.GH1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Y142/9l9nQlBiaj"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--4Y142/9l9nQlBiaj
Content-Type: multipart/mixed; boundary="Aaj1jBvBEV7KRjLi"
Content-Disposition: inline


--Aaj1jBvBEV7KRjLi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is a patch adding a 'raw' table.  This table is iterated in
NF_IP[6]_PRE_ROUTING before anything else happens (esp. before conntrack).

The idea is to call the 'NOTRACK' target from within the 'raw' table to
prevent certain packets from being connection tracked.

This 'raw' table is also neccessarry for the upcoming 'TRACE' target
that would allow you to mark those packets that you want to have traced
while iterating through all netfilter/iptables modules.

Author: Jozsef Kadlecsik

Please submit,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Aaj1jBvBEV7KRjLi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nf_raw.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.6.5-rc2-nflo=
g-trace/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.5-rc2-nflog/include/linux/netfilter_ipv4/ip_conntrack.h	2004-=
03-11 03:55:44.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/include/linux/netfilter_ipv4/ip_conntrack.h=
	2004-03-29 13:01:50.000000000 +0200
@@ -251,6 +251,9 @@
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
=20
+/* Fake conntrack entry for untracked connections */
+extern struct ip_conntrack ip_conntrack_untracked;
+
 /* Returns new sk_buff, or NULL */
 struct sk_buff *
 ip_ct_gather_frags(struct sk_buff *skb);
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/include/linux/netfilter_ipv4/ipt_conntrack.h linux-2.6.5-rc2-nfl=
og-trace/include/linux/netfilter_ipv4/ipt_conntrack.h
--- linux-2.6.5-rc2-nflog/include/linux/netfilter_ipv4/ipt_conntrack.h	2004=
-03-11 03:55:37.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/include/linux/netfilter_ipv4/ipt_conntrack.=
h	2004-03-29 13:01:50.000000000 +0200
@@ -10,6 +10,7 @@
=20
 #define IPT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
 #define IPT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
+#define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
=20
 /* flags, invflags: */
 #define IPT_CONNTRACK_STATE	0x01
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/include/linux/netfilter_ipv4/ipt_state.h linux-2.6.5-rc2-nflog-t=
race/include/linux/netfilter_ipv4/ipt_state.h
--- linux-2.6.5-rc2-nflog/include/linux/netfilter_ipv4/ipt_state.h	2004-03-=
11 03:55:43.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/include/linux/netfilter_ipv4/ipt_state.h	20=
04-03-29 13:01:50.000000000 +0200
@@ -4,6 +4,8 @@
 #define IPT_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
 #define IPT_STATE_INVALID (1 << 0)
=20
+#define IPT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+
 struct ipt_state_info
 {
 	unsigned int statemask;
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/include/linux/netfilter_ipv4.h linux-2.6.5-rc2-nflog-trace/inclu=
de/linux/netfilter_ipv4.h
--- linux-2.6.5-rc2-nflog/include/linux/netfilter_ipv4.h	2004-03-11 03:55:4=
3.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/include/linux/netfilter_ipv4.h	2004-03-29 1=
3:01:50.000000000 +0200
@@ -51,6 +51,8 @@
=20
 enum nf_ip_hook_priorities {
 	NF_IP_PRI_FIRST =3D INT_MIN,
+	NF_IP_PRI_CONNTRACK_DEFRAG =3D -400,
+	NF_IP_PRI_RAW =3D -300,
 	NF_IP_PRI_SELINUX_FIRST =3D -225,
 	NF_IP_PRI_CONNTRACK =3D -200,
 	NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD =3D -175,
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/Kconfig linux-2.6.5-rc2-nflog-trace/net/ipv4/=
netfilter/Kconfig
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/Kconfig	2004-03-11 03:55:43.00=
0000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/Kconfig	2004-03-29 13:01=
:49.000000000 +0200
@@ -579,5 +579,29 @@
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config IP_NF_TARGET_NOTRACK
+	tristate  'NOTRACK target support'
+	depends on IP_NF_RAW
+	help
+	  The NOTRACK target allows a select rule to specify
+	  which packets *not* to enter the conntrack/NAT
+	  subsystem with all the consequences (no ICMP error tracking,
+	  no protocol helpers for the selected packets).
+=09
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+config IP_NF_RAW
+	tristate  'raw table support (required for NOTRACK/TRACE)'
+	depends on IP_NF_IPTABLES
+	help
+	  This option adds a `raw' table to iptables. This table is the very
+	  first in the netfilter framework and hooks in at the PREROUTING
+	  and OUTPUT chains.
+=09
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  help
+
 endmenu
=20
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/Makefile linux-2.6.5-rc2-nflog-trace/net/ipv4=
/netfilter/Makefile
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/Makefile	2004-03-11 03:55:23.0=
00000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/Makefile	2004-03-29 13:0=
1:49.000000000 +0200
@@ -38,6 +38,7 @@
 obj-$(CONFIG_IP_NF_FILTER) +=3D iptable_filter.o
 obj-$(CONFIG_IP_NF_MANGLE) +=3D iptable_mangle.o
 obj-$(CONFIG_IP_NF_NAT) +=3D iptable_nat.o
+obj-$(CONFIG_IP_NF_RAW) +=3D iptable_raw.o
=20
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HELPER) +=3D ipt_helper.o
@@ -81,6 +82,7 @@
 obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) +=3D ipt_ULOG.o
 obj-$(CONFIG_IP_NF_TARGET_TCPMSS) +=3D ipt_TCPMSS.o
+obj-$(CONFIG_IP_NF_TARGET_NOTRACK) +=3D ipt_NOTRACK.o
=20
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) +=3D arp_tables.o
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.5-rc2-nflog-tra=
ce/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-11=
 03:55:20.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/ip_conntrack_core.c	2004=
-03-29 13:01:50.000000000 +0200
@@ -67,6 +67,7 @@
 static atomic_t ip_conntrack_count =3D ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
+struct ip_conntrack ip_conntrack_untracked;
=20
 extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
=20
@@ -794,6 +795,15 @@
 	int set_reply;
 	int ret;
=20
+	/* Never happen */
+	if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
+		if (net_ratelimit()) {
+		printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=3D%u)\n",
+		       (*pskb)->nh.iph->protocol, hooknum);
+		}
+		return NF_DROP;
+	}
+
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |=3D NFC_UNKNOWN;
=20
@@ -812,18 +822,10 @@
 	}
 #endif
=20
-	/* Previously seen (loopback)?  Ignore.  Do this before
-           fragment check. */
+	/* Previously seen (loopback or untracked)?  Ignore. */
 	if ((*pskb)->nfct)
 		return NF_ACCEPT;
=20
-	/* Gather fragments. */
-	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
-		*pskb =3D ip_ct_gather_frags(*pskb);
-		if (!*pskb)
-			return NF_STOLEN;
-	}
-
 	proto =3D ip_ct_find_proto((*pskb)->nh.iph->protocol);
=20
 	/* It may be an icmp error... */
@@ -1422,6 +1424,18 @@
=20
 	/* For use by ipt_REJECT */
 	ip_ct_attach =3D ip_conntrack_attach;
+
+	/* Set up fake conntrack:
+	    - to never be deleted, not in any hashes */
+	atomic_set(&ip_conntrack_untracked.ct_general.use, 1);
+	/*  - and look it like as a confirmed connection */
+	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
+	/*  - and prepare the ctinfo field for REJECT & NAT. */
+	ip_conntrack_untracked.infos[IP_CT_NEW].master =3D
+	ip_conntrack_untracked.infos[IP_CT_RELATED].master =3D
+	ip_conntrack_untracked.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master =3D=
=20
+			&ip_conntrack_untracked.ct_general;
+
 	return ret;
=20
 err_free_hash:
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6.5-rc2-nfl=
og-trace/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ip_conntrack_standalone.c	2004=
-03-11 03:55:26.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/ip_conntrack_standalone.=
c	2004-03-29 13:01:50.000000000 +0200
@@ -194,6 +194,26 @@
 	return ip_conntrack_confirm(*pskb);
 }
=20
+static unsigned int ip_conntrack_defrag(unsigned int hooknum,
+				        struct sk_buff **pskb,
+				        const struct net_device *in,
+				        const struct net_device *out,
+				        int (*okfn)(struct sk_buff *))
+{
+	/* Previously seen (loopback)?  Ignore.  Do this before
+           fragment check. */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+
+	/* Gather fragments. */
+	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
+		*pskb =3D ip_ct_gather_frags(*pskb);
+		if (!*pskb)
+			return NF_STOLEN;
+	}
+	return NF_ACCEPT;
+}
+
 static unsigned int ip_refrag(unsigned int hooknum,
 			      struct sk_buff **pskb,
 			      const struct net_device *in,
@@ -236,6 +256,14 @@
=20
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
+static struct nf_hook_ops ip_conntrack_defrag_ops =3D {
+	.hook		=3D ip_conntrack_defrag,
+	.owner		=3D THIS_MODULE,
+	.pf		=3D PF_INET,
+	.hooknum	=3D NF_IP_PRE_ROUTING,
+	.priority	=3D NF_IP_PRI_CONNTRACK_DEFRAG,
+};
+
 static struct nf_hook_ops ip_conntrack_in_ops =3D {
 	.hook		=3D ip_conntrack_in,
 	.owner		=3D THIS_MODULE,
@@ -244,6 +272,14 @@
 	.priority	=3D NF_IP_PRI_CONNTRACK,
 };
=20
+static struct nf_hook_ops ip_conntrack_defrag_local_out_ops =3D {
+	.hook		=3D ip_conntrack_defrag,
+	.owner		=3D THIS_MODULE,
+	.pf		=3D PF_INET,
+	.hooknum	=3D NF_IP_LOCAL_OUT,
+	.priority	=3D NF_IP_PRI_CONNTRACK_DEFRAG,
+};
+
 static struct nf_hook_ops ip_conntrack_local_out_ops =3D {
 	.hook		=3D ip_conntrack_local,
 	.owner		=3D THIS_MODULE,
@@ -470,10 +506,20 @@
 	if (!proc) goto cleanup_init;
 	proc->owner =3D THIS_MODULE;
=20
+	ret =3D nf_register_hook(&ip_conntrack_defrag_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register pre-routing defrag hook.\n");
+		goto cleanup_proc;
+	}
+	ret =3D nf_register_hook(&ip_conntrack_defrag_local_out_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register local_out defrag hook.\n");
+		goto cleanup_defragops;
+	}
 	ret =3D nf_register_hook(&ip_conntrack_in_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register pre-routing hook.\n");
-		goto cleanup_proc;
+		goto cleanup_defraglocalops;
 	}
 	ret =3D nf_register_hook(&ip_conntrack_local_out_ops);
 	if (ret < 0) {
@@ -511,6 +557,10 @@
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
@@ -602,5 +652,6 @@
 EXPORT_SYMBOL(ip_conntrack_expect_list);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
+EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/ip_nat_core.c linux-2.6.5-rc2-nflog-trace/net=
/ipv4/netfilter/ip_nat_core.c
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ip_nat_core.c	2004-03-11 03:55=
:22.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/ip_nat_core.c	2004-03-29=
 13:01:50.000000000 +0200
@@ -1016,6 +1016,10 @@
 	/* FIXME: Man, this is a hack.  <SIGH> */
 	IP_NF_ASSERT(ip_conntrack_destroyed =3D=3D NULL);
 	ip_conntrack_destroyed =3D &ip_nat_cleanup_conntrack;
+=09
+	/* Initialize fake conntrack so that NAT will skip it */
+	ip_conntrack_untracked.nat.info.initialized |=3D=20
+		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
=20
 	return 0;
 }
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/ipt_NOTRACK.c linux-2.6.5-rc2-nflog-trace/net=
/ipv4/netfilter/ipt_NOTRACK.c
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ipt_NOTRACK.c	1970-01-01 01:00=
:00.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/ipt_NOTRACK.c	2004-03-29=
 13:01:49.000000000 +0200
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
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const void *targinfo,
+       void *userinfo)
+{
+	/* Previously seen (loopback)? Ignore. */
+	if ((*pskb)->nfct !=3D NULL)
+		return IPT_CONTINUE;
+
+	/* Attach fake conntrack entry.=20
+	   If there is a real ct entry correspondig to this packet,=20
+	   it'll hang aroun till timing out. We don't deal with it
+	   for performance reasons. JK */
+	(*pskb)->nfct =3D &ip_conntrack_untracked.infos[IP_CT_NEW];
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
+	if (targinfosize !=3D 0) {
+		printk(KERN_WARNING "NOTRACK: targinfosize %u !=3D 0\n",
+		       targinfosize);
+		return 0;
+	}
+
+	if (strcmp(tablename, "raw") !=3D 0) {
+		printk(KERN_WARNING "NOTRACK: can only be called from \"raw\" table, not=
 \"%s\"\n", tablename);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_target ipt_notrack_reg =3D {=20
+	.name =3D "NOTRACK",=20
+	.target =3D target,=20
+	.checkentry =3D checkentry,
+	.me =3D THIS_MODULE=20
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
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/ipt_conntrack.c linux-2.6.5-rc2-nflog-trace/n=
et/ipv4/netfilter/ipt_conntrack.c
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ipt_conntrack.c	2004-03-11 03:=
55:44.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/ipt_conntrack.c	2004-03-=
29 13:01:50.000000000 +0200
@@ -35,11 +35,13 @@
=20
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
=20
-	if (ct)
-		statebit =3D IPT_CONNTRACK_STATE_BIT(ctinfo);
-	else
-		statebit =3D IPT_CONNTRACK_STATE_INVALID;
-
+	if (skb->nfct =3D=3D &ip_conntrack_untracked.infos[IP_CT_NEW])
+		statebit =3D IPT_CONNTRACK_STATE_UNTRACKED;
+	else if (ct)
+ 		statebit =3D IPT_CONNTRACK_STATE_BIT(ctinfo);
+ 	else
+ 		statebit =3D IPT_CONNTRACK_STATE_INVALID;
+=20
 	if(sinfo->flags & IPT_CONNTRACK_STATE) {
 		if (ct) {
 			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip !=3D
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/ipt_state.c linux-2.6.5-rc2-nflog-trace/net/i=
pv4/netfilter/ipt_state.c
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/ipt_state.c	2004-03-11 03:55:5=
4.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/ipt_state.c	2004-03-29 1=
3:01:50.000000000 +0200
@@ -30,7 +30,9 @@
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
=20
-	if (!ip_conntrack_get((struct sk_buff *)skb, &ctinfo))
+	if (skb->nfct =3D=3D &ip_conntrack_untracked.infos[IP_CT_NEW])
+		statebit =3D IPT_STATE_UNTRACKED;
+	else if (!ip_conntrack_get((struct sk_buff *)skb, &ctinfo))
 		statebit =3D IPT_STATE_INVALID;
 	else
 		statebit =3D IPT_STATE_BIT(ctinfo);
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv4/netfilter/iptable_raw.c linux-2.6.5-rc2-nflog-trace/net=
/ipv4/netfilter/iptable_raw.c
--- linux-2.6.5-rc2-nflog/net/ipv4/netfilter/iptable_raw.c	1970-01-01 01:00=
:00.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv4/netfilter/iptable_raw.c	2004-03-29=
 13:01:49.000000000 +0200
@@ -0,0 +1,149 @@
+/*=20
+ * 'raw' table, which is the very first hooked in at PRE_ROUTING and LOCAL=
_OUT .
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
+=3D { { "raw", RAW_VALID_HOOKS, 3,
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
+	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } =
},
+		-NF_ACCEPT - 1 } },
+	    /* LOCAL_OUT */
+	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+		0,
+		sizeof(struct ipt_entry),
+		sizeof(struct ipt_standard),
+		0, { 0, 0 }, { } },
+	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } =
},
+		-NF_ACCEPT - 1 } }
+    },
+    /* ERROR */
+    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+	0,
+	sizeof(struct ipt_entry),
+	sizeof(struct ipt_error),
+	0, { 0, 0 }, { } },
+      { { { { IPT_ALIGN(sizeof(struct ipt_error_target)), IPT_ERROR_TARGET=
 } },
+	  { } },
+	"ERROR"
+      }
+    }
+};
+
+static struct ipt_table packet_raw =3D {=20
+	.name =3D "raw",=20
+	.table =3D &initial_table.repl,
+	.valid_hooks =3D  RAW_VALID_HOOKS,=20
+	.lock =3D RW_LOCK_UNLOCKED,=20
+	.me =3D THIS_MODULE
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
+static struct nf_hook_ops ipt_ops[] =3D {
+	{
+	  .hook =3D ipt_hook,=20
+	  .pf =3D PF_INET,=20
+	  .hooknum =3D NF_IP_PRE_ROUTING,=20
+	  .priority =3D NF_IP_PRI_RAW
+	},
+	{
+	  .hook =3D ipt_hook,=20
+	  .pf =3D PF_INET,=20
+	  .hooknum =3D NF_IP_LOCAL_OUT,=20
+	  .priority =3D NF_IP_PRI_RAW
+	},
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	/* Register table */
+	ret =3D ipt_register_table(&packet_raw);
+	if (ret < 0)
+		return ret;
+
+	/* Register hooks */
+	ret =3D nf_register_hook(&ipt_ops[0]);
+	if (ret < 0)
+		goto cleanup_table;
+
+	ret =3D nf_register_hook(&ipt_ops[1]);
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
+	for (i =3D 0; i < sizeof(ipt_ops)/sizeof(struct nf_hook_ops); i++)
+		nf_unregister_hook(&ipt_ops[i]);
+
+	ipt_unregister_table(&packet_raw);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv6/netfilter/Kconfig linux-2.6.5-rc2-nflog-trace/net/ipv6/=
netfilter/Kconfig
--- linux-2.6.5-rc2-nflog/net/ipv6/netfilter/Kconfig	2004-03-11 03:55:44.00=
0000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv6/netfilter/Kconfig	2004-03-29 13:01=
:49.000000000 +0200
@@ -218,5 +218,17 @@
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 #dep_tristate '  LOG target support' CONFIG_IP6_NF_TARGET_LOG $CONFIG_IP6_=
NF_IPTABLES
+config IP6_NF_RAW
+	tristate  'raw table support (required for TRACE)'
+	depends on IP6_NF_IPTABLES
+	help
+	  This option adds a `raw' table to ip6tables. This table is the very
+	  first in the netfilter framework and hooks in at the PREROUTING
+	  and OUTPUT chains.
+=09
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  help
+
 endmenu
=20
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv6/netfilter/Makefile linux-2.6.5-rc2-nflog-trace/net/ipv6=
/netfilter/Makefile
--- linux-2.6.5-rc2-nflog/net/ipv6/netfilter/Makefile	2004-03-11 03:55:33.0=
00000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv6/netfilter/Makefile	2004-03-29 13:0=
1:49.000000000 +0200
@@ -21,4 +21,5 @@
 obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
 obj-$(CONFIG_IP6_NF_QUEUE) +=3D ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) +=3D ip6t_LOG.o
+obj-$(CONFIG_IP6_NF_RAW) +=3D ip6table_raw.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) +=3D ip6t_hl.o
diff -Nru --exclude-from /sunbeam/home/laforge/scripts/dontdiff linux-2.6.5=
-rc2-nflog/net/ipv6/netfilter/ip6table_raw.c linux-2.6.5-rc2-nflog-trace/ne=
t/ipv6/netfilter/ip6table_raw.c
--- linux-2.6.5-rc2-nflog/net/ipv6/netfilter/ip6table_raw.c	1970-01-01 01:0=
0:00.000000000 +0100
+++ linux-2.6.5-rc2-nflog-trace/net/ipv6/netfilter/ip6table_raw.c	2004-03-2=
9 13:01:49.000000000 +0200
@@ -0,0 +1,154 @@
+/*
+ * IPv6 raw table, a port of the IPv4 raw table to IPv6
+ *
+ * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ */
+#include <linux/module.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+#define RAW_VALID_HOOKS ((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_OU=
T))
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
+} initial_table __initdata=20
+=3D { { "raw", RAW_VALID_HOOKS, 3,
+      sizeof(struct ip6t_standard) * 2 + sizeof(struct ip6t_error),
+      { [NF_IP6_PRE_ROUTING] 	0,
+	[NF_IP6_LOCAL_OUT]	sizeof(struct ip6t_standard) },
+      { [NF_IP6_PRE_ROUTING] 	0,
+	[NF_IP6_LOCAL_OUT]	sizeof(struct ip6t_standard) },
+      0, NULL, { } },
+    {
+	    /* PRE_ROUTING */
+            { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } }=
 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+		0,
+		sizeof(struct ip6t_entry),
+		sizeof(struct ip6t_standard),
+		0, { 0, 0 }, { } },
+	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { =
} },
+		-NF_ACCEPT - 1 } },
+	    /* LOCAL_OUT */
+            { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } }=
 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
+		0,
+		sizeof(struct ip6t_entry),
+		sizeof(struct ip6t_standard),
+		0, { 0, 0 }, { } },
+	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { =
} },
+		-NF_ACCEPT - 1 } },
+    },
+    /* ERROR */
+    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", =
"", { 0 }, { 0 }, 0, 0, 0 },
+	0,
+	sizeof(struct ip6t_entry),
+	sizeof(struct ip6t_error),
+	0, { 0, 0 }, { } },
+      { { { { IP6T_ALIGN(sizeof(struct ip6t_error_target)), IP6T_ERROR_TAR=
GET } },
+	  { } },
+	"ERROR"
+      }
+    }
+};
+
+static struct ip6t_table packet_raw =3D {=20
+	.name =3D "raw",=20
+	.table =3D &initial_table.repl,
+	.valid_hooks =3D RAW_VALID_HOOKS,=20
+	.lock =3D RW_LOCK_UNLOCKED,=20
+	.me =3D THIS_MODULE
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
+static struct nf_hook_ops ip6t_ops[] =3D {=20
+	{
+	  .hook =3D ip6t_hook,=20
+	  .pf =3D PF_INET6,
+	  .hooknum =3D NF_IP6_PRE_ROUTING,
+	  .priority =3D NF_IP6_PRI_FIRST
+	},
+	{
+	  .hook =3D ip6t_hook,=20
+	  .pf =3D PF_INET6,=20
+	  .hooknum =3D NF_IP6_LOCAL_OUT,
+	  .priority =3D NF_IP6_PRI_FIRST
+	},
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	/* Register table */
+	ret =3D ip6t_register_table(&packet_raw);
+	if (ret < 0)
+		return ret;
+
+	/* Register hooks */
+	ret =3D nf_register_hook(&ip6t_ops[0]);
+	if (ret < 0)
+		goto cleanup_table;
+
+	ret =3D nf_register_hook(&ip6t_ops[1]);
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
+	for (i =3D 0; i < sizeof(ip6t_ops)/sizeof(struct nf_hook_ops); i++)
+		nf_unregister_hook(&ip6t_ops[i]);
+
+	ip6t_unregister_table(&packet_raw);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");

--Aaj1jBvBEV7KRjLi--

--4Y142/9l9nQlBiaj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAaALrXaXGVTD0i/8RAjMeAKCQbZBG4m5s1lGHwOyHSxrdN9vm5wCeOctX
LaXgrnrLpvJwuSqj+OocDa8=
=wAHF
-----END PGP SIGNATURE-----

--4Y142/9l9nQlBiaj--
