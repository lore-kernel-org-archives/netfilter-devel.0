Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE4610E0
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2024 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722523526; cv=none; b=uB4k2S4USiZCIb2xgx5Vgo4O4pW1hnjVAsmCwETPHxFs4BKK59HWMgrUR3Cl12TYx0Qz/wnyaHZudEVLLjCmwmzWj8/9C6IngV2h7OnkiioIyDCbOiInKJIi/JaBGxitn9+6p8pGxtuCnGwPu1PCy1sFm9VNxqe53O/UTyaSgFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722523526; c=relaxed/simple;
	bh=9TELWxhWElOP4bSzxJDZidKkImIQDyHwS6M0fWoWxZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Om78r7vtIfyV7ezkPdbu7iWmfdr2aO2pLMUN2xcUg8M9pW8bkgtcjVZnpinHOR2KGSswrB+t9X9Kbr3s/+AvqE0LB/Gi4Wc4XyCKOvt4kI2m2DBXBOOJFpMNkDIr8+2ayz3dv/5jof/iMSiLOFOnBGDuplKWbzUw9YkIz9csWC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=0/qxh28v; arc=none smtp.client-ip=45.157.188.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="0/qxh28v"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4WZWwC54nXzwR4;
	Thu,  1 Aug 2024 16:45:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1722523515;
	bh=aeog2hiGt/OigAqa8alpWIae6eqE08tPxSVHP2fkYo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0/qxh28v44seBIYGOp1hEvLlNeA6aLtyPnEKnQQOkOUBF5O4z5CxgJX8052FR30Nk
	 4tE9kc8hw3ltutQ9loc4DfHpXVoRy0Ib2FFU5j2zb5+LsUw14hxSx/IvJPdSJYmvrP
	 KsPYRF7uHNC7TIKIQ4TbwlW0oM+v4i6mGFYlw7iA=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4WZWwB5G20zj1Q;
	Thu,  1 Aug 2024 16:45:14 +0200 (CEST)
Date: Thu, 1 Aug 2024 16:45:07 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
Message-ID: <20240801.EeshaeThai9j@digikod.net>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
 <20240731.AFooxaeR5mie@digikod.net>
 <68568a44-2079-33ac-592d-c2677acf50dd@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68568a44-2079-33ac-592d-c2677acf50dd@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Thu, Aug 01, 2024 at 10:52:25AM +0300, Mikhail Ivanov wrote:
> 7/31/2024 9:30 PM, Mickaël Salaün wrote:
> > On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
> > > LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
> > > ports to forbid a malicious sandboxed process to impersonate a legitimate
> > > server process. However, bind(2) might be used by (TCP) clients to set the
> > > source port to a (legitimate) value. Controlling the ports that can be
> > > used for listening would allow (TCP) clients to explicitly bind to ports
> > > that are forbidden for listening.
> > > 
> > > Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
> > > access right that restricts listening on undesired ports with listen(2).
> > > 
> > > It's worth noticing that this access right doesn't affect changing
> > > backlog value using listen(2) on already listening socket.
> > > 
> > > * Create new LANDLOCK_ACCESS_NET_LISTEN_TCP flag.
> > > * Add hook to socket_listen(), which checks whether the socket is allowed
> > >    to listen on a binded local port.
> > > * Add check_tcp_socket_can_listen() helper, which validates socket
> > >    attributes before the actual access right check.
> > > * Update `struct landlock_net_port_attr` documentation with control of
> > >    binding to ephemeral port with listen(2) description.
> > > * Change ABI version to 6.
> > > 
> > > Closes: https://github.com/landlock-lsm/linux/issues/15
> > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > 
> > Thanks for this series!
> > 
> > I cannot apply this patch series though, could you please provide the
> > base commit?  BTW, this can be automatically put in the cover letter
> > with the git format-patch's --base argument.
> 
> base-commit: 591561c2b47b7e7225e229e844f5de75ce0c09ec

Thanks, the following commit makes this series to not apply.

> 
> Günther said that I should rebase to the latest commits, so I'll do
> it in the next version of this patchset.

Yep, currently we're on v6.11-rc1, but please specify the base commit
each time.

> 
> > 
> > > ---
> > >   include/uapi/linux/landlock.h                | 23 +++--
> > >   security/landlock/limits.h                   |  2 +-
> > >   security/landlock/net.c                      | 90 ++++++++++++++++++++
> > >   security/landlock/syscalls.c                 |  2 +-
> > >   tools/testing/selftests/landlock/base_test.c |  2 +-
> > >   5 files changed, 108 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> > > index 68625e728f43..6b8df3293eee 100644
> > > --- a/include/uapi/linux/landlock.h
> > > +++ b/include/uapi/linux/landlock.h
> > > @@ -104,13 +104,16 @@ struct landlock_net_port_attr {
> > >   	/**
> > >   	 * @port: Network port in host endianness.
> > >   	 *
> > > -	 * It should be noted that port 0 passed to :manpage:`bind(2)` will
> > > -	 * bind to an available port from a specific port range. This can be
> > > -	 * configured thanks to the ``/proc/sys/net/ipv4/ip_local_port_range``
> > > -	 * sysctl (also used for IPv6). A Landlock rule with port 0 and the
> > > -	 * ``LANDLOCK_ACCESS_NET_BIND_TCP`` right means that requesting to bind
> > > -	 * on port 0 is allowed and it will automatically translate to binding
> > > -	 * on the related port range.
> > > +	 * It should be noted that some operations cause binding socket to a random
> > > +	 * available port from a specific port range. This can be configured thanks
> > > +	 * to the ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl (also used for
> > > +	 * IPv6). Following operation requests are automatically translate to
> > > +	 * binding on the related port range:
> > > +	 *
> > > +	 * - A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP``
> > > +	 *   right means that binding on port 0 is allowed.
> > > +	 * - A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_LISTEN_TCP``
> > > +	 *   right means listening without an explicit binding is allowed.
> > >   	 */
> > >   	__u64 port;
> > >   };
> > > @@ -251,7 +254,7 @@ struct landlock_net_port_attr {
> > >    * DOC: net_access
> > >    *
> > >    * Network flags
> > > - * ~~~~~~~~~~~~~~~~
> > > + * ~~~~~~~~~~~~~
> > >    *
> > >    * These flags enable to restrict a sandboxed process to a set of network
> > >    * actions. This is supported since the Landlock ABI version 4.
> > > @@ -261,9 +264,13 @@ struct landlock_net_port_attr {
> > >    * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
> > >    * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
> > >    *   a remote port.
> > > + * - %LANDLOCK_ACCESS_NET_LISTEN_TCP: Listen for TCP socket connections on
> > > + *   a local port. This access right is available since the sixth version
> > > + *   of the Landlock ABI.
> > >    */
> > >   /* clang-format off */
> > >   #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
> > >   #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
> > > +#define LANDLOCK_ACCESS_NET_LISTEN_TCP			(1ULL << 2)
> > >   /* clang-format on */
> > >   #endif /* _UAPI_LINUX_LANDLOCK_H */
> > > diff --git a/security/landlock/limits.h b/security/landlock/limits.h
> > > index 4eb643077a2a..2ef147389474 100644
> > > --- a/security/landlock/limits.h
> > > +++ b/security/landlock/limits.h
> > > @@ -22,7 +22,7 @@
> > >   #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
> > >   #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
> > > -#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_LISTEN_TCP
> > >   #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
> > >   #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
> > > diff --git a/security/landlock/net.c b/security/landlock/net.c
> > > index 669ba260342f..a29cb27c3f14 100644
> > > --- a/security/landlock/net.c
> > > +++ b/security/landlock/net.c
> > > @@ -6,10 +6,12 @@
> > >    * Copyright © 2022-2023 Microsoft Corporation
> > >    */
> > > +#include "net/sock.h"
> > 
> > These should not be quotes.
> 
> will be fixed, thanks
> 
> > 
> > >   #include <linux/in.h>
> > >   #include <linux/net.h>
> > >   #include <linux/socket.h>
> > >   #include <net/ipv6.h>
> > > +#include <net/tcp.h>
> > >   #include "common.h"
> > >   #include "cred.h"
> > > @@ -194,9 +196,97 @@ static int hook_socket_connect(struct socket *const sock,
> > >   					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
> > >   }
> > > +/*
> > > + * Checks that socket state and attributes are correct for listen.
> > > + * It is required to not wrongfully return -EACCES instead of -EINVAL.
> > > + *
> > > + * This checker requires sock->sk to be locked.
> > > + */
> > > +static int check_tcp_socket_can_listen(struct socket *const sock)
> > 
> > Is this function still useful with the listen LSM hook?
> 
> Yeap, we need to validate socket structure before checking the access
> right. You can see [1] and [2] where the behavior of this function is
> tested.
> 
> [1] https://lore.kernel.org/all/20240728002602.3198398-6-ivanov.mikhail1@huawei-partners.com/
> [2] https://lore.kernel.org/all/20240728002602.3198398-8-ivanov.mikhail1@huawei-partners.com/

OK, that's good.

> 
> > 
> > > +{
> > > +	struct sock *sk = sock->sk;
> > > +	unsigned char cur_sk_state = sk->sk_state;
> > > +	const struct tcp_ulp_ops *icsk_ulp_ops;
> > > +
> > > +	/* Allows only unconnected TCP socket to listen (cf. inet_listen). */
> > > +	if (sock->state != SS_UNCONNECTED)
> > > +		return -EINVAL;
> > > +
> > > +	/*
> > > +	 * Checks sock state. This is needed to ensure consistency with inet stack
> > > +	 * error handling (cf. __inet_listen_sk).
> > > +	 */
> > > +	if (WARN_ON_ONCE(!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN))))
> > > +		return -EINVAL;
> > > +
> > > +	icsk_ulp_ops = inet_csk(sk)->icsk_ulp_ops;
> > > +
> > > +	/*
> > > +	 * ULP (Upper Layer Protocol) stands for protocols which are higher than
> > > +	 * transport protocol in OSI model. Linux has an infrastructure that
> > > +	 * allows TCP sockets to support logic of some ULP (e.g. TLS ULP).
> > > +	 *
> > > +	 * Sockets can listen only if ULP control hook has clone method.
> > > +	 */
> > > +	if (icsk_ulp_ops && !icsk_ulp_ops->clone)
> > > +		return -EINVAL;
> > > +	return 0;
> > > +}
> > > +
> > > +static int hook_socket_listen(struct socket *const sock, const int backlog)
> > > +{
> > 
> > Why can't we just call current_check_access_socket()?
> 
> I've mentioned in the message of the previous commit that this method
> has address checks for bind(2) and connect(2). In the case of listen(2)
> port is extracted from the socket structure, so calling
> current_check_access_socket() would be pointless.

Yep, I missed the check_access_socket() refactoring.

> 
> > 
> > > +	int err = 0;
> > > +	int family;
> > > +	__be16 port;
> > > +	struct sock *sk;
> > > +	const struct landlock_ruleset *const dom = get_current_net_domain();
> > > +
> > > +	if (!dom)
> > > +		return 0;
> > > +	if (WARN_ON_ONCE(dom->num_layers < 1))
> > > +		return -EACCES;
> > > +
> > > +	/* Checks if it's a (potential) TCP socket. */
> > > +	if (sock->type != SOCK_STREAM)
> > > +		return 0;
> > > +
> > > +	sk = sock->sk;
> > > +	family = sk->__sk_common.skc_family;
> > > +	/*
> > > +	 * Socket cannot be assigned AF_UNSPEC because this type is used only
> > > +	 * in the context of addresses.
> > > +	 *
> > > +	 * Doesn't restrict listening for non-TCP sockets.
> > > +	 */
> > > +	if (family != AF_INET && family != AF_INET6)
> > > +		return 0;
> > > +
> > > +	lock_sock(sk);
> > > +	/*
> > > +	 * Calling listen(2) for a listening socket does nothing with its state and
> > > +	 * only changes backlog value (cf. __inet_listen_sk). Checking of listen
> > > +	 * access right is not required.
> > > +	 */
> > > +	if (sk->sk_state == TCP_LISTEN)
> > > +		goto release_nocheck;
> > > +
> > > +	err = check_tcp_socket_can_listen(sock);
> > > +	if (unlikely(err))
> > > +		goto release_nocheck;
> > > +
> > > +	port = htons(inet_sk(sk)->inet_num);
> > > +	release_sock(sk);
> > > +	return check_access_socket(dom, port, LANDLOCK_ACCESS_NET_LISTEN_TCP);
> > > +
> > > +release_nocheck:
> > > +	release_sock(sk);
> > > +	return err;
> > > +}
> > > +
> > >   static struct security_hook_list landlock_hooks[] __ro_after_init = {
> > >   	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
> > >   	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
> > > +	LSM_HOOK_INIT(socket_listen, hook_socket_listen),
> > >   };
> > >   __init void landlock_add_net_hooks(void)
> > > diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> > > index 03b470f5a85a..3752bcc033d4 100644
> > > --- a/security/landlock/syscalls.c
> > > +++ b/security/landlock/syscalls.c
> > > @@ -149,7 +149,7 @@ static const struct file_operations ruleset_fops = {
> > >   	.write = fop_dummy_write,
> > >   };
> > > -#define LANDLOCK_ABI_VERSION 5
> > > +#define LANDLOCK_ABI_VERSION 6
> > >   /**
> > >    * sys_landlock_create_ruleset - Create a new ruleset
> > > diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
> > > index 3c1e9f35b531..52b00472a487 100644
> > > --- a/tools/testing/selftests/landlock/base_test.c
> > > +++ b/tools/testing/selftests/landlock/base_test.c
> > > @@ -75,7 +75,7 @@ TEST(abi_version)
> > >   	const struct landlock_ruleset_attr ruleset_attr = {
> > >   		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
> > >   	};
> > > -	ASSERT_EQ(5, landlock_create_ruleset(NULL, 0,
> > > +	ASSERT_EQ(6, landlock_create_ruleset(NULL, 0,
> > >   					     LANDLOCK_CREATE_RULESET_VERSION));
> > >   	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
> > > -- 
> > > 2.34.1
> > > 
> > > 
> 
