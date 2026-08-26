Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C4388878
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 10:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787739944; cv=none; b=MySxul3B2GZAvwTimi9T8fqqRyvQArQB3shRa8mJrTyDkzoqLuX3cSUUknzkZ5WPnEeHtwc5+qDj8I+JOzACyZ3ZGdaGWn6O26qdv1oZuA5mwDbaI8ohZw3nz/6qrOvaSAKYix22GoatmW0/3wLBQNPpXsjlfEDa+rTvWqeBix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787739944; c=relaxed/simple;
	bh=yOPBs5r9Xlny9bU0wtMSm9Qnue7FFfzqfvX7TvJkB5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gtiykkTqvKAQhtdNdoakYeOi7/7Upov9hMPYEh41GU0F9pQa/g3XJe1QxACTMCtncV8jlW1gJ/PCO97AaMu4cjuwzK/AmyE89AP9gQYa8WsppaXXLHsWN+buESMYpwtDvfuWfZTLe4ZyT67mJ4L8zWWoI/VQ3blik94/TVZnHr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YI/mZ4Bi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fcFj+7Y/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TgMYuuxp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o0w/Zrlq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YI/mZ4Bi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fcFj+7Y/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TgMYuuxp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o0w/Zrlq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A4BB11F7F8;
	Wed, 26 Aug 2026 10:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787739936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Kd0AXOWe92Fl7TAFzkGO7aqjGTdSSh6SL61iwtKKtg=;
	b=YI/mZ4Bi7WyW6jApfaAcvaYfZM95jBcuFMGL23S/PYutmVCFG/MR9Rvx7xmge6damAqm03
	NODtou/FFA/7Hxk6ijJ+XnJITzdIYVO4Cw4/WHO8Qs9DDnH9GiIFDYiM4zo8o6m5ceGLPe
	pNtDZBqC6C8NcRF7GEhvfRiI8qTQQaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787739936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Kd0AXOWe92Fl7TAFzkGO7aqjGTdSSh6SL61iwtKKtg=;
	b=fcFj+7Y/CGvGMak6D1+AEdyUqPBScguufhWZjKD6pG4m2Et46C+XR70AK06MtuA0qs0VRR
	RXmEAQjyKs7Z1jCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TgMYuuxp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="o0w/Zrlq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787739932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Kd0AXOWe92Fl7TAFzkGO7aqjGTdSSh6SL61iwtKKtg=;
	b=TgMYuuxpsAc4yga7u2M46+lDIfs8RXAxJKBdTL80jYNnLApUQ4G91xpblBPmVJpLY1Bcl7
	ubxkUeg4AzbX3hMVdaF/pfSmAYjLLzCmITEGCAETUZISld+ObKxL8jtWVkukn+QlHluEYd
	ifMaPqNA+w47eBkOWYE32CPpRNxFKH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787739932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Kd0AXOWe92Fl7TAFzkGO7aqjGTdSSh6SL61iwtKKtg=;
	b=o0w/Zrlqlmb7Fg4gmP5PC71ZWL2jx9PfNWvnGZuvzkWmY7PFaJFk485DR2+m79nP3K++3a
	CmEBifVZnayFNPCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45DB313354;
	Wed, 26 Aug 2026 10:25:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mWClDRy/jmoZKgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 26 Aug 2026 10:25:32 +0000
Message-ID: <93f950f7-4ea1-4975-aceb-d5b836c9d626@suse.de>
Date: Wed, 26 Aug 2026 12:25:09 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_tables: fix device name and prefix match
 in hook lookup
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 coreteam@netfilter.org, Wei Fang <void0red@gmail.com>
References: <20260818101825.8213-1-fmancera@suse.de>
 <ao6-eoTsgfs2cyc5@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ao6-eoTsgfs2cyc5@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,strlen.de,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: A4BB11F7F8
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action



On 8/26/26 12:22 PM, Phil Sutter wrote:
> Hi Fernando,
> 
> On Tue, Aug 18, 2026 at 12:18:25PM +0200, Fernando Fernandez Mancera wrote:
>> Currently, a netdev chain or flowtable hooked to a device prefix can be
>> unintentionally deleted or updated by a control-plane request targeting
>> an exact device name or even a shorter one due to the usage of min() to
>> calculate the length to match.
>>
>> Fix this by making sure an exact device match never matches a prefix and
>> that both the target and the candidate have the same length.
>>
>> Reported-by: Wei Fang <void0red@gmail.com>
>> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
>> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>>   net/netfilter/nf_tables_api.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index af357f6c5070..e2b18c4722fc 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -1973,7 +1973,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>>   	return -ENOSPC;
>>   }
>>   
>> -static bool hook_is_prefix(struct nft_hook *hook)
>> +static bool hook_is_prefix(const struct nft_hook *hook)
>>   {
>>   	return strlen(hook->ifname) >= hook->ifnamelen;
>>   }
>> @@ -2440,8 +2440,11 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>>   	struct nft_hook *hook;
>>   
>>   	list_for_each_entry(hook, hook_list, list) {
>> -		if (!strncmp(hook->ifname, this->ifname,
>> -			     min(hook->ifnamelen, this->ifnamelen))) {
>> +		if (hook_is_prefix(hook) != hook_is_prefix(this))
>> +			continue;
>> +		if (hook->ifnamelen != this->ifnamelen)
>> +			continue;
>> +		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
>>   			if (hook->flags & NFT_HOOK_REMOVE)
>>   				continue;
> 
> I think this fix introduces another issue, when adding another prefix to
> a flowtable/chain which partially matches an existing prefix. E.g.,
> adding "eth*" with "eth0*" present must be rejected since we otherwise
> end up trying to register a new interface "eth007" to two hooks at the
> same time.
> 
> Maybe we need a "bool exact" flag which turns the min() intoa a max()?
> (untested ;)
> 
> Cheers, Phil

Hi Phil, you are right here. I sent a v2 2 days ago changing the 
behavior of delete operation only. What do you think?

https://lore.kernel.org/netfilter-devel/20260824092805.4940-1-fmancera@suse.de/

Thanks, Fernando.
