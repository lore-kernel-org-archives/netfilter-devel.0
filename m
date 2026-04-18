Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433F29BDB1
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 09:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776505921; cv=none; b=RIgF5qIOuHrGh+eZK4uYOS9K32DgGbzls1sW3z9SZOnUxx39Wsw/ftvqbcbHAm5rF7T1/tOVxcOljjv+BxwT9ZQbbA7w+0h0mmmVn1sHwpVVkjjhON2Q63vbEC6EN6DYhXDLYpUcC0VtsGRM0vbJpnqrEcBp2RsGNEEpR39+c6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776505921; c=relaxed/simple;
	bh=d8tp5GGO1O+eSZR4pglWOiyM0laQq+gQxbmqEwYX054=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AdAoQqK/4QLgA4IX+yfM1EabSBQhv314fqd9DWsf/OGopqyuW+UI3yIVhjLCcHxWeP96TKz8yvOltoW6zAaQy5BzvtNGEVW8Z5XN0DF6pun7WP+myaLKQzHYVYS4XTpxhfRUsbLP98IYS/0kM+2y0EYXTRLiK0bHBk53D4vH3Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Wxex1cU2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nt0/AstE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Wxex1cU2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nt0/AstE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Wxex1cU2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nt0/AstE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Wxex1cU2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nt0/AstE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 036746A88C;
	Sat, 18 Apr 2026 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776505913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILc91nbKpIqZKXRZGp9ayAf2yse+/ezIxRKf0IYsI0s=;
	b=Wxex1cU2Ul9b09b6+BXthUADuTanrKLEXfQQI9jH7RAcM94xMNatdXZ13pxbQQ1N4cxIL4
	FTyQCx304OWrgj1CLLBLZRWZdFLU9miG23icGLUCGE1TwHtqv+5y+BMfda9ZvKqeE85nLe
	yyr2mJDs9wlt8iYYQ2vdG9yxoNjlySI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776505913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILc91nbKpIqZKXRZGp9ayAf2yse+/ezIxRKf0IYsI0s=;
	b=Nt0/AstEZyM8Si7jl5EzgFYCb0x4uNQxiTYx1W96jXcxX2mWltAr9DBmyswVJ1fwUlp0WK
	M44RZ3m3M3w8B9BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wxex1cU2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Nt0/AstE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776505913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILc91nbKpIqZKXRZGp9ayAf2yse+/ezIxRKf0IYsI0s=;
	b=Wxex1cU2Ul9b09b6+BXthUADuTanrKLEXfQQI9jH7RAcM94xMNatdXZ13pxbQQ1N4cxIL4
	FTyQCx304OWrgj1CLLBLZRWZdFLU9miG23icGLUCGE1TwHtqv+5y+BMfda9ZvKqeE85nLe
	yyr2mJDs9wlt8iYYQ2vdG9yxoNjlySI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776505913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILc91nbKpIqZKXRZGp9ayAf2yse+/ezIxRKf0IYsI0s=;
	b=Nt0/AstEZyM8Si7jl5EzgFYCb0x4uNQxiTYx1W96jXcxX2mWltAr9DBmyswVJ1fwUlp0WK
	M44RZ3m3M3w8B9BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 967D8593A3;
	Sat, 18 Apr 2026 09:51:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BLVbIThU42mDegAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 18 Apr 2026 09:51:52 +0000
Message-ID: <5e162147-d182-4119-82bd-b56f0e76a44e@suse.de>
Date: Sat, 18 Apr 2026 11:51:44 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4 nf] netfilter: nft_exthdr: skip SCTP chunk evaluation
 for non-first fragments
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 coreteam@netfilter.org, fw@strlen.de, phil@nwl.cc
References: <20260417183433.4739-1-fmancera@suse.de>
 <aeM3gmXM43beA3ot@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aeM3gmXM43beA3ot@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 036746A88C
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/18/26 9:49 AM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Fri, Apr 17, 2026 at 08:34:30PM +0200, Fernando Fernandez Mancera wrote:
>> The SCTP chunk matching logic in nft_exthdr relies on SCTP common header
>> being present at the transport header offset. For fragmented packets at
>> IP level, only the first fragment would match this condition.
>>
>> The nft_exthdr could be used in a PREROUTING chain with a priority lower
>> than -400. This would bypass defragmentation. In addition, it can be use
>> in stateless environments so it should work on a environment where
>> defragmentation is not being performed at all.
> 
> Yes, and stateless filtering is still a valid configuration, ie.
> nf_conntrack is not loaded.
> 
>> Add a check for pkt->fragoff to ensure exthdr SCTP only evaluates
>> unfragmented packets or the first fragment in the stream.
> 
> I would suggest to squash the three small patches to check for
> pkt->fragoff in one patch. The three expressions have been already
> around for a while (backporting the combo patch that makes the same
> logical change should be easy) and it is basically the same logical
> change.
> 

Hi Pablo,

Thanks for the review! I am not sure about squashing them as they all 
have different blamed commits. I find accurate fixes tag quite useful 
when handling backports and I guess others do too (also for stable 
kernels). Is that convincing?

Anyway, not a big deal if there is a strong preference I will squash them.

Thanks,
Fernando.

> Thanks!
> 
>> Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>>   net/netfilter/nft_exthdr.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
>> index 7eedf4e3ae9c..8eb708bb8cff 100644
>> --- a/net/netfilter/nft_exthdr.c
>> +++ b/net/netfilter/nft_exthdr.c
>> @@ -376,7 +376,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
>>   	const struct sctp_chunkhdr *sch;
>>   	struct sctp_chunkhdr _sch;
>>   
>> -	if (pkt->tprot != IPPROTO_SCTP)
>> +	if (pkt->tprot != IPPROTO_SCTP || pkt->fragoff)
>>   		goto err;
>>   
>>   	do {
>> -- 
>> 2.53.0
>>

