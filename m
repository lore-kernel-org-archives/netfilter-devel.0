From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Hacking iptables 1.3.5 for 2.6.17
Date: Fri, 30 Jun 2006 20:57:18 +0900 (JST)
Message-ID: <200606301157.k5UBvJTl016149@toshiba.co.jp>
References: <e82pqq$3es$1@sea.gmane.org>
	<200606300948.k5U9mNot001866@toshiba.co.jp>
	<44A50091.7070003@ufomechanic.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net
In-Reply-To: <44A50091.7070003@ufomechanic.net>
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

From: Amin Azez <azez@ufomechanic.net>
Date: Fri, 30 Jun 2006 11:44:33 +0100

> Well, my src/linux-2.6.17.1/include/linux/config.h (line 6) tries to
> include linux/autoconf.h, which is now part of the O=dir build output.
> If it can't find my build autoconf.h then it falls back to
> /usr/include/linux/autoconf.h which is:
> #error Invalid kernel header included in userspace
> 
> In case this much is bogus, here are the include dependancies;
> 
> Extensions found: IPv4:CLUSTERIP IPv4:connbytes IPv4:dccp IPv4:recent
> IPv4:string IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst
> IPv6:REJECT IPv6:rt
> cc -O2 -Wall -Wunused -I/opt/KERNEL/linux-2.6.17.1//include -Iinclude/
> -DIPTABLES_VERSION=\"1.3.5-20060629\" -D_UNKNOWN_KERNEL_POINTER_SIZE
> -fPIC -o extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
> In file included from /opt/KERNEL/linux-2.6.17.1/include/linux/config.h:6,
> from /opt/KERNEL/linux-2.6.17.1/include/linux/netfilter_ipv4.h:8,
> from /opt/KERNEL/linux-2.6.17.1/include/linux/netfilter_ipv4/ip_tables.h:26,
> from include/libiptc/libiptc.h:6,
> from include/iptables.h:5,
> from extensions/libipt_ah.c:8:
> /usr/include/linux/autoconf.h:1:2: #error Invalid kernel header included
> in usersp

I was seeing the recent git tree that the above problem was fixed.

As you says, netfilter_ipv4.h in 2.6.17.x has unnecessary
'#include <config.h>' outside of __KERNEL__. But it seemd to be deleted
in recent kernel as follows.

> commit 62c4f0a2d5a188f73a94f2cb8ea0dba3e7cf0a7f
> Author: David Woodhouse <dwmw2@infradead.org>
> Date:   Wed Apr 26 12:56:16 2006 +0100
> 
>     Don't include linux/config.h from anywhere else in include/
> 
>     Signed-off-by: David Woodhouse <dwmw2@infradead.org> 

I don't think/know that this goes to stable tree, though.

-- Yasuyuki Kozakai
