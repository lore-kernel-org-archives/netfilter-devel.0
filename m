From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: ipset-4.4 on 2.6.16.60 kernel
Date: Sat, 06 Nov 2010 20:19:38 +0000
Message-ID: <4CD5B85A.4050007@googlemail.com>
References: <alpine.DEB.2.00.1010012214250.19669@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34279 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0KFUTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Nov 2010 16:19:43 -0400
In-Reply-To: <alpine.DEB.2.00.1010012214250.19669@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am trying to install ipset on the above kernel version after 
successfully recompiling and installing my iptables v1.3.7.

When I unzip ipset-4.4.tar.bz2, then copy both 
kernel/include/linux/netfilter_ipv4/ip_set.h AND 
kernel/include/linux/netfilter_ipv4/ipt_set.h to 
include/linux/netfilter_ipv4 (the latter was also needed for building 
iptables as well, though the installation page did not mention that as a 
requirement) and then ran make I've got the following error:

=================
  CC [M]  /root/ipset-4.4/kernel/ipt_set.o
/root/ipset-4.4/kernel/ipt_set.c: In function `checkentry':
/root/ipset-4.4/kernel/ipt_set.c:167: warning: implicit declaration of 
function `IPT_ALIGN'
/root/ipset-4.4/kernel/ipt_set.c: In function `ipt_ipset_init':
/root/ipset-4.4/kernel/ipt_set.c:244: warning: passing arg 1 of 
`xt_register_match' makes integer from pointer without a cast
/root/ipset-4.4/kernel/ipt_set.c:244: error: too few arguments to 
function `xt_register_match'
/root/ipset-4.4/kernel/ipt_set.c: In function `ipt_ipset_fini':
/root/ipset-4.4/kernel/ipt_set.c:249: warning: passing arg 1 of 
`xt_unregister_match' makes integer from pointer without a cast
/root/ipset-4.4/kernel/ipt_set.c:249: error: too few arguments to 
function `xt_unregister_match'
make[2]: *** [/root/ipset-4.4/kernel/ipt_set.o] Error 1
make[1]: *** [_module_/root/ipset-4.4/kernel] Error 2
=================

Looking at the source of ipt_set.c I think this is what causes the error:

=================
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16)
#include <linux/netfilter_ipv4/ip_tables.h>
#define xt_register_match       ipt_register_match
#define xt_unregister_match     ipt_unregister_match
#define xt_match                ipt_match
#else
#include <linux/netfilter/x_tables.h>
#endif
#include <linux/netfilter_ipv4/ip_set.h>
#include <linux/netfilter_ipv4/ipt_set.h>
.....
static int __init ipt_ipset_init(void)
{
        return xt_register_match(&set_match);
}

static void __exit ipt_ipset_fini(void)
{
        xt_unregister_match(&set_match);
}
=================

I looked at both x_tables.h and ip_tables.h files and they do contain 
the following:

x_tables.h
~~~~~~~~~~
extern int xt_register_match(int af, struct xt_match *target);
extern void xt_unregister_match(int af, struct xt_match *target);

ip_tables.h
~~~~~~~~~~~
#define ipt_register_match(mtch) xt_register_match(AF_INET, mtch)
#define ipt_unregister_match(mtch) xt_unregister_match(AF_INET, mtch)

According to the above as my kernel version appears to be > 2,6,16 
x_tables.h include triggers and it defines the 2 functions, but 
requiring two parameters instead of the one defined in ipt_set.c! I 
tried to change the version to KERNEL_VERSION(2,6,17) to force include 
of netfilter_ipv4/ip_tables.h - that passes, though for this file I get 
the following warning:

=================
  CC [M]  /root/ipset-4.4/kernel/ipt_set.o
/root/ipset-4.4/kernel/ipt_set.c: In function `ipt_ipset_init':
/root/ipset-4.4/kernel/ipt_set.c:244: warning: implicit declaration of 
function `ipt_register_match'
/root/ipset-4.4/kernel/ipt_set.c: In function `ipt_ipset_fini':
/root/ipset-4.4/kernel/ipt_set.c:249: warning: implicit declaration of 
function `ipt_unregister_match'
=================

and then get a similar error for ipt_SET.c:

=================
  CC [M]  /root/ipset-4.4/kernel/ipt_SET.o
/root/ipset-4.4/kernel/ipt_SET.c: In function `checkentry':
/root/ipset-4.4/kernel/ipt_SET.c:157: warning: implicit declaration of 
function `IPT_ALIGN'
/root/ipset-4.4/kernel/ipt_SET.c: In function `ipt_SET_init':
/root/ipset-4.4/kernel/ipt_SET.c:247: warning: passing arg 1 of 
`xt_register_target' makes integer from pointer without a cast
/root/ipset-4.4/kernel/ipt_SET.c:247: error: too few arguments to 
function `xt_register_target'
/root/ipset-4.4/kernel/ipt_SET.c: In function `ipt_SET_fini':
/root/ipset-4.4/kernel/ipt_SET.c:252: warning: passing arg 1 of 
`xt_unregister_target' makes integer from pointer without a cast
/root/ipset-4.4/kernel/ipt_SET.c:252: error: too few arguments to 
function `xt_unregister_target'
make[2]: *** [/root/ipset-4.4/kernel/ipt_SET.o] Error 1
make[1]: *** [_module_/root/ipset-4.4/kernel] Error 2
=================

Trying the same 'trick' for ipt_SET.c won't work though, I am getting this:

=================
  CC [M]  /root/ipset-4.4/kernel/ipt_SET.o
/root/ipset-4.4/kernel/ipt_SET.c:24:1: warning: "XT_CONTINUE" redefined
In file included from include/linux/netfilter_ipv4/ip_tables.h:28,
                 from /root/ipset-4.4/kernel/ipt_SET.c:20:
include/linux/netfilter/x_tables.h:17:1: warning: this is the location 
of the previous definition
/root/ipset-4.4/kernel/ipt_SET.c: In function `target':
/root/ipset-4.4/kernel/ipt_SET.c:94: error: `XT_CONTINUE' undeclared 
(first use in this function)
/root/ipset-4.4/kernel/ipt_SET.c:94: error: (Each undeclared identifier 
is reported only once
/root/ipset-4.4/kernel/ipt_SET.c:94: error: for each function it appears 
in.)
/root/ipset-4.4/kernel/ipt_SET.c: In function `ipt_SET_init':
/root/ipset-4.4/kernel/ipt_SET.c:247: warning: implicit declaration of 
function `ipt_register_target'
/root/ipset-4.4/kernel/ipt_SET.c: In function `ipt_SET_fini':
/root/ipset-4.4/kernel/ipt_SET.c:252: warning: implicit declaration of 
function `ipt_unregister_target'
make[2]: *** [/root/ipset-4.4/kernel/ipt_SET.o] Error 1
make[1]: *** [_module_/root/ipset-4.4/kernel] Error 2
make[1]: Leaving directory 
`/usr/src/expresscore/distrib/build/sources/kernel-runtime/linux-2.6.16.60'
make: *** [modules] Error 2
=================

XT_CONTINUE is defined as IPT_CONTINUE, which, in ip_tables.h is defined 
as ... XT_CONTINUE in ip_tables.h! After a bit more digging I found that 
netfilter/x_tables.h defines XT_CONTINUE as 0xFFFFFFFF, so I tried to 
replace this in ipt_SET.c, but when tried make again I've got this:

=================
  CC [M]  /root/ipset-4.4/kernel/ipt_set.o
/root/ipset-4.4/kernel/ipt_set.c: In function `ipt_ipset_init':
/root/ipset-4.4/kernel/ipt_set.c:244: warning: implicit declaration of 
function `ipt_register_match'
/root/ipset-4.4/kernel/ipt_set.c: In function `ipt_ipset_fini':
/root/ipset-4.4/kernel/ipt_set.c:249: warning: implicit declaration of 
function `ipt_unregister_match'
  CC [M]  /root/ipset-4.4/kernel/ipt_SET.o
/root/ipset-4.4/kernel/ipt_SET.c: In function `ipt_SET_init':
/root/ipset-4.4/kernel/ipt_SET.c:247: warning: implicit declaration of 
function `ipt_register_target'
/root/ipset-4.4/kernel/ipt_SET.c: In function `ipt_SET_fini':
/root/ipset-4.4/kernel/ipt_SET.c:252: warning: implicit declaration of 
function `ipt_unregister_target'

  Building modules, stage 2.
  MODPOST
*** Warning: "ipt_unregister_match" [/root/ipset-4.4/kernel/ipt_set.ko] 
undefined!
*** Warning: "ipt_register_match" [/root/ipset-4.4/kernel/ipt_set.ko] 
undefined!
*** Warning: "ipt_unregister_target" [/root/ipset-4.4/kernel/ipt_SET.ko] 
undefined!
*** Warning: "ipt_register_target" [/root/ipset-4.4/kernel/ipt_SET.ko] 
undefined!
=================

Where I am now stuck and would appreciate a bit of help.

My iptables 1.3.7 compiled and installed successfully (from what I can 
gather it added two additional files in /usr/lib/iptables - 
libipt_set.so and libipt_SET.so), so I don't think this is iptables problem.


> ipset-4.4 has just been released with one important fix and some small 
> corrections:
>
> Kernel part changes:
>   - The ipporthash, ipportiphash and ipportnethash set types did 
>     not work with mixed "src" and "dst" direction parameters of the "set" 
>     and  "SET" iptables match and target (reported by Dash Four)
>   - Errorneous semaphore handling in error path fixed (reported by 
>     Jan Engelhardt, bugzilla id 668) 
>   

