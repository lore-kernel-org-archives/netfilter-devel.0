Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6FC3F7AAB
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 08:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791360196; cv=none; b=lnLqElLb6uXBmn+9ed4W1M4Sm3Q+PM4OYDtklQBV22MYHi4UoftSAJhmGWRSElOdZa5Fh2oOZ+0HtkG3vAdI22b3N5qUAWrOzwp0Vms1+m+WR2G191D134iYAqwIn7ueqynC3ShI+6PX48qYyD4nxjh6madEJeGKxsrB37eBhbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791360196; c=relaxed/simple;
	bh=jWApKTgptFdY1KQeqD93/QRCkr4X3E9F161X5R7eg/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MjA17P1sI17b/u0xf1a/aKHHBLT0xVNXsG+daxfVZprH5WOS2w5aQcaG3TfyZjdZbKWJubbxyO6EvRdLOjAEYtBQ7XMKqh+traeiFjzSO5HT/tv31BB/OMmmkk5OCqilzHxpYEx3Sw99uc80mEVt2CkAohUGPNmcIrU+AAa5hHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OGuqLYQm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F2qs+CdB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iVn3RsEv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B5FA78od; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OGuqLYQm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F2qs+CdB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iVn3RsEv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B5FA78od"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 816B51F7DF;
	Wed,  7 Oct 2026 08:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791360174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qENP9ENPVPa7Um4bYKL6cP8mnHA8GkG3MZL4iFVZ92c=;
	b=OGuqLYQmIvJ3XxjoFzibcN5BOIkjXzmmyEUleKaATSB9jZWJc4/oxBdCViHAgNQq+pHWXh
	9iTS+vifz/5TofNsS4+zKxRsV0g2DS5524OGaSXlaYUWgdqk7z1q1juBOeCQ4LRO0B+5wZ
	Y7SxYPo8/LRoVKmmTTWr5YNwxk8HpeA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791360174;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qENP9ENPVPa7Um4bYKL6cP8mnHA8GkG3MZL4iFVZ92c=;
	b=F2qs+CdBqGSVolDq3Qpsk1eVMxrMCXoOU0zsXpn0OsJrYLv3OG47s947LeOJ5pxsEzsRUM
	8jBbefFNACN7amCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791360170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qENP9ENPVPa7Um4bYKL6cP8mnHA8GkG3MZL4iFVZ92c=;
	b=iVn3RsEv9/ayXVSczBpdneDynrTtqs2Su7afSSm/iH6617VOkehhobC7FcXcCs83cqIOq4
	MS2vMFoR9z2Cx5S97xZXFA00/7qLw1HFLCpCLdIPaq5LzNl9R3krI/HlRmjKCUUTQ+4F+x
	uzgleFOeei/hA/fbg0OPUP5344ztfGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791360170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qENP9ENPVPa7Um4bYKL6cP8mnHA8GkG3MZL4iFVZ92c=;
	b=B5FA78odmet4nqUpB+XJMjlBUPSJqJUMZlsZOuDsXzDpvOG44FkSiJus/U17FuOj6AF8p6
	DCMDaK5F4ElMJ/Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E44E13312;
	Wed,  7 Oct 2026 08:02:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H/fdNqn8xWp/KAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 07 Oct 2026 08:02:50 +0000
Message-ID: <4b8e49eb-9a14-4dae-aed9-3bcf35308efc@suse.de>
Date: Wed, 7 Oct 2026 10:01:51 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
 <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
 <aruMPHNdZq7U9eV9@chamomile>
 <4da35a94-af13-47de-adef-35b5671100b7@kernel.org>
 <arupFwGHewREJJ74@chamomile>
 <6365150c-09d0-4a2c-84e3-ffe6e292e317@kernel.org>
 <asWEWpVJLk0so8zM@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <asWEWpVJLk0so8zM@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO



On 10/7/26 1:29 AM, Pablo Neira Ayuso wrote:
> Hi Matthieu,
> 
> On Wed, Sep 30, 2026 at 08:33:36PM +0200, Matthieu Baerts wrote:
>> Hi Pablo,
>>
>> Thank you for your reply!
>>
>> On 29/09/2026 14:03, Pablo Neira Ayuso wrote:
>>> On Tue, Sep 29, 2026 at 12:40:47PM +0200, Matthieu Baerts wrote:
>>>> On 29/09/2026 12:00, Pablo Neira Ayuso wrote:
>>>>> On Tue, Sep 29, 2026 at 11:21:15AM +0200, Matthieu Baerts wrote:
>>>>>> Hi Pablo,
>>>>>>
>>>>>> Thank you for your reply!
>>>>>>
>>>>>> On 28/09/2026 23:52, Pablo Neira Ayuso wrote:
>>>>>>> Hi Mattieu,
>>>>>>>
>>>>>>> On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
>>>>>>>> Hello Netfilter devs,
>>>>>>>>
>>>>>>>> First, thank you for maintaining Netfilter in the kernel and the
>>>>>>>> userspace tools.
>>>>>>>>
>>>>>>>> The MPTCP selftests are switching from IPTables to NFTables, and
>>>>>>>> Clashiko reported that this part of a rule wouldn't match anything:
>>>>>>>>
>>>>>>>>    tcp option mptcp subtype remove-addr drop
>>>>>>>>
>>>>>>>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>>>>>>>> added to the TCP options, it is added after an MPTCP DSS option (type
>>>>>>>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>>>>>>>> (type 30) options in the TCP options. It looks like Netfilter doesn't
>>>>>>>> handle that, because it stops processing other TCP options when the
>>>>>>>> expected type is found:
>>>>>>>>
>>>>>>>> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
>>>>>>>>      ...
>>>>>>>> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
>>>>>>>> 		optl = optlen(opt, i);
>>>>>>>>
>>>>>>>> 		if (priv->type != opt[i])
>>>>>>>> 			continue;
>>>>>>>> 		...
>>>>>>>> 		return;  // <== it will look at the first MPTCP option
>>>>>>>> 	}
>>>>>>>>      ...
>>>>>>>> }
>>>>>>>>
>>>>>>>> It looks like it shouldn't stop if the wrong subtype is found, but the
>>>>>>>> subtype is not compared there if I'm not mistaken. Should there be a fix
>>>>>>>> to support this case?
>>>>>>>
>>>>>>> Would it work for you if you can specify what TCP option you want to
>>>>>>> match? ie.
>>>>>>>   
>>>>>>>      tcp option[2] mptcp subtype remove-addr drop
>>>>>>>                 ^
>>>>>>>                 |
>>>>>>>                 |
>>>>>>>         allow to specify a match at a given tcp option
>>>>>>
>>>>>> In my specific use-case, yes it would work. Some MPTCP sub-options will
>>>>>> always be after another one... when the Linux stack is used.
>>>>>
>>>>> This would require a smaller patch.
>>>>
>>>> I understand. But I guess that still means adding a new option.
>>>>
>>>> In my case, it would work, but this might be confusing for people who
>>>> want to use this filter: they need to know if a suboption can be used
>>>> with another one. I guess they could have multiple rules to check the
>>>> presence of a suboption in the first matched type, and in a second one,
>>>> but that seems confusing. Or maybe not?
>>>
>>> You mean, the might want to validate the entire list of suboptions in
>>> a particular order, correct? ie. first suboption A then suboption B.
>>
>> Yes, that's one possibility. But initially, I was thinking about having
>> two rules (or a set?) to match "the MPTCP subtype is either in the first
>> MPTCP option, or the second one (if any)". (Or nft could always say with
>> MPTCP by default, check also for a second MPTCP option, if any)
>>
>>>>>>> Or would this be too strict for your use-case and you would prefer
>>>>>>> that you can match it anywhere?
>>>>>>
>>>>>> I think it would make more sense to match it anywhere. For example, an
>>>>>> MP_RESET can be used alone, or after an MP_FASTCLOSE. Plus some stacks
>>>>>> could reorder the options as there is no imposed order.
>>>>>
>>>>> I think this would require a MPTCP subtype parser, ie. make kernel
>>>>> aware of MPTCP subtypes.
>>>>
>>>> In nft_exthdr_tcp_eval(), why can the comparison not be done there
>>>> instead of copying the data in a register, and compare later on? If the
>>>> comparison is done directly for a given type and is different, the code
>>>> could continue and check for the same type. (Or store in multiple
>>>> registers.)
>>>
>>> In nftables, the fetch then cmp instructions are splitted, ie. you
>>> first retrieve then you compare (or make a set lookup with it).
>>> Builtin comparison should be possible, but it defeats the integration
>>> with the set infrastructure.
>>
>> OK, I see.
>>
>> If someone gives ...
>>
>>    tcp option mptcp subtype { mp-capable, mp-join, remove-addr } drop
>>
>> ... a bitmap could be used, but then that's specific to MPTCP I suppose.
> 
> I think this makes sense from user perspective.
> 
> The nft_exthdr expression needs iterate over the whole list of tcp
> options, then if type is 30, make a set lookup to check if the subtype
> value is in the set.
> 
> Something like:
> 
>   - loop
>   |  r1 <- exthdr     [ if no more tcp options, break loop ]
>   |  r2 <- lookup(r1) [ if found, break loop ]
> 
> but exthdr need to be taugh to resume from the last visited tcp
> option. A new loop expression would wrap these two exthdr and lookup
> expression (similar to nft_inner) and store the iteration context (ie.
> last visited tcp option to continue from there).
> 
> exthdr tcp option support needs advertise a new NFT_EXPR_LOOP flag, so
> it can be used with within this new nft_loop expression.
> 

Wouldn't this be too complex? I was thinking in something a bit more 
generic and simpler. E.g a new NFTA_EXTHDR_INNER_TYPE which will work 
with PRESENT flag.

That way one can match MPTCP options exactly the same way TCP options 
are matched. The implementation would look first for the TCP option 30 
and then check the subtype, if it matches return 1 otherwise continue.

This is chained with a CMP_EQ expression.

I have a working patch, let me polish the code and will send it as RFC 
today so we can discuss it. I like this idea because it could be 
extended to match similar situations in IPv6 headers or SCTP.

> Another question: Would you still like to validate that DSS comes
> before REMOVE_ADDR?
> 
>>>> I don't know if you need something specific to MPTCP, maybe just a way
>>>> to check all options with the same type.
>>>
>>> Going back to this:
>>>
>>> "When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>>> added to the TCP options, it is added after an MPTCP DSS option (type
>>> 0x30, len >= 8, subtype 0x2)"
>>>
>>> Would you like to check for this particular sequence, right? Then
>>
>> In my case, no particularly -- I just want to count/drop REMOVE_ADDR to
>> catch kernel regressions in the selftests -- but I can.
>>
>>> position-based solution would work, because this would allow to match
>>> strictly:
>>>
>>> pos = 0, suboption DSS
>>> pos = 1, suboption REMOVE_ADDR
>>>
>>> This ruleset might break the protocol if there is ever a suboption
>>> before DSS.
>>
>> Indeed. Technically, with MPTCP, we could send the REMOVE_ADDR alone
>> (without DSS), or before the DSS, or with another one in between if
>> there is room.
> 
> Position matching is too strict.
> 
> You can still make it with the raw expression, but I think the native
> matching representation should be more flexible too as you describe.
> 
>>> Loose mode is more protocol designer friendly as it does not constrain
>>> future updates in the protocol:
>>>
>>> "please find MP-TCP suboption REMOVE_ADDR for me"
>>>
>>> but security folks might probably say this is ... loose, because it
>>> does not validate DSS before and REMOVE_ADDR might come anywhere.
>>> Protocol designer would say that this is good for them because this
>>> firewall does not constrain future enhancements of the protocol (still
>>> raw expressions are possible, then this last statement does not hold
>>> anymore).
>>>
>>> Which one would you pick? :-)
>>
>> I would first prefer if people don't drop packets with MPTCP options :-D
>>
>> Honestly, I'm not sure what people would be interested in doing in
>> production, but I guess it would be more: "please match packet with
>> MPTCP suboption X, no matter the order".
> 
> Yes, as discussed, this is more protocol friendly too in terms of
> extensibility.
> 
>> If people are interested in a specific packet where MPTCP suboptions
>> are in a specific order, with a specific length, I *think* they can
>> use a raw payload expression instead, no?
>>
>> In my case, I just wanted to drop packets with a specific MPTCP
>> suboption. It happens that I know exactly which packet I want to block,
>> and I can use a raw payload expression, but a simpler rule would be
>> welcome :)
> 
> Makes sense.
> 
> This would need an extension in the kernel as Florian has anticipated.

