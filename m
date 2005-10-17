From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!) in
 ipt_limit
Date: Mon, 17 Oct 2005 18:45:47 +0900 (JST)
Message-ID: <20051017.184547.117007327.yoshfuji@linux-ipv6.org>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: m.innocenti@cineca.it
In-Reply-To: <20051017094417.GA26911@pc-innocenti.cineca.it>
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

Hello.

In article <20051017094417.GA26911@pc-innocenti.cineca.it> (at Mon, 17 Oct 2005 11:44:17 +0200), Marco Innocenti <m.innocenti@cineca.it> says:

> --- linux-2.6.13.4/net/ipv4/netfilter/ipt_limit.c	2005-10-10 20:54:29.000000000 +0200
> +++ linux-2.6.13.4.mio/net/ipv4/netfilter/ipt_limit.c	2005-10-15 16:30:23.000000000 +0200
> @@ -82,11 +82,11 @@ ipt_limit_match(const struct sk_buff *sk
>  		/* We're not limited. */
>  		r->credit -= r->cost;
>  		spin_unlock_bh(&limit_lock);
> -		return 1;
> +		return 1 ^ r->invert;
>  	}

!r->invert

>  
>         	spin_unlock_bh(&limit_lock);
> -	return 0;
> +	return 0 ^ r->invert;

!!r->invert

--yoshfuji
