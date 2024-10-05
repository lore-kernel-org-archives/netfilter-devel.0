Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47443157E6B;
	Sat,  5 Oct 2024 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728147422; cv=none; b=fWhRnN95oFrW6PU/gIa4R85IIjb7mZpOfLnHiYLUdpIKVV4p1nPUiMV+sXoSGbGLQkVFZ9W1s2AojUjH7ljOgotlrTCGK6uA7V8xhY0mWh9EE8Q2C3trkMsmF/EYUkQTQG4kBgQb8WkLxhK52/GF72X7VrQx02MdlSYj7y0Jzo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728147422; c=relaxed/simple;
	bh=C53/nKc8kTa34d4u7tRpsIQORJDP1miIvNFEmEG5u54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJfISDe5JA/AOov2eKYdVLWi89sFSQ7DZgbS9zIsRx4CaBuGKZ5mslzTvzjxmDrhAU/aPirH1rn5IMJXc5t6Mcfg4JEBZk+doO0R8zjWP/Da9oDGQpusrpJHc2rSwjr1qYH+9SAte3A4sIC+eKxQEH/ncI6iHqAYjce8V7/INzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X1rrt4KA; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X1rrt4KA"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a93b2070e0cso361416066b.3;
        Sat, 05 Oct 2024 09:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728147418; x=1728752218; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gDdrjY4ewD5Ne/flcYwXLODWb/FV1pztt34PqmMXqQE=;
        b=X1rrt4KAs95qOUBtcbknWS6Q/acpiHZ6M+8nzWD64SkNp6l2S8mrlp2EpNruf++Io8
         8vqkKtyM6T4Kp0ZDbZlzVwB4PKvHEq2XtO25CbElViTu5e1BVNuSn0gi01bWWMOx8zse
         6iGhTJUJUUf86NdGSW2A9/aAKPV6e/TvUJAFJ5ltLRH6XRK7DnHejLmR7ObNXpepWYeJ
         dtmdnHkxmGwejkZ8/R9g6yWMfoKz76B6qeQT6hqN9Miy+SkbkDHd7OawSe0BP39Z/5Y9
         K9B9Fqn8zlPnxa/REB0yw8Ut1hCh/q23zXr5GDPpOPR1lKSvf1yT8B6ZhriK1GjQw6Z7
         6BhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728147418; x=1728752218;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gDdrjY4ewD5Ne/flcYwXLODWb/FV1pztt34PqmMXqQE=;
        b=oADNOfGPR7HTJIGUkjux3wJIyxObwt7FCXeuRgWuy8hchweYkbXi0sTf6g08fPt5mS
         zOqGvS3oKdjKjrmn6tKbuMJmHVBy7oSo7DjZxg1mpzoiPlsAO/5/eonM8qbg9Uj293Ae
         7JfYdcLOWXOKBNYYSdrjvwDzUs5dzKrMxC9xjY9e7YEglS4OMhCwpSPI4wgLrzL8mSlx
         g58oCmA1TLzt3fSm0rFXwBcMYMVUNgvV+M1KIzOmgKqdznFRJobkqnLLhibD1721Cn0x
         PhUaLcg3ytKsmUDQ2BGdWHv15MvQwMSFKdPxEVS1hBwt/cf/xBkHtqZmm5DP+IiqkiKK
         7Sqg==
X-Forwarded-Encrypted: i=1; AJvYcCViFXHjHeIF4zIu7/LP95TLnAs23StyR5wQG3n7qiI9LEnOVh+azXlZ/4MeCmCr3syeuE1CwKh4h+slAkY7Q1wB@vger.kernel.org, AJvYcCW3HCCm86BLtuhw8JKmidfW/LL1IQRkb81zIRvUn7TDZXm24cnxh9CXLmyAGz74+TkrBPCAWlCf@vger.kernel.org, AJvYcCX/a3bQJGa/TYJX1aiZ02l2GCjTYlNuM13xIw/tH+6zSFcPCaXTtpPuhWVkoZFbk7WTnoeXqCfSm2rDin/m5qeN448d4Xo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2clbuRQAeLyDrP4QyesN04puFDP8rratxgdXWC+FjvhfcmYmK
	UDxyrsbwjHRW/Nk9BuTUBHrI/rQyX1SuMtVCU6nvWklfd4k8wUhi
X-Google-Smtp-Source: AGHT+IGGz1aH0PxQLQDiOiY0RpUmQ+uipdK5LYyaxjboYTF/lZWoEUULA5iPIbufJP9RrwXjT8k1sw==
X-Received: by 2002:a17:906:c151:b0:a93:9996:fb16 with SMTP id a640c23a62f3a-a991c077de7mr679941866b.64.1728147418121;
        Sat, 05 Oct 2024 09:56:58 -0700 (PDT)
Received: from localhost ([2a02:168:59f0:1:b0ab:dd5e:5c82:86b0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99399c6735sm107627866b.9.2024.10.05.09.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 09:56:57 -0700 (PDT)
Date: Sat, 5 Oct 2024 18:56:52 +0200
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, yusongping@huawei.com,
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 2/9] landlock: Support TCP listen access-control
Message-ID: <20241005.bd6123d170b4@gnoack.org>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-3-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240814030151.2380280-3-ivanov.mikhail1@huawei-partners.com>

Hello!

On Wed, Aug 14, 2024 at 11:01:44AM +0800, Mikhail Ivanov wrote:
> LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
> ports to forbid a malicious sandboxed process to impersonate a legitimate
> server process. However, bind(2) might be used by (TCP) clients to set the
> source port to a (legitimate) value. Controlling the ports that can be
> used for listening would allow (TCP) clients to explicitly bind to ports
> that are forbidden for listening.
> 
> Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
> access right that restricts listening on undesired ports with listen(2).
> 
> It's worth noticing that this access right doesn't affect changing
> backlog value using listen(2) on already listening socket.
> 
> * Create new LANDLOCK_ACCESS_NET_LISTEN_TCP flag.
> * Add hook to socket_listen(), which checks whether the socket is allowed
>   to listen on a binded local port.
> * Add check_tcp_socket_can_listen() helper, which validates socket
>   attributes before the actual access right check.
> * Update `struct landlock_net_port_attr` documentation with control of
>   binding to ephemeral port with listen(2) description.
> * Change ABI version to 6.
> 
> Closes: https://github.com/landlock-lsm/linux/issues/15
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
> 
> Changes since v1:
> * Refactors 'struct landlock_net_port_attr' documentation.
> * Fixes check_tcp_socket_can_listen() description.
> * Adds lockdep_assert_held() into check_tcp_socket_can_listen().
> * Minor fixes.
> ---
>  include/uapi/linux/landlock.h                | 26 ++++--
>  security/landlock/limits.h                   |  2 +-
>  security/landlock/net.c                      | 98 ++++++++++++++++++++
>  security/landlock/syscalls.c                 |  2 +-
>  tools/testing/selftests/landlock/base_test.c |  2 +-
>  5 files changed, 119 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> index 2c8dbc74b955..f7dd6949c50b 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -111,14 +111,20 @@ struct landlock_net_port_attr {
>  	/**
>  	 * @port: Network port in host endianness.
>  	 *
> -	 * It should be noted that port 0 passed to :manpage:`bind(2)` will bind
> -	 * to an available port from the ephemeral port range.  This can be
> -	 * configured with the ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl
> -	 * (also used for IPv6).
> +	 * Some socket operations will fall back to using a port from the ephemeral port
> +	 * range, if no specific port is requested by the caller.  Among others, this
> +	 * happens in the following cases:
>  	 *
> -	 * A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP``
> -	 * right means that requesting to bind on port 0 is allowed and it will
> -	 * automatically translate to binding on the related port range.
> +	 * - :manpage:`bind(2)` is invoked with a socket address that uses port 0.
> +	 * - :manpage:`listen(2)` is invoked on a socket without previously calling
> +	 *   :manpage:`bind(2)`.
> +	 *
> +	 * These two actions, which implicitly use an ephemeral port, can be allowed with
> +	 * a Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP`` /
> +	 * ``LANDLOCK_ACCESS_NET_LISTEN_TCP`` right.
> +	 *
> +	 * The ephemeral port range is configured in the
> +	 * ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl (also used for IPv6).
>  	 */
>  	__u64 port;
>  };
> @@ -259,7 +265,7 @@ struct landlock_net_port_attr {
>   * DOC: net_access
>   *
>   * Network flags
> - * ~~~~~~~~~~~~~~~~
> + * ~~~~~~~~~~~~~
>   *
>   * These flags enable to restrict a sandboxed process to a set of network
>   * actions. This is supported since the Landlock ABI version 4.
> @@ -269,9 +275,13 @@ struct landlock_net_port_attr {
>   * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
>   * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>   *   a remote port.
> + * - %LANDLOCK_ACCESS_NET_LISTEN_TCP: Listen for TCP socket connections on
> + *   a local port. This access right is available since the sixth version
> + *   of the Landlock ABI.
>   */
>  /* clang-format off */
>  #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>  #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
> +#define LANDLOCK_ACCESS_NET_LISTEN_TCP			(1ULL << 2)
>  /* clang-format on */
>  #endif /* _UAPI_LINUX_LANDLOCK_H */
> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
> index 4eb643077a2a..2ef147389474 100644
> --- a/security/landlock/limits.h
> +++ b/security/landlock/limits.h
> @@ -22,7 +22,7 @@
>  #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
>  #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>  
> -#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_LISTEN_TCP
>  #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>  #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
>  
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index 669ba260342f..0e494b46d086 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -6,10 +6,12 @@
>   * Copyright © 2022-2023 Microsoft Corporation
>   */
>  
> +#include <net/sock.h>
>  #include <linux/in.h>
>  #include <linux/net.h>
>  #include <linux/socket.h>
>  #include <net/ipv6.h>
> +#include <net/tcp.h>
>  
>  #include "common.h"
>  #include "cred.h"
> @@ -194,9 +196,105 @@ static int hook_socket_connect(struct socket *const sock,
>  					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>  }
>  
> +/*
> + * Checks that socket state and attributes are correct for listen.
> + * Returns 0 on success and -EINVAL otherwise.
> + *
> + * This checker requires sock->sk to be locked.
> + */
> +static int check_tcp_socket_can_listen(struct socket *const sock)
> +{
> +	struct sock *sk = sock->sk;
> +	unsigned char cur_sk_state;
> +	const struct tcp_ulp_ops *icsk_ulp_ops;
> +
> +	lockdep_assert_held(&sk->sk_lock.slock);
> +
> +	/* Allows only unconnected TCP socket to listen (cf. inet_listen). */
> +	if (sock->state != SS_UNCONNECTED)
> +		return -EINVAL;
> +
> +	cur_sk_state = sk->sk_state;
> +	/*
> +	 * Checks sock state. This is needed to ensure consistency with inet stack
> +	 * error handling (cf. __inet_listen_sk).
> +	 */
> +	if (WARN_ON_ONCE(!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN))))
> +		return -EINVAL;
> +
> +	icsk_ulp_ops = inet_csk(sk)->icsk_ulp_ops;
> +
> +	/*
> +	 * ULP (Upper Layer Protocol) stands for protocols which are higher than
> +	 * transport protocol in OSI model. Linux has an infrastructure that
> +	 * allows TCP sockets to support logic of some ULP (e.g. TLS ULP).
> +	 *
> +	 * Sockets can listen only if ULP control hook has clone method
> +	 * (cf. inet_csk_listen_start)
> +	 */
> +	if (icsk_ulp_ops && !icsk_ulp_ops->clone)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int hook_socket_listen(struct socket *const sock, const int backlog)
> +{
> +	int err = 0;
> +	int family;
> +	__be16 port;
> +	struct sock *sk;
> +	const struct landlock_ruleset *const dom = get_current_net_domain();
> +
> +	if (!dom)
> +		return 0;
> +	if (WARN_ON_ONCE(dom->num_layers < 1))
> +		return -EACCES;
> +
> +	/* Checks if it's a (potential) TCP socket. */
> +	if (sock->type != SOCK_STREAM)
> +		return 0;
> +
> +	sk = sock->sk;
> +	family = sk->__sk_common.skc_family;
> +	/*
> +	 * Socket cannot be assigned AF_UNSPEC because this type is used only
> +	 * in the context of addresses.
> +	 *
> +	 * Doesn't restrict listening for non-TCP sockets.
> +	 */
> +	if (family != AF_INET && family != AF_INET6)
> +		return 0;

I imagine that we'll need the "protocol" comparison as well, in line
with your fix for the bind() and connect() functionality at
https://lore.kernel.org/all/20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com/
?

> +
> +	lock_sock(sk);

The socket gets locked twice when doing listen() -- first it is locked
by the security hook, then released again, then locked again by the
actual listen() implementation and then released again.

What if the protected values change in between the two times when the
lock is held?  What is the reasoning for why this is safe?  (This
might be worth a comment in the code to explain, IMHO.)

> +	/*
> +	 * Calling listen(2) for a listening socket does nothing with its state and
> +	 * only changes backlog value (cf. __inet_listen_sk). Checking of listen
> +	 * access right is not required.
> +	 */
> +	if (sk->sk_state == TCP_LISTEN)
> +		goto release_nocheck;
> +
> +	/*
> +	 * Checks socket state to not wrongfully return -EACCES instead
> +	 * of -EINVAL.
> +	 */
> +	err = check_tcp_socket_can_listen(sock);
> +	if (unlikely(err))
> +		goto release_nocheck;
> +
> +	port = htons(inet_sk(sk)->inet_num);
> +	release_sock(sk);
> +	return check_access_socket(dom, port, LANDLOCK_ACCESS_NET_LISTEN_TCP);

Nit: The last two lines could just be

  err = check_access_socket(...);

and then you would only need the release_sock(sk) call in one place.
(And maybe rename the goto label accordingly.)

> +
> +release_nocheck:
> +	release_sock(sk);
> +	return err;
> +}
> +
>  static struct security_hook_list landlock_hooks[] __ro_after_init = {
>  	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
>  	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
> +	LSM_HOOK_INIT(socket_listen, hook_socket_listen),
>  };
>  
>  __init void landlock_add_net_hooks(void)
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index ccc8bc6c1584..328198e8a9f5 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -149,7 +149,7 @@ static const struct file_operations ruleset_fops = {
>  	.write = fop_dummy_write,
>  };
>  
> -#define LANDLOCK_ABI_VERSION 5
> +#define LANDLOCK_ABI_VERSION 6
>  
>  /**
>   * sys_landlock_create_ruleset - Create a new ruleset
> diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
> index 3b26bf3cf5b9..1bc16fde2e8a 100644
> --- a/tools/testing/selftests/landlock/base_test.c
> +++ b/tools/testing/selftests/landlock/base_test.c
> @@ -76,7 +76,7 @@ TEST(abi_version)
>  	const struct landlock_ruleset_attr ruleset_attr = {
>  		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
>  	};
> -	ASSERT_EQ(5, landlock_create_ruleset(NULL, 0,
> +	ASSERT_EQ(6, landlock_create_ruleset(NULL, 0,
>  					     LANDLOCK_CREATE_RULESET_VERSION));
>  
>  	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
> -- 
> 2.34.1
> 
