From: Wang Jian <lark@linux.net.cn>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Thu, 14 Apr 2005 18:15:02 +0800
Message-ID: <20050414175957.0334.LARK@linux.net.cn>
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


On Mon, 11 Apr 2005 11:45:23 +0100, Amin Azez <azez@ufomechanic.net> wrote:

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

This patch is reversed.

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

Yes. automake-1.4 must be used.

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

Looking at the code, it looks like it should

in __ip_conntrack_confirm()

                ip_conntrack_event_cache(master_ct(ct) ?
                                         IPCT_RELATED : IPCT_NEW, *pskb);

But no one calls it.

> 
> 16) .... write your own userspace client based on ctnltest and any 
> documentation you can find?
> 
> Amin
> 



-- 
  lark
