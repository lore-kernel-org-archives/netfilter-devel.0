From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH-2.4-POM] NF_REPEAT was ignored !
Date: Fri, 24 Oct 2003 00:08:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031023220833.GB13864@alpha.home.local>
References: <20031022102556.GA10540@alpha.home.local> <Pine.LNX.4.33.0310232349181.20545-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0310232349181.20545-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Oct 24, 2003 at 12:02:03AM +0200, Jozsef Kadlecsik wrote:
 
> Well spotted problem and the fix is correct. But I'd better apply
> a sligthly modified version which does not add one more condition to the
> conntrack core:
> 
> --- linux/net/ipv4/netfilter/ip_conntrack_core.c.orig	2003-10-23 23:43:20.000000000  +0200
> +++ linux/net/ipv4/netfilter/ip_conntrack_core.c	2003-10-23 23:46:03.000000000  +0200
> @@ -838,11 +838,12 @@
>  	IP_NF_ASSERT((*pskb)->nfct);
> 
>  	ret = proto->packet(ct, *pskb, ctinfo);
> -	if (ret == -1) {
> -		/* Invalid */
> +	if (ret < 0 ) {
> +		/* Invalid: inverse of the return code tells
> +		   to netfilter core what to do. */
> 		nf_conntrack_put((*pskb)->nfct);
>  		(*pskb)->nfct = NULL;
> -		return NF_ACCEPT;
> +		return -ret;
>  	}
> 
>  	if (ret != NF_DROP && ct->helper) {
> 
> with the slight modification of the TCP window tracking code by returning
> -NF_REPEAT instead of NF_REPEAT.

That's a very clever way of doing it ! But in case other ->packet() functions
one day rely on NF_REPEAT, perhaps it's a bit risky, or the documentation
should be extended to state clearly that negative values will lead to the
->nfct being dropped and the opposite value to be returned.

> > I've not checked yet if the mainline conntrack code is also affected, but this
> > could be possible.
> 
> No, that does not handle reopening at all.

In fact yes, the conntrack code can do it but nothing uses it. It should be
safer to apply the same patch to keep the code in sync.

Cheers,
Willy
