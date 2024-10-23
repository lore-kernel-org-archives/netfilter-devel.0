Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF203A8D0;
	Wed, 23 Oct 2024 07:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729667024; cv=none; b=CUxLPzSz3u9gB8mhFZG6Kd6VhtpgszWtxY6lGDBsWf17cYEC9aSawyyE6z8y+F8Ml6lIzoNFfOIQJpRwX2LKs++ouQNctGuHoH29A4ECesgQHfspbrT/+XPeI0wYFoR6q8srVF0su+B/mQ7AJ0EKNE9zx+OubxQtkpmLUHXVQsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729667024; c=relaxed/simple;
	bh=07YQ39BvaVJ3ZEungHzuAFJToOywmLh4vhw+RhC7ArI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RnsZ+t7Hn7nEw1qsb6SOriFEQGIUfqTzhkaXj8M1Q3iJSppHzAGFhpdezCHLoxFd205hNO+GE6Jsxagutd2d999q5bD6vJ/T4Q32U1N0pnRXAGDNcL/KdBIU1cieJXjY4BSKAYeMZ2bGgGi4jAnXf4//dAdBs0CVNyt6DsCp0HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XYKkF6TZBzQs9f;
	Wed, 23 Oct 2024 15:02:45 +0800 (CST)
Received: from kwepemd100023.china.huawei.com (unknown [7.221.188.33])
	by mail.maildlp.com (Postfix) with ESMTPS id ADF60180103;
	Wed, 23 Oct 2024 15:03:37 +0800 (CST)
Received: from [10.174.177.223] (10.174.177.223) by
 kwepemd100023.china.huawei.com (7.221.188.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 23 Oct 2024 15:03:36 +0800
Message-ID: <e4336ee6-31c1-4299-bddc-4c3072e03065@huawei.com>
Date: Wed, 23 Oct 2024 15:03:35 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
To: Florian Westphal <fw@strlen.de>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<kuniyu@amazon.com>, <netfilter-devel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <yuehaibing@huawei.com>
References: <20241022085753.2069639-1-dongchenchen2@huawei.com>
 <20241022094839.GA26371@breakpoint.cc>
From: "dongchenchen (A)" <dongchenchen2@huawei.com>
In-Reply-To: <20241022094839.GA26371@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd100023.china.huawei.com (7.221.188.33)


On 2024/10/22 17:48, Florian Westphal wrote:
> Dong Chenchen <dongchenchen2@huawei.com> wrote:
>>   net/netfilter/x_tables.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
>> index da5d929c7c85..359c880ecb07 100644
>> --- a/net/netfilter/x_tables.c
>> +++ b/net/netfilter/x_tables.c
>> @@ -1239,6 +1239,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>>   	struct module *owner = NULL;
>>   	struct xt_template *tmpl;
>>   	struct xt_table *t;
>> +	int err = -ENOENT;
>>   
>>   	mutex_lock(&xt[af].mutex);
>>   	list_for_each_entry(t, &xt_net->tables[af], list)
>> @@ -1247,8 +1248,6 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>>   
>>   	/* Table doesn't exist in this netns, check larval list */
>>   	list_for_each_entry(tmpl, &xt_templates[af], list) {
>> -		int err;
>> -
>>   		if (strcmp(tmpl->name, name))
>>   			continue;
>>   		if (!try_module_get(tmpl->me))
>> @@ -1267,6 +1266,9 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>>   		break;
>>   	}
>>   
>> +	if (err < 0)
>> +		goto out;
>> +
>>   	/* and once again: */
>>   	list_for_each_entry(t, &xt_net->tables[af], list)
>>   		if (strcmp(t->name, name) == 0)
> Proabably also:
>
> -  		if (strcmp(t->name, name) == 0)
> +               if (strcmp(t->name, name) == 0 && owner == t->me)

Hi, Florian. Thank you very much for your suggestions!

If err <0 , xt_table does not exist in the xt_net list or the tmpl list.

And  list operations are performed in the mutex lock.

Therefore, it may not be necessary to traverse the xt_net list again.

