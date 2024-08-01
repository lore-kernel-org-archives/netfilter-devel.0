Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [45.157.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B318D1EB496
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2024 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722523539; cv=none; b=KlWWWaz5+qxjba0ZXUbmioXLMWJmw07klZk1jDf7vJe5FtfvbdpxU7JvQae8SjjGKt7WfrpYeNr+JzBmKg/XZeCGsWT2m02X8ZQfR5u4n91Hgi/C3d8PSZ3DGlYwa2k9wzDzZh7DtPHmiX9jiXbrZnIpJ5++0H+07rNdKOe5Ehk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722523539; c=relaxed/simple;
	bh=+KdHK0b3XxdW4O5hbDWzgXpW8h0tMLuS+cuVoM22y+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3lwIEmJ+BZcYsx7KRW++dGirg6xmEo58q8xXceNjQUN0ePi1Y7KPQYwtDuL5UAAeeBpLVpDcVAUYSGaVQCQCB8ZT75v3nVHBsUm7VLo2muD6WmdnVggvuzsbUZNd4Gp0zriihfFCYsMvbzqjQeyQW1lZWzHiNm5760NaswlB/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=q2sgE8gx; arc=none smtp.client-ip=45.157.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="q2sgE8gx"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4WZWwS0XSwzw4l;
	Thu,  1 Aug 2024 16:45:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1722523527;
	bh=x//Dp0shY6tzNnupZLePovHHLUCCNyFiszDQ/rMk7R0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2sgE8gxeRPIvhixfGdhSjwDQhJ2iJ7uE3mNGs/PSaNKI9QaefT4zgKOs6yrkFLK1
	 39nIgvfv41S9mMQD9mt7966Jg0eXNiZhRagrDwoiFbkfU+l78DF5Wa7PvmKGVx5sq/
	 FeseOLTbubHOa7+i6b+ooCziu2plgQ9QTeSacdig=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4WZWwR41X3zRlc;
	Thu,  1 Aug 2024 16:45:27 +0200 (CEST)
Date: Thu, 1 Aug 2024 16:45:23 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
Message-ID: <20240801.Euhith6ukah2@digikod.net>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
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
>  include/uapi/linux/landlock.h                | 23 +++--
>  security/landlock/limits.h                   |  2 +-
>  security/landlock/net.c                      | 90 ++++++++++++++++++++
>  security/landlock/syscalls.c                 |  2 +-
>  tools/testing/selftests/landlock/base_test.c |  2 +-
>  5 files changed, 108 insertions(+), 11 deletions(-)

> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index 669ba260342f..a29cb27c3f14 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -6,10 +6,12 @@
>   * Copyright © 2022-2023 Microsoft Corporation
>   */
>  
> +#include "net/sock.h"
>  #include <linux/in.h>
>  #include <linux/net.h>
>  #include <linux/socket.h>
>  #include <net/ipv6.h>
> +#include <net/tcp.h>
>  
>  #include "common.h"
>  #include "cred.h"
> @@ -194,9 +196,97 @@ static int hook_socket_connect(struct socket *const sock,
>  					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>  }
>  
> +/*
> + * Checks that socket state and attributes are correct for listen.
> + * It is required to not wrongfully return -EACCES instead of -EINVAL.
> + *
> + * This checker requires sock->sk to be locked.
> + */
> +static int check_tcp_socket_can_listen(struct socket *const sock)
> +{
> +	struct sock *sk = sock->sk;
> +	unsigned char cur_sk_state = sk->sk_state;
> +	const struct tcp_ulp_ops *icsk_ulp_ops;
> +

I think we can add this assert:
lockdep_assert_held(&sk->sk_lock.slock);

> +	/* Allows only unconnected TCP socket to listen (cf. inet_listen). */
> +	if (sock->state != SS_UNCONNECTED)
> +		return -EINVAL;
> +
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
> +	 * Sockets can listen only if ULP control hook has clone method.
> +	 */
> +	if (icsk_ulp_ops && !icsk_ulp_ops->clone)
> +		return -EINVAL;
> +	return 0;
> +}
