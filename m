Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698C4310625
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2025 08:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761900910; cv=none; b=f1K6sEA3gz94b74PTb2OjV9jWfilxP1t6rRi0Qa90GJZO9vnWwwF0koGqoLiXsZDWE7/jYACmkMpu1DIypZoq19xmlT/IJOEXixWxvUnMiuaU4baSF0NbITe0Li9TSBvtPhYoMhbaM0wWuw+F6Zd3qOvxuCpUys++4O/w2xaMrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761900910; c=relaxed/simple;
	bh=1MbyiaM0CI13y5zCe5OSZyLt/kQ7HZpjOem4gCVDSeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=adqU4UkWbz1pYOS9fgHrZLQuFKrG2RAsw0sL49kDxTAaItdteaD6u88LZHUGxxS6Ut7lPGWh3ge9QVfdz63uu8Keb6aGoGiazTDycMbqvJ1Nyd76NoSkmONOV+pzwjA7YQe9XsR73vNmasxBt7a+JgXHgNDJFrYyOmIiVRO6IYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wB5WvpEg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d3Hm1ZMv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wB5WvpEg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d3Hm1ZMv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wB5WvpEg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d3Hm1ZMv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wB5WvpEg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d3Hm1ZMv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF2FB222F1;
	Fri, 31 Oct 2025 08:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761900900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3PMUM+fnH4DGcmOwnLEW6N/O1hyhjilxGFPyCJAaoIg=;
	b=wB5WvpEgPQqCwGt2+09gwW0fuFa0yyCNuiDzHMfbAwZVa3mLlEHS6rRS+vmYxmdw93PyA1
	jOSU0t8ojensdL4rGjFpxjCR6d0XgpnnE3q54LiaEkFLDnhV/5iIpJjpdj7eWxB/M0s3Dy
	iF1APOWJoUTn2h+8/EzHnT8ZVSA1jSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761900900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3PMUM+fnH4DGcmOwnLEW6N/O1hyhjilxGFPyCJAaoIg=;
	b=d3Hm1ZMvro/+G2ob+wrggyADJVfCJq5gVKNVhDXIafhTpOIyJVYo+XdYUhvEXGmoRfMVN9
	tzda3vnEPBaSZ8BA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761900900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3PMUM+fnH4DGcmOwnLEW6N/O1hyhjilxGFPyCJAaoIg=;
	b=wB5WvpEgPQqCwGt2+09gwW0fuFa0yyCNuiDzHMfbAwZVa3mLlEHS6rRS+vmYxmdw93PyA1
	jOSU0t8ojensdL4rGjFpxjCR6d0XgpnnE3q54LiaEkFLDnhV/5iIpJjpdj7eWxB/M0s3Dy
	iF1APOWJoUTn2h+8/EzHnT8ZVSA1jSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761900900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3PMUM+fnH4DGcmOwnLEW6N/O1hyhjilxGFPyCJAaoIg=;
	b=d3Hm1ZMvro/+G2ob+wrggyADJVfCJq5gVKNVhDXIafhTpOIyJVYo+XdYUhvEXGmoRfMVN9
	tzda3vnEPBaSZ8BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A08F113393;
	Fri, 31 Oct 2025 08:55:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MqWCJGR5BGlCOgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 31 Oct 2025 08:55:00 +0000
Message-ID: <3489517f-90e7-4923-b773-d68a362dc52d@suse.de>
Date: Fri, 31 Oct 2025 09:55:00 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2] netfilter: nft_connlimit: fix duplicated tracking
 of a connection
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
References: <20251029132318.5628-1-fmancera@suse.de>
 <aQJ6AysjCMTHLzsP@calendula> <c58ae9ad-46f3-4853-bc61-ac725c860160@suse.de>
 <aQPvFHEYZYacJQcC@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQPvFHEYZYacJQcC@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/31/25 12:04 AM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Thu, Oct 30, 2025 at 09:12:32AM +0100, Fernando Fernandez Mancera wrote:
>>
>> On 10/29/25 9:33 PM, Pablo Neira Ayuso wrote:
>>> Hi Fernando,
>>>
>>> On Wed, Oct 29, 2025 at 02:23:18PM +0100, Fernando Fernandez Mancera wrote:
>>>> Connlimit expression can be used for all kind of packets and not only
>>>> for packets with connection state new. See this ruleset as example:
>>>>
>>>> table ip filter {
>>>>           chain input {
>>>>                   type filter hook input priority filter; policy accept;
>>>>                   tcp dport 22 ct count over 4 counter
>>>>           }
>>>> }
>>>>
>>>> Currently, if the connection count goes over the limit the counter will
>>>> count the packets. When a connection is closed, the connection count
>>>> won't decrement as it should because it is only updated for new
>>>> connections due to an optimization on __nf_conncount_add() that prevents
>>>> updating the list if the connection is duplicated.
>>>>
>>>> In addition, since commit d265929930e2 ("netfilter: nf_conncount: reduce
>>>> unnecessary GC") there can be situations where a duplicated connection
>>>> is added to the list. This is caused by two packets from the same
>>>> connection being processed during the same jiffy.
>>>>
>>>> To solve these problems, check whether this is a new connection and only
>>>> add the connection to the list if that is the case during connlimit
>>>> evaluation. Otherwise run a GC to update the count. This doesn't yield a
>>>> performance degradation.
>>>
>>> This is true is list is small, e.g. ct count over 4.
>>>
>>> But user could much larger value, then every packet could trigger a
>>> long list walk, because gc is bound to CONNCOUNT_GC_MAX_NODES which is
>>> the maximum number of nodes that is _collected_.
>>>
>>> And maybe the user selects:
>>>
>>>     ct count over N mark set 0x1
>>>
>>> where N is high, the gc walk can be long.
>>>
>>> TBH, I added this expression mainly focusing on being used with
>>> dynset, I allowed it too in rules for parity. In the dynset case,
>>> there is a front-end datastructure (set) and this conncount list
>>> is per element. Maybe there high ct count is also possible.
>>>
>>> With this patch, gc is called more frequently, not only for each new
>>> packet.
>>>
>>
>> How is it called more frequently? Before, it was calling nf_conncount_add()
>> for every packet which is indeed performing a GC inside, both
>> nf_conncount_add() and nf_conncount_gc_list() return immediately if a GC was
>> performed during the same jiffy.
> 
> Before this patch, without 'ct state new' in front, this was just
> adding duplicates, then count is wrong, ie. this is broken.
> 
> Assuming 'ct state new' in place, then gc is only called when new
> entries for the initial packet of a connection (still broken because
> duplicates due to retransmissions are possible).
> 
> My proposal:
> 
> - Follow a more conservative approach: Perform this gc cycle for
>    confirmed ct only when 'ct count over' evaluates true or 'ct count'
>    evaluates false.
> 

I like this in particular because it would save CPU.. as long as the 
condition is not met AFAIU we don't need to check if the list is updated 
or not.

This would be easy to add to the proposed patch.

> - For the confirmed ct case, stop gc inmediately when one slot is
>    released to short-circuit the walk.
> 

I guess we care only about long lists.. maybe as Florian said stopping 
after 8 collects is enough. We could reduce it if needed.

> ... but still long walk could possible.
> 
> - More difficult: For the confirmed ct case, add a limit on the
>    maximum entries that are walked over in the gc iteration for each
>    packet. If no connections are found to be released, annotate the
>    entry at which this stops and a jiffy timestamp, to resume from where
>    the gc walk has stopped in the previous gc. The timestamp could be
>    used to decide whether to make a full gc walk or not. I mean, explore
>    a bit more advance gc logic now that this will be alled for every
>    packet.

My proposal is to defer all the changes to nf_conncount.c to a follow-up 
patch on nf-next. As there are more users of this, it seems risky to me 
to change the logic on rc4 or greater. What if I send a v3 with the 
change mentioned above to save some CPU cycles and then we move forward 
the discussion in a series for nf-next? Do you agree?

Thanks,
Fernando.
