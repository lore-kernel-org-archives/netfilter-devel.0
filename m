From: Marek Becka <beckam2@fel.cvut.cz>
Subject: Packet marking based on IP header
Date: Tue, 19 Aug 2008 10:12:44 +0200
Message-ID: <48AA807C.5020108@fel.cvut.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090800040509080405080702"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:50331 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYHSITd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:19:33 -0400
Received: from localhost (unknown [192.168.200.4])
	by max.feld.cvut.cz (Postfix) with ESMTP id 4444C19F3872
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 10:12:56 +0200 (CEST)
Received: from max.feld.cvut.cz ([192.168.200.1])
	by localhost (styx.feld.cvut.cz [192.168.200.4]) (amavisd-new, port 10044)
	with ESMTP id RA0-sGlL+Aji for <netfilter-devel@vger.kernel.org>;
	Tue, 19 Aug 2008 10:12:54 +0200 (CEST)
Received: from imap.feld.cvut.cz (imap.feld.cvut.cz [147.32.192.34])
	by max.feld.cvut.cz (Postfix) with ESMTP id AFFE519F3838
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 10:12:54 +0200 (CEST)
Received: from [10.125.50.141] (proxy.klacno.sk [213.215.100.225])
	by imap.feld.cvut.cz (Postfix) with ESMTP id 8C141404C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 10:12:54 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090800040509080405080702
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hi, I'm working on iptables target, that enables marking ipv4/6 packet 
based on their headers. I need this for high performance gateway that 
marks packet by part of source address. Marks are used with tc filter. 
Because there is also nat on outgoing device, tc u32 filter is not 
usable here. It may be also useful for someone other, so suggestions nad 
commens are welcome.

--------------090800040509080405080702
Content-Type: text/plain;
 name="libxt_IPHMARK.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libxt_IPHMARK.c"

#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <xtables.h>
#include <linux/netfilter/x_tables.h>
#include <linux/netfilter/xt_IPHMARK.h>

enum {
	IPH_OFFSET 	= 1 << 0,
};

static void help(void)
{
	printf(
"IPHMARK target options:\n"
"	--offset value[/mask]	Data offset from beggining of IP header\n"
"	  		        with optional mask\n"
"\n"
);
}

static const struct option opts[] = {
	{ "offset", 1, NULL, '1' },
	{ .name = NULL }
};

static void init(struct xt_entry_target *target)
{
	struct xt_iphmark_target_info *iphinfo = (void *)target->data;

	iphinfo->mask = ~0U;
}

static int parse(int c, int invert, unsigned int *flags,
                 struct xt_entry_target **target, const int max)
{
	struct xt_iphmark_target_info *iphminfo = (void *)(*target)->data;
	char *end;

	switch (c) {
	case '1':
		param_act(P_ONLY_ONCE, "IPHMARK", "--offset", *flags & IPH_OFFSET);
		param_act(P_NO_INVERT, "IPHMARK", "--offset", invert);
		if (strtonum(optarg, &end, &(iphminfo->offset), 0, max))
			exit_error(PARAMETER_PROBLEM, "IPMHARK invalid offset");
		if (*end == '/' && end[1] != '\0')
			iphminfo->mask = strtoul(end + 1, &end, 0);
		if (*end != '\0')
			exit_error(PARAMETER_PROBLEM, "IPHMARK bad syntax");
		*flags |= IPH_OFFSET;
		break;
	default:
		return 0;
	}

	return 1;
}

static int parse4(int c, char **argv, int invert, unsigned int *flags,
                  const void *entry, struct xt_entry_target **target)
{
	return parse(c, invert, flags, target, IP4_MAX_IPHOFFSET);
}

static int parse6(int c, char **argv, int invert, unsigned int *flags,
                  const void *entry, struct xt_entry_target **target)
{
	return parse(c, invert, flags, target, IP6_MAX_IPHOFFSET);
}

static void final_check(unsigned int flags)
{
	if (flags == 0)
		exit_error(PARAMETER_PROBLEM, 
                           "IPHMARK --offset parameter required");
}

static void print(const void *ip, const struct xt_entry_target *target, 
                  int numeric)
{
	const struct xt_iphmark_target_info *iphminfo = (void *)target->data;

	if (iphminfo->mask != 0xffffffffU) 
		printf("IPHMARK offset %d", iphminfo->offset);
	else
		printf("IPHMARK offset %d  mask 0x%x",
		       iphminfo->offset, iphminfo->mask);
}

static void save(const void *ip, const struct xt_entry_target *target)
{
	const struct xt_iphmark_target_info *iphminfo = (void *)target->data;

	printf("--offset %d/0x%x", iphminfo->offset, iphminfo->mask);
}

static struct xtables_target iphmark = {
	.family		= AF_INET,
	.name		= "IPHMARK",
	.version	= XTABLES_VERSION,
	.size		= XT_ALIGN(sizeof(struct xt_iphmark_target_info)),
	.userspacesize	= XT_ALIGN(sizeof(struct xt_iphmark_target_info)),
	.help		= help,
	.init		= init,
	.parse		= parse4,
	.final_check	= final_check,
	.print		= print,
	.save		= save,
	.extra_opts	= opts,
};

static struct xtables_target iphmark6 = {
	.family		= AF_INET6,
	.name		= "IPHMARK",
	.version	= XTABLES_VERSION,
	.size		= XT_ALIGN(sizeof(struct xt_iphmark_target_info)),
	.userspacesize	= XT_ALIGN(sizeof(struct xt_iphmark_target_info)),
	.help		= help,
	.init		= init,
	.parse		= parse6,
	.final_check	= final_check,
	.print		= print,
	.save		= save,
	.extra_opts	= opts,
};

void _init(void)
{
	xtables_register_target(&iphmark);
	xtables_register_target(&iphmark6);
}


--------------090800040509080405080702
Content-Type: text/plain;
 name="xt_IPHMARK.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xt_IPHMARK.c"

/*
 * net/netfilter/xt_IPHMARK.c   Internet protocol header packet marker
 *
 *              This program is free software; you can redistribute it and/or
 *              modify it under the terms of the GNU General Public License
 *              as published by the Free Software Foundation; either version
 *              2 of the License, or (at your option) any later version.
 *
 * Authors:	Marek Becka <beckam2@fel.cvut.cz>
 *
 * Based on ipt_IPCLASSIFY
 */

#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/types.h>
#include <linux/netfilter/x_tables.h>
#include <linux/netfilter/xt_IPHMARK.h>

MODULE_LICENCE("GPL");
MODULE_AUTHOR("Marek Becka <beckam2@fel.cvut.cz");
MODULE_DESCRIPTION("Xtables: mark packet with IP header bits");
MODULE_ALIAS("ipt_IPHMARK");
MODULE_ALIAS("ip6t_IPHMARK");

static unsigned int iphmark_tg(struct sk_buff *skb,
                               const struct net_device *in, 
			       const struct net_device *out, 
			       unsigned int hooknum,                        
			       const struct xt_target *target, 
			       const void *targinfo)
{
	const struct xt_iphmark_target_info *iphminfo = targinfo;
	int pos = iphminfo->offset + skb_network_offset(skb);
	u32 mark;

	if (unlikely(skb_copy_bits(skb, pos, &mark, sizeof(mark)))) 
		BUG();
		
	mark = ntohl(mark);
	mark &= iphminfo->mask;
	
	skb->mark = mark;
	return XT_CONTINUE;
}

static bool check_offset(const int offset, const int maximum_offset)
{
	if (offset > maximum_offset) {
		printk(KERN_WARNING "IPHMARK: invalid offset %d\n", offset);
		return false;
	}
	return true;
}

static bool iphmark_tg_check4(const char *tablename, const void *entry,
                              const struct xt_target *target, void *targinfo,
		              unsigned int hook_mask)
{
	const struct xt_iphmark_target_info *iphminfo = targinfo;

	return check_offset(iphminfo->offset, IP4_MAX_IPHOFFSET);
}

static bool iphmark_tg_check6(const char *tablename, const void *entry,
                              const struct xt_target *target, void *targinfo,
			      unsigned int hook_mask)
{
	const struct xt_iphmark_target_info *iphminfo = targinfo;

	return check_offset(iphminfo->offset, IP6_MAX_IPHOFFSET);
}

static struct xt_target iphmark_tg_reg[] __read_mostly = {
	{
		.name		= "IPHMARK",
		.family		= AF_INET,
		.checkentry	= iphmark_tg_check4,
		.target		= iphmark_tg,		
		.targetsize	= sizeof(struct xt_iphmark_target_info),
		.table 		= "mangle",
		.me		= THIS_MODULE,
	},
	{
		.name		= "IPHMARK",
		.family		= AF_INET6,
		.checkentry	= iphmark_tg_check6,
		.target		= iphmark_tg,
		.targetsize	= sizeof(struct xt_iphmark_target_info),
		.table		= "mangle",
		.me		= THIS_MODULE,
	},
};

static int __init iphmark_tg_init(void)
{
	return xt_register_targets(iphmark_tg_reg, ARRAY_SIZE(iphmark_tg_reg));
}

static void __exit iphmark_tg_exit(void)
{
	xt_unregister_targets(iphmark_tg_reg, ARRAY_SIZE(iphmark_tg_reg));
}

module_init(iphmark_tg_init);
module_exit(iphmark_tg_exit);


--------------090800040509080405080702
Content-Type: text/plain;
 name="xt_IPHMARK.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xt_IPHMARK.h"

#ifndef _XT_IPHMARK_H
#define _XT_IPHMARK_H

#define IP4_MAX_IPHOFFSET (20 - 4)
#define IP6_MAX_IPHOFFSET (40 - 4) 

struct xt_iphmark_target_info {
	unsigned int offset;
	u_int32_t mask;
};

#endif /* _XT_IPHMARK_H */


--------------090800040509080405080702--
