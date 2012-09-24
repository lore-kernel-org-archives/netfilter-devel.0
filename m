From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] Inter-match communication cache
Date: Mon, 24 Sep 2012 11:57:07 +0200
Message-ID: <20120924095707.GA19084@1984>
References: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53698 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab2IXJ5P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:57:15 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Tue, Sep 18, 2012 at 11:01:34PM +0200, Jozsef Kadlecsik wrote:
> Hi,
> 
> I propose a small cache for inter-match communication purpose:
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 8d674a7..f07eab2 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -216,6 +216,9 @@ struct xt_action_param {
>  		const void *matchinfo, *targinfo;
>  	};
>  	const struct net_device *in, *out;
> +#ifdef CONFIG_NETFILTER_XTABLES_CACHE
> +	u_int32_t cache;
> +#endif

I think you can implement this by means of one per-CPU cache inside
the xt_set match.

Check the old per-CPU event cache in net/netfilter/nf_conntrack_ecache.c.
We used to have something similar.

I'd prefer this approach rather than one change in xtables for this.
It still seems to me too specific of your xt_set extensions.

It will remain internal of xt_set match, but we can revisit this later
on to generalize it if it becomes interesting for more matches.
