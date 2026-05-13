Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B7E1F5821
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778680120; cv=none; b=LJ+ER9PEEuqA4PX9wKo8QMi/2kv2HlGy2+vROqmgk7L0SjrocEDtRU/Q4Gk6kYhIu9R6twjy8tuvgz6PFZAHALbxqVJwG1DrALPZrjRH21cORY4x73/zy4CJBdhwxpt49SqTPj3SCVTXDa/QsFgIFF9igD0jaoxvIGd4FpO6g4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778680120; c=relaxed/simple;
	bh=PR9MzK22p1HiI3CUHwcN0KprVQDFi2v/yO4KZr79TQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GUsGNZNkXHMFX2kDWwpTYga3HGqlKGCwnuv6tuLEI9zONPxgXC1MceEtaN3tunxdmAtPY8zEYlkPVWx9h42oHevUn6KtRo57JUbvOvjAsftfGFg3xFncHPjxIA6GHnRujfJLjSOaZ5vD+HWuXfghve8D0yYCjt8T6kfNHxuWEj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zsFzsUJ1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fbQbrq4B; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zsFzsUJ1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fbQbrq4B; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zsFzsUJ1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fbQbrq4B";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zsFzsUJ1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fbQbrq4B"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB1DE5D38B;
	Wed, 13 May 2026 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778680116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2j6LlDXbPaXzkFY9TL634Vq0u22LWtgBvCYDqJqT/o=;
	b=zsFzsUJ1n177udz11x74soyRYvctgI1BCFs30XVtfU0Djn6wc8fzyjq7ZD2QHkI80B2M3+
	yDrSzL0GyDvaxJ7XeJZT1nni0fIAyHxAgoEmajBHnH4+8A8bPQbKl35wNHA6XYuKq7rS6b
	0HzKCuInnfP9j2VkuVg3sqGoFjPgvmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778680116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2j6LlDXbPaXzkFY9TL634Vq0u22LWtgBvCYDqJqT/o=;
	b=fbQbrq4BL9zxC8EIZ1OYWiYfhFmFhzubqU/MBFFMcIzLDBaBwFwFODJuxWu3unly+2/jin
	YGOkW5A7HQn9i2Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778680116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2j6LlDXbPaXzkFY9TL634Vq0u22LWtgBvCYDqJqT/o=;
	b=zsFzsUJ1n177udz11x74soyRYvctgI1BCFs30XVtfU0Djn6wc8fzyjq7ZD2QHkI80B2M3+
	yDrSzL0GyDvaxJ7XeJZT1nni0fIAyHxAgoEmajBHnH4+8A8bPQbKl35wNHA6XYuKq7rS6b
	0HzKCuInnfP9j2VkuVg3sqGoFjPgvmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778680116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2j6LlDXbPaXzkFY9TL634Vq0u22LWtgBvCYDqJqT/o=;
	b=fbQbrq4BL9zxC8EIZ1OYWiYfhFmFhzubqU/MBFFMcIzLDBaBwFwFODJuxWu3unly+2/jin
	YGOkW5A7HQn9i2Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 677E3593A9;
	Wed, 13 May 2026 13:48:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L5eMFjSBBGqHcgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 13 May 2026 13:48:36 +0000
Message-ID: <7fbd428e-93b7-4e17-8360-5434f0d1f6bc@suse.de>
Date: Wed, 13 May 2026 15:48:25 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_conncount: prevent connlimit drops for
 early confirmed ct
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
 pablo@netfilter.org,
 Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
References: <20260513121547.6434-1-fmancera@suse.de>
 <agRygM7hHtKs8jQB@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <agRygM7hHtKs8jQB@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.80



On 5/13/26 2:45 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>   	if (ct && nf_ct_is_confirmed(ct)) {
>> -		/* local connections are confirmed in postrouting so confirmation
>> -		 * might have happened before hitting connlimit
>> -		 */
>> -		if (skb->skb_iif != LOOPBACK_IFINDEX) {
>> +		if (test_bit(IPS_ASSURED_BIT, &ct->status) || ctinfo == IP_CT_ESTABLISHED) {
>>   			err = -EEXIST;
>>   			goto out_put;
>>   		}
> 
> IIRC IP_CT_ESTABLISHED requires we can observe traffic in both
> directions.  I'm not sure it was a good idea to allow this new
> usage case added in 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped"),
> but I don't think we can revert it either :-(
> 

Whether allowing or not, it was already being used as the tcp --syn 
requirement was never enforced. This currently fixes it in most of the 
situations, we just missed an edge case.

The proposed solutions should be fine as it covers:

1. Standard connlimit usage with tcp --syn for both local/non-local 
connections and input/output hooks

2. soft-limiting connlimit usage without tcp --syn on both 
local/non-local connections and input/output hooks

3. OVS zone limits (this is actually like scenario 1.)

It also covers re-use of sockets in TIME_WAIT and fixes hotdrops for 
outgoing already tracked connections when doing softlimiting in the 
INPUT hook. Of course, it prevents the double tracking even for 
retransmissions.

About IP_CT_ESTABLISHED, I added it because it was not clear to me that 
IPS_ASSURED_BIT is always set. I guess yes for TCP/UDP but what about 
other protocols? (Are we supporting other protocols???) Anyway, I have 
tested it and confirmed that for TCP/UDP it is safe to drop it.

And please note that the idea is to be cautious when returning --EXIST. 
If IPS_ASSURED_BIT is set we can for sure skip the tracking BUT if not, 
we run a GC skipping the skip optimization..

FWIW; I run a test with 60k connections and no warnings/drops/dup 
tracking seen.

> No idea how to fix this mess.

Is it that bad? I mean, it has some back and forth and I apologize for 
that but overall this is fixing some real use cases.

Thanks for the patience Florian,
Fernando.
