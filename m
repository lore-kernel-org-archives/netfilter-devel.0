Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4387F51E43A
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 18:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793220; cv=none; b=k5wysDU4w05qWswFciLKsK+6d+rRg8W021l4xJ8mMDmw12ME+vR9Oh1ia1LWW+cWx0lp+n4gLPT5TKshcYJdemL98adgAPD6heqII9/Dwb8VRu2TD/BUQb+blwLCBA6iDV80F67TCOVIgz8fPNPIEMm9zhOYnHpa0lGKQx7DxA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793220; c=relaxed/simple;
	bh=HJjm6WyLXNvzc2hRoMl6epzzzASDL7FyzUjgi9OaLmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K785LENTJX7KMJI3bmpfr67oTAC48DsKzt/PnrPI6wawKi3AKxgiVdGKQPwvACWOowHyf3F8HBHh/Wdff2RmzQr2x9MR3JqATXSbBEALvSrJQSDVD23yJ8T6E4YMZrcqFSeqBWY7/ALIyd842FN2bmBMsV6+AZSV/woesMUrQy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrfwqPwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrfwqPwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8C21F00898;
	Wed, 30 Sep 2026 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793219;
	bh=kPUUw9cp29gO1W/QzwDho0BggZ2KfrOo/xXGmXuy2bs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LrfwqPwgzPSWNIVKamDOxYoAy7PjOYvcc1GZG72df9zXciqavnAyp32AWAaCXut60
	 pwUldmFM3rLcAJed8R36jyH539hpc6yqb3U1akXTplndNpwOIfUX09VXT0H14Vw2Bs
	 RenPKRX22YZ412a3WLgj8tGbMBns8Xpq3bAwG5S4mluOhCYzcqW2jtvu1hCQXH/lEl
	 c3teik9gAodPFWd5aAHtnoXsb4yLg311HThU226SQ/eLw41ALuhz64O0B8Y+uIAVrq
	 Yq+IqxzYN2HsZJNHIUOX6ql05/BhvhEfHtE3ulZzMfo1hMh1ZjolRDwekqt81c+lky
	 MAdTbgqYId21g==
Message-ID: <6365150c-09d0-4a2c-84e3-ffe6e292e317@kernel.org>
Date: Wed, 30 Sep 2026 20:33:36 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
Content-Language: fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
 <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
 <aruMPHNdZq7U9eV9@chamomile>
 <4da35a94-af13-47de-adef-35b5671100b7@kernel.org>
 <arupFwGHewREJJ74@chamomile>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <arupFwGHewREJJ74@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Pablo,

Thank you for your reply!

On 29/09/2026 14:03, Pablo Neira Ayuso wrote:
> On Tue, Sep 29, 2026 at 12:40:47PM +0200, Matthieu Baerts wrote:
>> On 29/09/2026 12:00, Pablo Neira Ayuso wrote:
>>> On Tue, Sep 29, 2026 at 11:21:15AM +0200, Matthieu Baerts wrote:
>>>> Hi Pablo,
>>>>
>>>> Thank you for your reply!
>>>>
>>>> On 28/09/2026 23:52, Pablo Neira Ayuso wrote:
>>>>> Hi Mattieu,
>>>>>
>>>>> On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
>>>>>> Hello Netfilter devs,
>>>>>>
>>>>>> First, thank you for maintaining Netfilter in the kernel and the
>>>>>> userspace tools.
>>>>>>
>>>>>> The MPTCP selftests are switching from IPTables to NFTables, and
>>>>>> Clashiko reported that this part of a rule wouldn't match anything:
>>>>>>
>>>>>>   tcp option mptcp subtype remove-addr drop
>>>>>>
>>>>>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>>>>>> added to the TCP options, it is added after an MPTCP DSS option (type
>>>>>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>>>>>> (type 30) options in the TCP options. It looks like Netfilter doesn't
>>>>>> handle that, because it stops processing other TCP options when the
>>>>>> expected type is found:
>>>>>>
>>>>>> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>>>>>>     ...
>>>>>> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
>>>>>> 		optl = optlen(opt, i);
>>>>>>
>>>>>> 		if (priv->type != opt[i])
>>>>>> 			continue;
>>>>>> 		...
>>>>>> 		return;  // <== it will look at the first MPTCP option
>>>>>> 	}
>>>>>>     ...
>>>>>> }
>>>>>>
>>>>>> It looks like it shouldn't stop if the wrong subtype is found, but the
>>>>>> subtype is not compared there if I'm not mistaken. Should there be a fix
>>>>>> to support this case?
>>>>>
>>>>> Would it work for you if you can specify what TCP option you want to
>>>>> match? ie.
>>>>>  
>>>>>     tcp option[2] mptcp subtype remove-addr drop
>>>>>                ^
>>>>>                |
>>>>>                |
>>>>>        allow to specify a match at a given tcp option
>>>>
>>>> In my specific use-case, yes it would work. Some MPTCP sub-options will
>>>> always be after another one... when the Linux stack is used.
>>>
>>> This would require a smaller patch.
>>
>> I understand. But I guess that still means adding a new option.
>>
>> In my case, it would work, but this might be confusing for people who
>> want to use this filter: they need to know if a suboption can be used
>> with another one. I guess they could have multiple rules to check the
>> presence of a suboption in the first matched type, and in a second one,
>> but that seems confusing. Or maybe not?
> 
> You mean, the might want to validate the entire list of suboptions in
> a particular order, correct? ie. first suboption A then suboption B.

Yes, that's one possibility. But initially, I was thinking about having
two rules (or a set?) to match "the MPTCP subtype is either in the first
MPTCP option, or the second one (if any)". (Or nft could always say with
MPTCP by default, check also for a second MPTCP option, if any)

>>>>> Or would this be too strict for your use-case and you would prefer
>>>>> that you can match it anywhere?
>>>>
>>>> I think it would make more sense to match it anywhere. For example, an
>>>> MP_RESET can be used alone, or after an MP_FASTCLOSE. Plus some stacks
>>>> could reorder the options as there is no imposed order.
>>>
>>> I think this would require a MPTCP subtype parser, ie. make kernel
>>> aware of MPTCP subtypes.
>>
>> In nft_exthdr_tcp_eval(), why can the comparison not be done there
>> instead of copying the data in a register, and compare later on? If the
>> comparison is done directly for a given type and is different, the code
>> could continue and check for the same type. (Or store in multiple
>> registers.)
> 
> In nftables, the fetch then cmp instructions are splitted, ie. you
> first retrieve then you compare (or make a set lookup with it).
> Builtin comparison should be possible, but it defeats the integration
> with the set infrastructure.

OK, I see.

If someone gives ...

  tcp option mptcp subtype { mp-capable, mp-join, remove-addr } drop

... a bitmap could be used, but then that's specific to MPTCP I suppose.

>> I don't know if you need something specific to MPTCP, maybe just a way
>> to check all options with the same type.
> 
> Going back to this:
> 
> "When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> added to the TCP options, it is added after an MPTCP DSS option (type
> 0x30, len >= 8, subtype 0x2)"
> 
> Would you like to check for this particular sequence, right? Then

In my case, no particularly -- I just want to count/drop REMOVE_ADDR to
catch kernel regressions in the selftests -- but I can.

> position-based solution would work, because this would allow to match
> strictly:
> 
> pos = 0, suboption DSS
> pos = 1, suboption REMOVE_ADDR
> 
> This ruleset might break the protocol if there is ever a suboption
> before DSS.

Indeed. Technically, with MPTCP, we could send the REMOVE_ADDR alone
(without DSS), or before the DSS, or with another one in between if
there is room.

> Loose mode is more protocol designer friendly as it does not constrain
> future updates in the protocol:
> 
> "please find MP-TCP suboption REMOVE_ADDR for me"
> 
> but security folks might probably say this is ... loose, because it
> does not validate DSS before and REMOVE_ADDR might come anywhere.
> Protocol designer would say that this is good for them because this
> firewall does not constrain future enhancements of the protocol (still
> raw expressions are possible, then this last statement does not hold
> anymore).
> 
> Which one would you pick? :-)

I would first prefer if people don't drop packets with MPTCP options :-D

Honestly, I'm not sure what people would be interested in doing in
production, but I guess it would be more: "please match packet with
MPTCP suboption X, no matter the order". If people are interested in a
specific packet where MPTCP suboptions are in a specific order, with a
specific length, I *think* they can use a raw payload expression
instead, no?

In my case, I just wanted to drop packets with a specific MPTCP
suboption. It happens that I know exactly which packet I want to block,
and I can use a raw payload expression, but a simpler rule would be
welcome :)

>>> I would support both of them eventually? Starting by the one above
>>> that allows to match at a given position which looks simpler to
>>> support to me. Then, look into adding a MPTCP subtype parser later?
>>
>> If the second one can be implemented in a simple way, perhaps the first
>> one is not needed? If not, yes, good idea to start with the first one,
>> which might be enough for most people.
> 
> Both solutions are feasible IMO, the second needs a bit more work,
> that's all.

Understood!

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

