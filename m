From: Wang Jian <lark@linux.net.cn>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Thu, 14 Apr 2005 16:35:12 +0800
Message-ID: <20050414162843.032A.LARK@linux.net.cn>
References: <425A5543.9000300@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <425A5543.9000300@ufomechanic.net>
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

Hi Amin Azez,

The patch is not enough at least when compiled using gcc 3.4.


[root@qos linux-2.6.11-w]# make O=/home/QoSTestBuild/ modules                     Using /home/linux-2.6.11-w as source for kernel
  GEN    /home/QoSTestBuild/Makefile
  CHK     include/linux/version.h
  SPLIT   include/linux/autoconf.h -> include/config/*
make[2]: `arch/i386/kernel/asm-offsets.s' is up to date.
  CHK     include/asm-i386/asm_offsets.h
gcc: drivers/atm/../../include/asm/byteorder.h: No such file or directory
gcc: no input files
  CC [M]  net/ipv4/netfilter/ip_conntrack_netlink.o
/home/linux-2.6.11-w/net/ipv4/netfilter/ip_conntrack_netlink.c: In function `ctnetlink_create_conntrack':
/home/linux-2.6.11-w/include/linux/netfilter_ipv4/ip_conntrack.h:344: sorry, unimplemented: inlining failed in call to 'ip_conntrack_free': function body not available
/home/linux-2.6.11-w/net/ipv4/netfilter/ip_conntrack_netlink.c:652: sorry, unimplemented: called from here
/home/linux-2.6.11-w/include/linux/netfilter_ipv4/ip_conntrack.h:346: sorry, unimplemented: inlining failed in call to 'ip_conntrack_insert': function body not available
/home/linux-2.6.11-w/net/ipv4/netfilter/ip_conntrack_netlink.c:656: sorry, unimplemented: called from here
make[4]: *** [net/ipv4/netfilter/ip_conntrack_netlink.o] Error 1
make[3]: *** [net/ipv4/netfilter] Error 2
make[2]: *** [net/ipv4] Error 2
make[1]: *** [net] Error 2
make: *** [modules] Error 2

and net/ipv4/netfilter/ip_conntrack_core.c has the same problem.

The ip_conntrac_free() is defined in ip_conntrack_core.c as inline after
first usage.

Didn't you meet the same problem?


On Mon, 11 Apr 2005 11:45:23 +0100, Amin Azez <azez@ufomechanic.net> wrote:

> Many thanks to Pablo (and Harald whose work was also contained in some 
> of the patches Pablo sent) I now have nfnetlink-ctnetlink modules and 
> libraries working such that ctnltest (part of libctnetlink) returns 
> valid data on open network connections.
> 
> [On note: It seems deliberate that the new nfnetlink module conflicts 
> with ip_queue because both listen on the same netlink socket number 
> NETLINK_FIREWALL (is that the right terminology). Is there a reason for 
> this?]
> 
> I document here the full steps required to make this work on pristine 
> 2.6.11 kernel sources, and I repeat the steps as I write them here so 
> there will be full confidence that the steps are accurate.
> 
> (Perhaps there may be other patches that are desired, such as 
> http://lists.netfilter.org/pipermail/netfilter-devel/2005-April/019177.html)
> 
> This means that only one of these modules can be loaded at a time.
> 
> What is the reason for this?]
> 
> 
> 1) Get the pristine 2.6.11 sources and un-tar
> 
> 2) apply pablos patches from 
> http://people.netfilter.org/pablo/patches/nfnetlink-conntrack-0.50-2.6.11/
> 
> 3) edit net/Kconfig and insert:
> source "net/netfilter/Kconfig"
> just before:
> source "net/ipv4/Kconfig"
> 
> 4) edit net/Makefile
> obj-$(CONFIG_NETFILTER_NETLINK) += netfilter/
> just after:
> obj-$(CONFIG_NET)              += $(tmp-y)
> 
> 5) configure, build and install your kernel and modules
> My config includes:
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_IP_NF_CONNTRACK=m
> CONFIG_IP_NF_CONNTRACK_NETLINK=m
> CONFIG_IP_NF_CT_ACCT=y
> CONFIG_IP_NF_CONNTRACK_MARK=y
> CONFIG_NETFILTER=y
> CONFIG_IP_NF_CONNTRACK_EVENTS=y
> 
> once you done that, reboot to your new kernel (may as well)
> 
> 6) now get libctnetlink from: 
> ftp://ftp.netfilter.org/pub/libctnetlink/snapshot/
> I got the 20050410 snapshot. Possibly newer snapshots will have some of 
> the next patches already attached.
> 
> 7) now get libnfnetlink from:
> ftp://ftp.netfilter.org/pub/libnfnetlink/snapshot/
> I got the 20050410 snapshot. Possibly newer snapshots will have some of 
> the next patches already attached.
> 
> 8) untar both these files from the same dir, and then create a symlink 
> from your libnfnetlink-2005???? folder to libnfnetlink, so that 
> libctnetlink can find it. I did it like this:
> ln -s libnfnetlink-20050410 libnfnetlink
> 
> 9) Get and apply Pablos patches from
> http://lists.netfilter.org/pipermail/netfilter-devel/2005-April/019182.html
> (the last patch in the list is for libnfnetlink, the others are for 
> libctnetlink)
> 
> 10) Apply this patch in libctnetlink to fix the "test/demo" program
> --- ctnltest.c  2005-04-11 14:06:08.000000000 -0400
> +++ ctnltest.c.orig     2005-04-11 13:58:53.000000000 -0400
> @@ -10,7 +10,7 @@
> 
>   #include <linux/types.h>
>   #include <linux/netlink.h>
> -#include <linux/netfilter_ipv4/ip_conntrack_netlink.h>
> +#include <linux/nfnetlink_conntrack.h>
> 
>   #include "libctnetlink.h"
> 
> @@ -115,7 +115,7 @@
>          if (cb[CTA_ORIG]) {
>                  printf("orig: %s\n",
>  
> display_tuple_flat(NFA_DATA(cb[CTA_ORIG])));
> -               ctnl_del_conntrack(cth, NFA_DATA(cb[CTA_ORIG]),CTA_UNSPEC);
> +               ctnl_del_conntrack(cth, NFA_DATA(cb[CTA_ORIG]));
>          }
>          if (cb[CTA_RPLY])
>                  printf("rply: %s\n",
> @@ -169,7 +169,7 @@
>                  exit(2);
>          }
> 
> -       ctnl_wilddump_request(cth, AF_INET, IPCTNL_MSG_GETCONNTRACK);
> +       ctnl_wilddump_request(cth, AF_INET, CTNL_MSG_GETCONNTRACK);
> 
>          while (len = recv(cth->nfnlh.fd, &buf, sizeof(buf), 0)) {
>                  printf("pkt received\n");
> 
> 
> [BTW make sure libnfnetlink and libctnetlink see your new kernel source]
> 
> 11) build libnfnetlink:
> cd libnfnetlink-2005????
> automake-1.4
> autoconf
> ./configure
> make && make install
> 
> 12) build libctnetlink
> cd libctnetlink-2005????
> automake-1.4
> autoconf
> ./configure
> make && make install
> 
> 13) build ctnltest.c with
> gcc -o ctnltest ctnltest.c -L/usr/local/lib \
> -I/opt/KERNEL/linux-2.6.11.6/include/ -lctnetlink -lnfnetlink
> 
> 14) You may need to add /usr/local/lib to /etc/ld.so.conf and run ldconfig
> 
> 15) get kernel modules loaded:
> rmmod ip_queue # cos it conflicts with nfnetlink (used by 
> ip_conntrack_netlink)
> modprobe ip_conntrack_netlink
> 
> 15) try out ctnltest:
> ./ctnltest
> It should print out data on active network connections
> It doesn't print out data on new connections as they form, I don't know 
> if it should.
> 
> 16) .... write your own userspace client based on ctnltest and any 
> documentation you can find?
> 
> Amin
> 



-- 
  lark
