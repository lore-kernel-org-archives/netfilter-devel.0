Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E142424640;
	Mon,  6 Jul 2026 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783339729; cv=none; b=e0P9+LUubR8KpwdlTh8Bs0HM4MlcB3Yv4wPFhkNucQm/rzbDoi+s5kNH/TtpKG/48C7OfHsnQKPUMXZlks6Tucl+th3Zi9//cVcPNk3zWCPdY09dgr3uZAlW6Bo+JvvdaJjVhg3N4i26O30c/OHlnRcmWKOgblTrtDhCPLivNTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783339729; c=relaxed/simple;
	bh=tRs3GVTaKzsZ4pdHTplCBL/FRJCM1VCYpeCmaeWDU2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=od5wuqgaoesNYbmSzJi7SUyEqOYVy5NwnabXDxR2hu5lzJ7owipS7fsXYGAvjcThFRqO2H0QkwNeuoEQ8T7sBKtFdtxYq7Ia7++1BJIQ0Id+BuLpI72ZsVzRfOy1x3u3/iZ0ORWraXQtkEuVsj/XCxbVxqzd9tAx/IPWjKG83Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=P54UHUvT; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="P54UHUvT"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vC10ux4fJtQ16w2EzTd3hzZ1Dnuiiz7X0EywE4oxAms=;
	b=P54UHUvTOpJkTtH/lmfy0vUn1/WhBFUf4N2W5KI5Q/vjZFxwpf+PP4OyJlNBL9okxWu4TPgT6
	1IPJa9HGTEseaHIHEBvjZk1IxavKqPg1fuT9pQIvJKlMfZmdh9lSs3iF9RQ8+f5wY+jCV1b/i9S
	gnEs1kKLhkwbMBBfo/WEhdM=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gv2vz3HFnzmVbL;
	Mon,  6 Jul 2026 19:59:27 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C65D4055B;
	Mon,  6 Jul 2026 20:08:40 +0800 (CST)
Received: from [10.136.112.147] (10.136.112.147) by
 kwepemr100001.china.huawei.com (7.202.195.168) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 6 Jul 2026 20:08:39 +0800
Message-ID: <3620a5a9-9ced-4825-9bc4-6950be205749@h-partners.com>
Date: Mon, 6 Jul 2026 20:08:38 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS
 offset when port is randomized
To: Florian Westphal <fw@strlen.de>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, "David
 S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, gaoxingwang <gaoxingwang1@huawei.com>, huyizhen
	<huyizhen2@huawei.com>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20260629093408.3927103-1-xietangxin@h-partners.com>
 <akKN4cywAsFRdefX@strlen.de>
 <0ad60f06-387e-49bc-9e26-3dcebf182cb4@h-partners.com>
 <akUhid7_3iHovivd@strlen.de>
Content-Language: en-US
From: xietangxin <xietangxin@h-partners.com>
In-Reply-To: <akUhid7_3iHovivd@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100001.china.huawei.com (7.202.195.168)



On 7/1/2026 10:17 PM, Florian Westphal wrote:
> xietangxin <xietangxin@h-partners.com> wrote:
>> Shifting the helper down to nf_nat_l4proto_unique_tuple() as you suggested
>> encounters a structural roadblock. we don't have access to the skb there.
>> Adding skb to all intermediate callers (like nf_nat_setup_info, get_unique_tuple)
>> would severely pollute the core NAT APIs.
> 
> Right, propagating the skb is too much code churn.
> 
>> would it be acceptable to place this logic in nf_nat_inet_fn() before do_nat?
>>
>>  963 do_nat:
>>              ..here
> 
> This is hit for every packet, not just the first one after
> nf_nat_setup_info().  I suggest a slightly earlier spot in the
> same function.
> 
>  936                                 ret = e->hooks[i].hook(e->hooks[i].priv, skb,
>  937                                                        state);
>  938                                 if (ret != NF_ACCEPT)
>  939                                         return ret;
>  940                                 if (nf_nat_initialized(ct, maniptype))
>  941                                         goto do_nat;
>  942                         }
>  943 null_bind:
>  944                         ret = nf_nat_alloc_null_binding(ct, state->hook);
>  945                         if (ret != NF_ACCEPT)
>  946                                 return ret;
> 
>  .... Here.
> 
>  947                 } else {
> 
> This spot runs only for new connections, right after a nf_nat_setup_info() call.

Hi Florian,

Thanks for your guidance. I’ve successfully fix the helper location
as you suggested, and it works fine for local traffic.

However, I realized that I had completely overlooked the forwarding scenario
(where SNAT acts as a middlebox gateway, e.g. Host A -> Gateway B -> Server C).
In this gateway scenario, when random-fully is enabled, the test results show
a massive performance degradation: the QPS drops from ~19000 down to ~10000.

Since skb->sk is NULL on the forwarding gateway, my current approach of
updating tp->tsoffset in struct tcp_sock cannot be applied here.
To be honest, I am currently stuck on how to handle this forwarding scenario
within the netfilter architecture without adding redundant overhead to the fast path.

Could you please give some advice on how the community would prefer to resolve this?
For instance, should we look into extending the Conntrack NAT extension to
track and adjust the TCP timestamps?

Any suggestions would be highly appreciated!

-- 
Best regards,
Tangxin Xie

