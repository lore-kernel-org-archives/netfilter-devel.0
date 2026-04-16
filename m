Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5016C1A01BE
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Apr 2026 13:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776346644; cv=none; b=selYUpyXsmE9F5eegUn5ri3GNLYuQDR8SropluWz1PNgUqm14cnzzJhZFU/E/y2YvhWTKrzS+Yj0RUDTWGHLxK42alKCukbqtOJZ5pekqgUH+JWz3aqNYKjAbWH9ox4UDvQgkCIFTSSFBKr6DySUxsSwLkzS8HyTAI9uOpwR1nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776346644; c=relaxed/simple;
	bh=y1LMAIBn6cQUT1VjzIm14sKBb4UWR5l0RHmKhq5OhqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fXcQ0MFafavOY/AzEu/dliyQ9jERQvbdqR1jkWV+4vJOHp0iSUwhBTCeu+4oDmlFrYzD5n1v4u9segCEpenEi//q4M0B/dcgXkU+jDGhFZQ9NFbFc3s9EiLcTZ8OFIu+2h80+ChzULerOdWRS1i0yjwTz5aWvAFecfBGOTYc29w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EqsAWePZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ir4XLzWd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EqsAWePZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ir4XLzWd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EqsAWePZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ir4XLzWd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EqsAWePZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ir4XLzWd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 98B425BD31;
	Thu, 16 Apr 2026 13:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776346641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mI0DI4a4b+BC3Hi1tXZE76HVZxPr63eTcG+E02Ebi1E=;
	b=EqsAWePZG8+i4p9Ath9fSV1e6LNT6gtarepdjQoRUNC9EitMgXWiVJZBkeaIGd7yIj45Xf
	9tFVoqWeKvp+IqpvHmMEGRlepURrVKyq4OmCEi+m4ZnNctTOBecWA4BmVsxvxHliiNRe7i
	cY71kLDhnU2Bh96J0rl3SErOtJx/ZlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776346641;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mI0DI4a4b+BC3Hi1tXZE76HVZxPr63eTcG+E02Ebi1E=;
	b=Ir4XLzWdNvpRaVl2rWQZVXuRqz0aghqN7mNpMTnQRy8YBsmMIi1VR95Sfzaae2CqomkHye
	TALZhlpEaaHhlVAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EqsAWePZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ir4XLzWd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776346641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mI0DI4a4b+BC3Hi1tXZE76HVZxPr63eTcG+E02Ebi1E=;
	b=EqsAWePZG8+i4p9Ath9fSV1e6LNT6gtarepdjQoRUNC9EitMgXWiVJZBkeaIGd7yIj45Xf
	9tFVoqWeKvp+IqpvHmMEGRlepURrVKyq4OmCEi+m4ZnNctTOBecWA4BmVsxvxHliiNRe7i
	cY71kLDhnU2Bh96J0rl3SErOtJx/ZlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776346641;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mI0DI4a4b+BC3Hi1tXZE76HVZxPr63eTcG+E02Ebi1E=;
	b=Ir4XLzWdNvpRaVl2rWQZVXuRqz0aghqN7mNpMTnQRy8YBsmMIi1VR95Sfzaae2CqomkHye
	TALZhlpEaaHhlVAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 201EE593A3;
	Thu, 16 Apr 2026 13:37:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UwHdBBHm4GlDYQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Apr 2026 13:37:21 +0000
Message-ID: <0a4b74fc-732c-4842-b2af-e2dde658319e@suse.de>
Date: Thu, 16 Apr 2026 15:37:20 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 00/14] Netfilter/IPVS fixes for net
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, horms@kernel.org
References: <20260416013101.221555-1-pablo@netfilter.org>
 <aeCPB1_WaFOX-Xos@chamomile> <aeC4A75gYD9qT5OR@chamomile>
 <aeC8hyj6IFW7UvUG@strlen.de> <36ccd420-25f2-43e9-89bf-088fcad40f81@suse.de>
 <aeDgvwlyuGF4HnWK@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aeDgvwlyuGF4HnWK@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,sashiko.dev:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 98B425BD31

On 4/16/26 3:14 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> I would like to propose to add netfilter-devel mailing list to
>> sashiko.dev and also to Netdev CI.. I think Jakub mentioned it was
>> possible on a previous situation.
> 
> I already run all my pull requests through most of NIPAs test, with
> additional netfilter-specific tests.
> 
>> I think it isn't sustainable to review and address the AI/LLM comments
>> when sending the pull request to for net/net-next.
> 
> The current bug report influx is already unsustainable for us.
> 

Yes, it isn't. It should be fine to just delay everything. The resources 
are limited and if the influx of LLM/AI generated reports increases, it 
will just take more time to get through them.

>> If you agree I could help moving this forward.
> 
> If you know who to contact to make sashiko also digest netfilter-devel
> that would be good to have.
> 

Yes, I can reach out to Roman Gushchin regarding it.

Thanks,
Fernando.

