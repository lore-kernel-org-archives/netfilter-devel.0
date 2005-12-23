From: "m.innocenti@cineca.it" <m.innocenti@cineca.it>
Subject: Re: ipt_limit patch for iptables-1.3.1 and linux-2.4.22
Date: Fri, 23 Dec 2005 14:40:24 +0100 (MET)
Message-ID: <43ABFE4B.6040102@cineca.it>
References: <5210898791.20051223141249@uu3.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <5210898791.20051223141249@uu3.net>
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

borg@uu3.net ha scritto:
> Hello.
> 
> Here is very small patch adding ! functionnality to
> ipt_limit (iptables -m limit).

I've sent in october a similar patch in witch were present the same
errors that are present in yours.
Namely
 - "0 ^ r->invert" and "1 ^ r->invert" are not very clear
 - it break the userspace. This problem is solved using versions.

Look for the thread with the subject
"NETFILTER: add support for invert condition (!) in ipt_limit". My last
patch (20 Oct) should be correct. Please review it.


> Thanks to this patch, you can easly filter SYNs attack to
> your host.. and also limit your lusers trying to do
> SYNs attack.
> 
> Simple example:
> iptables -t mangle -A FORWARD -i eth0 -s 1.2.3.4 \
> -p tcp --tcp-flags SYN SYN \
> -m limit ! --limit 2/s -- limit-burst 10 -j DROP
> Forwarding only 2 SYNs per second (burst up to 10 conn per sec).
> (You can put it in filter table, I used mangle since when packet
> is not dropping, it goes to my QoS tables)
> 
> To apply this patch simply run:
> # cd /usr/src/linux
> # patch -p1 < ipt_limit-linux-2.4.22.patch
> 
> And patch userland iptables
> # cd iptables-1.3.1
> # patch -p1 < ipt_limit-iptables-1.3.1.patch
> 
> Recompile kernel (dont forget about clean)
> recompile and install new iptables
> Install kernel.
> Reboot.. vioala..
> 
> I hope it will get to the mainstream very soon!
> Im still suprised why its not here already..
> It adds extra functionality w/o security risks nor
> performance loss.
> 
> Files:
> ftp://ftp.benet.uu3.net/pub/linux/ipt_limit-linux-2.4.22.patch
> ftp://ftp.benet.uu3.net/pub/linux/ipt_limit-iptables-1.3.1.patch
> 
> Regards,
> Borg
> 
> == File 'ipt_limit-linux-2.4.22.patch' ==============================
> --- linux-2.4.22.orig/include/linux/netfilter_ipv4/ipt_limit.h  2005-12-23 13:07:30.000000000 +0100
> +++ linux-2.4.22/include/linux/netfilter_ipv4/ipt_limit.h       2005-12-22 13:33:56.000000000 +0100
> @@ -10,6 +10,11 @@
>         u_int32_t avg;    /* Average secs between packets * scale */
>         u_int32_t burst;  /* Period multiplier for upper limit. */
>  
> +       /* Borg
> +       adding invert support
> +       */
> +       char invert;
> +
>         /* Used internally by the kernel */
>         unsigned long prev;
>         u_int32_t credit;
> --- linux-2.4.22.orig/net/ipv4/netfilter/ipt_limit.c    2005-12-23 13:07:30.000000000 +0100
> +++ linux-2.4.22/net/ipv4/netfilter/ipt_limit.c 2005-12-22 12:40:35.000000000 +0100
> @@ -63,11 +63,11 @@
>                 /* We're not limited. */
>                 r->credit -= r->cost;
>                 spin_unlock_bh(&limit_lock);
> -               return 1;
> +               return 1 ^ r->invert;
>         }
>  
>                 spin_unlock_bh(&limit_lock);
> -       return 0;
> +       return 0 ^ r->invert;
>  }
>  
>  /* Precision saver. */
> =====================================================================
> 
> == File 'ipt_limit-linux-2.4.22.patch' ==============================
> --- iptables-1.3.1-orig/extensions/libipt_limit.c       2005-12-22 11:38:38.000000000 +0100
> +++ iptables-1.3.1/extensions/libipt_limit.c    2005-12-22 13:33:03.000000000 +0100
> @@ -12,7 +12,8 @@
>  #include <stddef.h>
>  #include <linux/netfilter_ipv4/ip_tables.h>
>  /* For 64bit kernel / 32bit userspace */
> -#include "../include/linux/netfilter_ipv4/ipt_limit.h"
> +//#include "../include/linux/netfilter_ipv4/ipt_limit.h"
> +#include "linux/netfilter_ipv4/ipt_limit.h"
>  
>  #define IPT_LIMIT_AVG  "3/hour"
>  #define IPT_LIMIT_BURST        5
> @@ -120,9 +121,12 @@
>                 return 0;
>         }
>  
> -       if (invert)
> -               exit_error(PARAMETER_PROBLEM,
> -                          "limit does not support invert");
> +       if (invert) {
> +               /* Borg
> +               Adding invert support
> +               */
> +               r->invert = 1;
> +       }
>  
>         return 1;
>  }
> =====================================================================
> 
> 
> 
> 


-- 
**********************************************************************
Marco Innocenti              Gruppo Infrastruttura e Sicurezza
CINECA                       phone:+39 0516171553 / fax:+39 0516132198
Via Magnanelli 6/3           e-mail: innocenti@cineca.it
40033 Casalecchio di Reno    Bologna (Italia)
**********************************************************************
