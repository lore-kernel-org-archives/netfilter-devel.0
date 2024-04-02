Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1793433F2
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2024 12:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712062374; cv=none; b=dCkMmSr3ujA6I15qJlVx9SGGUGnsKkvEPdsB9vrrysOWq90hN08s8i7eJyZ5IIJX95Tq4ZcfBwJK9ou2Lc3fcD77up4opxsyiBjIZaDoga7MvHvmGh7RDhnf1DbMK+Nl2VmFxV+LnSs7YYDLCRej/9xEx04B+JJ6R4YRE9F4cPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712062374; c=relaxed/simple;
	bh=Ry2usyAphN2kumMuNWURSYQknB6c+yLt1XTbxWrkvJ4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=r4eDD1quIZMTDDjcbPqOKvwwpO9kkupXWUpe5eXx/zBFlbbqdBYrgTc6zHhwxgi5KTikeE1VNtXwaeAeoq2tCxrePCzTIwcayg8AyO1Afj4jDwNSjirvIEXUagIq8a1QJ8BBz1cyxGIgpgsIvPnSpWLZo3E5/LdcXideLwRu8xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4V877H3W0jz1wpZN;
	Tue,  2 Apr 2024 20:51:55 +0800 (CST)
Received: from canpemm500006.china.huawei.com (unknown [7.192.105.130])
	by mail.maildlp.com (Postfix) with ESMTPS id 762B71402C7;
	Tue,  2 Apr 2024 20:52:47 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 20:52:47 +0800
Subject: Re: [PATCH nft] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
To: Florian Westphal <fw@strlen.de>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
References: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
 <20240402105642.GB18301@breakpoint.cc>
From: "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <8393b674-2ad9-404f-8795-4a871240bf1b@huawei.com>
Date: Tue, 2 Apr 2024 20:52:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240402105642.GB18301@breakpoint.cc>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)

> Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
>> nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
>> concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
>> And thhere is not any protection when iterate over nf_tables_flowtables
>> list in __nft_flowtable_type_get(). Therefore, there is pertential
>> data-race of nf_tables_flowtables list entry.
>>
>> Use list_for_each_entry_rcu() with rcu_read_lock() to Iterate over
>> nf_tables_flowtables list in __nft_flowtable_type_get() to resolve it.
> 
> I don't think this resolves the described race.
> 
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  net/netfilter/nf_tables_api.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index fd86f2720c9e..fbf38e32f11d 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -8297,10 +8297,14 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
>>  {
>>  	const struct nf_flowtable_type *type;
>>  
>> -	list_for_each_entry(type, &nf_tables_flowtables, list) {
>> -		if (family == type->family)
>> +	rcu_read_lock()
>> +	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
>> +		if (family == type->family) {
>> +			rcu_read_unlock();
>>  			return type;
> 
> This means 'type' can be non-null while module is being unloaded,
> before refcount increment.
> 
> You need acquire rcu_read_lock() in the caller, nft_flowtable_type_get,
> and release it after refcount on module owner failed or succeeded.
> .
In fact, I just want to resolve the potential tear-down problem about list entry here.

As following:

void nft_unregister_flowtable_type(struct nf_flowtable_type *type)
{
	nfnl_lock(NFNL_SUBSYS_NFTABLES);
	/* just use WRITE_ONCE() inside, but not rcu_assign_pointer().
	 * It can not form competition protection with rcu_read_lock().
	 */
	list_del_rcu(&type->list);
	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
}

static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
{
	const struct nf_flowtable_type *type;

	/* Get list entry use READ_ONCE() inside. And I think rcu_read_lock() maybe unnecessary. */
	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
		if (family == type->family)
			return type;
	}
	return NULL;
}

static const struct nf_flowtable_type *
nft_flowtable_type_get(struct net *net, u8 family)
{
	const struct nf_flowtable_type *type;

	type = __nft_flowtable_type_get(family);
	/* If type is non-NULL, try to get module. If the module
	 * state is not ok, it will fail here.
	 */
	if (type != NULL && try_module_get(type->owner))
		return type;

	lockdep_nfnl_nft_mutex_not_held();
#ifdef CONFIG_MODULES
	if (type == NULL) {
		if (nft_request_module(net, "nf-flowtable-%u", family) == -EAGAIN)
			return ERR_PTR(-EAGAIN);
	}
#endif
	return ERR_PTR(-ENOENT);
}

So I think replace with list_for_each_entry_rcu() can resolve the tear-down problem now.


William Xuan
Best regards.
