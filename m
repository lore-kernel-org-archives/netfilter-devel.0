Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169152DF68
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770223461; cv=none; b=axjl7eneZQpXDdzYmdGppxjE9AxPPCjFrWT5RrnUlN++ePuvLlQ4bSraFXUd/lOKPA67FkAj3R7B9SrCq1NVYDH2vcmxToy+I+qq1rhMoBkeJK+HIGYRZMVLygtLgyZkwngKTrj1GYeT81VFlnaa+F3iP2AfFJeb1ZQnkwMhw4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770223461; c=relaxed/simple;
	bh=yB9x89H7QGDmYVEbCgjL7NsKMTQGOc6ZZtnABHXTuWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XoC6tOvwfCoyV58cUf2d2H7uERWjDwCTg5w9v2FiDtWNNOIku1PLbFC0Mmcm7/Th3W7YjTOwLXo9qMiyDmMTBOdrXdgqwSjfdfImxK6/GOyK+yajKVYxk0qQgzD3icVPMaLvTwanuMkBZQLr48uoH4Q2Ba0nF4J8pLhrhpt7xkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pEEmNKjB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/v7RbT8I; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pEEmNKjB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/v7RbT8I; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pEEmNKjB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/v7RbT8I";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pEEmNKjB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/v7RbT8I"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 23B5B5BD6A;
	Wed,  4 Feb 2026 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770223459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4waHGUexDjzD3eP87pbo42oJm2FEttbJN4+LCr9CZug=;
	b=pEEmNKjB5GQqyuP10tb1U83JGlSVqgxZPc363FONtpPz9JWxM7D84LL7jyo6byGUjxG7p1
	PWgtXL/4bgqR4dJu46MejeJZ1XKjklZGDdD6r9W68/wEjfS9+xngaI2IFD4kI4zNVXZDIv
	JiyPnmTP4LgxOzXeU4FVGtBTSgsamGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770223459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4waHGUexDjzD3eP87pbo42oJm2FEttbJN4+LCr9CZug=;
	b=/v7RbT8IhdZEaqFW+ibxtrsuCSslC6sY32yINCZSu28z1g8b/ad9rCWPKuH4XK8jd5pGwc
	5jT0z7IzI4/enqCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770223459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4waHGUexDjzD3eP87pbo42oJm2FEttbJN4+LCr9CZug=;
	b=pEEmNKjB5GQqyuP10tb1U83JGlSVqgxZPc363FONtpPz9JWxM7D84LL7jyo6byGUjxG7p1
	PWgtXL/4bgqR4dJu46MejeJZ1XKjklZGDdD6r9W68/wEjfS9+xngaI2IFD4kI4zNVXZDIv
	JiyPnmTP4LgxOzXeU4FVGtBTSgsamGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770223459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4waHGUexDjzD3eP87pbo42oJm2FEttbJN4+LCr9CZug=;
	b=/v7RbT8IhdZEaqFW+ibxtrsuCSslC6sY32yINCZSu28z1g8b/ad9rCWPKuH4XK8jd5pGwc
	5jT0z7IzI4/enqCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C32513EA63;
	Wed,  4 Feb 2026 16:44:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d0HjLGJ3g2k7SgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Feb 2026 16:44:18 +0000
Message-ID: <22a1eed1-0e9b-42ed-b5bb-2947d90c0ada@suse.de>
Date: Wed, 4 Feb 2026 17:44:14 +0100
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
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aYNurHgLqfnX07NB@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.11)[-0.574];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On 2/4/26 5:07 PM, Phil Sutter wrote:
> Hi Fernando,
> 
> On Wed, Feb 04, 2026 at 04:23:58PM +0100, Fernando Fernandez Mancera wrote:
>> Historically, users have requested support for increasing and decreasing
>> TTL value in nftables in order to migrate from iptables.
>>
>> Following the nftables spirit of flexible and multipurpose expressions,
>> this patch introduces "nft_math" expression. This expression allows to
>> increase and decrease u32, u16 and u8 values stored in the nftables
>> registers.
>>
>> The math expression intends to be flexible enough in case it needs to be
>> extended in the future, e.g implement bitfields operations. For this
>> reason, the length of the data is indicated in bits instead of bytes.
>>
>> When loading a u8 or u16 payload into a register we don't know if the
>> value is stored at least significant byte or most significant byte. In
>> order to handle such cases, introduce a bitmask indicating what is the
>> target bit and also use it to handle limits to prevent overflow.
> 
> This part puzzles me. IMO byteorder conversion is needed for arithmetic
> on multi-byte values in non-host byte order.
> 
> Since nftables only knows host byte order and network byte order, the
> only case to consider is Little Endian host with NBO data. Registers are
> filled "from left to right", so (u16)0x1337 and (u32)0xfeedbabe look
> like this when stored in Network Byte Order in registers:
> 
> { 0x13, 0x37, 0x00, 0x00 }
> { 0xfe, 0xed, 0xba, 0xbe }
> 
> Interpreting those buffers as u16/u32 on Little Endian results in values
> 0x3713 and 0xbebaedfe. Any increment/decrement on those values leads to
> wrong results.
> 
> Maybe there's a hidden secret in 'bit_unit', but even if you calculate
> the right value to add/subtract from the right byte (0x100 and 0x1000000
> in our examples), a possible carry-over bumps the wrong byte.
> 

Hi!

This is correct. In the initial implementation [1] I included a 
NFTA_MATH_BYTEORDER attribute but after discussing with Florian we 
decided to drop it. Of course, in order to make this work correctly, nft 
byteorder expression must be used to perform the conversion when needed.

I believe that nft command line tool can figure out when a byteorder 
conversion is needed as I noticed this is already done for other 
expressions.

My initial idea was to keep the bytecode as smaller as possible but it 
is true that it makes sense to use the existing byteorder operations.

Does this make sense or am I missing something?

Thanks for the feedback!

[1] 
https://lore.kernel.org/netfilter-devel/20250923152452.3618-1-fmancera@suse.de/

> Assuming that I didn't entirely miss the point you might want to have a
> look at recent libnftnl/nftables commits informing libnftnl of payload
> byteorder for host byteorder independent debug output (with correct
> values). Particularly interesting are nftnl_*_set_imm() functions. Maybe
> this allows you to annotate math expression with data byteorder so it
> may perform byteorder conversion as needed.
> 
> Cheers, Phil
> 

