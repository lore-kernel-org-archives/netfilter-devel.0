Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1540030EF74
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Nov 2025 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763482104; cv=none; b=BIr1z9LlrzvJKKTYSVVCfBYy2N+nThUYIXoVdeS1u05uRsp66EBbMP2/xH0QDwcWjMe4UgK3LHWv00XEIYNY0XDqS6vh6tHBDgUbWN8XslczFX7utY/LHjMcuJngJvVMCU0VpxsA+o3tjJW9lCahyniaE8chKi1pLUvJFBD9SS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763482104; c=relaxed/simple;
	bh=CGS0avF3n70rs7VsnLA6U2ZsKIwKSF0b9kK3RSLXgs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e31qiZOS5e81XFjpkkMEChP4RbdBoOv32nJ1U83uBze0KZ6NPyRZC2shKnLqTJpQh7GFJ3FFjZf/Cy6FO44EnYjOw6ldN5FfaNjDoYQL7dYetu9LfdpEkeOiqshXHQWUGINipX9WwDVCQV07WWU+KYwlb6/bOMfSFZCWl7Bs2og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zPc1Lufg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PdngeRse; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zPc1Lufg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PdngeRse; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zPc1Lufg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PdngeRse";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zPc1Lufg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PdngeRse"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4CF571FF8A;
	Tue, 18 Nov 2025 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763482101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDreU/3vuQGNhmus7lN5qPGVGHMqUW/r6EEkPyaIto4=;
	b=zPc1LufgUOjNNHnV89jtHoaIFyr5LffiJoEGQL+qfMVWjSsGExwu8ggGoj/gjyDUgEYOLU
	WCI8GRzJvXb1a3GfiHWRxQ+dMgktbNpOwme98hCvnZUoUA0ZJ/SKT6gEZDGqTjXikDopQ2
	H/bYVgXfySpdfc3w7PJKBEpWrDtpyVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763482101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDreU/3vuQGNhmus7lN5qPGVGHMqUW/r6EEkPyaIto4=;
	b=PdngeRsePFKpRSDyXLiOIcYNhltfQSNEmO4lJqCiMOvOmf+On2eUDbMSSuiZ+k38iZOgdb
	/xV6tNppSbu2srAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763482101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDreU/3vuQGNhmus7lN5qPGVGHMqUW/r6EEkPyaIto4=;
	b=zPc1LufgUOjNNHnV89jtHoaIFyr5LffiJoEGQL+qfMVWjSsGExwu8ggGoj/gjyDUgEYOLU
	WCI8GRzJvXb1a3GfiHWRxQ+dMgktbNpOwme98hCvnZUoUA0ZJ/SKT6gEZDGqTjXikDopQ2
	H/bYVgXfySpdfc3w7PJKBEpWrDtpyVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763482101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDreU/3vuQGNhmus7lN5qPGVGHMqUW/r6EEkPyaIto4=;
	b=PdngeRsePFKpRSDyXLiOIcYNhltfQSNEmO4lJqCiMOvOmf+On2eUDbMSSuiZ+k38iZOgdb
	/xV6tNppSbu2srAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 236C93EA61;
	Tue, 18 Nov 2025 16:08:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hpfTBfWZHGm2YAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 18 Nov 2025 16:08:21 +0000
Message-ID: <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>
Date: Tue, 18 Nov 2025 17:07:56 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251118111657.12003-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251118111657.12003-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 11/18/25 12:16 PM, Florian Westphal wrote:
> This series fixes false negative lookup bug in rbtree set backend that
> can occur during transaction.
> 
> First two patches prepare for actual fix, which is coming in last patch.
> 
> All inserts/removals will now occur in a cloned copy, so packetpath can
> no longer observe the problematic mixed-bag of old, current and new
> elements.
> 
> The live tree will only have reachable elements that are active in the
> current generation or were active in the previous generation (but are still
> valid while packetpath holds rcu read lock).  The latter case is only
> temporary, as new lookups already observe the updated tree).
> 

Hi Florian,

I have been taking a look to the series and testing it with different 
set sizes. The implementation looks good to me but I noticed that due 
the new "clone" mechanism there is an impact on performance when 
modifying an existing rbtree set (inserts or deletions). According to my 
number the impact would be around 40~%. Usually that isn't problematic 
but if big sets are used.. then it is a bit more. e.g

200K elements ~ avg. time insertion before 510ms after 744ms
500K elements ~ avg. time insertion before 5460ms after 7730ms

I was wondering if there could be a different solution.. what if we keep 
both trees synchronize? Would that be possible? Initially root[0] and 
root[1] can be identical and root[0] is the "live" tree.

When adding a new element, it is inserted into the cloned copy and we 
swap the genbit so root[1] is now live. Then, when we are sure that the 
operation was successful, we update root[0] with the same operation. 
Therefore, root[0] and root[1] are now identical.

This way we can avoid the clone operation which is quite expensive.. of 
course, it would require to do the insert/removal operation twice.. but 
that is cheaper if I am not wrong.

Maybe I am asking for too much (?). Also it brings some problems.. like 
what if the sync operation fails, should we re-do the cloning?

Thanks,
Fernando.

> Florian Westphal (3):
>    netfilter: nft_set_rbtree: prepare for two rbtrees
>    netfilter: nft_set_rbtree: factor out insert helper
>    netfilter: nft_set_rbtree: do not modifiy live tree
> 
>   net/netfilter/nft_set_rbtree.c | 279 +++++++++++++++++++++++++--------
>   1 file changed, 211 insertions(+), 68 deletions(-)
