Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72692D7D2F;
	Thu,  9 Oct 2025 09:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760003922; cv=none; b=dwluQvNvfFGEILHeAGq7vfVbUlVyq9o8iCPKW0I3dHM7h4/IHDM0drCik5eQfsyASYgLeHcKLnaO7Ax6YBaQlNYDG3o0Jj7geW5tnrhJCXcRkON+fyVKimyA8jEXkiwMHWnXRlDK1RzT15ytfwXtMtRzcC/Q/iMhZ/DMKZWxGVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760003922; c=relaxed/simple;
	bh=DD3lsW4PC+wA7y7TKHoF4ND4pU/tVKFZUCiXJAORoAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbR8XQnfUlVxfmwIjlaWoW38RiUeduWtshe8Juud09b8FKHqimGswUyvjQwvniKS/oWuRc6ZN1X/uwUmADvp/0tXiclvwIajDlGkAYU5Olqe+Y0TPP1aoPSoQkwgAp/xzn221q+Y23NuXM5YJOYEwoJqLmhRRqd6xUsT0XC2gPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E868E602F8; Thu,  9 Oct 2025 11:58:30 +0200 (CEST)
Date: Thu, 9 Oct 2025 11:58:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Keno Fischer <keno@juliahub.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH] netfilter: Consistently use NFPROTO_, not AF_
Message-ID: <aOeHRv_z-aBFQd4U@strlen.de>
References: <aOcfvmjCTVkUxMYX@juliacomputing.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOcfvmjCTVkUxMYX@juliacomputing.com>

Keno Fischer <keno@juliahub.com> wrote:
> The uapi headers document `nfgen_family` as `AF_*`. However,
> this hasn't been technically true since 7e9c6eeb, which switched
> the interpretation of this field to `NFPROTO_*`.
> This is value-compatible on AF_INET (though note that this is
> NFPROTO_IPV4, *not* NFPROTO_INET), AF_INET6, AF_IPV6 and AF_DECnet,
> and AF_BRIDGE, but has since grown additional values.
> Now, because of the value compatibility between AF_ and
> NFPROTO_, it doesn't matter too much, but to the extent that
> the uapi headers constitute interface documentation, it can be
> misleading. For example, some userspace tooling, such as wireshark
> will print AF_UNIX for netlink packets that have an NFPROTO_INET
> family set. I will submit a patch for this downstream, but I wanted
> to cleanup the kernel side also. To that end, change the comment in
> the UAPI header and audit uses of AF_* in the netfilter code and
> switch them to NFPROTO_ unless calling non-netfilter APIs.

I'm not sold on this patch, lots of code churn for little gain.

> diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
> index 6cd58cd2a6f0..9d7fe3daf327 100644
> --- a/include/uapi/linux/netfilter/nfnetlink.h
> +++ b/include/uapi/linux/netfilter/nfnetlink.h
> @@ -32,7 +32,7 @@ enum nfnetlink_groups {
>  /* General form of address family dependent message.
>   */
>  struct nfgenmsg {
> -	__u8  nfgen_family;		/* AF_xxx */
> +	__u8  nfgen_family;		/* NFPROTO_xxx */
>  	__u8  version;		/* nfnetlink version */
>  	__be16    res_id;		/* resource id */
>  };

Maybe just chase down comments like this and leave the rest alone?

> @@ -690,7 +690,7 @@ module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
>  		  &nf_conntrack_htable_size, 0600);
>  
>  MODULE_ALIAS("ip_conntrack");
> -MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
> -MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
> +MODULE_ALIAS("nf_conntrack-" __stringify(NFPROTO_IPV4));
> +MODULE_ALIAS("nf_conntrack-" __stringify(NFPROTO_IPV6));

This breaks module autloading aliases, __stringify needs a define not enum:

alias:          nf_conntrack-NFPROTO_IPV6
alias:          nf_conntrack-NFPROTO_IPV4

... this NFPROTO_IPV6 should not be there, this needs to be kept as

alias:          nf_conntrack-10
alias:          nf_conntrack-2
