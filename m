Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208FF1396;
	Wed, 31 Jul 2024 17:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722446457; cv=none; b=tB1MyrPX+ErPSc2RXY8CMIFbfR3C+Jckjr0fnUc4SOJ1VokOtoYrIV/f9EpHJx87+hJgU2yd6efzqqUYIRsh7Bu9iXi8aVfKaCFdRSoClqwHU+FhEShv5GVMejR0Vu6yK9CbvphotKCBTm22S+I0BH2gz+ZUndq3cvlbCBRcjP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722446457; c=relaxed/simple;
	bh=/OUjgcQxbVb4DKsUujnjXtANlpLT2j0hUSkBEfzHeXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lTJT8Go9/altCJEOuBiqh0rfv6GJzFja24TPv8+00cnLPKM5hm8+VsIlAhLa/llofnx2mZ9VF/ztLiG2arD67ktXuDPRSYvo42PZCp/im4nlJCLFRLbptKNke2RdCe1AjZRHfUmY6d1cRL7LpyrKfLPZ/lAlY8sagiMNqx55hqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WYzN35cPxzfZ4Y;
	Thu,  1 Aug 2024 01:18:59 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 6AECB180105;
	Thu,  1 Aug 2024 01:20:50 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 1 Aug 2024 01:20:46 +0800
Message-ID: <0a3b8596-f3f3-f617-c40d-de54e8ff05f0@huawei-partners.com>
Date: Wed, 31 Jul 2024 20:20:41 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>, <alx@kernel.org>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
 <ZqijJPrnCnGnVGkq@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZqijJPrnCnGnVGkq@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 dggpemm500020.china.huawei.com (7.185.36.49)

7/30/2024 11:24 AM, Günther Noack wrote:
> Hello!
> 
> Thanks for sending these patches!
> 
> Most comments are about documentation so far.
> 
> In the implementation, I'm mostly unclear about the interaction with the
> uncommon Upper Layer Protocols.  I'm also not very familiar with the socket
> state machines, maybe someone from the netdev list would have time to double
> check that aspect?
> 
> 
> On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
>> LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
>> ports to forbid a malicious sandboxed process to impersonate a legitimate
>> server process. However, bind(2) might be used by (TCP) clients to set the
>> source port to a (legitimate) value. Controlling the ports that can be
>> used for listening would allow (TCP) clients to explicitly bind to ports
>> that are forbidden for listening.
>>
>> Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
>> access right that restricts listening on undesired ports with listen(2).
> 
> Nit: I would turn around the first two commit message paragraphs and describe
> your changes first, before explaining the problems in the bind(2) support.  I
> was initially a bit confused that the description started talking about
> LANDLOCK_ACCESS_NET_BIND_TCP.
> 
> General recommendations at:
> https://www.kernel.org/doc/html/v6.10/process/submitting-patches.html#describe-your-changes

I consider the first paragraph as a problem statement for this patch.
According to linux recommendations problem should be established before
the description of changes. Do you think that the changes part should
stand before the problem anyway?

> 
> 
>> It's worth noticing that this access right doesn't affect changing
>> backlog value using listen(2) on already listening socket.
>>
>> * Create new LANDLOCK_ACCESS_NET_LISTEN_TCP flag.
>> * Add hook to socket_listen(), which checks whether the socket is allowed
>>    to listen on a binded local port.
>> * Add check_tcp_socket_can_listen() helper, which validates socket
>>    attributes before the actual access right check.
>> * Update `struct landlock_net_port_attr` documentation with control of
>>    binding to ephemeral port with listen(2) description.
>> * Change ABI version to 6.
>>
>> Closes: https://github.com/landlock-lsm/linux/issues/15
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   include/uapi/linux/landlock.h                | 23 +++--
>>   security/landlock/limits.h                   |  2 +-
>>   security/landlock/net.c                      | 90 ++++++++++++++++++++
>>   security/landlock/syscalls.c                 |  2 +-
>>   tools/testing/selftests/landlock/base_test.c |  2 +-
>>   5 files changed, 108 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index 68625e728f43..6b8df3293eee 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -104,13 +104,16 @@ struct landlock_net_port_attr {
>>   	/**
>>   	 * @port: Network port in host endianness.
>>   	 *
>> -	 * It should be noted that port 0 passed to :manpage:`bind(2)` will
>> -	 * bind to an available port from a specific port range. This can be
>> -	 * configured thanks to the ``/proc/sys/net/ipv4/ip_local_port_range``
>> -	 * sysctl (also used for IPv6). A Landlock rule with port 0 and the
>> -	 * ``LANDLOCK_ACCESS_NET_BIND_TCP`` right means that requesting to bind
>> -	 * on port 0 is allowed and it will automatically translate to binding
>> -	 * on the related port range.
> 
> Please rebase on a more recent revision, we have changed this phrasing in the meantime:
> 
>   - s/a specific port range/the ephemeral port range/
>   - The paragraph was split in two.

ok

> 
>> +	 * It should be noted that some operations cause binding socket to a random
>> +	 * available port from a specific port range. This can be configured thanks
>> +	 * to the ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl (also used for
>> +	 * IPv6). Following operation requests are automatically translate to
>> +	 * binding on the related port range:
>> +	 *
>> +	 * - A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP``
>> +	 *   right means that binding on port 0 is allowed.
>> +	 * - A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_LISTEN_TCP``
>> +	 *   right means listening without an explicit binding is allowed.
> 
> There are some grammatical problems in this documentation section.
> 
> Can I suggest an alternative?
> 
>    Some socket operations will fall back to using a port from the ephemeral port
>    range, if no specific port is requested by the caller.  Among others, this
>    happens in the following cases:
> 
>    - :manpage:`bind(2)` is invoked with a socket address that uses port 0.
>    - :manpage:`listen(2)` is invoked on a socket without previously calling
>      :manpage:`bind(2)`.
> 
>    These two actions, which implicitly use an ephemeral port, can be allowed with
>    a Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP`` /
>    ``LANDLOCK_ACCESS_NET_LISTEN_TCP`` right.
> 
>    The ephemeral port range is configured in the
>    ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl (also used for IPv6).

Thanks, lets take this one.

> 
> When we have the documentation wording finalized,
> please send an update to the man pages as well,
> for this and other documentation updates.

Should I send it after this patchset would be accepted?

> 
> Small remarks on what I've done here:
> 
> * I am avoiding the word "binding" when referring to the automatic assignment to
>    an ephemeral port - IMHO, this is potentially confusing, since bind(2) is not
>    explicitly called.
> * I am also dropping the "It should be noted" / "Note that" phrase, which is
>    frowned upon in man pages.

Didn't know that, thanks

> 
>>   	 */
>>   	__u64 port;
>>   };
>> @@ -251,7 +254,7 @@ struct landlock_net_port_attr {
>>    * DOC: net_access
>>    *
>>    * Network flags
>> - * ~~~~~~~~~~~~~~~~
>> + * ~~~~~~~~~~~~~
>>    *
>>    * These flags enable to restrict a sandboxed process to a set of network
>>    * actions. This is supported since the Landlock ABI version 4.
>> @@ -261,9 +264,13 @@ struct landlock_net_port_attr {
>>    * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
>>    * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>>    *   a remote port.
>> + * - %LANDLOCK_ACCESS_NET_LISTEN_TCP: Listen for TCP socket connections on
>> + *   a local port. This access right is available since the sixth version
>> + *   of the Landlock ABI.
>>    */
>>   /* clang-format off */
>>   #define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>>   #define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>> +#define LANDLOCK_ACCESS_NET_LISTEN_TCP			(1ULL << 2)
>>   /* clang-format on */
>>   #endif /* _UAPI_LINUX_LANDLOCK_H */
>> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
>> index 4eb643077a2a..2ef147389474 100644
>> --- a/security/landlock/limits.h
>> +++ b/security/landlock/limits.h
>> @@ -22,7 +22,7 @@
>>   #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
>>   #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>>   
>> -#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
>> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_LISTEN_TCP
>>   #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>>   #define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
>>   
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> index 669ba260342f..a29cb27c3f14 100644
>> --- a/security/landlock/net.c
>> +++ b/security/landlock/net.c
>> @@ -6,10 +6,12 @@
>>    * Copyright © 2022-2023 Microsoft Corporation
>>    */
>>   
>> +#include "net/sock.h"
>>   #include <linux/in.h>
>>   #include <linux/net.h>
>>   #include <linux/socket.h>
>>   #include <net/ipv6.h>
>> +#include <net/tcp.h>
>>   
>>   #include "common.h"
>>   #include "cred.h"
>> @@ -194,9 +196,97 @@ static int hook_socket_connect(struct socket *const sock,
>>   					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>   }
>>   
>> +/*
>> + * Checks that socket state and attributes are correct for listen.
>> + * It is required to not wrongfully return -EACCES instead of -EINVAL.
>        ^^^^^^^^^^^^^^
> 
> Doc nit: I would just document that this function returns -EINVAL on failure?
> In this place, I would expect that the function interface is documented for
> callers.  (From that perspective, this is not a requirement, but a guarantee
> that the function gives.)

Agreed, thanks

> 
>> + *
>> + * This checker requires sock->sk to be locked.
>> + */
>> +static int check_tcp_socket_can_listen(struct socket *const sock)
>> +{
>> +	struct sock *sk = sock->sk;
>> +	unsigned char cur_sk_state = sk->sk_state;
>> +	const struct tcp_ulp_ops *icsk_ulp_ops;
>> +
>> +	/* Allows only unconnected TCP socket to listen (cf. inet_listen). */
>> +	if (sock->state != SS_UNCONNECTED)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Checks sock state. This is needed to ensure consistency with inet stack
>> +	 * error handling (cf. __inet_listen_sk).
>> +	 */
>> +	if (WARN_ON_ONCE(!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN))))
>> +		return -EINVAL;
>> +
>> +	icsk_ulp_ops = inet_csk(sk)->icsk_ulp_ops;
>> +
>> +	/*
>> +	 * ULP (Upper Layer Protocol) stands for protocols which are higher than
>> +	 * transport protocol in OSI model. Linux has an infrastructure that
>> +	 * allows TCP sockets to support logic of some ULP (e.g. TLS ULP).
>> +	 *
>> +	 * Sockets can listen only if ULP control hook has clone method.
>> +	 */
>> +	if (icsk_ulp_ops && !icsk_ulp_ops->clone)
>> +		return -EINVAL;
> 
> This seems like an implementation detail in the networking subsystem?

Yeap. There is probably a missing reference to the corresponding network
stack code (inet_csk_listen_start()). I'll add it.

> 
> If I understand correctly, these are cases where we use TCP on top of protocols
> that are not IP (or have an additional layer in the middle, like TLS?).  This
> can not be recognized through the socket family or type?

ULP can be used in the context of TCP protocols as an additional layer
(currently supported only by IP and MPTCP), so it cannot be recognized
with family or type. You can check this test [1] in which TCP IP socket
is created with ULP control hook.

[1] 
https://lore.kernel.org/all/20240728002602.3198398-8-ivanov.mikhail1@huawei-partners.com/

> 
> Do we have cases where we can run TCP on top of something else than plain IPv4
> or IPv6, where the clone method exists?

Yeah, MPTCP protocol for example (see net/mptcp/subflow.c). ULP control
hook is supported only by IP and MPTCP, and in both cases
clone method is checked during listen(2) execution.

> 
>> +	return 0;
>> +}
>> +
>> +static int hook_socket_listen(struct socket *const sock, const int backlog)
>> +{
>> +	int err = 0;
>> +	int family;
>> +	__be16 port;
>> +	struct sock *sk;
>> +	const struct landlock_ruleset *const dom = get_current_net_domain();
>> +
>> +	if (!dom)
>> +		return 0;
>> +	if (WARN_ON_ONCE(dom->num_layers < 1))
>> +		return -EACCES;
>> +
>> +	/* Checks if it's a (potential) TCP socket. */
>> +	if (sock->type != SOCK_STREAM)
>> +		return 0;
>> +
>> +	sk = sock->sk;
>> +	family = sk->__sk_common.skc_family;
>> +	/*
>> +	 * Socket cannot be assigned AF_UNSPEC because this type is used only
>> +	 * in the context of addresses.
>> +	 *
>> +	 * Doesn't restrict listening for non-TCP sockets.
>> +	 */
>> +	if (family != AF_INET && family != AF_INET6)
>> +		return 0;
> 
> Aren't the socket type and family checks duplicated with existing logic that we
> have for the connect(2) and bind(2) support?  Should it be deduplicated, or is
> that too messy?

bind(2) and connect(2) hooks also support AF_UNSPEC family, so I think
such helper is gonna complicate code a little bit. Also it can
complicate switch in current_check_access_socket().

> 
>> +
>> +	lock_sock(sk);
>> +	/*
>> +	 * Calling listen(2) for a listening socket does nothing with its state and
>> +	 * only changes backlog value (cf. __inet_listen_sk). Checking of listen
>> +	 * access right is not required.
>> +	 */
>> +	if (sk->sk_state == TCP_LISTEN)
>> +		goto release_nocheck;
>> +
>> +	err = check_tcp_socket_can_listen(sock);
>> +	if (unlikely(err))
>> +		goto release_nocheck;
>> +
>> +	port = htons(inet_sk(sk)->inet_num);
>> +	release_sock(sk);
>> +	return check_access_socket(dom, port, LANDLOCK_ACCESS_NET_LISTEN_TCP);
>> +
>> +release_nocheck:
>> +	release_sock(sk);
>> +	return err;
>> +}
> 
> Thanks for sending these patches!
> 
> —Günther
