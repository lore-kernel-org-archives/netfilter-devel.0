From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] netfilter: ctnetlink: force null nat binding on insert
Date: Mon, 17 Feb 2014 14:32:24 +0100
Message-ID: <20140217133224.GD31125@breakpoint.cc>
References: <1392549343-7145-1-git-send-email-fw@strlen.de>
 <20140217103750.GA22363@localhost>
 <20140217104511.GB31125@breakpoint.cc>
 <20140217105856.GA16361@localhost>
 <20140217111519.GC31125@breakpoint.cc>
 <20140217132435.GA4083@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48209 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbaBQNcZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:32:25 -0500
Content-Disposition: inline
In-Reply-To: <20140217132435.GA4083@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I think we can simplify this, the nfnetlink_parse_nat_setup() hook
> function is always called under rcu_read_lock. See patch attached.

Right.  The patch looks good to me.

Acked-by: Florian Westphal <fw@strlen.de>

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index bb322d0..b9f0e03 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1310,27 +1310,22 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
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
> +	ret = ctnetlink_parse_nat_setup(ct, NF_NAT_MANIP_DST,
> +					cda[CTA_NAT_DST]);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ctnetlink_parse_nat_setup(ct, NF_NAT_MANIP_SRC,
> +					cda[CTA_NAT_SRC]);
> +	return ret;
>  #else
> +	if (!cda[CTA_NAT_DST] && !cda[CTA_NAT_SRC])
> +		return 0;
>  	return -EOPNOTSUPP;
>  #endif
>  }
> @@ -1659,11 +1654,9 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
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
> index d3f5cd6..52ca952 100644
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
> @@ -702,9 +708,9 @@ static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
>  
>  static int
>  nfnetlink_parse_nat(const struct nlattr *nat,
> -		    const struct nf_conn *ct, struct nf_nat_range *range)
> +		    const struct nf_conn *ct, struct nf_nat_range *range,
> +		    const struct nf_nat_l3proto *l3proto)
>  {
> -	const struct nf_nat_l3proto *l3proto;
>  	struct nlattr *tb[CTA_NAT_MAX+1];
>  	int err;
>  
> @@ -714,38 +720,46 @@ nfnetlink_parse_nat(const struct nlattr *nat,
>  	if (err < 0)
>  		return err;
>  
> -	rcu_read_lock();
> -	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
> -	if (l3proto == NULL) {
> -		err = -EAGAIN;
> -		goto out;
> -	}
>  	err = l3proto->nlattr_to_range(tb, range);
>  	if (err < 0)
> -		goto out;
> +		return err;
>  
>  	if (!tb[CTA_NAT_PROTO])
> -		goto out;
> +		return 0;
>  
> -	err = nfnetlink_parse_nat_proto(tb[CTA_NAT_PROTO], ct, range);
> -out:
> -	rcu_read_unlock();
> -	return err;
> +	return nfnetlink_parse_nat_proto(tb[CTA_NAT_PROTO], ct, range);
>  }
>  
> +/* This function is called under rcu_read_lock() */
>  static int
>  nfnetlink_parse_nat_setup(struct nf_conn *ct,
>  			  enum nf_nat_manip_type manip,
>  			  const struct nlattr *attr)
>  {
>  	struct nf_nat_range range;
> +	const struct nf_nat_l3proto *l3proto;
>  	int err;
>  
> -	err = nfnetlink_parse_nat(attr, ct, &range);
> +	/* Should not happen, restricted to creating new conntracks
> +	 * via ctnetlink.
> +	 */
> +	if (WARN_ON_ONCE(nf_nat_initialized(ct, manip)))
> +		return -EEXIST;
> +
> +	/* Make sure that L3 NAT is there by when we call nf_nat_setup_info to
> +	 * attach the null binding, otherwise this may oops.
> +	 */
> +	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
> +	if (l3proto == NULL)
> +		return -EAGAIN;
> +
> +	/* No NAT information has been passed, allocate the null-binding */
> +	if (attr == NULL)
> +		return __nf_nat_alloc_null_binding(ct, manip);
> +
> +	err = nfnetlink_parse_nat(attr, ct, &range, l3proto);
>  	if (err < 0)
>  		return err;
> -	if (nf_nat_initialized(ct, manip))
> -		return -EEXIST;
>  
>  	return nf_nat_setup_info(ct, &range, manip);
>  }
> -- 
> 1.7.10.4
> 


-- 
Florian Westphal <fw@strlen.de> // http://www.strlen.de
1024D/F260502D 2005-10-20
Key fingerprint = 1C81 1AD5 EA8F 3047 7555  E8EE 5E2F DA6C F260 502D
Phone: +49 151 11132303
