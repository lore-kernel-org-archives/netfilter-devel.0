Received: from smtp-190e.mail.infomaniak.ch (smtp-190e.mail.infomaniak.ch [185.125.25.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159031A7250
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 17:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727977541; cv=none; b=dhbCcwUFVyTnl8fF2uy7tBVJYfl/TETK9v6AxJn+EPVldnMUsZZcZagbuJQq8apdPFKB5uXz9BkHyUystTInxTCwsjjBdurJpv5Uga7Jv3+knMyH7rmJLpQDnJQ+PEDqE/8fOCVbv6CSZ8hr48FQzE2rewUFlTzJagDhZ/PDRXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727977541; c=relaxed/simple;
	bh=GwBvwlPnRklqBwWjd+s1Bz4rmRwYLIUKif3msYMxzI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pOFeSNdOuXvbzD96mCVe/0kDJ0eRmChoRdwGcreFPmFAWgZs3iqmnX4Upo8seZRkA3DdspWyj/nTd6r27vWYJrCOI8ownbTB/naJI+vGRztj1bjN7HtoGVwD2W9+DW+Ck2+tG8QSFjTK/gDdUauqph/A1AC0RZMzWm8IdqNSMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=NMiunSe8; arc=none smtp.client-ip=185.125.25.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="NMiunSe8"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XKJx42Dx9zkZd;
	Thu,  3 Oct 2024 19:45:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1727977528;
	bh=WCz4o0hEWbAJEm7cUMTuC56hiiBO4M5T+U2PG6rzQAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NMiunSe8EQGfE8PF7FXdVvY8g7RgjUvz87baXEEoLo7KauasXZgB40sNC/VBuiXBv
	 /b8nSjWKBbuL2ujZrOSO0klQO0HOUY/tF8u/HVkU28lqA2m6hwj7UO6AZ82jdvFl/q
	 XGCwH5yaBQKpy/MCnBJpRbMNVr6wkdi5ezXU0soE=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4XKJx34DYXzG9T;
	Thu,  3 Oct 2024 19:45:27 +0200 (CEST)
Date: Thu, 3 Oct 2024 19:45:25 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [RFC PATCH v1 1/2] landlock: Fix non-TCP sockets restriction
Message-ID: <20241003.wie1aiphaeCh@digikod.net>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
 <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

Please also add Matthieu in Cc for the network patch series.

On Thu, Oct 03, 2024 at 10:39:31PM +0800, Mikhail Ivanov wrote:
> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
> should not restrict bind(2) and connect(2) for non-TCP protocols
> (SCTP, MPTCP, SMC).
> 
> Closes: https://github.com/landlock-lsm/linux/issues/40
> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  security/landlock/net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index bc3d943a7118..6f59dd98bb13 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -68,7 +68,7 @@ static int current_check_access_socket(struct socket *const sock,
>  		return -EACCES;
>  
>  	/* Checks if it's a (potential) TCP socket. */

We can extend this comment to explain that we don't use sk_is_tcp()
because we need to handle the AF_UNSPEC case.

> -	if (sock->type != SOCK_STREAM)
> +	if (sock->type != SOCK_STREAM || sock->sk->sk_protocol != IPPROTO_TCP)

I think we should check sock->sk->sk_type instead of sock->type (even if
it should be the same).  To make it simpler, we should only use sk in
current_check_access_socket():
struct sock *sk = sock->sk;

Could you please also do s/__sk_common\.skc_/sk_/g ?

>  		return 0;
>  
>  	/* Checks for minimal header length to safely read sa_family. */
> -- 
> 2.34.1
> 
> 
