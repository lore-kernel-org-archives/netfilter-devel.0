Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B293D8910
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226312; cv=none; b=Ci2bdvGoqwGFuI1o6bUseb486SvFZo8ZldTOSc6Jx1+oNIesdGODNZiFJ6qyw+VKdhKg3Y6i/RlKwRHUfyvcdihNs8mubv+SbYhfXfZWtOiO991ro4BPPeDy8by3U/jKHl54nWmMv9fbsVWxKEtcxH9F99sCo88LlYjnTNV34cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226312; c=relaxed/simple;
	bh=Abqi4jAI7Coy1fx2jeFT6CmpkXoWJIffpO6n3+LxZfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUomPrdRjgbGms/AZ2G/yNgwWmAqNhJxJPfvr7fXmrq5hxtK2rtqnAqw6nXghnnHzNqPUMBB5tVXTMLOp1al/84CNl4CP8fx+LapUKZR3Ku006KF/ZZ6AEKZ8TYlaZzJNj0OmUlDi36tnssN0mIcuvvjkWgS11rHwLFVW4I+z8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0+t6NGyw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=//o3XtjL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0+t6NGyw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=//o3XtjL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0+t6NGyw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="//o3XtjL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0+t6NGyw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="//o3XtjL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B762B6AF5B;
	Tue, 19 May 2026 21:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779226308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LTnKfazDkTDw5Mv9O+Ncx2ABEoWWOVz5n9wiRMLo7YE=;
	b=0+t6NGywwk+of1Mm41Op6apHo59IahfoQkrbPB09mhFwbCFQ4Mn/GfJnDlDPysSM9QOOHJ
	DFAYrPOJ5i1WD5JqvRvS31ZWp9y3ZWzN57SQ/SiwH+ROsljehGSEfvRpxqZUvzCqOCM3bw
	0snneaXOf0Q6vXLP5RvtJ3tsX23d0I8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779226308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LTnKfazDkTDw5Mv9O+Ncx2ABEoWWOVz5n9wiRMLo7YE=;
	b=//o3XtjLOeRhIPVpdmip7xFhoPNV6aGTf+bsBpkN9qqlFRV4FXj8j5l8IsJ7r59RJs/Ipe
	m24q1YHJbXLg/vAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779226308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LTnKfazDkTDw5Mv9O+Ncx2ABEoWWOVz5n9wiRMLo7YE=;
	b=0+t6NGywwk+of1Mm41Op6apHo59IahfoQkrbPB09mhFwbCFQ4Mn/GfJnDlDPysSM9QOOHJ
	DFAYrPOJ5i1WD5JqvRvS31ZWp9y3ZWzN57SQ/SiwH+ROsljehGSEfvRpxqZUvzCqOCM3bw
	0snneaXOf0Q6vXLP5RvtJ3tsX23d0I8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779226308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LTnKfazDkTDw5Mv9O+Ncx2ABEoWWOVz5n9wiRMLo7YE=;
	b=//o3XtjLOeRhIPVpdmip7xFhoPNV6aGTf+bsBpkN9qqlFRV4FXj8j5l8IsJ7r59RJs/Ipe
	m24q1YHJbXLg/vAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F7AD593A8;
	Tue, 19 May 2026 21:31:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x91JJsTWDGpXBgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 19 May 2026 21:31:48 +0000
Message-ID: <35fd02b9-468c-40bd-86bc-833be7abda89@suse.de>
Date: Tue, 19 May 2026 23:31:43 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nf_conncount: prevent connlimit drops
 for early confirmed ct
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
 pablo@netfilter.org,
 Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
References: <20260514141628.4636-1-fmancera@suse.de>
 <agzGsaehgIuc0vIT@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <agzGsaehgIuc0vIT@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,nwl.cc,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -2.80

On 5/19/26 10:23 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Commit 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add
>> was skipped") introduced a regression where packets for valid
>> connections are dropped when using connlimit for soft-limiting
>> scenarios.
>>
>> The issue occurs when a new connection reuses a socket currently in
>> the TIME_WAIT state. In this scenario, the connection tracking entry
>> is evaluated as already confirmed. Previously, __nf_conncount_add()
>> assumed that if a connection was confirmed and did not originate from
>> the loopback interface, it should skip the addition and return -EEXIST.
>>
>> Skipping the addition triggers a garbage collection run that cleans up
>> the TIME_WAIT connection. Consequently, the active connection count
>> drops to 0, which xt_connlimit mishandles, leading to the false rejection
>> of the perfectly valid new connection.
> 
> What do you make of https://sashiko.dev/#/patchset/20260514141628.4636-1-fmancera%40suse.de
> 
> Is there a way to handle this with a different solution?
> I don't see a good solution.   What about making
> __nf_conncount_gc_list() return the number of removed elements and allow
> a single re-add attempt if we released some entries?
> 
> (Note that I don't think that conncount with unidirectional traffic
>   is a sensible thing to configure, but I can't say "not supported"
>   either...)

Ugh I read it and to be honest, I am not sure this is valid feedback. 
The problematic thing here would be that GC is always called.. which is 
fine?

I can try to generate 50k connections and generate unidirectional 
traffic to understand the consequences but I expect that it will not be 
that bad.

Let me get back to you..

Thanks Florian!

