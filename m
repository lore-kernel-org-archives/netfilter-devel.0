Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D19E23D7DC
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 20:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761684506; cv=none; b=A8kdOmQKO5qCzmrAN1uqhkTqrI7l9nhjTu2t1firXPQKup1LZAW+16ktwWRIVRMzFPmjm7omw8MGT0gOrqCxNrdCLm1NBcARBxMutMXr3GyZstYlSbXpOl3IwywwN5AxAvWMSK1PJ3WoAkb1qJoOrc0WujcZsokgPZoMBJzIH+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761684506; c=relaxed/simple;
	bh=DuUhdZolbUpv1mxADOCpUm5gP33aBHtkwNLc2PRGQIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3fnMQVN49AoDGnnVVlqfmYKwEx30EJa0VG7zBVSFeOlH6zMMrBRNFJEfBkawpN96tVI5SMI8LjPBYoJmE/jSuAvtieaEpKkku/y/i0f/SNx7H+z/Nh3o2GMoeM2dIFHTHHmjtzfcp86iEIjyyvq8L/7Cva/VWXKi7MGQ3W66eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qv4ma/ka; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m5ot4nXf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qv4ma/ka; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m5ot4nXf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qv4ma/ka";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m5ot4nXf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qv4ma/ka";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m5ot4nXf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 34400218E5;
	Tue, 28 Oct 2025 20:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761684502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KUXFfbIF3a5HeiMo419ZIiJ78VasLtJo7KZBteTVrw=;
	b=Qv4ma/kavWCvLyI1vZhi8cd2DHpp/qm0ymz3FJtz9VYq9h4moLVEzOsENhCSu2pi7Chbfx
	JJsrhaoMys6oznoRUeeu0G9rE8da5iug/gWxQHWGDN4os4QSvUE0PsicmtOsZ7zE2b9xou
	giPhqvHY3sZZGLkTmu21PF6xp2o3eaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761684502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KUXFfbIF3a5HeiMo419ZIiJ78VasLtJo7KZBteTVrw=;
	b=m5ot4nXfzKCnv8Mm5y8pMSfobrmzpUqlp8J9Dzf6ZeLv/ZDjpanmXHo5R4yA0bb14yw4bH
	jZ9GA4cDQuoJC1Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761684502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KUXFfbIF3a5HeiMo419ZIiJ78VasLtJo7KZBteTVrw=;
	b=Qv4ma/kavWCvLyI1vZhi8cd2DHpp/qm0ymz3FJtz9VYq9h4moLVEzOsENhCSu2pi7Chbfx
	JJsrhaoMys6oznoRUeeu0G9rE8da5iug/gWxQHWGDN4os4QSvUE0PsicmtOsZ7zE2b9xou
	giPhqvHY3sZZGLkTmu21PF6xp2o3eaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761684502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KUXFfbIF3a5HeiMo419ZIiJ78VasLtJo7KZBteTVrw=;
	b=m5ot4nXfzKCnv8Mm5y8pMSfobrmzpUqlp8J9Dzf6ZeLv/ZDjpanmXHo5R4yA0bb14yw4bH
	jZ9GA4cDQuoJC1Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4CFD13693;
	Tue, 28 Oct 2025 20:48:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ievlMBUsAWkZNQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 28 Oct 2025 20:48:21 +0000
Message-ID: <9d1bb390-0f79-405e-8f28-6c7143a2e6b5@suse.de>
Date: Tue, 28 Oct 2025 21:48:11 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of a
 connection
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, louis.t42@caramail.com
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula> <aQD4J7pI-Fz1V3eC@strlen.de>
 <aQD5PUkG7M_sqUAv@calendula> <aQD810keSBweNG66@strlen.de>
 <fdaccdd2-fce5-4224-9636-bf3366de2761@suse.de> <aQEMbKZUBms2bfuI@strlen.de>
 <f012e7c0-4c29-42b0-90e6-9e82ef5bc6d8@suse.de> <aQEVF4mZ23ewPmUN@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQEVF4mZ23ewPmUN@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	FREEMAIL_CC(0.00)[netfilter.org,vger.kernel.org,caramail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/28/25 8:10 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 10/28/25 7:33 PM, Florian Westphal wrote:
>>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>>> We need this gc call, it is what fixes the use-case reported by the
>>>> user. If the user is using this expression without a ct state new check,
>>>> we must check if some connection closed already and update the
>>>> connection count properly, then evaluate if the connection count greater
>>>> than the limit for all the packets.
>>>
>>> I don't think so.  AFAICS the NEW/!confirmed check is enough, a
>>> midstream packet (established connection) isn't added anymore so 'ct
>>> count' can't go over the budget.
>>>
>>> If last real-add brought us over the budget, then it wasn't added
>>> (we were over budget), so next packet of existing flow will still be
>>> within budget.
>>>
>>> Does that make sense to you?
>>>
>>
>> It does for standard use case but not for "inverted" flag - the
>> expression will continue matching and letting packets pass even if count
>> is NOT over the limit anymore because the count is not being updated
>> until a new connection arrives.
> 
> I don't really see how.  Empty ruleset with single
> 
> 'ct count over 3 reject'
> 
> ... is broken flat out broken. I mean, whats that supposed to do?
> 
> 1st connection comes in -> 1
> 2nd connection comes in -> 2
> 3rd connection comes in -> 3
> 4th connection comes in -> 4 -> rejects happen (for all matching _packets_!)
> 
> The extra gc doesn't change anything here except that when one
> connection has closed this gets 'healed'.  But I argue that this is
> nonsensical ruleset, given the connection has to time out (even fin/rst etc.
> won't pass, so normal closing possible).
> 

The use-case I have on mind (which is similar to what user described, 
but he uses a counter which I guess is just for debugging):

ip saddr 192.168.1.100 tcp dport 22 ct counter over 4 mark set 0x1

later, the mark can be used for tc or policy-based routing - e.g 
limiting bandwidth if the ip address has too many connections open.

To me this seems a valid use case..

1st connection comes in -> 1
2nd connection comes in -> 2
3rd connection comes in -> 3
4th connection comes in -> 4

all the packets are now being marked with 0x1 and QoS is being performed 
with tc (limiting the bandwidth). Later, 1st and 2nd connection are 
closed but the packets from 3rd and 4th connection are still being 
marked as 0x1 until a new connnection arrives and the count is updated.

This behavior seems wrong to me.. and while I know it isn't supposed to 
be used without "ct state new" check, I could find some examples doing 
this on the internet..
