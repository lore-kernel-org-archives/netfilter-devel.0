From: "Ranjeet Shetye" <ranjeet.shetye@zultys.com>
Subject: RE: [RESEND][PATCH] Hop Limit match/target for IPv6
Date: Tue, 31 Dec 2002 13:00:40 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000101c2b10f$ad097860$0100a8c0@zultys.com>
References: <Pine.LNX.4.44.0212301950480.6450-200000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.samba.org>
In-Reply-To: <Pine.LNX.4.44.0212301950480.6450-200000@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi Maciej,

I appreciate any code development that people like you are doing, and I
am sure that others appreciate it too. Maybe the reason you haven't
received a response/review is that most people are probably working on
ipv4 right now. When ipv6 starts kicking in big time, I am sure you'll
hear from all the people, esp. since your email id is in the diffs!

A very Happy New Year to you.

Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
771 Vaqueros Avenue
Sunnyvale  CA  94085
USA
Ranjeet.Shetye@Zultys.com
http://www.zultys.com/

 


> -----Original Message-----
> From: netfilter-devel-admin@lists.netfilter.org 
> [mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf 
> Of Maciej Soltysiak
> Sent: Monday, December 30, 2002 12:10 PM
> To: netfilter-devel@lists.samba.org
> Subject: [RESEND][PATCH] Hop Limit match/target for IPv6
> 
> 
> Hello,
> 
> this is a Hop Limit match and target (similar to the TTL 
> modules) for IPv6.
> 
> There was no response on the list to this :(
> It's a resend.
> 
> Best Regards,
> Maciej Soltysiak
> 
> 
> diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6 
> netfilter/patch-o-matic/base/HL.patch.ipv6
> --- netfilter.orig/patch-o-matic/base/HL.patch.ipv6	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/HL.patch.ipv6	
> 2002-12-16 18:05:55.000000000 +0100
> @@ -0,0 +1,135 @@
> +diff -Nru 
> linux-2.4.20/include/linux/netfilter_ipv6/ip6t_HL.h 
> linux.new/include/linux/netfilter_ipv6/ip6t_HL.h
> +--- linux-2.4.20/include/linux/netfilter_ipv6/ip6t_HL.h	
> 1970-01-01 01:00:00.000000000 +0100
> ++++ linux.new/include/linux/netfilter_ipv6/ip6t_HL.h	
> 2002-12-16 17:12:29.000000000 +0100
> +@@ -0,0 +1,22 @@
> ++/* Hop Limit modification module for ip6tables
> ++ * Maciej Soltysiak <solt@dns.toxicfilms.tv> */
> ++ * Based on HW's TTL module */
> ++
> ++#ifndef _IP6T_HL_H
> ++#define _IP6T_HL_H
> ++
> ++enum {
> ++	IP6T_HL_SET = 0,
> ++	IP6T_HL_INC,
> ++	IP6T_HL_DEC
> ++};
> ++
> ++#define IP6T_HL_MAXMODE	IP6T_HL_DEC
> ++
> ++struct ip6t_HL_info {
> ++	u_int8_t	mode;
> ++	u_int8_t	hop_limit;
> ++};
> ++
> ++
> ++#endif
> +diff -Nru linux-2.4.20/net/ipv6/netfilter/ip6t_HL.c 
> linux.new/net/ipv6/netfilter/ip6t_HL.c
> +--- linux-2.4.20/net/ipv6/netfilter/ip6t_HL.c	
> 1970-01-01 01:00:00.000000000 +0100
> ++++ linux.new/net/ipv6/netfilter/ip6t_HL.c	2002-12-16 
> 17:08:23.000000000 +0100
> +@@ -0,0 +1,105 @@
> ++/*
> ++ * Hop Limit modification target for ip6tables
> ++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
> ++ * Based on HW's TTL module
> ++ *
> ++ * This software is distributed under the terms of GNU GPL
> ++ */
> ++
> ++#include <linux/module.h>
> ++#include <linux/skbuff.h>
> ++#include <linux/ip.h>
> ++
> ++#include <linux/netfilter_ipv6/ip6_tables.h>
> ++#include <linux/netfilter_ipv6/ip6t_HL.h>
> ++
> ++MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>"); 
> ++MODULE_DESCRIPTION("IP tables Hop Limit modification module"); 
> ++MODULE_LICENSE("GPL");
> ++
> ++static unsigned int ip6t_hl_target(struct sk_buff **pskb, 
> unsigned int hooknum,
> ++		const struct net_device *in, const struct 
> net_device *out,
> ++		const void *targinfo, void *userinfo)
> ++{
> ++	struct ipv6hdr *ip6h = (*pskb)->nh.ipv6h;
> ++	const struct ip6t_HL_info *info = targinfo;
> ++	u_int16_t diffs[2];
> ++	int new_hl;
> ++
> ++	switch (info->mode) {
> ++		case IP6T_HL_SET:
> ++			new_hl = info->hop_limit;
> ++			break;
> ++		case IP6T_HL_INC:
> ++			new_hl = ip6h->hop_limit + info->hop_limit;
> ++			if (new_hl > 255)
> ++				new_hl = 255;
> ++			break;
> ++		case IP6T_HL_DEC:
> ++			new_hl = ip6h->hop_limit + info->hop_limit;
> ++			if (new_hl < 0)
> ++				new_hl = 0;
> ++			break;
> ++		default:
> ++			new_hl = ip6h->hop_limit;
> ++			break;
> ++	}
> ++
> ++	if (new_hl != ip6h->hop_limit) {
> ++		diffs[0] = htons(((unsigned)ip6h->hop_limit) << 
> 8) ^ 0xFFFF;
> ++		ip6h->hop_limit = new_hl;
> ++		diffs[1] = htons(((unsigned)ip6h->hop_limit) << 8);
> ++	}
> ++
> ++	return IP6T_CONTINUE;
> ++}
> ++
> ++static int ip6t_hl_checkentry(const char *tablename,
> ++		const struct ip6t_entry *e,
> ++		void *targinfo,
> ++		unsigned int targinfosize,
> ++		unsigned int hook_mask)
> ++{
> ++	struct ip6t_HL_info *info = targinfo;
> ++
> ++	if (targinfosize != IP6T_ALIGN(sizeof(struct ip6t_HL_info))) {
> ++		printk(KERN_WARNING "HL: targinfosize %u != %Zu\n",
> ++				targinfosize,
> ++				IP6T_ALIGN(sizeof(struct 
> ip6t_HL_info)));
> ++		return 0;
> ++	}
> ++
> ++	if (strcmp(tablename, "mangle")) {
> ++		printk(KERN_WARNING "HL: can only be called 
> from \"mangle\" table, not \"%s\"\n", tablename);
> ++		return 0;
> ++	}
> ++
> ++	if (info->mode > IP6T_HL_MAXMODE) {
> ++		printk(KERN_WARNING "HL: invalid or unknown Mode %u\n",
> ++			info->mode);
> ++		return 0;
> ++	}
> ++
> ++	if ((info->mode != IP6T_HL_SET) && (info->hop_limit == 0)) {
> ++		printk(KERN_WARNING "HL: increment/decrement 
> doesn't make sense with value 0\n");
> ++		return 0;
> ++	}
> ++
> ++	return 1;
> ++}
> ++
> ++static struct ip6t_target ip6t_HL = { { NULL, NULL }, "HL",
> ++	ip6t_hl_target, ip6t_hl_checkentry, NULL, THIS_MODULE };
> ++
> ++static int __init init(void)
> ++{
> ++	return ip6t_register_target(&ip6t_HL);
> ++}
> ++
> ++static void __exit fini(void)
> ++{
> ++	ip6t_unregister_target(&ip6t_HL);
> ++}
> ++
> ++module_init(init);
> ++module_exit(fini);
> diff -Nru 
> netfilter.orig/patch-o-matic/base/HL.patch.ipv6.config.in 
> netfilter/patch-o-matic/base/HL.patch.ipv6.config.in
> --- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.config.in	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/HL.patch.ipv6.config.in	
> 2002-12-16 18:32:27.000000000 +0100
> @@ -0,0 +1,4 @@
> +  dep_tristate '  Packet filtering' CONFIG_IP6_NF_FILTER 
> + $CONFIG_IP6_NF_IPTABLES  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
> +    dep_tristate '    HL target support' 
> CONFIG_IP6_NF_TARGET_HL $CONFIG_IP6_NF_FILTER
> +  fi
> diff -Nru 
> netfilter.orig/patch-o-matic/base/HL.patch.ipv6.configure.help
>  netfilter/patch-o-matic/base/HL.patch.ipv6.configure.help
> --- 
> netfilter.orig/patch-o-matic/base/HL.patch.ipv6.configu
> re.help	1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/HL.patch.ipv6.configure.help	
> 2002-12-16 18:02:32.000000000 +0100
> @@ -0,0 +1,8 @@
> +CONFIG_IP6_NF_TARGET_LOG
> +HL target support
> +CONFIG_IP6_NF_TARGET_HL
> +  This option adds a `HL' target, which allows you to modify 
> the value 
> +of
> +  IPv6 Hop Limit field.
> +
> +  If you want to compile it as a module, say M here and read  
> + <file:Documentation/modules.txt>.  If unsure, say `N'.
> diff -Nru 
> netfilter.orig/patch-o-matic/base/HL.patch.ipv6.help 
> netfilter/patch-o-matic/base/HL.patch.ipv6.help
> --- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.help	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/HL.patch.ipv6.help	
> 2002-12-16 18:23:09.000000000 +0100
> @@ -0,0 +1,10 @@
> +Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
> +Status: Works for me.
> +
> +This allows the user to set the IPv6 Hop Limit value on a 
> packet or to 
> +increment or decrement it by a given value.
> +
> +Example:
> +# ip6tables -t mangle -A OUTPUT -j HL --hl-inc 1
> +# ip6tables -t mangle -A INPUT -j HL --hl-eq 64
> +# ip6tables -t mangle -A OUTPUT -j HL --hl-dec 2
> diff -Nru 
> netfilter.orig/patch-o-matic/base/HL.patch.ipv6.makefile 
> netfilter/patch-o-matic/base/HL.patch.ipv6.makefile
> --- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.makefile	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/HL.patch.ipv6.makefile	
> 2002-12-16 18:10:45.000000000 +0100
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
> +obj-$(CONFIG_IP_NF_TARGET_HL) += ipt_HL.o
> diff -Nru netfilter.orig/patch-o-matic/base/hl.patch.ipv6 
> netfilter/patch-o-matic/base/hl.patch.ipv6
> --- netfilter.orig/patch-o-matic/base/hl.patch.ipv6	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/hl.patch.ipv6	
> 2002-12-16 18:05:19.000000000 +0100
> @@ -0,0 +1,104 @@
> +diff -Nru 
> linux-2.4.20/include/linux/netfilter_ipv6/ip6t_hl.h 
> linux.new/include/linux/netfilter_ipv6/ip6t_hl.h
> +--- linux-2.4.20/include/linux/netfilter_ipv6/ip6t_hl.h	
> 1970-01-01 01:00:00.000000000 +0100
> ++++ linux.new/include/linux/netfilter_ipv6/ip6t_hl.h	
> 2002-12-16 17:11:56.000000000 +0100
> +@@ -0,0 +1,22 @@
> ++/* ip6tables module for matching the Hop Limit value
> ++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
> ++ * Based on HW's ttl module */
> ++
> ++#ifndef _IP6T_HL_H
> ++#define _IP6T_HL_H
> ++
> ++enum {
> ++	IP6T_HL_EQ = 0,		/* equals */
> ++	IP6T_HL_NE,		/* not equals */
> ++	IP6T_HL_LT,		/* less than */
> ++	IP6T_HL_GT,		/* greater than */
> ++};
> ++
> ++
> ++struct ip6t_hl_info {
> ++	u_int8_t	mode;
> ++	u_int8_t	hop_limit;
> ++};
> ++
> ++
> ++#endif
> +diff -Nru linux-2.4.20/net/ipv6/netfilter/ip6t_hl.c 
> linux.new/net/ipv6/netfilter/ip6t_hl.c
> +--- linux-2.4.20/net/ipv6/netfilter/ip6t_hl.c	
> 1970-01-01 01:00:00.000000000 +0100
> ++++ linux.new/net/ipv6/netfilter/ip6t_hl.c	2002-12-16 
> 17:09:53.000000000 +0100
> +@@ -0,0 +1,74 @@
> ++/*
> ++ * Hop Limit matching module
> ++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
> ++ * Based on HW's ttl module
> ++ *
> ++ * This software is distributed under the terms  GNU GPL
> ++ */
> ++
> ++#include <linux/module.h>
> ++#include <linux/skbuff.h>
> ++
> ++#include <linux/netfilter_ipv6/ip6t_hl.h>
> ++#include <linux/netfilter_ipv6/ip6_tables.h>
> ++
> ++MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>"); 
> ++MODULE_DESCRIPTION("IP tables Hop Limit matching module"); 
> ++MODULE_LICENSE("GPL");
> ++
> ++static int match(const struct sk_buff *skb, const struct 
> net_device *in,
> ++		 const struct net_device *out, const void *matchinfo,
> ++		 int offset, const void *hdr, u_int16_t datalen,
> ++		 int *hotdrop)
> ++{
> ++	const struct ip6t_hl_info *info = matchinfo;
> ++	const struct ipv6hdr *ip6h = skb->nh.ipv6h;
> ++
> ++	switch (info->mode) {
> ++		case IP6T_HL_EQ:
> ++			return (ip6h->hop_limit == info->hop_limit);
> ++			break;
> ++		case IP6T_HL_NE:
> ++			return (!(ip6h->hop_limit == info->hop_limit));
> ++			break;
> ++		case IP6T_HL_LT:
> ++			return (ip6h->hop_limit < info->hop_limit);
> ++			break;
> ++		case IP6T_HL_GT:
> ++			return (ip6h->hop_limit > info->hop_limit);
> ++			break;
> ++		default:
> ++			printk(KERN_WARNING "ip6t_hl: unknown 
> mode %d\n",
> ++				info->mode);
> ++			return 0;
> ++	}
> ++
> ++	return 0;
> ++}
> ++
> ++static int checkentry(const char *tablename, const struct 
> ip6t_ip *ip,
> ++		      void *matchinfo, unsigned int matchsize,
> ++		      unsigned int hook_mask)
> ++{
> ++	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_hl_info)))
> ++		return 0;
> ++
> ++	return 1;
> ++}
> ++
> ++static struct ip6t_match hl_match = { { NULL, NULL }, "hl", &match,
> ++		&checkentry, NULL, THIS_MODULE };
> ++
> ++static int __init init(void)
> ++{
> ++	return ip6t_register_match(&hl_match);
> ++}
> ++
> ++static void __exit fini(void)
> ++{
> ++	ip6t_unregister_match(&hl_match);
> ++
> ++}
> ++
> ++module_init(init);
> ++module_exit(fini);
> diff -Nru 
> netfilter.orig/patch-o-matic/base/hl.patch.ipv6.config.in 
> netfilter/patch-o-matic/base/hl.patch.ipv6.config.in
> --- netfilter.orig/patch-o-matic/base/hl.patch.ipv6.config.in	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/hl.patch.ipv6.config.in	
> 2002-12-16 18:08:55.000000000 +0100
> @@ -0,0 +1,2 @@
> +  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC 
> + $CONFIG_IP6_NF_IPTABLES  dep_tristate '  HL match support' 
> + CONFIG_IP6_NF_MATCH_HL $CONFIG_IP6_NF_IPTABLES
> diff -Nru 
> netfilter.orig/patch-o-matic/base/hl.patch.ipv6.configure.help
>  netfilter/patch-o-matic/base/hl.patch.ipv6.configure.help
> --- 
> netfilter.orig/patch-o-matic/base/hl.patch.ipv6.configu
> re.help	1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/hl.patch.ipv6.configure.help	
> 2002-12-16 18:04:01.000000000 +0100
> @@ -0,0 +1,8 @@
> +CONFIG_IP6_NF_TARGET_LOG
> +HL match support
> +CONFIG_IP6_NF_MATCH_HL
> +  This option adds a `hl' match, which allows you match the value of
> +  the IPv6 Hop Limit field.
> +
> +  If you want to compile it as a module, say M here and read  
> + <file:Documentation/modules.txt>.  If unsure, say `N'.
> diff -Nru 
> netfilter.orig/patch-o-matic/base/hl.patch.ipv6.help 
> netfilter/patch-o-matic/base/hl.patch.ipv6.help
> --- netfilter.orig/patch-o-matic/base/hl.patch.ipv6.help	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/hl.patch.ipv6.help	
> 2002-12-16 18:22:25.000000000 +0100
> @@ -0,0 +1,9 @@
> +Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
> +Status: Works for me.
> +
> +This allows the user to match the IPv6 Hop Limit value on a packet.
> +
> +Examples:
> +# ip6tables -A INPUT -m hl --hl-eq 63 -j LOG --log-prefix "Blah: " # 
> +ip6tables -A FORWARD -m hl --hl-gt 64 -j DROP # ip6tables -A 
> OUTPUT -m 
> +hl --hl-lt 64 -j ACCEPT
> diff -Nru 
> netfilter.orig/patch-o-matic/base/hl.patch.ipv6.makefile 
> netfilter/patch-o-matic/base/hl.patch.ipv6.makefile
> --- netfilter.orig/patch-o-matic/base/hl.patch.ipv6.makefile	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/patch-o-matic/base/hl.patch.ipv6.makefile	
> 2002-12-16 18:11:03.000000000 +0100
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
> +obj-$(CONFIG_IP_NF_MATCH_HL) += ipt_hl.o
> diff -Nru netfilter.orig/userspace/extensions/Makefile 
> netfilter/userspace/extensions/Makefile
> --- netfilter.orig/userspace/extensions/Makefile	
> 2002-12-09 10:31:23.000000000 +0100
> +++ netfilter/userspace/extensions/Makefile	2002-12-16 
> 16:57:44.000000000 +0100
> @@ -1,7 +1,7 @@
>  #! /usr/bin/make
> 
>  PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length 
> limit mac mark multiport owner pkttype standard state tcp 
> tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE 
> MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS ULOG 
> -PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport 
> owner standard tcp udp LOG MARK
> +PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner 
> +standard tcp udp LOG MARK hl HL
> 
>  # The following may not be present, but compile them anyway. 
>  PF_EXT_SLIB+=TTL iplimit diff -Nru 
> netfilter.orig/userspace/extensions/libip6t_HL.c 
> netfilter/userspace/extensions/libip6t_HL.c
> --- netfilter.orig/userspace/extensions/libip6t_HL.c	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/userspace/extensions/libip6t_HL.c	
> 2002-12-16 17:05:57.000000000 +0100
> @@ -0,0 +1,164 @@
> +/*
> + * IPv6 Hop Limit Target module
> + * Maciej Soltysiak <solt@dns.toxicfilms.tv>
> + * Based on HW's ttl target
> + * This program is distributed under the terms of GNU GPL
> + */
> +
> +#include <stdio.h>
> +#include <string.h>
> +#include <stdlib.h>
> +#include <getopt.h>
> +#include <ip6tables.h>
> +
> +#include <linux/netfilter_ipv6/ip6_tables.h>
> +#include <linux/netfilter_ipv6/ip6t_HL.h>
> +
> +#define IP6T_HL_USED	1
> +
> +static void init(struct ip6t_entry_target *t, unsigned int 
> *nfcache) {
> +}
> +
> +static void help(void)
> +{
> +	printf(
> +"HL target v%s options\n"
> +"  --hl-set value		Set HL to <value>\n"
> +"  --hl-dec value		Decrement HL by <value>\n"
> +"  --hl-inc value		Increment HL by <value>\n"
> +, IPTABLES_VERSION);
> +}
> +
> +static int parse(int c, char **argv, int invert, unsigned int *flags,
> +		const struct ip6t_entry *entry,
> +		struct ip6t_entry_target **target)
> +{
> +	struct ip6t_HL_info *info = (struct ip6t_HL_info *) 
> (*target)->data;
> +	u_int8_t value;
> +
> +	if (*flags & IP6T_HL_USED) {
> +		exit_error(PARAMETER_PROBLEM,
> +				"Can't specify HL option twice");
> +	}
> +
> +	if (!optarg)
> +		exit_error(PARAMETER_PROBLEM,
> +				"HL: You must specify a value");
> +
> +	if (check_inverse(optarg, &invert, NULL, 0))
> +		exit_error(PARAMETER_PROBLEM,
> +				"HL: unexpected `!'");
> +
> +	value = atoi(optarg);
> +
> +	switch (c) {
> +
> +		case '1':
> +			info->mode = IP6T_HL_SET;
> +			break;
> +
> +		case '2':
> +			if (value == 0) {
> +				exit_error(PARAMETER_PROBLEM,
> +					"HL: decreasing by 0?");
> +			}
> +
> +			info->mode = IP6T_HL_DEC;
> +			break;
> +
> +		case '3':
> +			if (value == 0) {
> +				exit_error(PARAMETER_PROBLEM,
> +					"HL: increasing by 0?");
> +			}
> +
> +			info->mode = IP6T_HL_INC;
> +			break;
> +
> +		default:
> +			return 0;
> +
> +	}
> +
> +	info->hop_limit = value;
> +	*flags |= IP6T_HL_USED;
> +
> +	return 1;
> +}
> +
> +static void final_check(unsigned int flags)
> +{
> +	if (!(flags & IP6T_HL_USED))
> +		exit_error(PARAMETER_PROBLEM,
> +				"HL: You must specify an action");
> +}
> +
> +static void save(const struct ip6t_ip6 *ip,
> +		const struct ip6t_entry_target *target)
> +{
> +	const struct ip6t_HL_info *info =
> +		(struct ip6t_HL_info *) target->data;
> +
> +	switch (info->mode) {
> +		case IP6T_HL_SET:
> +			printf("--hl-set ");
> +			break;
> +		case IP6T_HL_DEC:
> +			printf("--hl-dec ");
> +			break;
> +
> +		case IP6T_HL_INC:
> +			printf("--hl-inc ");
> +			break;
> +	}
> +	printf("%u ", info->hop_limit);
> +}
> +
> +static void print(const struct ip6t_ip6 *ip,
> +		const struct ip6t_entry_target *target, int numeric)
> +{
> +	const struct ip6t_HL_info *info =
> +		(struct ip6t_HL_info *) target->data;
> +
> +	printf("HL ");
> +	switch (info->mode) {
> +		case IP6T_HL_SET:
> +			printf("set to ");
> +			break;
> +		case IP6T_HL_DEC:
> +			printf("decrement by ");
> +			break;
> +		case IP6T_HL_INC:
> +			printf("increment by ");
> +			break;
> +	}
> +	printf("%u ", info->hop_limit);
> +}
> +
> +static struct option opts[] = {
> +	{ "hl-set", 1, 0, '1' },
> +	{ "hl-dec", 1, 0, '2' },
> +	{ "hl-inc", 1, 0, '3' },
> +	{ 0 }
> +};
> +
> +static
> +struct ip6tables_target HL = { NULL,
> +	"HL",
> +	IPTABLES_VERSION,
> +	IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
> +	IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
> +	&help,
> +	&init,
> +	&parse,
> +	&final_check,
> +	&print,
> +	&save,
> +	opts
> +};
> +
> +void _init(void)
> +{
> +	register_target6(&HL);
> +}
> diff -Nru netfilter.orig/userspace/extensions/libip6t_hl.c 
> netfilter/userspace/extensions/libip6t_hl.c
> --- netfilter.orig/userspace/extensions/libip6t_hl.c	
> 1970-01-01 01:00:00.000000000 +0100
> +++ netfilter/userspace/extensions/libip6t_hl.c	
> 2002-12-16 17:05:14.000000000 +0100
> @@ -0,0 +1,177 @@
> +/*
> + * IPv6 Hop Limit matching module
> + * Maciej Soltysiak <solt@dns.toxicfilms.tv>
> + * Based on HW's ttl match
> + * This program is released under the terms of GNU GPL
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <getopt.h>
> +#include <ip6tables.h>
> +
> +#include <linux/netfilter_ipv6/ip6_tables.h>
> +#include <linux/netfilter_ipv6/ip6t_hl.h>
> +
> +static void help(void)
> +{
> +	printf(
> +"HL match v%s options:\n"
> +"  --hl-eq value	Match hop limit value\n"
> +"  --hl-lt value	Match HL < value\n"
> +"  --hl-gt value	Match HL > value\n"
> +, IPTABLES_VERSION);
> +}
> +
> +static void init(struct ip6t_entry_match *m, unsigned int *nfcache) {
> +	/* caching not yet implemented */
> +	*nfcache |= NFC_UNKNOWN;
> +}
> +
> +static int parse(int c, char **argv, int invert, unsigned int *flags,
> +		const struct ip6t_entry *entry, unsigned int *nfcache,
> +		struct ip6t_entry_match **match)
> +{
> +	struct ip6t_hl_info *info = (struct ip6t_hl_info *) 
> (*match)->data;
> +	u_int8_t value;
> +
> +	check_inverse(optarg, &invert, &optind, 0);
> +	value = atoi(argv[optind-1]);
> +
> +	if (*flags)
> +		exit_error(PARAMETER_PROBLEM,
> +				"Can't specify HL option twice");
> +
> +	if (!optarg)
> +		exit_error(PARAMETER_PROBLEM,
> +				"hl: You must specify a value");
> +	switch (c) {
> +		case '2':
> +			if (invert)
> +				info->mode = IP6T_HL_NE;
> +			else
> +				info->mode = IP6T_HL_EQ;
> +
> +			/* is 0 allowed? */
> +			info->hop_limit = value;
> +			*flags = 1;
> +
> +			break;
> +		case '3':
> +			if (invert)
> +				exit_error(PARAMETER_PROBLEM,
> +						"hl: unexpected `!'");
> +
> +			info->mode = IP6T_HL_LT;
> +			info->hop_limit = value;
> +			*flags = 1;
> +
> +			break;
> +		case '4':
> +			if (invert)
> +				exit_error(PARAMETER_PROBLEM,
> +						"hl: unexpected `!'");
> +
> +			info->mode = IP6T_HL_GT;
> +			info->hop_limit = value;
> +			*flags = 1;
> +
> +			break;
> +		default:
> +			return 0;
> +
> +	}
> +
> +	return 1;
> +}
> +
> +static void final_check(unsigned int flags)
> +{
> +	if (!flags)
> +		exit_error(PARAMETER_PROBLEM,
> +			"HL match: You must specify one of "
> +			"`--hl-eq', `--hl-lt', `--hl-gt");
> +}
> +
> +static void print(const struct ip6t_ip6 *ip,
> +		const struct ip6t_entry_match *match,
> +		int numeric)
> +{
> +	const struct ip6t_hl_info *info =
> +		(struct ip6t_hl_info *) match->data;
> +
> +	printf("HL match ");
> +	switch (info->mode) {
> +		case IP6T_HL_EQ:
> +			printf("HL == ");
> +			break;
> +		case IP6T_HL_NE:
> +			printf("HL != ");
> +			break;
> +		case IP6T_HL_LT:
> +			printf("HL < ");
> +			break;
> +		case IP6T_HL_GT:
> +			printf("HL > ");
> +			break;
> +	}
> +	printf("%u ", info->hop_limit);
> +}
> +
> +static void save(const struct ip6t_ip6 *ip,
> +		const struct ip6t_entry_match *match)
> +{
> +	const struct ip6t_hl_info *info =
> +		(struct ip6t_hl_info *) match->data;
> +
> +	switch (info->mode) {
> +		case IP6T_HL_EQ:
> +			printf("--hl-eq ");
> +			break;
> +		case IP6T_HL_NE:
> +			printf("! --hl-eq ");
> +			break;
> +		case IP6T_HL_LT:
> +			printf("--hl-lt ");
> +			break;
> +		case IP6T_HL_GT:
> +			printf("--hl-gt ");
> +			break;
> +		default:
> +			/* error */
> +			break;
> +	}
> +	printf("%u ", info->hop_limit);
> +}
> +
> +static struct option opts[] = {
> +	{ "hl", 1, 0, '2' },
> +	{ "hl-eq", 1, 0, '2'},
> +	{ "hl-lt", 1, 0, '3'},
> +	{ "hl-gt", 1, 0, '4'},
> +	{ 0 }
> +};
> +
> +static
> +struct ip6tables_match hl = {
> +	NULL,
> +	"hl",
> +	IPTABLES_VERSION,
> +	IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
> +	IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
> +	&help,
> +	&init,
> +	&parse,
> +	&final_check,
> +	&print,
> +	&save,
> +	opts
> +};
> +
> +
> +void _init(void)
> +{
> +	register_match6(&hl);
> +}
> diff -Nru 
> netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_HL.
> h netfilter/userspace/include/linux/netfilter_ipv6/ip6t_HL.h
> --- 
> netfilter.orig/userspace/include/linux/netfilter_ipv6/ip
> 6t_HL.h	1970-01-01 01:00:00.000000000 +0100
> +++ 
> netfilter/userspace/include/linux/netfilter_ipv6/ip6t_HL.h	
> 2002-12-16 17:12:29.000000000 +0100
> @@ -0,0 +1,22 @@
> +/* Hop Limit modification module for ip6tables
> + * Maciej Soltysiak <solt@dns.toxicfilms.tv> */
> + * Based on HW's TTL module */
> +
> +#ifndef _IP6T_HL_H
> +#define _IP6T_HL_H
> +
> +enum {
> +	IP6T_HL_SET = 0,
> +	IP6T_HL_INC,
> +	IP6T_HL_DEC
> +};
> +
> +#define IP6T_HL_MAXMODE	IP6T_HL_DEC
> +
> +struct ip6t_HL_info {
> +	u_int8_t	mode;
> +	u_int8_t	hop_limit;
> +};
> +
> +
> +#endif
> diff -Nru 
> netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_hl.
> h netfilter/userspace/include/linux/netfilter_ipv6/ip6t_hl.h
> --- 
> netfilter.orig/userspace/include/linux/netfilter_ipv6/ip
> 6t_hl.h	1970-01-01 01:00:00.000000000 +0100
> +++ 
> netfilter/userspace/include/linux/netfilter_ipv6/ip6t_hl.h	
> 2002-12-16 17:11:56.000000000 +0100
> @@ -0,0 +1,22 @@
> +/* ip6tables module for matching the Hop Limit value
> + * Maciej Soltysiak <solt@dns.toxicfilms.tv>
> + * Based on HW's ttl module */
> +
> +#ifndef _IP6T_HL_H
> +#define _IP6T_HL_H
> +
> +enum {
> +	IP6T_HL_EQ = 0,		/* equals */
> +	IP6T_HL_NE,		/* not equals */
> +	IP6T_HL_LT,		/* less than */
> +	IP6T_HL_GT,		/* greater than */
> +};
> +
> +
> +struct ip6t_hl_info {
> +	u_int8_t	mode;
> +	u_int8_t	hop_limit;
> +};
> +
> +
> +#endif
> 
