From: Nagy Zoltan <kirk@elte.hu>
Subject: Re: Checksum of IP header
Date: Tue, 28 Jun 2005 13:39:33 +0159
Message-ID: <42C1370B.2060004@elte.hu>
References: <ada605fb050626041856c71794@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060703060707060500060009"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Que <qwejohn@gmail.com>
In-Reply-To: <ada605fb050626041856c71794@mail.gmail.com>
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
--------------060703060707060500060009
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

John Que wrote:
>        Namely, what I change is :
>                skb->nh.iph->daddr = newIPAddress (in u32 ).
> 
>        Everything works OK and the packets are sent to the new
>        destination as I can see with the sniffer; except foo the csum.
> 
>        I see in the sniffer that the csum of the ip header is wrong.
hi
i've the same problem not long ago, and i wrote the IPALTER patch, i think it can be usefull to you ;)
i've attached it ;)
i think it can be extended to alter other thing in the ip header like tos, but currently i don't need it ;)

>  done somewhere in the nat code (because as I understand part of what nat
>  does is change the source ip addresses).
but you must know, that the nat code doesn't know anything about what you have done, so the responses for the faked addresses
doesn't get any usable data, use NETMAP, MASQUERADE for those purposes

my patch is only working for extreme situtatuions, where you must inform your clients that they mtu is too big, or a better route is existing(redirect)
while you don't want to take(or can't) the router's ip ;)

sorry for my english ;)
best regards, kirk


--------------060703060707060500060009
Content-Type: text/plain;
 name="ipt_IPALTER-iptables-1.3.1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_IPALTER-iptables-1.3.1.patch"

diff -Naur iptables-1.3.1-orig/extensions/.IPALTER-test iptables-1.3.1/extensions/.IPALTER-test
--- iptables-1.3.1-orig/extensions/.IPALTER-test	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.1/extensions/.IPALTER-test	2005-05-14 00:37:57.000578224 +0200
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if IPALTER patch is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_IPALTER.h ] && echo IPALTER
diff -Naur iptables-1.3.1-orig/extensions/libipt_IPALTER.c iptables-1.3.1/extensions/libipt_IPALTER.c
--- iptables-1.3.1-orig/extensions/libipt_IPALTER.c	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.3.1/extensions/libipt_IPALTER.c	2005-05-15 17:36:17.876815776 +0200
@@ -0,0 +1,146 @@
+/* Shared library add-on to iptables to add TOS target support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <netdb.h>
+
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_IPALTER.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"IPALTER target v%s options:\n"
+"  --ip-saddr <ip>                   manipulate the source ip address\n"
+"  --ip-daddr <ip>                   manipulate the destination ip address\n",
+IPALTER_VERSION);
+
+	fputc('\n', stdout);
+}
+
+#define	IP_SADDR	100
+#define	IP_DADDR	101
+
+
+static struct option opts[] = {
+	{ "ip-saddr", 1, 0, IP_SADDR },
+	{ "ip-daddr", 1, 0, IP_DADDR },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+	memset((struct ipt_ipalter_target_info *)t->data,0,sizeof(struct ipt_ipalter_target_info));
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+inline void buff_or(void*dst,void*src,uint32_t l)
+{
+	uint32_t	p;
+	for(p=0;p<l/4;p++)
+		((uint32_t*)dst)[p]|=((uint32_t*)src)[p];
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+	struct ipt_ipalter_target_info *info
+		= (struct ipt_ipalter_target_info *)(*target)->data;
+	struct	iphdr	thdr;
+	memset(&thdr,0,sizeof(struct iphdr));
+	struct in_addr *ip;
+	
+	if(invert)
+	{
+		exit_error(PARAMETER_PROBLEM,
+		           "IPALTER: invert err");
+	}
+	switch (c) {
+	case IP_SADDR:
+		memset(&thdr.saddr,0xff,sizeof(uint32_t));
+		buff_or(&info->mask,&thdr,sizeof(struct iphdr));
+		ip=dotted_to_addr(optarg);
+		if(!ip)
+			exit_error(PARAMETER_PROBLEM,"IPALTER saddr ip");
+		thdr.saddr=ip->s_addr;
+		buff_or(&info->alter,&thdr,sizeof(struct iphdr));
+		*flags |= 1;
+		break;
+	case IP_DADDR:
+		memset(&thdr.daddr,0xff,sizeof(uint32_t));
+		buff_or(&info->mask,&thdr,sizeof(struct iphdr));
+		ip=dotted_to_addr(optarg);
+		if(!ip)
+			exit_error(PARAMETER_PROBLEM,"IPALTER daddr ip");
+		thdr.daddr=ip->s_addr;
+		buff_or(&info->alter,&thdr,sizeof(struct iphdr));
+		*flags |= 1;
+		break;
+	
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+		           "IPALTER target: xxx");
+}
+
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+//	const struct ipt_tos_target_info *tosinfo =
+//		(const struct ipt_tos_target_info *)target->data;
+	printf("IPALTER");
+//	print_tos(tosinfo->tos, numeric);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+//	const struct ipt_tos_target_info *tosinfo =
+//		(const struct ipt_tos_target_info *)target->data;
+//
+//	printf("--set-tos 0x%02x ", tosinfo->tos);
+}
+
+static struct iptables_target ipalter = {
+	.next		= NULL,
+	.name		= "IPALTER",
+	.version		= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_ipalter_target_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ipalter_target_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_target(&ipalter);
+}


--------------060703060707060500060009
Content-Type: text/plain;
 name="ipt_IPALTER-linux-2.6.11.9.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_IPALTER-linux-2.6.11.9.patch"

diff -Naur linux-2.6.11.9-orig/include/linux/netfilter_ipv4/ipt_IPALTER.h linux-2.6.11.9/include/linux/netfilter_ipv4/ipt_IPALTER.h
--- linux-2.6.11.9-orig/include/linux/netfilter_ipv4/ipt_IPALTER.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.11.9/include/linux/netfilter_ipv4/ipt_IPALTER.h	2005-05-15 17:36:21.020337888 +0200
@@ -0,0 +1,12 @@
+#ifndef _IPT_IPALTER_H_target
+#define _IPT_IPALTER_H_target
+
+//#include <linux/ip.h>
+#define	IPALTER_VERSION	"0.1"
+
+struct ipt_ipalter_target_info {
+	struct	iphdr	mask;
+	struct	iphdr	alter;
+};
+
+#endif /*_IPT_IPALTER_H_target*/
diff -Naur linux-2.6.11.9-orig/net/ipv4/netfilter/Kconfig linux-2.6.11.9/net/ipv4/netfilter/Kconfig
--- linux-2.6.11.9-orig/net/ipv4/netfilter/Kconfig	2005-05-12 00:42:25.000000000 +0200
+++ linux-2.6.11.9/net/ipv4/netfilter/Kconfig	2005-05-14 01:58:15.821006168 +0200
@@ -566,6 +566,14 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_TARGET_IPALTER
+	tristate "IPALTER target support"
+	depends on IP_NF_MANGLE
+	help
+	  This option adds a `IPALTER' target
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
diff -Naur linux-2.6.11.9-orig/net/ipv4/netfilter/Makefile linux-2.6.11.9/net/ipv4/netfilter/Makefile
--- linux-2.6.11.9-orig/net/ipv4/netfilter/Makefile	2005-05-12 00:40:57.000000000 +0200
+++ linux-2.6.11.9/net/ipv4/netfilter/Makefile	2005-05-14 02:36:29.942246728 +0200
@@ -63,6 +63,7 @@
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
+obj-$(CONFIG_IP_NF_TARGET_IPALTER) += ipt_IPALTER.o
 obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
 obj-$(CONFIG_IP_NF_TARGET_DSCP) += ipt_DSCP.o
 obj-$(CONFIG_IP_NF_TARGET_MARK) += ipt_MARK.o
diff -Naur linux-2.6.11.9-orig/net/ipv4/netfilter/ipt_IPALTER.c linux-2.6.11.9/net/ipv4/netfilter/ipt_IPALTER.c
--- linux-2.6.11.9-orig/net/ipv4/netfilter/ipt_IPALTER.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.11.9/net/ipv4/netfilter/ipt_IPALTER.c	2005-05-15 17:36:32.978519968 +0200
@@ -0,0 +1,131 @@
+
+/* ipt_IPALTER
+ *  started from ipt_TOS
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_IPALTER.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("kirk <kirk@elte.hu>");
+MODULE_DESCRIPTION("iptables ALTERIP mangling module");
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const void *targinfo,
+       void *userinfo)
+{
+	const struct ipt_ipalter_target_info *info = targinfo;
+
+	u_int16_t	pos;
+	u_int32_t	check_diff=0;
+	u_int8_t	altered	=0;
+	u_int32_t	t[2];
+	u_int32_t	*mask	=(u_int32_t*)&info->mask;
+	u_int32_t	*alter	=(u_int32_t*)&info->alter;
+	u_int32_t	*hdr		=(u_int32_t*)((*pskb)->nh.iph);
+
+	for(pos=0;pos<sizeof(struct iphdr)/4;pos++)
+	{
+		if(!mask[pos] ||	hdr[pos] & mask[pos] == alter[pos])
+			continue;
+		if(!altered)
+		{
+			altered=1;
+			if (!skb_ip_make_writable(pskb, sizeof(struct iphdr)))
+				return NF_DROP;
+			hdr		=(u_int32_t*)((*pskb)->nh.iph);
+//			(*pskb)->nh.iph->saddr=0x43434343;
+//			hdr[2]=0;
+//			(*pskb)->nfcache |= NFC_ALTERED;
+//			return IPT_CONTINUE;
+		}
+//		check_diff-=csum_partial(hdr+pos,sizeof(u_int32_t),0);
+		t[0]=hdr[pos]^0xffffffff;
+		hdr[pos]=alter[pos] | (hdr[pos] & ~mask[pos]);
+		t[1]=hdr[pos];
+		check_diff=csum_partial(&t,sizeof(u_int32_t)*2,check_diff);
+//		printk("t %x	%x\n",t,check_diff);
+	}
+	
+	if(altered)
+	{
+//		printk("c %x\n",(*pskb)->nh.iph->check);
+		(*pskb)->nh.iph->check
+			= csum_fold(csum_partial((char*)&check_diff,
+						 sizeof(u_int32_t),
+						 (*pskb)->nh.iph->check^0xffff
+							));
+//						 (*pskb)->nh.iph->check
+//						 ^0xFFFF));
+		(*pskb)->nfcache |= NFC_ALTERED;
+	}
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
+//	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
+
+	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_ipalter_target_info))) {
+		printk(KERN_WARNING "IPALTER: targinfosize %u != %Zu\n",
+		       targinfosize,
+		       IPT_ALIGN(sizeof(struct ipt_ipalter_target_info)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") != 0) {
+		printk(KERN_WARNING "IPALTER: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
+		return 0;
+	}
+
+// 	if (tos != IPTOS_LOWDELAY
+// 	    && tos != IPTOS_THROUGHPUT
+// 	    && tos != IPTOS_RELIABILITY
+// 	    && tos != IPTOS_MINCOST
+// 	    && tos != IPTOS_NORMALSVC) {
+// 		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
+// 		return 0;
+// 	}
+
+	return 1;
+}
+
+static struct ipt_target ipt_ipalter_reg = {
+	.name		= "IPALTER",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me			= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	printk("ipt_alter v%s",IPALTER_VERSION);
+	return ipt_register_target(&ipt_ipalter_reg);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_ipalter_reg);
+}
+
+module_init(init);
+module_exit(fini);


--------------060703060707060500060009--
