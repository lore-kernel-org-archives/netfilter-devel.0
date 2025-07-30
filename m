Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4DB2A1C9
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 00:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753835549; cv=none; b=DlBhftDbuVyPwsorpYNHylfAbmb5ykAs46qtP+DsMcQVn3ffBxY4wh0RAXQ19tFRqB4vY0RpO26ZUkAm2JvWFKLhFgJRkPBpNciOmFjXTYRaBUeUI2BhSbgqQE3DjYZC5cnLdB+Cyem/Gwu4K3NMTHoIh8I8dViZMqikj42cYxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753835549; c=relaxed/simple;
	bh=dH9jHSm2AEbgXq+8uubCnDxpIZwkzjSWHqwXLxpM3z0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=udWX6rQx/3BwAQQEg9ZytbOHqGAz0tuKSTIKRmJIpOZIs0H8tgP2FsUPUviKHMSVLD1RdEUfW8QLoPDKuVS24pR09lg+BSEG5LRQaS5SCkP4ETmO5K+TuJWXZHdh5MGZWuzJSQRoOCDLnnwtlqku5UN5AcMn1LT0BsF49o2cLD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Oziyw4Nn; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Oziyw4Nn"
Message-ID: <d680a7b0-4c92-4937-83a7-6044e17e9997@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753835535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zpBevtBp+vvDKaYxeeSbfJvyA9GkDU+7/833LnHEBvU=;
	b=Oziyw4Nn+5OA/Q81daHTxQnqOLpwBMWDS6HsQtLuFqqwgZ9xi2mVydkzVGioSi4f7IHXiN
	HLxHeXpNbzxNOXfX6qE0tYEkm3XGt+HWcoBY8MavI/elQXTvZjuTJhly3gPg0z1GxC2heQ
	uQu+QKkk2VcsotUS/7MuuubM0KLWXPw=
Date: Tue, 29 Jul 2025 17:32:07 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 4/4] selftests/bpf: add icmp_send_unreach
 kfunc tests
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: alexei.starovoitov@gmail.com, andrii@kernel.org, ast@kernel.org,
 bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
 fw@strlen.de, john.fastabend@gmail.com, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
 pablo@netfilter.org, lkp@intel.com
References: <202507270940.kXGmRbg5-lkp@intel.com>
 <20250728094345.46132-1-mahe.tardy@gmail.com>
 <20250728094345.46132-5-mahe.tardy@gmail.com>
 <382ff228-704c-4e0c-9df3-2eb178adcba8@linux.dev> <aIiP5l24ihrS2x-u@gmail.com>
 <996bb1dd-e72e-4515-a60f-c5f31b840459@linux.dev>
 <cdd57fe6-ed8c-4cc9-a1dc-8563160a71e4@linux.dev>
Content-Language: en-US
In-Reply-To: <cdd57fe6-ed8c-4cc9-a1dc-8563160a71e4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 7/29/25 5:01 PM, Martin KaFai Lau wrote:
> On 7/29/25 4:27 PM, Martin KaFai Lau wrote:
>> On 7/29/25 2:09 AM, Mahe Tardy wrote:
>>> On Mon, Jul 28, 2025 at 06:18:11PM -0700, Martin KaFai Lau wrote:
>>>> On 7/28/25 2:43 AM, Mahe Tardy wrote:
>>>>> +SEC("cgroup_skb/egress")
>>>>> +int egress(struct __sk_buff *skb)
>>>>> +{
>>>>> +    void *data = (void *)(long)skb->data;
>>>>> +    void *data_end = (void *)(long)skb->data_end;
>>>>> +    struct iphdr *iph;
>>>>> +    struct tcphdr *tcph;
>>>>> +
>>>>> +    iph = data;
>>>>> +    if ((void *)(iph + 1) > data_end || iph->version != 4 ||
>>>>> +        iph->protocol != IPPROTO_TCP || iph->daddr != bpf_htonl(SERVER_IP))
>>>>> +        return SK_PASS;
>>>>> +
>>>>> +    tcph = (void *)iph + iph->ihl * 4;
>>>>> +    if ((void *)(tcph + 1) > data_end ||
>>>>> +        tcph->dest != bpf_htons(SERVER_PORT))
>>>>> +        return SK_PASS;
>>>>> +
>>>>> +    kfunc_ret = bpf_icmp_send_unreach(skb, unreach_code);
>>>>> +
>>>>> +    /* returns SK_PASS to execute the test case quicker */
>>>>
>>>> Do you know why the user space is slower if 0 (SK_DROP) is used?
>>>
>>> I tried to write my understanding of this in the commit description:
>>>
>>> "Note that the BPF program returns SK_PASS to let the connection being
>>> established to finish the test cases quicker. Otherwise, you have to
>>> wait for the TCP three-way handshake to timeout in the kernel and
>>> retrieve the errno translated from the unreach code set by the ICMP
>>> control message."
>>
>> This feels like a bit hacky to let the 3WHS finished while the objective of 
>> the patch set is to drop it. It is not unusual for people to directly borrow 
>> this code. Does non blocking connect() help?
>>
> 
> After reading more on how sk_err_soft is used, non blocking won't help. I think 
> I see why tcp rst is better.
> 

Actually, while replying on the cover letter and looking at tcp_v4_err again, 
there is an exception to do ip_icmp_error for TCP_SYN_SENT, so it may worth a 
try on non blocking connect and then poll the sk for err if you haven't tried 
that before.
