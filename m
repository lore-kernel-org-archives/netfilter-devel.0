From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Fri, 08 Apr 2005 13:29:04 +0100
Message-ID: <42567910.4090601@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>	<4254265F.6080607@eurodev.net>	<42554200.3020405@ufomechanic.net>	<42555F99.8010201@ufomechanic.net>	<42564BA6.3040702@ufomechanic.net>
	<42564FAA.2050302@eurodev.net>	<425658A8.6050200@ufomechanic.net>
	<42565AB4.5000803@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070500050102030100050008"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42565AB4.5000803@eurodev.net>
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
--------------070500050102030100050008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[attached is a candidate patch for ctnltest.c]

Pablo Neira wrote:
> Amin Azez wrote:
>> I seem to have missed something obvious, is that libctnetlink 
>> dependancy out of date?
> 
> 
> yes, include files have changed its location.

Thanks for the patches Pablo, they seemed to do the trick.
ctnl_del_conntrack has been expanded to 3 args, should I be using 
CTA_UNSPEC or CTA_ORIG or CTA_STATUS as the 3rd arg on line 118 of 
ctnltest.c?

ctnl_del_conntrack(cth, NFA_DATA(cb[CTA_ORIG]),XXXXX);

For the record, to help those who follow, to get libctnetlink and 
libnfnetlink working, here are the instructions.

1) unpack the pristine kernel sources of 2.6.11
2) apply pablos patches from 
http://people.netfilter.org/pablo/patches/nfnetlink-conntrack-0.50-2.6.11/
3) build and install your kernel & modules with all the right NF options 
enabled
4) unpack a recent libctnetlink from 
ftp://ftp.netfilter.org/pub/libctnetlink/snapshot/
5) run:
   automake-1.4
   autoconf
6) unpack a recent libnfnetlink from 
ftp://ftp.netfilter.org/pub/libnfnetlink/snapshot/
make a symlink from libnfnetlink-2005xxxx to libnfnetlink so that 
libctnetlink can find it
7) run:
   automake-1.4
   autoconf
8) inside the libctnetlink dir
./configure
make
make install
9) inside the libnfnetlink dir
./configure
make
make install

Attached is my candidate patch for ctnltest.c which can be compiled with:
gcc -o ctnltest ctnltest.c -L/usr/local/lib 
-I/opt/KERNEL/linux-2.6.11.6/include/ -lctnetlink -lnfnetlink

(you might need to put /usr/local/lib in your /etc/ld.so.conf and run 
ldconfig)


--------------070500050102030100050008
Content-Type: text/x-patch;
 name="ctnltest.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnltest.patch"

--- ctnltest.c.orig     2005-04-08 15:38:22.000000000 -0400
+++ ctnltest.c  2005-04-08 16:18:58.000000000 -0400
@@ -10,7 +10,7 @@

 #include <linux/types.h>
 #include <linux/netlink.h>
-#include <linux/nfnetlink_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_netlink.h>

 #include "libctnetlink.h"

@@ -115,7 +115,7 @@
        if (cb[CTA_ORIG]) {
                printf("orig: %s\n",
                                display_tuple_flat(NFA_DATA(cb[CTA_ORIG])));
-               ctnl_del_conntrack(cth, NFA_DATA(cb[CTA_ORIG]));
+               ctnl_del_conntrack(cth, NFA_DATA(cb[CTA_ORIG]),CTA_UNSPEC);
        }
        if (cb[CTA_RPLY])
                printf("rply: %s\n",
@@ -169,7 +169,7 @@
                exit(2);
        }

-       ctnl_wilddump_request(cth, AF_INET, CTNL_MSG_GETCONNTRACK);
+       ctnl_wilddump_request(cth, AF_INET, IPCTNL_MSG_GETCONNTRACK);

        while (len = recv(cth->nfnlh.fd, &buf, sizeof(buf), 0)) {
                printf("pkt received\n");

--------------070500050102030100050008--
