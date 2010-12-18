From: "Rob Sterenborg (lists)" <lists@sterenborg.info>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 08:29:11 +0100
Message-ID: <1292657351.2371.73.camel@kushiel.sterenborg.info>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from firehole.xs4all.nl ([82.95.248.56]:45120 "EHLO
	smtp.sterenborg.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0LRH3f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 02:29:35 -0500
In-Reply-To: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-12-17 at 23:26 +0100, Jozsef Kadlecsik wrote:
> Hi,
> 
> I'm happy to announce the new branch of ipset and release it's first 
> element, ipset-5.0.

I'm not a C programmer. I just tried to make ipset compile which seems
to have worked partially. I have no clue if I did the right thing so the
below should be reviewed.

I'm on CentOS 5.5 with a custom 2.6.36.2 kernel, gcc version 4.1.2
20080704 (Red Hat 4.1.2-48).

When running 'configure' I got this error:

./configure: line 11510: syntax error near unexpected token `[libmnl],'
./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >= 1])'

CentOS' pkg-config is installed, so, for reference: I copied
'/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.sh'
again and after that 'configure' had no problems.

Running 'make', I got this :

cc1: error: unrecognized command line option "-Woverlength-strings"

If I remove '-Woverlength-strings' from all Makefiles then of course
there's no complaining about that anymore, but I'm not sure if that's
the way to go.

Next, I got this:

session.c: In function 'attr2data':
session.c:566: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
this function)
session.c:566: error: (Each undeclared identifier is reported only once
session.c:566: error: for each function it appears in.)
session.c: In function 'decode_errmsg':
session.c:1216: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
this function)
session.c: In function 'attr_len':
session.c:1338: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
this function)

To make it compile I did the following.
New file 'include/libipset/nla.h':

/*
* nla_type (16 bits)
* +---+---+-------------------------------+
* | N | O | Attribute Type                |
* +---+---+-------------------------------+
* N := Carries nested attributes
* O := Payload stored in network byte order
*
* Note: The N and O flag are mutually exclusive.
*/

#define NLA_F_NESTED            (1 << 15)
#define NLA_F_NET_BYTEORDER     (1 << 14)
#define NLA_TYPE_MASK           ~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)

Change in 'lib/session.c':

--- session.c.orig      2010-12-18 08:00:31.000000000 +0100
+++ session.c   2010-12-18 07:59:48.000000000 +0100
@@ -23,6 +23,9 @@
 #include <libipset/utils.h>                    /* STREQ */
 #include <libipset/ui.h>                       /* IPSET_ENV_* */
 #include <libipset/session.h>                  /* prototypes */
+#ifndef NLA_TYPE_MASK
+#include <libipset/nla.h>
+#endif
 
 
 #define IPSET_NEST_MAX 4

After that 'make' runs without errors.
Running 'make modules' gives:

/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c: In function
'start_msg':
/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:735: error:
'NFNL_SUBSYS_IPSET' undeclared (first use in this function)
/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:735: error: (Each
undeclared identifier is reported only once
/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:735: error: for each
function it appears in.)
/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c: At top level:
/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:1701: error:
'NFNL_SUBSYS_IPSET' undeclared here (not in a function)
make[2]: *** [/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.o] Error
1
make[1]: *** [_module_/usr/local/src/netfilter/ipset-5.0/kernel] Error 2
make[1]: Leaving directory `/usr/local/src/kernel/linux-2.6.36.2'
make: *** [modules] Error 2

I noticed there was a 'netlink.patch' file that I tried to apply to
'/usr/include/linux/netfilter/nfnetlink.h', but it wouldn't: it looks
like your nfnetlink.h is different from mine (can send a copy of the
original if you need it) so I applied manually. Still no go, same error,
probably wrong location? I copied 'nfnetlink.h' into
'kernel/include/linux/netfilter' because ip_set.c seems to look there(?)
but it wasn't there. Still no go. To get around this I dit this:

New file 'kernel/include/linux/netfilter/nfnl.h':

/* netfilter netlink message types are split in two pieces:
* 8 bit subsystem, 8bit operation.
*/

#define NFNL_SUBSYS_ID(x)       ((x & 0xff00) >> 8)
#define NFNL_MSG_TYPE(x)        (x & 0x00ff)

/* No enum here, otherwise __stringify() trick of
MODULE_ALIAS_NFNL_SUBSYS()
* won't work anymore */
#define NFNL_SUBSYS_NONE                0
#define NFNL_SUBSYS_CTNETLINK           1
#define NFNL_SUBSYS_CTNETLINK_EXP       2
#define NFNL_SUBSYS_QUEUE               3
#define NFNL_SUBSYS_ULOG                4
#define NFNL_SUBSYS_OSF                 5
#define NFNL_SUBSYS_IPSET               6
#define NFNL_SUBSYS_COUNT               7

Change in 'kernel/ip_set.c'

--- ip_set.c.orig       2010-12-16 12:26:02.000000000 +0100
+++ ip_set.c    2010-12-18 08:30:47.000000000 +0100
@@ -24,6 +24,10 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/ipset/ip_set.h>
 
+#ifndef NFNL_SUBSYS_IPSET
+#include <linux/netfilter/nfnl.h>
+#endif
+
 static struct list_head ip_set_type_list;      /* all registered set
types */
 static DEFINE_MUTEX(ip_set_type_mutex);                /* protects
ip_set_type_list */
 
After that, 'make modules' for some reason warns about redefines. first
they weren't defined, now they're redefined when I use ifndef? Removing
the include, make -of course- complains again that 'NFNL_SUBSYS_IPSET'
is not defined. Well, I don't know..
Other than that everything seems to compile and install fine.

Finally, when trying the new ipset it seems that except for 'version',
every command I tried returns 'Invalid argument':

(Yes I know this is incorrect syntax, but now I know it's trying to do
something besides giving me 'Invalid argument'.)
# ipset create TEST hash   
ipset v5.0: Syntax error: typename 'hash' is unkown

(As per ipset.8 example.)
# ipset create foo bitmap:ip range 192.168.0.0/16
ipset v5.0: Kernel error received: Invalid argument

# ipset list               
ipset v5.0: Kernel error received: Invalid argument

# lsmod|grep set
ip_set                 16790  0 
nfnetlink               3179  2 ip_set,nf_conntrack_netlink

So, I guess something must have gone wrong when compiling ipset anyhow.


Thanks,
Rob


