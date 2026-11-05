Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793877917;
	b=5n0hKfW0E89L5p/06tboDuUyfuEXdOxWcIDZlNJIkSEYpgcdhj/AR0yNZ8TtziR7Uy/W
	 /psp1s+AqwffzGEVGGprSOALZ0Nt6Z4XT0r4XL6drFdwA+i7YYcRVMzFdHfojer99tiW7
	 wxpjcGT/7QjaoPxDAe2gYglibN5GOmr6RN1mXYpZJYsAO3501L7T3xfdM5B/JRfWofPqY
	 JxoobolN19O7PDpETI+p10nFRpCVIZ4MmXvlDUUv2RLL3Fxph54x5XpH6Rvkda+f5tkfQ
	 hvzu94RChFS8vWUIVRqtXP1oVZyNFAqHZ60H3JKTznbPuh/jJyWeYYw6MB2vlAZ9ebw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793877917;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=btVhKYQnOIs/zkFjqGHHA5LcvChg1GChxUCzmFFZvII=;
	b=gR57W7Vap9MRiHqGHgnIxT5ak6kKACzBseap7urH3dN21dqgSW5oPbPweHXfuTMobdPr
	 Xy7/tFS2U3Mm4uQYz4tRye3ZGWVZONxtb8P2KFU+MH2J12CPkimv0FSoNCBj93iUdOwyj
	 ypTXsIWfJ6nJuva/21up0Bhh4+U6DHCbCLHmUsrD0wZ5568JMzVdB6Z+sxTtkEOfCpR2b
	 Ib04cav7BWUk9Bbyk95YRsDc122+o6PufzT9hWJR1x2MGHJLcmNAqsHp80gDpgOVMnmPe
	 S0GBb78zlc9ttA3Q6RR3lWT0Ci8wjKiFo8dukJ9C/uKKn8tmItwcDtsIoblbI6Z0yVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g1jV+lbz;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF96606A329
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 11:25:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBF96606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g1jV+lbz
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so14422025e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 03:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793877915; x=1794482715; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=btVhKYQnOIs/zkFjqGHHA5LcvChg1GChxUCzmFFZvII=;
        b=g1jV+lbzljXSmj6DClhX3ctbuF9t3LiZficuI4GouJbTcMeh7VrecvpVfnUmg059Cz
         PlIkjNzZKMA9FFswLLD69XoNMLy5CdptfvK4hqFT1Nvsa3coX2a4AyAe5+lSyRSgPBEp
         htfZjF75Iq2bx01ntT3ZJQFWHP1B7c/dRF9agJcfpAfcmpR/jpV33XNBzi6No069qFp2
         B4HbfkAIWWoEIIE/T/Q/xbH8J/JNXkqVAzoYZHx78aa2akyl0NQp07LrFzKenKQG60JM
         rPJZDcKISQLQtaJ54WAk84pPZmwiJpM50FcDwAjI2Un16yBozA1OtpzxMLj1hvAO0lxU
         ScPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793877915; x=1794482715;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=btVhKYQnOIs/zkFjqGHHA5LcvChg1GChxUCzmFFZvII=;
        b=NO6oFXb787BERcQZk3gYGhDjEbdcOxGK9NzuLGPGPcux2RdjHLeepj9/V7R+iyFDgu
         VvgpgR1PZJVo4ksU3PwVJrOnbA3MYmu/Hj8ZE3AxTkcc9IiUTzFLkrjtWFbSSd4SDS7l
         oRRHaNm52sfqW5PifvXCagKgbPwlfQ/WkUx1syXleMmL3odZYnef4Xt+3QbhNys6XnUF
         HPsNQngnzOiljchOJY3rwukhBsuOo5XDXkoyYYUxX7C4dYdaUEhLS6m/fWfkFgwinatx
         FCDSDgJInl9r141qD33v+bnnA+4JtWeX8Zd8wrU6MBK8LHfcpUd0X02ESIFfZLmBWpvF
         nMTA==
X-Forwarded-Encrypted: i=1; AKwUvBwKXypOMnUozLiQPn8CI+/3pZ+K3zTPd5CpWcRa8j3lN9cXaeRX4kyM/IzKTEtv36Ds9ZAKwA2HIxWxKqnidOU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/YAE9pcM5Xeqwk9I1gTOOClciuYzcb54I5cpQ0pQpSiWFqmNV9
	6Kl0Ew+OTQDXtFYnewR4xm3w50mko87+rFmlvb+Cun2UOGfN/hA1MS7J
X-Gm-Gg: AYBFou1gcwQ1GnTbw+wDMHUBhtWz/UgQsZGlgRLDHwe0PQCZOPv+SHkDM4Gz1gXLfBM
	oqBoseqGAMH4/z5zjLnQli5+mmhlKMHQ5/7qp0p22casWoOdc6gR7w+0fTxRX5I5mvmDS0ismmy
	Hq851fxdrcnpXjK9ICk/NAFOfYZ4LKeRz+6NIWs2EXf+NmTpO1+Eum1YVnMN7+Ke2A5XIl7QJIt
	MypkIzhCP/DcKiOFVx8u84ynrWd9G/0281DSWZpq0GBUZb2LSK4NHW+cGFL6zMSxfw3Bf5eyCu7
	f0TZi+MajDVmHQU+dFZ7UykvBr58z3ie7N6go3DZk40UuNfqLB2kEBNTJ0z2AyQDHS1skMwY9ou
	kw+ttl9gsabG8Feeodkc1BzHZqVYvi3gqbkUP6cwgi1A/phEaDeQQyrRuwmYiGZoOFnQvv/uAlO
	m4+tg4kqHs+CXlyHjsQoSb903Zt9bqOPyjDdP++e6BHDnY/qwGvbNTgotPzeZT1HLZbl8MiklGA
	20oGJaNpOYPmruhoM4l6+35nhV4iDAaTy5RszE+iJOyrCI3BGiTtEn9XdGxbFMXZZUecJ9Wzspn
	xSeFlMJhdPmshr54MNB7ze64arAT2OJ59nMIyARf+BvTStBrklveJWt4cD3r5ZfVaMmjOWtihRP
	DEMU=
X-Received: by 2002:a05:600c:e547:10b0:4ad:5e09:ae43 with SMTP id 5b1f17b1804b1-4ad5e09ae61mr214496175e9.29.1793877915077;
        Thu, 05 Nov 2026 03:25:15 -0800 (PST)
Received: from ?IPV6:2a12:26c0:4402:6300:b609:bb68:87a3:baf6? ([2a12:26c0:4402:6300:b609:bb68:87a3:baf6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda1f100sm9637529f8f.46.2026.11.05.03.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 03:25:14 -0800 (PST)
Message-ID: <33ae075d-1178-477f-b57d-927b1dffae0d@gmail.com>
Date: Thu, 5 Nov 2026 11:25:13 +0000
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: flowtable: do not clear the offload bit
 twice
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Sven Auhagen <sven.auhagen@voleatech.de>,
 Oz Shlomo <ozsh@nvidia.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>
 <aunoySCHzqwI1QIz@chamomile> <f909ccfb-0bad-4ad2-a5d7-d836f4bbc958@gmail.com>
 <ausaF4X_RieUIjxg@chamomile>
Content-Language: en-US, pt-PT
From: =?UTF-8?Q?Jo=C3=A3o_Silva?= <jgc3silva@gmail.com>
In-Reply-To: <ausaF4X_RieUIjxg@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Sorry for the late reply. It is infact out-of-tree. Will resend against 
nf-next.

Thanks,

João Silva


On 04/11/26 11:42, Pablo Neira Ayuso wrote:
> On Tue, Nov 03, 2026 at 06:56:30PM +0000, João Silva wrote:
>> Hi,
>>
>> The fix was LLM generated but I wouldn't say it's just "for correctness".
>> For some context, this issue was hit while developing hardware-offloaded
>> flows for the RTL930x target in openwrt. There was a point in development
>> where this was causing flows to pile up and eventually exhaust the TCAM of
>> the PIE engine on the switch.
> Good, but that is not an out-tree driver?
>
> If so, this should follow nf-next.
>
> Thanks
>
>> Thanks for considering.
>>
>> João Silva
>>
>>
>> On 03/11/26 13:59, Pablo Neira Ayuso wrote:
>>> On Tue, Nov 03, 2026 at 09:52:56AM +0000, João Silva via B4 Relay wrote:
>>>> From: João Silva <jgc3silva@gmail.com>
>>>>
>>>> An expired hardware flow remains in the flowtable until its asynchronous
>>>> hardware deletion completes. Teardown clears IPS_OFFLOAD_BIT, so a packet
>>>> can create a replacement flow referencing the same conntrack entry while
>>>> the old flow is still waiting for deletion.
>>>>
>>>> The next GC pass calls flow_offload_teardown() on the expired old flow
>>>> again, clearing the replacement's offload bit. More packets can then
>>>> create additional flows for the same conntrack entry. A pending hardware
>>>> work item can also delay deletion and expose the same repeated teardown.
>>>>
>>>> Commit d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of
>>>> offload bit") closed this window for software flows by unlinking them in
>>>> the same GC pass and made the conntrack state fixup one-shot, but
>>>> hardware flows stay linked until NF_FLOW_HW_DEAD is set.
>>>>
>>>> Make clearing IPS_OFFLOAD_BIT part of the existing one-time teardown
>>>> transition, alongside the conntrack state fixup. Subsequent teardown calls
>>>> must not alter the offload state now owned by a replacement flow.
>>> Let's better target nf-next for this, this looks like LLM triggered
>>> for correctness.
>>>
>>> Thanks.
>>>
>>>> Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
>>>> Signed-off-by: João Silva <jgc3silva@gmail.com>
>>>> ---
>>>>    net/netfilter/nf_flow_table_core.c | 6 ++++--
>>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>>>> index 0d72dc8ae47a..709b55b74cc7 100644
>>>> --- a/net/netfilter/nf_flow_table_core.c
>>>> +++ b/net/netfilter/nf_flow_table_core.c
>>>> @@ -398,9 +398,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>>>>    void flow_offload_teardown(struct flow_offload *flow)
>>>>    {
>>>> +	if (test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
>>>> +		return;
>>>> +
>>>>    	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>>>> -	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
>>>> -		flow_offload_fixup_ct(flow);
>>>> +	flow_offload_fixup_ct(flow);
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(flow_offload_teardown);
>>>>
>>>> ---
>>>> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
>>>> change-id: 20261103-flowtable-offload-bit-f15bfd1d38ed
>>>>
>>>> Best regards,
>>>> -- 
>>>> João Silva <jgc3silva@gmail.com>
>>>>
>>>>

