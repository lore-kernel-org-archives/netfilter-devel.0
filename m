Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F24F12EBDB;
	Thu,  3 Oct 2024 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727991016; cv=none; b=IEHXFG2DJMjIe7oa55lejvyv6hLZJ/AdL1kB3hHvixeYd0Ap7lUI6MKEA12h8bZQC08g7BnrInzHFrqnRGQYsdg23VFFHnLr3fyaot/ojv2V5KPQneEZh0UjvU/VCDYzrnlOGk5os8jdiocLKDHiy1lGGYFav80FqMDsW+PC0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727991016; c=relaxed/simple;
	bh=oCxUZ57wnVraO3zmW4BR6HiP4N+sk6KMjuzqh6uY5Kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZBHtf966xq1YL0njbXim9+aj0P3EpBqzny+jyT+LUYj2ytjjXoL00TN9QVKGumtOBcrqeVwpfJGRQCw1uPMCTzkFxTwBvO/XRhra0wcMDrrznSED3jZPkMC5bhvh75b3JBVWgddnNqdN15j8SycIr5p2SZ12fZtVMn3ccCQ4FpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XKPvm23Jpz20pqL;
	Fri,  4 Oct 2024 05:29:40 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id C36B9140109;
	Fri,  4 Oct 2024 05:30:10 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 4 Oct 2024 05:30:06 +0800
Message-ID: <8f023c51-bac1-251e-0f40-24dbe2bba729@huawei-partners.com>
Date: Fri, 4 Oct 2024 00:30:02 +0300
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
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241003.wie1aiphaeCh@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/3/2024 8:45 PM, Mickaël Salaün wrote:
> Please also add Matthieu in Cc for the network patch series.
> 
> On Thu, Oct 03, 2024 at 10:39:31PM +0800, Mikhail Ivanov wrote:
>> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
>> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
>> should not restrict bind(2) and connect(2) for non-TCP protocols
>> (SCTP, MPTCP, SMC).
>>
>> Closes: https://github.com/landlock-lsm/linux/issues/40
>> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   security/landlock/net.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> index bc3d943a7118..6f59dd98bb13 100644
>> --- a/security/landlock/net.c
>> +++ b/security/landlock/net.c
>> @@ -68,7 +68,7 @@ static int current_check_access_socket(struct socket *const sock,
>>   		return -EACCES;
>>   
>>   	/* Checks if it's a (potential) TCP socket. */
> 
> We can extend this comment to explain that we don't use sk_is_tcp()
> because we need to handle the AF_UNSPEC case.

Indeed, I'll do this.

> 
>> -	if (sock->type != SOCK_STREAM)
>> +	if (sock->type != SOCK_STREAM || sock->sk->sk_protocol != IPPROTO_TCP)
> 
> I think we should check sock->sk->sk_type instead of sock->type (even if
> it should be the same).  To make it simpler, we should only use sk in
> current_check_access_socket():
> struct sock *sk = sock->sk;

Agreed.

> 
> Could you please also do s/__sk_common\.skc_/sk_/g ?

Ofc

Btw, there is probably incorrect read of skc_family in this function
[1]. I'll add READ_ONCE for sk->sk_family.

[1] https://lore.kernel.org/all/20240202095404.183274-1-edumazet@google.com/

> 
>>   		return 0;
>>   
>>   	/* Checks for minimal header length to safely read sa_family. */
>> -- 
>> 2.34.1
>>
>>
