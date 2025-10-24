Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A002F2F5B
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 15:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320878; cv=none; b=AF631BL1BZUH0PvYSaOz1CI1k+D9t/LgqJfjzBAFYwpoR+i18gI1hifOgGPyFD9j35qXzJyT+Kn3N4Z8ImvKxpqONbCw/HwCprWcpPuDEfGOUwpZ0BlTGSRBwCig9nAYRDy3HNeQdXCzm0jdjE0jncb6PKML+sEh7Vk/tJMZI2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320878; c=relaxed/simple;
	bh=7aS0I+dTg/WnuIC7mNo+VHzY2MrjOJLy42QGH+pPAhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nDsk7ldfoMQaMFxA9KJbgQxOre113c/Cep/oFkVto2GXIO56GemFgIBdVHZdda5uO+4Wql+weeVyv2iZhTxPlvmLtFbfKrmD8yjks+r/+Tc2LahDb8o4P8kZ5PtLIP5jeLQXGz3/+4b3+Y/NRNjvOsd4P1mhSZxRjGBoFBd7whY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i+Z+meHG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8vHW22qG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i+Z+meHG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8vHW22qG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i+Z+meHG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8vHW22qG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i+Z+meHG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8vHW22qG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9277211FC;
	Fri, 24 Oct 2025 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DOc21fp/1HggLd4HWrAE2jK7SOXpoAbcqmp4WD0mFKU=;
	b=i+Z+meHG0Z4hKQoCh+HzvaFMMESM6sQbEL7Fl/hHGz0oGCh+ZlA7zNunPNw0ZgNBfgG0L5
	xS5gbQivlhL+oHuACiFhoR7UbPfxv4JAZ9/fy1OWzZj+WtivxnkNS5oQJ6c29lBY+LCeYI
	JNtgwaxjeGrdFQC6B7GVCs6J2tUhNng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DOc21fp/1HggLd4HWrAE2jK7SOXpoAbcqmp4WD0mFKU=;
	b=8vHW22qGKzJ4wX8D2GnNZwNOu3yQagp9Y4Mg0usBNDsPNEvS/cwwzReYrnBLTL/SDLIljA
	YOaUf8TazRQYcJDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761320874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DOc21fp/1HggLd4HWrAE2jK7SOXpoAbcqmp4WD0mFKU=;
	b=i+Z+meHG0Z4hKQoCh+HzvaFMMESM6sQbEL7Fl/hHGz0oGCh+ZlA7zNunPNw0ZgNBfgG0L5
	xS5gbQivlhL+oHuACiFhoR7UbPfxv4JAZ9/fy1OWzZj+WtivxnkNS5oQJ6c29lBY+LCeYI
	JNtgwaxjeGrdFQC6B7GVCs6J2tUhNng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761320874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DOc21fp/1HggLd4HWrAE2jK7SOXpoAbcqmp4WD0mFKU=;
	b=8vHW22qGKzJ4wX8D2GnNZwNOu3yQagp9Y4Mg0usBNDsPNEvS/cwwzReYrnBLTL/SDLIljA
	YOaUf8TazRQYcJDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71308132C2;
	Fri, 24 Oct 2025 15:47:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IMU2GKqf+2iuDwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 24 Oct 2025 15:47:54 +0000
Message-ID: <b74b168f-d9bd-45c6-b4c5-d61163f34c08@suse.de>
Date: Fri, 24 Oct 2025 17:47:34 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix stale read of connection
 count
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 louis.t42@caramail.com
References: <20251023232037.3777-1-fmancera@suse.de>
 <aPtjnNZncIqh19Jl@strlen.de> <9d15bc0f-e41d-400b-9e3b-84f6ba1688f7@suse.de>
 <aPt13hRzJvTkkK4e@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aPt13hRzJvTkkK4e@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[caramail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,caramail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/24/25 2:49 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 10/24/25 1:31 PM, Florian Westphal wrote:
>>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>>> nft_connlimit_eval() reads priv->list->count to check if the connection
>>>> limit has been exceeded. This value can be cached by the CPU while it
>>>> can be decremented by a different CPU when a connection is closed. This
>>>> causes a data race as the value cached might be outdated.
>>>>
>>>> When a new connection is established and evaluated by the connlimit
>>>> expression, priv->list->count is incremented by nf_conncount_add(),
>>>> triggering the CPU's cache coherency protocol and therefore refreshing
>>>> the cached value before updating it.
>>>>
>>>> Solve this situation by reading the value using READ_ONCE().
>>>
>>> Hmm, I am not sure about this.
>>>
>>> Patch looks correct (we read without holding a lock),
>>> but I don't see how compiler would emit different code here.
>>>
>>> This patch makes no difference on my end, same code is emitted.
>>>
>>> Can you show code before and after this patch on your side?
>>
>> I did `make net/netfilter/nft_connlimit.s` for before and after, then I
>> diffed both files with diff -u:
>>
>> I see a difference on how count is being handled.
> 
> I'd apply this patch for correctness reasons. But I see no difference:
> 
>> @@ -984,19 +984,19 @@
>>    # net/netfilter/nft_connlimit.c:46: 	if
>> (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
>>    	testl	%eax, %eax	# _30
>>    	jne	.L65	#,
>> -# net/netfilter/nft_connlimit.c:51: 	count = priv->list->count;
>> -	movq	8(%rbx), %rax	# MEM[(struct nft_connlimit *)expr_2(D) + 8B].list,
>> MEM[(struct nft_connlimit *)expr_2(D) + 8B].list
>> +# net/netfilter/nft_connlimit.c:51: 	count = READ_ONCE(priv->list->count);
>> +	movq	8(%rbx), %rax	# MEM[(struct nft_connlimit *)expr_2(D) + 8B].list, _31
>> +	movl	88(%rax), %eax	# MEM[(const volatile unsigned int *)_31 + 88B], _32
> 
> old:
> movq    8(%rbx), %rax
> movl    88(%rax), %eax
> cmpl    %eax, 16(%rbx)
> 
> new:
> movq    8(%rbx), %rax
> movl    88(%rax), %eax
> cmpl    %eax, 16(%rbx)
> 
> same instruction sequence, only comments differ.
> Doesn't invalidate the patch however, we do read while not holding
> any locks so this READ_ONCE annotation is needed.
> 


Yes, you are right. Let me send a V2 clarifying the commit message. I am 
sending some other patches as this requires other fixes..
