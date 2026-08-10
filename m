Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1870935C695
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 09:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786355050; cv=none; b=kYJ3POlw2OW5f0hps7Fd5WrKXV4wtOuTLsl2OeTd/Qjb7yHVSa0KWeqaDfXSUB1BohPCFD2WspZHt8+UTrfJZlHpoJo0VJk8BbpPoNxeM5Fjfe//9iV+5CK1tFOo+V0oWTuatLTQvyZuQIDcjn9qBTnZh8tNV7tD7VYFVez6GQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786355050; c=relaxed/simple;
	bh=V/jZZJOLsEPNHFPyAPO0Ca5aROhFjMYUJbRrtqST3D0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvGqYbIWI0+yx5/q2Jx9o0LpIhSsR2rh/wupzchasIZqEnMSv4NJUK27wSE/ixRb1AxSyRGgLxhXxi0F3DX8dd2AsGCBdMnU7D6uoop1GLpKzq/R0tE7vL1gTUIpXHTn5TUeDU3eEujRWArMX1/lEWiSccBOZJkzvGs+eSR4uUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0yxqoqbT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T2va0ds1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=V4ssd1WI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lW+Kvuc+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0yxqoqbT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T2va0ds1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="V4ssd1WI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lW+Kvuc+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E080844CD;
	Mon, 10 Aug 2026 09:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786355043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pia9qcwDWHFbiRVmP1j5XSZyL4A3HBfRqe0yBhxM1CE=;
	b=0yxqoqbTXKXGLJBbnxVUbScaKA7oosQsF2tOpr757BrAjfdnqtAYi/PJoP1ynVr4Y/TOfX
	GVI/5qYiYLyF/XFHxynQZd8gJOG/O1WPzJ9chGDo5X38suAyifMy51YebLOeFdaLFCUkL8
	Rp4VpDSVj3ancCtwtoFJdQkRqs+x5rQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786355043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pia9qcwDWHFbiRVmP1j5XSZyL4A3HBfRqe0yBhxM1CE=;
	b=T2va0ds1FFLMvrdMWUn05baeeACXMIq+ymQphqnZ7Vtz+tWrggcSjgEfRjsJFNNptI+1Ee
	MYXIMuyjM6k+/JCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V4ssd1WI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lW+Kvuc+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786355038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pia9qcwDWHFbiRVmP1j5XSZyL4A3HBfRqe0yBhxM1CE=;
	b=V4ssd1WIkHFTlyP9zUOkHBKvxABrWgGVBGl9Vux/5imfziMFO+y2bBvgXDBKe95vJvoBL2
	es/kfljeloFKSyqnRh8c0nmYesblBsTTH6N4F8qThmkffMBjJKA0cCE2ML0fXjn5zgVsqu
	WWFTUk5t2QatPaH2n1kZpINPE44mgHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786355038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pia9qcwDWHFbiRVmP1j5XSZyL4A3HBfRqe0yBhxM1CE=;
	b=lW+Kvuc+UJNfOomBYvy6lZrRkFPHkP5nZTXWMtCJoAtrVOOhh51MmswRnVdpvdkZHf+HNx
	W6lCghDIbCQs5oBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B93C8779B2;
	Mon, 10 Aug 2026 09:43:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jbZvKl6deWpcPwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 10 Aug 2026 09:43:58 +0000
Message-ID: <bd0e90f5-41e1-4114-bf07-1cc85a668187@suse.de>
Date: Mon, 10 Aug 2026 11:43:31 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit when
 building new ruleset
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <20260805171115.250749-1-pablo@netfilter.org>
 <20260805171115.250749-2-pablo@netfilter.org>
 <e57417f4-b586-400c-97ad-fce9f0b6d0aa@suse.de> <anR_NQJ_mJdAuOie@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <anR_NQJ_mJdAuOie@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: E080844CD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/6/26 4:35 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Thu, Aug 06, 2026 at 12:30:14PM +0200, Fernando Fernandez Mancera wrote:
>> On 8/5/26 7:11 PM, Pablo Neira Ayuso wrote:
>>> The rbtree set only builds the b-search array after the new ruleset has
>>> been exposed through set ops .commit.
>>>
>>> This is currently needed by pipapo because it purges the elements from
>>> the clone after the transactions are handled, therefore, pipapo still
>>> needs the delayed set ops .commit call after the transaction handling.
>>>
>>> Allow the rbtree to call .commit before the transaction handling which
>>> purges the stale elements from the frontend rbtree datastructure.
>>>
>>> Update rbtree .commit to skip deactivated and expired elements when
>>> building the new b-search array.
>>>
>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>> ---
>>> sashiko: there is a timestamp that prevents elements from expiring while
>>> handling the transaction.
>>>
>>> v2: - use NFT_GENMASK_ANY for GC scan, theoretically no new element in
>>>         this transaction can expire while handling the transaction but
>>>         let's just skip either new element or deactivated elements from
>>>         the GC scan.
>>>       - remove incorrect reset of previous rbe when performing GC scan.
>>>
>>>    net/netfilter/nf_tables_api.c  |  9 ++++++--
>>>    net/netfilter/nft_set_rbtree.c | 38 ++++++++++++++++++++++++++++------
>>>    2 files changed, 39 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>>> index 90a379533e08..a7006725c307 100644
>>> --- a/net/netfilter/nf_tables_api.c
>>> +++ b/net/netfilter/nf_tables_api.c
>>> @@ -10853,11 +10853,14 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
>>>    	}
>>>    }
>>> -static void nft_set_commit_update(struct nftables_pernet *nft_net)
>>> +static void nft_set_commit_update(struct nftables_pernet *nft_net, bool early_commit)
>>>    {
>>>    	struct nft_set *set, *next;
>>>    	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
>>> +		if (set->ops->abort_skip_removal && early_commit)
>>> +			continue;
>>> +
>>
>> Hi Pablo,
>>
>> wouldn't it be better to add the early_commit flag to set->ops? This way we
>> don't need to check abort_skip_removal flag.
>>
>> I could foresee problems in the future using the same flag for this skip..
>>
>> What about creating a nft_commit_phase enum:
>>
>> enum nft_commit_phase {
>> 	NFT_COMMIT_PHASE_EARLY,
>> 	NFT_COMMIT_PHASE_DELAYED,
>> };
>>
>> and then we can use it in nft_set_commit_update() as argument, something
>> like:
>>
>> static void nft_set_commit_update(struct nftables_pernet *nft_net,
>>                                    enum nft_commit_phase phase)
>>
>> This way, early_commit makes sense on set->ops..
>>
>> What do you think? I am trying to think in a way to make the code more
>> readable.
> 
> The (ab)use of ->abort_skip_removal is hack to address the reported
> regression with minimal changes.
> 
> I can add an .early_commit interface instead, but where I want to go
> is to move .commit before transaction handling, but pipapo needs to be
> revisited to make it. Because pipapo has the same issue reported here:
> 
> https://lore.kernel.org/netfilter-devel/589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com/
> 
> The update for pipapo would be targetted at the nf-next.
> 
> I can add a .early_commit, that would be cleaner and it is not a lot
> more code.
> 
> Eventually, .early_commit will just become .commit once pipapo becomes
> safe to be used before transaction handling.
> 

Sounds good to me, in essence I would like to avoid re-using a flag that 
isn't supposed to be used for that. In any case, if this is a temporary 
change it might be fine too..

Thanks!

