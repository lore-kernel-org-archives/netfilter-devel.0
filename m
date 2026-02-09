Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE016374174
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Feb 2026 12:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770639281; cv=none; b=lyXLuSO+kcO6kg3EmMJ8FOzDG9eBokrnFpJvN+w/gpOTU2+HmWkuqNFb86uVek5l7/yPQFxz3MsdMqYtJDwB2Zbk9nUKq7z3yMiNQtrCNBt5drBQrzq8nUXgi8CsFWL+2usezhwM9y0ZgdrN6xBOXWwd8SVD9JyTb5gj+smuUZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770639281; c=relaxed/simple;
	bh=HDHLQsPKGDzu8nFEfIyybLOKvm1qkE/XnrJ2c7i7yIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=olb18bmcpAKYOJ1PmNAz92TEk/GFsaq/sWCc0Dpns0RCf7t8W3JofCMn6c0iCFGxxOQEI71iNKl7K2CmQB3ae0/ty5D8RA1RriwhYhyWeuLyi14Z1eGAnjzBfIuM29AofAUveZBpMB2397mNDcIAAzZEpQKk6vrX+egooqsGDaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YRG66iT+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iP80/HC1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YRG66iT+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iP80/HC1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YRG66iT+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iP80/HC1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YRG66iT+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iP80/HC1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0957D5BD1A;
	Mon,  9 Feb 2026 12:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770639279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1oc6nchHmaW1fypGnj95fEcUTb/sTAjlzw4MrMo8c=;
	b=YRG66iT+g+wA7kMMn4IexNj27DYpUv0ObCyxtu7MKtlGVkbo4iKHUzZ5CMrunOTRU+w9v0
	nPoFWi7Rf7N4W2kLaBAZrqJ3056SGsBsk4N9Cmw7SgJMMBIeQzTQqvvx0ofQzksk+cSmtx
	7BkXPC0NQqbp/jankSJmM3LXExw2lqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770639279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1oc6nchHmaW1fypGnj95fEcUTb/sTAjlzw4MrMo8c=;
	b=iP80/HC1lsbIEwoJR1RfU3ZgWcE4WX7/c9OKwpTMZSnYVmktNjiF8Uk0Sy6HGF3rHR+TAe
	PTkUQhfH49k97hCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YRG66iT+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="iP80/HC1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770639279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1oc6nchHmaW1fypGnj95fEcUTb/sTAjlzw4MrMo8c=;
	b=YRG66iT+g+wA7kMMn4IexNj27DYpUv0ObCyxtu7MKtlGVkbo4iKHUzZ5CMrunOTRU+w9v0
	nPoFWi7Rf7N4W2kLaBAZrqJ3056SGsBsk4N9Cmw7SgJMMBIeQzTQqvvx0ofQzksk+cSmtx
	7BkXPC0NQqbp/jankSJmM3LXExw2lqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770639279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EM1oc6nchHmaW1fypGnj95fEcUTb/sTAjlzw4MrMo8c=;
	b=iP80/HC1lsbIEwoJR1RfU3ZgWcE4WX7/c9OKwpTMZSnYVmktNjiF8Uk0Sy6HGF3rHR+TAe
	PTkUQhfH49k97hCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A36993EA63;
	Mon,  9 Feb 2026 12:14:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zc/sJK7PiWkLOgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 09 Feb 2026 12:14:38 +0000
Message-ID: <f46440da-6ac5-4048-8aa6-7c66ef341e75@suse.de>
Date: Mon, 9 Feb 2026 13:14:38 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v3] netfilter: nf_tables: add math expression
 support
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, fw@strlen.de, pablo@netfilter.org
References: <20260204152358.11396-1-fmancera@suse.de>
 <aYNurHgLqfnX07NB@orbyte.nwl.cc>
 <22a1eed1-0e9b-42ed-b5bb-2947d90c0ada@suse.de>
 <aYOAgsSVPdisk19Y@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aYOAgsSVPdisk19Y@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0957D5BD1A
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 2/4/26 6:23 PM, Phil Sutter wrote:
> On Wed, Feb 04, 2026 at 05:44:14PM +0100, Fernando Fernandez Mancera wrote:
>> On 2/4/26 5:07 PM, Phil Sutter wrote:
>>> Hi Fernando,
>>>
>>> On Wed, Feb 04, 2026 at 04:23:58PM +0100, Fernando Fernandez Mancera wrote:
>>>> Historically, users have requested support for increasing and decreasing
>>>> TTL value in nftables in order to migrate from iptables.
>>>>
>>>> Following the nftables spirit of flexible and multipurpose expressions,
>>>> this patch introduces "nft_math" expression. This expression allows to
>>>> increase and decrease u32, u16 and u8 values stored in the nftables
>>>> registers.
>>>>
>>>> The math expression intends to be flexible enough in case it needs to be
>>>> extended in the future, e.g implement bitfields operations. For this
>>>> reason, the length of the data is indicated in bits instead of bytes.
>>>>
>>>> When loading a u8 or u16 payload into a register we don't know if the
>>>> value is stored at least significant byte or most significant byte. In
>>>> order to handle such cases, introduce a bitmask indicating what is the
>>>> target bit and also use it to handle limits to prevent overflow.
>>>
>>> This part puzzles me. IMO byteorder conversion is needed for arithmetic
>>> on multi-byte values in non-host byte order.
>>>
>>> Since nftables only knows host byte order and network byte order, the
>>> only case to consider is Little Endian host with NBO data. Registers are
>>> filled "from left to right", so (u16)0x1337 and (u32)0xfeedbabe look
>>> like this when stored in Network Byte Order in registers:
>>>
>>> { 0x13, 0x37, 0x00, 0x00 }
>>> { 0xfe, 0xed, 0xba, 0xbe }
>>>
>>> Interpreting those buffers as u16/u32 on Little Endian results in values
>>> 0x3713 and 0xbebaedfe. Any increment/decrement on those values leads to
>>> wrong results.
>>>
>>> Maybe there's a hidden secret in 'bit_unit', but even if you calculate
>>> the right value to add/subtract from the right byte (0x100 and 0x1000000
>>> in our examples), a possible carry-over bumps the wrong byte.
>>>
>>
>> Hi!
>>
>> This is correct. In the initial implementation [1] I included a
>> NFTA_MATH_BYTEORDER attribute but after discussing with Florian we
>> decided to drop it. Of course, in order to make this work correctly, nft
>> byteorder expression must be used to perform the conversion when needed.
>>
>> I believe that nft command line tool can figure out when a byteorder
>> conversion is needed as I noticed this is already done for other
>> expressions.
>>
>> My initial idea was to keep the bytecode as smaller as possible but it
>> is true that it makes sense to use the existing byteorder operations.
>>
>> Does this make sense or am I missing something?
> 
> Ah, got it! So nft_math simply assumes sreg and dreg are in host byte
> order and nftables is supposed to add nft_byteorder expressions as
> needed. That should do and is indeed easier than dealing with data
> byteorder within nft_math itself!
> 
> The only odd thing that remains is the combined use of mask and length.
> Typically one would either use length and offset or mask alone because
> the former two values may be extracted from the latter. Also, why does
> nft_math_init() restrict masks to align at start or end of register?
> 

Hm. I have been thinking about this. So the initial reason for this was 
to simplify everything so if u32 length is used we don't need to use a 
bitmask. But tbh, it doesn't make much sense.

I will get rid of the length attribute on the v4. Thank you Phil! :)

> Thanks, Phil
> 

