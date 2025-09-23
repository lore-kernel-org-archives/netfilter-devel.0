Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08A01D90C8
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 17:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649201; cv=none; b=Dyr/tTQDH68C8qKxd4ejmZh+NDuVDOCUJgWWqwPqVfyvbrRuNIgMwLQLZy19fezxvhygJ4BSUrcDMn/z8b0t9VN0JiiISqwU45T9ytcKP3SJC51IfD9t6ZOPM80/gAROOfciy9iv8c3UQ3ihvDXuevfIL/BK1mv8IuicsAIRfsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649201; c=relaxed/simple;
	bh=RhRzuX1nHetnUmyEoqK5A22Aa6DgI//uIVAPnozFj2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JVSFwUbaPnk96b+cq0s6eMQtc6UEFkvk9/pLPE9HXo8DaLlP2v6OrM6R9r4Oz72dkTG8PfNVGklvfy0+0A39oIpE/HPODpYa4BdSnwJOW13FixmMamjH9zDtmQe0g+bDracFjeL3vuh5HwDm5o0Wa2xhFQgXK/CIj18GMI3maug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ApHhBRID; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=p1pmVecE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ij+CKHfE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qWxPccNb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ApHhBRID";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="p1pmVecE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ij+CKHfE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qWxPccNb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2CD021F85;
	Tue, 23 Sep 2025 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758649198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BwS9kf+zH+sBYY1PdChAFysa/9PeG8T6v89oM/3E/w=;
	b=ApHhBRIDH0B5wbb1yQtho02jRREkxj+hocR3bDbujGRQkEZCMFKF1KOwST9H+G4q0Gp2iA
	sasNbTEeYzjEwtezqXWPAo0G0x5cdWhbrWQlK1+E4RKkUq0okjxUXmeUynmONvFAgkiSAo
	U69m7ZdneeONegWsip3Y/W/5P7zOVJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758649198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BwS9kf+zH+sBYY1PdChAFysa/9PeG8T6v89oM/3E/w=;
	b=p1pmVecEMKhT3gJ7q7x1UVntWl4ej7hAnrt1rveT3cziGFFZ0W2iOyDeGKoirlpzhfcbZS
	5cFlgbGy+UfjdZBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ij+CKHfE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qWxPccNb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758649197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BwS9kf+zH+sBYY1PdChAFysa/9PeG8T6v89oM/3E/w=;
	b=ij+CKHfE2vnLSqbnfMdp6VLWqrYGC6sVC+ISdSsyt5VkCHhAsCvU8IxGbzj2CJD91o6jYA
	3PlhjLtN44lp7wPKB8UrUr55usiFebIJKSeFlplWrJavfapEiN1AxrDDDU8gASbXmzZ0Nl
	3l66ORUoa9N9EuXinXLyoFRObKn/50Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758649197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BwS9kf+zH+sBYY1PdChAFysa/9PeG8T6v89oM/3E/w=;
	b=qWxPccNbktWFE3iLU0k+IhUUelqgL5XXOa/Nm6SeLvrV5qFrIGcLeBDlBjy4jsYYGc3YZp
	cVFxAuyMctLJnyAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F9391388C;
	Tue, 23 Sep 2025 17:39:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YCrsG23b0mgsBQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 23 Sep 2025 17:39:57 +0000
Message-ID: <19498e76-bd17-4e63-9144-8cff9874d3da@suse.de>
Date: Tue, 23 Sep 2025 19:39:50 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC nf-next] netfilter: nf_tables: add math expression
 support
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org
References: <20250923152452.3618-1-fmancera@suse.de>
 <aNLMF2CdcCKWi4cI@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aNLMF2CdcCKWi4cI@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: C2CD021F85
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51



On 9/23/25 6:34 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Historically, users have requested support for increasing and decreasing
>> TTL value in nftables in order to migrate from iptables.
> 
> Right.
> 
>> In addition, it takes into account the byteorder of the value
>> stored in the source register, so there is no need to do a byteorder
>> conversion before and after the math expression.
> 
> Why?  Any particular reason for this?
> 

It is for simplicity reasons. Just to avoid a big payload with byteorder 
conversions per math expression.

> I would have expected to have ntf insert the needed byteorder
> conversions.
> 
>> The math expression intends to be flexible enough in case it needs to be
>> extended in the future, e.g implement bitfields operations. For this
>> reason, the length of the data is indicated in bits instead of bytes.
> 
> Not so sure.  We already have nft_bitwise. Or what bitfield operations
> are you considering?
> 
> You mean 'add' to a non-byte part, like e.g. as in iph->ihl?
> 

Yes, I do not have a clear use-case for it right now, but I just wanted 
to keep it as flexible as possible.

>> Payload set operations sometimes need 16 bits for checksum
>> recalculation. Even it is a 8 bit operation, 16 bits are loaded in the
>> source register. Handle such cases applying a bitmask when operating
>> with 8 bits length.
>>
>> As a last detail, nft_math prevents overflow of the field. If the value
>> is already at its limit, do nothing.
> 
> Should it set NFT_BREAK?
> 

I don't think so. If the user wants to increase or decrease a field but 
it already reached the limit IMO it shouldn't do anything but continue 
with the next expression instead of setting NFT_BREAK. Anyway, not a 
deal breaker for me..

>> table mangle inet flags 0 use 1 handle 5
>> inet mangle output use 1 type filter hook output prio 0 policy accept packets 0 bytes 0 flags 1
>> inet mangle output 2
>>    [ payload load 2b @ network header + 8 => reg 1 ]
>>    [ math math 8 bits host reg 1 + 1 => 1]
>>    [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
> 
> Thanks for including these examples.
> You can drop the 'math' from the snprintf callback in libnftnl to avoid
> this 'math math'.
> 

Ugh, sorry I missed that detail.

> I assume this says 'host' because its limited to 8 bits?
> 

Yes, well it says "host" because I used NFT_MATH_BYTEORDER_HOST to 
generate it, anyway it doesn't matter as it is 8 bits. Would it be 
better to hide byteorder if it doesn't matter?

>> +	/* For payload set if checksum needs to be adjusted 16 bits are stored
>> +	 * in the source register instead of 8. Therefore, use a bitmask to
>> +	 * operate with the less significant byte. */
> 
> I don't think this works.  You don't know if the add should be done
> on the less significant byte order the MSB one.
> 
> (If you do... how?)
> 
> AFAICS you need to add support for a displacement
> offset inside the register to support this (or I should write:
> work-around-align-fetch-mangling ...)
> 

So I was aware of this. But after reading nft_payload.c expression I 
thought the desired value was always stored in the less significant 
byte. Anyway, this assumption was wrong and you are right.

What would be the best way to implement this? A pure bit offset 
(NFT_MATH_OFFSET) or a bitmask (NFT_MATH_BITMASK)?


>> +static int nft_math_init(const struct nft_ctx *ctx,
>> +			 const struct nft_expr *expr,
>> +			 const struct nlattr * const tb[])
>> +{
>> +	struct nft_math *priv = nft_expr_priv(expr);
>> +	int err;
>> +
>> +	if (tb[NFTA_MATH_SREG] == NULL ||
>> +	    tb[NFTA_MATH_DREG] == NULL ||
>> +	    tb[NFTA_MATH_LEN] == NULL ||
>> +	    tb[NFTA_MATH_OP] == NULL ||
>> +	    tb[NFTA_MATH_BYTEORDER] == NULL)
>> +		return -EINVAL;
> 
>> +	priv->op = nla_get_u8(tb[NFTA_MATH_OP]);
> 
> Can you make it NLA_U32?  NLA_U8 doesn't buy anything except
> limiting us to 255 supported options (i don't see a use case
> for ever having so many, but if we ever have we don't need new OP32
> attribute).

Sure, no problems about that. Also NFTA_MATH_LEN? I do not see a U32 
bits operation happening in the future tho.

> 
> I wonder if we really want this as a module, it seems rather small.
> 

By default I thought that a module made sense.. but it is true it is 
"general" purpose code and small. I don't really mind.

> I would also be open to just extending bitwise expression with this
> inc/dec, both bitwise & math expr do register manipulations.

While both do register manipulation, I do not think they fit together 
from a user perspective. Especially if we extend the number of math 
operations in the future.

