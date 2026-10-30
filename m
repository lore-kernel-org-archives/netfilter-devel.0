Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372330;
	b=ur/uKLWs8QVwCXDaBS8XUVASYbS7SUno1QpALcJYVaaifT9uqShge1VeWQairb1wH1eg
	 mQphKtS1MGQKs/e0BKelc6fW87pIujbKd+4koZ1GnvwGl4ZfNO8A2hqpbFQaxP0KnPjy4
	 uTbL4VSThxNZJFFWDdNmgNMh3r3HGHCS+ozXdlGjG5K4D2X69IUPKC1a+ange+0cim6FR
	 2yaq4JrIuxFi1izwW5saemVfdCBnGgi+fQS3E+v88JSdcW+yNzF9KU5KNwR9/VGFrZoSg
	 gjao6ai+j+vAQWu7iOipjy3q4f1atAJJkUhw73qcv5iUQ5TLb48irlZVz5gMqxX112Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372330;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=4bpxQRnQ0Bis4NFIPRdNSJ2T4B3GbDqO+kIUPdQDKos=;
	b=IcfRl/bmghpRE4eYc+yVoMCL/wcCaWM9364c5m1dKEPo+dUSQK/QyTnNp2ta5V+BTo5w
	 kzGw+QDgwKzcm6QhxGkkKvIVk/SmF5D3g8BBWtw6GvzJykCO3SJXOQt2XvT4yNaQZLK4f
	 Iaz3gnh64fWkqo0uN/ZjNevdzc1l3EB5/NKEKn38ZpDjylWQDgmjSnSrBw/FDLZALeI5J
	 1fKfnrjT97qvRi0f6Ag5OKl2KT/l4Jr/Fo9OxCDRxotWtY7ZXZc4QtvOsorzW44OZAGSU
	 iMRT2iXXkdSZZi5X/AvhmAlapEH2nhO+jGx5q/WtCx1Aq9jr2ISC+BQDOvQK7qscjJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VYaTm2P1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=h3HlbDB2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mubofwHh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TnfeDvE4;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A49606A31F
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 14:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74A49606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VYaTm2P1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=h3HlbDB2;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mubofwHh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TnfeDvE4
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62043222D7;
	Fri, 30 Oct 2026 14:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793372327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4bpxQRnQ0Bis4NFIPRdNSJ2T4B3GbDqO+kIUPdQDKos=;
	b=VYaTm2P1JOn3jJvjB7WPzpYLjM9teIoTTrS9ignqg1L8+v48ZRvD6hJCklRxlp4C+l8Tb9
	FcmeDgtzF8sW4gY6W3DSoED/l+XNrC4eCiWL/vCPxFgXr5AmwaR8U8GDDum7E0MfCxoaFd
	QLlMT23BtJqAIP73VPvmc7iuR+mGHEU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793372327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4bpxQRnQ0Bis4NFIPRdNSJ2T4B3GbDqO+kIUPdQDKos=;
	b=h3HlbDB2caGsOsRWGL2i0MQX9YGbuFA1B7DwrYD+isT70TjrOa7OOQsTIGRzqOjDy+GAxX
	cBpIyDYiP2FpK+Bg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mubofwHh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TnfeDvE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793372326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4bpxQRnQ0Bis4NFIPRdNSJ2T4B3GbDqO+kIUPdQDKos=;
	b=mubofwHhsONBiKSZHlQRcujlxPj1vkIO09fqN5fkEjGmUIlWjJdcb2rTpKXr2CclSw1adT
	Kd6DIbXPKA8ROgDUDAW/mA27kOa8AB3E5nAqbE+E71oXW01AQkyeFy7tq28ZGFZ+Yi11P/
	orLV/KNUVyflpjhXCW1xt5+aP71wMYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793372326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4bpxQRnQ0Bis4NFIPRdNSJ2T4B3GbDqO+kIUPdQDKos=;
	b=TnfeDvE469MPz68RAJR533mURWAuYUBy7XJhlZIP5br/CvKLHski4PQV9zuup33gWoW6ho
	gaXbI5d0wpy64LBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAC9E13432;
	Fri, 30 Oct 2026 14:58:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id djPfKqWw5Gr6OAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 30 Oct 2026 14:58:45 +0000
Message-ID: <964c22e6-9be8-4896-8c7c-45d927789c97@suse.de>
Date: Fri, 30 Oct 2026 15:57:34 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership when
 expanding skb
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc, VEGA <vega@nebusec.ai>
References: <20261030135750.4452-1-fmancera@suse.de>
 <auSrTEnc8tibSGs2@strlen.de> <17f1cf11-ae17-46f6-a8a0-a23644411ab0@suse.de>
 <auSvco0w7wKkuyE9@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <auSvco0w7wKkuyE9@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 62043222D7
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 10/30/26 3:53 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 10/30/26 3:35 PM, Florian Westphal wrote:
>>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>>> nfqnl_mangle() replaces the skb with skb_copy_expand() when a verdict
>>>> grows a packet beyond its tailroom. skb_copy_expand() does not copy
>>>> skb->sk, so the replacement is unowned and freeing the original drops
>>>> its socket memory charge.
>>>>
>>>> The expanded packet is no longer associated with the process that sent
>>>> it. Therefore xt_owner or xt_cgroup and other socket based matches in
>>>> later rules no longer matches and a later NFQUEUE reports no uid/gid. In
>>>> addition, the expanded packet's memory is not counted towards the
>>>> sender's SO_SNDBUF limit, so the sender can keep producing them while
>>>> they sit in a queue.
>>>
>>> A proper fix requires wmem/truesize fixups and will have to deal with
>>> wmem-accounted vs. non-wmem accounted.
>>>
>>> I dont think its worth fixing this, there are many other ways to
>>> get OOM when you have CAP_NET_ADMIN.
>>
>> That is fair but the keeping ownership of the skb seems worth it for
>> other uses too? Anyway, I don't think the OOM aspect is too relevant.
> 
> I don't think many people to packet payload rewrite for locally
> originating packets.
> 

Oh that is for sure. This is a corner case.

>> This is just fixing a combination of queue + other matches. I can also
>> drop the memory aspect of it from the commit and keep the combination thing.
> 
> I think that problem isn't too serious in practice, LLM is overselling.
> 
> You just need to structure the ruleset so that the nfqueue stuff comes
> after the sk identity checks :-)
> 
>> But yeah, we can just ignore it. There are many combinations that are
>> problematic anyway (?)
>>
>> What do you think?
> 
> If you think its worth doing, then by all means, go for it!

The ownership fix is trivial and already done so why not? Anyway, let's 
see what does Pablo think and decide based on that. FWIW, I won't go for 
the whole memory issue fix you mentioned before.
