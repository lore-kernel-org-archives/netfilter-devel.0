Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5482C12CD90;
	Tue, 30 Apr 2024 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714484204; cv=none; b=c3ug81I7JhccJEtJWF4Y2Byars6Qf1rUky81HblRtvVz+4Zi3LRFceq3rOR4Uo8zhwRAF64x+z+TfSqK9ZsPAZ9VuWKTV0/vKL2Qt4rKccgd+k28smFePSbwjNKPgJJGAkyf7eJjdmwmYxFOYPf8WgIzMBvy2ApzxBHsbOccVjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714484204; c=relaxed/simple;
	bh=Ht7HNLm5kaquAR3oK1qW8ocro1DDSWKUd9H3i4ybEOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTC0d03AtUfB3R2ulvWHxd2ZRUoceUWi/WmCEpbslO2Edi3CIb3wYIqtTo1m278ghgAWMhXy6BBP+bw6WO/TworyVYk1zZfSvqrqMQb3h+C25ogiymkrGtxY0Jptf3BQ5cTI9iXj8X0TgrtskP+dSWg+0FhV5hlkfU2docx5UGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=qLUt/of9; arc=none smtp.client-ip=83.166.143.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="qLUt/of9"
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VTLnn6D1gzgYs;
	Tue, 30 Apr 2024 15:36:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1714484189;
	bh=Ht7HNLm5kaquAR3oK1qW8ocro1DDSWKUd9H3i4ybEOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qLUt/of9TegrevasuZ1ZZ//CxRv68TJMT5zVXStwYeTbg5L4OiQ6srmzmOlPBLaI+
	 uXUXueh/t6p8XwG8Os7UudmZvO5oSY8P0tUzThEH6Jf3SnObNY1yOWBiy0ZIAtd9dy
	 YEMVfUxQBG6tuf6bIrBa0SW/unvM3uoBS3H6RrVI=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VTLnn22qLz10y;
	Tue, 30 Apr 2024 15:36:28 +0200 (CEST)
Date: Tue, 30 Apr 2024 15:36:28 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
Message-ID: <20240425.Soot5eNeexol@digikod.net>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
> Make hook for socket_listen(). It will check that the socket protocol is
> TCP, and if the socket's local port number is 0 (which means,
> that listen(2) was called without any previous bind(2) call),
> then listen(2) call will be legitimate only if there is a rule for bind(2)
> allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
> supported by the sandbox).

Thanks for this patch and sorry for the late full review.  The code is
good overall.

We should either consider this patch as a fix or add a new flag/access
right to Landlock syscalls for compatibility reason.  I think this
should be a fix.  Calling listen(2) without a previous call to bind(2)
is a corner case that we should properly handle.  The commit message
should make that explicit and highlight the goal of the patch: first
explain why, and then how.

We also need to update the user documentation to explain that
LANDLOCK_ACCESS_NET_BIND_TCP also handles this case.

> 
> Create a new check_access_socket() function to prevent useless copy paste.
> It should be called by hook handlers after they perform special checks and
> calculate socket port value.

You can add this tag:
Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")

> 
> Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
> Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
>  security/landlock/net.c | 104 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 88 insertions(+), 16 deletions(-)
> 
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index c8bcd29bde09..c6ae4092cfd6 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -10,6 +10,7 @@
>  #include <linux/net.h>
>  #include <linux/socket.h>
>  #include <net/ipv6.h>
> +#include <net/tcp.h>
>  
>  #include "common.h"
>  #include "cred.h"
> @@ -61,17 +62,36 @@ static const struct landlock_ruleset *get_current_net_domain(void)
>  	return dom;
>  }
>  
> -static int current_check_access_socket(struct socket *const sock,
> -				       struct sockaddr *const address,
> -				       const int addrlen,
> -				       access_mask_t access_request)
> +static int check_access_socket(const struct landlock_ruleset *const dom,
> +			  __be16 port,
> +			  access_mask_t access_request)

Please format all patches with clang-format.

>  {
> -	__be16 port;
>  	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>  	const struct landlock_rule *rule;
>  	struct landlock_id id = {
>  		.type = LANDLOCK_KEY_NET_PORT,
>  	};
> +
> +	id.key.data = (__force uintptr_t)port;
> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> +
> +	rule = landlock_find_rule(dom, id);
> +	access_request = landlock_init_layer_masks(
> +		dom, access_request, &layer_masks, LANDLOCK_KEY_NET_PORT);
> +
> +	if (landlock_unmask_layers(rule, access_request, &layer_masks,
> +				   ARRAY_SIZE(layer_masks)))
> +		return 0;
> +
> +	return -EACCES;
> +}

This check_access_socket() refactoring should be in a dedicated patch.

> +
> +static int current_check_access_socket(struct socket *const sock,
> +				       struct sockaddr *const address,
> +				       const int addrlen,
> +				       access_mask_t access_request)
> +{
> +	__be16 port;
>  	const struct landlock_ruleset *const dom = get_current_net_domain();
>  
>  	if (!dom)
> @@ -159,17 +179,7 @@ static int current_check_access_socket(struct socket *const sock,
>  			return -EINVAL;
>  	}
>  
> -	id.key.data = (__force uintptr_t)port;
> -	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> -
> -	rule = landlock_find_rule(dom, id);
> -	access_request = landlock_init_layer_masks(
> -		dom, access_request, &layer_masks, LANDLOCK_KEY_NET_PORT);
> -	if (landlock_unmask_layers(rule, access_request, &layer_masks,
> -				   ARRAY_SIZE(layer_masks)))
> -		return 0;
> -
> -	return -EACCES;
> +	return check_access_socket(dom, port, access_request);
>  }
>  
>  static int hook_socket_bind(struct socket *const sock,
> @@ -187,9 +197,71 @@ static int hook_socket_connect(struct socket *const sock,
>  					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>  }
>  
> +/*
> + * Check that socket state and attributes are correct for listen.
> + * It is required to not wrongfully return -EACCES instead of -EINVAL.
> + */
> +static int check_tcp_socket_can_listen(struct socket *const sock)
> +{
> +	struct sock *sk = sock->sk;
> +	unsigned char cur_sk_state = sk->sk_state;
> +	const struct inet_connection_sock *icsk;
> +
> +	/* Allow only unconnected TCP socket to listen(cf. inet_listen). */

nit: Missing space.

The other comments in Landlock are written with the third person
(in theory everywhere): "Allows..."

> +	if (sock->state != SS_UNCONNECTED)
> +		return -EINVAL;
> +
> +	/* Check sock state consistency. */

Can you explain exactly what is going on here (in the comment)? Linking
to a kernel function would help.

> +	if (!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> +		return -EINVAL;
> +
> +	/* Sockets can listen only if ULP control hook has clone method. */

What is ULP?

> +	icsk = inet_csk(sk);
> +	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
> +		return -EINVAL;

Can you please add tests covering all these error cases?

> +	return 0;
> +}
> +
> +static int hook_socket_listen(struct socket *const sock,
> +			  const int backlog)
> +{
> +	int err;
> +	int family;
> +	const struct landlock_ruleset *const dom = get_current_net_domain();
> +
> +	if (!dom)
> +		return 0;
> +	if (WARN_ON_ONCE(dom->num_layers < 1))
> +		return -EACCES;
> +
> +	/*
> +	 * listen() on a TCP socket without pre-binding is allowed only
> +	 * if binding to port 0 is allowed.
> +	 */

This comment should be just before the inet_sk(sock->sk)->inet_num
check.

> +	family = sock->sk->__sk_common.skc_family;
> +
> +	if (family == AF_INET || family == AF_INET6) {

This would make the code simpler:

if (family != AF_INET && family != AF_INET6)
	return 0;


What would be the effect of listen() on an AF_UNSPEC socket?

> +		/* Checks if it's a (potential) TCP socket. */
> +		if (sock->type != SOCK_STREAM)
> +			return 0;

As for current_check_access_socket() this kind of check should be at the
beginning of the function (before the family check) to exit early and
simplify code.

> +
> +		/* Socket is alredy binded to some port. */

This kind of spelling issue can be found by scripts/checkpatch.pl

> +		if (inet_sk(sock->sk)->inet_num != 0)

Why do we want to allow listen() on any socket that is binded?

> +			return 0;
> +
> +		err = check_tcp_socket_can_listen(sock);
> +		if (unlikely(err))
> +			return err;
> +
> +		return check_access_socket(dom, 0, LANDLOCK_ACCESS_NET_BIND_TCP);
> +	}
> +	return 0;
> +}
> +
>  static struct security_hook_list landlock_hooks[] __ro_after_init = {
>  	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
>  	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
> +	LSM_HOOK_INIT(socket_listen, hook_socket_listen),
>  };
>  
>  __init void landlock_add_net_hooks(void)
> -- 
> 2.34.1
> 
> 
