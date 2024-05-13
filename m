Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C39114AD02;
	Mon, 13 May 2024 12:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715602567; cv=none; b=NRxGw52lp9rCzywPau9gBrz7Z8hBvGl9ROyfuhFcI9/kArtMi/bjBqiG5kpYW9nEtD+TpQ7V/W87YJOQo1ZZy/lK1l0tC6Zsw7FO/JFyYvPL6KodEztFxvVjC7Nmf/6y6ERYANAEEfHmO5OpZy8ewpCDCGXrQd7IKanyJiBGOws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715602567; c=relaxed/simple;
	bh=xW5coIiXGPPePDo5ep+BcM9TB0/lvgCp/Nb01yqgel8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=K5lb/0vXh7zjc2aBc4VMNzbsuTNI+lF5G2Z7tc4K6ws9WPXo+lSnDmqNDsUragQqP8ekn6zqlN3+PaDSXUkUIezPOMMN5akJBQoUtDCzTbDeuNO1s1Qt6f6eNiZNHchN9WFRR3W0LZy2M8bOuKCmFX7EmBxWZhHXetqFy4en+84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VdJJx5P1Fz1S5Kv;
	Mon, 13 May 2024 20:12:33 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 275781800B6;
	Mon, 13 May 2024 20:16:00 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 20:15:55 +0800
Message-ID: <a18333c0-4efc-dcf4-a219-ec46480352b1@huawei-partners.com>
Date: Mon, 13 May 2024 15:15:50 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] landlock: Add hook on socket_listen()
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>,
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-2-ivanov.mikhail1@huawei-partners.com>
 <20240425.Soot5eNeexol@digikod.net>
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240425.Soot5eNeexol@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 dggpemm500020.china.huawei.com (7.185.36.49)



4/30/2024 4:36 PM, Mickaël Salaün wrote:
> On Mon, Apr 08, 2024 at 05:47:46PM +0800, Ivanov Mikhail wrote:
>> Make hook for socket_listen(). It will check that the socket protocol is
>> TCP, and if the socket's local port number is 0 (which means,
>> that listen(2) was called without any previous bind(2) call),
>> then listen(2) call will be legitimate only if there is a rule for bind(2)
>> allowing binding to port 0 (or if LANDLOCK_ACCESS_NET_BIND_TCP is not
>> supported by the sandbox).
> 
> Thanks for this patch and sorry for the late full review.  The code is
> good overall.
> 
> We should either consider this patch as a fix or add a new flag/access
> right to Landlock syscalls for compatibility reason.  I think this
> should be a fix.  Calling listen(2) without a previous call to bind(2)
> is a corner case that we should properly handle.  The commit message
> should make that explicit and highlight the goal of the patch: first
> explain why, and then how.

Yeap, this is fix-patch. I have covered motivation and proposed solution
in cover letter. Do you have any suggestions on how i can improve this?

> 
> We also need to update the user documentation to explain that
> LANDLOCK_ACCESS_NET_BIND_TCP also handles this case.

ok, i'll update it.

> 
>>
>> Create a new check_access_socket() function to prevent useless copy paste.
>> It should be called by hook handlers after they perform special checks and
>> calculate socket port value.
> 
> You can add this tag:
> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")

Yeah, thanks!

> 
>>
>> Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
>> Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>   security/landlock/net.c | 104 +++++++++++++++++++++++++++++++++-------
>>   1 file changed, 88 insertions(+), 16 deletions(-)
>>
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> index c8bcd29bde09..c6ae4092cfd6 100644
>> --- a/security/landlock/net.c
>> +++ b/security/landlock/net.c
>> @@ -10,6 +10,7 @@
>>   #include <linux/net.h>
>>   #include <linux/socket.h>
>>   #include <net/ipv6.h>
>> +#include <net/tcp.h>
>>   
>>   #include "common.h"
>>   #include "cred.h"
>> @@ -61,17 +62,36 @@ static const struct landlock_ruleset *get_current_net_domain(void)
>>   	return dom;
>>   }
>>   
>> -static int current_check_access_socket(struct socket *const sock,
>> -				       struct sockaddr *const address,
>> -				       const int addrlen,
>> -				       access_mask_t access_request)
>> +static int check_access_socket(const struct landlock_ruleset *const dom,
>> +			  __be16 port,
>> +			  access_mask_t access_request)
> 
> Please format all patches with clang-format.

will be fixed

> 
>>   {
>> -	__be16 port;
>>   	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>>   	const struct landlock_rule *rule;
>>   	struct landlock_id id = {
>>   		.type = LANDLOCK_KEY_NET_PORT,
>>   	};
>> +
>> +	id.key.data = (__force uintptr_t)port;
>> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
>> +
>> +	rule = landlock_find_rule(dom, id);
>> +	access_request = landlock_init_layer_masks(
>> +		dom, access_request, &layer_masks, LANDLOCK_KEY_NET_PORT);
>> +
>> +	if (landlock_unmask_layers(rule, access_request, &layer_masks,
>> +				   ARRAY_SIZE(layer_masks)))
>> +		return 0;
>> +
>> +	return -EACCES;
>> +}
> 
> This check_access_socket() refactoring should be in a dedicated patch.

ok, i'll move it.

> 
>> +
>> +static int current_check_access_socket(struct socket *const sock,
>> +				       struct sockaddr *const address,
>> +				       const int addrlen,
>> +				       access_mask_t access_request)
>> +{
>> +	__be16 port;
>>   	const struct landlock_ruleset *const dom = get_current_net_domain();
>>   
>>   	if (!dom)
>> @@ -159,17 +179,7 @@ static int current_check_access_socket(struct socket *const sock,
>>   			return -EINVAL;
>>   	}
>>   
>> -	id.key.data = (__force uintptr_t)port;
>> -	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
>> -
>> -	rule = landlock_find_rule(dom, id);
>> -	access_request = landlock_init_layer_masks(
>> -		dom, access_request, &layer_masks, LANDLOCK_KEY_NET_PORT);
>> -	if (landlock_unmask_layers(rule, access_request, &layer_masks,
>> -				   ARRAY_SIZE(layer_masks)))
>> -		return 0;
>> -
>> -	return -EACCES;
>> +	return check_access_socket(dom, port, access_request);
>>   }
>>   
>>   static int hook_socket_bind(struct socket *const sock,
>> @@ -187,9 +197,71 @@ static int hook_socket_connect(struct socket *const sock,
>>   					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>   }
>>   
>> +/*
>> + * Check that socket state and attributes are correct for listen.
>> + * It is required to not wrongfully return -EACCES instead of -EINVAL.
>> + */
>> +static int check_tcp_socket_can_listen(struct socket *const sock)
>> +{
>> +	struct sock *sk = sock->sk;
>> +	unsigned char cur_sk_state = sk->sk_state;
>> +	const struct inet_connection_sock *icsk;
>> +
>> +	/* Allow only unconnected TCP socket to listen(cf. inet_listen). */
> 
> nit: Missing space.

will be fixed

> 
> The other comments in Landlock are written with the third person
> (in theory everywhere): "Allows..."

Indeed, i'll fix comments. Thanks!

> 
>> +	if (sock->state != SS_UNCONNECTED)
>> +		return -EINVAL;
>> +
>> +	/* Check sock state consistency. */
> 
> Can you explain exactly what is going on here (in the comment)? Linking
> to a kernel function would help.

Yeap, i'll fix comment.

> 
>> +	if (!((1 << cur_sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
>> +		return -EINVAL;
>> +
>> +	/* Sockets can listen only if ULP control hook has clone method. */
> 
> What is ULP?

ULP (Upper Layer Protocol) stands for protocols which are higher than
transport protocol in OSI model. Linux has an infrastructure that
allows TCP sockets to support logic of some ULP (e.g. TLS ULP). [1]

There is a patch that prevents ULP sockets from listening
if corresponding ULP implementation in linux doesn't have a clone
method. [2]

Landlock shouldn't return EACCES for ULP sockets that cannot listen
due to some ULP restrictions.

[1] 
https://lore.kernel.org/all/20170524162646.GA24128@davejwatson-mba.local/
[2] 
https://lore.kernel.org/all/4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com/

> 
>> +	icsk = inet_csk(sk);
>> +	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
>> +		return -EINVAL;
> 
> Can you please add tests covering all these error cases?

Yeap, i'll add a test for first check.

I have not found a way to trigger the second check from userspace.
Since socket wasn't binded to any port, this means that it cannot
be part of a TCP connection in any state, so it has to be in TCPF_CLOSE
state. Nevertheless i think that this check is required:

* for consistency with inet stack (see __inet_listen_sk())

* i have not found any restrictions connected with sock locking
   for TCP-like protocols, so listen(2) can be called after
   sk->sk_prot->connect() method will change sock state in
   __inet_stream_connect() (e.g. to TCP_SYN_SENT). In that case this
   check may be required.

What do you think?
Btw this hook on socket_listen() should be fixed in
order to not check socket that is already in TCP_LISTEN state. Calling
listen(2) only changes backlog value, so landlock shouldn't do anything
in this case.

I'm not sure about ULP checking. I thought of adding test that creates
espintcp ULP (net/xfrm/expintcp.c) socket and tries to listen on it.
Since espintcp doesn't have clone method ULP check will be triggered.
Problem is that kernel doesnt support this ULP module by default and it
should be configured with CONFIG_XFRM_ESPINTCP option enabled. I think
that selftests shouldn't depend on specific kernel configuration to be
fully executed, so probably we should just skip this. What do you think?

> 
>> +	return 0;
>> +}
>> +
>> +static int hook_socket_listen(struct socket *const sock,
>> +			  const int backlog)
>> +{
>> +	int err;
>> +	int family;
>> +	const struct landlock_ruleset *const dom = get_current_net_domain();
>> +
>> +	if (!dom)
>> +		return 0;
>> +	if (WARN_ON_ONCE(dom->num_layers < 1))
>> +		return -EACCES;
>> +
>> +	/*
>> +	 * listen() on a TCP socket without pre-binding is allowed only
>> +	 * if binding to port 0 is allowed.
>> +	 */
> 
> This comment should be just before the inet_sk(sock->sk)->inet_num
> check.

will be fixed

> 
>> +	family = sock->sk->__sk_common.skc_family;
>> +
>> +	if (family == AF_INET || family == AF_INET6) {
> 
> This would make the code simpler:
> 
> if (family != AF_INET && family != AF_INET6)
> 	return 0;

indeed, will be fixed.

> 
> 
> What would be the effect of listen() on an AF_UNSPEC socket?

AF_UNSPEC is a family type that only addresses can use.
Socket itself can only be AF_INET or AF_INET6 in TCP.

> 
>> +		/* Checks if it's a (potential) TCP socket. */
>> +		if (sock->type != SOCK_STREAM)
>> +			return 0;
> 
> As for current_check_access_socket() this kind of check should be at the
> beginning of the function (before the family check) to exit early and
> simplify code.

will be fixed

> 
>> +
>> +		/* Socket is alredy binded to some port. */
> 
> This kind of spelling issue can be found by scripts/checkpatch.pl

will be fixed

> 
>> +		if (inet_sk(sock->sk)->inet_num != 0)
> 
> Why do we want to allow listen() on any socket that is binded?
> 
>> +			return 0;
>> +
>> +		err = check_tcp_socket_can_listen(sock);
>> +		if (unlikely(err))
>> +			return err;
>> +
>> +		return check_access_socket(dom, 0, LANDLOCK_ACCESS_NET_BIND_TCP);
>> +	}
>> +	return 0;
>> +}
>> +
>>   static struct security_hook_list landlock_hooks[] __ro_after_init = {
>>   	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
>>   	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
>> +	LSM_HOOK_INIT(socket_listen, hook_socket_listen),
>>   };
>>   
>>   __init void landlock_add_net_hooks(void)
>> -- 
>> 2.34.1
>>
>>
