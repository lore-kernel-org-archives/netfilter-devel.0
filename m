Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3292A288504;
	Thu, 21 Aug 2025 01:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755741396; cv=none; b=kYA7dTVBt8ygtvLbU93Pk0qzRDhIFXQBvXtv9r/e3IUkxDJChu60TqofloNRmXZr/bUtxYK842YAkD1BN0lZTgIaGB4Ue99ALhiMcdEl8SSurpLgAO7cibQTnVtdiB1Btx1PIrJ6FcFUQFm02Ox5jfiF4M+qhN3c0lF/OZM+G9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755741396; c=relaxed/simple;
	bh=rB1BGf26IEIKquulbtzHM2s9bSe26Cv/iAmfPf+I+1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=G4q2pYqLwNnT8lIFqrM5hTHgormSxZ1kl0/YxecLrrXYknudztNahiAjEs5qC4GP/TGJcjVEtL0zVQiz3INQT77BEivpSxUXI+7lTozVb7vmRHFN7MQh3IMcjFsE/P4Rz3F3hNTj5xrLyuJg9OEapJ6bIgPqpagHsAHpRMkQPI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c6mXR14Snzdcfc;
	Thu, 21 Aug 2025 09:52:07 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 750DC180B63;
	Thu, 21 Aug 2025 09:56:30 +0800 (CST)
Received: from [10.174.176.70] (10.174.176.70) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:56:29 +0800
Message-ID: <80706fff-ca22-45f5-ac0b-ff84e1ba6a8b@huawei.com>
Date: Thu, 21 Aug 2025 09:56:27 +0800
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
From: Wang Liang <wangliang74@huawei.com>
In-Reply-To: <aKWyImI9qxi6GDIF@strlen.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500016.china.huawei.com (7.185.36.197)


在 2025/8/20 19:31, Florian Westphal 写道:
> Wang Liang <wangliang74@huawei.com> wrote:
>> Previous commit 2d72afb34065 ("netfilter: nf_conntrack: fix crash due to
>> removal of uninitialised entry") move the IPS_CONFIRMED assignment after
>> the hash table insertion.
> How is that related to this change?
> As you write below, the bug came in with 62e7151ae3eb.


Before the commit 2d72afb34065, __nf_conntrack_confirm() set
'ct->status |= IPS_CONFIRMED;' before check hash, the warning will not
happen, so I put it here.

As you say, the bug came in with 62e7151ae3eb. I will delete this paragraph
in next patch.

>> To solve the hash conflict, nf_ct_resolve_clash() try to merge the
>> conntracks, and update skb->_nfct. However, br_nf_local_in() still use the
>> old ct from local variable 'nfct' after confirm(), which leads to this
>> issue. Fix it by rereading nfct from skb.
>>
>> Fixes: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
>> Signed-off-by: Wang Liang <wangliang74@huawei.com>
>> ---
>>   net/bridge/br_netfilter_hooks.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
>> index 94cbe967d1c1..55b1b7dcb609 100644
>> --- a/net/bridge/br_netfilter_hooks.c
>> +++ b/net/bridge/br_netfilter_hooks.c
>> @@ -626,6 +626,7 @@ static unsigned int br_nf_local_in(void *priv,
>>   		break;
>>   	}
>>   
>> +	nfct = skb_nfct(skb);
>>   	ct = container_of(nfct, struct nf_conn, ct_general);
>>   	WARN_ON_ONCE(!nf_ct_is_confirmed(ct));
> There is a second bug here, confirm can return NF_DROP and
> nfct will be NULL.


Thanks for your suggestion!

Do you mean that ct may be deleted in confirm and return NF_DROP, so we can
not visit it in br_nf_local_in() and need to add 'case NF_DROP:' here?

I cannot find somewhere set skb->_nfct to NULL and return NF_DROP. Can you
give some hints?

------
Best regards
Wang Liang

>
> Can you make this change too? (or something similar)?
>
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 94cbe967d1c1..69b7b7c7565e 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -619,8 +619,9 @@ static unsigned int br_nf_local_in(void *priv,
>          nf_bridge_pull_encap_header(skb);
>          ret = ct_hook->confirm(skb);
>          switch (ret & NF_VERDICT_MASK) {
> +       case NF_DROP:
>          case NF_STOLEN:
> -               return NF_STOLEN;
> +               return ret;
>
>
> nfct reload seems correct, thanks for catching this.
