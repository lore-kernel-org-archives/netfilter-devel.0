Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E0333A9CA
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765897796; cv=none; b=bGx4eKEhq6GmvOboo2L3R9NXhA8m8YMhO+9HASqJmR7rdCwp8VfQ8w3EhM/ZG0VS8pOu26bZDjOHD+rfME16KRFs1cfh5ZB3+gMiYiiIa7reYmAHCq9fRcaSR/cOtlG0FvFRCQPO5G3ILoWaSxrzcYzutI1lvG50GgHDPwox/1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765897796; c=relaxed/simple;
	bh=U3W0Wsbu+Yw1jtK9ZofG8LinxRreb7fNUygA7XpSk+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iow0oLFh7nYr5svqNPyMwMF4Lmd3UBcyk9E33gTzXtlXQOsT39dT/BCe+6/qKlJPWiAgcbdQyKu0IhoIrH4EQJuBA//V9Tmjl81hmQzjXW+B6nHTojd35ouANJ3ThtsZXUW3O6Ca2QgoRok9AK9cAYOsV7M9L8vA+a4ExOsCuKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OMWmBBja; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kdBf/DgQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=r6AH/LlX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zWcVUMd3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OMWmBBja";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kdBf/DgQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="r6AH/LlX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zWcVUMd3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 57DE43372B;
	Tue, 16 Dec 2025 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765897790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMS+lKVynRuvbaXhjLqzV331fJ1scIPtcsIdAl7pukw=;
	b=OMWmBBjafX1l3lc9I9xcRRlWX+0Uy2Mc0/GEV7Eqjbd0B6dfZovR0Pd1p4dsroXPqgJoOI
	J17CWyT++ODROou/xkNiwe4GA9dI/s0s6fADRn8pq4nTOQfbmALLI1C+swIQ40FHJHlbS+
	0wFrAi/a205PHOazjqNty4SMhDhdEyc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765897790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMS+lKVynRuvbaXhjLqzV331fJ1scIPtcsIdAl7pukw=;
	b=kdBf/DgQoBgQfxacF3SmFvt4GXLaWx16f2Dj1OpMmJsV2V4pzX3X6fKOslg9uIxC8l7lAF
	jbDjgK+Er+4EuMBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="r6AH/LlX";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zWcVUMd3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765897789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMS+lKVynRuvbaXhjLqzV331fJ1scIPtcsIdAl7pukw=;
	b=r6AH/LlXbU6xcdELiVLUawlOsDSoL18H9BWYaWaLx3V1enNUXBly/m7H6zWZ320maULJrE
	m1KXnjJlEeRtb8dqQhLoPm7N9r7X7dbUX4PE4daMTDzCoNUJFOphIFqWklWFAETJXoU4xr
	M8SthYXekXW37v7WqyZyk54de0jvApw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765897789;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMS+lKVynRuvbaXhjLqzV331fJ1scIPtcsIdAl7pukw=;
	b=zWcVUMd3d4oOivz0l9pqoH1t9ataaQ3XgjwfObook5aeygRXVIeYTS/QPBdVqud4/pNZSQ
	4qrrE34iTv/AH7Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10A2D3EA63;
	Tue, 16 Dec 2025 15:09:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uDHBAD12QWkmcAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 16 Dec 2025 15:09:49 +0000
Message-ID: <3f651847-9a0e-4007-8790-ffacd90f6e32@suse.de>
Date: Tue, 16 Dec 2025 16:09:25 +0100
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
 <aUFgyOkfh8e8vx_Z@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aUFgyOkfh8e8vx_Z@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 57DE43372B
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 



On 12/16/25 2:38 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> After the optimization to only perform one GC per jiffy, a new problem
>> was introduced. If more than 8 new connections are tracked per jiffy the
>> list won't be cleaned up fast enough possibly reaching the limit
>> wrongly.
>>
>> In order to prevent this issue, increase the clean up limit to 64
>> connections so it is easier for conncount to keep up with the new
>> connections tracked per jiffy rate.
> 
> But that doesn't solve the issue, no?
> Now its the same as before, just with 64 instead of 8.
> 
> I think that more work is needed.
> 
>>   /* we will save the tuples of all connections we care about */
>>   struct nf_conncount_tuple {
>> @@ -187,7 +188,7 @@ static int __nf_conncount_add(struct net *net,
>>   
>>   	/* check the saved connections */
>>   	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
>> -		if (collect > CONNCOUNT_GC_MAX_NODES)
>> +		if (collect > CONNCOUNT_GC_MAX_COLLECT)
>>   			break;
> 
> I see several options.
> One idea that comes to mind:
> 
> 1. In nf_conncount_list, add "unsigned int scanned".
> 2. in __nf_conncount_add, move alive elements to the tail.
> 3. For each alive element, increment ->scanned.
> 4. break if scanned >= list->count.
> 5. only set last_gc if "->scanned >= list->count" (and set scanned to 0).
> 

Hi Florian,

This sounds quite expensive to me. What about the following solution?

1. In nf_conncount_list, add "unsigned int last_gc_count"
2. In __nf_connncount_add the optimization would look like this:

	if ((u32)jiffies == list->last_gc && (list->count - 
list->last_gc_count) >= CONNCOUNT_GC_MAX_NODES - 1)
	goto add_new_node;

3. After gc, we update the list->last_gc_count.

This way we make sure the optimization is not done if 7 or more 
connections were added to the list. It should ensure that the list does 
not fill up. For better optimization, we can increase the number to 64 
as I proposed. The solution you proposed works too but I am worried that 
it will trigger a CPU lockup for a big amount of connections..

What do you think?

> Before this only-one-gc-run-per-jiffy we always collected for each new
> tracked entry, and hence we never had the "fills up" problem.
> 
> Maybe it would be possible to also apply this scheme to gc_list()
> helper.

