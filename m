From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: inconsistency in time module of iptables
Date: Wed, 10 Dec 2008 20:44:10 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812102018180.6340@fbirervta.pbzchgretzou.qr>
References: <494010B2.2050608@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Pawe=C5=82_Bany=C5=9B?= <pbanys@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53999 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYLJToL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:44:11 -0500
In-Reply-To: <494010B2.2050608@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-12-10 19:55, Pawe=C5=82 Bany=C5=9B wrote:
>
>I tried to use the time module in iptables and I noticed some problems=
=20
>with time interpretation. I tested it on the following system:
>
>kernel: 2.6.27
>iptables: v1.4.2
>system clock time zone: Berlin (UTC+1)
>
>1. Inconsistency of "datestop":
>2. Inconsistency of "datestart":
>
>system_time		--datestop	RESULT
>14:00:00		14:10:00	rule should apply but it does not because for
>iptables datestop is 13:10:00
>
>Remark: in internal calculations datestop is one hour less than set
>Remark: in internal calculations datestart is two hours less than set


Your kernel timezone may not be set. The below module may help:

---<8--- (Makefile)
obj-m +=3D time.o
all:
	make -C /lib/modules/`uname -r`/build M=3D$$PWD;
--->8---

---<8--- (time.c)
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/time.h>

extern struct timezone sys_tz;

static int __init t_init(void)
{
	int minutes =3D sys_tz.tz_minuteswest;

	if (minutes < 0) /* east of GW */
		printk(KERN_WARNING "TZ is +%02d%02d\n",
			-minutes / 60, -minutes % 60);
	else /* west of GW */
		printk(KERN_WARNING "TZ is -%02d%02d\n",
		       minutes / 60, minutes % 60);
	return -EIO;
}

static void __exit t_exit(void)
{
}

module_init(t_init);
module_exit(t_exit);
MODULE_LICENSE("GPL");
--->8---
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
