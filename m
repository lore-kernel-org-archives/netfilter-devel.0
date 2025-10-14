Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D832C158D
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 07:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427158; cv=none; b=iRKABAXzXKdY6+zmHiV0egEUsixn0ofzIKkCFjaz10Hug2A/Dk4oQxpWBVW+tKaK+V20tPPt1DByGtpXQtGrDl0M/RYVENrimRfv2DPfcaLnYy/Gyb/bpFuiNhvcq5547dlutJXrGoM0r0nSQ9lMaVQrIT5IvJwfgnqDvBAmiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427158; c=relaxed/simple;
	bh=fel+CsuYcCAxsOy+TLykUblyVjtVunbBs9xW8X/evpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=izqVP2rvSWb3LtkOR7/j3yZwBnCS+Owwjs6oBvS6U7E2PXAyF3nbi5uMr+LAQcmW9+5+y5UcZZxdYsz5bZIur7jONkf5drnXpA/j6WF9lkU/dxJDachPNnB7KoFiiOLl/wLnMdQDlP9xrgQvr3lOhuXr8WJgfTIRt2XSmwHNy9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O/PaPc94; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aOPoCuCF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O/PaPc94; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aOPoCuCF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O/PaPc94";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aOPoCuCF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O/PaPc94";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aOPoCuCF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5BFB21F794;
	Tue, 14 Oct 2025 07:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760427154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiZ6gOGnigyWmLie95GQw41HzEoqC9nTRl/LmGxSO4U=;
	b=O/PaPc94+miCeMRURHkTFWwrApahzOaoDUNsaJ+FMLQWBvO+0btUTxuflPfARsnsUWOaFC
	i+Wm1deYhEjcAJivso4lDNwIE9MbGnu43DXVPDtyYwV7goLxDogEP50AqtCjkyCBnozeLQ
	P8DKnAEyXN4Zi4pdmRuvJStIovJUIDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760427154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiZ6gOGnigyWmLie95GQw41HzEoqC9nTRl/LmGxSO4U=;
	b=aOPoCuCFnii5nAvZCcxASyJcaYD3PtidjE286I4X3YCo/l+C3pVVD0VxD/PpHdOpSh7+8L
	oshWNiEGrgYf2jCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760427154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiZ6gOGnigyWmLie95GQw41HzEoqC9nTRl/LmGxSO4U=;
	b=O/PaPc94+miCeMRURHkTFWwrApahzOaoDUNsaJ+FMLQWBvO+0btUTxuflPfARsnsUWOaFC
	i+Wm1deYhEjcAJivso4lDNwIE9MbGnu43DXVPDtyYwV7goLxDogEP50AqtCjkyCBnozeLQ
	P8DKnAEyXN4Zi4pdmRuvJStIovJUIDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760427154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiZ6gOGnigyWmLie95GQw41HzEoqC9nTRl/LmGxSO4U=;
	b=aOPoCuCFnii5nAvZCcxASyJcaYD3PtidjE286I4X3YCo/l+C3pVVD0VxD/PpHdOpSh7+8L
	oshWNiEGrgYf2jCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E590139B0;
	Tue, 14 Oct 2025 07:32:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vOhdAJL87WgfWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 14 Oct 2025 07:32:34 +0000
Message-ID: <71e3b9f3-4a9e-4aa3-9e56-88c3983610ef@suse.de>
Date: Tue, 14 Oct 2025 09:32:26 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] meta: introduce meta ibrhwdr support
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250902113529.5456-1-fmancera@suse.de>
 <aO1XOREzSUUgROcy@strlen.de> <aO1jchhd9t07Igq3@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aO1jchhd9t07Igq3@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 10/13/25 10:39 PM, Pablo Neira Ayuso wrote:
> Hi Florian,
> 
> On Mon, Oct 13, 2025 at 09:47:05PM +0200, Florian Westphal wrote:
>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>> Can be used in bridge prerouting hook to redirect the packet to the
>>> receiving physical device for processing.
>>>
>>> table bridge nat {
>>>          chain PREROUTING {
>>>                  type filter hook prerouting priority 0; policy accept;
>>>                  ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
>>>          }
>>> }
>>
>> Pablo, does the above ok to you?
>> I am not sure about 'ibrhwdr'.
> 
> I'd suggest: ibrhwaddr, for consistency with other existing ibr
> selectors and anything that relates to address uses the suffix 'addr'.
> 

Fine for me! If it looks good to you Florian I can send a v2 quickly and 
also adjust the test.

>> Will there be an 'obrhwdr'?
> 
> No usecase for this so far.
> 
>> Or is it for consistency because its envisioned to be used in
>> incoming direction?
> 
> Using the input device where this frame came from, which is a bridge
> port, fetch the address of the upper bridge device on top of it.
> 
> It is a bit unix-like looking acronym, arguably not so intuitive, but
> I don't have a better idea.
> 
>> Patch LGTM, I would apply this and the libnftnl dependency.
> 

