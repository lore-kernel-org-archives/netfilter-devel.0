Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFAF244694
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2026 09:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776417437; cv=none; b=Q62FLPfobXbCGtGu2RFDDuDYvXaIP7BRJeY70VtYEMlEC8Q525xrB+L/si0b/78qhDcgiP4es4GNCja/6ap0+1+lFtIoUzSI86FTqbLMRTkP0/vtiTEIzqxydLv/ENRP/V97NkE1t0oQXuqqC9BWDoMAzkdPuGFvy3Rhn8zOM2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776417437; c=relaxed/simple;
	bh=53G/T0vtuVDUDEIsLPezKFbyfG9x46Qlm3EVjx4PUGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sewJfwbsq1rvL52KHmvWUZTELaxI8A+MJCTOh0rcCnA0qEd0SXejPAUYfRC0F8x1HLWA/wJQFO6GA7BKWZPzJof5DdfMHc3XZXbssppgJF+tU2GtIpzhgh0yoIGPcyKJcz7RdNlCU0Fk5841YkUhFx4DVr9ZFhm+mKc5UCaD0n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uV2U5UTE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q/AY4b8+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uV2U5UTE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q/AY4b8+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uV2U5UTE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q/AY4b8+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uV2U5UTE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q/AY4b8+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 30EF25BD05;
	Fri, 17 Apr 2026 09:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776417428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJwDx2KWVN2ui/r0NppSEtiurd1+rrW1h0GUdaDPYr4=;
	b=uV2U5UTEq7PI55wIJTZxgWm8j2nxKtzlOlvlTQnhg9gOq530pDOaZgMS0FtwDY92kpkbpV
	yMubyRUFasQoTaO1DZC1nPB5c5M9ZfXSB4u+SYtS5Oqd6W6pr+FF/SaCrMDvp2n3gLEcuZ
	cRPomxJaDmbIhEawj+CCIAJLS5U2BTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776417428;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJwDx2KWVN2ui/r0NppSEtiurd1+rrW1h0GUdaDPYr4=;
	b=q/AY4b8+H4gMGl+nSBcZykW0ny079nzdxOGU2yBrlXdG3A1WiwRrBlgOR1sw9a4T8jFarX
	b8dvb8VZkj3NgtAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776417428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJwDx2KWVN2ui/r0NppSEtiurd1+rrW1h0GUdaDPYr4=;
	b=uV2U5UTEq7PI55wIJTZxgWm8j2nxKtzlOlvlTQnhg9gOq530pDOaZgMS0FtwDY92kpkbpV
	yMubyRUFasQoTaO1DZC1nPB5c5M9ZfXSB4u+SYtS5Oqd6W6pr+FF/SaCrMDvp2n3gLEcuZ
	cRPomxJaDmbIhEawj+CCIAJLS5U2BTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776417428;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJwDx2KWVN2ui/r0NppSEtiurd1+rrW1h0GUdaDPYr4=;
	b=q/AY4b8+H4gMGl+nSBcZykW0ny079nzdxOGU2yBrlXdG3A1WiwRrBlgOR1sw9a4T8jFarX
	b8dvb8VZkj3NgtAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABF38593AE;
	Fri, 17 Apr 2026 09:17:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8hZIJ5P64WmVbgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 17 Apr 2026 09:17:07 +0000
Message-ID: <29523179-02d3-4be6-96f6-862d930146cc@suse.de>
Date: Fri, 17 Apr 2026 11:16:59 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net,v2 00/11] Netfilter/IPVS fixes for net
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org
References: <20260416131453.308611-1-pablo@netfilter.org>
 <aeFRt__YQqJ84ZaN@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aeFRt__YQqJ84ZaN@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/16/26 11:16 PM, Florian Westphal wrote:
[...] /* snip */
> I hope we get shashiko to also digest netfilter-devel;
> otherwise this situation will persist forever or can
> dissolve nf-devel and spam netdev@ directly :-|
> 

FWIW, I just checked that sashiko already digest 
https://lore.kernel.org/all/ - that means we can already check the 
results for netfilter-devel patches although we need to search for them 
manually.

I reached out to them so we can have a netfilter-devel filter, but I 
think we should start checking the results of sashiko on the patches 
sent to netfilter-devel by manual search.

