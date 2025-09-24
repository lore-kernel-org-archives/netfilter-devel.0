Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90799200BA1
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 09:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758705439; cv=none; b=hLQ54w4ZGIMQKpDMp2nGy5ZPinJPDOdwEJUboE1IvwQMxcFbwnTYstJLocKTgbYX173qmKxqZr+L9MgoV+t61HbwRznTIsmufVuqmnbbfCydY7OzJk5mr/h3OdUqQ2FE9YCI56iLH1prKnn0sWKVIP27Hcg6cec34VBWztr3v+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758705439; c=relaxed/simple;
	bh=FhCZVLJfn4h3dEcG2Vx3oHB/Hkv0AWDMVOjX7G/eZN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cac1eO8ENIYrtcoZpBZUeXHAwdyptv5/VVoGcdZ2TVQ+ZfwqgVymAnYlZM47yRzzt70zQemQiABK8++4hG2jRhaiqF0xWi9Sqc9xyP7iBXyEtR9fYMNSzK4wEltWSvhgfPeBqswtEdWrOaqF8CxOTYWRIbPv+7OB2u/L17ayzCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bWgl3FJt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cpsYr6dH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bWgl3FJt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cpsYr6dH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bWgl3FJt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cpsYr6dH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bWgl3FJt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cpsYr6dH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FAD82174F;
	Wed, 24 Sep 2025 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758705429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHxcGIjtYsmcaAJLUU0J2x+V0hALG0YD6JgdeBmD5CY=;
	b=bWgl3FJtbdlPSoSBJOsk8XTpVh4zm37PiE6kidfkPu9mNQ80cA+J6fYooCb9L/RgBCWNx5
	Q0fh3bttxMCkHa9pcT+nNQUVemyTSJP6+/bcHS9bzWGm7dJXFVNDvCtbEDi+CV2LyoTmHJ
	9DuFjVQwzQPS/Gn7wNOMKWa84kxazQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758705429;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHxcGIjtYsmcaAJLUU0J2x+V0hALG0YD6JgdeBmD5CY=;
	b=cpsYr6dHQWqWz56uW2w28ZkmXED9fzhrjQ+Ja/bvyD8yYiu5CWgrlxv5MX0x1u0BMIRV0L
	q8XZUBFZWe7oRoAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bWgl3FJt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cpsYr6dH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758705429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHxcGIjtYsmcaAJLUU0J2x+V0hALG0YD6JgdeBmD5CY=;
	b=bWgl3FJtbdlPSoSBJOsk8XTpVh4zm37PiE6kidfkPu9mNQ80cA+J6fYooCb9L/RgBCWNx5
	Q0fh3bttxMCkHa9pcT+nNQUVemyTSJP6+/bcHS9bzWGm7dJXFVNDvCtbEDi+CV2LyoTmHJ
	9DuFjVQwzQPS/Gn7wNOMKWa84kxazQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758705429;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHxcGIjtYsmcaAJLUU0J2x+V0hALG0YD6JgdeBmD5CY=;
	b=cpsYr6dHQWqWz56uW2w28ZkmXED9fzhrjQ+Ja/bvyD8yYiu5CWgrlxv5MX0x1u0BMIRV0L
	q8XZUBFZWe7oRoAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B837813A61;
	Wed, 24 Sep 2025 09:17:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mwIWKhS302iZEQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 24 Sep 2025 09:17:08 +0000
Message-ID: <2763497d-12f9-451c-ba32-554723467998@suse.de>
Date: Wed, 24 Sep 2025 11:17:04 +0200
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
 <aNLMF2CdcCKWi4cI@strlen.de> <19498e76-bd17-4e63-9144-8cff9874d3da@suse.de>
 <aNLf4Uj9Faye2fTu@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aNLf4Uj9Faye2fTu@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 0FAD82174F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51



On 9/23/25 7:58 PM, Florian Westphal wrote:
> [..] 
>>> AFAICS you need to add support for a displacement
>>> offset inside the register to support this (or I should write:
>>> work-around-align-fetch-mangling ...)
> 
> [..]
> 
>> What would be the best way to implement this? A pure bit offset
>> (NFT_MATH_OFFSET) or a bitmask (NFT_MATH_BITMASK)?
> 
> Bitmask would allow to remove MATH_LEN, correct?
> 
> Users that want pure U8 increment can do 0xff000000
> resp.  0x000000ff.
> 
> Same for U16.  So I'd say a mask would be better.
> 

Well, I would prefer to keep the MATH_LEN in order to keep this flexible 
in the future for bitfield math operations unless we discard them 
completely.

Anyway, I also prefer the bitmask approach.

>>> Can you make it NLA_U32?  NLA_U8 doesn't buy anything except
>>> limiting us to 255 supported options (i don't see a use case
>>> for ever having so many, but if we ever have we don't need new OP32
>>> attribute).
>>
>> Sure, no problems about that. Also NFTA_MATH_LEN? I do not see a U32
>> bits operation happening in the future tho.
> 
> Yes, good question.  Due to netlink padding neither u8 nor u16 saves
> space in the message encoding.  I'll leave it up to you, I don't see
> 2**32 math len making any sense.
> 
>> By default I thought that a module made sense.. but it is true it is
>> "general" purpose code and small. I don't really mind.
>>
>>> I would also be open to just extending bitwise expression with this
>>> inc/dec, both bitwise & math expr do register manipulations.
>>
>> While both do register manipulation, I do not think they fit together
>> from a user perspective. Especially if we extend the number of math
>> operations in the future.
> 
> Users don't interact with the expressions directly.
> But I understand your point.
> 

Nft command line tool users do not interact with the expression directly 
but libnftnl users do. I have found some users using custom C programs 
to configure rules with libnftnl.

It is not common of course, but I think it is good to keep them on mind.

Thanks for all this feedback Florian!

> Pablo, whats your take?
> 

