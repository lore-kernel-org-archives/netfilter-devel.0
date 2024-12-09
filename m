Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3F12165E0;
	Mon,  9 Dec 2024 10:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733739605; cv=none; b=EWSbvLTM0UIx3uksr1DKCyUXdJ+VrNT0jc+G8lqNwqgEysucvQdnq5ZFxowoZ9tyVEZEcwvB1Hv/5tJdBx91C5Obor3cbH3Be4k4hQooqNXkrZCpXwQsyb8CG4f4ZSV+FqZYRx2C3PmKfTi97YQsBi6q4eR1sHHTW2hGIJ6VChY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733739605; c=relaxed/simple;
	bh=jcDfGiGBJQOcG2/HUp85dnb0Wju06Z6xQW8db4c8UsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=W79C36JZk1xFQLYUw3GFnz1S22g1R1QeuKdwMBpnmm2v18m8iu5p/4XBAXs2WL7hEwIcJTd5v/csVySJYbHIZAvUMSlUgl2Hv4c2bGoMLDa43JiLRJVs6w7+Cl9J9xNGwtZms98YfLz3HY6D6XOZsWBTrqLnrgPdzhQ9Bc7plyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Y6Hmy6GSnz6GC6l;
	Mon,  9 Dec 2024 18:15:30 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A6ED1403A1;
	Mon,  9 Dec 2024 18:20:01 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 9 Dec 2024 13:19:59 +0300
Message-ID: <5cd7186d-45cc-e31f-3e8e-26aa805f5b5c@huawei-partners.com>
Date: Mon, 9 Dec 2024 13:19:59 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <20241204.xoog3Quei4ta@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241204.xoog3Quei4ta@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 12/4/2024 10:30 PM, Mickaël Salaün wrote:
> On Thu, Oct 17, 2024 at 07:04:47PM +0800, Mikhail Ivanov wrote:
>> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
>> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
>> should not restrict bind(2) and connect(2) for non-TCP protocols
>> (SCTP, MPTCP, SMC).
>>
>> sk_is_tcp() is used for this to check address family of the socket
>> before doing INET-specific address length validation. This is required
>> for error consistency.
>>
>> Closes: https://github.com/landlock-lsm/linux/issues/40
>> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>
>> Changes since v1:
>> * Validate socket family (=INET{,6}) before any other checks
>>    with sk_is_tcp().
>> ---
>>   security/landlock/net.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> index fdc1bb0a9c5d..1e80782ba239 100644
>> --- a/security/landlock/net.c
>> +++ b/security/landlock/net.c
>> @@ -66,8 +66,8 @@ static int current_check_access_socket(struct socket *const sock,
>>   	if (WARN_ON_ONCE(dom->num_layers < 1))
>>   		return -EACCES;
>>   
>> -	/* Checks if it's a (potential) TCP socket. */
>> -	if (sock->type != SOCK_STREAM)
>> +	/* Do not restrict non-TCP sockets. */
> 
> You can remove this comment because the following check is explicit.

ok, thx

> 
>> +	if (!sk_is_tcp(sock->sk))
>>   		return 0;
>>   
>>   	/* Checks for minimal header length to safely read sa_family. */
>> -- 
>> 2.34.1
>>
>>
