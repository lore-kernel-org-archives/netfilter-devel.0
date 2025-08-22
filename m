Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21D20EB;
	Fri, 22 Aug 2025 01:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755824935; cv=none; b=FzqtVWhijToEIg8WvSjkGXU0g3FXR2OIkrcYh9FZmXxgPtWWYJ8vaFNlE5Sf56e6g/aNB+r5wcq+jlS9S/9sys8zO1mSR1LSSlttq0nfxLNDCoEy1ZUYR2MMQCRZw0mfWYsC8eGnY8a8Vs0uFSqecRSq0iJodilavIYLmAsTI0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755824935; c=relaxed/simple;
	bh=mhtMjMM8sl4QM2j/204rTXTQo3Dig9BevZ/k5TmelaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NRwsWGjLFMhaTwDrkSQRi3DIWrJnSjBzW05W+P/wNj7243KOcPQr1HObjnuHrjFlEc1895i6/4VKT2OQubNv+5Y1xrK9hhsXIn0qK4PdrwQRWNDyM4or82SyFZnqgwZTQD1v8fUU+dHxwdLvRRGC7hyhVcS4hv9ifg3EdaDt07U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c7MQz1hH0zdcS5;
	Fri, 22 Aug 2025 09:04:27 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id ED3CF140257;
	Fri, 22 Aug 2025 09:08:50 +0800 (CST)
Received: from [10.174.176.70] (10.174.176.70) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 09:08:49 +0800
Message-ID: <9f576014-c54f-44d4-a8aa-ddfafeb7a310@huawei.com>
Date: Fri, 22 Aug 2025 09:08:47 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: br_netfilter: reread nf_conn from skb
 after confirm()
To: Florian Westphal <fw@strlen.de>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>, <razor@blackwall.org>,
	<idosch@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <horms@kernel.org>,
	<yuehaibing@huawei.com>, <zhangchangzhong@huawei.com>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<bridge@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20250820043329.2902014-1-wangliang74@huawei.com>
 <aKWyImI9qxi6GDIF@strlen.de>
 <80706fff-ca22-45f5-ac0b-ff84e1ba6a8b@huawei.com>
 <aKbDZWHNf4_Nktsm@strlen.de>
From: Wang Liang <wangliang74@huawei.com>
In-Reply-To: <aKbDZWHNf4_Nktsm@strlen.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500016.china.huawei.com (7.185.36.197)


在 2025/8/21 14:57, Florian Westphal 写道:
> Wang Liang <wangliang74@huawei.com> wrote:
>> 在 2025/8/20 19:31, Florian Westphal 写道:
>>> Wang Liang <wangliang74@huawei.com> wrote:
>>>> Previous commit 2d72afb34065 ("netfilter: nf_conntrack: fix crash due to
>>>> removal of uninitialised entry") move the IPS_CONFIRMED assignment after
>>>> the hash table insertion.
>>> How is that related to this change?
>>> As you write below, the bug came in with 62e7151ae3eb.
>> Before the commit 2d72afb34065, __nf_conntrack_confirm() set
>> 'ct->status |= IPS_CONFIRMED;' before check hash, the warning will not
>> happen, so I put it here.
> Oh, right, the problem was concealed before this.
>
>>> There is a second bug here, confirm can return NF_DROP and
>>> nfct will be NULL.
>> Thanks for your suggestion!
>>
>> Do you mean that ct may be deleted in confirm and return NF_DROP, so we can
>> not visit it in br_nf_local_in() and need to add 'case NF_DROP:' here?
>>
>> I cannot find somewhere set skb->_nfct to NULL and return NF_DROP. Can you
>> give some hints?
> You are right, skb->_nfct isn't set to NULL in case NF_DROP is returned.
> However, the warning will trigger as we did not insert the conntrack
> entry in that case.
>
> I suggest to remove the warning, I don't think it buys anything.
>
> Thanks.


Yes, remove the warning is a good a choice. I will remove the two lines in
v2 patch later, please check it.

------
Best regards
Wang Liang

