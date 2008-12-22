From: Piotr Duszynski <regis44@gmail.com>
Subject: Re: [PATCH 1/1 ] Conntrack extensions : Interrupt timeout
Date: Mon, 22 Dec 2008 11:36:38 +0100
Message-ID: <494F6DB6.9030106@gmail.com>
References: <49467ACC.8080107@trash.net>	 <20081216.012018.196068498.davem@davemloft.net>	 <49495F88.2010103@gmail.com> <38bcb3ec0812171836r4c6161b2m1026d73722a72cfe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:34937 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYLVKgV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:36:21 -0500
Received: by fg-out-1718.google.com with SMTP id 19so754776fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Dec 2008 02:36:19 -0800 (PST)
In-Reply-To: <38bcb3ec0812171836r4c6161b2m1026d73722a72cfe@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you James,
I have rewritten my code according to your advice. Unfortunately I am
still getting the same exception ( death_by_timeout () ) at random
moments ( Sometimes this occurs after creating many conntracks with nc
www.google.com . Another time instantly after first tcp connection has
been made . I would be very grateful If you could point me the directio=
n
in which I could investigate this problem .

I don't know if this has anything to do, but I am testing this patch on
VMware Fedora 10 wit selinux enabled .

Best regards
Piotr Duszynski

I have attached new patch to this e-mail :

diff -uNr
linux-2.6.27.i686.orig/include/linux/netfilter/nf_conntrack_common.h
linux-2.6.27.i686.new/include/linux/netfilter/nf_conntrack_common.h
---
linux-2.6.27.i686.orig/include/linux/netfilter/nf_conntrack_common.h
2008-11-28 07:31:14.000000000 +0100
+++ linux-2.6.27.i686.new/include/linux/netfilter/nf_conntrack_common.h
2008-12-09 17:42:47.000000000 +0100
@@ -73,6 +73,10 @@
       /* Connection has fixed timeout. */
       IPS_FIXED_TIMEOUT_BIT =3D 10,
       IPS_FIXED_TIMEOUT =3D (1 << IPS_FIXED_TIMEOUT_BIT),
+
+       /* Connection has src L2 info */
+       IPS_L2_INFO_BIT =3D 11,
+       IPS_L2_INFO =3D (1 << IPS_L2_INFO_BIT),
 };

 /* Connection tracking event bits */
diff -uNr
linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_extend.h
linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_extend.h
--- linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_extend.h
2008-11-28 07:31:53.000000000 +0100
+++ linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_extend.h
2008-12-14 04:16:44.000000000 +0100
@@ -8,12 +8,14 @@
       NF_CT_EXT_HELPER,
       NF_CT_EXT_NAT,
       NF_CT_EXT_ACCT,
+       NF_CT_EXT_L2INFO,
       NF_CT_EXT_NUM,
 };

 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
+#define NF_CT_EXT_L2INFO_TYPE struct nf_conn_l2info

 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff -uNr
linux-2.6.27.i686.orig/
include/net/netfilter/nf_conntrack_l2info.h
linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_l2info.h
--- linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_l2info.h

1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_l2info.h
2008-12-19 06:58:47.000000000 +0100
@@ -0,0 +1,39 @@
+#ifndef _NF_CONNTRACK_L2INFO_H
+#define _NF_CONNTRACK_L2INFO_H

+
+#include <linux/if_ether.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conn_l2info {
+       // MAC only at the moment
+       unsigned char src_addr[ETH_ALEN];
+       unsigned char dst_addr[ETH_ALEN];
+};
+
+
+static inline
+struct nf_conn_l2info  *nfct_l2info(const struct nf_conn *ct)
+{
+        return nf_ct_ext_find(ct,NF_CT_EXT_L2INFO);
+}
+
+
+static inline

+struct nf_conn_l2info *nf_ct_l2info_ext_add(struct nf_conn *ct, gfp_t =
gfp)
+{
+       struct nf_conn_l2info *l2info;

+
+       l2info =3D nf_ct_ext_add(ct, NF_CT_EXT_L2INFO,GFP_ATOMIC);
+        if (l2info =3D=3D NULL) {

+                            printk(KERN_INFO "failed to add L2INFO
extension\n");
+                            }
+
+       return l2info;
+};
+
+extern int nf_conntrack_l2info_init(void);
+extern void nf_conntrack_l2info_fini(void);
+
+
+#endif

diff -uNr linux-2.6.27.i686.orig/net/netfilter/Kconfig
linux-2.6.27.i686.new/net/netfilter/Kconfig
--- linux-2.6.27.i686.orig/net/netfilter/Kconfig        2008-11-28
07:29:39.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/Kconfig 2008-12-09
18:52:13.000000000 +0100
@@ -380,6 +380,16 @@

         To compile it as a module, choose M here.  If unsure, say N.

+
+config NETFILTER_XT_TARGET_L2INFO
+       tristate  '"L2INFO" target support'
+       depends on NETFILTER_XTABLES
+       depends on NF_CONNTRACK
+       help
+         Adds L2 info to the connection
+         If unsure, say `N'.
+
+
 config NETFILTER_XT_TARGET_NOTRACK
       tristate  '"NOTRACK" target support'
       depends on NETFILTER_XTABLES
diff -uNr linux-2.6.27.i686.orig/net/netfilter/Makefile
linux-2.6.27.i686.new/net/netfilter/Makefile
--- linux-2.6.27.i686.orig/net/netfilter/Makefile       2008-11-28
07:29:33.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/Makefile        2008-12-19
20:35:01.000000000 +0100
@@ -1,6 +1,6 @@
 netfilter-objs :=3D core.o nf_log.o nf_queue.o nf_sockopt.o

-nf_conntrack-y :=3D nf_conntrack_core.o nf_conntrack_standalone.o
nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o
nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o
nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o
nf_conntrack_acct.o
+nf_conntrack-y :=3D nf_conntrack_core.o nf_conntrack_standalone.o
nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o
nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o
nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o
nf_conntrack_acct.o nf_conntrack_l2info.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) +=3D nf_conntrack_ecache.o

 obj-$(CONFIG_NETFILTER) =3D netfilter.o
@@ -49,6 +49,7 @@
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) +=3D xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) +=3D xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) +=3D xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_L2INFO) +=3D xt_L2INFO.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) +=3D xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) +=3D xt_TRACE.o

diff -uNr linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_core.c
linux-2.6.27.i686.new/net/netfilter/nf_conntrack_core.c
--- linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_core.c    2008-11=
-28

07:29:33.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/nf_conntrack_core.c     2008-12=
-19
06:55:31.000000000 +0100
@@ -38,6 +38,7 @@
 #include <net/netfilter/nf_conntrack_core.h>

 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/nf_conntrack_l2info.h>

 #define NF_CONNTRACK_VERSION   "0.5.0"

@@ -557,6 +558,7 @@
       }

       nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+       nf_ct_l2info_ext_add(ct, GFP_ATOMIC);

       spin_lock_bh(&nf_conntrack_lock);
       exp =3D nf_ct_find_expectation(tuple);
@@ -1032,6 +1034,8 @@
       nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_vmalloc,
                            nf_conntrack_htable_size);

+
+       nf_conntrack_l2info_fini();
       nf_conntrack_acct_fini();
       nf_conntrack_expect_fini();
       nf_conntrack_helper_fini();
@@ -1178,6 +1182,11 @@
       ret =3D nf_conntrack_acct_init();
       if (ret < 0)
               goto out_fini_helper;
+
+       ret =3D nf_conntrack_l2info_init();
+       if (ret < 0)
+               goto out_fini_helper;
+

       /* For use by REJECT target */
       rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
diff -uNr linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_l2info.c
linux-2.6.27.i686.new/net/netfilter/nf_conntrack_l2info.c
--- linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_l2info.c

1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/nf_conntrack_l2info.c   2008-12=
-19
23:37:04.000000000 +0100
@@ -0,0 +1,33 @@
+#include <linux/netfilter.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>

+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_l2info.h>
+
+MODULE_PARM_DESC(acct, "Enable l2info tracking.");
+

+static struct nf_ct_ext_type l2info_extend __read_mostly =3D {
+       .len            =3D sizeof(struct nf_conn_l2info),
+       .align          =3D __alignof__(struct nf_conn_l2info),
+       .id             =3D NF_CT_EXT_L2INFO,
+};
+
+int nf_conntrack_l2info_init(void)

+{
+
+       int ret;
+
+       ret =3D nf_ct_extend_register(&l2info_extend);
+       if (ret < 0) {
+               printk(KERN_ERR "Unable to register L2INFO extension\n"=
);
+               return ret;
+       }
+
+       return 0;
+}
+
+void nf_conntrack_l2info_fini(void)

+{
+       nf_ct_extend_unregister(&l2info_extend);
+}
diff -uNr linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_standalone.=
c
linux-2.6.27.i686.new/net/netfilter/nf_conntrack_standalone.c
--- linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_standalone.c
2008-11-28 07:29:39.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/nf_conntrack_standalone.c
2008-12-19 07:27:41.000000000 +0100

@@ -26,6 +26,8 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/nf_conntrack_l2info.h>

+

 MODULE_LICENSE("GPL");

@@ -151,6 +153,32 @@
       if (test_bit(IPS_ASSURED_BIT, &ct->status))
               if (seq_printf(s, "[ASSURED] "))
                       return -ENOSPC;
+       if (test_bit(IPS_L2_INFO, &ct->status))
+           {
+               if (seq_printf(s, "[L2INFO] "))
+                       return -ENOSPC;
+               struct nf_conn_l2info* l2info =3D nfct_l2info(ct);
+
+               if (!l2info)
+                       return -ENOSPC;

+
+               int
ret=3Dseq_printf(s,"[%.2x:%.2x:%.2x:%.2x:%.2x:%.2x]<->[%.2x:%.2x:%.2x:%=
=2E2x:%.2x:%.2x]
",
+                l2info->src_addr[0],
+                l2info->src_addr[1],
+                l2info->src_addr[2],
+                l2info->src_addr[3],
+                l2info->src_addr[4],
+                l2info->dst_addr[5],
+                l2info->dst_addr[0],
+                l2info->dst_addr[1],
+                l2info->dst_addr[2],
+                l2info->dst_addr[3],
+                l2info->dst_addr[4],
+                l2info->dst_addr[5]);
+
+               if (ret)
+               return -ENOSPC;
+           }

 #if defined(CONFIG_NF_CONNTRACK_MARK)
       if (seq_printf(s, "mark=3D%u ", ct->mark))
diff -uNr linux-2.6.27.i686.orig/net/netfilter/xt_L2INFO.c
linux-2.6.27.i686.new/net/netfilter/xt_L2INFO.c
--- linux-2.6.27.i686.orig/net/netfilter/xt_L2INFO.c    1970-01-01
01:00:00.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/xt_L2INFO.c     2008-12-19
06:54:02.000000000 +0100
@@ -0,0 +1,113 @@

+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <net/netfilter/nf_conntrack_l2info.h>
- Poka=C5=BC cytowany tekst -
- Poka=C5=BC cytowany tekst -
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/inet.h>
+#include <linux/version.h>
+
+
+MODULE_AUTHOR("Piotr Duszynski L2 info target");
+MODULE_DESCRIPTION("x_tables per-conntrack L2info target");
+MODULE_LICENSE("GPL");
+
+
+static unsigned int target(struct sk_buff *skb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const struct xt_target *target,
+       const void *targinfo)
+{
+       struct nf_conn_l2info *l2info ;
+       struct nf_conn *ct;
+       enum ip_conntrack_info ctinfo;
+       struct ethhdr *eth;
+
+       ct =3D nf_ct_get(skb, &ctinfo);
+
+       if (ct && (! test_bit(IPS_L2_INFO,&ct->status)))
+       {
+
+       if(IP_CT_ESTABLISHED!=3Dctinfo
+       && ctinfo !=3D IP_CT_ESTABLISHED+IP_CT_IS_REPLY)
+       return XT_CONTINUE;
+
+       if (  IP_CT_ESTABLISHED=3D=3Dctinfo)
+       printk(KERN_INFO "L2INFO ESTABLISHED\n");
+       if ( ctinfo =3D=3D IP_CT_ESTABLISHED+IP_CT_IS_REPLY)
+       printk(KERN_INFO "L2INFO REPLY ESTABLISHED\n");
+
+               l2info =3D nfct_l2info(ct);
+               if (!l2info) {
+                       printk(KERN_INFO "failed to find L2INFO
extension\n");
+                       return XT_CONTINUE;
+                       }
+
- Poka=C5=BC cytowany tekst -

+               eth =3D (struct ethhdr *)skb_mac_header(skb);
+               printk( KERN_INFO "L2INFO: [
%.2x:%.2x:%.2x:%.2x:%.2x:%.2x ->
%.2x:%.2x:%.2x:%.2x:%.2x:%.2x] \n",
+                 eth->h_source[0],
+                 eth->h_source[1],
+                 eth->h_source[2],
+                 eth->h_source[3],
+                 eth->h_source[4],
+                 eth->h_source[5],
+                 eth->h_dest[0],
+                 eth->h_dest[1],
+                 eth->h_dest[2],
+                 eth->h_dest[3],
+                 eth->h_dest[4],
+                 eth->h_dest[5]);
+
+               l2info->src_addr[0]=3Deth->h_source[0];
+                l2info->src_addr[1]=3Deth->h_source[1];
+                l2info->src_addr[2]=3Deth->h_source[2];
+                l2info->src_addr[3]=3Deth->h_source[3];
+                l2info->src_addr[4]=3Deth->h_source[4];
+                l2info->src_addr[5]=3Deth->h_source[5];
+                l2info->dst_addr[0]=3Deth->h_dest[0];
+                l2info->dst_addr[1]=3Deth->h_dest[1];
+                l2info->dst_addr[2]=3Deth->h_dest[2];
+                l2info->dst_addr[3]=3Deth->h_dest[3];
+                l2info->dst_addr[4]=3Deth->h_dest[4];
+                l2info->dst_addr[5]=3Deth->h_dest[5];
+
+               //memcpy(l2info->src_addr,eth->h_source,sizeof( unsigne=
d
char
)*ETH_ALEN );
+               //memcpy(l2info->src_addr,eth->h_dest,sizeof( unsigned
char )*ETH_ALEN );
+               set_bit(IPS_L2_INFO,&ct->status);
+       }
+               return XT_CONTINUE;
+}
+
+
+static struct xt_target xt_l2info __read_mostly =3D {
+               .name           =3D "L2INFO",
+               .family         =3D AF_INET,
+               .target         =3D target,
+               .me             =3D THIS_MODULE,
+};
+
+static int __init xt_l2info_init(void)
+{
+       int ret;
+
+       ret =3D xt_register_target(&xt_l2info);
+       if (ret < 0)
+       printk(KERN_ERR "xt_L2INFO: Unable to register target \n");

+
+       return ret;
+}
+
+static void __exit xt_l2info_fin(void)
+{
+       xt_unregister_target(&xt_l2info);

+}
+
+module_init(xt_l2info_init);
+module_exit(xt_l2info_fin);
+
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
