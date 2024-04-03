Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C3A6EB45
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133047; cv=none; b=nOoWZMXJatFmc+WYqe4Q9oWobq+gViY5aSiUlUylHm0t6jc7BBcAPUjC7hK8MXZCRf2vEEY+MsuE9TY36TBohf5Wmv3LVfMW07+/kEaoLwUR1fWsrehUaGmHqcJim4sli3fB3R+3/9FGmRfvuXE+qLmrcSG/kDk+6vt5YdHGjhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133047; c=relaxed/simple;
	bh=guQC5/hZTZisIFKKljwEtcY+UbW2ZY/1Sinp76lyOkY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Jyxnb8MitcoKt+AinXEQs4VEmpVfrnesPLiN1o5kDofimo3VFPiZWZ+ZBf6DuQjAoRQKgbaXeNM3micMQdJ9kMglTrKOaRHqmNmfWEaeqy8YTwe+J9Tef1li+gOgbAIeU+bUl0iuYiVYj/5pzRbMoD8OCIAByhEWdwy7o7aIH+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4V8dDR6DTcz1QCD6;
	Wed,  3 Apr 2024 16:28:07 +0800 (CST)
Received: from canpemm500006.china.huawei.com (unknown [7.192.105.130])
	by mail.maildlp.com (Postfix) with ESMTPS id E41F118007D;
	Wed,  3 Apr 2024 16:30:41 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 16:30:41 +0800
Subject: Re: [PATCH nft v2] netfilter: nf_tables: Fix pertential data-race in
 __nft_flowtable_type_get()
To: Florian Westphal <fw@strlen.de>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
References: <20240403072204.2139712-1-william.xuanziyang@huawei.com>
 <20240403080144.GC26310@breakpoint.cc>
From: "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <0a1e576a-7fb8-8f26-17ce-54ec137acf70@huawei.com>
Date: Wed, 3 Apr 2024 16:30:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240403080144.GC26310@breakpoint.cc>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)

> Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
>> nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
>> concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
>> And thhere is not any protection when iterate over nf_tables_flowtables
>> list in __nft_flowtable_type_get(). Therefore, there is pertential
>> data-race of nf_tables_flowtables list entry.
>>
>> Use list_for_each_entry_rcu() to iterate over nf_tables_flowtables list
>> in __nft_flowtable_type_get(), and use rcu_read_lock() in the caller
>> nft_flowtable_type_get() to protect the entire type query process.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> Would you be so kind to send followup patches for the other two types
> Pablo pointed out?
> 
> static LIST_HEAD(nf_tables_expressions);
> static LIST_HEAD(nf_tables_objects);
> 
> It looks like they have same issue.

Yes, I am doing and testing.

Best regards.
> 
> Thanks!
> 
> 
> .
> 
