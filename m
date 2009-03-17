From: Vlad <limonad@gmx.net>
Subject: No chain/target/match by that name
Date: Tue, 17 Mar 2009 11:19:28 +0100
Message-ID: <49BF7930.5000808@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48426 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754055AbZCQKTk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:19:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hallo , I'm trying to write a new module for iptables. I started with a 
dummy module. I can successfully compile it. But if I trying to use it, 
I get an error message:
 
$ iptables -A INPUT -s 128.0.0.1 -m secan --drop -j DROP
drop frame
iptables: No chain/target/match by that name

Can someone tell me what is a problem? Here is my code:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <iptables.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include "libipt_secan.h"

static void secan_help(void)
{
    printf(
"secan options:\n"
"  --drop    Drop Frame\n"
"  --accept    Accept Frame\n");
}

static int secan_parse(int c, char **argv, int invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
{
    struct ipt_secan_info *info = (struct ipt_secan_info *) (*match)->data;
    switch (c) {
        case '1':
            if (*flags & SECAN_DROP)
            exit_error(PARAMETER_PROBLEM, "Only use --drop once!");
            *flags |= SECAN_DROP;
            info->flags |= SECAN_DROP;
            printf("drop frame\n");
            break;
        case '2':
            if (*flags & SECAN_ACCEPT)
            exit_error(PARAMETER_PROBLEM, "Only use --accept once!");
            *flags |= SECAN_ACCEPT;
            info->flags |= SECAN_ACCEPT;
            printf("accept frame\n");
            break;
        default:
            return 0;

    }

    return 1;
}

static void secan_check(unsigned int flags)
{
    if (!flags)
        exit_error(PARAMETER_PROBLEM,
            "SECAN: You must specify one of "
            "`--drop', `--accept'");
}

static void secan_print(const void *ip, const struct xt_entry_match *match,
                      int numeric)
{
    printf("SECAN match ");
}

static void secan_save(const void *ip, const struct xt_entry_match *match)
{
    const struct ipt_secan_info *info = (struct ipt_secan_info *) 
match->data;

    if (info->flags & SECAN_DROP)
    {
        printf("--drop ");
    }
    if (info->flags & SECAN_ACCEPT)
    {
        printf("--accept ");
    }
    printf("save");
}

static const struct option secan_opts[] = {
    { "drop", 0, NULL, '1' },
    { "accept", 0, NULL, '2'},
    { .name = NULL }
};

static struct xtables_match secan_reg = {
    .name        = "secan",
    .version    = XTABLES_VERSION,
    .family        = PF_INET,
    .size        = XT_ALIGN(sizeof(struct ipt_secan_info)),
    .userspacesize    = XT_ALIGN(sizeof(struct ipt_secan_info)),
    .help        = secan_help,
    .parse        = secan_parse,
    .final_check    = secan_check,
    .print        = secan_print,
    .save        = secan_save,
    .extra_opts    = secan_opts,
};


void _init(void)
{
    xtables_register_match(&secan_reg);
}
 
As I sad this is only a dummy module now and it doesn't do much.

Sincerely,
Vlad

