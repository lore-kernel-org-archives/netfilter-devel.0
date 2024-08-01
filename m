Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA8C1B3F26;
	Thu,  1 Aug 2024 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722528342; cv=none; b=KHSvVi/fJ8JnDzTQzrnDUP8RJLtZV31MzVqTjcHOzeJ811a1Bl89NjLAZq+ipRH1H0rf4PTQZaq/G/Ii53sVq0z9pTbA6ugz3TeuQ8PxAjujrqMXEUdq0Anx2mY9lEAFDzqkqotu0cWQ+mJs94cw3duZ0R1Kh7uIZ1K03usKFSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722528342; c=relaxed/simple;
	bh=pSHG9lsWqj8+0KA9KuNPYXaQrCHLdJR48JyOFONYADQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HVKFMk7Vcl59FB8Y/O20stqr1Zj0pot792iVUQAOZWwWVgcn7flYIVKdwBA1cr1xLGI/9E0Q62E7o2Hw218GsrQTXQ9PRo2N7WcMOyqenWuJaJ84zfrIyGxC29hU2v9pP1mY1+ga9iS+iKagC9vJzejndM2MxVoFjGOnthyb95Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WZYZb4GdJzyPVB;
	Fri,  2 Aug 2024 00:00:07 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 4952318005F;
	Fri,  2 Aug 2024 00:05:07 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 2 Aug 2024 00:05:03 +0800
Message-ID: <2030c426-f351-480c-7bf5-a44ed0344495@huawei-partners.com>
Date: Thu, 1 Aug 2024 19:04:59 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
 <20240801.Euhith6ukah2@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240801.Euhith6ukah2@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/1/2024 5:45 PM, Mickaël Salaün wrote:
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
>>   include/uapi/linux/landlock.h                | 23 +++--
>>   security/landlock/limits.h                   |  2 +-
>>   security/landlock/net.c                      | 90 ++++++++++++++++++++
>>   security/landlock/syscalls.c                 |  2 +-
>>   tools/testing/selftests/landlock/base_test.c |  2 +-
>>   5 files changed, 108 insertions(+), 11 deletions(-)
> 
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
>> + *
>> + * This checker requires sock->sk to be locked.
>> + */
>> +static int check_tcp_socket_can_listen(struct socket *const sock)
>> +{
>> +	struct sock *sk = sock->sk;
>> +	unsigned char cur_sk_state = sk->sk_state;
>> +	const struct tcp_ulp_ops *icsk_ulp_ops;
>> +
> 
> I think we can add this assert:
> lockdep_assert_held(&sk->sk_lock.slock);

Ok, let's add it. I just haven't seen this being a common practice in
the network stack.

> 
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
>> +	return 0;
>> +}
