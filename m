Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DC4332ECF
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761676580; cv=none; b=ZgrmiPcVuo7rVlhfkC++t/9JndaJcBZdRf948Jj3iekIhzKQV91B7+c9dJvEZ9NLJMWRDAK/5hVT4danLffghStOEz44NNroLrDFRhd3wCuuydltZ80iencgMeTIMk8XnwZJocgSLqic/tPHkeZ2OCVRN2OIGR5rYEcWrT5Dxek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761676580; c=relaxed/simple;
	bh=sGP4mehY0BUi/Bwxujz7oE8FvgAFtdWx/NlK1Ni/5hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCwmKXNui0b6Du/izZ2DcFMcqXog+8QPNrluxyhb2J3m16ivK74EC/N/iI/JvWYJaeZ8iksmkpKDRZ6WnESgTFC1ScqU02lWlUJk0OUabr+LZk0tZjMb5MQ5gc4PjLpaL7n7zAFB0BAQyzORcHe1wKlWAt2GQKmPKFjt3YkbUqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pA2GGPzm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/x+vRuh6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pA2GGPzm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/x+vRuh6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pA2GGPzm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/x+vRuh6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pA2GGPzm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/x+vRuh6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8A44C1F749;
	Tue, 28 Oct 2025 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761676577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wmGkqzYhMRXd23ljTgsLFzBcZCQ7nuwGwdNrxY16nY=;
	b=pA2GGPzmWiZM9IkMdg2uA0ol7pFuyooJVwShL1lz041Ke3aaD5GbVhIiumMD0/vJ/GU5Os
	r04Fx0wQRnDbSVeJYOS3+f1KbenwxcgarbtfXtWSYrsAlrUS319F0ljEDSx6b7AbtOYaXI
	ckExGa8Fp63+KMggRRoY1GPiHaEJN0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761676577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wmGkqzYhMRXd23ljTgsLFzBcZCQ7nuwGwdNrxY16nY=;
	b=/x+vRuh6Lrgz1yxbChbSjA74POSvu6B2Fz4NuQ6his6H0UeRe9QtdqjR4f8G0i7pTLzsFp
	GoAR75vrwS0C3fCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761676577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wmGkqzYhMRXd23ljTgsLFzBcZCQ7nuwGwdNrxY16nY=;
	b=pA2GGPzmWiZM9IkMdg2uA0ol7pFuyooJVwShL1lz041Ke3aaD5GbVhIiumMD0/vJ/GU5Os
	r04Fx0wQRnDbSVeJYOS3+f1KbenwxcgarbtfXtWSYrsAlrUS319F0ljEDSx6b7AbtOYaXI
	ckExGa8Fp63+KMggRRoY1GPiHaEJN0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761676577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wmGkqzYhMRXd23ljTgsLFzBcZCQ7nuwGwdNrxY16nY=;
	b=/x+vRuh6Lrgz1yxbChbSjA74POSvu6B2Fz4NuQ6his6H0UeRe9QtdqjR4f8G0i7pTLzsFp
	GoAR75vrwS0C3fCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33C8813693;
	Tue, 28 Oct 2025 18:36:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tJJBCSENAWlEOQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 28 Oct 2025 18:36:17 +0000
Message-ID: <f012e7c0-4c29-42b0-90e6-9e82ef5bc6d8@suse.de>
Date: Tue, 28 Oct 2025 19:36:16 +0100
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
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQEMbKZUBms2bfuI@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	FREEMAIL_CC(0.00)[netfilter.org,vger.kernel.org,caramail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 10/28/25 7:33 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> We need this gc call, it is what fixes the use-case reported by the
>> user. If the user is using this expression without a ct state new check,
>> we must check if some connection closed already and update the
>> connection count properly, then evaluate if the connection count greater
>> than the limit for all the packets.
> 
> I don't think so.  AFAICS the NEW/!confirmed check is enough, a
> midstream packet (established connection) isn't added anymore so 'ct
> count' can't go over the budget.
> 
> If last real-add brought us over the budget, then it wasn't added
> (we were over budget), so next packet of existing flow will still be
> within budget.
> 
> Does that make sense to you?
> 

It does for standard use case but not for "inverted" flag - the 
expression will continue matching and letting packets pass even if count 
is NOT over the limit anymore because the count is not being updated 
until a new connection arrives.

>> Otherwise, this change will introduce a change in behavior.. AFAICT
> 
> Yes, the existing behaviour is random?  (Due to multiple re-adds).
> With NEW/!confirmed check: no multiadd possible, so no need to ad-hoc
> gc.
> 
> Did I miss anything?

