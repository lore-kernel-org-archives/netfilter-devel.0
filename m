From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] iptables: Sort table names in ip[6]tables-save
Date: Fri, 30 Aug 2013 23:11:58 +0200
Message-ID: <20130830211158.GA3850@localhost>
References: <20130731202107.GA12949@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46270 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab3H3VMD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:12:03 -0400
Content-Disposition: inline
In-Reply-To: <20130731202107.GA12949@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Wed, Jul 31, 2013 at 01:21:07PM -0700, Phil Oester wrote:
> Depending upon the load order of rules, the output from ip[6]tables-save
> will vary, as ip[6]_tables_names is sorted LIFO.  As reported by
> Linus van Geuns, this makes comparing output from ip[6]tables-save across
> reboots difficult.  Attached are two patches which attempt to fix this.
> 
>   1) Sort by default - add 'u' option to unsort
>   2) Unsorted by default - add 's' option to sort

I think we should just sorted it inconditionally. I don't get how that
can be useful for any interesting purpose.

More comments below:

> diff --git a/include/xtables.h b/include/xtables.h
> index c35a6e6..dc6e566 100644
> --- a/include/xtables.h
> +++ b/include/xtables.h
> @@ -479,6 +479,8 @@ extern void xtables_ip6parse_any(const char *, struct in6_addr **,
>  extern void xtables_ip6parse_multiple(const char *, struct in6_addr **,
>  	struct in6_addr **, unsigned int *);
>  
> +extern int stringcmp(const void *, const void *);

Please, no new function into libxtables for this. Better define it
internally to iptables-save and ip6tables-save.

I also have to ask you to make a patch for iptables-nftables, so we
obtain the same behaviour in xtables-save.

Thanks.
