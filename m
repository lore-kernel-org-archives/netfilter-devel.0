From: Nagy Zoltan <kirk@elte.hu>
Subject: ipalter/ipset
Date: Mon, 16 May 2005 06:41:53 +0159
Message-ID: <428824A7.3060506@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060605080805080607010001"
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
--------------060605080805080607010001
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

hi

i've made a small patch to the ipset/portmap match, it adds an alternate "invert" which made me able to
restrict all users to ssh/http/other basic services,
and open all ports when neccessary with an easy step...maybe good for somebody too ;)

the IPALTER target it rewrites the source or dest address of an ip package - i've searched a long time for an alternate solution...but i didn't find anything..
i think it's only useful for extreme situtations in my case: i've an arp proxy firewall, and it wants to notify the
clients that they need to change there MTU to 1440 because the other side can't handle it...the clients doesn't accept
the icmp fragmentation-needed package, because 10.0.0.2 is not their router, so i rewrite it to look like that ;)

best regards, kirk

--------------060605080805080607010001
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

--------------060605080805080607010001
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

--------------060605080805080607010001
Content-Type: text/plain;
 name="portmap_invert_ipset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="portmap_invert_ipset.patch"

diff -Naur ipset-orig/ipset_portmap.c ipset/ipset_portmap.c
--- ipset-orig/ipset_portmap.c	2005-01-19 14:38:57.000000000 +0100
+++ ipset/ipset_portmap.c	2005-04-08 01:24:28.000000000 +0200
@@ -69,7 +69,9 @@
 		   port_tostring(mydata->to, 0));
 
 		break;
-
+	case '3':
+		mydata->invert=1;
+		break;
 	default:
 		return 0;
 	}
@@ -111,6 +113,7 @@
 static struct option create_opts[] = {
 	{"from", 1, 0, '1'},
 	{"to", 1, 0, '2'},
+	{"invert", 0, 0, '3'},
 	{0}
 };
 
@@ -140,6 +143,7 @@
 	memset(map, 0, sizeof(struct ip_set_portmap));
 	map->first_port = header->from;
 	map->last_port = header->to;
+	map->invert=header->invert;
 }
 
 void printheader(struct set *set, unsigned options)
@@ -149,6 +153,8 @@
 
 	printf(" from: %s", port_tostring(mysetdata->first_port, options));
 	printf(" to: %s\n", port_tostring(mysetdata->last_port, options));
+	printf(" invert: %s\n", mysetdata->invert ? "on" : "off");
+
 }
 
 void printports_sorted(struct set *set, void *data, size_t len, unsigned options)
@@ -176,6 +182,8 @@
 	       port_tostring(mysetdata->first_port, options));
 	printf(" --to %s\n", 
 	       port_tostring(mysetdata->last_port, options));
+	if(mysetdata->invert)
+		printf(" --invert\n");
 }
 
 void saveports(struct set *set, void *data, size_t len, unsigned options)
@@ -196,7 +204,7 @@
 void usage(void)
 {
 	printf
-	    ("-N set portmap --from PORT --to PORT\n"
+	    ("-N set portmap --from PORT --to PORT [--invert]\n"
 	     "-A set PORT\n"
 	     "-D set PORT\n"
 	     "-T set PORT\n");

--------------060605080805080607010001
Content-Type: text/plain;
 name="portmap_invert_kernel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="portmap_invert_kernel.patch"

--- ./linux-2.6.11.5-b2/include/linux/netfilter_ipv4/ip_set_portmap.h	2005-03-27 15:58:31.000000000 +0200
+++ ./linux-2.6.11.5/include/linux/netfilter_ipv4/ip_set_portmap.h	2005-04-07 07:40:34.000000000 +0200
@@ -9,17 +9,20 @@
 
 struct ip_set_portmap {
 	void *members;			/* the portmap proper */
-	ip_set_ip_t first_port;		/* host byte order, included in range */
-	ip_set_ip_t last_port;		/* host byte order, included in range */
+	ip_set_ip_t	first_port;	/* host byte order, included in range */
+	ip_set_ip_t	last_port;	/* host byte order, included in range */
+	ip_set_ip_t	invert;		/* invert ports match */	
 };
 
 struct ip_set_req_portmap_create {
 	ip_set_ip_t from;
 	ip_set_ip_t to;
+	ip_set_ip_t invert;
 };
 
 struct ip_set_req_portmap {
 	ip_set_ip_t port;
+	ip_set_ip_t invert;
 };
 
 #endif /* __IP_SET_PORTMAP_H */
--- ./linux-2.6.11.5-b2/net/ipv4/netfilter/ip_set_portmap.c	2005-03-27 15:58:33.000000000 +0200
+++ ./linux-2.6.11.5/net/ipv4/netfilter/ip_set_portmap.c	2005-04-07 08:28:06.000000000 +0200
@@ -69,11 +69,17 @@
 	struct ip_set_portmap *map = (struct ip_set_portmap *) set->data;
 
 	if (port < map->first_port || port > map->last_port)
-		return -ERANGE;
-		
+	{
+		if(map->invert)
+			return	1;
+		else	return -ERANGE;
+	}	
 	*hash_port = port;
 	DP("set: %s, port:%u, %u", set->name, port, *hash_port);
-	return !!test_bit(port - map->first_port, map->members);
+	if(map->invert)
+		return !test_bit(port - map->first_port, map->members);
+	else
+		return !!test_bit(port - map->first_port, map->members);
 }
 
 static int
@@ -229,6 +235,7 @@
 	}
 	map->first_port = req->from;
 	map->last_port = req->to;
+	map->invert = !!req->invert;
 	newbytes = bitmap_bytes(req->from, req->to);
 	map->members = kmalloc(newbytes, GFP_KERNEL);
 	if (!map->members) {
@@ -268,6 +275,7 @@
 
 	header->from = map->first_port;
 	header->to = map->last_port;
+	header->invert=map->invert;
 }
 
 static int list_members_size(const struct ip_set *set)

--------------060605080805080607010001--
