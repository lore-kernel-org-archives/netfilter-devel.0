Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3F8393DC8;
	Thu,  9 Jul 2026 03:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783568280; cv=none; b=WdsyiNpc31QaBbrGi+PZp2d1o8SJg5B/HxF7f6b80U/h+kogcjiNjLOk9GfSTvNhosWXkI/C1dgc4JuJ0XFHO/ziIEYo0hKUrQkuPZ61Ks3+8jGT09Tmi4SQ3EzPMrh7/aYIb/e6s46wswwRwR1hjT43SpqnXAlUw2Z6llhs4Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783568280; c=relaxed/simple;
	bh=eunZhR6efw09yHGWlxpUw7s7IHYXvw3HFUp4g/Sqfs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uj2EqetNrmJ8eIvR6v3JNA8fWOet2s5PoHZtvrUprDSYZslw+dL5cE5Z5JJw4ooIr1IkP6oVCxYafEy6xj6mwTs0TTi+SadEU5jkidLQlWq+j9/+UJnOS1PzmrNNfzzKBdUrwsEW1VgELhEIJf7xjCPkBzW7hIe8//2JN7jJqCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=P0QpaQ35; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="P0QpaQ35"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3usAFxvBnQSrtlEyPuj8Dfm5zlE7XgPSwefjV7zsIHk=;
	b=P0QpaQ35sARZ3tjtHh2+/C0+cZwFEP9O++LrQqS1Nvbi9nMy1XmkemJnC0ckQq4rPbU9BHqOV
	XNi3BJ05OTYdVS7mw3Q+yBCzBWLSSfMFoPuV4ltvpcBKw91KHT9uJC9ZJljV5IutgJjmHpfr/Lp
	Mc/xEYsBUMKLHB0fDzMRXuI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gwgRD3n0Vz1K9Ck;
	Thu,  9 Jul 2026 11:28:40 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id C2ED840578;
	Thu,  9 Jul 2026 11:37:53 +0800 (CST)
Received: from [10.136.112.147] (10.136.112.147) by
 kwepemr100001.china.huawei.com (7.202.195.168) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 9 Jul 2026 11:37:52 +0800
Message-ID: <e55d6327-78a9-41dc-9627-4414f408774b@h-partners.com>
Date: Thu, 9 Jul 2026 11:37:51 +0800
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
 <3620a5a9-9ced-4825-9bc4-6950be205749@h-partners.com>
 <ak5riPx5d3rSG6MG@strlen.de>
Content-Language: en-US
From: xietangxin <xietangxin@h-partners.com>
In-Reply-To: <ak5riPx5d3rSG6MG@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100001.china.huawei.com (7.202.195.168)



On 7/8/2026 11:23 PM, Florian Westphal wrote:
> xietangxin <xietangxin@h-partners.com> wrote:
>> Thanks for your guidance. I’ve successfully fix the helper location
>> as you suggested, and it works fine for local traffic.
>>
>> However, I realized that I had completely overlooked the forwarding scenario
>> (where SNAT acts as a middlebox gateway, e.g. Host A -> Gateway B -> Server C).
>> In this gateway scenario, when random-fully is enabled, the test results show
>> a massive performance degradation: the QPS drops from ~19000 down to ~10000.
> 
> I don't think the forwarding case is fixable.
> 
> Host S could be another NAT gateway, so it could be possible that
> the connections originate from different physical machines and
> timestamps differ due to different clocks, not per-connection
> randomisation.
> 
>> Since skb->sk is NULL on the forwarding gateway, my current approach of
>> updating tp->tsoffset in struct tcp_sock cannot be applied here.
> 
> Yes. I think the tp->tsoffset recalc is fine to handle local case.
> 
> For local case we do know that we're the end host and ts recalc is fine.
> 
>> To be honest, I am currently stuck on how to handle this forwarding scenario
>> within the netfilter architecture without adding redundant overhead to the fast path.
>>
>> Could you please give some advice on how the community would prefer to resolve this?
>> For instance, should we look into extending the Conntrack NAT extension to
>> track and adjust the TCP timestamps?
> 
> If we have some guarantee that internal network isn't doing any
> snat at all, then yes, one could implement some TS adjustment
> scheme similar to seqadj extension we already have to deal with
> tcp sequence number adjustments.
> 
> We'd have to keep state and subtract the offset to get back the
> right tsecr again on reverse direction.
> 
> I'm not keen to have something like this, it would breaks PAWS
> as soon as the originating host is itself a nat gateway.
> 
> Is this really a problem to begin with?
Hi Florian,

Thanks for your precise analysis. I completely agree with you that
the forwarding case is theoretically unfixable due to the multi-tier NAT risks.

This is a real and severe problem for us, but the actual issue we encountered
is in the local case, not the forwarding case:

1.Laboratory Test Case Failure:
We noticed a severe HTTP performance regression in our automated Kubernetes testing,
where wrk was used to benchmark Pod client http performance. Through git bisect,
we successfully pinned the commit 165573e41f2f ("tcp: secure_seq: add back ports to TS offset").
The trigger was the default MASQUERADE --random-fully rule configured by kube-proxy on the k8s node.

2.Downstream Production Impact (AI Inference Cluster on Kubernetes):
Shortly after, one of our major downstream product teams reported a massive performance degradation.
After they upgraded their kernel to a version containing commit 165573e41f2f,
they suffered a 40% AI inference performance drop. They confirmed that simply
removing the random-fully flag instantly restored the performance back to normal.

Would it be acceptable to a V2 patch that targets the local case?

-- 
Best regards,
Tangxin Xie

