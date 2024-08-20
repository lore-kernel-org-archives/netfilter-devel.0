Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8894FEEA5;
	Tue, 20 Aug 2024 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724152871; cv=none; b=rxAjHLQqnOZE/V2WHByqP/Njvdf2zm+/1LMYRsqZjJT+ix3In0EqWpoCwrEG+hhJ+wgWWuk4pi316xHcTj1kXR5TYik414jOSnujRaHZdPppMCcN6FD60fKQxoQZXOaOuk2Q3w0RxsxQAnqzxBKu/MpK3Z3Httbudl7eLbZ7Wxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724152871; c=relaxed/simple;
	bh=kW9hAKYO/zc9u3MdD6wMUHHAtECrOqBOQ86pSxZcNhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SDRN7g5G6DdKa91JyZdXeKLydmtHpLbDaIWfO2tmJ7Tp/D2SLzKkyxxeeYV5Blh8tjMYWFPGA8B1OMLkhxEI9zAPFULGaBoB9gHxSFCt4/eX/ynWWVPzzz+AXVCkM76UGvgx5c1AuU7EKDATjXyE9DSPGlmJ0DAOSeCw3ljgVvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wp6N36cgZz2Cmq9;
	Tue, 20 Aug 2024 19:16:03 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A9E3D1401F2;
	Tue, 20 Aug 2024 19:21:03 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 19:20:59 +0800
Message-ID: <c7983120-813d-5a26-2cf4-e2965c0f374c@huawei-partners.com>
Date: Tue, 20 Aug 2024 14:20:55 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/9] landlock: Refactor
 current_check_access_socket() access right check
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-2-ivanov.mikhail1@huawei-partners.com>
 <ZsO6_14c14BAn-kI@google.com>
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZsO6_14c14BAn-kI@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/20/2024 12:37 AM, Günther Noack wrote:
> Hello!
> 
> Thanks for sending round 2 of this patch set!
> 
> On Wed, Aug 14, 2024 at 11:01:43AM +0800, Mikhail Ivanov wrote:
>> The current_check_access_socket() function contains a set of address
>> validation checks for bind(2) and connect(2) hooks. Separate them from
>> an actual port access right checking. It is required for the (future)
>> hooks that do not perform address validation.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   security/landlock/net.c | 41 ++++++++++++++++++++++++-----------------
>>   1 file changed, 24 insertions(+), 17 deletions(-)
>>
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> index c8bcd29bde09..669ba260342f 100644
>> --- a/security/landlock/net.c
>> +++ b/security/landlock/net.c
>> @@ -2,7 +2,7 @@
>>   /*
>>    * Landlock LSM - Network management and hooks
>>    *
>> - * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
>> + * Copyright © 2022-2024 Huawei Tech. Co., Ltd.
>>    * Copyright © 2022-2023 Microsoft Corporation
>>    */
>>   
>> @@ -61,17 +61,34 @@ static const struct landlock_ruleset *get_current_net_domain(void)
>>   	return dom;
>>   }
>>   
>> -static int current_check_access_socket(struct socket *const sock,
>> -				       struct sockaddr *const address,
>> -				       const int addrlen,
>> -				       access_mask_t access_request)
>> +static int check_access_socket(const struct landlock_ruleset *const dom,
>> +			       __be16 port, access_mask_t access_request)
> 
> It might be worth briefly spelling out in documentation that access_request in
> current_check_access_socket() may only have a single bit set.  This is different
> to other places where access_mask_t is used, where combinations of these flags
> are possible.
> 
> These functions do checks for special cases using "if (access_request ==
> LANDLOCK_ACCESS_NET_CONNECT_TCP)" and the same for "bind".  I think it's a
> reasonable way to simplify the implementation here, but we have to be careful to
> not accidentally use it differently.
> 
> It is a preexisting issue, so I don't consider it a blocker, but it might be
> worth fixing while we are at it?

I think such comment is not required if we remove
"current_check_access_socket()" as you suggest? In this function
access_request can be a mask with multiple access rights included.

> 
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
>> +	if (landlock_unmask_layers(rule, access_request, &layer_masks,
>> +				   ARRAY_SIZE(layer_masks)))
>> +		return 0;
>> +
>> +	return -EACCES;
>> +}
>> +
>> +static int current_check_access_socket(struct socket *const sock,
> 
> Re-reading the implementation of this function, it was surprised how specialized
> it is towards the "connect" and "bind" use cases, which it has specific code
> paths for.  This does not look like it would extend naturally to additional
> operations.
> 
> After your refactoring, current_check_access_socket() is now (a) checking that
> we are looking at a TCP address, and extracting the port, and then (b) doing
> connect- and bind-specific logic, and then (c) calling check_access_socket().
> 
> Would it maybe be possible to turn the code logic around by creating a
> "get_tcp_port()" helper function for step (a), and then doing all of (a), (b)
> and (c) directly from hook_socket_bind() and hook_socket_connect()?  It would
> have the upside that in step (b) you don't need to distinguish between bind and
> connect because it would be clear from the context which of the two cases we are
> in.  It would also remove the need for a function that only supports one bit in
> the access_mask_t, which is potentially surprising.
> 
> Thanks,
> —Günther
> 

Good idea! But I suggest using "get_port_from_addr_tcp()" naming to
distinguish between extracting a port from an address structure and
from a socket (as performed in hook_listen() in the next patch).
