Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0BD7EF10
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2024 12:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712062721; cv=none; b=obCTdbVU22ayMx5OrXP9/iNpLFO/se1chO35aXpb/SmtxIJJ3FZwZBDhcEt+0voSpa9lmM5qEMu6VQnoGz8poeHAR+Rb1qljcz+cNvotgHRCGmfgygkW0GuFktAF6QudO/ktzK1YEgteusnONe3i4r0o2ENISgblTn28RlmjinY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712062721; c=relaxed/simple;
	bh=MOsyJHGnCv3B50Grga+TlbaCxJkk9PFUQ0cyx9AND8I=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fLBA3PkL3OAlCsXr/9v3gjoCsItNCakZJSApyxZU8dogOvcb5FzXU5cBNOD3uY1SD0XERdjE1+mVKkzWCAagjf42q0p57PXIJ24TaoOARJjYOTigb/om5FMwA917E2o1kEuVAwYcPTaOd+W/X0DimkSf6pP6wSAIyx/RQOVdNoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4V87Cn1M4JzwQx1;
	Tue,  2 Apr 2024 20:55:49 +0800 (CST)
Received: from canpemm500006.china.huawei.com (unknown [7.192.105.130])
	by mail.maildlp.com (Postfix) with ESMTPS id 18BD71400FD;
	Tue,  2 Apr 2024 20:58:36 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 20:58:35 +0800
Subject: Re: [PATCH nft] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
CC: <kadlec@netfilter.org>, <netfilter-devel@vger.kernel.org>
References: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
 <20240402105642.GB18301@breakpoint.cc> <ZgvsTTsCUay4GCUa@calendula>
From: "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <3e49bd14-ee3a-af68-1903-d5418894ae75@huawei.com>
Date: Tue, 2 Apr 2024 20:58:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZgvsTTsCUay4GCUa@calendula>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)

> On Tue, Apr 02, 2024 at 12:56:42PM +0200, Florian Westphal wrote:
>> Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
>>> nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
>>> concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
>>> And thhere is not any protection when iterate over nf_tables_flowtables
>>> list in __nft_flowtable_type_get(). Therefore, there is pertential
>>> data-race of nf_tables_flowtables list entry.
>>>
>>> Use list_for_each_entry_rcu() with rcu_read_lock() to Iterate over
>>> nf_tables_flowtables list in __nft_flowtable_type_get() to resolve it.
>>
>> I don't think this resolves the described race.
>>
>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>> ---
>>>  net/netfilter/nf_tables_api.c | 8 ++++++--
>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>>> index fd86f2720c9e..fbf38e32f11d 100644
>>> --- a/net/netfilter/nf_tables_api.c
>>> +++ b/net/netfilter/nf_tables_api.c
>>> @@ -8297,10 +8297,14 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
>>>  {
>>>  	const struct nf_flowtable_type *type;
>>>  
>>> -	list_for_each_entry(type, &nf_tables_flowtables, list) {
>>> -		if (family == type->family)
>>> +	rcu_read_lock()
>>> +	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
>>> +		if (family == type->family) {
>>> +			rcu_read_unlock();
>>>  			return type;
>>
>> This means 'type' can be non-null while module is being unloaded,
>> before refcount increment.
>>
>> You need acquire rcu_read_lock() in the caller, nft_flowtable_type_get,
>> and release it after refcount on module owner failed or succeeded.
> 
> And these need to be rcu protected:
> 
> static LIST_HEAD(nf_tables_expressions);
> static LIST_HEAD(nf_tables_objects);
> static LIST_HEAD(nf_tables_flowtables);
> 
> for a complete fix for:
> 
> f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
> .
> 

I would be happy to do these. Thank you for your kind remind!


William Xuan
Best regards.




