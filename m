From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: ctnetlink: force null nat binding on insert
Date: Mon, 17 Feb 2014 11:37:50 +0100
Message-ID: <20140217103750.GA22363@localhost>
References: <1392549343-7145-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59404 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaBQKh4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:37:56 -0500
Content-Disposition: inline
In-Reply-To: <1392549343-7145-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Sun, Feb 16, 2014 at 12:15:43PM +0100, Florian Westphal wrote:
> Quoting Andrey Vagin:
>   When a conntrack is created  by kernel, it is initialized (sets
>   IPS_{DST,SRC}_NAT_DONE_BIT bits in nf_nat_setup_info) and only then it
>   is added in hashes (__nf_conntrack_hash_insert), so one conntract
>   can't be initialized from a few threads concurrently.
> 
>   ctnetlink can add an uninitialized conntrack (w/o
>   IPS_{DST,SRC}_NAT_DONE_BIT) in hashes, then a few threads can look up
>   this conntrack and start initialize it concurrently. It's dangerous,
>   because BUG can be triggered from nf_nat_setup_info.
> 
> Fix this race by always setting up nat, even if no CTA_NAT_ attribute
> was requested before inserting the ct into the hash table.
> 
> In absence of CTA_NAT_ attribute, a null binding is created.
> 
> This alters current behaviour:
> Before this patch, the first packet matching the newly injected
> conntrack would be run through the nat table since nf_nat_initialized()
> returns false.  IOW, this forces ctnetlink users to specify the desired
> nat transformation on ct creation time.
> 
> Reported-By: Andrey Vagin <avagin@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Change since v1: fix OOPS when L3 conntrack module is not loaded.
> 
>  Caused by nf_nat_setup_info -> get_unique_tuple() which will
>  call __nf_nat_l4proto_find() but thats only possible when l3 module
>  is loaded, else null-ptr deref.
> 
>  For the non-ctnetlink case the l3 module must be there, else we cannot
>  end up in this function.  Thus I did not want to add tests there
>  and instead added a pre-check when adding null binding via ctnetlink.
> 
>  Not very nice, perhaps someone has better idea
>  [ look in patch for comment in nfnetlink_attach_null_binding() ]
> 
>  net/netfilter/nf_conntrack_netlink.c | 37 +++++++++++---------------
>  net/netfilter/nf_nat_core.c          | 51 +++++++++++++++++++++++++++++++-----
>  2 files changed, 61 insertions(+), 27 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index bb322d0..40299a6 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1310,27 +1310,24 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
>  }
>  
>  static int
> -ctnetlink_change_nat(struct nf_conn *ct, const struct nlattr * const cda[])
> +ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
>  {
>  #ifdef CONFIG_NF_NAT_NEEDED
>  	int ret;
>  
> -	if (cda[CTA_NAT_DST]) {
> -		ret = ctnetlink_parse_nat_setup(ct,
> -						NF_NAT_MANIP_DST,
> -						cda[CTA_NAT_DST]);
> -		if (ret < 0)
> -			return ret;
> -	}
> -	if (cda[CTA_NAT_SRC]) {
> -		ret = ctnetlink_parse_nat_setup(ct,
> -						NF_NAT_MANIP_SRC,
> -						cda[CTA_NAT_SRC]);
> -		if (ret < 0)
> -			return ret;
> -	}
> -	return 0;
> +	ret = ctnetlink_parse_nat_setup(ct,
> +					NF_NAT_MANIP_DST,
> +					cda[CTA_NAT_DST]);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ctnetlink_parse_nat_setup(ct,
> +					NF_NAT_MANIP_SRC,
> +					cda[CTA_NAT_SRC]);
> +	return ret;
>  #else
> +	if (!cda[CTA_NAT_DST] && !cda[CTA_NAT_SRC])
> +		return 0;
>  	return -EOPNOTSUPP;
>  #endif
>  }
> @@ -1659,11 +1656,9 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>  			goto err2;
>  	}
>  
> -	if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
> -		err = ctnetlink_change_nat(ct, cda);
> -		if (err < 0)
> -			goto err2;
> -	}
> +	err = ctnetlink_setup_nat(ct, cda);
> +	if (err < 0)
> +		goto err2;
>  
>  	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
>  	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index d3f5cd6..c8ba395 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -432,15 +432,15 @@ nf_nat_setup_info(struct nf_conn *ct,
>  }
>  EXPORT_SYMBOL(nf_nat_setup_info);
>  
> -unsigned int
> -nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
> +static unsigned int
> +__nf_nat_alloc_null_binding(struct nf_conn *ct, enum nf_nat_manip_type manip)
>  {
>  	/* Force range to this IP; let proto decide mapping for
>  	 * per-proto parts (hence not IP_NAT_RANGE_PROTO_SPECIFIED).
>  	 * Use reply in case it's already been mangled (eg local packet).
>  	 */
>  	union nf_inet_addr ip =
> -		(HOOK2MANIP(hooknum) == NF_NAT_MANIP_SRC ?
> +		(manip == NF_NAT_MANIP_SRC ?
>  		ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3 :
>  		ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3);
>  	struct nf_nat_range range = {
> @@ -448,7 +448,13 @@ nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
>  		.min_addr	= ip,
>  		.max_addr	= ip,
>  	};
> -	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
> +	return nf_nat_setup_info(ct, &range, manip);
> +}
> +
> +unsigned int
> +nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
> +{
> +	return __nf_nat_alloc_null_binding(ct, HOOK2MANIP(hooknum));
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_alloc_null_binding);
>  
> @@ -734,6 +740,33 @@ out:
>  }
>  
>  static int
> +nfnetlink_attach_null_binding(struct nf_conn *ct,
> +			      enum nf_nat_manip_type manip)
> +{
> +	int ret = -EAGAIN;
> +	bool can_alloc;
> +
> +	/* This looks bogus, but its important.
> +	 *
> +	 * We cannot be sure that L3 NAT is available.
> +	 *
> +	 * If it is not, we will oops in nf_nat_setup_info when we try
> +	 * to fetch the l4 nat protocol (which would be on top of the l3 one).
> +	 *
> +	 * Normally nf_nat_setup_info cannot be called without L3 nat
> +	 * available, but this function is invoked from ctnetlink.
> +	 */
> +	rcu_read_lock();
> +
> +	can_alloc = !!__nf_nat_l3proto_find(nf_ct_l3num(ct));
> +	if (can_alloc)
> +		ret = __nf_nat_alloc_null_binding(ct, manip);
> +
> +	rcu_read_unlock();
> +	return ret;

I think we should always do the module autoloading for nf-nat and
nf-nat-ipvX modules depending on nf_ct_l3num(ct), then return EAGAIN
to give another retry. Now, this needs to happen in any case, not only
when calling ctnetlink_parse_nat_setup().
