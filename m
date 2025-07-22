Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812DD33062
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 02:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753152430; cv=none; b=UvQQD12zPhbBFakuEU9dN/8EE7wMZSXgwvT+FS0PfDGLd4ItrqquqpCHXoxqUDlDbAbIw5AlgbrP/63/yXEMceLQnQzH+nsDliih6wZClBlmkFioSytmkVJWvt9k9y2I9ojlRGf83NG70ABXXXp8xNoWGvU8NArHys1M6Crt5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753152430; c=relaxed/simple;
	bh=lnn0CxLWd/VzXlpXwZKcWwtkTjXI9PfI9gbJcEUmwFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kE1k51iFQZ+U51Snr4LEX74DKz05iWfWwOi5gUkg4XJzeYY8gKi977+dwMtyx7zu3RMGYeUtSdyKnx45qmY9OI+qGYcevtWdC1XRn7bYsYWy+fuFGKM5biQbiErm/MmJVBX/SdeqOAQSas5A/Sj1q/SUqPqCJQDp9Jd8/ftPun4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wK7Ak52g; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dBNfkijT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wK7Ak52g";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dBNfkijT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B8C8560276; Tue, 22 Jul 2025 04:47:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753152425;
	bh=T7kFgd8ieeOc7w179kRbA67XxjeIq5F8PkdMGwSJLk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wK7Ak52gHraHVF63EjKb+WD5sytaurjB/eKymMi/PqOeXx9PMsiT+sjQrYM9tFjfi
	 8aoXqYLiYxmwPAsgAu7h4QCmqFEMmRkMYUUeNjkTk/no+6XLUpsnrfLACYA/LOL7X9
	 QRnDjlR3NBgrEGi5IRMhRivjP0tzmJHgV0XJZLzKJVU5PS0Wm8XSZ547JF/YUshe58
	 k06ElQWqY7snjUphRbr/Qub0yTOrOgAa8warbOQD6WKTFmN2K3CbGvwZo3HpHdN802
	 N9fiLAHsgx75KaG4IUZI2J84xs8H6iAczd5oX1tKnx567eMKhzsihKATLMq0mLNuDZ
	 MJKTdfeTvoUKw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2B01D6026E;
	Tue, 22 Jul 2025 04:47:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753152424;
	bh=T7kFgd8ieeOc7w179kRbA67XxjeIq5F8PkdMGwSJLk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dBNfkijTYlYeOx9gWVJ4/OzSqph9oaHCqTaJI8zIiememNx3orr0i9HA6y1RTn9cX
	 tfgng/r0aGq5HBmW6o5fbnxXPkPkFEfSmLsqIwClgQ7ZpZVBnWGMmZpHp7/+aw0XJS
	 iR2pioUy7Bb45lwbwlneeWjdlFob+5/E3kZgBJFWJIIxauYspKP6lgC2zxU+0G8am/
	 w5ceasvJ+pXIdG3SUbUVTdebE5I8ZqiIULFQMw94IttdC9BD06NlDx3mzeEiErCgSf
	 AcigveOgc97u1rJVWIrlFqJT+X3GFaDhNBzlWl7Peepy/oEJjFggdCQG7/jwEVMpXY
	 uhIcAwbyfqJ2A==
Date: Tue, 22 Jul 2025 04:46:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Add helpers for interface name wildcards
Message-ID: <aH77oyMqwmO3x3V9@calendula>
References: <20250716132209.20372-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250716132209.20372-1-phil@nwl.cc>

Hi Phil,

On Wed, Jul 16, 2025 at 03:22:06PM +0200, Phil Sutter wrote:
> Support simple (suffix) wildcards in NFTNL_CHAIN_DEV(ICES) and
> NFTA_FLOWTABLE_HOOK_DEVS identified by non-NUL-terminated strings. Add
> helpers converting to and from the human-readable asterisk-suffix
> notation.

We spent some time discussing scenarios where host and container could
use different userspace versions (older vs. newer).

In this case, newer version will send a string without the trailing
null character to the kernel. Then, the older version will just
_crash_ when parsing the netlink message from the kernel because it
expects a string that is nul-terminated (and we cannot fix an old
libnftnl library... it is not possible to fix the past, but it is
better if you can just deal with it).

I suggest you maybe pass the * at the end of the string to the kernel
so nft_netdev_hook_alloc() can just handle this special case and we
always have a nul-terminated string? There is ifnamelen which does in
the kernel what you need to compare the strings, while ifname can
still contain the *.

Worth a fix? Not much time ahead, but we are still in -rc7.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v3:
> - Use uint16_t for 'attr' parameter and size_t for internal 'len'
>   variable
> - nftnl_attr_get_ifname to return allocated buffer, 'attr' parameter may
>   be const
> 
> Changes since v2:
> - Use 'nftnl' prefix for introduced helpers
> - Forward-declare struct nlattr to avoid extra include in utils.h
> - Sanity-check array indexes to avoid out-of-bounds access
> ---
>  include/utils.h |  6 ++++++
>  src/chain.c     |  8 +++++---
>  src/flowtable.c |  2 +-
>  src/str_array.c |  2 +-
>  src/utils.c     | 31 +++++++++++++++++++++++++++++++
>  5 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/include/utils.h b/include/utils.h
> index 247d99d19dd7f..f232e7e2f3dd7 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -83,4 +83,10 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
>  int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
>  		       uint16_t attr, const void *data, uint32_t data_len);
>  
> +struct nlattr;
> +
> +void nftnl_attr_put_ifname(struct nlmsghdr *nlh,
> +			   uint16_t attr, const char *ifname);
> +char *nftnl_attr_get_ifname(const struct nlattr *attr);
> +
>  #endif
> diff --git a/src/chain.c b/src/chain.c
> index 895108cddad51..b401526c367fb 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -457,14 +457,14 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
>  		mnl_attr_put_u32(nlh, NFTA_HOOK_PRIORITY, htonl(c->prio));
>  
>  	if (c->flags & (1 << NFTNL_CHAIN_DEV))
> -		mnl_attr_put_strz(nlh, NFTA_HOOK_DEV, c->dev);
> +		nftnl_attr_put_ifname(nlh, NFTA_HOOK_DEV, c->dev);
>  	else if (c->flags & (1 << NFTNL_CHAIN_DEVICES)) {
>  		struct nlattr *nest_dev;
>  		const char *dev;
>  
>  		nest_dev = mnl_attr_nest_start(nlh, NFTA_HOOK_DEVS);
>  		nftnl_str_array_foreach(dev, &c->dev_array, i)
> -			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
> +			nftnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME, dev);
>  		mnl_attr_nest_end(nlh, nest_dev);
>  	}
>  
> @@ -648,7 +648,9 @@ static int nftnl_chain_parse_hook(struct nlattr *attr, struct nftnl_chain *c)
>  		c->flags |= (1 << NFTNL_CHAIN_PRIO);
>  	}
>  	if (tb[NFTA_HOOK_DEV]) {
> -		c->dev = strdup(mnl_attr_get_str(tb[NFTA_HOOK_DEV]));
> +		if (c->flags & (1 << NFTNL_CHAIN_DEV))
> +			xfree(c->dev);
> +		c->dev = nftnl_attr_get_ifname(tb[NFTA_HOOK_DEV]);
>  		if (!c->dev)
>  			return -1;
>  		c->flags |= (1 << NFTNL_CHAIN_DEV);
> diff --git a/src/flowtable.c b/src/flowtable.c
> index fbbe0a866368d..006d50743e78a 100644
> --- a/src/flowtable.c
> +++ b/src/flowtable.c
> @@ -299,7 +299,7 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
>  
>  		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
>  		nftnl_str_array_foreach(dev, &c->dev_array, i)
> -			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev);
> +			nftnl_attr_put_ifname(nlh, NFTA_DEVICE_NAME, dev);
>  		mnl_attr_nest_end(nlh, nest_dev);
>  	}
>  
> diff --git a/src/str_array.c b/src/str_array.c
> index 5669c6154d394..02501c0cbdd79 100644
> --- a/src/str_array.c
> +++ b/src/str_array.c
> @@ -56,7 +56,7 @@ int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest)
>  		return -1;
>  
>  	mnl_attr_for_each_nested(attr, nest) {
> -		sa->array[sa->len] = strdup(mnl_attr_get_str(attr));
> +		sa->array[sa->len] = nftnl_attr_get_ifname(attr);
>  		if (!sa->array[sa->len]) {
>  			nftnl_str_array_clear(sa);
>  			return -1;
> diff --git a/src/utils.c b/src/utils.c
> index 5f2c5bff7c650..2a8669c6242b7 100644
> --- a/src/utils.c
> +++ b/src/utils.c
> @@ -13,8 +13,11 @@
>  #include <errno.h>
>  #include <inttypes.h>
>  
> +#include <libmnl/libmnl.h>
> +
>  #include <libnftnl/common.h>
>  
> +#include <linux/if.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
>  
> @@ -146,3 +149,31 @@ int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
>  	*flags |= (1 << attr);
>  	return 0;
>  }
> +
> +void nftnl_attr_put_ifname(struct nlmsghdr *nlh,
> +			   uint16_t attr, const char *ifname)
> +{
> +	size_t len = strlen(ifname) + 1;
> +
> +	if (len >= 2 && ifname[len - 2] == '*')
> +		len -= 2;
> +
> +	mnl_attr_put(nlh, attr, len, ifname);
> +}
> +
> +char *nftnl_attr_get_ifname(const struct nlattr *attr)
> +{
> +	size_t slen = mnl_attr_get_payload_len(attr);
> +	const char *dev = mnl_attr_get_str(attr);
> +	char buf[IFNAMSIZ];
> +
> +	if (slen > 0 && dev[slen - 1] == '\0')
> +		return strdup(dev);
> +
> +	if (slen > IFNAMSIZ - 2)
> +		slen = IFNAMSIZ - 2;
> +
> +	memcpy(buf, dev, slen);
> +	memcpy(buf + slen, "*\0", 2);
> +	return strdup(buf);
> +}
> -- 
> 2.49.0
> 
