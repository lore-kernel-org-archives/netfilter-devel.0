Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B012D97B5;
	Wed,  1 Jul 2026 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914973; cv=none; b=jshpskWyn/Cr7dv6uTJQcIhKn5mdlS1ACaSeOiUJjOUyGiraRgySjUQho20ddyqAPQNlHV//FZTb54cci1688HzZFAOUk8PhCXzmqBZghExdK1XbIb7WxkofJ7+/rCgWPjcUGTkUPmxXZJOarHvkPDqHMdpg+xuPCq7bY41CJUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914973; c=relaxed/simple;
	bh=ZILN6gtte3VTuWz2MDDPVacKzfJyPzK8qQQjXqjTEqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YRIKYxaFXn6tgcRWK5HMch9MR1VftrmnrTEn1aeCZaTR13n8VWY/dHj6Wccq/I6CMzu3+3HeSHk/MZ/55osfKJXqmQxB3d/w8cY2J/xJzpqgOzsf8SqfXfPS/umOS1aRPUvRC3hhDbKC2hMhjzhBzVW8uZiPWBwrCwXz9s8ADko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=BSOoP2EC; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="BSOoP2EC"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x+YQQZdl+zcGOGPMuUavo8t+GSogJ59TL26Izpzh+CI=;
	b=BSOoP2ECTYDILZF7Zy50EpMtsKHKDJzIYalhdbVM+WCkITo8iVto8ldJ8ynAED/CEmsQZuUXL
	Ga3ygHFCpt/K5EfvYkP2GmWmp8iozmVBPzaKuVDtveSd7n2NBvNriZ9MpuyuzISx4H0h5mV25Ye
	88N7usBGTukLOQGo/Hi5c7Q=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gr1r42CTxz12LCv;
	Wed,  1 Jul 2026 22:00:36 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id 59F894057F;
	Wed,  1 Jul 2026 22:09:19 +0800 (CST)
Received: from [10.136.112.147] (10.136.112.147) by
 kwepemr100001.china.huawei.com (7.202.195.168) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 1 Jul 2026 22:09:18 +0800
Message-ID: <0ad60f06-387e-49bc-9e26-3dcebf182cb4@h-partners.com>
Date: Wed, 1 Jul 2026 22:09:00 +0800
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
Content-Language: en-US
From: xietangxin <xietangxin@h-partners.com>
In-Reply-To: <akKN4cywAsFRdefX@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100001.china.huawei.com (7.202.195.168)



On 6/29/2026 11:23 PM, Florian Westphal wrote:
> xietangxin <xietangxin@h-partners.com> wrote:
>> Problem observed in Kubernetes environments where MASQUERADE target with
>> --random-fully is configured by default. after commit
>> 165573e41f2f ("tcp: secure_seq: add back ports to TS offset") TCP short
>> connection QPS dropped from ~20000 to ~10000. This added source and
>> destination ports into TS offset calculation.
>>
>> However, with MASQUERADE --random-fully, when multiple internal connections
>> (e.g sport 10000,20000) are mapped to the same external port (e.g 30000),
>> their TS offsets are calculated as ts_offset(10000) and ts_offset(20000).
>> If the server reuses the TIME_WAIT slot from the first connection, there is
>> a chance that ts_offset(20000) < ts_offset(10000), breaking TSval
>> monotonicity for the same 4-tuple and causing RST packets:
>>   Client -> Server 24870 -> 80 [SYN] TSval=2294041168
>>   Server -> Client 80 -> 24870 [ACK] TSecr=2846236456
>>   Client -> Server 24870 -> 80 [RST] Seq=855605690
>>
>> After nf_nat_setup_info() successfully assigns a new randomized
>> source port, recalculate the TS offset using the new port and
>> update the SYN packet's TSval accordingly.
> 
> I don't think this is related to masquerade but to snat (port address
> rewrite) in general.
> 
> I think you could place your new helper in nf_nat_core.c and call it
> from nf_nat_l4proto_unique_tuple() once we've found a usable tuple:
> 
>  668 another_round:
>  669         for (i = 0; i < attempts; i++, off++) {
>  670                 *keyptr = htons(min + off % range_size);
>  671                 if (!nf_nat_used_tuple_harder(tuple, ct, attempts - i))
> 
> 	 		     ... here.
>  672                         return;
>  673         }
> 
Hi Florian,

Thank you for the insightful feedback. You are absolutely right that
this issue is releated to SNAT with port rewrite, rather masquerade.

Shifting the helper down to nf_nat_l4proto_unique_tuple() as you suggested
encounters a structural roadblock. we don't have access to the skb there.
Adding skb to all intermediate callers (like nf_nat_setup_info, get_unique_tuple)
would severely pollute the core NAT APIs.

would it be acceptable to place this logic in nf_nat_inet_fn() before do_nat?

 963 do_nat:
             ..here
 964         return nf_nat_packet(ct, ctinfo, state->hook, skb);
 965
 966 oif_changed:
 967         nf_ct_kill_acct(ct, ctinfo, skb);
 968         return NF_DROP;
 969 }

Best regards,
Tangxin Xie

