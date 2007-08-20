From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Kernel oops during netfilter memory allocation
Date: Mon, 20 Aug 2007 18:08:08 +0200
Message-ID: <200708201808.08880.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oxbyGo0uDEikItZ"
Cc: netfilter-devel@lists.netfilter.org
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

--Boundary-00=_oxbyGo0uDEikItZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hey there,

I'm currently debugging a kernel oops with kernel 2.6.21.7 that occurs
from time to time with our netfilter accounting module ipt_ACCOUNT 
(http://www.intra2net.com/de/produkte/opensource/ipt_account/).

What basically happens is that the module allocates memory
inside an interrupt handler like many other netfilter modules do.
Except that it does it very often if you have a large, busy network.

To me it looks like I found a bug in the kernel memory handler.
I've written a minimalistic netfilter module ipt_CRASH that
just allocates and frees memory to demonstrate the problem.

Here's a screenshot of the oops:
http://img231.imageshack.us/img231/9064/kerneloopsiptcrashzb1.jpg

Another shot of it with a "tainted" kernel:
http://img529.imageshack.us/img529/6681/kerneloopsey1.jpg

I would have included the backtrace as text, but unfortunately
the USB serial console dies before it outputs anything useful.

You need a fast machine with lots of RAM to reproduce it, I used a 3 Ghz 
machine with 3 GB of RAM. ipt_CRASH allocates and frees memory for every 
packet, a packet generator like "sendip" might help:
http://www.earth.li/projectpurple/progs/sendip.html

The machine dies after 15-30 minutes or as soon as I try to reboot it.

Please CC: answers, I'm only on netfilter-devel.

Thanks in advance,
Thomas

--Boundary-00=_oxbyGo0uDEikItZ
Content-Type: application/x-shellscript;
  name="crashit.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="crashit.sh"

#!/bin/sh

while /bin/true; do
    for IP in `seq 2 255` ; do
	./sendip -p ipv4 -is 172.16.$IP.99 -id 172.16.1.124 -p udp -us 600 -ud 600 -d "x" 172.16.1.124
    done
done

--Boundary-00=_oxbyGo0uDEikItZ
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="libipt_CRASH.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libipt_CRASH.c"

/* Shared library add-on to iptables to add CRASH support.
   Author: Intra2net AG <opensource@intra2net.com>
   Licensed under the GPL v2.
*/

#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <syslog.h>
#include <getopt.h>
#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_CRASH.h>

static struct option opts[] = {
    { .name = 0 }
};

/* Function which prints out usage message. */
static void help(void)
{
    printf(
"CRASH v%s options:\n", IPTABLES_VERSION);
}

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache)
{
    /* Can't cache this */
    *nfcache |= NFC_UNKNOWN;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
    return 0;
}

/* Final check; nothing. */
static void final_check(unsigned int flags)
{
}

static void print_it(const struct ipt_ip *ip,
                     const struct ipt_entry_target *target, char do_prefix)
{
    if (!do_prefix)
        printf("CRASH ");
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
    print_it (ip, target, 0);
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
    print_it(ip, target, 1);
}

static
struct iptables_target crash
= {
    .next          = NULL,
    .name          = "CRASH",
    .version       = IPTABLES_VERSION,
    .size          = IPT_ALIGN(sizeof(struct ipt_crash_info)),
    .userspacesize = IPT_ALIGN(sizeof(struct ipt_crash_info)),
    .help          = &help,
    .init          = &init,
    .parse         = &parse,
    .final_check   = &final_check,
    .print         = &print,
    .save          = &save,
    .extra_opts    = opts
};

void _init(void)
{
    register_target(&crash);
}

--Boundary-00=_oxbyGo0uDEikItZ
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="ipt_CRASH.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ipt_CRASH.c"

/***************************************************************************
 *   Copyright (C) 2007 by Intra2net AG                                    *
 *   opensource@intra2net.com                                              *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License                  *
 *   version 2 as published by the Free Software Foundation;               *
 *                                                                         *
 ***************************************************************************/

#include <linux/module.h>
#include <linux/version.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <net/icmp.h>
#include <net/udp.h>
#include <net/tcp.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_CRASH.h>
#include <asm/semaphore.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/string.h>
#include <linux/spinlock.h>
#include <asm/uaccess.h>

/* Spinlock used during memory allocation */
static DEFINE_SPINLOCK(ipt_crash_lock);

static unsigned int ipt_crash_target(struct sk_buff **pskb,
                                   const struct net_device *in,
                                   const struct net_device *out,
                                   unsigned int hooknum,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
                                   const struct xt_target *target,
#endif
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)
                                   const void *targinfo)
#else
                                   const void *targinfo,
                                   void *userinfo)
#endif
{
    char *data;

    spin_lock_bh(&ipt_crash_lock);

    if ((data = (char *)get_zeroed_page(GFP_ATOMIC)) == NULL) {
        printk("ipt_CRASH: Out of memory!\n");
    } else {
        // Fill memory with pattern
        int i, j = 123;
        for (i = 0; i < PAGE_SIZE; i++) {
            data[i] = j;
            j++;
        }

        free_page((unsigned long)data);
    }

    spin_unlock_bh(&ipt_crash_lock);

    return IPT_CONTINUE;
}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
static struct xt_target xt_crash_reg = {
#else
static struct ipt_target ipt_crash_reg = {
#endif
    .name = "CRASH",
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
    .family = AF_INET,
#endif
    .target = ipt_crash_target,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
    .targetsize = sizeof(struct ipt_crash_info),
#endif
    .me = THIS_MODULE
};

static int __init init(void)
{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
    if (xt_register_target(&xt_crash_reg))
#else
    if (ipt_register_target(&ipt_crash_reg))
#endif
        return -EINVAL;

    return 0;
}

static void __exit fini(void)
{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
    xt_unregister_target(&xt_crash_reg);
#else
    ipt_unregister_target(&ipt_crash_reg);
#endif
}

module_init(init);
module_exit(fini);
MODULE_LICENSE("GPL");

--Boundary-00=_oxbyGo0uDEikItZ
Content-Type: text/x-chdr;
  charset="iso-8859-1";
  name="ipt_CRASH.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ipt_CRASH.h"

/***************************************************************************
 *   Copyright (C) 2004-2005 by Intra2net AG                               *
 *   opensource@intra2net.com                                              *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License                  *
 *   version 2 as published by the Free Software Foundation;               *
 *                                                                         *
 ***************************************************************************/

#ifndef _IPT_CRASH_H
#define _IPT_CRASH_H

/* Structure for the userspace part of ipt_CRASH */
struct ipt_crash_info {
};

#endif /*_IPT_CRASH_H*/

--Boundary-00=_oxbyGo0uDEikItZ--
