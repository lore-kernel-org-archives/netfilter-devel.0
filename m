From: Luciano Ruete <kies@myrealbox.com>
Subject: [PATCH] ipt_mask
Date: Mon, 02 Dec 2002 15:02:52 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEBA04C.7080606@myrealbox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050604040408030504010007"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050604040408030504010007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi, i've made a netfilter match module called ipt_mask. Basically it 
provides arbitrary mask syntax to do a match whit the destination address.
ie:

iptables -m mask --mask 0x01,0x00 -j MARK --set-mark 6900
iptables -m mask --mask 0x01,0x01 -j MARK --set-mark 6901

will logical AND the first parameter(and_mask) whit the daddress and 
then compare the result whit the second parameter(cmpr_mask)
As result it is MARKing whit 6900 the even daddress and whit 6901 the 
odd daddress.

It works for me to do a dirty ;-) load balancing between to or more 
providers.

I guess maybe can be usefull(?) to match broadcast address using ie:
iptables -m mask --mask 0xF,0xF


Whell if you see it is usefull in some way i will be glad to make a 
working patch against the las patch-o-matic version (this patchs are 
againsta iptables-1.2.7a and linux-2.4.19). Anyway i have a lot of fun 
doing it :-)

Suegestion/modifications are welcome. This is my first hack ever, so it 
maybe look like a newbie has code it =).

Attached patch also aviable at http://lupe.praga.org.ar/dev/ipt_mask/
Greetings !

--
Luciano
ps: sorry about my pour english.

--------------050604040408030504010007
Content-Type: text/plain;
 name="ipt_mask.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_mask.patch"

diff -Naur linux-2.4.19.orig/include/linux/netfilter_ipv4/ipt_mask.h linux-2.4.19/include/linux/netfilter_ipv4/ipt_mask.h
--- linux-2.4.19.orig/include/linux/netfilter_ipv4/ipt_mask.h	1969-12-31 21:00:00.000000000 -0300
+++ linux-2.4.19/include/linux/netfilter_ipv4/ipt_mask.h	2002-11-12 18:56:51.000000000 -0300
@@ -0,0 +1,9 @@
+#ifndef _IPT_MASK_H
+#define _IPT_MASK_H
+
+
+struct ipt_mask_info {
+	u_int32_t and_mask; // mask to be ANDed whit addres
+	u_int32_t cmpr_mask; // mask to compare after AND
+};
+#endif /*_IPT_MASK_H*/
diff -Naur linux-2.4.19.orig/net/ipv4/netfilter/Config.in linux-2.4.19/net/ipv4/netfilter/Config.in
--- linux-2.4.19.orig/net/ipv4/netfilter/Config.in	2002-08-02 21:39:46.000000000 -0300
+++ linux-2.4.19/net/ipv4/netfilter/Config.in	2002-11-16 17:11:50.000000000 -0300
@@ -25,6 +25,8 @@
   dep_tristate '  LENGTH match support' CONFIG_IP_NF_MATCH_LENGTH $CONFIG_IP_NF_IPTABLES
   dep_tristate '  TTL match support' CONFIG_IP_NF_MATCH_TTL $CONFIG_IP_NF_IPTABLES
   dep_tristate '  tcpmss match support' CONFIG_IP_NF_MATCH_TCPMSS $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  arbitrary mask syntax match support' CONFIG_IP_NF_MATCH_MASK $CONFIG_IP_NF_IPTABLES
+  
   if [ "$CONFIG_IP_NF_CONNTRACK" != "n" ]; then
     dep_tristate '  Connection state match support' CONFIG_IP_NF_MATCH_STATE $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES 
   fi
diff -Naur linux-2.4.19.orig/net/ipv4/netfilter/ipt_mask.c linux-2.4.19/net/ipv4/netfilter/ipt_mask.c
--- linux-2.4.19.orig/net/ipv4/netfilter/ipt_mask.c	1969-12-31 21:00:00.000000000 -0300
+++ linux-2.4.19/net/ipv4/netfilter/ipt_mask.c	2002-11-16 17:13:33.000000000 -0300
@@ -0,0 +1,57 @@
+/* Kernel module to match daddress against arbitrary syntax mask. 
+* 
+* Copyright (c) 2002 Luciano Ruete <luciano@lugmen.org.ar> 
+* 
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/ 
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/udp.h>
+
+
+#include <linux/netfilter_ipv4/ipt_mask.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *hdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+	const struct ipt_mask_info *info = matchinfo;
+	if (( skb->nh.iph->daddr & info->and_mask) ^ info->cmpr_mask)
+		return 0;
+	return 1;
+	
+}
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+        if (matchsize != IPT_ALIGN(sizeof(struct ipt_mask_info)))
+		return 0;
+	return 1;
+}
+
+static struct ipt_match mask_match
+= { { NULL, NULL }, "mask", &match, &checkentry, NULL, THIS_MODULE };
+
+static int __init init(void)
+{
+	return ipt_register_match(&mask_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&mask_match);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
+
diff -Naur linux-2.4.19.orig/net/ipv4/netfilter/Makefile linux-2.4.19/net/ipv4/netfilter/Makefile
--- linux-2.4.19.orig/net/ipv4/netfilter/Makefile	2002-08-02 21:39:46.000000000 -0300
+++ linux-2.4.19/net/ipv4/netfilter/Makefile	2002-11-12 18:56:03.000000000 -0300
@@ -55,6 +55,7 @@
 obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_AH_ESP) += ipt_ah.o ipt_esp.o
+obj-$(CONFIG_IP_NF_MATCH_MASK) += ipt_mask.o
 
 obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length.o
 

--------------050604040408030504010007
Content-Type: text/plain;
 name="libipt_mask.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_mask.patch"

diff -Naur iptables-1.2.7a.orig/extensions/libipt_mask.c iptables-1.2.7a/extensions/libipt_mask.c
--- iptables-1.2.7a.orig/extensions/libipt_mask.c	1969-12-31 21:00:00.000000000 -0300
+++ iptables-1.2.7a/extensions/libipt_mask.c	2002-11-18 02:20:58.000000000 -0300
@@ -0,0 +1,113 @@
+/* Shared library add-on to iptables to add NFMASK arbitrary mask syntax matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_mask.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"mask match v%s options:\n"
+"--mask andmask,matchmask  match matchmask whit the resutl of (dstadress & andmask)\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "mask", 1, 0, '1' },
+	{0}
+};
+
+/* Initialize the match. */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* Can't cache this. */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_mask_info *maskinfo = (struct ipt_mask_info *)(*match)->data;
+	switch (c) {
+		char *end;
+	case '1':
+		maskinfo->and_mask = htonl((u_int32_t)strtoul(optarg, &end, 0));
+		if (*end == ',') {
+			maskinfo->cmpr_mask = htonl((u_int32_t)strtoul(end+1, &end, 0));
+		} else
+			exit_error(PARAMETER_PROBLEM, "must specify both ANDmask,MATCHmask %s",optarg);
+		if (*end != '\0' || end == optarg)
+			exit_error(PARAMETER_PROBLEM, "bad mask values `%s'", optarg);
+		*flags=1;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+/* Final check; must have specified --mask. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "mask expection an option");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	const struct ipt_mask_info *maskinfo = (const struct ipt_mask_info *)match->data;
+	
+	printf("mask match ");
+	printf("0x%x,0x%x ", ntohl(maskinfo->and_mask),
+			     ntohl(maskinfo->cmpr_mask) );
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	const struct ipt_mask_info *maskinfo = (const struct ipt_mask_info *)match->data;
+	printf("--mask ");
+	printf("0x%x,0x%x ", ntohl(maskinfo->and_mask),
+			     ntohl(maskinfo->cmpr_mask) );
+}
+
+static
+struct iptables_match mask
+= { NULL,
+    "mask",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_mask_info)),
+    IPT_ALIGN(sizeof(struct ipt_mask_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match(&mask);
+}
diff -Naur iptables-1.2.7a.orig/extensions/Makefile iptables-1.2.7a/extensions/Makefile
--- iptables-1.2.7a.orig/extensions/Makefile	2002-08-09 04:44:10.000000000 -0300
+++ iptables-1.2.7a/extensions/Makefile	2002-11-18 02:21:05.000000000 -0300
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TCPMSS TOS ULOG
+PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length limit mac mark mask multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TCPMSS TOS ULOG
 PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner standard tcp udp LOG MARK
 
 # The following may not be present, but compile them anyway.

--------------050604040408030504010007--
