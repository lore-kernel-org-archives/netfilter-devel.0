From: Manu <manuprivat@gmx.de>
Subject: Add new target in mangle table
Date: Fri, 11 Apr 2008 09:45:03 +0200
Message-ID: <1207899903.8402.31.camel@mscheub-lapi.Simpsons>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-EkI7qRR5FUvVx3bIbw0+"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50105 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757254AbYDKHoa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:44:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-EkI7qRR5FUvVx3bIbw0+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi developers,

I encountered difficulties during integrating a new target in mangle
table (iptables-1.4.0 (from www.netfilter.org), kernel-2.6.23 (from
www.kernel.org)). 
I have a master from iptables-1.2.9 and kernel-2.6.3. But there were too
many differences and changes be made.
The idea behind to add the target is, that a user who has a fix-ip entry
in his network settings can be handled from a gateway, for which the new
targets should be implemented. for example:

# iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
--to-source 10.0.19.2
iptables: Target problem

-> dmesg shows:
...
SADDR: targinfosize 3290890384 != 4
...

There should be a user request management in the gateway, that nobody
should care about the network-settings. It should doesn't matter if a
user has dhcp activated or a fix IP entry.
It works with the iptables-1.2.9 and kernel-2.6.3:
Code posted:

kernel-sources 2.6.3:
ipt_SADDR.h
ipt_SADDR.c
iptables-sources 1.2.9:
libipt_SADDR.c

kernel-sources 2.6.23:
ipt_SADDR.h
ipt_SADDR.c
iptables-sources 1.4.0:
libipt_SADDR.c

nearly the same for DADDR-target! I have attached all the important
files - I think!?

Any help would be greatly appreciated!
Thanks in advance.

Regards
Manu


kernel-sources 2.6.3:
ipt_SADDR.h:
------------------------------
#ifndef _IPT_SADDR_H_target
#define _IPT_SADDR_H_target

struct ipt_saddr_target_info {
        u_int32_t saddr;
};

#endif /*_IPT_SADDR_H_target*/

------------------------------

ipt_SADDR.c:
------------------------------
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <net/tcp.h>
#include <net/checksum.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Uli Konrad");
MODULE_DESCRIPTION("iptables IP Source Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const void *targinfo,
       void *userinfo)
{
        const struct ipt_saddr_target_info *saddrinfo = targinfo;

        if ((*pskb)->nh.iph->saddr != saddrinfo->saddr) {
                u_int32_t diffs[2];

                if (!skb_ip_make_writable(pskb, sizeof(struct iphdr)))
                        return NF_DROP;

                diffs[0] = ~((*pskb)->nh.iph->saddr);
                (*pskb)->nh.iph->saddr = saddrinfo->saddr;
                diffs[1] = saddrinfo->saddr;

                (*pskb)->nh.iph->check
                        = csum_fold(csum_partial((char *)diffs,
                                                 sizeof(diffs),
                                                 (*pskb)->nh.iph->check
                                                 ^0xFFFF));

        if ((*pskb)->nh.iph->protocol == 0x06) {
                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

                iph = (*pskb)->nh.iph;
                tcph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl*4;
                tcph->check = 0;
                tcph->check = tcp_v4_check(tcph, datalen, iph->saddr,
iph->daddr,
                                   csum_partial((char *)tcph, datalen,
0));
        }
        if ((*pskb)->nh.iph->protocol == 0x11) {
                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

                iph = (*pskb)->nh.iph;
                udph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                udph->check = 0;
                udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char
*)udph,
                                                             datalen,
0));
        }


                (*pskb)->nfcache |= NFC_ALTERED;
        }

        return IPT_CONTINUE;
}

static int
checkentry(const char *tablename,
           const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
        if (targinfosize != IPT_ALIGN(sizeof(struct
ipt_saddr_target_info))) {
                printk(KERN_WARNING "SADDR: targinfosize %u != %Zu\n",
                       targinfosize,
                       IPT_ALIGN(sizeof(struct ipt_saddr_target_info)));
                return 0;
        }

        if (strcmp(tablename, "mangle") != 0) {
                printk(KERN_WARNING "SADDR: can only be called from
\"mangle\" table, not \"%s\"\n", tablename);
                return 0;
        }

        return 1;
}

static struct ipt_target ipt_saddr_reg = {
        .name           = "SADDR",
        .target         = target,
        .checkentry     = checkentry,
        .me             = THIS_MODULE,
};

static int __init init(void)
{
        return ipt_register_target(&ipt_saddr_reg);
}

static void __exit fini(void)
{
        ipt_unregister_target(&ipt_saddr_reg);
}

module_init(init);
module_exit(fini);

----------------------------

iptables-1.2.9:
libipt_SADDR.c: 
----------------------------
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

struct saddrinfo {
        struct ipt_entry_target t;
        struct ipt_saddr_target_info saddr;
};

/* Function which prints out usage message. */
static void
help(void)
{
        printf(
"SADDR target v%s options:\n"
"  --to-source ip-address       set source address\n",
IPTABLES_VERSION);
}

static struct option opts[] = {
        { "to-source", 1, 0, '1' },
        { 0 }
};

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache)
{
}

static void
parse_saddr(const unsigned char *s, struct ipt_saddr_target_info *info)
{
        struct in_addr *ip;

        ip = dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
s);

        info->saddr = ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
        struct ipt_saddr_target_info *saddrinfo
                = (struct ipt_saddr_target_info *)(*target)->data;

        switch (c) {
        case '1':
                if (*flags)
                        exit_error(PARAMETER_PROBLEM,
                                   "SADDR target: Cant specify
--to-source twice");
                parse_saddr(optarg, saddrinfo);
                *flags = 1;
                break;

        default:
                return 0;
        }

        return 1;
}

static void
final_check(unsigned int flags)
{
        if (!flags)
                exit_error(PARAMETER_PROBLEM,
                           "SADDR target: Parameter --to-source is
required");
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
        struct in_addr a;
        const struct ipt_saddr_target_info *saddrinfo =
                (const struct ipt_saddr_target_info *)target->data;
        a.s_addr = saddrinfo->saddr;
        printf("SADDR set %s ", addr_to_dotted(&a));
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
        struct in_addr a;
        const struct ipt_saddr_target_info *saddrinfo =
                (const struct ipt_saddr_target_info *)target->data;

        a.s_addr = saddrinfo->saddr;
        printf("--to-source %s ", addr_to_dotted(&a));
}

static
struct iptables_target saddr
= { NULL,
    "SADDR",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
    IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
        register_target(&saddr);
}

--------------------------------



kernel-sources 2.6.23:
ipt_SADDR.h
--------------------------------
#ifndef _IPT_SADDR_H
#define _IPT_SADDR_H

struct ipt_saddr_target_info {
        u_int8_t saddr;
};

#endif /*_IPT_SADDR_H*/
-------------------------------

ipt_SADDR.c
-------------------------------
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/in.h>
#include <linux/netfilter.h>
#include <net/checksum.h>

#include <linux/netfilter/x_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>
#include <linux/netfilter_ipv4/ip_tables.h>

#define NFC_ALTERED 0x8000

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Manuel Scheub");
MODULE_DESCRIPTION("iptables IP Source Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const struct xt_target *target,
       const void *targinfo)
{
        const struct ipt_saddr_target_info *saddrinfo = targinfo;
        struct iphdr *iph = ip_hdr(*pskb);

        if (iph->saddr != saddrinfo->saddr) {
                u_int32_t diffs[2];

                if (!skb_make_writable(pskb, sizeof(struct iphdr)))
                        return NF_DROP;

                diffs[0] = ~(iph->saddr);
                iph->saddr = saddrinfo->saddr;
                diffs[1] = saddrinfo->saddr;

                iph->check = csum_fold(csum_partial((char *)diffs,
                                                 sizeof(diffs),
                                                 iph->check
                                                 ^0xFFFF));

        if (iph->protocol == 0x06) {
//                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

//                iph = (*pskb)->nh.iph;
                tcph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                tcph->check = 0;
                tcph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_TCP,
                                                csum_partial((char
*)tcph,
                                                             datalen,
0));

        }

        if (iph->protocol == 0x11) {
//                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

//                iph = (*pskb)->nh.iph;
                udph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                udph->check = 0;
                udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char
*)udph,
                                                             datalen,
0));
        }

//              (*pskb)->nfcache |= NFC_ALTERED;
        }

        return XT_CONTINUE;
}

bool
checkentry(const char *tablename,
           const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
        if (targinfosize != IPT_ALIGN(sizeof(struct
ipt_saddr_target_info))) {
                printk(KERN_WARNING "SADDR: targinfosize %u != %Zu\n",
                       targinfosize,
                       IPT_ALIGN(sizeof(struct ipt_saddr_target_info)));
                return 0;
        }

        if (strcmp(tablename, "mangle") != 0) {
                printk(KERN_WARNING "SADDR: can only be called from
\"mangle\" table, not \"%s\"\n", tablename);
                return 0;
        }

        return 1;
}

static struct xt_target ipt_saddr_reg __read_mostly = {
        .name           = "SADDR",
        .family         = AF_INET,
        .target         = target,
        .targetsize     = sizeof(struct ipt_saddr_target_info),
        .table          = "mangle",
        .checkentry     = checkentry,
        .me             = THIS_MODULE,
};

static int __init ipt_saddr_init(void)
{
        return xt_register_target(&ipt_saddr_reg);
}

static void __exit ipt_saddr_fini(void)
{
        xt_unregister_target(&ipt_saddr_reg);
}

module_init(ipt_saddr_init);
module_exit(ipt_saddr_fini);
-----------------------------------

iptables-sources 1.4.0
libipt_SADDR.c:
----------------------------------#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

struct saddrinfo {
        struct xt_entry_target t;
        struct ipt_saddr_target_info saddr;
};

/* Function which prints out usage message. */
static void SADDR_help(void)
{
        printf(
"SADDR target v%s options:\n"
"  --to-source ip-address       set source address\n",
IPTABLES_VERSION);
}

static const struct option SADDR_opts[] = {
        { "to-source", 1, NULL, '1' },
        { 0 }
};

static void
parse_saddr(const char *s, struct ipt_saddr_target_info *info)
{
        struct in_addr *ip;

        ip = dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
s);

        info->saddr = ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int SADDR_parse(int c, char **argv, int invert, unsigned int
*flags,
                     const void *entry, struct xt_entry_target **target)
{
        struct ipt_saddr_target_info *saddrinfo
                = (struct ipt_saddr_target_info *)(*target)->data;

        switch (c) {
        case '1':
                if (*flags)
                        exit_error(PARAMETER_PROBLEM,
                                   "SADDR target: Cant specify
--to-source twice");
                parse_saddr(optarg, saddrinfo);
                *flags = 1;
                break;

        default:
                return 0;
        }

        return 1;
}

static void SADDR_check(unsigned int flags)
{
        if (!flags)
                exit_error(PARAMETER_PROBLEM,
                           "SADDR target: Parameter --to-source is
required");
}

static void
print_saddr(u_int8_t saddr, int numeric)
{
        unsigned int i;

        if (!numeric) {
                for (i = 0; i<sizeof(SADDR_values)/sizeof(struct
SADDR_value); i++)
                        if (SADDR_values[i].SADDR == saddr) {
                                printf("%s ", SADDR_values[i].name);
                                return;
                        }
        }
        printf("0x%02x ", saddr);
}

/* Prints out the targinfo. */
static void SADDR_print(const void *ip, const struct xt_entry_target
*target,
                      int numeric)
{
        const struct ipt_saddr_target_info *saddrinfo =
                (const struct ipt_saddr_target_info *)target->data;
        printf("SADDR set ");
        print_saddr(saddrinfo->saddr, numeric);
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void SADDR_save(const void *ip, const struct xt_entry_target
*target)
{
        const struct ipt_saddr_target_info *saddrinfo =
                (const struct ipt_saddr_target_info *)target->data;

        printf("--to-source 0x%02x ", saddrinfo->saddr);
}

static struct iptables_target saddr_target = {
        .name           = "SADDR",
        .version        = IPTABLES_VERSION,
        .size           = IPT_ALIGN(sizeof(struct
ipt_saddr_target_info)),
        .userspacesize  = IPT_ALIGN(sizeof(struct
ipt_saddr_target_info)),
        .help           = SADDR_help,
        .parse          = SADDR_parse,
        .final_check    = SADDR_check,
        .print          = SADDR_print,
        .save           = SADDR_save,
        .extra_opts     = SADDR_opts,
};

void _init(void)
{
        register_target(&saddr_target);
}
----------------------------------------




--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_DADDR_2.6.3.c
Content-Type: text/x-csrc; name=ipt_DADDR_2.6.3.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* This is a module which is used for setting the DADDR field of a packet. */

/* (C) 1999-2001 Paul `Rusty' Russell
 * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <net/tcp.h>
#include <net/checksum.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_DADDR.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Uli Konrad");
MODULE_DESCRIPTION("iptables IP Destination Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const void *targinfo,
       void *userinfo)
{
	const struct ipt_daddr_target_info *daddrinfo = targinfo;

	if ((*pskb)->nh.iph->daddr != daddrinfo->daddr) {
		u_int32_t diffs[2];

		if (!skb_ip_make_writable(pskb, sizeof(struct iphdr)))
			return NF_DROP;

		diffs[0] = ~((*pskb)->nh.iph->daddr);
		(*pskb)->nh.iph->daddr = daddrinfo->daddr;
		diffs[1] = daddrinfo->daddr;

		(*pskb)->nh.iph->check
			= csum_fold(csum_partial((char *)diffs,
						 sizeof(diffs),
						 (*pskb)->nh.iph->check
						 ^0xFFFF));

        if ((*pskb)->nh.iph->protocol == 0x06) {
                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

                iph = (*pskb)->nh.iph;
                tcph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl*4;
                tcph->check = 0;
                tcph->check = tcp_v4_check(tcph, datalen, iph->saddr, iph->daddr,
                                   csum_partial((char *)tcph, datalen, 0));
        }
        if ((*pskb)->nh.iph->protocol == 0x11) {
                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

                iph = (*pskb)->nh.iph;
                udph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                udph->check = 0;
                udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char *)udph,
                                                             datalen, 0));
        }


		(*pskb)->nfcache |= NFC_ALTERED;
	}

	return IPT_CONTINUE;
}

static int
checkentry(const char *tablename,
	   const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_daddr_target_info))) {
		printk(KERN_WARNING "DADDR: targinfosize %u != %Zu\n",
		       targinfosize,
		       IPT_ALIGN(sizeof(struct ipt_daddr_target_info)));
		return 0;
	}

	if (strcmp(tablename, "mangle") != 0) {
		printk(KERN_WARNING "DADDR: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
		return 0;
	}

	return 1;
}

static struct ipt_target ipt_daddr_reg = {
	.name		= "DADDR",
	.target		= target,
	.checkentry	= checkentry,
	.me		= THIS_MODULE,
};

static int __init init(void)
{
	return ipt_register_target(&ipt_daddr_reg);
}

static void __exit fini(void)
{
	ipt_unregister_target(&ipt_daddr_reg);
}

module_init(init);
module_exit(fini);

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_DADDR_2.6.3.h
Content-Type: text/x-chdr; name=ipt_DADDR_2.6.3.h; charset=UTF-8
Content-Transfer-Encoding: 7bit

#ifndef _IPT_DADDR_H_target
#define _IPT_DADDR_H_target

struct ipt_daddr_target_info {
	u_int32_t daddr;
};

#endif /*_IPT_DADDR_H_target*/

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_DADDR_2.6.23.c
Content-Type: text/x-csrc; name=ipt_DADDR_2.6.23.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* This is a module which is used for setting the DADDR field of a packet. */

/* (C) 1999-2001 Paul `Rusty' Russell
 * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/in.h>
#include <linux/netfilter.h>
#include <net/checksum.h>

#include <linux/netfilter/x_tables.h>
#include <linux/netfilter_ipv4/ipt_DADDR.h>
#include <linux/netfilter_ipv4/ip_tables.h>

#define NFC_ALTERED 0x8000

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Manuel Scheub");
MODULE_DESCRIPTION("iptables IP Destination Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const struct xt_target *target,
       const void *targinfo)
{
	const struct ipt_daddr_target_info *daddrinfo = targinfo;
	struct iphdr *iph = ip_hdr(*pskb);

        if (iph->daddr != daddrinfo->daddr) { 
                u_int32_t diffs[2];

                if (!skb_make_writable(pskb, sizeof(struct iphdr)))
                        return NF_DROP;

                diffs[0] = ~(iph->daddr);
                iph->daddr = daddrinfo->daddr;
                diffs[1] = daddrinfo->daddr;

                iph->check = csum_fold(csum_partial((char *)diffs,
                                                 sizeof(diffs),
                                                 iph->check
                                                 ^0xFFFF));

	if (iph->protocol == 0x06) {
//                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

//                iph = (*pskb)->nh.iph;
                tcph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                tcph->check = 0;
		tcph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_TCP,
						csum_partial((char *)tcph,
                                                             datalen, 0));

//                tcph->check = tcp_v4_check( datalen, 
//					iph->saddr, 
//					iph->daddr,
//                                   	csum_partial((char *)tcph, 
//						datalen, 0));
        }

	if (iph->protocol == 0x11) {
//                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

//                iph = (*pskb)->nh.iph;
                udph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                udph->check = 0;
                udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char *)udph,
                                                             datalen, 0));
        }
                
//		(*pskb)->nfcache |= NFC_ALTERED;
        }

        return XT_CONTINUE;
}

static bool
checkentry(const char *tablename,
           const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
        if (targinfosize != IPT_ALIGN(sizeof(struct ipt_daddr_target_info))) {
                printk(KERN_WARNING "DADDR: targinfosize %u != %Zu\n",
                       targinfosize,
                       IPT_ALIGN(sizeof(struct ipt_daddr_target_info)));
                return 0;
        }

        if (strcmp(tablename, "mangle") != 0) {
                printk(KERN_WARNING "DADDR: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
                return 0;
        }

        return 1;
}

static struct xt_target ipt_daddr_reg __read_mostly = {
	.name		= "DADDR",
	.family		= AF_INET,
	.target		= target,
	.targetsize	= sizeof(struct ipt_daddr_target_info),
	.table		= "mangle",
	.checkentry	= checkentry,
	.me		= THIS_MODULE,
};

static int __init ipt_daddr_init(void)
{
	return xt_register_target(&ipt_daddr_reg);
}

static void __exit ipt_daddr_fini(void)
{
	xt_unregister_target(&ipt_daddr_reg);
}

module_init(ipt_daddr_init);
module_exit(ipt_daddr_fini);

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_DADDR_2.6.23.h
Content-Type: text/x-chdr; name=ipt_DADDR_2.6.23.h; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* Set DADDR field in header to any value
 *
 * ipt_DADDR.h borrowed heavily from ipt_TOS.h  11/09/2000
*/
#ifndef _IPT_DADDR_H
#define _IPT_DADDR_H

struct ipt_daddr_target_info {
	u_int8_t daddr;
};

#endif /*_IPT_DADDR_H*/

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_SADDR_2.6.3.c
Content-Type: text/x-csrc; name=ipt_SADDR_2.6.3.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* This is a module which is used for setting the SADDR field of a packet. */

/* (C) 1999-2001 Paul `Rusty' Russell
 * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <net/tcp.h>
#include <net/checksum.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Uli Konrad");
MODULE_DESCRIPTION("iptables IP Source Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const void *targinfo,
       void *userinfo)
{
	const struct ipt_saddr_target_info *saddrinfo = targinfo;

	if ((*pskb)->nh.iph->saddr != saddrinfo->saddr) {
		u_int32_t diffs[2];

		if (!skb_ip_make_writable(pskb, sizeof(struct iphdr)))
			return NF_DROP;

		diffs[0] = ~((*pskb)->nh.iph->saddr);
		(*pskb)->nh.iph->saddr = saddrinfo->saddr;
		diffs[1] = saddrinfo->saddr;

		(*pskb)->nh.iph->check
			= csum_fold(csum_partial((char *)diffs,
						 sizeof(diffs),
						 (*pskb)->nh.iph->check
						 ^0xFFFF));

        if ((*pskb)->nh.iph->protocol == 0x06) {
                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

                iph = (*pskb)->nh.iph;
                tcph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl*4;
                tcph->check = 0;
                tcph->check = tcp_v4_check(tcph, datalen, iph->saddr, iph->daddr,
                                   csum_partial((char *)tcph, datalen, 0));
        }
        if ((*pskb)->nh.iph->protocol == 0x11) {
                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

                iph = (*pskb)->nh.iph;
                udph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                udph->check = 0;
                udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char *)udph,
                                                             datalen, 0));
        }


		(*pskb)->nfcache |= NFC_ALTERED;
	}

	return IPT_CONTINUE;
}

static int
checkentry(const char *tablename,
	   const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_saddr_target_info))) {
		printk(KERN_WARNING "SADDR: targinfosize %u != %Zu\n",
		       targinfosize,
		       IPT_ALIGN(sizeof(struct ipt_saddr_target_info)));
		return 0;
	}

	if (strcmp(tablename, "mangle") != 0) {
		printk(KERN_WARNING "SADDR: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
		return 0;
	}

	return 1;
}

static struct ipt_target ipt_saddr_reg = {
	.name		= "SADDR",
	.target		= target,
	.checkentry	= checkentry,
	.me		= THIS_MODULE,
};

static int __init init(void)
{
	return ipt_register_target(&ipt_saddr_reg);
}

static void __exit fini(void)
{
	ipt_unregister_target(&ipt_saddr_reg);
}

module_init(init);
module_exit(fini);

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_SADDR_2.6.3.h
Content-Type: text/x-chdr; name=ipt_SADDR_2.6.3.h; charset=UTF-8
Content-Transfer-Encoding: 7bit

#ifndef _IPT_SADDR_H_target
#define _IPT_SADDR_H_target

struct ipt_saddr_target_info {
	u_int32_t saddr;
};

#endif /*_IPT_SADDR_H_target*/

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_SADDR_2.6.23.c
Content-Type: text/x-csrc; name=ipt_SADDR_2.6.23.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* This is a module which is used for setting the SADDR field of a packet. */

/* (C) 1999-2001 Paul `Rusty' Russell
 * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/in.h>
#include <linux/netfilter.h>
#include <net/checksum.h>

#include <linux/netfilter/x_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>
#include <linux/netfilter_ipv4/ip_tables.h>

#define NFC_ALTERED 0x8000

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Manuel Scheub");
MODULE_DESCRIPTION("iptables IP Source Address mangling module");

static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const struct xt_target *target,
       const void *targinfo)
{
	const struct ipt_saddr_target_info *saddrinfo = targinfo;
	struct iphdr *iph = ip_hdr(*pskb);

        if (iph->saddr != saddrinfo->saddr) { 
                u_int32_t diffs[2];

                if (!skb_make_writable(pskb, sizeof(struct iphdr)))
                        return NF_DROP;

                diffs[0] = ~(iph->saddr);
                iph->saddr = saddrinfo->saddr;
                diffs[1] = saddrinfo->saddr;

                iph->check = csum_fold(csum_partial((char *)diffs,
                                                 sizeof(diffs),
                                                 iph->check
                                                 ^0xFFFF));

	if (iph->protocol == 0x06) {
//                struct iphdr *iph;
                struct tcphdr *tcph;
                int datalen;

//                iph = (*pskb)->nh.iph;
                tcph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                tcph->check = 0;
		tcph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_TCP,
						csum_partial((char *)tcph,
                                                             datalen, 0));

//                tcph->check = tcp_v4_check( datalen, 
//					iph->saddr, 
//					iph->daddr,
//                                   	csum_partial((char *)tcph, 
//						datalen, 0));
        }

	if (iph->protocol == 0x11) {
//                struct iphdr *iph;
                struct udphdr *udph;
                int datalen;

//                iph = (*pskb)->nh.iph;
                udph = (void *)iph + iph->ihl*4;

                datalen = (*pskb)->len - iph->ihl * 4;
                udph->check = 0;
                udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
                                                datalen, IPPROTO_UDP,
                                                csum_partial((char *)udph,
                                                             datalen, 0));
        }
                
//		(*pskb)->nfcache |= NFC_ALTERED;
        }

        return XT_CONTINUE;
}

bool
checkentry(const char *tablename,
           const struct ipt_entry *e,
           void *targinfo,
           unsigned int targinfosize,
           unsigned int hook_mask)
{
        if (targinfosize != IPT_ALIGN(sizeof(struct ipt_saddr_target_info))) {
                printk(KERN_WARNING "SADDR: targinfosize %u != %Zu\n",
                       targinfosize,
                       IPT_ALIGN(sizeof(struct ipt_saddr_target_info)));
                return 0;
        }

        if (strcmp(tablename, "mangle") != 0) {
                printk(KERN_WARNING "SADDR: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
                return 0;
        }

        return 1;
}

static struct xt_target ipt_saddr_reg __read_mostly = {
	.name		= "SADDR",
	.family		= AF_INET,
	.target		= target,
	.targetsize	= sizeof(struct ipt_saddr_target_info),
	.table		= "mangle",
	.checkentry	= checkentry,
	.me		= THIS_MODULE,
};

static int __init ipt_saddr_init(void)
{
	return xt_register_target(&ipt_saddr_reg);
}

static void __exit ipt_saddr_fini(void)
{
	xt_unregister_target(&ipt_saddr_reg);
}

module_init(ipt_saddr_init);
module_exit(ipt_saddr_fini);

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=ipt_SADDR_2.6.23.h
Content-Type: text/x-chdr; name=ipt_SADDR_2.6.23.h; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* Set SADDR field in header to any value
 *
 * ipt_SADDR.h borrowed heavily from ipt_TOS.h  11/09/2000
*/
#ifndef _IPT_SADDR_H
#define _IPT_SADDR_H

struct ipt_saddr_target_info {
	u_int8_t saddr;
};

#endif /*_IPT_SADDR_H*/

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=libipt_DADDR_1.2.9.c
Content-Type: text/x-csrc; name=libipt_DADDR_1.2.9.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* Shared library add-on to iptables to add DADDR target support. */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_DADDR.h>

struct daddrinfo {
	struct ipt_entry_target t;
	struct ipt_daddr_target_info daddr;
};

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"DADDR target v%s options:\n"
"  --to-dest ip-address       set dest address\n",
IPTABLES_VERSION);
}

static struct option opts[] = {
	{ "to-dest", 1, 0, '1' },
	{ 0 }
};

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache)
{
}

static void
parse_daddr(const unsigned char *s, struct ipt_daddr_target_info *info)
{
	struct in_addr *ip;

        ip = dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n", s);

	info->daddr = ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
	struct ipt_daddr_target_info *daddrinfo
		= (struct ipt_daddr_target_info *)(*target)->data;

	switch (c) {
	case '1':
		if (*flags)
			exit_error(PARAMETER_PROBLEM,
			           "DADDR target: Cant specify --to-dest twice");
		parse_daddr(optarg, daddrinfo);
		*flags = 1;
		break;

	default:
		return 0;
	}

	return 1;
}

static void
final_check(unsigned int flags)
{
	if (!flags)
		exit_error(PARAMETER_PROBLEM,
		           "DADDR target: Parameter --to-dest is required");
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
	struct in_addr a;
	const struct ipt_daddr_target_info *daddrinfo =
		(const struct ipt_daddr_target_info *)target->data;
	a.s_addr = daddrinfo->daddr;
	printf("DADDR set %s ", addr_to_dotted(&a));
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
	struct in_addr a;
	const struct ipt_daddr_target_info *daddrinfo =
		(const struct ipt_daddr_target_info *)target->data;

	a.s_addr = daddrinfo->daddr;
	printf("--to-dest %s ", addr_to_dotted(&a));
}

static
struct iptables_target daddr
= { NULL,
    "DADDR",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_daddr_target_info)),
    IPT_ALIGN(sizeof(struct ipt_daddr_target_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
	register_target(&daddr);
}

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=libipt_DADDR_1.4.0.c
Content-Type: text/x-csrc; name=libipt_DADDR_1.4.0.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* Shared library add-on to iptables to add DADDR target support. */
/* Adopted from TOS target support*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_DADDR.h>

struct daddrinfo {
	struct xt_entry_target t;
	struct ipt_daddr_target_info daddr;
};

/* Function which prints out usage message. */
static void DADDR_help(void)
{
	printf(
"DADDR target v%s options:\n"
"  --to-dest ip-address       set dest address\n",
IPTABLES_VERSION);	
}

static const struct option DADDR_opts[] = {
	{ "to-dest", 1, NULL, '1' },
	{ 0 }
};

static void
parse_daddr(const char *s, struct ipt_daddr_target_info *info)
{
	struct in_addr *ip;

        ip = dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n", s);

        info->daddr = ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int DADDR_parse(int c, char **argv, int invert, unsigned int *flags,
                     const void *entry, struct xt_entry_target **target)
{
	struct ipt_daddr_target_info *daddrinfo
		= (struct ipt_daddr_target_info *)(*target)->data;

	switch (c) {
	case '1':
		if (*flags)
			exit_error(PARAMETER_PROBLEM,
			           "DADDR target: Cant specify --to-dest twice");
		parse_daddr(optarg, daddrinfo);
		*flags = 1;
		break;

	default:
		return 0;
	}

	return 1;
}

static void DADDR_check(unsigned int flags)
{
	if (!flags)
		exit_error(PARAMETER_PROBLEM,
		           "DADDR target: Parameter --to-dest is required");
}

static void
print_daddr(u_int8_t daddr, int numeric)
{
	unsigned int i;

	if (!numeric) {
		for (i = 0; i<sizeof(DADDR_values)/sizeof(struct DADDR_value); i++)
			if (DADDR_values[i].DADDR == daddr) {
				printf("%s ", DADDR_values[i].name);
				return;
			}
	}
	printf("0x%02x ", daddr);
}

/* Prints out the targinfo. */
static void DADDR_print(const void *ip, const struct xt_entry_target *target,
                      int numeric)
{
	const struct ipt_daddr_target_info *daddrinfo =
		(const struct ipt_daddr_target_info *)target->data;
	printf("DADDR set ");
	print_daddr(daddrinfo->daddr, numeric);
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void DADDR_save(const void *ip, const struct xt_entry_target *target)
{
	const struct ipt_daddr_target_info *daddrinfo =
		(const struct ipt_daddr_target_info *)target->data;

	printf("--to-dest 0x%02x ", daddrinfo->daddr);
}

static struct iptables_target daddr_target = {
	.name		= "DADDR",
	.version	= IPTABLES_VERSION,
	.size		= IPT_ALIGN(sizeof(struct ipt_daddr_target_info)),
	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_daddr_target_info)),
	.help		= DADDR_help,
	.parse		= DADDR_parse,
	.final_check	= DADDR_check,
	.print		= DADDR_print,
	.save		= DADDR_save,
	.extra_opts	= DADDR_opts,
};

void _init(void)
{
	register_target(&daddr_target);
}

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=libipt_SADDR_1.2.9.c
Content-Type: text/x-csrc; name=libipt_SADDR_1.2.9.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* Shared library add-on to iptables to add SADDR target support. */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

struct saddrinfo {
	struct ipt_entry_target t;
	struct ipt_saddr_target_info saddr;
};

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"SADDR target v%s options:\n"
"  --to-source ip-address       set source address\n",
IPTABLES_VERSION);
}

static struct option opts[] = {
	{ "to-source", 1, 0, '1' },
	{ 0 }
};

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache)
{
}

static void
parse_saddr(const unsigned char *s, struct ipt_saddr_target_info *info)
{
	struct in_addr *ip;

        ip = dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n", s);

	info->saddr = ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
	struct ipt_saddr_target_info *saddrinfo
		= (struct ipt_saddr_target_info *)(*target)->data;

	switch (c) {
	case '1':
		if (*flags)
			exit_error(PARAMETER_PROBLEM,
			           "SADDR target: Cant specify --to-source twice");
		parse_saddr(optarg, saddrinfo);
		*flags = 1;
		break;

	default:
		return 0;
	}

	return 1;
}

static void
final_check(unsigned int flags)
{
	if (!flags)
		exit_error(PARAMETER_PROBLEM,
		           "SADDR target: Parameter --to-source is required");
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
	struct in_addr a;
	const struct ipt_saddr_target_info *saddrinfo =
		(const struct ipt_saddr_target_info *)target->data;
	a.s_addr = saddrinfo->saddr;
	printf("SADDR set %s ", addr_to_dotted(&a));
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
	struct in_addr a;
	const struct ipt_saddr_target_info *saddrinfo =
		(const struct ipt_saddr_target_info *)target->data;

	a.s_addr = saddrinfo->saddr;
	printf("--to-source %s ", addr_to_dotted(&a));
}

static
struct iptables_target saddr
= { NULL,
    "SADDR",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
    IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
	register_target(&saddr);
}

--=-EkI7qRR5FUvVx3bIbw0+
Content-Disposition: attachment; filename=libipt_SADDR_1.4.0.c
Content-Type: text/x-csrc; name=libipt_SADDR_1.4.0.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* Shared library add-on to iptables to add SADDR target support. */
/* Adopted from TOS target support*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_SADDR.h>

struct saddrinfo {
	struct xt_entry_target t;
	struct ipt_saddr_target_info saddr;
};

/* Function which prints out usage message. */
static void SADDR_help(void)
{
	printf(
"SADDR target v%s options:\n"
"  --to-source ip-address       set source address\n",
IPTABLES_VERSION);	
}

static const struct option SADDR_opts[] = {
	{ "to-source", 1, NULL, '1' },
	{ 0 }
};

static void
parse_saddr(const char *s, struct ipt_saddr_target_info *info)
{
	struct in_addr *ip;

        ip = dotted_to_addr(s);
        if (!ip)
                exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n", s);

        info->saddr = ip->s_addr;
}

/* Function which parses command options; returns true if it
   ate an option */
static int SADDR_parse(int c, char **argv, int invert, unsigned int *flags,
                     const void *entry, struct xt_entry_target **target)
{
	struct ipt_saddr_target_info *saddrinfo
		= (struct ipt_saddr_target_info *)(*target)->data;

	switch (c) {
	case '1':
		if (*flags)
			exit_error(PARAMETER_PROBLEM,
			           "SADDR target: Cant specify --to-source twice");
		parse_saddr(optarg, saddrinfo);
		*flags = 1;
		break;

	default:
		return 0;
	}

	return 1;
}

static void SADDR_check(unsigned int flags)
{
	if (!flags)
		exit_error(PARAMETER_PROBLEM,
		           "SADDR target: Parameter --to-source is required");
}

static void
print_saddr(u_int8_t saddr, int numeric)
{
	unsigned int i;

	if (!numeric) {
		for (i = 0; i<sizeof(SADDR_values)/sizeof(struct SADDR_value); i++)
			if (SADDR_values[i].SADDR == saddr) {
				printf("%s ", SADDR_values[i].name);
				return;
			}
	}
	printf("0x%02x ", saddr);
}

/* Prints out the targinfo. */
static void SADDR_print(const void *ip, const struct xt_entry_target *target,
                      int numeric)
{
	const struct ipt_saddr_target_info *saddrinfo =
		(const struct ipt_saddr_target_info *)target->data;
	printf("SADDR set ");
	print_saddr(saddrinfo->saddr, numeric);
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void SADDR_save(const void *ip, const struct xt_entry_target *target)
{
	const struct ipt_saddr_target_info *saddrinfo =
		(const struct ipt_saddr_target_info *)target->data;

	printf("--to-source 0x%02x ", saddrinfo->saddr);
}

static struct iptables_target saddr_target = {
	.name		= "SADDR",
	.version	= IPTABLES_VERSION,
	.size		= IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_saddr_target_info)),
	.help		= SADDR_help,
	.parse		= SADDR_parse,
	.final_check	= SADDR_check,
	.print		= SADDR_print,
	.save		= SADDR_save,
	.extra_opts	= SADDR_opts,
};

void _init(void)
{
	register_target(&saddr_target);
}

--=-EkI7qRR5FUvVx3bIbw0+--

