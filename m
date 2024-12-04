Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [83.166.143.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002DD14287
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2024 19:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733340653; cv=none; b=DYHd90VrUp90kD9j7OxCpt+8iH2vUiFMzR3ngUoaIX3PKOJIHbHPdmVC8B+cyDNnnWrBGW+99n0Da9Wxr4ukqCLt9mwpkrHSFMTWSfYLM/ZV996egGChjOpctUZvM5gF2F+qM2WN7o0W8B66/5UGakOF4XfdQG7kyat/g6VNwgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733340653; c=relaxed/simple;
	bh=RUbhRPIUh1mrwu0NbyhXZZRY5i2rA0XQzdjW5f/xXrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tbh3pu09h9k+aJu75DKVeeQX+z+2vzgC1aqyeWcBqgv5s218HYECVwSzH8JZ0QA9O2nT/7y63++84gw8N7G1YmXW8/UihJOq3cqRo4x+9ncxSgg4ZpFTWXZ6tdbxSexSlTVjDsRSeQKfkE+xWqTu86ZR/xxligOp4zLo47MGQfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=xMoQOFRP; arc=none smtp.client-ip=83.166.143.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="xMoQOFRP"
Received: from smtp-4-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10:40ca:feff:fe05:1])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Y3SKt5G5rzNTg;
	Wed,  4 Dec 2024 20:30:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733340642;
	bh=9OSpnLxgaXnL96jSVg82oOXJdgUS0BeZzC4mVOVmAe8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xMoQOFRPi+ZjF8yBlHa96na7c/QVBVGp+XzfcwXjmG2WtbXqa5Ls1QIyiZ+/ebCND
	 5Bi42EpVunYsD9vaKmDQYO0E6wxRtJ2S6lAcikwEHy3NYYcg7eDN6tb98ipjro4lLb
	 X5aoBgf5Occ4ToX6CtHU62pSFk3QVZe7KrXkiQ1w=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Y3SKt1GT4zr67;
	Wed,  4 Dec 2024 20:30:42 +0100 (CET)
Date: Wed, 4 Dec 2024 20:30:41 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Message-ID: <20241204.xoog3Quei4ta@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Thu, Oct 17, 2024 at 07:04:47PM +0800, Mikhail Ivanov wrote:
> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> should not restrict bind(2) and connect(2) for non-TCP protocols
> (SCTP, MPTCP, SMC).
> 
> sk_is_tcp() is used for this to check address family of the socket
> before doing INET-specific address length validation. This is required
> for error consistency.
> 
> Closes: https://github.com/landlock-lsm/linux/issues/40
> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> 
> Changes since v1:
> * Validate socket family (=INET{,6}) before any other checks
>   with sk_is_tcp().
> ---
>  security/landlock/net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index fdc1bb0a9c5d..1e80782ba239 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -66,8 +66,8 @@ static int current_check_access_socket(struct socket *const sock,
>  	if (WARN_ON_ONCE(dom->num_layers < 1))
>  		return -EACCES;
>  
> -	/* Checks if it's a (potential) TCP socket. */
> -	if (sock->type != SOCK_STREAM)
> +	/* Do not restrict non-TCP sockets. */

You can remove this comment because the following check is explicit.

> +	if (!sk_is_tcp(sock->sk))
>  		return 0;
>  
>  	/* Checks for minimal header length to safely read sa_family. */
> -- 
> 2.34.1
> 
> 
