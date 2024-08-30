Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6442612F59C;
	Fri, 30 Aug 2024 01:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724980681; cv=none; b=HJyI+YYGqeQZVejZcBKSpvLtXTZSuW1lcRBd0uwF+yK6RCsXXcxBOLU/+fodC+teb1aOejvcj/FVuPTScGg3qyHjawDT2NYF62zuHGtZxd3DiK7+Za7us22mpqIBntW7T1gfXm+tQoWAiZPaCUK5Wh3BjMzpnqVqiG0vpILFn2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724980681; c=relaxed/simple;
	bh=3evUu2oSdWg8++Ep2ljPWbekWCjYtkcC8oXqS8bDOyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HmYqpxvIFJQAiowisO66o656spS/5v2oJxUxRWjqZHGhGUILmGWw4qroFo910RjdQGWcOiXVN5Ar8B9JIZYC3uj/WMtYWC8x8jVgFtuqub0peWj7NSrvzREm+qtoGjUTN+YPcAqXobGiSOBKKPG+BbrZ8PJNLSPP4x/CnBu1jjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Ww0b23TX3z1xwcn;
	Fri, 30 Aug 2024 09:15:58 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id D3F291A0188;
	Fri, 30 Aug 2024 09:17:56 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 09:17:56 +0800
Message-ID: <36922bd7-5174-4cf0-b7a2-5ddc77c4868d@huawei.com>
Date: Fri, 30 Aug 2024 09:17:56 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/5] net/tipc: make use of the helper macro
 LIST_HEAD()
To: Simon Horman <horms@kernel.org>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
References: <20240827100407.3914090-1-lihongbo22@huawei.com>
 <20240827100407.3914090-3-lihongbo22@huawei.com>
 <20240827165723.GQ1368797@kernel.org>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240827165723.GQ1368797@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/28 0:57, Simon Horman wrote:
> On Tue, Aug 27, 2024 at 06:04:04PM +0800, Hongbo Li wrote:
>> list_head can be initialized automatically with LIST_HEAD()
>> instead of calling INIT_LIST_HEAD(). Here we can simplify
>> the code.
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   net/tipc/socket.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
>> index 1a0cd06f0eae..9d30e362392c 100644
>> --- a/net/tipc/socket.c
>> +++ b/net/tipc/socket.c
>> @@ -1009,12 +1009,11 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
>>   	struct tipc_member *mbr = NULL;
>>   	struct net *net = sock_net(sk);
>>   	u32 node, port, exclude;
>> -	struct list_head dsts;
>>   	int lookups = 0;
>>   	int dstcnt, rc;
>>   	bool cong;
>> +	LIST_HEAD(dsts);
> 
> nit: Please place this new line where the old dsts line was,
>       in order to preserve, within the context of this hunk,
>       reverse xmas tree order - longest line to shortest -
ok, I've learned, the reverse xmas tree order. Thank you!

Thanks,
Hongbo
>       for local variable declarations.
> 
>>   
>> -	INIT_LIST_HEAD(&dsts);
>>   	ua->sa.type = msg_nametype(hdr);
>>   	ua->scope = msg_lookup_scope(hdr);
>>   
>> @@ -1161,10 +1160,9 @@ static int tipc_send_group_mcast(struct socket *sock, struct msghdr *m,
>>   	struct tipc_group *grp = tsk->group;
>>   	struct tipc_msg *hdr = &tsk->phdr;
>>   	struct net *net = sock_net(sk);
>> -	struct list_head dsts;
>>   	u32 dstcnt, exclude;
>> +	LIST_HEAD(dsts);
>>   
>> -	INIT_LIST_HEAD(&dsts);
>>   	ua->sa.type = msg_nametype(hdr);
>>   	ua->scope = msg_lookup_scope(hdr);
>>   	exclude = tipc_group_exclude(grp);
> 
