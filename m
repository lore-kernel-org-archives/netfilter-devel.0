Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014BC13DBA0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 15:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765900117; cv=none; b=udN7tOwH0Fqq2zdWChytTULOKkR3a9KgcsEA7jwi3RD6Tfr0p4ZOfOKmMjBSg8iQERvTyI30pjFjbdW6LW/nSWiZY5Tc5qyNOMZVHF4KIrzeQJbwiTC+r0wfAL8gJ19USQtsGofYYNqAb1E4I77Cfz/89sBIWv1Kgw0MVA1YqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765900117; c=relaxed/simple;
	bh=R2g97mNCRrvrYaIM22ANO4NmPdHE86TVldDcNwfVboM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uzXSaheWmNDGAV66d1SqdnQx1MPzyqZh6NIouoZSXck96ukrVGkuy6cwB3Na3Mja2YjjHqMJfNbu731rh+FiXCTZYzD5WR3DNBJHqJ+6dMFYIHPQIiwBgmaI4/+1ANG1BOlDfCe519xqxQXNHoItEcFgKsdRUUtNYBIxpELRBTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xJ6CzQZo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=26ChiWBh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xJ6CzQZo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=26ChiWBh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xJ6CzQZo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="26ChiWBh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xJ6CzQZo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="26ChiWBh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2929D33717;
	Tue, 16 Dec 2025 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765900114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pwQLQradpgu7utrA+kTEhIXbNLXV9kJ1SQ4926carA=;
	b=xJ6CzQZo5TZoXTLUFhE6V8sAGbyhXRRjlnB6nKFY2kV91WbJ262INqU7RlyVysC5VcriJE
	Hn6cvdUCtjlZyL0OFdfSbu/e8RbZCZK8UdE1V8su65U6gNOoKnXpM/ysCEeIGdr8EQJTQR
	lLNFTOoJJZNR1aL8ma2jkEIm1xqgAl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765900114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pwQLQradpgu7utrA+kTEhIXbNLXV9kJ1SQ4926carA=;
	b=26ChiWBh0H7On5aRSUmOdW/Af5hjA4Aa2OCtExB7D9YzQJeu/J2DFGM4w/0brIkABKBqnn
	PqUd6nUXpWtBllBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765900114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pwQLQradpgu7utrA+kTEhIXbNLXV9kJ1SQ4926carA=;
	b=xJ6CzQZo5TZoXTLUFhE6V8sAGbyhXRRjlnB6nKFY2kV91WbJ262INqU7RlyVysC5VcriJE
	Hn6cvdUCtjlZyL0OFdfSbu/e8RbZCZK8UdE1V8su65U6gNOoKnXpM/ysCEeIGdr8EQJTQR
	lLNFTOoJJZNR1aL8ma2jkEIm1xqgAl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765900114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+pwQLQradpgu7utrA+kTEhIXbNLXV9kJ1SQ4926carA=;
	b=26ChiWBh0H7On5aRSUmOdW/Af5hjA4Aa2OCtExB7D9YzQJeu/J2DFGM4w/0brIkABKBqnn
	PqUd6nUXpWtBllBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 493ED3EA63;
	Tue, 16 Dec 2025 15:48:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ERAiCFF/QWluFAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 16 Dec 2025 15:48:33 +0000
Message-ID: <4c702f96-99bd-457c-881d-48402c4015c3@suse.de>
Date: Tue, 16 Dec 2025 16:48:25 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
References: <20251216122449.30116-1-fmancera@suse.de>
 <aUFgyOkfh8e8vx_Z@strlen.de> <3f651847-9a0e-4007-8790-ffacd90f6e32@suse.de>
 <aUF59KJs9ghiGBdR@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aUF59KJs9ghiGBdR@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.807];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.26

On 12/16/25 4:25 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> This sounds quite expensive to me. What about the following solution?
>>
>> 1. In nf_conncount_list, add "unsigned int last_gc_count"
>> 2. In __nf_connncount_add the optimization would look like this:
>>
>> 	if ((u32)jiffies == list->last_gc && (list->count - list->last_gc_count) >=
>> CONNCOUNT_GC_MAX_NODES - 1)
>> 	goto add_new_node;
> 
> Won't that rescan the same entries for as long as the condition
> persists?
> 
> That was the reason for the move-to-tail, so we start with something
> that we did not scan yet.
> 

I do not follow here. AFAICT, the current loop is only breaking if 
collect is greater than CONNCOUNT_GC_MAX_NODES. That means, the loop 
must find 8 closed connections or 8 errors (very unlikely) while trying 
to find the connection. If no connection is closed, the whole list is 
scanned.

Also, it makes sense to start from the first element always as I guess 
the longer the connection has been opened the more likely is that is 
about to close.

I tested this quickly and seems to solve the problem too for a huge 
amount of connections (20000+). As the new adds while skipping the GC 
will never be bigger than what we are able to clean up during a GC.

>> 3. After gc, we update the list->last_gc_count.
>>
>> This way we make sure the optimization is not done if 7 or more connections
>> were added to the list.
> 
> How many entries could be expected per seconds?  I think "tens of
> thousands" is possible. If not, then just increasing the GC_MAX_NODES
> would work.
> 

Yes that is right. FWIW, I believe that if we match the amount in 
netdev_budget we should be fine. But that seems like overkill to me.

> If we can't make this work, no choice but to add a destructor callback
> to conntrack... I very much dislike that idea.
> 

Yes, I do not like that neither.

>> It should ensure that the list does not fill up. For
>> better optimization, we can increase the number to 64 as I proposed. The
>> solution you proposed works too but I am worried that it will trigger a CPU
>> lockup for a big amount of connections..
> 
> You could add "start = jiffies" and break on "jiffies != start",
> which would split the gc over multiple add requests.
