Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C84199D8
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 23:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774999782; cv=none; b=JSOT4aHWkuuGR34E6zizGEvYS3supKiOJIrXrIf7c+kM9K9pJEqNjFah4DRs3kCAa+jBqZZYA6a0FCjvj1Vcviz5bGIUv7kxqmgB8NHWE15ZhC4ER1KhAlE7uk7jcUxov9+hpfu6G3la4qGK2t7Kqr6IZCitdq2P51OAmJ8zV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774999782; c=relaxed/simple;
	bh=EiKEYkGc1qeQLVdYx8/L3piL9chVRbHPsR0E8Dqea8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StgqSSRj8UFWOo0mq9WYzAqMfI1HEhCX1VzXN9CGaFBatTWzV6lcpJ/at+5EN64E1TTIKhf3K0kXeq2uQkwJPe2r8rmCvLnmjwRwUcPNBceqQy9Haq6hTfjmWT8dMyCX73tyCxOfAd/Tj285RXSpsLOQ5prFgfiy6TkGbRSmcc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ulvBmjZd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ulvBmjZd"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1C20960180;
	Wed,  1 Apr 2026 01:29:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774999778;
	bh=8G8il/F+aIt2UF1qG6EQLO2DK/MKEYRsKxsXyZHNV6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ulvBmjZdi7dIzZ1KRMiQKVAxGuectYDvfGWxkf2Wly6dPoB8y2vhc1Y3AC4aajGnB
	 kuwo8per1ckEGk6/9zcXLn63svTMBTwPMMmvSCYbmrVXXAY3s0q3l7aZe4cfMAUQmh
	 Fpv+f/4HlHm5WO/daP3WtVLqmiHByAAG4YDXwdGCUwng6PRx8eFnJogabA+gk6cWUZ
	 6QUxnCWBCZP1YIX1vl3V5JjbxfHaE402Cu4pMbtSGnd1rVZkA6yE2HOK+N+4OjYmqZ
	 mFT4+xknU8Q9B8iFhGpCYiOtl4BakZeCQ4CsMrR6MDkOaKAEBByUy0xlc5oLPErmsa
	 pg18Fdq4zdu8A==
Date: Wed, 1 Apr 2026 01:29:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, security@kernel.org, fw@strlen.de,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	shuah@kernel.org, yuantan098@gmail.com, bird@lzu.edu.cn,
	z1652074432@gmail.com, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, enjou1224z@gmail.com
Subject: Re: [PATCH v2] netfilter: xt_multiport: reject trailing range markers
Message-ID: <acxY3z1h2qkpzaEw@chamomile>
References: <cover.1774624314.git.n05ec@lzu.edu.cn>
 <dc1b0139fc250e188657e874ce4bb67f60af6e0c.1774659119.git.n05ec@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc1b0139fc250e188657e874ce4bb67f60af6e0c.1774659119.git.n05ec@lzu.edu.cn>

Hi,

On Sat, Mar 28, 2026 at 10:51:23PM +0800, Ren Wei wrote:
> diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
> index 44a00f5acde8..38aa5b90d38e 100644
> --- a/net/netfilter/xt_multiport.c
> +++ b/net/netfilter/xt_multiport.c
> @@ -26,10 +26,10 @@ MODULE_ALIAS("ip6t_multiport");
>  /* Returns 1 if the port is matched by the test, 0 otherwise. */
>  static inline bool
>  ports_match_v1(const struct xt_multiport_v1 *minfo,
> -	       u_int16_t src, u_int16_t dst)
> +	       u16 src, u16 dst)
>  {
>  	unsigned int i;
> -	u_int16_t s, e;
> +	u16 s, e;
>  
>  	for (i = 0; i < minfo->count; i++) {
>  		s = minfo->ports[i];

I see, this is a cleanup to use preferred datatypes.

> @@ -106,20 +106,36 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  }
>  
>  static inline bool
> -check(u_int16_t proto,
> -      u_int8_t ip_invflags,
> -      u_int8_t match_flags,
> -      u_int8_t count)
> +multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < multiinfo->count; i++) {
> +		if (!multiinfo->pflags[i])
> +			continue;
> +
> +		if (i == multiinfo->count - 1)
> +			return false;
> +
> +		i++;
> +	}

Why so convoluted? This should just fix this bug:

static bool multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
{
        return multiinfo->pflags[multiinfo->count - 1] == 0;
}

This is an off-by-one read bug from packet path that is possible
because the last slot in the multiport array _must_ be zero.

pflags[i] non-zero means beginning of a range, and pflags[i+1] zero
means end of range (or singleton port).

Actually multiport_valid_ranges() can just go away too given the more
simple fix.

> +
> +	return true;
> +}
> +
> +static inline bool
> +check(u16 proto, u8 ip_invflags, const struct xt_multiport_v1 *multiinfo)
>  {
>  	/* Must specify supported protocol, no unknown flags or bad count */
> -	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP
> -		|| proto == IPPROTO_UDPLITE
> -		|| proto == IPPROTO_SCTP || proto == IPPROTO_DCCP)
> -		&& !(ip_invflags & XT_INV_PROTO)
> -		&& (match_flags == XT_MULTIPORT_SOURCE
> -		    || match_flags == XT_MULTIPORT_DESTINATION
> -		    || match_flags == XT_MULTIPORT_EITHER)
> -		&& count <= XT_MULTI_PORTS;
> +	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP ||
> +		proto == IPPROTO_UDPLITE ||
> +		proto == IPPROTO_SCTP || proto == IPPROTO_DCCP) &&
> +	       !(ip_invflags & XT_INV_PROTO) &&
> +	       (multiinfo->flags == XT_MULTIPORT_SOURCE ||
> +		multiinfo->flags == XT_MULTIPORT_DESTINATION ||
> +		multiinfo->flags == XT_MULTIPORT_EITHER) &&
> +	       multiinfo->count <= XT_MULTI_PORTS &&
> +	       multiport_valid_ranges(multiinfo);

It took me a while to review this cleanup-in-fix is doing what it is
intended. While this coding style is preferred these days, I'm unsure
I want this cleanup in this fix.

I think this fix can be turned into a oneliner...

>  }
>  
>  static int multiport_mt_check(const struct xt_mtchk_param *par)
> @@ -127,8 +143,7 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
>  	const struct ipt_ip *ip = par->entryinfo;
>  	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
>  
> -	return check(ip->proto, ip->invflags, multiinfo->flags,
> -		     multiinfo->count) ? 0 : -EINVAL;
> +	return check(ip->proto, ip->invflags, multiinfo) ? 0 : -EINVAL;
>  }
>  
>  static int multiport_mt6_check(const struct xt_mtchk_param *par)
> @@ -136,8 +151,7 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
>  	const struct ip6t_ip6 *ip = par->entryinfo;
>  	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
>  
> -	return check(ip->proto, ip->invflags, multiinfo->flags,
> -		     multiinfo->count) ? 0 : -EINVAL;
> +	return check(ip->proto, ip->invflags, multiinfo) ? 0 : -EINVAL;
>  }
>  
>  static struct xt_match multiport_mt_reg[] __read_mostly = {
> -- 
> 2.51.0
> 
