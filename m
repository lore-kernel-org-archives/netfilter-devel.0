Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85323D527
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712105479; cv=none; b=Fj//hcfKH/A7bzdaQe+Aqvy/ivcNsReNo88+vuhQAR0tjxldB9pTfw9dXAKJ5Co8gCh+c3i5kY8xngTFTe9uYIWTwEsL5fvfQ4cRiOjwnFHlXs6FFTxLlCmn9Bz6nlTJUoXE6i31hkgK1gC9pN5RZytOCRzbQZq9esIhDbiX8iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712105479; c=relaxed/simple;
	bh=RzdWNphhB3cH6b8v2I330W/4Om5ixKmLlgD8Gh8HoSg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HkIX284HCeR/XUq7RWuSvQWx8embJop8zTWasg5HIdmmPCTTqO4kqVX7WLMISOaBhB3tGp/SpxGYCJP6bWLyhgf3OT22REa99qs8N+wOX6EVHOEUu36uJcZDZF9+rWy0Gbp+Y1NLq6TrQrSRfXn/tJi7eI8SmuWw0h4taRKbtU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4V8R242pcrz29dPW;
	Wed,  3 Apr 2024 08:48:28 +0800 (CST)
Received: from canpemm500006.china.huawei.com (unknown [7.192.105.130])
	by mail.maildlp.com (Postfix) with ESMTPS id C125C1A016C;
	Wed,  3 Apr 2024 08:51:13 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 08:51:13 +0800
Subject: Re: [PATCH nft] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
To: Florian Westphal <fw@strlen.de>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
References: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
 <20240402105642.GB18301@breakpoint.cc>
 <8393b674-2ad9-404f-8795-4a871240bf1b@huawei.com>
 <20240402135514.GC18301@breakpoint.cc>
From: "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <e021e592-6f44-5fe0-2768-684bb9d002dd@huawei.com>
Date: Wed, 3 Apr 2024 08:51:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240402135514.GC18301@breakpoint.cc>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)

> Ziyang Xuan (William) <william.xuanziyang@huawei.com> wrote:
>>>> Use list_for_each_entry_rcu() with rcu_read_lock() to Iterate over
>>>> nf_tables_flowtables list in __nft_flowtable_type_get() to resolve it.
>>>
>>> I don't think this resolves the described race.
>>>
>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>>> ---
>>>>  net/netfilter/nf_tables_api.c | 8 ++++++--
>>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>>>> index fd86f2720c9e..fbf38e32f11d 100644
>>>> --- a/net/netfilter/nf_tables_api.c
>>>> +++ b/net/netfilter/nf_tables_api.c
>>>> @@ -8297,10 +8297,14 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
>>>>  {
>>>>  	const struct nf_flowtable_type *type;
>>>>  
>>>> -	list_for_each_entry(type, &nf_tables_flowtables, list) {
>>>> -		if (family == type->family)
>>>> +	rcu_read_lock()
>>>> +	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
>>>> +		if (family == type->family) {
>>>> +			rcu_read_unlock();
>>>>  			return type;
>>>
>>> This means 'type' can be non-null while module is being unloaded,
>>> before refcount increment.
>>>
>>> You need acquire rcu_read_lock() in the caller, nft_flowtable_type_get,
>>> and release it after refcount on module owner failed or succeeded.
>>> .
>> In fact, I just want to resolve the potential tear-down problem about list entry here.
> 
> cpu1							cpu2
> 							rmmod
> 							flowtable_type
> 
> nft_flowtable_type_get
>      __nft_flowtable_type_get
>           finds family == type->family
> 	     						list_del_rcu(type)
> 
> CPU INTERRUPTED
> 							rmmod completes
> 
> nft_flowtable_type_get calls
>    if (type != NULL && try_module_get(type->owner))
> 	   ---> UaF
> 
> Skeleton fix:
> 
> nft_flowtable_type_get(struct net *net, u8 family)
>  {
>  	const struct nf_flowtable_type *type;
> 
> +       rcu_read_lock();
> 	type = __nft_flowtable_type_get(family);
> 	....
>  	if (type != NULL && try_module_get(type->owner)) {
> 		rcu_read_unlock();
>  		return type;
> 	}
> 
> 	rcu_read_unlock();
> 
> This avoids the above UaF, rmmod cannot complete fully until after
> rcu read lock section is done.  (There is a synchronize_rcu in module
> teardown path before the data section is freed).

I see. Thank you for your patient analysis!

>> So I think replace with list_for_each_entry_rcu() can resolve the tear-down problem now.
> 
> I don't think so.
> .
> 
