From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: [CRAP] Some patches
Date: Mon, 17 Jun 2002 10:45:38 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020617104538.B8138@sch.bme.hu>
References: <20020616200239.GI23720@stingr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: Paul P Komkoff Jr <i@stingr.net>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020616200239.GI23720@stingr.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Paul P Komkoff Jr ................................... (2002. június 17.)

 Hi!

> But ipv6 stuff seems awful :( it just duplicating one function already
> present in ipv6 code :( and doing it without static keyword ...
Please, read the code again!
In firewall I had to use the ESP and AH headers, too, but the core kernel does
not support it!
But the other side: yes, it's awful, I now. All the code contain the some
search and parser (not exactly the same, but can be changed). While the
patches are in the p-o-m and they are independent ones, I can not create exact
debedencies. (The core ipv6 code will be changed soon, after it the search
function will be placed into it - I can remove it from the extensions.)

> diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/Makefile.in linux-2.4.19-pre10-ac2-s3/net/ipv6/Makefile.in
> diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv6/exthdrs.c linux-2.4.19-pre10-ac2-s3/net/ipv6/exthdrs.c
> --- a/net/ipv6/exthdrs.c	Sat Jun 15 12:49:53 2002
> +++ linux-2.4.19-pre10-ac2-s3/net/ipv6/exthdrs.c	Fri Jun 14 20:03:51 2002
> @@ -20,6 +20,8 @@
>   *				  tlv options.
>   */
>  
> +#include <linux/config.h>
> +#include <linux/module.h>
>  #include <linux/errno.h>
>  #include <linux/types.h>
>  #include <linux/socket.h>
> @@ -729,6 +731,8 @@
>  		 (nexthdr == NEXTHDR_NONE)	||
>  		 (nexthdr == NEXTHDR_DEST) );
>  }
> +
> +EXPORT_SYMBOL(ipv6_ext_hdr);
>  
>  /*
>   * Skip any extension headers. This is used by the ICMP module.
It would be nice, but it is not the Netfilter code. (And these patches are in
p-o-m.)
The exported function:
int ipv6_ext_hdr(u8 nexthdr)
{
        return ( (nexthdr == NEXTHDR_HOP)       ||
                 (nexthdr == NEXTHDR_ROUTING)   ||
                 (nexthdr == NEXTHDR_FRAGMENT)  ||
                 (nexthdr == NEXTHDR_AUTH)      ||
                 (nexthdr == NEXTHDR_NONE)      ||
                 (nexthdr == NEXTHDR_DEST) );
}

> -int ipv6_ext_hdr(u8 nexthdr)
> -{
> -        return ( (nexthdr == NEXTHDR_HOP)       ||
> -                 (nexthdr == NEXTHDR_ROUTING)   ||
> -                 (nexthdr == NEXTHDR_FRAGMENT)  ||
> -                 (nexthdr == NEXTHDR_AUTH)      ||
> -                 (nexthdr == NEXTHDR_ESP)       ||
> -                 (nexthdr == NEXTHDR_NONE)      ||
> -                 (nexthdr == NEXTHDR_DEST) );
> -}

(Yes, I know that is a real problem, I'll solve it gracefullly, I promise! :) )

Regards,

	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /-----Member of the BUTE-MIS-SEARCHlab---------->
