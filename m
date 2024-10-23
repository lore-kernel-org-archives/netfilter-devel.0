Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728F16EB7C;
	Wed, 23 Oct 2024 06:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729666334; cv=none; b=OPbGU/fiMY/b8KlRwDTAFc11zNE+qNaFNc3bCW2RTn4lgP3Q7FAhCb61xGpLN5mK+2Ic5fhkQDUlYoK157TsbdN5rOFAYmSKpt4zGciRQPWcjIKMTIUYM2VzIvA0F6E1wddbG47A3vCb/+wvjndYEjBPwhQDB2NIAuQY686Yd5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729666334; c=relaxed/simple;
	bh=EUdBVH5hXEGzvh0WpLYIKcsLNXNeWShyHlmv4gfs8wc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=lfhi84VLz8a87B6BS5NK0jpENF4G/3ch9vhR1f7AQJqra1D6Z/gPu8EVcwZNcIffuwTCQc/Diwm1IXM3pfbAfEZAtVvetEps5LrcZDE+0eNRaNY1OXaJPOVANpEXWHnfzmdueYaTJ9BD75S1oSa7B2CG3KGmIpA67GMcsKwL2X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XYKQz6CLBzfdRL;
	Wed, 23 Oct 2024 14:49:31 +0800 (CST)
Received: from kwepemd100023.china.huawei.com (unknown [7.221.188.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A6EA1800D9;
	Wed, 23 Oct 2024 14:52:02 +0800 (CST)
Received: from [10.174.177.223] (10.174.177.223) by
 kwepemd100023.china.huawei.com (7.221.188.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 23 Oct 2024 14:52:00 +0800
Message-ID: <7492d260-0e17-4f60-81c2-861efe317ece@huawei.com>
Date: Wed, 23 Oct 2024 14:52:00 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
From: "dongchenchen (A)" <dongchenchen2@huawei.com>
To: <dongchenchen2@huawei.com>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<fw@strlen.de>, <kuniyu@amazon.com>, <netfilter-devel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <yuehaibing@huawei.com>, Simon Horman
	<horms@kernel.org>
References: <20241022085753.2069639-1-dongchenchen2@huawei.com>
 <20241022153327.GW402847@kernel.org>
 <1e9083bf-2297-443c-a703-4c54b6062886@huawei.com>
In-Reply-To: <1e9083bf-2297-443c-a703-4c54b6062886@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd100023.china.huawei.com (7.221.188.33)


On 2024/10/23 14:32, dongchenchen (A) wrote:
>
> On 2024/10/22 23:33, Simon Horman wrote:
>> On Tue, Oct 22, 2024 at 04:57:53PM +0800, Dong Chenchen wrote:
>>> ip6table_nat module unload has refcnt warning for UAF. call trace is:
>>>
>>> WARNING: CPU: 1 PID: 379 at kernel/module/main.c:853 
>>> module_put+0x6f/0x80
>>> Modules linked in: ip6table_nat(-)
>>> CPU: 1 UID: 0 PID: 379 Comm: ip6tables Not tainted 
>>> 6.12.0-rc4-00047-gc2ee9f594da8-dirty #205
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>>> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>> RIP: 0010:module_put+0x6f/0x80
>>> Call Trace:
>>>   <TASK>
>>>   get_info+0x128/0x180
>>>   do_ip6t_get_ctl+0x6a/0x430
>>>   nf_getsockopt+0x46/0x80
>>>   ipv6_getsockopt+0xb9/0x100
>>>   rawv6_getsockopt+0x42/0x190
>>>   do_sock_getsockopt+0xaa/0x180
>>>   __sys_getsockopt+0x70/0xc0
>>>   __x64_sys_getsockopt+0x20/0x30
>>>   do_syscall_64+0xa2/0x1a0
>>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>
>>> Concurrent execution of module unload and get_info() trigered the 
>>> warning.
>>> The root cause is as follows:
>>>
>>> cpu0                      cpu1
>>> module_exit
>>> //mod->state = MODULE_STATE_GOING
>>>    ip6table_nat_exit
>>>      xt_unregister_template
>>>      //remove table from templ list
>>>                       getinfo()
>>>                       t = xt_find_table_lock
>>>                         list_for_each_entry(tmpl, &xt_templates[af]...)
>>>                             if (strcmp(tmpl->name, name))
>>>                                 continue;  //table not found
>>>                             try_module_get
>>>                         list_for_each_entry(t, &xt_net->tables[af]...)
>>>                             return t;  //not get refcnt
>>>                       module_put(t->me) //uaf
>>>      unregister_pernet_subsys
>>>      //remove table from xt_net list
>>>
>>> While xt_table module was going away and has been removed from
>>> xt_templates list, we couldnt get refcnt of xt_table->me. Skip
>>> the re-traversal of xt_net->tables list to fix it.
>>>
>>> Fixes: c22921df777d ("netfilter: iptables: Fix potential 
>>> null-ptr-deref in ip6table_nat_table_init().")
>>> Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
>>> ---
>>>   net/netfilter/x_tables.c | 8 +++++---
>>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
>>> index da5d929c7c85..359c880ecb07 100644
>>> --- a/net/netfilter/x_tables.c
>>> +++ b/net/netfilter/x_tables.c
>>> @@ -1239,6 +1239,7 @@ struct xt_table *xt_find_table_lock(struct net 
>>> *net, u_int8_t af,
>>>       struct module *owner = NULL;
>>>       struct xt_template *tmpl;
>>>       struct xt_table *t;
>>> +    int err = -ENOENT;
>>>         mutex_lock(&xt[af].mutex);
>>>       list_for_each_entry(t, &xt_net->tables[af], list)
>>> @@ -1247,8 +1248,6 @@ struct xt_table *xt_find_table_lock(struct net 
>>> *net, u_int8_t af,
>>>         /* Table doesn't exist in this netns, check larval list */
>>>       list_for_each_entry(tmpl, &xt_templates[af], list) {
>>> -        int err;
>>> -
>>>           if (strcmp(tmpl->name, name))
>>>               continue;
>>>           if (!try_module_get(tmpl->me))
>>> @@ -1267,6 +1266,9 @@ struct xt_table *xt_find_table_lock(struct net 
>>> *net, u_int8_t af,
>>>           break;
>>>       }
>>>   +    if (err < 0)
>>> +        goto out;
>>> +
>>>       /* and once again: */
>>>       list_for_each_entry(t, &xt_net->tables[af], list)
>>>           if (strcmp(t->name, name) == 0)
>>> @@ -1275,7 +1277,7 @@ struct xt_table *xt_find_table_lock(struct net 
>>> *net, u_int8_t af,
>>>       module_put(owner);
>> Hi Dong Chenchen,
>>
>> I'm unsure if this can happen in practice, although I guess so else the
>> module_put() call above is never reached.
>
> Hi, Simon. Thank you very much for your suggestions!
>
> module_put(owner) will be never reached indeed. which wiil be executed 
> in:
>
>
sorry, there is a problem with the email format. resend:

module_put(owner) wiil be executed in:
1. xt_table not found in tmpl list and xt_net list:
   owner == NULL, no need to put
2. xt_table found in tmpl list, table_init() fail to add table to xt_net 
list but return 0
this situation may be mutually exclusive

So I thought it may not need to call module_puy(owner) here

xt_find_table_lock
     list_for_each_entry(tmpl, &xt_templates[af], list)
         if (strcmp(tmpl->name, name))
             continue;
         err = tmpl->table_init(net); //add xtable to xt_net list
         if (err < 0) {
                 module_put(owner);
                 return ERR_PTR(err);
         }
     list_for_each_entry(t, &xt_net->tables[af], list)
         if (strcmp(t->name, name) == 0)
             return t;  //err = 0, will return here

     module_put(owner); // put effectively while (err == 0) && (xtable 
found in tmpl list) and add table xt_net list failed in table_init()
  out:
     mutex_unlock(&xt[af].mutex);
     return ERR_PTR(-ENOENT);
>> In any case, previously if we got
>> to this line then the function would return ERR_PTR(-ENOENT). But now it
>> will return ERR_PTR(0). Which although valid often indicates a bug.
>>
>> Flagged by Smatch.
>
> As described above, err = 0 will be return in xt_net table list re- 
> traversal.
>
>>>    out:
>>>       mutex_unlock(&xt[af].mutex);
>>> -    return ERR_PTR(-ENOENT);
>>> +    return ERR_PTR(err);
>>>   }
>>>   EXPORT_SYMBOL_GPL(xt_find_table_lock);
>>>   --
>>> 2.25.1
>>>
>>>
