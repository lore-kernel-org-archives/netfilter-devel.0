Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8836B1E377A;
	Fri,  4 Oct 2024 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728065836; cv=none; b=W+joByGUxkLmnvPROyBP8+sSjfIZ9Puw9zZlKPLQSp8S6NLCnrFvLQIPRsomOW+gzBm9Zd9YaTUMb4ABx6VO5OwJhJi7EoxFJM3S02+43dS2VR7e6r5PKCvzVGlEjHaE8254DUN9gBmS41drn8XBiGJGGzf/XhceT9IZXEWjvRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728065836; c=relaxed/simple;
	bh=+0QIs1lN858F6dyCNvNENg78JbK9LWa9tkRBTY11Skw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=R1uyiv/qyQvb9VQD//UeVNMVc5S+xVtyTzTAQVC0gnnfZTB6A+cPj1RJaPraLT0otvtJ+re68WqeeeHMqd3ZOqDkDhABh48l0krlIVjZwn4tfcYA9BoIOjDWfbFbWSw54GDQeDCcShKric0zAZJBLUwi2CWyazwVRFuWRm+puQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XKxYj5Gv2zySgr;
	Sat,  5 Oct 2024 02:15:53 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id E8A4618007C;
	Sat,  5 Oct 2024 02:17:04 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 5 Oct 2024 02:17:01 +0800
Message-ID: <0774e9f1-994f-1131-17f9-7dd8eb96738f@huawei-partners.com>
Date: Fri, 4 Oct 2024 21:16:56 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/2] landlock: Fix non-TCP sockets restriction
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>, Matthieu Buffet
	<matthieu@buffet.re>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
 <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
 <20241003.wie1aiphaeCh@digikod.net>
 <8f023c51-bac1-251e-0f40-24dbe2bba729@huawei-partners.com>
 <20241004.rel9ja7IeDo4@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241004.rel9ja7IeDo4@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/4/2024 1:13 PM, Mickaël Salaün wrote:
> On Fri, Oct 04, 2024 at 12:30:02AM +0300, Mikhail Ivanov wrote:
>> On 10/3/2024 8:45 PM, Mickaël Salaün wrote:
>>> Please also add Matthieu in Cc for the network patch series.
>>>
>>> On Thu, Oct 03, 2024 at 10:39:31PM +0800, Mikhail Ivanov wrote:
>>>> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
>>>> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
>>>> should not restrict bind(2) and connect(2) for non-TCP protocols
>>>> (SCTP, MPTCP, SMC).
>>>>
>>>> Closes: https://github.com/landlock-lsm/linux/issues/40
>>>> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
>>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>>> ---
>>>>    security/landlock/net.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>>>> index bc3d943a7118..6f59dd98bb13 100644
>>>> --- a/security/landlock/net.c
>>>> +++ b/security/landlock/net.c
>>>> @@ -68,7 +68,7 @@ static int current_check_access_socket(struct socket *const sock,
>>>>    		return -EACCES;
>>>>    	/* Checks if it's a (potential) TCP socket. */
>>>
>>> We can extend this comment to explain that we don't use sk_is_tcp()
>>> because we need to handle the AF_UNSPEC case.
>>
>> Indeed, I'll do this.

I've noticed that we still should check sk->sk_family = AF_INET{,6}
here (so sk_is_tcp() is suitable). AF_UNSPEC can be only related to
addresses and we should not provide any checks (for address) if socket
is unrestrictable (i.e. it's not TCP). It's not useful and might lead to
error incosistency for non-TCP sockets.

Btw, I suppose we can improve error consistency by bringing more checks
from INET/TCP stack. For example it may be useful to return EISCONN
instead of EACCES while connect(2) is called on a connected socket.

This should be done really carefully and only for some useful cases.
Anyway it's not related to the current patch (since it's not a bug).

>>
>>>
>>>> -	if (sock->type != SOCK_STREAM)
>>>> +	if (sock->type != SOCK_STREAM || sock->sk->sk_protocol != IPPROTO_TCP)
>>>
>>> I think we should check sock->sk->sk_type instead of sock->type (even if
>>> it should be the same).  To make it simpler, we should only use sk in
>>> current_check_access_socket():
>>> struct sock *sk = sock->sk;
>>
>> Agreed.
>>
>>>
>>> Could you please also do s/__sk_common\.skc_/sk_/g ?
>>
>> Ofc
>>
>> Btw, there is probably incorrect read of skc_family in this function
>> [1]. I'll add READ_ONCE for sk->sk_family.
>>
>> [1] https://lore.kernel.org/all/20240202095404.183274-1-edumazet@google.com/
> 
> I think it should not be a bug with the current code (IPv6 -> IPV4, and
> socket vs. sock) but we should indeed use READ_ONCE() (and add this link
> to the commit message).

ok

> 
>>
>>>
>>>>    		return 0;
>>>>    	/* Checks for minimal header length to safely read sa_family. */
>>>> -- 
>>>> 2.34.1
>>>>
>>>>
>>
