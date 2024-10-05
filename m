Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829A2156F54;
	Sat,  5 Oct 2024 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728150856; cv=none; b=gdQTpTzsF7Oa7RL0srP34w4iN9WjjQnSRxu+YUM5KyhCID3MOo+l+Tgi2ocCVRSS6DvJkCrjbwyCudiB2iqAiHroEZzrsOLqPiS0BYsS7cEK8g9hLT990Own2sw98zUMeNq1aQDd0Inzjqtb3DUy8oIv4FJsn+JVJElQ8nR1IpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728150856; c=relaxed/simple;
	bh=B4Ya4cScZRzBO0sIB0J5E2IbXD2MHurV5fH20It/wQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hf1uBgjTYQ3CEp3Td314rGSHm/LO7j29ujUS+lctdSqOKe0BeoMq53Iq+dP8HBeWPvbcYV9SQbCvfr2fWpi84vM/RXbnFnWZjSa6sy9rasn0bmbn8vSHkOSxc8GGtez6IO2Po1IkHeAPykXBjaPygstAh7O3V33A2deB+e82e1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XLXzK1yxNzfclq;
	Sun,  6 Oct 2024 01:51:41 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 473721402CA;
	Sun,  6 Oct 2024 01:54:03 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 6 Oct 2024 01:53:59 +0800
Message-ID: <47ff2457-59e2-b08e-0bb4-5d7c70be2ad1@huawei-partners.com>
Date: Sat, 5 Oct 2024 20:53:55 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/9] landlock: Support TCP listen access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-3-ivanov.mikhail1@huawei-partners.com>
 <20241005.bd6123d170b4@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241005.bd6123d170b4@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/5/2024 7:56 PM, Günther Noack wrote:
> Hello!
> 
> On Wed, Aug 14, 2024 at 11:01:44AM +0800, Mikhail Ivanov wrote:
>> LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
>> ports to forbid a malicious sandboxed process to impersonate a legitimate
>> server process. However, bind(2) might be used by (TCP) clients to set the
>> source port to a (legitimate) value. Controlling the ports that can be
>> used for listening would allow (TCP) clients to explicitly bind to ports
>> that are forbidden for listening.
>>
>> Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
>> access right that restricts listening on undesired ports with listen(2).
>>
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
>>
>> Changes since v1:
>> * Refactors 'struct landlock_net_port_attr' documentation.
>> * Fixes check_tcp_socket_can_listen() description.
>> * Adds lockdep_assert_held() into check_tcp_socket_can_listen().
>> * Minor fixes.
>> ---
>>   include/uapi/linux/landlock.h                | 26 ++++--
>>   security/landlock/limits.h                   |  2 +-
>>   security/landlock/net.c                      | 98 ++++++++++++++++++++
>>   security/landlock/syscalls.c                 |  2 +-
>>   tools/testing/selftests/landlock/base_test.c |  2 +-
>>   5 files changed, 119 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index 2c8dbc74b955..f7dd6949c50b 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -111,14 +111,20 @@ struct landlock_net_port_attr {
>>   	/**
>>   	 * @port: Network port in host endianness.
>>   	 *
>> -	 * It should be noted that port 0 passed to :manpage:`bind(2)` will bind
>> -	 * to an available port from the ephemeral port range.  This can be
>> -	 * configured with the ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl
>> -	 * (also used for IPv6).
>> +	 * Some socket operations will fall back to using a port from the ephemeral port
>> +	 * range, if no specific port is requested by the caller.  Among others, this
>> +	 * happens in the following cases:
>>   	 *
>> -	 * A Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP``
>> -	 * right means that requesting to bind on port 0 is allowed and it will
>> -	 * automatically translate to binding on the related port range.
>> +	 * - :manpage:`bind(2)` is invoked with a socket address that uses port 0.
>> +	 * - :manpage:`listen(2)` is invoked on a socket without previously calling
>> +	 *   :manpage:`bind(2)`.
>> +	 *
>> +	 * These two actions, which implicitly use an ephemeral port, can be allowed with
>> +	 * a Landlock rule with port 0 and the ``LANDLOCK_ACCESS_NET_BIND_TCP`` /
>> +	 * ``LANDLOCK_ACCESS_NET_LISTEN_TCP`` right.
>> +	 *
>> +	 * The ephemeral port range is configured in the
>> +	 * ``/proc/sys/net/ipv4/ip_local_port_range`` sysctl (also used for IPv6).
>>   	 */
>>   	__u64 port;
>>   };
>> @@ -259,7 +265,7 @@ struct landlock_net_port_attr {
>>    * DOC: net_access
>>    *
>>    * Network flags
>> - * ~~~~~~~~~~~~~~~~
>> + * ~~~~~~~~~~~~~
>>    *
>>    * These flags enable to restrict a sandboxed process to a set of network
>>    * actions. This is supported since the Landlock ABI version 4.
>> @@ -269,9 +275,13 @@ struct landlock_net_port_attr {
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
>> index 669ba260342f..0e494b46d086 100644
>> --- a/security/landlock/net.c
>> +++ b/security/landlock/net.c
>> @@ -6,10 +6,12 @@
>>    * Copyright © 2022-2023 Microsoft Corporation
>>    */
>>   
>> +#include <net/sock.h>
>>   #include <linux/in.h>
>>   #include <linux/net.h>
>>   #include <linux/socket.h>
>>   #include <net/ipv6.h>
>> +#include <net/tcp.h>
>>   
>>   #include "common.h"
>>   #include "cred.h"
>> @@ -194,9 +196,105 @@ static int hook_socket_connect(struct socket *const sock,
>>   					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>   }
>>   
>> +/*
>> + * Checks that socket state and attributes are correct for listen.
>> + * Returns 0 on success and -EINVAL otherwise.
>> + *
>> + * This checker requires sock->sk to be locked.
>> + */
>> +static int check_tcp_socket_can_listen(struct socket *const sock)
>> +{
>> +	struct sock *sk = sock->sk;
>> +	unsigned char cur_sk_state;
>> +	const struct tcp_ulp_ops *icsk_ulp_ops;
>> +
>> +	lockdep_assert_held(&sk->sk_lock.slock);
>> +
>> +	/* Allows only unconnected TCP socket to listen (cf. inet_listen). */
>> +	if (sock->state != SS_UNCONNECTED)
>> +		return -EINVAL;
>> +
>> +	cur_sk_state = sk->sk_state;
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
>> +	 * Sockets can listen only if ULP control hook has clone method
>> +	 * (cf. inet_csk_listen_start)
>> +	 */
>> +	if (icsk_ulp_ops && !icsk_ulp_ops->clone)
>> +		return -EINVAL;
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
> I imagine that we'll need the "protocol" comparison as well, in line
> with your fix for the bind() and connect() functionality at
> https://lore.kernel.org/all/20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com/
> ?

Yes, this check (and one above for SOCK_STREAM) should be replaced with
sk_is_tcp() [1].

[1] 
https://lore.kernel.org/all/0774e9f1-994f-1131-17f9-7dd8eb96738f@huawei-partners.com/

> 
>> +
>> +	lock_sock(sk);
> 
> The socket gets locked twice when doing listen() -- first it is locked
> by the security hook, then released again, then locked again by the
> actual listen() implementation and then released again.
> 
> What if the protected values change in between the two times when the
> lock is held?  What is the reasoning for why this is safe?  (This
> might be worth a comment in the code to explain, IMHO.)

If some of these values change, inet_listen() will simply return
the appropriate error code (consistent with these checks). Since
hook_socket_listen() does not cause any socket changes, this scenario is
equivalent to a normal listen(2) call.

I'll add an appropriate comment, thanks!

> 
>> +	/*
>> +	 * Calling listen(2) for a listening socket does nothing with its state and
>> +	 * only changes backlog value (cf. __inet_listen_sk). Checking of listen
>> +	 * access right is not required.
>> +	 */
>> +	if (sk->sk_state == TCP_LISTEN)
>> +		goto release_nocheck;
>> +
>> +	/*
>> +	 * Checks socket state to not wrongfully return -EACCES instead
>> +	 * of -EINVAL.
>> +	 */
>> +	err = check_tcp_socket_can_listen(sock);
>> +	if (unlikely(err))
>> +		goto release_nocheck;
>> +
>> +	port = htons(inet_sk(sk)->inet_num);
>> +	release_sock(sk);
>> +	return check_access_socket(dom, port, LANDLOCK_ACCESS_NET_LISTEN_TCP);
> 
> Nit: The last two lines could just be
> 
>    err = check_access_socket(...);
> 
> and then you would only need the release_sock(sk) call in one place.
> (And maybe rename the goto label accordingly.)
This split was done in order to not hold socket lock while doing some
Landlock-specific logic. It might be identical in performance to
your suggestion, but I thought that (1) security module should have as
little impact on network stack as possible and (2) it is more
clear that locking is performed only for a few socket state checks which
are not related to the access control.

I'll add this explanation with a comment if you agree that everything is
correct.

> 
>> +
>> +release_nocheck:
>> +	release_sock(sk);
>> +	return err;
>> +}
>> +
>>   static struct security_hook_list landlock_hooks[] __ro_after_init = {
>>   	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
>>   	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
>> +	LSM_HOOK_INIT(socket_listen, hook_socket_listen),
>>   };
>>   
>>   __init void landlock_add_net_hooks(void)
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index ccc8bc6c1584..328198e8a9f5 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -149,7 +149,7 @@ static const struct file_operations ruleset_fops = {
>>   	.write = fop_dummy_write,
>>   };
>>   
>> -#define LANDLOCK_ABI_VERSION 5
>> +#define LANDLOCK_ABI_VERSION 6
>>   
>>   /**
>>    * sys_landlock_create_ruleset - Create a new ruleset
>> diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
>> index 3b26bf3cf5b9..1bc16fde2e8a 100644
>> --- a/tools/testing/selftests/landlock/base_test.c
>> +++ b/tools/testing/selftests/landlock/base_test.c
>> @@ -76,7 +76,7 @@ TEST(abi_version)
>>   	const struct landlock_ruleset_attr ruleset_attr = {
>>   		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
>>   	};
>> -	ASSERT_EQ(5, landlock_create_ruleset(NULL, 0,
>> +	ASSERT_EQ(6, landlock_create_ruleset(NULL, 0,
>>   					     LANDLOCK_CREATE_RULESET_VERSION));
>>   
>>   	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
>> -- 
>> 2.34.1
>>
