Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF223D88F1
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779790375; cv=none; b=TzGg2OzUmbcbha/2TIICigjQH5+4U3wcBTaO0qI2bsH0Nma8lr8EhIFIMhNU8+PsMlPfX5oGZXgrNQUc0tb7dTG745qFPQlYuARvmkQ9U5C0G4pFbyXP09znj5Mqd/XEp0qAdIY9TF0AYeBJGvGWt0XXjVyFytGNZwc5S3xe/Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779790375; c=relaxed/simple;
	bh=uGmN/A4Bu+4H6Stp+M2DzkH3zP5Qc7E5hQ48Dka/MMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FgcBACOyifi4dDSsSESrveIvJ3thYcqRegeuMr8bkasASoQQ1oEWKCT36Ifme36SDmr0xr0JRtpy71M0OaR8Y8krATB7fcERH2wF95oW0/pi0V5sNNYkJ8bvJuopk70hImwTpZ1c/1CQ9bipY20FFn59FLG+W5OTc+xMMy+Tg7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QrwK3hBN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cFRyoyfq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QrwK3hBN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cFRyoyfq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QrwK3hBN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cFRyoyfq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QrwK3hBN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cFRyoyfq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 455E86711E;
	Tue, 26 May 2026 10:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779790372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NvIrdghQhyWTjFdcBvR0Ew8r7Xg8DywphMcoFe4/+FY=;
	b=QrwK3hBNnVQ0D668Y2RqIqxFQnx8YP0aOJivEc2uDbZjs5hyWukQwdmN4rF5k1EcEI+ran
	Y32ITK7R8Zkso+5ZP+jdFW81XA0CwnmsaaYmAFk7kKqLvbKcR2V2i0QQO3MIajAXx79FNu
	lJqhIHXM/K/UENJzQly4sdVf7nUDGy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779790372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NvIrdghQhyWTjFdcBvR0Ew8r7Xg8DywphMcoFe4/+FY=;
	b=cFRyoyfqD5Pl2RjYTTcKrsDBPEuEeBc2vzfn0SemdasiIOb6JM/q7eu2Y7D3PEmJmQyBPP
	taYCc7Wy/l2gdODw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QrwK3hBN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cFRyoyfq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779790372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NvIrdghQhyWTjFdcBvR0Ew8r7Xg8DywphMcoFe4/+FY=;
	b=QrwK3hBNnVQ0D668Y2RqIqxFQnx8YP0aOJivEc2uDbZjs5hyWukQwdmN4rF5k1EcEI+ran
	Y32ITK7R8Zkso+5ZP+jdFW81XA0CwnmsaaYmAFk7kKqLvbKcR2V2i0QQO3MIajAXx79FNu
	lJqhIHXM/K/UENJzQly4sdVf7nUDGy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779790372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NvIrdghQhyWTjFdcBvR0Ew8r7Xg8DywphMcoFe4/+FY=;
	b=cFRyoyfqD5Pl2RjYTTcKrsDBPEuEeBc2vzfn0SemdasiIOb6JM/q7eu2Y7D3PEmJmQyBPP
	taYCc7Wy/l2gdODw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA1695A157;
	Tue, 26 May 2026 10:12:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iEEgNiNyFWrwLgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 10:12:51 +0000
Message-ID: <4887bf00-d044-4366-8588-a83e4bce0274@suse.de>
Date: Tue, 26 May 2026 12:12:43 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4 nf v2] netfilter: synproxy: fix possible write to
 stale pointer
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc
References: <20260525124450.6043-1-fmancera@suse.de>
 <20260525124450.6043-5-fmancera@suse.de>
 <df64cebb-1279-4e66-afa7-3d8ffca4928f@suse.de> <ahSb-UU8n9o1aHoI@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ahSb-UU8n9o1aHoI@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 455E86711E
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid,sashiko.dev:url];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On 5/25/26 8:59 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 5/25/26 2:44 PM, Fernando Fernandez Mancera wrote:
>>> skb_ensure_writable() is called to guarantee that the TCP options area
>>> can be safely modified when adjusting the timestamp. As it expands or
>>> linearize the skb head it might reallocate the data buffer.
>>>
>>> This makes the th pointer passed by the caller stale. The following
>>> writes to the TCP header might be done to a stale pointer.
>>>
>>> Recalculating the th pointer after skb_ensure_writable() prevents this
>>> issue from happening.
>>>
>>> Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
>>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>>
>> LOL. I just realized I already reviewed this at:
>>
>> https://lore.kernel.org/netfilter-devel/20260522104257.2008-3-fw@strlen.de/T/#u
>>
>> *facepalm* sorry for the noise, Florian could you ignore this patch but
>> consider the other 3 fixes?
> 
> I know its tiresome, but would you mind sending a new version that also
> fixes up the other things pointed out by sashiko?
> 
> https://sashiko.dev/#/patchset/20260525124450.6043-1-fmancera%40suse.de
> 
> In particular, seqadj and concurrent registration.  As these bugs aren't
> as severe as patch 4, I think nf-next would be fine as well.
> 
> 

I have been taking a look to this. The seqadj issue isn't real IMHO.

The logic here is protected by the TCP state machine. AFAIU, ALGs only 
look at fully established connections, I don't see how this can happen 
even for retransmitted packets, the TCP state would remain the same so 
nf_ct_seqadj_init() should never race with nf_ct_seqadj_set().

FWIW; the concurrent registration issue is real. I am writing a fix.

Thanks Florian!
