From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data (formerly entry_data)
Date: Wed, 21 Jun 2006 02:30:25 +0200
Message-ID: <44989321.2000106@trash.net>
References: <200606050029.08602.max@nucleus.it>
	<200606201325.02775.max@nucleus.it> <4497F561.4000503@trash.net>
	<200606210203.33209.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606210203.33209.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Tuesday 20 June 2006 3:17 pm, Patrick McHardy wrote:
> 
> 
>>The case of just needing a pointer is just an optimization for a
>>special-case in my opinion (avoid lookup of globally shared state),
>>per-instance state is probably more common. So I'd suggest to go
>>with the second possibility.
> 
> 
> Is this better?
> I'll send an example of its use in a few minutes.

Very nice, thanks.

> diff -Nru linux-2.6.17.1/net/ipv4/netfilter/ip_tables.c linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ip_tables.c
> --- linux-2.6.17.1/net/ipv4/netfilter/ip_tables.c	2006-06-20 11:31:55.000000000 +0200
> +++ linux-2.6.17.1-priv_data_core/net/ipv4/netfilter/ip_tables.c	2006-06-21 00:49:12.000000000 +0200
> @@ -519,10 +522,20 @@
>  	if (ret)
>  		goto err;
>  
> +	if (match->priv_size) {
> +		m->u.kernel.priv_data = kzalloc(match->priv_size,
> +					      GFP_KERNEL);
> +		if (!m->u.kernel.priv_data) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +	}
> +

I think this should be done somewhere in x_tables. I think I would
rename xt_check_match to xt_init_match, put the allocation there
and finally rename ->checkentry to ->init .. the name doesn't really
fit anymore since people started doing real initialization in there,
and changing prototypes is a good opportunity for fixing that.
