From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] Warning: "nd_tbl" [net/ipv6/netfilter/ip6t_ROUTE.ko]
 undefined!
Date: Fri, 22 Apr 2005 20:59:57 +0900 (JST)
Message-ID: <20050422.205957.47968472.yoshfuji@linux-ipv6.org>
References: <200504221331.27454.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pluto@pld-linux.org
In-Reply-To: <200504221331.27454.pluto@pld-linux.org>
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

In article <200504221331.27454.pluto@pld-linux.org> (at Fri, 22 Apr 2005 13:31:27 +0200), Pawel Sikora <pluto@pld-linux.org> says:

> Warning: "nd_tbl" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!
> 
> --- a/net/ipv6/ipv6_syms.c	2005-04-22 13:18:01.000000000 +0200
> +++ b/net/ipv6/ipv6_syms.c	2005-04-22 13:21:28.000000000 +0200
> @@ -36,6 +36,7 @@
>  #ifdef CONFIG_XFRM
>  EXPORT_SYMBOL(xfrm6_rcv);
>  #endif
> +EXPORT_SYMBOL(nd_tbl);
>  EXPORT_SYMBOL(rt6_lookup);
>  EXPORT_SYMBOL(fl6_sock_lookup);
>  EXPORT_SYMBOL(ipv6_push_nfrag_opts);

I disagree. Please try not to use nd_tbl;
maybe, by making and exporting neigh_lookup().
Thanks.

-- 
Hideaki YOSHIFUJI @ USAGI Project <yoshfuji@linux-ipv6.org>
Homepage: http://www.yoshifuji.org/~hideaki/
GPG FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
