Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477D342189A
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 11:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777978875; cv=none; b=S9SmH/8eCWpiFfmvnWsSrE5Dn5lTD+ISxFZG5S41+F/zqPIEGXX2XDcipl/dfyeEXVHqp6gM1vr1c/Err3k4qy8cLDJNuqNF0pKQe5JvYv8DqMBa9oDKdBZyGiGhu0s87+0VHjtCSOmBQfs4xgkcbB7nwyhlG+s/st1Wt8okytg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777978875; c=relaxed/simple;
	bh=yZHX2zu6pRXp/aiFpcnEVJYoWFJl2mSPRNnA8tmDQVs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=boLOCdXrv91S8BWTwRG/kLXABcNjl0WLE2VvBaKAN0ZQLezUKTMPyV/Iag/51rlqkPBcc1IuLBg730fYMbCcUwDfyCyjNQMM1/Z9IVFRJNHbSZq83QsaRbvUBUI8Ydkyl9dzCTDIs7+5gvRIjH22u7g61lXPvPVoPH8oO1Lw0H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-b9d9971d059so696070566b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 05 May 2026 04:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777978871; x=1778583671;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DArCLHy5i8lXdAo5MW+nZY6yAncYzCTVpd/mPRM7974=;
        b=AfqeSNUSBZ/fzow1skY8pFmc9x8eDtV2Qv8Qh5lu52AfeoljyFddm40O9Ha9b+K7VD
         ZTqAAMCdTl/699+FYnNbbSBNNFRtTAKBHfrr5DZwnyHeZaFHd9sEoTt2OzXzpVi8MfKM
         qxokTt8TMX9cvcSVImNyb6RXXII+a9Aocb5GKkofQt/GJrGlQ05yza0q+hmrW++ZfEup
         SPXBUcEUOeeM5LOlasCU96eOzWz1Z/bW8cocUWkmZnJYWW9HUDBxfuHHwyjw3ED/Uq9n
         o9ZoIChG+x5AUqO0bvYjLjuqjEITP2U1vF1oxGsmXf5vQCMQ0WoWzJfOvPc2z0lXDaj+
         T5vw==
X-Forwarded-Encrypted: i=1; AFNElJ8obQLCINqYfUvDGBch8KRaUM85s9Yqs+ONWqhD140aVQ3kb+imymfToVHT5H+qzbi4ozu8POLRwgQK2uBzotc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNhSKiR/SD2Qme1AuferqaXH+Y9aE1dwHLr0coixEOa9E9YfRC
	HTj2kyRf2U1t5jhmJcGG4n8dk0bkmtbrAxxSUfS2Ouo2KZpm0XmkhDnV
X-Gm-Gg: AeBDieuP5KiLAJpQgSJA8wALsbqdiiDm9R/j0fDB++p5vKPntQQmphNDSR01JTkh+JW
	z9GtaPzmFz0A9UhDdmGqmEz2xrgwYrMot78iOLPKYZ8kYz6RgfkMaRokB74hPGrYJynWSQxQ+GE
	7QTQo0+Eh1/WTbMG0wKhGVhbNfSyfHPDnZgzln9yVPlgSAt6c0KZrF+26nNq5c1XO6wgUerLSqP
	pckAXpARAjEz6SMGQn8/BCYDfxT8shiccfktKM0xe5p7HltH26Ncd4YXtZ3jiY9FJXBJNpUrHn3
	fvRBE4fhQssALqE6aSm0FwfTru5yJrP8ZJuA32TcP4XO9Lw/2Pv7M5WrhdJyTzexzEF2scIFiMN
	JKJTp3zzUM4JJJBGyI/zm5ty346FRi0zHkkodI6rKgT8yc1hItUcCtlWcD2vIO8KtX5hLKg16Kk
	qoN82sxxQiE6Fe6N8iQcjOsVstyKu8Xd4UuudxCsxhvgxQof2YUejYyj21wPEKRHChNw==
X-Received: by 2002:a17:906:9f87:b0:b9b:ddb2:b1c1 with SMTP id a640c23a62f3a-bbffcf7eb2amr739165066b.21.1777978870741;
        Tue, 05 May 2026 04:01:10 -0700 (PDT)
Received: from [192.168.88.241] (37-48-40-237.nat.epc.tmcz.cz. [37.48.40.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bc4b921a277sm14495866b.3.2026.05.05.04.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 04:01:10 -0700 (PDT)
Message-ID: <fdd012a9-9ab7-4da2-b9f2-0a8e6c254186@ovn.org>
Date: Tue, 5 May 2026 13:01:08 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: i.maximets@ovn.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, horms@kernel.org,
 Eelco Chaudron <echaudro@redhat.com>, Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net 06/12] netfilter: nf_conntrack_expect: honor
 expectation helper field
To: Pablo Neira Ayuso <pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <20260326125153.685915-7-pablo@netfilter.org>
 <8fd5d3a3-d1d7-4542-a0db-1678989940d4@ovn.org> <afSCXEg-X-ieL9cY@chamomile>
 <ef01005e-d867-4936-b138-b98f37e5f394@ovn.org> <afkosr2fDEPA_jX9@chamomile>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <afkosr2fDEPA_jX9@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/5/26 1:16 AM, Pablo Neira Ayuso wrote:
> Hi Ilya,
> 
> On Mon, May 04, 2026 at 02:19:20PM +0200, Ilya Maximets wrote:
>> On 5/1/26 12:37 PM, Pablo Neira Ayuso wrote:
>>> Hi Ilya,
>>>
>>> On Thu, Apr 30, 2026 at 10:58:38PM +0200, Ilya Maximets wrote:
>>>> On 3/26/26 1:51 PM, Pablo Neira Ayuso wrote:
>>>>> The expectation helper field is mostly unused. As a result, the
>>>>> netfilter codebase relies on accessing the helper through exp->master.
>>>>>
>>>>> Always set on the expectation helper field so it can be used to reach
>>>>> the helper.
>>>>>
>>>>> nf_ct_expect_init() is called from packet path where the skb owns
>>>>> the ct object, therefore accessing exp->master for the newly created
>>>>> expectation is safe. This saves a lot of updates in all callsites
>>>>> to pass the ct object as parameter to nf_ct_expect_init().
>>>>>
>>>>> This is a preparation patches for follow up fixes.
>>>>>
>>>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>>>> ---
>>>>
>>>> Hi, Pablo and Florian.
>>>>
>>>> I was investigating FTP test failures in OVS with 7.0 kernel and bisected
>>>> the issue down to this commit.  AFAIU, with this change all the related
>>>> connections over time gain their parents' helpers,.  This is causing a change
>>>> visible to the userspace, because FTP data connections are now reported to
>>>> have helpers in the conntrack dump:
>>>>
>>>> # conntrack -L
>>>> tcp      6 119 TIME_WAIT src=10.1.1.1 dst=10.1.1.2 sport=59534 dport=21 \
>>>>                          src=10.1.1.2 dst=10.1.1.1 sport=21    dport=59534 \
>>>>            [ASSURED] mark=0 helper=ftp use=2
>>>> tcp      6 119 TIME_WAIT src=10.1.1.2 dst=10.1.1.1 sport=52709 dport=52381 \
>>>>                          src=10.1.1.1 dst=10.1.1.2 sport=52381 dport=52709 \
>>>>            [ASSURED] mark=0 helper=ftp use=1
>>>>
>>>> Before this commit only the control connection had helper=ftp reported in
>>>> the dump.  The traffic seems to work fine, but our tests fail because we
>>>> do not expect the helper attached.
>>>>
>>>> AFAIU, it's generally not something that should be happening, as helpers
>>>> on data connections do not really make much sense.  But I'm just trying to
>>>> figure out if you would consider this as a regression and fix in the kernel
>>>> or if we should adjust our userspace components for this new dump content,
>>>> which would not be very straightforward to do if we want to be able to run
>>>> tests on both old and the new versions.
>>>>
>>>> What do you think?
>>>
>>> It seems previous behaviour to 9c42bc9db90a was inconsistent, ie. only
>>> the h323 helper sets on exp->helper, then it shows helper= in expected
>>> connections via ctnetlink. I guess this is for debugging given that
>>> h323 is actually a family of helpers.
>>>
>>> To consistently skip dumping this for expected connections, probably
>>> this is the way to do:
>>>
>>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conn
>>> index eda5fe4a75c8..9491ae9e080e 100644
>>> --- a/net/netfilter/nf_conntrack_netlink.c
>>> +++ b/net/netfilter/nf_conntrack_netlink.c
>>> @@ -226,7 +226,7 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *sk
>>>         const struct nf_conn_help *help = nfct_help(ct);
>>>         struct nf_conntrack_helper *helper;
>>>  
>>> -       if (!help)
>>> +       if (!help || ct->status & IPS_EXPECTED)
>>>                 return 0;
>>>  
>>>         rcu_read_lock();
>>
>> I'm not sure.  I tried this change and it fixed one case but broke another.
>> Looking at what we're testing, the old behavior (at least for FTP) was:
>> "if helper was committed - report it, if not - don't".  i.e. it's not really
>> about the connection being expected it's about if the user committed the
>> helper for the connection or not.
>>
>> Let me explain a few scenarios that we have in the OVS system tests and what
>> I see with the old kernel (6.19), the new (7.0) and the patch above.
>>
>> A) The first scenario has the following OpenFlow rules (simplified):
>>
>>   table=0,in_port=1,tcp,action=ct(alg=ftp,commit),2
>>   table=0,in_port=2,tcp,action=ct(table=1)
>>   table=1,in_port=2,tcp,ct_state=+trk+est,action=1
>>   table=1,in_port=2,tcp,ct_state=+trk+rel,action=1
>>
>> This set of rule blindly commits every packet coming from port 1 with the
>> helper and sends to port 2.  Packets from port 2 are passed through ct and
>> only related or established traffic is passed to port 1.  This is a very
>> rudimentary setup that users can make to allow ftp from port 1 towards port 2,
>> but not in the opposite direction.
>>
>> For this scenario regardless of the kernel version or the patch above I see
>> that both the data and the control connections have a helper reported in the
>> ctnetlink dump.
> 
> This ruleset then is attached the conntrack helper to data connection,
> that is, ALG is inspecting the FTP data connection but it will just
> find no patterns because it is only the FTP control connection that
> creates expectations?

Yes.  It's just a "lazy" way to make the traffic work, we do not expect
the helper on the data connection to do anything useful in this scenario.

Best regards, Ilya Maximets.
