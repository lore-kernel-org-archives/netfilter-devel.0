Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EC018FDA2
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2024 08:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327868; cv=none; b=nFq1QQxz6EU8pBL1PIdSwIyXBblOj+qGUiDkRC+aE4aNLSA2Tbh52HtTsSiv+Fe8rjCd87IWMPWfpcCAhBmp2PgOOuUxxefZC1/NlgqiKThQN/11JmvMBJf2c/FnxRReVqMD2lnSVQSkEsjld2OG/Drc9Rudh9KR+gjUwlkEH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327868; c=relaxed/simple;
	bh=2uHxQS5aKMWh2kPpovXZi27KIf/tDW3ergHMdyPuVgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LSdRgDXy3haay7GMgW0C54R/b6XQ3fF8XH1+lkvUaGRzUiap1lvVMkOSkO8rJ051SzJNAKpqCiofxRnIHLj/ZM6ez4Jvx8GudphJ6S+1uZ5eRuh1WJGJOV9z5cyM3g3OlJPYVFkGRdtstr8Z8ZZD3hEngSOen6uh4SAQYSEDsGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zsE52QNo; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--gnoack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zsE52QNo"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b35859345so5484002276.2
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2024 01:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722327865; x=1722932665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=09LrO9zJocW7sBgmr7f+qecRkcjOtNz8Q6JyiO8R0pc=;
        b=zsE52QNot2n0Ug02UR+LSjgHRAjBb1vOVBZ2ZyrrwWROmA0Lno4scpowk72Ts3kxAI
         BVZ6QXmBaqWhU5q6q6vq4JHa/0ftr2OpIO6ge16ds4sVegFXS5Iq5HfsILQIdb3d7p03
         TMbGdKlmBIVtKWAP3YgEatLLZTbSuYqu4rG5MkNI4QPkQY0dm9uOcPD0ip+n73vAtL8t
         TwYz404wh5u8CW4pKFvsNJ4hLpWnB+5sA8oZV2DgjTx2QFcDNx3Rr11zV9iwM9afGE2a
         MnDyuBDObsCOJxM+wpjRz1/kIr6o+D9o6F97/6jbhRftZtYdkFulq9nffgTm3ZJGYT2z
         uJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722327865; x=1722932665;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=09LrO9zJocW7sBgmr7f+qecRkcjOtNz8Q6JyiO8R0pc=;
        b=JqSAvGvnu2hcFkPPs7mCZ0tawnQ4tLrdOR/+UpAV1I4yvqqonYZ0YiOcXvGJpWXi24
         zwNzPvOMNoGt2X/7oyCM3eSAFb5oCrqc8U3B5OYUHzlCT4RpGqtcEALg0Yzm8x4zqB9i
         rm9eg3LYJZ8kIttsk8lQMAplIXZOSsMxs98JLg2+wz+Bp6GEMratM6EY2vhUJN/T6iXp
         s9sQeJBbgvEoi9Z9NqNlX6I1mDvFRmUhE1hK8D1OGOj5w8JoSWvq75uqJGUDUjjGgIp0
         e/ja+CnU12JVkxDZd//YGvFENQyMRgziDXcZuTqsNcW80pnSbiw+YOihATHMp5juDVqA
         cDzg==
X-Forwarded-Encrypted: i=1; AJvYcCW4P7te/4Nc0IIISY1E66Cr00hXpPh6Ls+PInBIdaY8UihVOhQ3InQq514OOXUtnG+REwXhXCRMm+9OsyuhC6qZnGjwTCsGAbiaJJfeacgF
X-Gm-Message-State: AOJu0YzBYYjtn3mv25N3jS+zEqQrJCCmNaT75xWTyJX2lmSnzbn+D7xJ
	vTJmw3p5Hik78RE5DRoOqV1sRUmWlj+hR0AHt0EbSJYjF9gBHtPJxuT6m3zESQX6t6n5AEl7NCx
	T5Q==
X-Google-Smtp-Source: AGHT+IE0GdaENzmKS3iU3wF52+3rW+u0cpzuGOkE3HXo4IXpVdMBS8KYMnNu3L5OIimBGkKycHgWUFccoxk=
X-Received: from swim.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:1605])
 (user=gnoack job=sendgmr) by 2002:a05:6902:188a:b0:dfe:fe5e:990a with SMTP id
 3f1490d57ef6-e0b544ec634mr18964276.9.1722327865224; Tue, 30 Jul 2024 01:24:25
 -0700 (PDT)
Date: Tue, 30 Jul 2024 10:24:23 +0200
In-Reply-To: <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com> <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
Message-ID: <ZqijJPrnCnGnVGkq@google.com>
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
From: "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, alx@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

Thanks for sending these patches!

Most comments are about documentation so far.

In the implementation, I'm mostly unclear about the interaction with the
uncommon Upper Layer Protocols.  I'm also not very familiar with the socket
state machines, maybe someone from the netdev list would have time to doubl=
e
check that aspect?


On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
> LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
> ports to forbid a malicious sandboxed process to impersonate a legitimate
> server process. However, bind(2) might be used by (TCP) clients to set th=
e
> source port to a (legitimate) value. Controlling the ports that can be
> used for listening would allow (TCP) clients to explicitly bind to ports
> that are forbidden for listening.
>=20
> Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
> access right that restricts listening on undesired ports with listen(2).

Nit: I would turn around the first two commit message paragraphs and descri=
be
your changes first, before explaining the problems in the bind(2) support. =
 I
was initially a bit confused that the description started talking about
LANDLOCK_ACCESS_NET_BIND_TCP.

General recommendations at:
https://www.kernel.org/doc/html/v6.10/process/submitting-patches.html#descr=
ibe-your-changes


> It's worth noticing that this access right doesn't affect changing
> backlog value using listen(2) on already listening socket.
>=20
> * Create new LANDLOCK_ACCESS_NET_LISTEN_TCP flag.
> * Add hook to socket_listen(), which checks whether the socket is allowed
>   to listen on a binded local port.
> * Add check_tcp_socket_can_listen() helper, which validates socket
>   attributes before the actual access right check.
> * Update `struct landlock_net_port_attr` documentation with control of
>   binding to ephemeral port with listen(2) description.
> * Change ABI version to 6.
>=20
> Closes: https://github.com/landlock-lsm/linux/issues/15
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  include/uapi/linux/landlock.h                | 23 +++--
>  security/landlock/limits.h                   |  2 +-
>  security/landlock/net.c                      | 90 ++++++++++++++++++++
>  security/landlock/syscalls.c                 |  2 +-
>  tools/testing/selftests/landlock/base_test.c |  2 +-
>  5 files changed, 108 insertions(+), 11 deletions(-)
>=20
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.=
h
> index 68625e728f43..6b8df3293eee 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -104,13 +104,16 @@ struct landlock_net_port_attr {
>  	/**
>  	 * @port: Network port in host endianness.
>  	 *
> -	 * It should be noted that port 0 passed to :manpage:`bind(2)` will
> -	 * bind to an available port from a specific port range. This can be
> -	 * configured thanks to the ``/proc/sys/net/ipv4/ip_local_port_range``
> -	 * sysctl (also used for IPv6). A Landlock rule with port 0 and the
> -	 * ``LANDLOCK_ACCESS_NET_BIND_TCP`` right means that requesting to bind
> -	 * on port 0 is allowed and it will automatically translate to binding
> -	 * on the related port range.

Please rebase on a more recent revision, we have changed this phrasing in t=
he meantime:

 - s/a specific port range/the ephemeral port range/
 - The paragraph was split in two.

> +	 * It should be noted that some operations cause binding socket to a ra=
ndom
> +	 * available port from a specific port range. This can be configured th=
anks
> +	 * to the ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl (also used =
for
> +	 * IPv6). Following operation requests are automatically translate to
> +	 * binding on the related port range:
> +	 *
> +	 * - A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP=
``
> +	 *   right means that binding on port 0 is allowed.
> +	 * - A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_LISTEN_T=
CP``
> +	 *   right means listening without an explicit binding is allowed.

There are some grammatical problems in this documentation section.

Can I suggest an alternative?

  Some socket operations will fall back to using a port from the ephemeral =
port
  range, if no specific port is requested by the caller.  Among others, thi=
s
  happens in the following cases:

  - :manpage:`bind(2)` is invoked with a socket address that uses port 0.
  - :manpage:`listen(2)` is invoked on a socket without previously calling
    :manpage:`bind(2)`.

  These two actions, which implicitly use an ephemeral port, can be allowed=
 with
  a Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP`` /
  ``LANDLOCK_ACCESS_NET_LISTEN_TCP`` right.

  The ephemeral port range is configured in the
  ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl (also used for IPv6).

When we have the documentation wording finalized,
please send an update to the man pages as well,
for this and other documentation updates.

Small remarks on what I've done here:

* I am avoiding the word "binding" when referring to the automatic assignme=
nt to
  an ephemeral port - IMHO, this is potentially confusing, since bind(2) is=
 not
  explicitly called.
* I am also dropping the "It should be noted" / "Note that" phrase, which i=
s
  frowned upon in man pages.

>  	 */
>  	__u64 port;
>  };
> @@ -251,7 +254,7 @@ struct landlock_net_port_attr {
>   * DOC: net_access
>   *
>   * Network flags
> - * ~~~~~~~~~~~~~~~~
> + * ~~~~~~~~~~~~~
>   *
>   * These flags enable to restrict a sandboxed process to a set of networ=
k
>   * actions. This is supported since the Landlock ABI version 4.
> @@ -261,9 +264,13 @@ struct landlock_net_port_attr {
>   * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
>   * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>   *   a remote port.
> + * - %LANDLOCK_ACCESS_NET_LISTEN_TCP: Listen for TCP socket connections =
on
> + *   a local port. This access right is available since the sixth versio=
n
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
>  #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_F=
S)
> =20
> -#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_LISTEN_TCP
>  #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>  #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_=
NET)
> =20
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> index 669ba260342f..a29cb27c3f14 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -6,10 +6,12 @@
>   * Copyright =C2=A9 2022-2023 Microsoft Corporation
>   */
> =20
> +#include "net/sock.h"
>  #include <linux/in.h>
>  #include <linux/net.h>
>  #include <linux/socket.h>
>  #include <net/ipv6.h>
> +#include <net/tcp.h>
> =20
>  #include "common.h"
>  #include "cred.h"
> @@ -194,9 +196,97 @@ static int hook_socket_connect(struct socket *const =
sock,
>  					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>  }
> =20
> +/*
> + * Checks that socket state and attributes are correct for listen.
> + * It is required to not wrongfully return -EACCES instead of -EINVAL.
      ^^^^^^^^^^^^^^

Doc nit: I would just document that this function returns -EINVAL on failur=
e?
In this place, I would expect that the function interface is documented for
callers.  (From that perspective, this is not a requirement, but a guarante=
e
that the function gives.)

> + *
> + * This checker requires sock->sk to be locked.
> + */
> +static int check_tcp_socket_can_listen(struct socket *const sock)
> +{
> +	struct sock *sk =3D sock->sk;
> +	unsigned char cur_sk_state =3D sk->sk_state;
> +	const struct tcp_ulp_ops *icsk_ulp_ops;
> +
> +	/* Allows only unconnected TCP socket to listen (cf. inet_listen). */
> +	if (sock->state !=3D SS_UNCONNECTED)
> +		return -EINVAL;
> +
> +	/*
> +	 * Checks sock state. This is needed to ensure consistency with inet st=
ack
> +	 * error handling (cf. __inet_listen_sk).
> +	 */
> +	if (WARN_ON_ONCE(!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN))))
> +		return -EINVAL;
> +
> +	icsk_ulp_ops =3D inet_csk(sk)->icsk_ulp_ops;
> +
> +	/*
> +	 * ULP (Upper Layer Protocol) stands for protocols which are higher tha=
n
> +	 * transport protocol in OSI model. Linux has an infrastructure that
> +	 * allows TCP sockets to support logic of some ULP (e.g. TLS ULP).
> +	 *
> +	 * Sockets can listen only if ULP control hook has clone method.
> +	 */
> +	if (icsk_ulp_ops && !icsk_ulp_ops->clone)
> +		return -EINVAL;

This seems like an implementation detail in the networking subsystem?

If I understand correctly, these are cases where we use TCP on top of proto=
cols
that are not IP (or have an additional layer in the middle, like TLS?).  Th=
is
can not be recognized through the socket family or type?

Do we have cases where we can run TCP on top of something else than plain I=
Pv4
or IPv6, where the clone method exists?

> +	return 0;
> +}
> +
> +static int hook_socket_listen(struct socket *const sock, const int backl=
og)
> +{
> +	int err =3D 0;
> +	int family;
> +	__be16 port;
> +	struct sock *sk;
> +	const struct landlock_ruleset *const dom =3D get_current_net_domain();
> +
> +	if (!dom)
> +		return 0;
> +	if (WARN_ON_ONCE(dom->num_layers < 1))
> +		return -EACCES;
> +
> +	/* Checks if it's a (potential) TCP socket. */
> +	if (sock->type !=3D SOCK_STREAM)
> +		return 0;
> +
> +	sk =3D sock->sk;
> +	family =3D sk->__sk_common.skc_family;
> +	/*
> +	 * Socket cannot be assigned AF_UNSPEC because this type is used only
> +	 * in the context of addresses.
> +	 *
> +	 * Doesn't restrict listening for non-TCP sockets.
> +	 */
> +	if (family !=3D AF_INET && family !=3D AF_INET6)
> +		return 0;

Aren't the socket type and family checks duplicated with existing logic tha=
t we
have for the connect(2) and bind(2) support?  Should it be deduplicated, or=
 is
that too messy?

> +
> +	lock_sock(sk);
> +	/*
> +	 * Calling listen(2) for a listening socket does nothing with its state=
 and
> +	 * only changes backlog value (cf. __inet_listen_sk). Checking of liste=
n
> +	 * access right is not required.
> +	 */
> +	if (sk->sk_state =3D=3D TCP_LISTEN)
> +		goto release_nocheck;
> +
> +	err =3D check_tcp_socket_can_listen(sock);
> +	if (unlikely(err))
> +		goto release_nocheck;
> +
> +	port =3D htons(inet_sk(sk)->inet_num);
> +	release_sock(sk);
> +	return check_access_socket(dom, port, LANDLOCK_ACCESS_NET_LISTEN_TCP);
> +
> +release_nocheck:
> +	release_sock(sk);
> +	return err;
> +}

Thanks for sending these patches!

=E2=80=94G=C3=BCnther
