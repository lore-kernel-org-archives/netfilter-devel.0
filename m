Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60E8364E8B
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Nov 2025 17:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485286; cv=none; b=qfXlLGTAAt4EcOtzL6PxbVQBAgYrwk5VRTVBv1jZau0qEn+49VMzR698LI5RvbZ1+O3w5/XZSMZW1+UZ/anWGVAqaPT4RxwwZufp4VvOkKhQoqS/wgdxGfDCqUMPho3iTJBo4srOdY/elHS0o7MQZyLQmsxEC//A1TllcTsiVJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485286; c=relaxed/simple;
	bh=5Vukuz4t38uWZDdynInsGxvh8d6CZjpi4BeKef4SlOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QjixqNUJUkj21At1hTsAJ2OfSHUdIfMP95v8uX/Z+8/1oAJ+Bpn3SHBRHq0U297Kh/8GYMlcnWgyJ3tN8uDObZRwUFbyN/pb+WvaFhkgom1Ap0Spi6WrqTfwzWR8qzO5/E8Tqd8ADzIBKdTMKXE0GiNIyoNjzQElMX2mtYvAHik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HQXHtK+m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TUd2m82s; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HQXHtK+m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TUd2m82s; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HQXHtK+m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TUd2m82s";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HQXHtK+m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TUd2m82s"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C23C1FFBB;
	Tue, 18 Nov 2025 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763485278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWgywMRbOVkCqpR/HxkMUbpepOgzZNziX2gZdsVjQSM=;
	b=HQXHtK+mUeh1YfnM6pAST7TA9Vwogy0AA7WcztBg3JWMENO0y21BNOd3g57mMixYcGWc9z
	6XkCETQZatfbHvJdWFTtYbCtUjODds8UAg8xOtkYA00ufCxyYxGPkn2r/uxtW50JUbQgJ4
	3rP+xC4Y8+wT0OYofY+oaE4S5HisRew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763485278;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWgywMRbOVkCqpR/HxkMUbpepOgzZNziX2gZdsVjQSM=;
	b=TUd2m82sI0SqZgrG24v0JArVAVmnfEOcARO32rbs2fOsYXRm8zViSH0eoad/uv4yZz9E+M
	JFbDYciUSgPgifBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763485278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWgywMRbOVkCqpR/HxkMUbpepOgzZNziX2gZdsVjQSM=;
	b=HQXHtK+mUeh1YfnM6pAST7TA9Vwogy0AA7WcztBg3JWMENO0y21BNOd3g57mMixYcGWc9z
	6XkCETQZatfbHvJdWFTtYbCtUjODds8UAg8xOtkYA00ufCxyYxGPkn2r/uxtW50JUbQgJ4
	3rP+xC4Y8+wT0OYofY+oaE4S5HisRew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763485278;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWgywMRbOVkCqpR/HxkMUbpepOgzZNziX2gZdsVjQSM=;
	b=TUd2m82sI0SqZgrG24v0JArVAVmnfEOcARO32rbs2fOsYXRm8zViSH0eoad/uv4yZz9E+M
	JFbDYciUSgPgifBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 733433EA61;
	Tue, 18 Nov 2025 17:01:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BIFoGV6mHGnyFQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 18 Nov 2025 17:01:18 +0000
Message-ID: <c32029ff-17e4-44a5-8986-970d0156aef8@suse.de>
Date: Tue, 18 Nov 2025 18:01:13 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20251118111657.12003-1-fw@strlen.de>
 <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de> <aRyi5VVq6HKTvEDm@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aRyi5VVq6HKTvEDm@strlen.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 11/18/25 5:46 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> When adding a new element, it is inserted into the cloned copy and we
>> swap the genbit so root[1] is now live. Then, when we are sure that the
>> operation was successful, we update root[0] with the same operation.
>> Therefore, root[0] and root[1] are now identical.
> 
> I don't understand this.  The swap can't be done before ->commit().
> Else, how do you deal with a rollback (failing transaction)?
> 
> Not exposing any of the new elements to the data path until
> the entire transaction has moved past the point-of-no-return
> is large part of the patch series.
> 

Right, that is good point, the swap must happen after commit.

> After commit, yes, we can do a walk of the old tree, purge
> old elements, then walk the new tree, add new elements to the old
> tree so they are identical again.
> 
> But that doesn't sound faster than duplicating everything
> on next insert/removal.
> 

Of course, if walking the old/new tree is required then it is not 
better. I guess, a possibility would be to keep track of the performed 
operations (elements added/deleted) to perform the updates after commit 
but to be honest that would be quite cumbersome and would require 
infrastructure for bookkeeping. I think we should not consider it.

>> This way we can avoid the clone operation which is quite expensive.. of
>> course, it would require to do the insert/removal operation twice.. but
>> that is cheaper if I am not wrong.
> 
> How do I know what to re-insert and to remove from the old live tree
> without a walk of the new tree?
> 
>> Maybe I am asking for too much (?). Also it brings some problems.. like
>> what if the sync operation fails, should we re-do the cloning?
> 
> How can the sync op fail?  Can you elaborate?
> 

I was thinking in not enough memory situations (unlikely but possible). 
Anyway, given the constraints we have on hands I do not think my idea is 
suitable.

In addition, the performance impact happens on control-plane operations 
so it should be fine I guess as it isn't a hot path.

So never mind, the series is fine and after some testing on it no 
serious issues found so far.
