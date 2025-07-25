Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C171510F1
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753456370; cv=none; b=mgOVoCbUhzHZwDNsAaSaNcb1dOADdLyIiZUx12vAZNle6E+LcoOJqBX/OcElveMvjBjdCiEp26NsQmBZZNwwt4/J7HXSZq6rKLQwkgt9BZPFjK9Qr+Z5RWCUG64XooFgbjThG92wSaSdrYfZ8GqNyEvbPMb+ue1PoiVRDoiCfpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753456370; c=relaxed/simple;
	bh=ntoLGOIGmK0QmHRQAyYXWaxshFvS9TUM3pWe2UzCmWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sanr86Vu6MfnsjPVzkEy+PYtqElkLz8w0OtdXVpBzi4aacswmj+MCEHP/zcosLIjyjl8aKXP4Ih0zdFXz7VU7L102rljXzatL6MlA4A1m7N2AIPVEsgMR9euqEjARVbNpOjdcJbIWmo2rdMfuanGNAuJWYYM/8/aV1irrGcHmMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G3iEbsSr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y5EZtk7/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G3iEbsSr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y5EZtk7/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 14A7760279; Fri, 25 Jul 2025 17:12:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753456366;
	bh=FFcUMU0eRU6uOUTcUPkzKCbtkgXgbkPpimhdOAI0T9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G3iEbsSrI4U16dKQqCgKTMpSGRhTO8hBhK1QtXP3nxfb4MpXCIhZ28pRGtm8Rwe7n
	 6jYFcCiSQk2mJxINHC989L/yyz/etHuSPt+jw7wRu2eugAOlDqkZ2xSyI4/jbIwfeR
	 /jiOjzcyiEk2pXkxFd/hYxAuS57pA05Jr7Jcksdz/F6t/2jKMz5VX2jJifDeGI5eyU
	 I9ADEkCXn3WUfpZNt4cbLXfhjsx0v1wVZoWUiId6yy0gs2+RJkBotCw50blNqR1Zb6
	 JwvTIqIYr663s8rItr6nV2X7WRPHcRfCS30gt1pa6W4VCaGxLb5LAhBmPqioftYgBh
	 7XwaK+6j7F6HA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BF34460273;
	Fri, 25 Jul 2025 17:12:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753456365;
	bh=FFcUMU0eRU6uOUTcUPkzKCbtkgXgbkPpimhdOAI0T9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y5EZtk7/5JCCItz9+mWgY1CAi5zqydjQyQsuve+OdzGN54kyZcYlaPR3D28wlw/kw
	 soQIeGInlqqkykIIJPqLQsRVKzSrZKLPRdm4nrDhJirWTeLaBvdp62StVef8c10d7U
	 a5xTzxjhRzdXxEts2vIypTqsreDp+S8JxzVSom1v8wZJ7r7mf+FWPRSMWe7etFHR+g
	 /LoloV+Fx/hCR8CJRW26dfDjTfaSa6F6pCXnr1JP1kJgSvoly9Eg+tXP24yzAITRSm
	 yXCnbiIAeKh/+llCVTSG7AA/1SlmBmkNj9/MFohIBjHC/WyKzzAhIKAd1ubqqd3FNQ
	 UQFFA4cJ6UIcw==
Date: Fri, 25 Jul 2025 17:12:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Introduce
 NFTA_DEVICE_WILDCARD
Message-ID: <aIOe6gUjXTXwR2Nv@calendula>
References: <20250724221150.10502-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250724221150.10502-1-phil@nwl.cc>

Hi Phil,

On Fri, Jul 25, 2025 at 12:00:31AM +0200, Phil Sutter wrote:
> On netlink receive side, this attribute is just another name for
> NFTA_DEVICE_NAME and handled equally. It enables user space to detect
> lack of wildcard interface spec support as older kernels will reject it.
> 
> On netlink send side, it is used for wildcard interface specs to avoid
> confusing or even crashing old user space with non NUL-terminated
> strings in attributes which are expected to be NUL-terminated.

This looks good to me.

> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> While this works, I wonder if it should be named NFTA_DEVICE_PREFIX
> instead and contain NUL-terminated strings just like NFTA_DEVICE_NAME.
> Kernel-internally I would continue using strncmp() and hook->ifnamelen,
> but handling in user space might be simpler.

Pick the name you like.

> A downside of this approach is that we mix NFTA_DEVICE_NAME and
> NFTA_DEVICE_WILDCARD attributes in NFTA_FLOWTABLE_HOOK_DEVS and
> NFTA_HOOK_DEVS nested attributes, even though old user space will reject
> the whole thing and not just take the known attributes and ignore the
> rest.

Old userspace is just ignoring the unknown attribute?

I think upside is good enough to follow this approach: new userspace
version with old kernel bails out with EINVAL, so it is easy to see
that feature is unsupported.

As for netlink attributes coming from the kernel, we can just review
the existing userspace parsing side and see what we can do better in
that regard.

> ---
>  include/uapi/linux/netfilter/nf_tables.h |  1 +
>  net/netfilter/nf_tables_api.c            | 16 +++++++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 2beb30be2c5f..ed85b61afcd8 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1788,6 +1788,7 @@ enum nft_synproxy_attributes {
>  enum nft_devices_attributes {
>  	NFTA_DEVICE_UNSPEC,
>  	NFTA_DEVICE_NAME,
> +	NFTA_DEVICE_WILDCARD,
>  	__NFTA_DEVICE_MAX
>  };
>  #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 04795af6e586..f65b4fba5225 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1959,6 +1959,14 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>  	return -ENOSPC;
>  }
>  
> +static int hook_device_attr(struct nft_hook *hook)
> +{
> +	if (hook->ifname[hook->ifnamelen - 1] == '\0')
> +		return NFTA_DEVICE_NAME;
> +
> +	return NFTA_DEVICE_WILDCARD;
> +}
> +
>  static int nft_dump_basechain_hook(struct sk_buff *skb,
>  				   const struct net *net, int family,
>  				   const struct nft_base_chain *basechain,
> @@ -1990,7 +1998,7 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
>  			if (!first)
>  				first = hook;
>  
> -			if (nla_put(skb, NFTA_DEVICE_NAME,
> +			if (nla_put(skb, hook_device_attr(hook),
>  				    hook->ifnamelen, hook->ifname))
>  				goto nla_put_failure;
>  			n++;
> @@ -1998,6 +2006,7 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
>  		nla_nest_end(skb, nest_devs);
>  
>  		if (n == 1 &&
> +		    hook_device_attr(first) != NFTA_DEVICE_WILDCARD &&
>  		    nla_put(skb, NFTA_HOOK_DEV,
>  			    first->ifnamelen, first->ifname))
>  			goto nla_put_failure;
> @@ -2376,7 +2385,8 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
>  	int rem, n = 0, err;
>  
>  	nla_for_each_nested(tmp, attr, rem) {
> -		if (nla_type(tmp) != NFTA_DEVICE_NAME) {
> +		if (nla_type(tmp) != NFTA_DEVICE_NAME &&
> +		    nla_type(tmp) != NFTA_DEVICE_WILDCARD) {
>  			err = -EINVAL;
>  			goto err_hook;
>  		}
> @@ -9427,7 +9437,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
>  
>  	list_for_each_entry_rcu(hook, hook_list, list,
>  				lockdep_commit_lock_is_held(net)) {
> -		if (nla_put(skb, NFTA_DEVICE_NAME,
> +		if (nla_put(skb, hook_device_attr(hook),
>  			    hook->ifnamelen, hook->ifname))
>  			goto nla_put_failure;
>  	}
> -- 
> 2.49.0
> 
