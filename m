Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [45.157.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BBC1A8F7A
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2024 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733340760; cv=none; b=R8J3VoxH1KgZFIAECe5qK8/ESdm7ZZ8+ov9AQ+Ch7O8YwpEoDcckcpUSJhihfXQBRS9jbK6vfV6zarZmzQTg87SqGdGQOjYdFxEwiAw/jycj99GGwEwboinOMqdonNqU+pKL331U3pBTT3voWtAuRav3ROkjlIUVYfR+WZrM+qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733340760; c=relaxed/simple;
	bh=kUfdxp26V3MkmIFL9pdEPQ3I7Befj/l6pnri40Lwu+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/Sl0p93H++NxMiDvtviK7oTHQVtQjAbkmGkpYYkaffq7ooPm3xzxaAPPUPbTIWrh7WtYJUxtb0aB/iFBG0Tbz6Nkf3Qo4LlkpwnIVCs+U9bvErf9BVzQBfHmR5uLVeXE+jelYsXr5VcPcWF1DP9+6lSc9O9N8l5XY/uqmc0lDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=TTjTEqx1; arc=none smtp.client-ip=45.157.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="TTjTEqx1"
Received: from smtp-4-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10:40ca:feff:fe05:0])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Y3SN21FfyzPrl;
	Wed,  4 Dec 2024 20:32:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733340754;
	bh=bBc4+NrFY5fC1DdWWnl1xhtUZ+a+YH5MbM076jmmPqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTjTEqx1wDZ7DShAlGtetoX4k6QghzimlljPUTOf+PGPxmODgohEoKmqZIJnewxgu
	 vqJCd5Bu18VVXwWMAjGGG3AmVlHH9XMyEKt0FoHlRZbZ6mbUmI5EE9+/ysjJq8Ax18
	 AMlchYzjhdQ1Mf4MRmyskLpKzadCaw98trlPym0Q=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Y3SN14Jv0zFc;
	Wed,  4 Dec 2024 20:32:33 +0100 (CET)
Date: Wed, 4 Dec 2024 20:32:32 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: gnoack@google.com, willemdebruijn.kernel@gmail.com, matthieu@buffet.re, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 3/8] landlock: Fix inconsistency of errors for TCP
 actions
Message-ID: <20241204.ibahfoo6thuG@digikod.net>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-4-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241017110454.265818-4-ivanov.mikhail1@huawei-partners.com>
X-Infomaniak-Routing: alpha

Something is wrong with this patch.

On Thu, Oct 17, 2024 at 07:04:49PM +0800, Mikhail Ivanov wrote:
> Add two helpers for TCP bind/connect accesses, which will serve to perform
> action-specific network stack level checks and safely extract the port from
> the address.
> 
> Return -EAFNOSUPPORT instead of -EINVAL in sin_family checks.
> 
> Check socket state before validating address for TCP connect access. This
> is necessary to follow the error order of network stack.
> 
> Read sk_family value from socket structure with READ_ONCE to safely handle
> IPV6_ADDRFORM case (see [1]).
> 
> [1] https://lore.kernel.org/all/20240202095404.183274-1-edumazet@google.com/
> 
> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> ---
>  security/landlock/net.c | 543 +++++++++++++++++++++++-----------------
>  1 file changed, 315 insertions(+), 228 deletions(-)
>  rewrite security/landlock/net.c (37%)
> 
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> dissimilarity index 37%
> index a3142f9b15ee..06791aba9196 100644
> --- a/security/landlock/net.c
> +++ b/security/landlock/net.c
> @@ -1,228 +1,315 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * Landlock LSM - Network management and hooks
> - *
> - * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
> - * Copyright © 2022-2023 Microsoft Corporation
> - */
> -
> -#include <linux/in.h>
> -#include <linux/net.h>
> -#include <linux/socket.h>
> -#include <net/ipv6.h>
> -
> -#include "common.h"
> -#include "cred.h"
> -#include "limits.h"
> -#include "net.h"
> -#include "ruleset.h"
> -
> -int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
> -			     const u16 port, access_mask_t access_rights)
> -{
> -	int err;
> -	const struct landlock_id id = {
> -		.key.data = (__force uintptr_t)htons(port),
> -		.type = LANDLOCK_KEY_NET_PORT,
> -	};
> -
> -	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> -
> -	/* Transforms relative access rights to absolute ones. */
> -	access_rights |= LANDLOCK_MASK_ACCESS_NET &
> -			 ~landlock_get_net_access_mask(ruleset, 0);
> -
> -	mutex_lock(&ruleset->lock);
> -	err = landlock_insert_rule(ruleset, id, access_rights);
> -	mutex_unlock(&ruleset->lock);
> -
> -	return err;
> -}
> -
> -static const struct landlock_ruleset *get_current_net_domain(void)
> -{
> -	const union access_masks any_net = {
> -		.net = ~0,
> -	};
> -
> -	return landlock_match_ruleset(landlock_get_current_domain(), any_net);
> -}
> -
> -static int check_access_port(const struct landlock_ruleset *const dom,
> -			     __be16 port, access_mask_t access_request)
> -{
> -	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
> -	const struct landlock_rule *rule;
> -	struct landlock_id id = {
> -		.type = LANDLOCK_KEY_NET_PORT,
> -	};
> -
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
> -}
> -
> -static int hook_socket_bind(struct socket *const sock,
> -			    struct sockaddr *const address, const int addrlen)
> -{
> -	__be16 port;
> -	struct sock *const sk = sock->sk;
> -	const struct landlock_ruleset *const dom = get_current_net_domain();
> -
> -	if (!dom)
> -		return 0;
> -	if (WARN_ON_ONCE(dom->num_layers < 1))
> -		return -EACCES;
> -
> -	if (sk_is_tcp(sk)) {
> -		/* Checks for minimal header length to safely read sa_family. */
> -		if (addrlen < offsetofend(typeof(*address), sa_family))
> -			return -EINVAL;
> -
> -		switch (address->sa_family) {
> -		case AF_UNSPEC:
> -		case AF_INET:
> -			if (addrlen < sizeof(struct sockaddr_in))
> -				return -EINVAL;
> -			port = ((struct sockaddr_in *)address)->sin_port;
> -			break;
> -
> -#if IS_ENABLED(CONFIG_IPV6)
> -		case AF_INET6:
> -			if (addrlen < SIN6_LEN_RFC2133)
> -				return -EINVAL;
> -			port = ((struct sockaddr_in6 *)address)->sin6_port;
> -			break;
> -#endif /* IS_ENABLED(CONFIG_IPV6) */
> -
> -		default:
> -			return 0;
> -		}
> -
> -		/*
> -		 * For compatibility reason, accept AF_UNSPEC for bind
> -		 * accesses (mapped to AF_INET) only if the address is
> -		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
> -		 * required to not wrongfully return -EACCES instead of
> -		 * -EAFNOSUPPORT.
> -		 *
> -		 * We could return 0 and let the network stack handle these
> -		 * checks, but it is safer to return a proper error and test
> -		 * consistency thanks to kselftest.
> -		 */
> -		if (address->sa_family == AF_UNSPEC) {
> -			/* addrlen has already been checked for AF_UNSPEC. */
> -			const struct sockaddr_in *const sockaddr =
> -				(struct sockaddr_in *)address;
> -
> -			if (sk->sk_family != AF_INET)
> -				return -EINVAL;
> -
> -			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
> -				return -EAFNOSUPPORT;
> -		} else {
> -			/*
> -			 * Checks sa_family consistency to not wrongfully return
> -			 * -EACCES instead of -EINVAL.  Valid sa_family changes are
> -			 * only (from AF_INET or AF_INET6) to AF_UNSPEC.
> -			 *
> -			 * We could return 0 and let the network stack handle this
> -			 * check, but it is safer to return a proper error and test
> -			 * consistency thanks to kselftest.
> -			 */
> -			if (address->sa_family != sk->sk_family)
> -				return -EINVAL;
> -		}
> -		return check_access_port(dom, port,
> -					 LANDLOCK_ACCESS_NET_BIND_TCP);
> -	}
> -	return 0;
> -}
> -
> -static int hook_socket_connect(struct socket *const sock,
> -			       struct sockaddr *const address,
> -			       const int addrlen)
> -{
> -	__be16 port;
> -	struct sock *const sk = sock->sk;
> -	const struct landlock_ruleset *const dom = get_current_net_domain();
> -
> -	if (!dom)
> -		return 0;
> -	if (WARN_ON_ONCE(dom->num_layers < 1))
> -		return -EACCES;
> -
> -	if (sk_is_tcp(sk)) {
> -		/* Checks for minimal header length to safely read sa_family. */
> -		if (addrlen < offsetofend(typeof(*address), sa_family))
> -			return -EINVAL;
> -
> -		switch (address->sa_family) {
> -		case AF_UNSPEC:
> -		case AF_INET:
> -			if (addrlen < sizeof(struct sockaddr_in))
> -				return -EINVAL;
> -			port = ((struct sockaddr_in *)address)->sin_port;
> -			break;
> -
> -#if IS_ENABLED(CONFIG_IPV6)
> -		case AF_INET6:
> -			if (addrlen < SIN6_LEN_RFC2133)
> -				return -EINVAL;
> -			port = ((struct sockaddr_in6 *)address)->sin6_port;
> -			break;
> -#endif /* IS_ENABLED(CONFIG_IPV6) */
> -
> -		default:
> -			return 0;
> -		}
> -
> -		/*
> -		 * Connecting to an address with AF_UNSPEC dissolves the TCP
> -		 * association, which have the same effect as closing the
> -		 * connection while retaining the socket object (i.e., the file
> -		 * descriptor).  As for dropping privileges, closing
> -		 * connections is always allowed.
> -		 *
> -		 * For a TCP access control system, this request is legitimate.
> -		 * Let the network stack handle potential inconsistencies and
> -		 * return -EINVAL if needed.
> -		 */
> -		if (address->sa_family == AF_UNSPEC)
> -			return 0;
> -		/*
> -		 * Checks sa_family consistency to not wrongfully return
> -		 * -EACCES instead of -EINVAL.  Valid sa_family changes are
> -		 * only (from AF_INET or AF_INET6) to AF_UNSPEC.
> -		 *
> -		 * We could return 0 and let the network stack handle this
> -		 * check, but it is safer to return a proper error and test
> -		 * consistency thanks to kselftest.
> -		 */
> -		if (address->sa_family != sk->sk_family)
> -			return -EINVAL;
> -
> -		return check_access_port(dom, port,
> -					 LANDLOCK_ACCESS_NET_CONNECT_TCP);
> -	}
> -	return 0;
> -}
> -
> -static struct security_hook_list landlock_hooks[] __ro_after_init = {
> -	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
> -	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
> -};
> -
> -__init void landlock_add_net_hooks(void)
> -{
> -	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
> -			   &landlock_lsmid);
> -}
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock LSM - Network management and hooks
> + *
> + * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
> + * Copyright © 2022-2023 Microsoft Corporation
> + */
> +
> +#include <linux/in.h>
> +#include <linux/net.h>
> +#include <linux/socket.h>
> +#include <net/ipv6.h>
> +
> +#include "common.h"
> +#include "cred.h"
> +#include "limits.h"
> +#include "net.h"
> +#include "ruleset.h"
> +
> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
> +			     const u16 port, access_mask_t access_rights)
> +{
> +	int err;
> +	const struct landlock_id id = {
> +		.key.data = (__force uintptr_t)htons(port),
> +		.type = LANDLOCK_KEY_NET_PORT,
> +	};
> +
> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> +
> +	/* Transforms relative access rights to absolute ones. */
> +	access_rights |= LANDLOCK_MASK_ACCESS_NET &
> +			 ~landlock_get_net_access_mask(ruleset, 0);
> +
> +	mutex_lock(&ruleset->lock);
> +	err = landlock_insert_rule(ruleset, id, access_rights);
> +	mutex_unlock(&ruleset->lock);
> +
> +	return err;
> +}
> +
> +static const struct landlock_ruleset *get_current_net_domain(void)
> +{
> +	const union access_masks any_net = {
> +		.net = ~0,
> +	};
> +
> +	return landlock_match_ruleset(landlock_get_current_domain(), any_net);
> +}
> +
> +static int check_access_port(const struct landlock_ruleset *const dom,
> +			     __be16 port, access_mask_t access_request)
> +{
> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
> +	const struct landlock_rule *rule;
> +	struct landlock_id id = {
> +		.type = LANDLOCK_KEY_NET_PORT,
> +	};
> +
> +	id.key.data = (__force uintptr_t)port;
> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> +
> +	rule = landlock_find_rule(dom, id);
> +	access_request = landlock_init_layer_masks(
> +		dom, access_request, &layer_masks, LANDLOCK_KEY_NET_PORT);
> +	if (landlock_unmask_layers(rule, access_request, &layer_masks,
> +				   ARRAY_SIZE(layer_masks)))
> +		return 0;
> +
> +	return -EACCES;
> +}
> +
> +/*
> + * Checks that TCP @sock and @address attributes are correct for bind(2).
> + *
> + * On success, extracts port from @address in @port and returns 0.
> + *
> + * This validation is consistent with network stack and returns the error
> + * in the order corresponding to the order of errors from the network stack.
> + * It's required to not wrongfully return -EACCES instead of meaningful network
> + * stack level errors. Consistency is tested with kselftest.
> + *
> + * This helper does not provide consistency of error codes for BPF filter
> + * (if any).
> + */
> +static int
> +check_tcp_bind_consistency_and_get_port(struct socket *const sock,
> +					struct sockaddr *const address,
> +					const int addrlen, __be16 *port)
> +{
> +	/* IPV6_ADDRFORM can change sk->sk_family under us. */
> +	switch (READ_ONCE(sock->sk->sk_family)) {
> +	case AF_INET:
> +		const struct sockaddr_in *const addr =
> +			(struct sockaddr_in *)address;
> +
> +		/* Cf. inet_bind_sk(). */
> +		if (addrlen < sizeof(struct sockaddr_in))
> +			return -EINVAL;
> +		/*
> +		 * For compatibility reason, accept AF_UNSPEC for bind
> +		 * accesses (mapped to AF_INET) only if the address is
> +		 * INADDR_ANY (cf. __inet_bind).
> +		 */
> +		if (addr->sin_family != AF_INET) {
> +			if (addr->sin_family != AF_UNSPEC ||
> +			    addr->sin_addr.s_addr != htonl(INADDR_ANY))
> +				return -EAFNOSUPPORT;
> +		}
> +		*port = ((struct sockaddr_in *)address)->sin_port;
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		/* Cf. inet6_bind_sk(). */
> +		if (addrlen < SIN6_LEN_RFC2133)
> +			return -EINVAL;
> +		/* Cf. __inet6_bind(). */
> +		if (address->sa_family != AF_INET6)
> +			return -EAFNOSUPPORT;
> +		*port = ((struct sockaddr_in6 *)address)->sin6_port;
> +		break;
> +#endif /* IS_ENABLED(CONFIG_IPV6) */
> +	default:
> +		WARN_ON_ONCE(0);
> +		return -EACCES;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Checks that TCP @sock and @address attributes are correct for connect(2).
> + *
> + * On success, extracts port from @address in @port and returns 0.
> + *
> + * This validation is consistent with network stack and returns the error
> + * in the order corresponding to the order of errors from the network stack.
> + * It's required to not wrongfully return -EACCES instead of meaningful network
> + * stack level error. Consistency is partially tested with kselftest.
> + *
> + * This helper does not provide consistency of error codes for BPF filter
> + * (if any).
> + *
> + * The function holds socket lock while checking the socket state.
> + */
> +static int
> +check_tcp_connect_consistency_and_get_port(struct socket *const sock,
> +					   struct sockaddr *const address,
> +					   const int addrlen, __be16 *port)
> +{
> +	int err = 0;
> +	struct sock *const sk = sock->sk;
> +
> +	/* Cf. __inet_stream_connect(). */
> +	lock_sock(sk);
> +	switch (sock->state) {
> +	default:
> +		err = -EINVAL;
> +		break;
> +	case SS_CONNECTED:
> +		err = -EISCONN;
> +		break;
> +	case SS_CONNECTING:
> +		/*
> +		 * Calling connect(2) on nonblocking socket with SYN_SENT or SYN_RECV
> +		 * state immediately returns -EISCONN and -EALREADY (Cf. __inet_stream_connect()).
> +		 *
> +		 * This check is not tested with kselftests.
> +		 */
> +		if ((sock->file->f_flags & O_NONBLOCK) &&
> +		    ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))) {
> +			if (inet_test_bit(DEFER_CONNECT, sk))
> +				err = -EISCONN;
> +			else
> +				err = -EALREADY;
> +			break;
> +		}
> +
> +		/*
> +		 * Current state is possible in two cases:
> +		 * 1. connect(2) is called upon nonblocking socket and previous
> +		 *    connection attempt was closed by RST packet (therefore socket is
> +		 *    in TCP_CLOSE state). In this case connect(2) calls
> +		 *    sk_prot->disconnect(), changes socket state and increases number
> +		 *    of disconnects.
> +		 * 2. connect(2) is called twice upon socket with TCP_FASTOPEN_CONNECT
> +		 *    option set. If socket state is TCP_CLOSE connect(2) does the
> +		 *    same logic as in point 1 case. Otherwise connect(2) may freeze
> +		 *    after inet_wait_for_connect() call since SYN was never sent.
> +		 *
> +		 * For both this cases Landlock cannot provide error consistency since
> +		 * 1. Both cases involve executing some network stack logic and changing
> +		 *    the socket state.
> +		 * 2. It cannot omit access check and allow network stack handle error
> +		 *    consistency since socket can change its state to SS_UNCONNECTED
> +		 *    before it will be locked again in inet_stream_connect().
> +		 *
> +		 * Therefore it is only possible to return 0 and check access right with
> +		 * check_access_port() helper.
> +		 */
> +		release_sock(sk);
> +		return 0;
> +	case SS_UNCONNECTED:
> +		if (sk->sk_state != TCP_CLOSE)
> +			err = -EISCONN;
> +		break;
> +	}
> +	release_sock(sk);
> +
> +	if (err)
> +		return err;
> +
> +	/* IPV6_ADDRFORM can change sk->sk_family under us. */
> +	switch (READ_ONCE(sk->sk_family)) {
> +	case AF_INET:
> +		/* Cf. tcp_v4_connect(). */
> +		if (addrlen < sizeof(struct sockaddr_in))
> +			return -EINVAL;
> +		if (address->sa_family != AF_INET)
> +			return -EAFNOSUPPORT;
> +
> +		*port = ((struct sockaddr_in *)address)->sin_port;
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		/* Cf. tcp_v6_connect(). */
> +		if (addrlen < SIN6_LEN_RFC2133)
> +			return -EINVAL;
> +		if (address->sa_family != AF_INET6)
> +			return -EAFNOSUPPORT;
> +
> +		*port = ((struct sockaddr_in6 *)address)->sin6_port;
> +		break;
> +#endif /* IS_ENABLED(CONFIG_IPV6) */
> +	default:
> +		WARN_ON_ONCE(0);
> +		return -EACCES;
> +	}
> +
> +	return 0;
> +}
> +
> +static int hook_socket_bind(struct socket *const sock,
> +			    struct sockaddr *const address, const int addrlen)
> +{
> +	int err;
> +	__be16 port;
> +	const struct landlock_ruleset *const dom = get_current_net_domain();
> +
> +	if (!dom)
> +		return 0;
> +	if (WARN_ON_ONCE(dom->num_layers < 1))
> +		return -EACCES;
> +
> +	if (sk_is_tcp(sock->sk)) {
> +		err = check_tcp_bind_consistency_and_get_port(sock, address,
> +							      addrlen, &port);
> +		if (err)
> +			return err;
> +		return check_access_port(dom, port,
> +					 LANDLOCK_ACCESS_NET_BIND_TCP);
> +	}
> +	return 0;
> +}
> +
> +static int hook_socket_connect(struct socket *const sock,
> +			       struct sockaddr *const address,
> +			       const int addrlen)
> +{
> +	int err;
> +	__be16 port;
> +	const struct landlock_ruleset *const dom = get_current_net_domain();
> +
> +	if (!dom)
> +		return 0;
> +	if (WARN_ON_ONCE(dom->num_layers < 1))
> +		return -EACCES;
> +
> +	if (sk_is_tcp(sock->sk)) {
> +		/* Checks for minimal header length to safely read sa_family. */
> +		if (addrlen < sizeof(address->sa_family))
> +			return -EINVAL;
> +		/*
> +		 * Connecting to an address with AF_UNSPEC dissolves the TCP
> +		 * association, which have the same effect as closing the
> +		 * connection while retaining the socket object (i.e., the file
> +		 * descriptor).  As for dropping privileges, closing
> +		 * connections is always allowed.
> +		 *
> +		 * For a TCP access control system, this request is legitimate.
> +		 * Let the network stack handle potential inconsistencies and
> +		 * return -EINVAL if needed.
> +		 */
> +		if (address->sa_family == AF_UNSPEC)
> +			return 0;
> +
> +		err = check_tcp_connect_consistency_and_get_port(
> +			sock, address, addrlen, &port);
> +		if (err)
> +			return err;
> +		return check_access_port(dom, port,
> +					 LANDLOCK_ACCESS_NET_CONNECT_TCP);
> +	}
> +	return 0;
> +}
> +
> +static struct security_hook_list landlock_hooks[] __ro_after_init = {
> +	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
> +	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
> +};
> +
> +__init void landlock_add_net_hooks(void)
> +{
> +	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
> +			   &landlock_lsmid);
> +}
> -- 
> 2.34.1
> 
> 
