Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2552E3EA83;
	Wed, 28 Aug 2024 01:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724808941; cv=none; b=bAjKEmrOuM2f63dqB0v8yLTOEzPqxzKkvSj6dPTqZP3jUpKUJhBDLKm1vvQbma4rAEuCZ2/TA+L/b+I0OE695D3I8xJXfa8hpqcK/ft3MzkYm0tuHrT//vidpqan7mhFP252zrcrS9amlqu/8lB6yMQguMyqu4O13q/6XwbtZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724808941; c=relaxed/simple;
	bh=qBLrv9JlE70mWhVlECZv3GB4o9EX244VrjofKIZHJzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VwR7Yoq2ezkqxJaJ5gh3V4JexXHs6XS2ETxfzgShSn9cmDWrj5cMugLwNqTciGh7c/7la8FoluYzXCWI2M/zncdN3lHaZ7AFk+ZvbWz/wWMG75ytfXqMi714n3uTr4cOJiNZrVIWxfdIThuRpLr3oMVtAp/4pcwIjJKcbIVJ4vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Wtn6P00Pqz1S8sL;
	Wed, 28 Aug 2024 09:35:24 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 6728D180044;
	Wed, 28 Aug 2024 09:35:36 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 09:35:36 +0800
Message-ID: <55ea4acb-fd89-4ec2-9eb3-1c6aa1a423ef@huawei.com>
Date: Wed, 28 Aug 2024 09:35:35 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/5] net/netfilter: make use of the helper macro
 LIST_HEAD()
Content-Language: en-US
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <kadlec@netfilter.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>
References: <20240827100407.3914090-1-lihongbo22@huawei.com>
 <20240827100407.3914090-4-lihongbo22@huawei.com> <Zs37l04h3bsK8LIE@calendula>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <Zs37l04h3bsK8LIE@calendula>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/28 0:15, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Tue, Aug 27, 2024 at 06:04:05PM +0800, Hongbo Li wrote:
>> list_head can be initialized automatically with LIST_HEAD()
>> instead of calling INIT_LIST_HEAD(). Here we can simplify
>> the code.
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   net/netfilter/core.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
>> index b00fc285b334..93642fcd379c 100644
>> --- a/net/netfilter/core.c
>> +++ b/net/netfilter/core.c
>> @@ -655,10 +655,8 @@ void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
>>   		       const struct nf_hook_entries *e)
>>   {
>>   	struct sk_buff *skb, *next;
>> -	struct list_head sublist;
>>   	int ret;
>> -
>> -	INIT_LIST_HEAD(&sublist);
>> +	LIST_HEAD(sublist);
> 
> comestic:
> 
>    	struct sk_buff *skb, *next;
> 	LIST_HEAD(sublist);          <- here
>    	int ret;
> 
> I think this should be included in the variable declaration area at
> the beginning of this function.

It is in the variable declaration area just after ret (with a blank line 
before list_for_each_entry_safe).

Thanks,
Hongbo
> 
>>   	list_for_each_entry_safe(skb, next, head, list) {
>>   		skb_list_del_init(skb);
>> -- 
>> 2.34.1
>>
>>
> 
